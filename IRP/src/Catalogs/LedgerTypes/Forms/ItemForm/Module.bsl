
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
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
			If Level2.Use And Not ValueIsFilled(Level2.Period) Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_111, Level1.Document, Level2.AccountingOperation));
			EndIf;
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	For Each Level1 In ThisObject.OperationsTree.GetItems() Do
		For Each Level2 In Level1.GetItems() Do
			If Not ValueIsFilled(Level2.Period) Then
				Continue;
			EndIf;
			RecordSet = InformationRegisters.LedgerTypeOperations.CreateRecordSet();
			RecordSet.Filter.LedgerType.Set(Object.Ref);
			RecordSet.Filter.AccountingOperation.Set(Level2.AccountingOperation);
			NewRecord = RecordSet.Add();
			NewRecord.LedgerType = Object.Ref;
			NewRecord.AccountingOperation = Level2.AccountingOperation;
			NewRecord.Period = Level2.Period;
			NewRecord.Use = Level2.Use;
			RecordSet.Write();
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
			FillPropertyValues(NewLevel1.GetItems().Add(), Level2);
		EndDo;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetAccountingOperations(LedgerTypeRef)
	ArrayOfAccountingOperations = New Array();
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
	While QuerySelection.Next() Do
		Level1 = New Structure();
		Level1.Insert("Level", 1);
		Level1.Insert("Picture", 1);
		Level1.Insert("Presentation", String(QuerySelection.Document));
		Level1.Insert("Document", QuerySelection.Document);
		Level1.Insert("Rows", New Array());
		ArrayOfAccountingOperations.Add(Level1);
		
		QuerySelectionDetail = QuerySelection.Select();
		While QuerySelectionDetail.Next() Do
			Level2 = New Structure();
			Level2.Insert("Level", 2);
			Level2.Insert("Picture", 0);
			Level2.Insert("Presentation", String(QuerySelectionDetail.AccountingOperation));
			Level2.Insert("AccountingOperation", QuerySelectionDetail.AccountingOperation);
			Level2.Insert("Period", QuerySelectionDetail.Period);
			Level2.Insert("Use", QuerySelectionDetail.Use);
			Level1.Rows.Add(Level2);
		EndDo;
	EndDo;
	Return ArrayOfAccountingOperations;
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
