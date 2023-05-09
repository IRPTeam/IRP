Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If Not Cancel And WriteMode = DocumentWriteMode.Posting Then
		If ThisObject.AllocationMode = Enums.AllocationMode.ByDocuments Then
			// Remove me
			ThisObject.RegisterRecords.R6070T_OtherPeriodsExpenses.Read();
			If ThisObject.RegisterRecords.R6070T_OtherPeriodsExpenses.Count() Then
				ThisObject.RegisterRecords.R6070T_OtherPeriodsExpenses.Clear();
				ThisObject.RegisterRecords.R6070T_OtherPeriodsExpenses.Write();
			EndIf;
			UpdateAmounts();
			FillTables_ByDocuments();
		EndIf;
	EndIf;
EndProcedure

Procedure UpdateAmounts()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R6070T_OtherPeriodsExpenses.Basis AS Document,
	|	R6070T_OtherPeriodsExpenses.Company,
	|	R6070T_OtherPeriodsExpenses.Currency,
	|	SUM(R6070T_OtherPeriodsExpenses.AmountBalance) AS Amount,
	|	SUM(R6070T_OtherPeriodsExpenses.AmountTaxBalance) AS TaxAmount
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(, CurrencyMovementType = &CurrencyMovementType
	|	AND Basis IN (&ArrayOfDocuments)) AS R6070T_OtherPeriodsExpenses
	|GROUP BY
	|	R6070T_OtherPeriodsExpenses.Basis,
	|	R6070T_OtherPeriodsExpenses.Company,
	|	R6070T_OtherPeriodsExpenses.Currency";	
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	BalancePeriod = New Boundary(ThisObject.PointInTime(), BoundaryType.Excluding);
	Query.SetParameter("BalancePeriod", BalancePeriod);
	
	ArrayOfDocuments = New Array();
	For Each Row In ThisObject.CostDocuments Do
		ArrayOfDocuments.Add(Row.Document);
	EndDo;
	
	Query.SetParameter("ArrayOfDocuments", ArrayOfDocuments);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	For Each Row In ThisObject.CostDocuments Do
		If QuerySelection.FindNext(New Structure("Document", Row.Document)) Then
			Row.Currency = QuerySelection.Currency;
			Row.Amount = QuerySelection.Amount;
			Row.TaxAmount = QuerySelection.TaxAmount;
		EndIf;
		QuerySelection.Reset();
	EndDo;
EndProcedure

Procedure FillTables_ByDocuments()
	ThisObject.CostList.Clear();
	ThisObject.AllocationList.Clear();
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CostDocuments.Key,
	|	CostDocuments.Document,
	|	CostDocuments.Currency
	|INTO CostDocuments
	|FROM
	|	&CostDocuments AS CostDocuments
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
	|	CostDocuments.Key,
	|	R6070T_OtherPeriodsExpensesBalance.RowID,
	|	CostDocuments.Document AS Basis,
	|	CostDocuments.Currency,
	|	R6070T_OtherPeriodsExpensesBalance.ItemKey,
	|	R6070T_OtherPeriodsExpensesBalance.AmountBalance AS Amount,
	|	R6070T_OtherPeriodsExpensesBalance.AmountTaxBalance AS TaxAmount
	|FROM
	|	CostDocuments AS CostDocuments
	|		LEFT JOIN AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(, (Basis, Currency) IN
	|			(SELECT
	|				CostDocuments.Document,
	|				CostDocuments.Currency
	|			FROM
	|				CostDocuments AS CostDocuments)) AS R6070T_OtherPeriodsExpensesBalance
	|		ON CostDocuments.Document = R6070T_OtherPeriodsExpensesBalance.Basis
	|		AND CostDocuments.Currency = R6070T_OtherPeriodsExpensesBalance.Currency
	|		AND R6070T_OtherPeriodsExpensesBalance.CurrencyMovementType = &CurrencyMovementType
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
	|	T6020S_BatchKeysInfo.Amount
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		INNER JOIN AllocationDocuments AS AllocationDocuments
	|		ON AllocationDocuments.Document = T6020S_BatchKeysInfo.Recorder
	|		AND T6020S_BatchKeysInfo.Direction = VALUE(Enum.BatchDirection.Receipt)
	|		AND T6020S_BatchKeysInfo.RowID <> """"";
	
	Query.SetParameter("CostDocuments"        , ThisObject.CostDocuments.Unload());
	Query.SetParameter("AllocationDocuments"  , ThisObject.AllocationDocuments.Unload());
	Query.SetParameter("CurrencyMovementType" , ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	BalancePeriod = Undefined;
	If ValueIsFilled(ThisObject.Ref) And ThisObject.Ref.Posted Then
		BalancePeriod = New Boundary(ThisObject.Ref.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = ThisObject.Date;
	EndIf;
	Query.SetParameter("BalancePeriod", BalancePeriod);
	
	ThisObject.CostList.Clear();
	ThisObject.AllocationList.Clear();
	
	QueryResults = Query.ExecuteBatch();
	
	CostTable = QueryResults[2].Unload();
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
		
	For Each RowCost In CostTable Do
		FillPropertyValues(ThisObject.CostList.Add(), RowCost);
		
		TotalAllocated    = 0;
		TotalAllocatedTax = 0;
		
		MaxRow    = Undefined;
		MaxRowTax = Undefined;
		
		AllocationTableCopy = AllocationTable.Copy(New Structure("Key", RowCost.Key));
		
		_RowCost_Amount = RowCost.Amount;
		If Not ValueIsFilled(RowCost.Amount) Then
			_RowCost_Amount = 0;
		EndIf;
		
		_RowCost_TaxAmount = RowCost.TaxAmount;
		If Not ValueIsFilled(RowCost.TaxAmount) Then
			_RowCost_TaxAmount = 0;
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
			NewRowAllocationList.BasisRowID = RowCost.RowID;
			
			NewRowAllocationList.Amount    = (_RowCost_Amount   / Total)  * _RowAllocation_ColumnName;
			NewRowAllocationList.TaxAmount = (_RowCost_TaxAmount / Total) * _RowAllocation_ColumnName;
			
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
				If MaxRowTax.TaxAmount < NewRowAllocationList.TaxAmount Then
					MaxRowTax = NewRowAllocationList;
				EndIf;
			EndIf;
			
		EndDo;
		
		If _RowCost_Amount <> TotalAllocated And MaxRow <> Undefined Then
			MaxRow.Amount = MaxRow.Amount + (_RowCost_Amount - TotalAllocated);
		EndIf;
		
		If _RowCost_TaxAmount <> TotalAllocatedTax And MaxRowTax <> Undefined Then
			MaxRowTax.TaxAmount = MaxRowTax.TaxAmount + (_RowCost_TaxAmount - TotalAllocatedTax);
		EndIf;
		
	EndDo;
	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
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
		
		For Each Row In ThisObject.CostDocuments Do
			ArrayOfAllocationDocuments = ThisObject.AllocationDocuments.FindRows(New Structure("Key", Row.Key));
			If Not ArrayOfAllocationDocuments.Count() Then
				CommonFunctionsClientServer.ShowUsersMessage(
						StrTemplate(R().Error_125, Row.Document), 
						"Object.CostDocuments[" + (Row.LineNumber - 1) + "].Document", 
						"Object.CostDocuments");
				Cancel = True;
			EndIf;
		EndDo;
		
	EndIf;
EndProcedure
