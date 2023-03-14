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
	|	R6080T_OtherPeriodsRevenuesBalance.ItemKey,
	|	R6080T_OtherPeriodsRevenuesBalance.AmountBalance AS Amount
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
	|	T6020S_BatchKeysInfo.Amount
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		INNER JOIN AllocationDocuments AS AllocationDocuments
	|		ON AllocationDocuments.Document = T6020S_BatchKeysInfo.Recorder
	|		AND T6020S_BatchKeysInfo.Direction = VALUE(Enum.BatchDirection.Receipt)
	|		AND T6020S_BatchKeysInfo.RowID <> """"";
	
	Query.SetParameter("RevenueDocuments", ThisObject.RevenueDocuments.Unload());
	Query.SetParameter("AllocationDocuments", ThisObject.AllocationDocuments.Unload());
	Query.SetParameter("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
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
	
	Total = AllocationTable.Total(ColumnName);
	
	If Total = 0 Then
		Return;
	EndIf;
	
	For Each RowRevenue In RevenueTable Do
		FillPropertyValues(ThisObject.RevenueList.Add(), RowRevenue);
		TotalAllocated = 0;
		MaxRow = Undefined;
		For Each RowAllocation In AllocationTable.Copy(New Structure("Key", RowRevenue.Key)) Do
			NewRowAllocationList = ThisObject.AllocationList.Add();
			FillPropertyValues(NewRowAllocationList, RowAllocation);
			NewRowAllocationList.BasisRowID = RowRevenue.RowID;
			NewRowAllocationList.Amount = (RowRevenue.Amount / Total) * RowAllocation[ColumnName];
			
			TotalAllocated = TotalAllocated + NewRowAllocationList.Amount;
			If MaxRow = Undefined Then
				MaxRow = NewRowAllocationList;
			Else
				If MaxRow.Amount < NewRowAllocationList.Amount Then
					MaxRow = NewRowAllocationList;
				EndIf;
			EndIf;
		EndDo;
		
		If RowRevenue.Amount <> TotalAllocated And MaxRow <> Undefined Then
			MaxRow.Amount = MaxRow.Amount + (RowRevenue.Amount - TotalAllocated);
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

