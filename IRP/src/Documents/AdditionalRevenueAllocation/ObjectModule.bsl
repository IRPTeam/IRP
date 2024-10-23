Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	
	If Not Cancel And WriteMode = DocumentWriteMode.Posting Then
		If ThisObject.AllocationMode = Enums.AllocationMode.ByDocuments Then
			// See #2206
			ThisObject.RegisterRecords.R6080T_OtherPeriodsRevenues.Read();
			If ThisObject.RegisterRecords.R6080T_OtherPeriodsRevenues.Count() Then
				ThisObject.RegisterRecords.R6080T_OtherPeriodsRevenues.Clear();
				ThisObject.RegisterRecords.R6080T_OtherPeriodsRevenues.Write();
			EndIf;
			UpdateAmounts();
			FillTables_ByDocuments();
		EndIf;
		UpdateAllocationResult();
	EndIf;
EndProcedure

Procedure UpdateAmounts()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6080T_OtherPeriodsRevenues.Basis AS Document,
	|	R6080T_OtherPeriodsRevenues.Company,
	|	R6080T_OtherPeriodsRevenues.Currency,
	|	R6080T_OtherPeriodsRevenues.RevenueType,
	|	R6080T_OtherPeriodsRevenues.ProfitLossCenter,
	|	SUM(R6080T_OtherPeriodsRevenues.AmountBalance) AS Amount,
	|	SUM(R6080T_OtherPeriodsRevenues.AmountTaxBalance) AS TaxAmount
	|FROM
	|	AccumulationRegister.R6080T_OtherPeriodsRevenues.Balance(&BalancePeriod, CurrencyMovementType = &CurrencyMovementType
	|	AND Basis IN (&ArrayOfDocuments)) AS R6080T_OtherPeriodsRevenues
	|GROUP BY
	|	R6080T_OtherPeriodsRevenues.Basis,
	|	R6080T_OtherPeriodsRevenues.Company,
	|	R6080T_OtherPeriodsRevenues.RevenueType,
	|	R6080T_OtherPeriodsRevenues.ProfitLossCenter,
	|	R6080T_OtherPeriodsRevenues.Currency";	
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	BalancePeriod = New Boundary(ThisObject.PointInTime(), BoundaryType.Excluding);
	Query.SetParameter("BalancePeriod", BalancePeriod);
	
	ArrayOfDocuments = New Array();
	For Each Row In ThisObject.RevenueDocuments Do
		ArrayOfDocuments.Add(Row.Document);
	EndDo;
	
	Query.SetParameter("ArrayOfDocuments", ArrayOfDocuments);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	For Each Row In ThisObject.RevenueDocuments Do
		If QuerySelection.FindNext(New Structure("Document", Row.Document)) Then
			Row.Currency = QuerySelection.Currency;
			Row.Amount = QuerySelection.Amount;
			Row.TaxAmount = QuerySelection.TaxAmount;
		EndIf;
		QuerySelection.Reset();
	EndDo;
EndProcedure

