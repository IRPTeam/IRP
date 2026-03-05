
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

Function CostOfGoodsSold_CollectRecords(DocObject) Export
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
	|			THEN R6010B_BatchWiseBalance.PreliminaryQuantity
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.PreliminaryQuantity
	|		ELSE 0
	|	END AS PreliminaryQuantity,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.InvoiceAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.InvoiceAmount
	|		ELSE 0
	|	END AS InvoiceAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.InvoiceTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.InvoiceTaxAmount
	|		ELSE 0
	|	END AS InvoiceTaxAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.IndirectCostAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.IndirectCostAmount
	|		ELSE 0
	|	END AS IndirectCostAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.IndirectCostTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.IndirectCostTaxAmount
	|		ELSE 0
	|	END AS IndirectCostTaxAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraCostAmountByRatio
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraCostAmountByRatio
	|		ELSE 0
	|	END AS ExtraCostAmountByRatio,
	|	
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraCostTaxAmountByRatio
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraCostTaxAmountByRatio
	|		ELSE 0
	|	END AS ExtraCostTaxAmountByRatio,
	|	
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraDirectCostAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraDirectCostAmount
	|		ELSE 0
	|	END AS ExtraDirectCostAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraDirectCostTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraDirectCostTaxAmount
	|		ELSE 0
	|	END AS ExtraDirectCostTaxAmount,
	|	
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedCostAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedCostAmount
	|		ELSE 0
	|	END AS AllocatedCostAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedCostTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedCostTaxAmount
	|		ELSE 0
	|	END AS AllocatedCostTaxAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedRevenueAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedRevenueAmount
	|		ELSE 0
	|	END AS AllocatedRevenueAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedRevenueTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedRevenueTaxAmount
	|		ELSE 0
	|	END AS AllocatedRevenueTaxAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.PreliminaryAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.PreliminaryAmount
	|		ELSE 0
	|	END AS PreliminaryAmount,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.PreliminaryTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.PreliminaryTaxAmount
	|		ELSE 0
	|	END AS PreliminaryTaxAmount,
	|
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.BatchKey.SerialLotNumber AS SerialLotNumber, 
	|	R6010B_BatchWiseBalance.BatchKey.SourceOfOrigin AS SourceOfOrigin,
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
	|	BatchWiseBalance.PreliminaryQuantity AS PreliminaryQuantity,
	|	BatchWiseBalance.InvoiceAmount AS InvoiceAmount,
	|	BatchWiseBalance.InvoiceTaxAmount AS InvoiceTaxAmount,
	|
	|	BatchWiseBalance.IndirectCostAmount AS IndirectCostAmount,
	|	BatchWiseBalance.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|
	|	BatchWiseBalance.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	BatchWiseBalance.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|
	|	BatchWiseBalance.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	BatchWiseBalance.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|
	|	BatchWiseBalance.AllocatedCostAmount AS AllocatedCostAmount,
	|	BatchWiseBalance.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|
	|	BatchWiseBalance.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	BatchWiseBalance.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|
	|	BatchWiseBalance.PreliminaryAmount AS PreliminaryAmount,
	|	BatchWiseBalance.PreliminaryTaxAmount AS PreliminaryTaxAmount,
	|
	|	BatchWiseBalance.ItemKey AS ItemKey,
	|	BatchWiseBalance.SerialLotNumber AS SerialLotNumber,
	|	BatchWiseBalance.SourceOfOrigin AS SourceOfOrigin,
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
	|		AND BatchWiseBalance.SerialLotNumber = T6020S_BatchKeysInfo.SerialLotNumber
	|		AND BatchWiseBalance.SourceOfOrigin = T6020S_BatchKeysInfo.SourceOfOrigin
	|WHERE
	|	BatchWiseBalance.Quantity <> 0	
	|	AND (BatchWiseBalance.InvoiceAmount <> 0
	|	OR BatchWiseBalance.InvoiceTaxAmount <> 0
	|
	|	OR BatchWiseBalance.IndirectCostAmount <> 0
	|	OR BatchWiseBalance.IndirectCostTaxAmount <> 0
	|
	|	OR BatchWiseBalance.ExtraCostAmountByRatio <> 0
	|	OR BatchWiseBalance.ExtraCostTaxAmountByRatio <> 0
	|
	|	OR BatchWiseBalance.ExtraDirectCostAmount <> 0
	|	OR BatchWiseBalance.ExtraDirectCostTaxAmount <> 0
	|
	|	OR BatchWiseBalance.AllocatedCostAmount <> 0
	|	OR BatchWiseBalance.AllocatedCostTaxAmount <> 0
	|
	|	OR BatchWiseBalance.AllocatedRevenueAmount <> 0
	|	OR BatchWiseBalance.AllocatedRevenueTaxAmount <> 0
	|
	|	OR BatchWiseBalance.PreliminaryAmount <> 0
	|	OR BatchWiseBalance.PreliminaryTaxAmount <> 0)";
	
	Query.SetParameter("Document", DocObject.Ref);
	Return Query.Execute().Unload();
