
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
		RecordSet = CreateRecordSet();
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
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.Quantity
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Quantity
	|		ELSE 0
	|	END AS Quantity,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.Amount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Amount
	|		ELSE 0
	|	END AS Amount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountTax
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountTax
	|		ELSE 0
	|	END AS AmountTax,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.NotDirectCosts
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.NotDirectCosts
	|		ELSE 0
	|	END AS NotDirectCosts,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCostRatio
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCostRatio
	|		ELSE 0
	|	END AS AmountCostRatio,	
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCostAdditional
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCostAdditional
	|		ELSE 0
	|	END AS AmountCostAdditional,	
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCost
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCost
	|		ELSE 0
	|	END AS AmountCost,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCostTax
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCostTax
	|		ELSE 0
	|	END AS AmountCostTax,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountRevenue
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountRevenue
	|		ELSE 0
	|	END AS AmountRevenue,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountRevenueTax
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountRevenueTax
	|		ELSE 0
	|	END AS AmountRevenueTax,
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCost
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|WHERE
	|	R6010B_BatchWiseBalance.Document = &Document
	|	AND NOT R6010B_BatchWiseBalance.IsSalesConsignorStocks
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.Amount AS Amount,
	|	BatchWiseBalance.AmountTax AS AmountTax,
	|	BatchWiseBalance.NotDirectCosts AS NotDirectCosts,
	|	BatchWiseBalance.AmountCostRatio AS AmountCostRatio,
	|	BatchWiseBalance.AmountCostAdditional AS AmountCostAdditional,
	|	BatchWiseBalance.AmountCost AS AmountCost,
	|
	|	BatchWiseBalance.AmountCostTax AS AmountCostTax,
	|	BatchWiseBalance.AmountRevenue AS AmountRevenue,
	|	BatchWiseBalance.AmountRevenueTax AS AmountRevenueTax,
	|
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
	|	AND (BatchWiseBalance.Amount <> 0
	|	OR BatchWiseBalance.AmountTax <> 0
	|	OR BatchWiseBalance.NotDirectCosts <> 0
	|	OR BatchWiseBalance.AmountCostRatio <> 0
	|	OR BatchWiseBalance.AmountCostAdditional <> 0
	|	OR BatchWiseBalance.AmountCost <> 0
	|	OR BatchWiseBalance.AmountCostTax <> 0
	|	OR BatchWiseBalance.AmountRevenue <> 0
	|	OR BatchWiseBalance.AmountRevenueTax <> 0)";
	
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
	|	AND (CASE
	|				WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|					THEN R6010B_BatchWiseBalance.Document.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales)
	|				ELSE FALSE
	|			END
	|			OR CASE
	|				WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|					THEN R6010B_BatchWiseBalance.Document.TransactionType = VALUE(Enum.SalesReturnTransactionTypes.ReturnFromCustomer)
	|				ELSE FALSE
	|			END
	|			OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|			OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent)
	|
	|GROUP BY
	|	R6010B_BatchWiseBalance.Document
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.Quantity
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Quantity
	|		ELSE 0
	|	END AS Quantity,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.Amount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.Amount
	|		ELSE 0
	|	END AS Amount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountTax
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountTax
	|		ELSE 0
	|	END AS AmountTax,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.NotDirectCosts
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.NotDirectCosts
	|		ELSE 0
	|	END AS NotDirectCosts,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCostRatio
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCostRatio
	|		ELSE 0
	|	END AS AmountCostRatio,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCostAdditional
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCostAdditional
	|		ELSE 0
	|	END AS AmountCostAdditional,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCost
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCost
	|		ELSE 0
	|	END AS AmountCost,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountCostTax
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountCostTax
	|		ELSE 0
	|	END AS AmountCostTax,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountRevenue
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountRevenue
	|		ELSE 0
	|	END AS AmountRevenue,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|				OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AmountRevenueTax
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|				OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AmountRevenueTax
	|		ELSE 0
	|	END AS AmountRevenueTax,
	|
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON R6010B_BatchWiseBalance.Document = AllDocumetsGrouped.Document
	|			AND (NOT R6010B_BatchWiseBalance.IsSalesConsignorStocks)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	|	BatchWiseBalance.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchWiseBalance.Document AS Document,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.Amount AS Amount,
	|	BatchWiseBalance.AmountTax AS AmountTax,
	|	BatchWiseBalance.NotDirectCosts AS NotDirectCosts,
	|	BatchWiseBalance.AmountCostRatio AS AmountCostRatio,
	|	BatchWiseBalance.AmountCostAdditional AS AmountCostAdditional,
	|	BatchWiseBalance.AmountCost AS AmountCost,
	|	BatchWiseBalance.AmountCostTax AS AmountCostTax,
	|	BatchWiseBalance.AmountRevenue AS AmountRevenue,
	|	BatchWiseBalance.AmountRevenueTax AS AmountRevenueTax,
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
	|			AND BatchWiseBalance.Company = T6020S_BatchKeysInfo.Company
	|			AND BatchWiseBalance.ItemKey = T6020S_BatchKeysInfo.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance_BatchKeysInfo.Period AS Period,
	|	BatchWiseBalance_BatchKeysInfo.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchWiseBalance_BatchKeysInfo.Document AS Document,
	|	BatchWiseBalance_BatchKeysInfo.Quantity AS Quantity,
	|	BatchWiseBalance_BatchKeysInfo.Amount AS Amount,
	|	BatchWiseBalance_BatchKeysInfo.AmountTax AS AmountTax,
	|	BatchWiseBalance_BatchKeysInfo.NotDirectCosts AS NotDirectCosts,
	|	BatchWiseBalance_BatchKeysInfo.AmountCostRatio AS AmountCostRatio,
	|	BatchWiseBalance_BatchKeysInfo.AmountCostAdditional AS AmountCostAdditional,
	|	BatchWiseBalance_BatchKeysInfo.AmountCost AS AmountCost,
	|	BatchWiseBalance_BatchKeysInfo.AmountCostTax AS AmountCostTax,
	|	BatchWiseBalance_BatchKeysInfo.AmountRevenue AS AmountRevenue,
	|	BatchWiseBalance_BatchKeysInfo.AmountRevenueTax AS AmountRevenueTax,
	|	BatchWiseBalance_BatchKeysInfo.ItemKey AS ItemKey,
	|	BatchWiseBalance_BatchKeysInfo.Company AS Company,
	|	BatchWiseBalance_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	BatchWiseBalance_BatchKeysInfo.CurrencyMovementType AS CurrencyMovementType,
	|	BatchWiseBalance_BatchKeysInfo.Currency AS Currency
	|FROM
	|	BatchWiseBalance_BatchKeysInfo AS BatchWiseBalance_BatchKeysInfo
	|TOTALS BY
	|	Document";
	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.Document) Then
			Continue;
		EndIf;
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRecord = RecordSet.Add();
			FillPropertyValues(NewRecord, QuerySelectionDetails);
			NewRecord.Recorder = QuerySelection.Document;
			NewRecord.Period   = QuerySelectionDetails.Period;
			NewRecord.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion