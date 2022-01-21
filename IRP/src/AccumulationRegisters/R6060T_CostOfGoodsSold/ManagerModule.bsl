
Procedure CostOfGoodsSold_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R6060T_CostOfGoodsSold.Recorder
	|FROM
	|	AccumulationRegister.R6060T_CostOfGoodsSold AS R6060T_CostOfGoodsSold
	|WHERE
	|	R6060T_CostOfGoodsSold.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	R6060T_CostOfGoodsSold.Recorder";
	Query.SetParameter("CalculationMovementCost", DocObjectRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		RecordSet = AccumulationRegisters.R6060T_CostOfGoodsSold.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Recorder);
		
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Row In RecordSet Do
			If Row.CalculationMovementCost = DocObjectRef Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		
		RecordSet.Write();
	EndDo;
EndProcedure

Procedure CostOfGoodsSold_CollectRecords(DocObject) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN R6010B_BatchWiseBalance.Quantity
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Quantity
	|		ELSE 0
	|	END AS Quantity,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN R6010B_BatchWiseBalance.Amount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Amount
	|		ELSE 0
	|	END AS Amount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN R6010B_BatchWiseBalance.AmountCost
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCost
	|		ELSE 0
	|	END AS AmountCost,
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCost
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|WHERE
	|	R6010B_BatchWiseBalance.Document = &Document
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.Amount AS Amount,
	|	BatchWiseBalance.Amount AS AmountCost,
	|	BatchWiseBalance.ItemKey AS ItemKey,
	|	BatchWiseBalance.Company AS Company,
	|	CASE
	|		WHEN T6020S_BatchKeysInfo.SalesInvoice.Ref IS NULL
	|			THEN &Document
	|		ELSE T6020S_BatchKeysInfo.SalesInvoice
	|	END AS SalesInvoice,
	|	BatchWiseBalance.CalculationMovementCost,
	|	BatchWiseBalance.Company.LandedCostCurrencyMovementType AS CurrencyMovementType,
	|	BatchWiseBalance.Company.LandedCostCurrencyMovementType.Currency AS Currency
	|FROM
	|	BatchWiseBalance AS BatchWiseBalance
	|		LEFT JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON T6020S_BatchKeysInfo.Recorder = &Document
	|		AND BatchWiseBalance.Company = T6020S_BatchKeysInfo.Company
	|		AND BatchWiseBalance.ItemKey = T6020S_BatchKeysInfo.ItemKey
	|WHERE
	|	BatchWiseBalance.Quantity <> 0
	|	AND BatchWiseBalance.Amount <> 0
	|	OR BatchWiseBalance.AmountCost <> 0";
	
	Query.SetParameter("Document", DocObject.Ref);
	QueryResult = Query.Execute();
	DocObject.RegisterRecords.R6060T_CostOfGoodsSold.Load(QueryResult.Unload());
EndProcedure

Procedure CostOfGoodsSold_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R6010B_BatchWiseBalance.Document AS Document
	|INTO AllDocumetsGrouped
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|WHERE
	|	R6010B_BatchWiseBalance.Recorder = &Recorder
	|	AND (R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|	OR R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|	OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|	OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt)
	|GROUP BY
	|	R6010B_BatchWiseBalance.Document
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN R6010B_BatchWiseBalance.Quantity
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Quantity
	|		ELSE 0
	|	END AS Quantity,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN R6010B_BatchWiseBalance.Amount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Amount
	|		ELSE 0
	|	END AS Amount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN R6010B_BatchWiseBalance.AmountCost
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCost
	|		ELSE 0
	|	END AS AmountCost,
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON R6010B_BatchWiseBalance.Document = AllDocumetsGrouped.Document
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	|	BatchWiseBalance.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchWiseBalance.Document AS Document,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.Amount AS Amount,
	|	BatchWiseBalance.AmountCost AS AmountCost,
	|	BatchWiseBalance.ItemKey AS ItemKey,
	|	BatchWiseBalance.Company AS Company,
	|	CASE
	|		WHEN T6020S_BatchKeysInfo.SalesInvoice.Ref IS NULL
	|			THEN BatchWiseBalance.Document
	|		ELSE T6020S_BatchKeysInfo.SalesInvoice
	|	END AS SalesInvoice,
	|	BatchWiseBalance.Company.LandedCostCurrencyMovementType AS CurrencyMovementType,
	|	BatchWiseBalance.Company.LandedCostCurrencyMovementType.Currency AS Currency
	|INTO BatchWiseBalance_BatchKeysInfo
	|FROM
	|	BatchWiseBalance AS BatchWiseBalance
	|		LEFT JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON BatchWiseBalance.Document = T6020S_BatchKeysInfo.Recorder
	|		AND BatchWiseBalance.Company = T6020S_BatchKeysInfo.Company
	|		AND BatchWiseBalance.ItemKey = T6020S_BatchKeysInfo.ItemKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance_BatchKeysInfo.Period,
	|	BatchWiseBalance_BatchKeysInfo.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchWiseBalance_BatchKeysInfo.Document AS Document,
	|	BatchWiseBalance_BatchKeysInfo.Quantity,
	|	BatchWiseBalance_BatchKeysInfo.Amount,
	|	BatchWiseBalance_BatchKeysInfo.AmountCost,
	|	BatchWiseBalance_BatchKeysInfo.ItemKey,
	|	BatchWiseBalance_BatchKeysInfo.Company,
	|	BatchWiseBalance_BatchKeysInfo.SalesInvoice,
	|	BatchWiseBalance_BatchKeysInfo.CurrencyMovementType,
	|	BatchWiseBalance_BatchKeysInfo.Currency
	|FROM
	|	BatchWiseBalance_BatchKeysInfo AS BatchWiseBalance_BatchKeysInfo
	|TOTALS
	|BY
	|	Document";
	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.Document) Then
			Continue;
		EndIf;
		RecordSet = AccumulationRegisters.R6060T_CostOfGoodsSold.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRecord = RecordSet.Add();
			FillPropertyValues(NewRecord, QuerySelectionDetails);
			NewRecord.Recorder = QuerySelection.Document;
			NewRecord.Period = QuerySelectionDetails.Period;
			NewRecord.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure