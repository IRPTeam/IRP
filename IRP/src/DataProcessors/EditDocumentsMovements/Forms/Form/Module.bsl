// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If ValueIsFilled(Parameters.DocRef) Then
	 	Object.DocumentRef = Parameters.DocRef;
	 	MovementsEdit = CommonFunctionsServer.GetRefAttribute(Object.DocumentRef, "ManualMovementsEdit"); //Boolean
		ManualMovementsEdit =  Boolean(MovementsEdit);
	EndIf;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	If Not ValueIsFilled(Object.DocumentRef) Then
		Return;
	EndIf;
	
	FillObjectMovements();
	SetEnabledToRegisterPages(ManualMovementsEdit);
	MovementAnalysisAsynh();	
	
EndProcedure

&AtClient
Procedure DocumentRefOnChange(Item)
	
	FillObjectMovements();
	
EndProcedure

&AtServer
Procedure ClearAttributes()
	
	AttributesArray = New Array; //Array of FormTable
	AttributesArrayDelete = New Array; //Array of String	
	
	For Each Row In Object.Movements Do
		If Items.Find(Row.RegisterName) <> Undefined Then
			AttributesArray.Add(Items[Row.RegisterName]);
			
			AttributesArrayDelete.Add(Items[Row.RegisterName].Name);
		EndIf;	
	EndDo;
	ChangeAttributes(New Array, AttributesArrayDelete);
		
	For Each ChildItem In Items.Registers.ChildItems Do
		AttributesArray.Add(ChildItem);
	EndDo;
			
	For Each ArrayItem In AttributesArray Do
		Items.Delete(ArrayItem);	
	EndDo;	
	
	Object.Movements.Clear();
	
EndProcedure	

&AtServer
Procedure FillObjectMovements()
	
	ClearAttributes();
	
	If Not ValueIsFilled(Object.DocumentRef) Then
		Return;
	EndIf;

	DocumentMeta = Object.DocumentRef.Metadata();

	For Each ItemMovement In DocumentMeta.RegisterRecords Do

		RegisterName = ItemMovement.Name;

		MovementsValueTable = PostingServer.GetDocumentMovementsByRegisterName(Object.DocumentRef, ItemMovement.FullName());

		MovementCount = MovementsValueTable.Count();

		NewRow = Object.Movements.Add();
		NewRow.RegisterName = RegisterName;
		NewRow.MovementsCount = MovementCount;
		NewRow.ValueTableStorage = ValueToStringInternal(MovementsValueTable);
	EndDo;
	
	Object.Movements.Sort("RegisterName");
	
	For Each Row In Object.Movements Do
		If Row.MovementsCount > 0 Then
			
			ValueTableStorage = ValueFromStringInternal(Row.ValueTableStorage);
			If TypeOf(ValueTableStorage) = Type("ValueTable") Then
				MovementsValueTable = ValueTableStorage;
			
				AddPageForMovement(Row.RegisterName, Row.MovementsCount);
				AddRegisterTableToForm(Row.RegisterName, MovementsValueTable);
			EndIf;	
		EndIf;
	EndDo;
	
EndProcedure

// Register table on change.
// 
// Parameters:
//  Item - FormTable - Item
&AtClient
Procedure RegisterTableOnChange(Item)
	
	Parent = Item.Parent; //FormGroup
	Parent.Picture = PictureLib.AppearanceExclamationMark;
	
EndProcedure

&AtServer
Procedure AddPageForMovement(RegisterName, RecordsCount)

	PageName = "Register_" + RegisterName;
	
	NewPage = Items.Add(PageName, Type("FormGroup"), Items.Registers);
	NewPage.Type	= FormGroupType.Page;
	NewPage.Title	= StrTemplate("%1 (%2)", RegisterName, RecordsCount);
	
EndProcedure

// Add register table to form.
// 
// Parameters:
//  TableName - String
//  MovementsValueTable - ValueTable
&AtServer
Procedure AddRegisterTableToForm(TableName, MovementsValueTable)
	
	PageName = "Register_" + TableName;

	CurrentMovementStructure = CommonFunctionsServer.BlankFormTableCreationStructure();
	CurrentMovementStructure.TableName				= TableName;
	CurrentMovementStructure.ValueTable				= MovementsValueTable;
	CurrentMovementStructure.Form					= ThisObject;
	CurrentMovementStructure.CreateTableOnForm		= True;
	CurrentMovementStructure.ParentName 			= PageName;
	CurrentMovementStructure.OnChangeProcedureName	= "RegisterTableOnChange";
	
	CommonFunctionsServer.CreateFormTable(CurrentMovementStructure);
	
	Table = ThisObject[TableName]; //FormDataCollection
	Table.Load(MovementsValueTable);

EndProcedure

&AtClient
Async Procedure ManualMovementsEditOnChange(Item)
	
	If CommonFunctionsServer.GetRefAttribute(Object.DocumentRef, "ManualMovementsEdit") Then
		
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_030, QuestionDialogMode.YesNo,, DialogReturnCode.Yes); //DialogReturnCode
		
		If Answer = DialogReturnCode.Yes Then 
			SetDefaultMovementsToDocument();
			SetEnabledToRegisterPages(ManualMovementsEdit);
		Else
			ManualMovementsEdit = True;	
		EndIf;
		
	Else
		SetEnabledToRegisterPages(ManualMovementsEdit);
	EndIf;
	
EndProcedure

