// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If ValueIsFilled(Parameters.DocRef) Then
	 	Object.DocumentRef = Parameters.DocRef;
	 	MovementsEdit = CommonFunctionsServer.GetRefAttribute(Object.DocumentRef, "ManualMovementsEdit"); // Boolean
		ManualMovementsEdit =  Boolean(MovementsEdit);
	EndIf;
	///
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	If Not ValueIsFilled(Object.DocumentRef) Then
		Return;
	EndIf;
	
	FillObjectMovements();
	SetEnabledToRegisterPages(ManualMovementsEdit);
	MovementAnalysisAsync();	
	
EndProcedure

&AtClient
Procedure DocumentRefOnChange(Item)
	
	FillObjectMovements();
	
EndProcedure

&AtServer
Procedure ClearAttributes()
	
	AttributesArray = New Array; // Array of FormTable
	AttributesArrayDelete = New Array; // Array of String	
	
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
	StructureTables = New Structure();
	
	For Each ItemMovement In DocumentMeta.RegisterRecords Do

		RegisterName = ItemMovement.Name;

		MovementsValueTable = PostingServer.GetDocumentMovementsByRegisterName(
		Object.DocumentRef,
		ItemMovement.FullName()); // ValueTable

		MovementCount = MovementsValueTable.Count();

		NewRow = Object.Movements.Add();
		NewRow.RegisterName = RegisterName;
		NewRow.MovementsCount = MovementCount;
		
		StructureTables.Insert(RegisterName, MovementsValueTable);
						
	EndDo;
	
	Object.Movements.Sort("RegisterName");
	
	For Each Row In Object.Movements Do
					
		ValueTable = StructureTables[Row.RegisterName]; // ValueTable
		
		AddPageForMovement(Row.RegisterName, Row.MovementsCount);
		AddRegisterTableToForm(Row.RegisterName, ValueTable);
				
	EndDo;
	
EndProcedure

// Register table on change.
// 
// Parameters:
//  Item - FormTable - Item
//@skip-check module-unused-method
&AtClient
Procedure RegisterTableOnChange(Item)
	
	Parent = Item.Parent; // FormGroup
	//@skip-check property-return-type
	Parent.Picture = PictureLib.AppearanceExclamationMark;
	
EndProcedure

&AtServer
Procedure AddPageForMovement(RegisterName, RecordsCount)

	PageName = "Register_" + RegisterName;
	
	NewPage = Items.Add(PageName, Type("FormGroup"), Items.Registers);
	NewPage.Type	= FormGroupType.Page;
	NewPage.Title	= StrTemplate("%1 (%2)", RegisterName, RecordsCount);
	If RecordsCount = 0 Then
		NewPage.Visible = False;
	EndIf;
	
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
	
	Table = ThisObject[TableName]; // FormDataCollection
	Table.Load(MovementsValueTable);

EndProcedure

&AtClient
Async Procedure ManualMovementsEditOnChange(Item)
	
	If CommonFunctionsServer.GetRefAttribute(Object.DocumentRef, "ManualMovementsEdit") Then
		
		//@skip-check property-return-type
		QuestionText = R().QuestionToUser_030; //String
		Answer = Await DoQueryBoxAsync(QuestionText, QuestionDialogMode.YesNo, , DialogReturnCode.Yes); // DialogReturnCode
		
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
Procedure SetEnabledToRegisterPages(Val ManualMovementsEditValue)
	
	Items.Registers.ReadOnly = Not ManualMovementsEditValue;
	Items.GroupWriteMovemementsMenu.Enabled = ManualMovementsEditValue;
	
EndProcedure

&AtClient
Procedure WriteMovementsWithRegisterSelfControl(Command)
	
	RegisterSelfControl = True;
	Cancel = False;
	WriteMovementsOnServer(Cancel, RegisterSelfControl);
	
EndProcedure

&AtClient
Procedure WriteMovements(Command)
	
	Cancel = False;
	WriteMovementsOnServer(Cancel);
	
EndProcedure

&AtClient
Procedure RereadPostingData(Command)
	
	FillObjectMovements();
	SetEnabledToRegisterPages(ManualMovementsEdit);
	MovementAnalysisAtServer();
	
EndProcedure

