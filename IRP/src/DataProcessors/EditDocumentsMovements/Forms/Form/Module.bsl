&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Parameters.Property("DocRef") Then
		Object.DocumentRef = Parameters.DocRef;
		ManualMovementsEdit = CommonFunctionsServer.GetAttributesFromRef(Object.DocumentRef, "ManualMovementsEdit").ManualMovementsEdit;
	EndIf;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	If Not ValueIsFilled(Object.DocumentRef) Then
		Return;
	EndIf;
	
	FillObjectMovements();
	SetEnabledToRegisterPages();
	MovementAnalysisAtServer();
	
EndProcedure

&AtClient
Procedure DocumentRefOnChange(Item)
	
	FillObjectMovements();
	
EndProcedure

&AtServer
Procedure ClearAttributes()
	
	AttributesArray = New Array;
	AttributesArrayDelete = New Array;	
	
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
	
	If Not ValueIsFilled(Object.DocumentRef) Then
		Return;
	EndIf;

	ClearAttributes();	

	DocumentObject = Object.DocumentRef.GetObject();
	DocumentMeta = Object.DocumentRef.Metadata();

	Counter = 0;
	For Each ItemMovement In DocumentMeta.RegisterRecords Do

		RegisterName = ItemMovement.Name;

		MovementsValue = DocumentObject.RegisterRecords[RegisterName];
		MovementsValue.Read();

		MovementsValueTable = MovementsValue.Unload();

		MovementCount = MovementsValue.Count();

		NewRow = Object.Movements.Add();
		NewRow.RegisterName = RegisterName;
		NewRow.MovementsCount = MovementCount;
	EndDo;
	
	Object.Movements.Sort("RegisterName");
	
	For Each Row In Object.Movements Do
		If Row.MovementsCount > 0 Then
			
			MovementsValue = DocumentObject.RegisterRecords[Row.RegisterName];
			MovementsValue.Read();
			
			MovementsValueTable = MovementsValue.Unload();
			
			AddPageForMovement(Row.RegisterName, Row.MovementsCount);
			AddRegisterTableToForm(Row.RegisterName, MovementsValueTable);
		EndIf;
	EndDo;
	
EndProcedure

&AtClient
Procedure RegisterTableOnChange(Item)
	
	Item.Parent.Picture = PictureLib.AppearanceExclamationMark;
	
EndProcedure

&AtServer
Procedure AddPageForMovement(RegisterName, RecordsCount)

	PageName = "Register_" + RegisterName;
	
	NewPage = Items.Add(PageName, Type("FormGroup"), Items.Registers);
	NewPage.Type	= FormGroupType.Page;
	NewPage.Title	= StrTemplate("%1 (%2)", RegisterName, RecordsCount);
	
EndProcedure

&AtServer
Procedure AddRegisterTableToForm(TableName, MovementsValueTable)
	
	PageName = "Register_" + TableName;

	CurrentMovementStructure = CommonFunctionsServer.BlankFormTableCreationStructure();
	CurrentMovementStructure.TableName				= TableName;
	CurrentMovementStructure.ValueTable				= MovementsValueTable;
	CurrentMovementStructure.Form					= ThisForm;
	CurrentMovementStructure.CreateTableOnForm		= True;
	CurrentMovementStructure.ParentName 			= PageName;
	CurrentMovementStructure.OnChangeProcedureName	= "RegisterTableOnChange";
	
	CommonFunctionsServer.CreateFormTable(CurrentMovementStructure);
	
	ThisObject[TableName].Load(MovementsValueTable);

EndProcedure

&AtClient
Procedure ManualMovementsEditOnChange(Item)
	
	If GetAttributesFromRef(Object.DocumentRef, "ManualMovementsEdit").ManualMovementsEdit Then
		QuestionToUserNotify = New NotifyDescription("RestoreDefaultMovementsNotify", ThisObject, New Structure);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_030, QuestionDialogMode.YesNo);
	Else
		SetEnabledToRegisterPages();
	EndIf;
	
EndProcedure

&AtServer
Function GetAttributesFromRef(Ref, Attribute)
	
	Return CommonFunctionsServer.GetAttributesFromRef(Ref, Attribute);
	