// Set enabled to register pages.
// 
// Parameters:
//  ManualMovementsEditValue - Boolean 
&AtClient
Procedure SetEnabledToRegisterPages(ManualMovementsEditValue)
	
	Items.Registers.ReadOnly = Not ManualMovementsEditValue;
	Items.FormWriteMovements.Enabled = ManualMovementsEditValue;
	
EndProcedure

&AtClient
Procedure WriteMovements(Command)
	
	Posted = CommonFunctionsServer.GetRefAttribute(Object.DocumentRef, "Posted");
	If Not Posted Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_146);
		Return;
	EndIf;
	
	Cancel = False;
	WriteMovementsOnServer(Cancel);
	If Not Cancel Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_037);
	EndIf;
	
EndProcedure

&AtClient
Procedure RereadPostingData(Command)
	
	FillObjectMovements();
	SetEnabledToRegisterPages(ManualMovementsEdit);
	MovementAnalysisAtServer();
	
EndProcedure

&AtServer
Procedure WriteMovementsOnServer(Cancel)
	
	BeginTransaction();
	Try
		
		DocumentObject = Object.DocumentRef.GetObject();
		
		For Each Row In Object.Movements Do
			If Row.MovementsCount > 0 Then
				Table = ThisObject[Row.RegisterName]; //FormDataCollection
				VT_Movements = Table.Unload();
				
				RegisterRecords = DocumentObject.RegisterRecords[Row.RegisterName];
				RegisterRecords.DataExchange.Load = True;
				RegisterRecords.Load(VT_Movements);
				RegisterRecords.Write();
				
			EndIf;
		EndDo;
		
		DocumentObject.ManualMovementsEdit	= True;
		DocumentObject.DataExchange.Load	= True;
		DocumentObject.Write();
		
		CommitTransaction();
		
	Except
		RollbackTransaction();
		Cancel = True;
		GetUserMessages(ErrorDescription());
	EndTry;
	
EndProcedure

&AtClient
Procedure MovementAnalysis(Command)
	MovementAnalysisAsynh();		
EndProcedure

&AtClient
Async Procedure MovementAnalysisAsynh()
	
	IsDifferenceInMovements = False;
	MovementAnalysisAtServer(IsDifferenceInMovements);
	
	If ManualMovementsEdit And Not IsDifferenceInMovements Then
		
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_029, QuestionDialogMode.YesNo,, DialogReturnCode.Yes); //DialogReturnCode
		
		If Answer = DialogReturnCode.Yes Then 
			SetManualMovementsEditInDocument(False);
		EndIf;
	
	EndIf;	
	
EndProcedure	

&AtServer
Procedure SetDefaultMovementsToDocument()

	Array = New Array; //Array of DocumentRefDocumentName
	Array.Add(Object.DocumentRef);
	
	ChechResult = PostingServer.CheckDocumentArray(Array);
	If ChechResult.Count() > 0 Then
		DifferenceStructure = ChechResult[0];
		
		For Each RegInfo In DifferenceStructure.RegInfo Do
			
			DotPosition = StrFind(RegInfo.RegName, ".");
			RegName = Mid(RegInfo.RegName, DotPosition+1);
			
			TableName = RegName;
			Table = ThisObject[RegName]; //FormDataCollection
			Table.Load(RegInfo.NewPostingData);
			
		EndDo;
		
		Cancel = False;
		WriteMovementsOnServer(Cancel);
		If Not Cancel Then
			
			SetManualMovementsEditInDocument(False);
						
			CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_037);
		Else
			ManualMovementsEdit = True;
		EndIf;
		
		MovementAnalysisAtServer();
		
	EndIf;
	
EndProcedure

&AtServer
Procedure SetManualMovementsEditInDocument(DocumentManualMovementsEdit)
	
	DocObject = Object.DocumentRef.GetObject();
	DocObject.DataExchange.Load		= True;
	DocObject.ManualMovementsEdit	= DocumentManualMovementsEdit;
	DocObject.Write(DocumentWriteMode.Write);
	
	ManualMovementsEdit = DocumentManualMovementsEdit;
	
EndProcedure

&AtServer
Procedure MovementAnalysisAtServer(IsDifferenceInMovements = False)
	
	RegEditNames = New Array;//Array of String
	
	Array = New Array; //Array of DocumentRefDocumentName
	Array.Add(Object.DocumentRef);
	ChechResult = PostingServer.CheckDocumentArray(Array);
	If ChechResult.Count() > 0 Then
		IsDifferenceInMovements = True;
		For Each ArrayItemStructure In ChechResult Do
			If Not ArrayItemStructure.Ref = Object.DocumentRef Then
				Continue;
			EndIf;	
			For Each RegInfo In ArrayItemStructure.RegInfo Do
				DotPosition = StrFind(RegInfo.RegName, ".");
				RegEditNames.Add(Mid(RegInfo.RegName, DotPosition+1));
			EndDo;			
		EndDo;
	EndIf;
	
	SetPicturesForPages(RegEditNames);
	
EndProcedure

&AtServer
Procedure SetPicturesForPages(RegEditNames)

	For Each Page In Items.Registers.ChildItems Do		
		RegisterName = StrReplace(Page.Name, "Register_", "");
		
		If RegEditNames.Find(RegisterName) <> Undefined Then
			Page.Picture = PictureLib.AppearanceExclamationMark;
		Else	
			Page.Picture = PictureLib.AppearanceCheckBox;
		EndIf;		
	EndDo;
	
EndProcedure