&AtServer
Procedure WriteMovementsOnServer(Cancel, RegisterSelfControl = False)
	
	Posted = CommonFunctionsServer.GetRefAttribute(Object.DocumentRef, "Posted");
	If Not Posted Then
		//@skip-check property-return-type
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_146);
		Return;
	EndIf;
	
	BeginTransaction();
	Try
		
		DocumentObject = Object.DocumentRef.GetObject();
		
		For Each Row In Object.Movements Do
			Table = ThisObject[Row.RegisterName]; // FormDataCollection
			VT_Movements = Table.Unload();
			
			RegisterRecords = DocumentObject.RegisterRecords[Row.RegisterName];
			If DoNotControlWriteRules = True Then
				RegisterRecords.DataExchange.Load = True;
			EndIf;
			
			IsSelfControlled = False;
			If RegisterSelfControl Then
				If Metadata.AccumulationRegisters.Contains(RegisterRecords.Metadata()) Then
					IsSelfControlled = True;
					RegisterName = Row.RegisterName;
					//@skip-check dynamic-access-method-not-found
					AccumulationRegisters[RegisterName].AdditionalDataFilling(VT_Movements);
				EndIf;
			EndIf;
			RegisterRecords.Load(VT_Movements);
			RegisterRecords.Write();
			
			If IsSelfControlled Then
				Table.Load(VT_Movements);
			EndIf;
		EndDo;
		
		DocumentObject.ManualMovementsEdit	= True;
		DocumentObject.DataExchange.Load	= True;
		DocumentObject.Write();
		
		CommitTransaction();
		
	Except
		RollbackTransaction();
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(
		ErrorProcessing.BriefErrorDescription(ErrorInfo()));
	EndTry;
	
	If Not Cancel Then
		//@skip-check property-return-type
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_039);
	EndIf;
	
EndProcedure

&AtClient
Procedure MovementAnalysis(Command)
	MovementAnalysisAsync();		
EndProcedure

&AtClient
Async Procedure MovementAnalysisAsync()
	
	IsDifferenceInMovements = False;
	MovementAnalysisAtServer(IsDifferenceInMovements);
	
	If ManualMovementsEdit And Not IsDifferenceInMovements Then
		
		//@skip-check invocation-parameter-type-intersect
		//@skip-check property-return-type
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_029, QuestionDialogMode.YesNo, , DialogReturnCode.Yes); // DialogReturnCode
		
		If Answer = DialogReturnCode.Yes Then 
			SetManualMovementsEditInDocument(False);
			SetEnabledToRegisterPages(ManualMovementsEdit);
		EndIf;
	
	EndIf;	
	
EndProcedure	

&AtServer
Procedure SetDefaultMovementsToDocument()

	Array = New Array; // Array of DocumentRefDocumentName
	Array.Add(Object.DocumentRef);
	
	CheckResult = PostingServer.CheckDocumentArray(Array);
	If CheckResult.Count() > 0 Then
		DifferenceStructure = CheckResult[0];
		
		For Each RegInfo In DifferenceStructure.RegInfo Do
			
			DotPosition = StrFind(RegInfo.RegName, ".");
			RegName = Mid(RegInfo.RegName, DotPosition + 1);
			
			//@skip-check property-return-type
			NewPostingData = RegInfo.NewPostingData; // ValueTable
			
			Table = ThisObject[RegName]; // FormDataCollection
			Table.Load(NewPostingData);
			
		EndDo;
		
		Cancel = False;
		WriteMovementsOnServer(Cancel);
		If Not Cancel Then
			
			SetManualMovementsEditInDocument(False);
						
			//@skip-check property-return-type
			CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_039);
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
	
	RegEditNames = New Array;// Array of String
	
	Array = New Array; // Array of DocumentRefDocumentName
	Array.Add(Object.DocumentRef);
	CheckResult = PostingServer.CheckDocumentArray(Array);
	If CheckResult.Count() > 0 Then
		IsDifferenceInMovements = True;
		ArrayItemStructure = CheckResult[0];
		
		For Each RegInfo In ArrayItemStructure.RegInfo Do
			DotPosition = StrFind(RegInfo.RegName, ".");
			RegEditNames.Add(Mid(RegInfo.RegName, DotPosition + 1));
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

