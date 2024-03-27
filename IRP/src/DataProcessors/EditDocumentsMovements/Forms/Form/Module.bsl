&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Object.DocumentRef = Documents.SalesInvoice.GetRef(New UUID("41CF0805-70B4-11ED-B78C-E657999BD693"));
	
	CommonFunctionsServer.GetAttributesFromRef(Object.DocumentRef, "ManualMovementsEdit");
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	FillObjectMovements();
	SetEnabledToRegisterPages();
	
EndProcedure

&AtClient
Procedure DocumentRefOnChange(Item)
	
	FillObjectMovements();
	
EndProcedure

&AtServer
Procedure ClearAttributes()
	
	AttributesArray = New Array;
	
	For Each Row In Object.Movements Do
		If Items.Find(Row.RegisterName) <> Undefined Then
			AttributesArray.Add(Items[Row.RegisterName]);
		EndIf;	
	EndDo;
		
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
			
			AddPageForMovement(Row.RegisterName);
			AddRegisterTableToForm(Row.RegisterName, MovementsValueTable);
		EndIf;
	EndDo;
	
EndProcedure

&AtServer
Procedure AddPageForMovement(RegisterName)

	PageName = "Register_" + RegisterName;

	NewPage = Items.Add(PageName, Type("FormGroup"), Items.Registers);
	NewPage.Type = FormGroupType.Page;
	NewPage.Title = RegisterName;

	DecorationName = RegisterName + "Decoration";
	
	DecorationItem = Items.Add(DecorationName, Type("FormDecoration"), Items[PageName]);
	DecorationItem.Type		= FormDecorationType.Label;
	DecorationItem.Title	= RegisterName;

EndProcedure
&AtServer
Procedure AddRegisterTableToForm(TableName, MovementsValueTable)
	
	PageName = "Register_" + TableName;

	CurrentMovementStructure = CommonFunctionsServer.BlankFormTableCreationStructure();
	CurrentMovementStructure.TableName			= TableName;
	CurrentMovementStructure.ValueTable			= MovementsValueTable;
	CurrentMovementStructure.Form				= ThisForm;
	CurrentMovementStructure.CreateTableOnForm	= True;
	CurrentMovementStructure.ParentName 		= PageName;
	
	CommonFunctionsServer.CreateFormTable(CurrentMovementStructure);
	
	ThisObject[TableName].Load(MovementsValueTable);

EndProcedure

&AtClient
Procedure ManualMovementsEditOnChange(Item)
	
	SetEnabledToRegisterPages();
	
EndProcedure

&AtClient
Procedure SetEnabledToRegisterPages()
	
	Items.Registers.ReadOnly 			= Not ManualMovementsEdit;
	Items.FormWriteMovements.Enabled	= ManualMovementsEdit;
	
EndProcedure

&AtClient
Procedure WriteMovements(Command)
	
	Cancel = False;
	WriteMovementsOnServer(Cancel);
	If Not Cancel Then
		TextMessage = "Movements successfully recorded";
		CommonFunctionsClientServer.ShowUsersMessage(TextMessage);
	EndIf;
	
EndProcedure

&AtClient
Procedure RereadData(Command)
	FillObjectMovements();	
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
		Cancel = True;
		If TransactionActive() Then
			RollbackTransaction();
			GetUserMessages(ErrorDescription());
		EndIf;
	EndTry;
	
EndProcedure