EndFunction

&AtClient
Procedure SetEnabledToRegisterPages()
	
	Items.Registers.ReadOnly 			= Not ManualMovementsEdit;
	Items.FormWriteMovements.Enabled	= ManualMovementsEdit;
	
EndProcedure

&AtClient
Procedure WriteMovements(Command)
	
	Posted = CommonFunctionsServer.GetAttributesFromRef(Object.DocumentRef, "Posted").Posted;
	If Not Posted Then
		TextMessage = R().Error_146;
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage);
		Return;
	EndIf;
	
	Cancel = False;
	WriteMovementsOnServer(Cancel);
	If Not Cancel Then
		TextMessage = R().InfoMessage_037;
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage);
	EndIf;
	
EndProcedure

&AtClient
Procedure RereadData(Command)
	
	FillObjectMovements();
	SetEnabledToRegisterPages();
	MovementAnalysisAtServer();
	
EndProcedure

&AtServer
Procedure WriteMovementsOnServer(Cancel)
	
	BeginTransaction();
	Try
		
		DocumentObject = Object.DocumentRef.GetObject();
		
		For Each Row In Object.Movements Do
			If Row.MovementsCount > 0 Then
				VT_Movements = ThisForm[Row.RegisterName].Unload();
				
				RegisterRecords = DocumentObject.RegisterRecords[Row.RegisterName];
				RegisterRecords.Read();
				RegisterRecords.DataExchange.Load = True;
				RegisterRecords.Clear();
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
		
	IsDifferenceInMovements = False;
	MovementAnalysisAtServer(IsDifferenceInMovements);
	
	If ManualMovementsEdit And Not IsDifferenceInMovements Then
		
		QuestionToUserNotify = New NotifyDescription("UncheckManualMovementsEditNotify", ThisObject, New Structure);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_029, QuestionDialogMode.YesNo);

	EndIf;
		
EndProcedure

&AtClient
Procedure UncheckManualMovementsEditNotify(Result, AdditionalParameters) Export
	
	If Not Result = DialogReturnCode.Yes Then
		Return;
	EndIf;
	SetManualMovementsEditInDocument(False);
	
EndProcedure

&AtClient
Procedure RestoreDefaultMovementsNotify(Result, AdditionalParameters) Export
	
	If Not Result = DialogReturnCode.Yes Then
		ManualMovementsEdit = True;
		Return;
	EndIf;
	
	SetDefaultMovementsToDocument();
	
EndProcedure

&AtServer
Procedure SetDefaultMovementsToDocument()

	Array = New Array;
	Array.Add(Object.DocumentRef);
	
	ChechResult = PostingServer.CheckDocumentArray(Array);
	If ChechResult.Count() > 0 Then
		DifferenceStructure = ChechResult[0];
		
		For Each RegInfo In DifferenceStructure.RegInfo Do
			
			DotPosition = StrFind(RegInfo.RegName, ".");
			RegName = Mid(RegInfo.RegName, DotPosition+1);
			
			TableName = RegName;
			ThisObject[RegName].Load(RegInfo.NewPostingData);
			
		EndDo;
		
		Cancel = False;
		WriteMovementsOnServer(Cancel);
		If Not Cancel Then
			
			SetManualMovementsEditInDocument(False);
			TextMessage = R().InfoMessage_037;
			
			CommonFunctionsClientServer.ShowUsersMessage(TextMessage);
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
	
	RegEditNames = New Array;
	
	Array = New Array;
	Array.Add(Object.DocumentRef);
	ChechResult = PostingServer.CheckDocumentArray(Array);
	If ChechResult.Count() > 0 Then
		IsDifferenceInMovements = True;
		For Each ArrayItemStructure In ChechResult Do
			If ArrayItemStructure.Ref = Object.DocumentRef Then
				For Each RegInfo In ArrayItemStructure.RegInfo Do
					Message = StrTemplate(R().Error_145, RegInfo.RegName);
					//CommonFunctionsClientServer.ShowUsersMessage(Message);
					
					DotPosition = StrFind(RegInfo.RegName, ".");
					RegEditNames.Add(Mid(RegInfo.RegName, DotPosition+1));
				EndDo;
			EndIf;
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
