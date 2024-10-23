
#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	Return;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocAdditionalCostAllocationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocAdditionalCostAllocationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocAdditionalCostAllocationClient.OnOpen(Object, ThisObject, Cancel);
	RefreshRowsAllocationTreesAtClient();
	SetVisibilityAllocations();
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	RefreshRowsAllocationTreesAtClient();
	SetVisibilityAllocations();
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocAdditionalCostAllocationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	Form.Items.GroupByRows.Visible = Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByRows");
	Form.Items.GroupByDocuments.Visible = Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByDocuments");
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

&AtClient
Procedure SetVisibilityAllocations() Export
	If Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByDocuments") Then
		CurrentData = ThisObject.Items.CostDocuments.CurrentData;
		If CurrentData = Undefined Then
			Return;
		EndIf;
		isRowSet = False;
		For Each Row In Object.AllocationDocuments Do
			Row.Visible = Row.Key = CurrentData.Key;
			If Not isRowSet And Row.Visible Then
				ThisObject.Items.AllocationDocuments.CurrentRow = Row.GetID();
				isRowSet = True;
			EndIf;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure AllocationModeOnChange(Item)
	If Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByDocuments") Then
		Object.CostList.Clear();
		Object.AllocationList.Clear();
		SetVisibilityAvailability(Object, ThisObject);
	ElsIf Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByRows") Then
		Object.CostDocuments.Clear();
		Object.AllocationDocuments.Clear();
		SetVisibilityAvailability(Object, ThisObject);
		RefreshRowsAllocationTreesAtClient();
	EndIf;
EndProcedure

&AtClient
Procedure RefreshRowsAllocationTreesAtClient()
	If Not Object.AllocationMode = PredefinedValue("Enum.AllocationMode.ByRows") Then
		Return;
	EndIf;
	RefreshRowsAllocationTreesAtServer();
	UpdateAllocatedStatus();
	
	CommonFormActions.ExpandTree(Items.CostRows, ThisObject.CostRows.GetItems());
	CommonFormActions.ExpandTree(Items.AllocationRows, ThisObject.AllocationRows.GetItems());
EndProcedure

&AtServer
Procedure RefreshRowsAllocationTreesAtServer()
	// Cost rows
	ThisObject.CostRows.GetItems().Clear();
	
	BasisTable = Object.CostList.Unload();
	BasisTable.GroupBy("Basis");
	FooterTotalAmount    = 0;
	FooterTotalTaxAmount = 0;
	For Each RowBasis In BasisTable Do
		NewRow_TopLevel = ThisObject.CostRows.GetItems().Add();
		NewRow_TopLevel.Level = 1;
		NewRow_TopLevel.Icon = 1;		
		NewRow_TopLevel.Document = RowBasis.Basis;
		NewRow_TopLevel.Presentation = String(RowBasis.Basis);
		TotalAmount    = 0;
		TotalTaxAmount = 0;
		TotalCurrency  = Undefined;
		For Each RowDetail In Object.CostList.FindRows(New Structure("Basis", RowBasis.Basis)) Do
			NewRow_SecondLevel = NewRow_TopLevel.GetItems().Add();
			NewRow_SecondLevel.Level = 2;
			NewRow_SecondLevel.Icon = 0;
			FillPropertyValues(NewRow_SecondLevel, RowDetail);
			NewRow_SecondLevel.Presentation = String(RowDetail.ItemKey.Item) + ", " + String(RowDetail.ItemKey);
			
			TotalAmount    = TotalAmount    + NewRow_SecondLevel.Amount;
			TotalTaxAmount = TotalTaxAmount + NewRow_SecondLevel.TaxAmount;

			FooterTotalAmount    = FooterTotalAmount    + NewRow_SecondLevel.Amount;
			FooterTotalTaxAmount = FooterTotalTaxAmount + NewRow_SecondLevel.TaxAmount;
		
			TotalCurrency = NewRow_SecondLevel.Currency;
		EndDo;
		NewRow_TopLevel.Amount    = TotalAmount;
		NewRow_TopLevel.TaxAmount = TotalTaxAmount;
		NewRow_TopLevel.Currency  = TotalCurrency;
	EndDo;
	Items.CostRowsAmount.FooterText    = Format(FooterTotalAmount    , "NFD=2;");
	Items.CostRowsTaxAmount.FooterText = Format(FooterTotalTaxAmount , "NFD=2;");
	
	// Allocation rows
	ThisObject.AllocationRows.GetItems().Clear();
	
	BasisTable = Object.AllocationList.Unload();
	BasisTable.GroupBy("Document");
	FooterTotalAmount    = 0;
	FooterTotalTaxAmount = 0;
	For Each RowBasis In BasisTable Do
		NewRow_TopLevel = ThisObject.AllocationRows.GetItems().Add();
		NewRow_TopLevel.Level = 1;
		NewRow_TopLevel.Icon = 1;
		NewRow_TopLevel.Document = RowBasis.Document;
		NewRow_TopLevel.Presentation = String(RowBasis.Document);
		TotalAmount    = 0;
		TotalTaxAmount = 0;
		For Each RowDetail In Object.AllocationList.FindRows(New Structure("Document", RowBasis.Document)) Do
			NewRow_SecondLevel = NewRow_TopLevel.GetItems().Add();
			NewRow_SecondLevel.Level = 2;
			NewRow_SecondLevel.Icon = 0;
			FillPropertyValues(NewRow_SecondLevel, RowDetail);
			NewRow_SecondLevel.Presentation = String(NewRow_SecondLevel.ItemKey.Item) + ", " + String(NewRow_SecondLevel.ItemKey);
			TotalAmount    = TotalAmount    + NewRow_SecondLevel.Amount;
			TotalTaxAmount = TotalTaxAmount + NewRow_SecondLevel.TaxAmount;
			FooterTotalAmount    = FooterTotalAmount + NewRow_SecondLevel.Amount;
			FooterTotalTaxAmount = FooterTotalTaxAmount + NewRow_SecondLevel.TaxAmount;
		EndDo;
		NewRow_TopLevel.Amount    = TotalAmount;
		NewRow_TopLevel.TaxAmount = TotalTaxAmount;
	EndDo;
	Items.AllocationRowsAmount.FooterText    = Format(FooterTotalAmount, "NFD=2;");
	Items.AllocationRowsTaxAmount.FooterText = Format(FooterTotalTaxAmount, "NFD=2;");
EndProcedure

&AtClient
Procedure CostDocumentsOnChange(Item)
	For Each Row In Object.CostDocuments Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = String(New UUID());
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure CostDocumentsDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	Notify = New NotifyDescription("CostDocumentsDocumentStartChoiceEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);
	FormParameters.Insert("Ref"     , Object.Ref);
	FormParameters.Insert("Date"    , Object.Date);
	ArrayOfSelectedDocuments = New Array();
	For Each Row In Object.CostDocuments Do
		ArrayOfSelectedDocuments.Add(Row.Document);
	EndDo;
	FormParameters.Insert("SelectedDocuments", ArrayOfSelectedDocuments);
	
	OpenForm("Document.AdditionalCostAllocation.Form.FormSelectCostDocument",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure CostDocumentsDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	CurrentData = ThisObject.Items.CostDocuments.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.Document  = Result.Document;
		CurrentData.Currency  = Result.Currency;
		CurrentData.Amount    = Result.Amount;
		CurrentData.TaxAmount = Result.TaxAmount;
	EndIf;
EndProcedure

&AtClient
Procedure CostDocumentsDocumentOnChange(Item)
	CurrentData = Items.CostDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(CurrentData.Document) Then
		CurrentData.Currency  = Undefined;
		CurrentData.Amount    = Undefined;
		CurrentData.TaxAmount = Undefined;
		Return;
	EndIf;
	
	DocData = GetDataFromDocument(CurrentData.Document);
	CurrentData.Currency  = DocData.Currency;
	CurrentData.Amount    = DocData.Amount;
	CurrentData.TaxAmount = DOcData.TaxAmount;	
EndProcedure

&AtServer
Function GetDataFromDocument(DocumentRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6070T_OtherPeriodsExpenses.Basis AS Document,
	|	R6070T_OtherPeriodsExpenses.Company,
	|	R6070T_OtherPeriodsExpenses.Currency,
	|	SUM(R6070T_OtherPeriodsExpenses.AmountBalance) AS Amount,
	|	SUM(R6070T_OtherPeriodsExpenses.AmountTaxBalance) AS TaxAmount
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(&BalancePeriod, CurrencyMovementType = &CurrencyMovementType
	|	AND Basis = &DocumentRef) AS R6070T_OtherPeriodsExpenses
	|GROUP BY
	|	R6070T_OtherPeriodsExpenses.Basis,
	|	R6070T_OtherPeriodsExpenses.Company,
	|	R6070T_OtherPeriodsExpenses.Currency";	
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	If ValueIsFilled(Object.Ref) And Object.Posted Then
		BalancePeriod = New Boundary(DocumentRef.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = CommonFunctionsServer.GetCurrentSessionDate();
	EndIf;
	Query.SetParameter("BalancePeriod", BalancePeriod);
	Query.SetParameter("DocumentRef", DocumentRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure();
	Result.Insert("Document"  , Undefined);
	Result.Insert("Currency"  , Undefined);
	Result.Insert("Amount"    , Undefined);
	Result.Insert("TaxAmount" , Undefined);
	
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

&AtClient
Procedure CostRowsBeforeDeleteRow(Item, Cancel)
	Cancel = True;	
EndProcedure

&AtClient
Procedure AllocationRowsBeforeDeleteRow(Item, Cancel)
	Cancel = True;	
EndProcedure

&AtClient
Procedure AllocationRowsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	CurrentData = Items.CostRows.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Notify = New NotifyDescription("AllocationRowsBeforeAddRowEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);
	FormParameters.Insert("BasisRowID", CurrentData.RowID);
	
	ArrayOfSelectedRows = New Array();
	For Each Row In Object.AllocationList Do
		If Row.BasisRowID <> CurrentData.RowID Then
			Continue;
		EndIf;
		SelectedRow = New Structure();
		
		SelectedRow.Insert("BasisRowID", Row.BasisRowID);
		SelectedRow.Insert("RowID"     , Row.RowID);
		SelectedRow.Insert("Document"  , Row.Document);
		SelectedRow.Insert("Store"     , Row.Store);
		SelectedRow.Insert("ItemKey"   , Row.ItemKey);
		ArrayOfSelectedRows.Add(SelectedRow)
	EndDo;
	
	FormParameters.Insert("SelectedRows", ArrayOfSelectedRows);
	
	OpenForm("Document.AdditionalCostAllocation.Form.FormSelectAllocationRows",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AllocationRowsOnActivateRow(Item)
	Return;
EndProcedure

&AtClient
Procedure CostRowsOnActivateRow(Item)
	CurrentData = Items.CostRows.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	IsSecondLevel = CurrentData.Level = 2;
	Items.AllocationRowsAdd.Enabled = IsSecondLevel;
	
	// Set visible and recalculate totals  amount
	FooterTotalAmount    = 0;
	FooterTotalTaxAmount = 0;
	CurrentRowID = Undefined;
	For Each Row_TopLevel In ThisObject.AllocationRows.GetItems() Do
		TotalAmount    = 0;
		TotalTaxAmount = 0;
		SecondLevelIsVisible = False;
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			If Row_SecondLevel.BasisRowID = CurrentData.RowID Then
				SecondLevelIsVisible = True;
				Row_SecondLevel.Visible = True;
				TotalAmount    = TotalAmount    + Row_SecondLevel.Amount;
				TotalTaxAmount = TotalTaxAmount + Row_SecondLevel.TaxAmount;
				FooterTotalAmount    = FooterTotalAmount    + Row_SecondLevel.Amount;
				FooterTotalTaxAmount = FooterTotalTaxAmount + Row_SecondLevel.TaxAmount;
			Else
				Row_SecondLevel.Visible = False;
			EndIf;
		EndDo;
		Row_TopLevel.Visible = SecondLevelIsVisible;
		Row_TopLevel.Amount    = TotalAmount;
		Row_TopLevel.TaxAmount = TotalTaxAmount;
		If CurrentRowID = Undefined And Row_TopLevel.Visible Then
			CurrentRowID = Row_TopLevel.GetID();
		EndIf;
	EndDo;
	If CurrentRowID <> Undefined Then
		Items.AllocationRows.CurrentRow = CurrentRowID;
	EndIf;
	Items.AllocationRowsAmount.FooterText    = Format(FooterTotalAmount   , "NFD=2;");
	Items.AllocationRowsTaxAmount.FooterText = Format(FooterTotalTaxAmount, "NFD=2;");
EndProcedure

&AtClient
Procedure CostRowsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	Notify = New NotifyDescription("CostRowsBeforeAddRowEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);
	FormParameters.Insert("Ref"     , Object.Ref);
	FormParameters.Insert("Date"    , Object.Date);
	
	ArrayOfSelectedRows = New Array();
	For Each Row In Object.CostList Do
		SelectedRow = New Structure();
		SelectedRow.Insert("RowID", Row.RowID);
		SelectedRow.Insert("Basis", Row.Basis);
		ArrayOfSelectedRows.Add(SelectedRow);
	EndDo;
	FormParameters.Insert("SelectedRows", ArrayOfSelectedRows);
	
	OpenForm("Document.AdditionalCostAllocation.Form.FormSelectCostRows",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure CostRowsBeforeAddRowEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.Modified = True;
	// Add new rows
	For Each ResultRow In Result.SelectedRows Do
		If Object.CostList.FindRows(New Structure("RowID, Basis", ResultRow.RowID, ResultRow.Basis)).Count() Then
			Continue;
		EndIf;
		NewRow = Object.CostList.Add();
		FillPropertyValues(NewRow, ResultRow);
	EndDo;
	
	// Remove unused rows from Cost list
	ArrayForDelete = New Array();
	For Each Row In Object.CostList Do
		If DocumentsClientServer.FindRowInArrayOfStructures(Result.SelectedRows, "RowID, Basis", 
			Row.RowID, Row.Basis) = Undefined Then
				ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.CostList.Delete(ItemForDelete);
	EndDo;
	
	// Remove unused rows from Allocation list
	ArrayForDelete = New Array();
	For Each Row In Object.AllocationList Do
		If DocumentsClientServer.FindRowInArrayOfStructures(Result.SelectedRows, "RowID", 
			Row.BasisRowID) = Undefined Then
				ArrayForDelete.Add(Row);
		EndIf;		
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AllocationList.Delete(ItemForDelete);
	EndDo;
	
	RefreshRowsAllocationTreesAtClient();
EndProcedure

&AtClient
Procedure AllocationRowsBeforeAddRowEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ThisObject.Modified = True;
	
	// Add new rows
	For Each ResultRow In Result.SelectedRows Do
		If Object.AllocationList.FindRows(New Structure("BasisRowID, RowID, Document", 
			ResultRow.BasisRowID, ResultRow.RowID, ResultRow.Document)).Count() Then
			Continue;
		EndIf;
		NewRow = Object.AllocationList.Add();
		FillPropertyValues(NewRow, ResultRow);
	EndDo;
	
	// Remove unused rows from Allocation list
	ArrayForDelete = New Array();
	For Each Row In Object.AllocationList Do
		If Result.BasisRowID <> Row.BasisRowID Then
			Continue;
		EndIf;
		If DocumentsClientServer.FindRowInArrayOfStructures(Result.SelectedRows, "BasisRowID, RowID, Document", 
			Row.BasisRowID, Row.RowID, Row.Document) = Undefined Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.AllocationList.Delete(ItemForDelete);
	EndDo;
	
	RefreshRowsAllocationTreesAtClient();
	
	CurrentRow = Undefined;
	For Each Row_TopLevel In ThisObject.CostRows.GetItems() Do
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			If Row_SecondLevel.RowID = Result.BasisRowID Then
				CurrentRow = Row_SecondLevel.GetID();
				Break;
			EndIf;
		EndDo;
		If CurrentRow <> Undefined Then
			Break;
		EndIf;
	EndDo;

	If CurrentRow <> Undefined Then
		Items.CostRows.CurrentRow = CurrentRow;
	EndIf;
EndProcedure

&AtClient
Procedure AllocateCostAmount(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	Result = AllocateCostAmountAtServer();
	FooterTotalAmount    = 0;
	FooterTotalTaxAmount = 0;
	CurrentRowID = Undefined;
	For Each Row_TopLevel In ThisObject.AllocationRows.GetItems() Do
		If CurrentRowID = Undefined And Row_TopLevel.Visible Then
			CurrentRowID = Row_TopLevel.GetID();
		EndIf;
		TotalAmount    = 0;
		TotalTaxAmount = 0;
		For Each Row_SecondLevel In Row_TopLevel.GetItems() Do
			For Each Row In Result.ArrayOfAllocatedAmounts Do
				If Row_SecondLevel.BasisRowID = Row.BasisRowID
				 	And Row_SecondLevel.RowID = Row.RowID Then
						Row_SecondLevel.Amount    = Row.Amount;
						Row_SecondLevel.TaxAmount = Row.TaxAmount;
						TotalAmount    = TotalAmount    + Row.Amount;
						TotalTaxAmount = TotalTaxAmount + Row.TaxAmount;
						FooterTotalAmount    = FooterTotalAmount    + Row.Amount;
						FooterTotalTaxAmount = FooterTotalTaxAmount + Row.TaxAmount;
					Break;
				EndIf;
			EndDo;
		EndDo; // Second level
		Row_TopLevel.Amount    = TotalAmount;
		Row_TopLevel.TaxAmount = TotalTaxAmount;
	EndDo; // Top level
	If CurrentRowID <> Undefined Then
		Items.AllocationRows.CurrentRow = CurrentRowID;
	EndIf;
	Items.AllocationRowsAmount.FooterText    = Format(FooterTotalAmount   , "NFD=2;");
	Items.AllocationRowsTaxAmount.FooterText = Format(FooterTotalTAxAmount, "NFD=2;");
	UpdateAllocatedStatus();
EndProcedure

&AtClient
Procedure UpdateAllocatedStatus()
	For Each RowLevel1 In ThisObject.CostRows.GetItems() Do
		For Each RowLevel2 In RowLevel1.GetItems() Do
			
			AmountByRows = 0;
			TaxAmountByRows = 0;
			
			For Each RowAlloclv1 In ThisObject.AllocationRows.GetItems() Do
				For Each RowAlloclv2 In RowAlloclv1.GetItems() Do
					If RowLevel2.RowID = RowAlloclv2.BasisRowID Then
						AmountByRows    = AmountByRows    + RowAlloclv2.Amount;
						TaxAmountByRows = TaxAmountByRows + RowAlloclv2.TaxAmount;
					EndIf;
				EndDo;	
			EndDo;
			
			If AmountByRows = RowLevel2.Amount 
				And TaxAmountByRows = RowLevel2.TaxAmount Then
				RowLevel2.Icon = 2;
			EndIf;
			
		EndDo;
	EndDo;
EndProcedure

&AtServer
Function AllocateCostAmountAtServer()
	Result = New Structure("ArrayOfAllocatedAmounts", New Array());
	AllocationListTable = Object.AllocationList.Unload();
	For Each Row_CostList In Object.CostList Do
		BatchKeyInfoTable = GetBatchKeyInfo(AllocationListTable.Copy(New Structure("BasisRowID", Row_CostList.RowID)));
		Total = 0;
		ColumnName = "";
		If Object.AllocationMethod = Enums.AllocationMethod.ByAmount Then
			ColumnName = "Amount";
		ElsIf Object.AllocationMethod = Enums.AllocationMethod.ByQuantity Then
			ColumnName = "Quantity";
		ElsIf Object.AllocationMethod = Enums.AllocationMethod.ByWeight Then
			ColumnName = "Weight";
		EndIf;
	
		Total = BatchKeyInfoTable.Total(ColumnName);
	
		If Total = 0 Then
			Continue;
		EndIf;
		
		TotalAllocated    = 0;
		TotalTaxAllocated = 0;
		MaxRow    = Undefined;
		MaxRowTax = Undefined;
	
		For Each Row_BatchKeyInfo In BatchKeyInfoTable Do
			Amount = (Row_CostList.Amount / Total) * Row_BatchKeyInfo[ColumnName];
			Amount = Round(Amount, 2 , RoundMode.Round15as10);
			
			TaxAmount = (Row_CostList.TaxAmount / Total) * Row_BatchKeyInfo[ColumnName];
			TaxAmount = Round(TaxAmount, 2 , RoundMode.Round15as10);
			
			TotalAllocated    = TotalAllocated    + Amount;
			TotalTaxAllocated = TotalTaxAllocated + TaxAmount;
			
			AllocatedAmount = New Structure("BasisRowID, RowID, Amount, TaxAmount", 
				Row_CostList.RowID, Row_BatchKeyInfo.RowID, Amount, TaxAmount);
				
			Result.ArrayOfAllocatedAmounts.Add(AllocatedAmount);
			
			AllocationListRows = Object.AllocationList.FindRows(New Structure("BasisRowID, RowID", 
				Row_CostList.RowID, Row_BatchKeyInfo.RowID));
			
			If AllocationListRows.Count() Then
				AllocationListRows[0].Amount    = Amount;
				AllocationListRows[0].TaxAmount = TaxAmount;
			
				If MaxRow = Undefined Then
					MaxRow = AllocationListRows[0];
				Else
					If MaxRow.Amount < AllocationListRows[0].Amount Then
						MaxRow = AllocationListRows[0];
					EndIf;
				EndIf;
				
				If MaxRowTax = Undefined Then
					MaxRowTax = AllocationListRows[0];
				Else
					If MaxRowTax.TaxAmount < AllocationListRows[0].TaxAmount Then
						MaxRowTax = AllocationListRows[0];
					EndIf;
				EndIf;
				
			EndIf;
			
		EndDo;
		
		If Row_CostList.Amount <> TotalAllocated And MaxRow <> Undefined Then
			MaxRow.Amount = MaxRow.Amount + (Row_CostList.Amount - TotalAllocated);
			For Each Row In Result.ArrayOfAllocatedAmounts Do
				If Row.BasisRowID = MaxRow.BasisRowID And Row.RowID = MaxRow.RowID Then
					Row.Amount = MaxRow.Amount;
					Break;
				EndIf;
			EndDo;
		EndIf;
		
		If Row_CostList.TaxAmount <> TotalTaxAllocated And MaxRowTax <> Undefined Then
			MaxRowTax.TaxAmount = MaxRowTax.TaxAmount + (Row_CostList.TaxAmount - TotalTaxAllocated);
			For Each Row In Result.ArrayOfAllocatedAmounts Do
				If Row.BasisRowID = MaxRow.BasisRowID And Row.RowID = MaxRow.RowID Then
					Row.TaxAmount = MaxRowTax.TaxAmount;
					Break;
				EndIf;
			EndDo;
		EndIf;
		
	EndDo;
	Return Result;
EndFunction

&AtServerNoContext
Function GetBatchKeyInfo(FilterTable)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	FilterTable.RowID,
	|	FilterTable.Document,
	|	FilterTable.Store,
	|	FilterTable.ItemKey
	|INTO FilterTable
	|FROM
	|	&FilterTable AS FilterTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	FilterTable.RowID,
	|	FilterTable.Document,
	|	FilterTable.ItemKey,
	|	FilterTable.Store,
	|	SUM(T6020S_BatchKeysInfo.InvoiceAmount) AS Amount,
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(CASE
	|		WHEN T6020S_BatchKeysInfo.ItemKey.Weight <> 0
	|			THEN T6020S_BatchKeysInfo.ItemKey.Weight
	|		ELSE T6020S_BatchKeysInfo.ItemKey.Item.Weight
	|	END) AS Weight
	|FROM
	|	FilterTable AS FilterTable
	|		INNER JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON FilterTable.Document = T6020S_BatchKeysInfo.Recorder
	|		AND FilterTable.Store = T6020S_BatchKeysInfo.Store
	|		AND FilterTable.ItemKey = T6020S_BatchKeysInfo.ItemKey
	|GROUP BY
	|	FilterTable.Document,
	|	FilterTable.ItemKey,
	|	FilterTable.RowID,
	|	FilterTable.Store";
	Query.SetParameter("FilterTable", FilterTable);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

&AtClient
Procedure CostDocumentsAfterDeleteRow(Item)
	ArrayForDelete = New Array();
	For Each Row In Object.AllocationDocuments Do
		If Not Object.CostDocuments.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;	
	For Each Row In ArrayForDelete Do
		Object.AllocationDocuments.Delete(Row);
	EndDo;
EndProcedure

&AtClient
Procedure CostDocumentsOnActivateRow(Item)
	SetVisibilityAllocations();
EndProcedure

&AtClient
Procedure AllocationDocumentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	CurrentData = Items.CostDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	NewRow = Object.AllocationDocuments.Add();
	NewRow.Key = CurrentData.Key;
	NewRow.Visible = True;
	Items.AllocationDocuments.CurrentRow = NewRow.GetID();
EndProcedure

&AtClient
Procedure AllocationDocumentsDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	Notify = New NotifyDescription("AllocationDocumentsDocumentStartChoiceEnd", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("Company" , Object.Company);

	OpenForm("Document.AdditionalCostAllocation.Form.FormSelectAllocationDocument",
		FormParameters,
		Item,
		ThisObject.UUID,
		,
		ThisObject.URL,
		Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AllocationDocumentsDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;

	CurrentData = ThisObject.Items.AllocationDocuments.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.Document = Result.Document;
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);	
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.AllocationResult.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "AllocationResult");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                        _AccountingExtDimensions, "AllocationResult");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocAdditionalCostAllocationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocAdditionalCostAllocationClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocAdditionalCostAllocationClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region COMMANDS

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