EndFunction

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
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|			THEN R6010B_BatchWiseBalance.Document.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales)
	|		ELSE FALSE
	|	END
	|	OR CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|			THEN R6010B_BatchWiseBalance.Document.TransactionType = VALUE(Enum.SalesReturnTransactionTypes.ReturnFromCustomer)
	|		ELSE FALSE
	|	END
	|	OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|	OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|	OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent)
	|GROUP BY
	|	R6010B_BatchWiseBalance.Document
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS CalculationMovementCosts,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|
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
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.PreliminaryQuantity
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.PreliminaryQuantity
	|		ELSE 0
	|	END AS PreliminaryQuantity,
	|
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.InvoiceAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.InvoiceAmount
	|		ELSE 0
	|	END AS InvoiceAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.InvoiceTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.InvoiceTaxAmount
	|		ELSE 0
	|	END AS InvoiceTaxAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.IndirectCostAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.IndirectCostAmount
	|		ELSE 0
	|	END AS IndirectCostAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.IndirectCostTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.IndirectCostTaxAmount
	|		ELSE 0
	|	END AS IndirectCostTaxAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraCostAmountByRatio
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraCostAmountByRatio
	|		ELSE 0
	|	END AS ExtraCostAmountByRatio,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraCostTaxAmountByRatio
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraCostTaxAmountByRatio
	|		ELSE 0
	|	END AS ExtraCostTaxAmountByRatio,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraDirectCostAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraDirectCostAmount
	|		ELSE 0
	|	END AS ExtraDirectCostAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.ExtraDirectCostTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.ExtraDirectCostTaxAmount
	|		ELSE 0
	|	END AS ExtraDirectCostTaxAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedCostAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedCostAmount
	|		ELSE 0
	|	END AS AllocatedCostAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedCostTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedCostTaxAmount
	|		ELSE 0
	|	END AS AllocatedCostTaxAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedRevenueAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedRevenueAmount
	|		ELSE 0
	|	END AS AllocatedRevenueAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.AllocatedRevenueTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.AllocatedRevenueTaxAmount
	|		ELSE 0
	|	END AS AllocatedRevenueTaxAmount,
	|	
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.PreliminaryAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.PreliminaryAmount
	|		ELSE 0
	|	END AS PreliminaryAmount,
	|	CASE
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesInvoice
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailSalesReceipt
	|		OR R6010B_BatchWiseBalance.Document REFS Document.SalesReportFromTradeAgent
	|			THEN R6010B_BatchWiseBalance.PreliminaryTaxAmount
	|		WHEN R6010B_BatchWiseBalance.Document REFS Document.SalesReturn
	|		OR R6010B_BatchWiseBalance.Document REFS Document.RetailReturnReceipt
	|			THEN -R6010B_BatchWiseBalance.PreliminaryTaxAmount
	|		ELSE 0
	|	END AS PreliminaryTaxAmount,
	|
	|	R6010B_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	R6010B_BatchWiseBalance.BatchKey.SerialLotNumber AS SerialLotNumber,
	|	R6010B_BatchWiseBalance.BatchKey.SourceOfOrigin AS SourceOfOrigin,
	|	R6010B_BatchWiseBalance.Batch.Company AS Company
	|INTO BatchWiseBalance
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|		INNER JOIN AllDocumetsGrouped AS AllDocumetsGrouped
	|		ON R6010B_BatchWiseBalance.Document = AllDocumetsGrouped.Document
	|		AND (NOT R6010B_BatchWiseBalance.IsSalesConsignorStocks)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance.Period AS Period,
	|	BatchWiseBalance.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchWiseBalance.Document AS Document,
	|	BatchWiseBalance.Quantity AS Quantity,
	|	BatchWiseBalance.PreliminaryQuantity AS PreliminaryQuantity,
	|	BatchWiseBalance.InvoiceAmount AS InvoiceAmount,
	|	BatchWiseBalance.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	BatchWiseBalance.IndirectCostAmount AS IndirectCostAmount,
	|	BatchWiseBalance.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	BatchWiseBalance.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	BatchWiseBalance.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	BatchWiseBalance.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	BatchWiseBalance.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	BatchWiseBalance.AllocatedCostAmount AS AllocatedCostAmount,
	|	BatchWiseBalance.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	BatchWiseBalance.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	BatchWiseBalance.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	BatchWiseBalance.PreliminaryAmount AS PreliminaryAmount,
	|	BatchWiseBalance.PreliminaryTaxAmount AS PreliminaryTaxAmount,
	|	BatchWiseBalance.ItemKey AS ItemKey,
	|	BatchWiseBalance.SerialLotNumber AS SerialLotNumber,
	|	BatchWiseBalance.SourceOfOrigin AS SourceOfOrigin,
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
	|		AND BatchWiseBalance.SerialLotNumber = T6020S_BatchKeysInfo.SerialLotNumber
	|		AND BatchWiseBalance.SourceOfOrigin = T6020S_BatchKeysInfo.SourceOfOrigin
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchWiseBalance_BatchKeysInfo.Period AS Period,
	|	BatchWiseBalance_BatchKeysInfo.CalculationMovementCosts AS CalculationMovementCosts,
	|	BatchWiseBalance_BatchKeysInfo.Document AS Document,
	|	BatchWiseBalance_BatchKeysInfo.Quantity AS Quantity,
	|	BatchWiseBalance_BatchKeysInfo.PreliminaryQuantity AS PreliminaryQuantity,
	|	BatchWiseBalance_BatchKeysInfo.InvoiceAmount AS InvoiceAmount,
	|	BatchWiseBalance_BatchKeysInfo.InvoiceTaxAmount AS InvoiceTaxAmount,
	|	BatchWiseBalance_BatchKeysInfo.IndirectCostAmount AS IndirectCostAmount,
	|	BatchWiseBalance_BatchKeysInfo.IndirectCostTaxAmount AS IndirectCostTaxAmount,
	|	BatchWiseBalance_BatchKeysInfo.ExtraCostAmountByRatio AS ExtraCostAmountByRatio,
	|	BatchWiseBalance_BatchKeysInfo.ExtraCostTaxAmountByRatio AS ExtraCostTaxAmountByRatio,
	|	BatchWiseBalance_BatchKeysInfo.ExtraDirectCostAmount AS ExtraDirectCostAmount,
	|	BatchWiseBalance_BatchKeysInfo.ExtraDirectCostTaxAmount AS ExtraDirectCostTaxAmount,
	|	BatchWiseBalance_BatchKeysInfo.AllocatedCostAmount AS AllocatedCostAmount,
	|	BatchWiseBalance_BatchKeysInfo.AllocatedCostTaxAmount AS AllocatedCostTaxAmount,
	|	BatchWiseBalance_BatchKeysInfo.AllocatedRevenueAmount AS AllocatedRevenueAmount,
	|	BatchWiseBalance_BatchKeysInfo.AllocatedRevenueTaxAmount AS AllocatedRevenueTaxAmount,
	|	BatchWiseBalance_BatchKeysInfo.PreliminaryAmount AS PreliminaryAmount,
	|	BatchWiseBalance_BatchKeysInfo.PreliminaryTaxAmount AS PreliminaryTaxAmount,
	|	BatchWiseBalance_BatchKeysInfo.ItemKey AS ItemKey,
	|	BatchWiseBalance_BatchKeysInfo.SerialLotNumber AS SerialLotNumber,
	|	BatchWiseBalance_BatchKeysInfo.SourceOfOrigin AS SourceOfOrigin,
	|	BatchWiseBalance_BatchKeysInfo.Company AS Company,
	|	BatchWiseBalance_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	BatchWiseBalance_BatchKeysInfo.CurrencyMovementType AS CurrencyMovementType,
	|	BatchWiseBalance_BatchKeysInfo.Currency AS Currency
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
		
		Parameters = New Structure();
		Parameters.Insert("Object", QuerySelection.Document);
		Parameters.Insert("PostingByRef", True);
		Parameters.Insert("Metadata", QuerySelection.Document.Metadata());
		Parameters.Insert("PostingDataTables", New Map());
		
		RecordsTable = RecordSet.Unload();
		RecordsTable.Columns.Delete("PointIntime");
		
		RegMetadata = Metadata.AccumulationRegisters.R6060T_CostOfGoodsSold;
		PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, RegMetadata.Name, RecordsTable);
		Parameters.PostingDataTables[RegMetadata].WriteInTransaction = False;
	
		CurrenciesTableParams = New Structure();
		CurrenciesTableParams.Insert("Ref"            , Parameters.Object);
		CurrenciesTableParams.Insert("Date"           , Parameters.Object.Date);
		CurrenciesTableParams.Insert("Company"        , Parameters.Object.Company);
		CurrenciesTableParams.Insert("Currency"       , Parameters.Object.Company.LandedCostCurrencyMovementType.Currency);
		CurrenciesTableParams.Insert("Agreement"      , Undefined);
		CurrenciesTableParams.Insert("RowKey"         , "");
		CurrenciesTableParams.Insert("DocumentAmount" , 0);
		CurrenciesTableParams.Insert("Currencies"     , New Array());
		
		CurrenciesTable = Parameters.Object.Currencies.UnloadColumns();
		CurrenciesServer.UpdateCurrencyTable(CurrenciesTableParams, CurrenciesTable);
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrenciesTable);
		CurrenciesServer.ExcludePostingDataTable(Parameters, RegMetadata);
		
		RecordSet.Load(Parameters.PostingDataTables[RegMetadata].PrepareTable);
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
// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure