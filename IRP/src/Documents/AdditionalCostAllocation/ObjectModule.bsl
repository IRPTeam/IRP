Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	If Not Cancel And WriteMode = DocumentWriteMode.Posting Then
		If ThisObject.AllocationMode = Enums.AllocationMode.ByDocuments Then
			FillTables_ByDocuments();
		EndIf;
	EndIf;
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
	|	R6070T_OtherPeriodsExpensesBalance.AmountBalance AS Amount
	|FROM
	|	CostDocuments AS CostDocuments
	|		LEFT JOIN AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(&BalancePeriod, (Basis, Currency) IN
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
	
	Query.SetParameter("CostDocuments", ThisObject.CostDocuments.Unload());
	Query.SetParameter("AllocationDocuments", ThisObject.AllocationDocuments.Unload());
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
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
	
	Total = AllocationTable.Total(ColumnName);
	
	If Total = 0 Then
		Return;
	EndIf;
	
	For Each RowCost In CostTable Do
		FillPropertyValues(ThisObject.CostList.Add(), RowCost);
		TotalAllocated = 0;
		MaxRow = Undefined;
		For Each RowAllocation In AllocationTable.Copy(New Structure("Key", RowCost.Key)) Do
			NewRowAllocationList = ThisObject.AllocationList.Add();
			FillPropertyValues(NewRowAllocationList, RowAllocation);
			NewRowAllocationList.BasisRowID = RowCost.RowID;
			NewRowAllocationList.Amount = (RowCost.Amount / Total) * RowAllocation[ColumnName];
			
			TotalAllocated = TotalAllocated + NewRowAllocationList.Amount;
			If MaxRow = Undefined Then
				MaxRow = NewRowAllocationList;
			Else
				If MaxRow.Amount < NewRowAllocationList.Amount Then
					MaxRow = NewRowAllocationList;
				EndIf;
			EndIf;
		EndDo;
		
		If RowCost.Amount <> TotalAllocated And MaxRow <> Undefined Then
			MaxRow.Amount = MaxRow.Amount + (RowCost.Amount - TotalAllocated);
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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