Procedure FillTables_ByDocuments()
	ThisObject.RevenueList.Clear();
	ThisObject.AllocationList.Clear();
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RevenueDocuments.Key,
	|	RevenueDocuments.Document,
	|	RevenueDocuments.Currency
	|INTO RevenueDocuments
	|FROM
	|	&RevenueDocuments AS RevenueDocuments
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllocationDocuments.Key,
	|	AllocationDocuments.Document
	|INTO AllocationDocuments
	|FROM
	|	&AllocationDocuments AS AllocationDocuments
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RevenueDocuments.Key,
	|	R6080T_OtherPeriodsRevenuesBalance.RowID,
	|	RevenueDocuments.Document AS Basis,
	|	RevenueDocuments.Currency,
	|	R6080T_OtherPeriodsRevenuesBalance.RevenueType,
	|	R6080T_OtherPeriodsRevenuesBalance.ProfitLossCenter,
	|	R6080T_OtherPeriodsRevenuesBalance.ItemKey,
	|	R6080T_OtherPeriodsRevenuesBalance.AmountBalance AS Amount,
	|	R6080T_OtherPeriodsRevenuesBalance.AmountTaxBalance AS TaxAmount
	|FROM
	|	RevenueDocuments AS RevenueDocuments
	|		LEFT JOIN AccumulationRegister.R6080T_OtherPeriodsRevenues.Balance(&BalancePeriod, (Basis, Currency) IN
	|			(SELECT
	|				RevenueDocuments.Document,
	|				RevenueDocuments.Currency
	|			FROM
	|				RevenueDocuments AS RevenueDocuments)) AS R6080T_OtherPeriodsRevenuesBalance
	|		ON RevenueDocuments.Document = R6080T_OtherPeriodsRevenuesBalance.Basis
	|		AND RevenueDocuments.Currency = R6080T_OtherPeriodsRevenuesBalance.Currency
	|		AND R6080T_OtherPeriodsRevenuesBalance.CurrencyMovementType = &CurrencyMovementType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllocationDocuments.Key,
	|	T6020S_BatchKeysInfo.RowID,
	|	T6020S_BatchKeysInfo.Recorder AS Document,
	|	T6020S_BatchKeysInfo.Currency,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey,
	|	CASE
	|		WHEN T6020S_BatchKeysInfo.ItemKey.Weight <> 0
	|			THEN T6020S_BatchKeysInfo.ItemKey.Weight
	|		ELSE T6020S_BatchKeysInfo.ItemKey.Item.Weight
	|	END AS Weight,
	|	T6020S_BatchKeysInfo.Quantity,
	|	T6020S_BatchKeysInfo.InvoiceAmount AS Amount
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		INNER JOIN AllocationDocuments AS AllocationDocuments
	|		ON AllocationDocuments.Document = T6020S_BatchKeysInfo.Recorder
	|		AND T6020S_BatchKeysInfo.Direction = VALUE(Enum.BatchDirection.Receipt)
	|		AND T6020S_BatchKeysInfo.RowID <> """"";
	
	Query.SetParameter("RevenueDocuments"     , ThisObject.RevenueDocuments.Unload());
	Query.SetParameter("AllocationDocuments"  , ThisObject.AllocationDocuments.Unload());
	Query.SetParameter("CurrencyMovementType" , ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	BalancePeriod = Undefined;
	If ValueIsFilled(ThisObject.Ref) And ThisObject.Ref.Posted Then
		BalancePeriod = New Boundary(ThisObject.Ref.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = ThisObject.Date;
	EndIf;
	Query.SetParameter("BalancePeriod", BalancePeriod);
	
	ThisObject.RevenueList.Clear();
	ThisObject.AllocationList.Clear();
	
	QueryResults = Query.ExecuteBatch();
	
	RevenueTable = QueryResults[2].Unload();
	AllocationTable = QueryResults[3].Unload();
	
	Total = 0;
	ColumnName = "";
	If ThisObject.AllocationMethod = Enums.AllocationMethod.ByAmount Then
		ColumnName = "Amount";
	ElsIf ThisObject.AllocationMethod = Enums.AllocationMethod.ByQuantity Then
		ColumnName = "Quantity";
	ElsIf ThisObject.AllocationMethod = Enums.AllocationMethod.ByWeight Then
		ColumnName = "Weight";
	EndIf;
		
	For Each RowRevenue In RevenueTable Do
		FillPropertyValues(ThisObject.RevenueList.Add(), RowRevenue);
		
		TotalAllocated    = 0;
		TotalAllocatedTax = 0;
		
		MaxRow    = Undefined;
		MaxRowTax = Undefined;
		
		AllocationTableCopy = AllocationTable.Copy(New Structure("Key", RowRevenue.Key));
		
		_RowRevenue_Amount = RowRevenue.Amount;
		If Not ValueIsFilled(RowRevenue.Amount) Then
			_RowRevenue_Amount = 0;
		EndIf;
		
		_RowRevenue_TaxAmount = RowRevenue.TaxAmount;
		If Not ValueIsFilled(RowRevenue.TaxAmount) Then
			_RowRevenue_TaxAmount = 0;
		EndIf;
		
		For Each RowAllocation In AllocationTableCopy Do
			Total = AllocationTableCopy.Total(ColumnName);
	
			_RowAllocation_ColumnName = RowAllocation[ColumnName];
			If Not ValueIsFilled(RowAllocation[ColumnName]) Then
				_RowAllocation_ColumnName = 0;
			EndIf;
			
			If Not ValueIsFilled(Total) Then
				Continue;
			EndIf;
	
			NewRowAllocationList = ThisObject.AllocationList.Add();
			FillPropertyValues(NewRowAllocationList, RowAllocation);
			NewRowAllocationList.BasisRowID = RowRevenue.RowID;
			
			NewRowAllocationList.Amount    = (_RowRevenue_Amount    / Total) * _RowAllocation_ColumnName;
			NewRowAllocationList.TaxAmount = (_RowRevenue_TaxAmount / Total) * _RowAllocation_ColumnName;
			
			TotalAllocated    = TotalAllocated    + NewRowAllocationList.Amount;
			TotalAllocatedTax = TotalAllocatedTax + NewRowAllocationList.TaxAmount;
			
			If MaxRow = Undefined Then
				MaxRow = NewRowAllocationList;
			Else
				If MaxRow.Amount < NewRowAllocationList.Amount Then
					MaxRow = NewRowAllocationList;
				EndIf;
			EndIf;
			
			If MaxRowTax = Undefined Then
				MaxRowTax = NewRowAllocationList;
			Else
				If MaxRowTax.Amount < NewRowAllocationList.TaxAmount Then
					MaxRowTax = NewRowAllocationList;
				EndIf;
			EndIf;
			
		EndDo;
		
		If _RowRevenue_Amount <> TotalAllocated And MaxRow <> Undefined Then
			MaxRow.Amount = MaxRow.Amount + (_RowRevenue_Amount - TotalAllocated);
		EndIf;
		
		If _RowRevenue_TaxAmount <> TotalAllocatedTax And MaxRowTax <> Undefined Then
			MaxRowTax.TaxAmount = MaxRowTax.TaxAmount + (_RowRevenue_TaxAmount - TotalAllocatedTax);
		EndIf;
		
	EndDo;
	
EndProcedure

Procedure UpdateAllocationResult()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RevenueList.RowID,
	|	RevenueList.Basis,
	|	RevenueList.ItemKey,
	|	RevenueList.Currency,
	|	RevenueList.RevenueType,
	|	RevenueList.ProfitLossCenter
	|INTO RevenueList
	|FROM
	|	&RevenueList AS RevenueList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllocationList.BasisRowID,
	|	AllocationList.RowID,
	|	AllocationList.Document,
	|	AllocationList.Store,
	|	AllocationList.ItemKey,
	|	AllocationList.Amount,
	|	AllocationList.TaxAmount
	|INTO AllocationList
	|FROM
	|	&AllocationList AS AllocationList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RevenueList.RowID,
	|	AllocationList.BasisRowID,
	|	RevenueList.Basis AS RevenueSalesInvoice,
	|	RevenueList.ItemKey.Item AS RevenueItem,
	|	RevenueList.ItemKey AS RevenueItemKey,
	|	RevenueList.Currency,
	|	AllocationList.Document AS SalesInvoice,
	|	AllocationList.ItemKey.Item AS Item,
	|	AllocationList.ItemKey AS ItemKey,
	|	AllocationList.Store,
	|	AllocationList.Amount,
	|	AllocationList.TaxAmount,
	|	RevenueList.RevenueType,
	|	RevenueList.ProfitLossCenter
	|FROM
	|	RevenueList AS RevenueList
	|		INNER JOIN AllocationList AS AllocationList
	|		ON RevenueList.RowID = AllocationList.BasisRowID";
	
	Query.SetParameter("RevenueList", ThisObject.RevenueList.Unload());
	Query.SetParameter("AllocationList", ThisObject.AllocationList.Unload());
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ArrayForDelete = New Array();
	For Each Row In ThisObject.AllocationResult Do
		Filter = New Structure("RowID, BasisRowID", Row.RowID, Row.BasisRowID);
		If QueryTable.FindRows(Filter).Count() = 0 Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayForDelete Do
		ThisObject.AllocationResult.Delete(Row);
	EndDo;
	
	For Each Row In QueryTable Do
		Filter = New Structure("RowID, BasisRowID", Row.RowID, Row.BasisRowID);
		Rows = ThisObject.AllocationResult.FindRows(Filter); 
		If Rows.Count() Then
			NewRow = Rows[0];
		Else
			NewRow = ThisObject.AllocationResult.Add();
			NewRow.Key = New UUID();
		EndIf;
		FillPropertyValues(NewRow, Row);
	EndDo;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
		
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel);
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		ThisObject.AllocationMode = Enums.AllocationMode.ByRows;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.AllocationMode = Enums.AllocationMode.ByDocuments Then
		
		For Each Row In ThisObject.RevenueDocuments Do
			ArrayOfAllocationDocuments = ThisObject.AllocationDocuments.FindRows(New Structure("Key", Row.Key));
			If Not ArrayOfAllocationDocuments.Count() Then
				CommonFunctionsClientServer.ShowUsersMessage(
						StrTemplate(R().Error_125, Row.Document), 
						"Object.RevenueDocuments[" + (Row.LineNumber - 1) + "].Document", 
						"Object.RevenueDocuments");
				Cancel = True;
			EndIf;
		EndDo;
		
	EndIf;
EndProcedure
