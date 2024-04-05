
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	For Each Level1 In ThisObject.OperationsTree.GetItems() Do
		For Each Level2 In Level1.GetItems() Do
			For Each Level3 In Level2.GetItems() Do
				If Level3.Use And Not ValueIsFilled(Level3.Period) Then
					Cancel = True;
					CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_111, Level1.Document, Level3.AccountingOperation));
				EndIf;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	For Each Level1 In ThisObject.OperationsTree.GetItems() Do
		For Each Level2 In Level1.GetItems() Do
			For Each Level3 In Level2.GetItems() Do
				RecordSet = InformationRegisters.LedgerTypeOperations.CreateRecordSet();
				RecordSet.Filter.LedgerType.Set(Object.Ref);
				RecordSet.Filter.AccountingOperation.Set(Level3.AccountingOperation);
				
				If ValueIsFilled(Level3.Period) Then
					NewRecord = RecordSet.Add();
					NewRecord.LedgerType = Object.Ref;
					NewRecord.AccountingOperation = Level3.AccountingOperation;
					NewRecord.Period = Level3.Period;
					NewRecord.Use = Level3.Use;
				Else
					RecordSet.Clear();
				EndIf;
				
				RecordSet.Write();
			EndDo;
		EndDo;
	EndDo;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	AttachIdleHandler("ExpandAllTrees", 1, True);
EndProcedure

&AtClient
Procedure ExpandAllTrees() Export
	CommonFormActions.ExpandTree(Items.OperationsTree, ThisObject.OperationsTree.GetItems());
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure OperationsTreePeriodOnChange(Item)
	CurrentData = Items.OperationsTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.Use = ValueIsFilled(CurrentData.Period);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	// Operations tree
	Form.OperationsTree.GetItems().Clear();
	ArrayOfAccountingOperations = GetAccountingOperations(Object.Ref);
	For Each Level1 In ArrayOfAccountingOperations Do
		NewLevel1 = Form.OperationsTree.GetItems().Add();
		FillPropertyValues(NewLevel1, Level1);
		
		For Each Level2 In Level1.Rows Do
			NewLevel2 = NewLevel1.GetItems().Add();
			FillPropertyValues(NewLevel2, Level2);
			
			For Each Level3 In Level2.Rows Do
				NewLevel3 = NewLevel2.GetItems().Add();
				FillPropertyValues(NewLevel3, Level3);
			EndDo;
		EndDo;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetAccountingOperations(LedgerTypeRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypeOperationsSliceLast.Period AS Period,
	|	LedgerTypeOperationsSliceLast.AccountingOperation AS AccountingOperation,
	|	LedgerTypeOperationsSliceLast.Use AS Use
	|INTO tmp
	|FROM
	|	InformationRegister.LedgerTypeOperations.SliceLast(, LedgerType = &LedgerType) AS LedgerTypeOperationsSliceLast
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AccountingOperations.Parent AS Document,
	|	AccountingOperations.Ref AS AccountingOperation,
	|	tmp.Period AS Period,
	|	tmp.Use AS Use
	|FROM
	|	Catalog.AccountingOperations AS AccountingOperations
	|		LEFT JOIN tmp AS tmp
	|		ON AccountingOperations.Ref = tmp.AccountingOperation
	|WHERE
	|	NOT AccountingOperations.Parent.Ref IS NULL
	|	AND NOT AccountingOperations.DeletionMark
	|
	|ORDER BY
	|	AccountingOperations.Order
	|TOTALS
	|BY
	|	Document";
	Query.SetParameter("LedgerType", LedgerTypeRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	
	ArrayOfRowsLevel1 = New Array();
	While QuerySelection.Next() Do // Level1
		Level1 = CreateLevel1(QuerySelection.Document);
		
		AccountingOperations = AccountingServer.SplitAccountingOperationsByTransactionTypes(QuerySelection.Document);
		QuerySelectionDetail = QuerySelection.Select();
		
		ArrayOfRowsLevel2 = New Array();
		For Each KeyValue In AccountingOperations.With_TransactionType Do // Level2
			
			Level2 = CreateLevel2(KeyValue.Key);
			
			ArrayOfRowsLevel3 = New Array();
			For Each AO In KeyValue.Value Do // Level3
				QuerySelectionDetail.Reset();
				If QuerySelectionDetail.FindNext(New Structure("AccountingOperation", AO)) Then
					ArrayOfRowsLevel3.Add(CreateLevel3(QuerySelectionDetail));
				EndIf;
			EndDo; // Level3
			
			If ArrayOfRowsLevel3.Count() Then
				Level2.Rows = ArrayOfRowsLevel3;
				ArrayOfRowsLevel2.Add(Level2);
			EndIf;
			
		EndDo; // Level2
		
		Level2 = CreateLevel2(R().AccountingInfo_02);
		
		ArrayOfRowsLevel3 = New Array();
		For Each AO In AccountingOperations.Without_TransactionType Do // Level3
			QuerySelectionDetail.Reset();
			If QuerySelectionDetail.FindNext(New Structure("AccountingOperation", AO)) Then
				ArrayOfRowsLevel3.Add(CreateLevel3(QuerySelectionDetail));
			EndIf;
		EndDo; // Level3
			
		If ArrayOfRowsLevel3.Count() Then
			Level2.Rows = ArrayOfRowsLevel3;
			ArrayOfRowsLevel2.Add(Level2);
		EndIf;
		
		If ArrayOfRowsLevel2.Count() Then
			For Each RowLevel2 In ArrayOfRowsLevel2 Do
				Level1.Rows.Add(RowLevel2);
			EndDo;
			ArrayOfRowsLevel1.Add(Level1);
		EndIf;
		
	EndDo; // Level1
	
	Return ArrayOfRowsLevel1;
EndFunction

&AtServerNoContext
Function CreateLevel1(Document)
	Level1 = New Structure();
	Level1.Insert("Level", 1);
	Level1.Insert("Picture", 1);
	Level1.Insert("Presentation", String(Document));
	Level1.Insert("Document", Document);
	Level1.Insert("Rows", New Array());
	Return Level1;
EndFunction

&AtServerNoContext
Function CreateLevel2(TransactionType)
	Level2 = New Structure();
	Level2.Insert("Level", 2);
	Level2.Insert("Picture", 2);
	Level2.Insert("Presentation", String(TransactionType));
	Level2.Insert("Rows", New Array());
	Return Level2;
EndFunction

&AtServerNoContext
Function CreateLevel3(QuerySelection)
	Level3 = New Structure();
	Level3.Insert("Level", 3);
	Level3.Insert("Picture", 0);
	Level3.Insert("Presentation", String(QuerySelection.AccountingOperation));
	Level3.Insert("AccountingOperation", QuerySelection.AccountingOperation);
	Level3.Insert("Period", QuerySelection.Period);
	Level3.Insert("Use", QuerySelection.Use);
	Return Level3;
EndFunction

&AtClient
Procedure OperationsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure OperationsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion