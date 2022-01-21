
Procedure CostOfGoodsSold_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_CostOfGoodsSold.Recorder
	|FROM
	|	AccumulationRegister.LC_CostOfGoodsSold AS LC_CostOfGoodsSold
	|WHERE
	|	LC_CostOfGoodsSold.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	LC_CostOfGoodsSold.Recorder";
	Query.SetParameter("CalculationMovementCost", DocObjectRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		RecordSet = AccumulationRegisters.LC_CostOfGoodsSold.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Recorder);
		//
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
		//
		//RecordSet.Clear();
		RecordSet.Write();
	EndDo;
EndProcedure

Procedure CostOfGoodsSold_CollectRecords(DocObject) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	|	CASE
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN LC_BatchWiseBalance.Quantity
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -LC_BatchWiseBalance.Quantity
	|		ELSE 0
	|	END AS Quantity,
	|	CASE
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN LC_BatchWiseBalance.Amount
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -LC_BatchWiseBalance.Amount
	|		ELSE 0
	|	END AS Amount,
	|	CASE
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN LC_BatchWiseBalance.AmountCost
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -LC_BatchWiseBalance.AmountCost
	|		ELSE 0
	|	END AS AmountCost,
	|	LC_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	LC_BatchWiseBalance.Batch.Company AS Company,
	|	LC_BatchWiseBalance.Recorder AS CalculationMovementCost
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|WHERE
	|	LC_BatchWiseBalance.Document = &Document
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.Amount AS Amount,
	|	BatchWiseBalance.Amount AS AmountCost,
	|	BatchWiseBalance.ItemKey AS ItemKey,
	|	BatchWiseBalance.Company AS Company,
	|	CASE
	|		WHEN LC_BatchKeysInfo.SalesInvoice.Ref IS NULL
	|			THEN &Document
	|		ELSE LC_BatchKeysInfo.SalesInvoice
	|	END AS SalesInvoice,
	|	BatchWiseBalance.CalculationMovementCost,
	|	BatchWiseBalance.Company.LC_LandedCostCurrencyMovementType AS CurrencyMovementType,
	|	BatchWiseBalance.Company.LC_LandedCostCurrencyMovementType.Currency AS Currency
	|FROM
	|	BatchWiseBalance AS BatchWiseBalance
	|		LEFT JOIN InformationRegister.LC_BatchKeysInfo AS LC_BatchKeysInfo
	|		ON LC_BatchKeysInfo.Recorder = &Document
	|		AND BatchWiseBalance.Company = LC_BatchKeysInfo.Company
	|		AND BatchWiseBalance.ItemKey = LC_BatchKeysInfo.ItemKey
	|WHERE
	|	(BatchWiseBalance.Quantity <> 0
	|	AND BatchWiseBalance.Amount <> 0) OR (BatchWiseBalance.AmountCost <> 0)";
	
	Query.SetParameter("Document", DocObject.Ref);
	QueryResult = Query.Execute();
	DocObject.RegisterRecords.LC_CostOfGoodsSold.Load(QueryResult.Unload());
EndProcedure

Procedure CostOfGoodsSold_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchWiseBalance.Document AS Document
	|INTO AllDocumetsGrouped
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|WHERE
	|	LC_BatchWiseBalance.Recorder = &Recorder
	|	AND (LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|	OR LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|	OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|	OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt)
	|GROUP BY
	|	LC_BatchWiseBalance.Document
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	//
	| 	LC_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	//
	|	LC_BatchWiseBalance.Document AS Document,
	|	CASE
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN LC_BatchWiseBalance.Quantity
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -LC_BatchWiseBalance.Quantity
	|		ELSE 0
	|	END AS Quantity,
	|	CASE
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN LC_BatchWiseBalance.Amount
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -LC_BatchWiseBalance.Amount
	|		ELSE 0
	|	END AS Amount,
	|	CASE
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			THEN LC_BatchWiseBalance.AmountCost
	|		WHEN LC_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR LC_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -LC_BatchWiseBalance.AmountCost
	|		ELSE 0
	|	END AS AmountCost,
	|	LC_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	LC_BatchWiseBalance.Batch.Company AS Company
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON LC_BatchWiseBalance.Document = AllDocumetsGrouped.Document
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	//
	| 	BatchWiseBalance.CalculationMovementCosts AS CalculationMovementCosts,
	//
	|	BatchWiseBalance.Document AS Document,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.Amount AS Amount,
	|	BatchWiseBalance.AmountCost AS AmountCost,
	|	BatchWiseBalance.ItemKey AS ItemKey,
	|	BatchWiseBalance.Company AS Company,
	|	CASE
	|		WHEN LC_BatchKeysInfo.SalesInvoice.Ref IS NULL
	|			THEN BatchWiseBalance.Document
	|		ELSE LC_BatchKeysInfo.SalesInvoice
	|	END AS SalesInvoice,
	|	BatchWiseBalance.Company.LC_LandedCostCurrencyMovementType AS CurrencyMovementType,
	|	BatchWiseBalance.Company.LC_LandedCostCurrencyMovementType.Currency AS Currency
	|INTO BatchWiseBalance_BatchKeysInfo
	|FROM
	|	BatchWiseBalance AS BatchWiseBalance
	|		LEFT JOIN InformationRegister.LC_BatchKeysInfo AS LC_BatchKeysInfo
	|		ON BatchWiseBalance.Document = LC_BatchKeysInfo.Recorder
	|		AND BatchWiseBalance.Company = LC_BatchKeysInfo.Company
	|		AND BatchWiseBalance.ItemKey = LC_BatchKeysInfo.ItemKey
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance_BatchKeysInfo.Period,
	//
	| 	BatchWiseBalance_BatchKeysInfo.CalculationMovementCosts AS CalculationMovementCosts,
	//
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
		RecordSet = AccumulationRegisters.LC_CostOfGoodsSold.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRecord = RecordSet.Add();
			FillPropertyValues(NewRecord, QuerySelectionDetails);
			NewRecord.Recorder = QuerySelection.Document;
			NewRecord.Period = QuerySelectionDetails.Period;
			NewRecord.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;//CalculationMovementCostRef;
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure