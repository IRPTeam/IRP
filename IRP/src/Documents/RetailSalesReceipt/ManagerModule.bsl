#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("StockReservation", PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("SalesTurnovers", PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("StockBalance", PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("TaxesTurnovers", PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("RevenuesTurnovers", PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	Tables.Insert("AccountBalance", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("RetailSales", PostingServer.CreateTable(AccReg.RetailSales));
	Tables.Insert("RetailCash", PostingServer.CreateTable(AccReg.RetailCash));
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextRetailSalesReceiptItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultItemList.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	// UUID to String
	QueryTableItemList.Columns.Add("RowKey", 
		Metadata.AccumulationRegisters.TaxesTurnovers.Dimensions.RowKey.Type);
	For Each Row In QueryTableItemList Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
	QueryTaxList = New Query();
	QueryTaxList.Text = GetQueryTextRetailSalesReceiptTaxList();
	QueryTaxList.SetParameter("Ref", Ref);
	QueryResultTaxList = QueryTaxList.Execute();
	QueryTableTaxList = QueryResultTaxList.Unload();
	// UUID to String
	QueryTableTaxList.Columns.Add("RowKey", Metadata.AccumulationRegisters.TaxesTurnovers.Dimensions.RowKey.Type);
	For Each Row In QueryTableTaxList Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextRetailSalesReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultPaymentList.Unload();
	
	QuerySalesTurnovers = New Query();
	QuerySalesTurnovers.Text = GetQueryTextRetailSalesReceiptSalesTurnovers();
	QuerySalesTurnovers.SetParameter("Ref", Ref);
	QueryResultSalesTurnovers = QuerySalesTurnovers.Execute();
	QueryTableSalesTurnovers = QueryResultSalesTurnovers.Unload();
	
	QueryRetailSales = New Query();
	QueryRetailSales.Text = GetQueryText_RetailSalesReceipt_RetailSales();
	QueryRetailSales.SetParameter("Ref", Ref);
	QueryResultRetailSales = QueryRetailSales.Execute();
	QueryTableRetailSales = QueryResultRetailSales.Unload();
	
	QueryRetailCash = New Query();
	QueryRetailCash.Text = GetQueryText_RetailSalesReceipt_RetailCash();
	QueryRetailCash.SetParameter("Ref", Ref);
	QueryResultRetailCash = QueryRetailCash.Execute();
	QueryTableRetailCash = QueryResultRetailCash.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResult = Query.ExecuteBatch();
	
	Tables.StockReservation = QueryResult[1].Unload();
	Tables.StockBalance = QueryResult[2].Unload();
	Tables.RevenuesTurnovers = QueryResult[3].Unload();
	
	Tables.TaxesTurnovers = QueryTableTaxList;
	Tables.AccountBalance = QueryTablePaymentList;
	Tables.SalesTurnovers = QueryTableSalesTurnovers;
	Tables.RetailSales = QueryTableRetailSales;
	Tables.RetailCash = QueryTableRetailCash;
	Return Tables;
EndFunction

Function GetQueryTextRetailSalesReceiptItemList()
	Return
		"SELECT
		|	RetailSalesReceiptItemList.Ref.Company AS Company,
		|	RetailSalesReceiptItemList.Store AS Store,
		|	RetailSalesReceiptItemList.ItemKey AS ItemKey,
		|	RetailSalesReceiptItemList.Quantity AS Quantity,
		|	RetailSalesReceiptItemList.TotalAmount AS TotalAmount,
		|	RetailSalesReceiptItemList.Ref.Partner AS Partner,
		|	RetailSalesReceiptItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND RetailSalesReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN RetailSalesReceiptItemList.Ref.Agreement.StandardAgreement
		|		ELSE RetailSalesReceiptItemList.Ref.Agreement
		|	END AS Agreement,
		|	RetailSalesReceiptItemList.Ref.Currency AS Currency,
		|	0 AS BasisQuantity,
		|	RetailSalesReceiptItemList.Unit AS Unit,
		|	RetailSalesReceiptItemList.ItemKey.Item.Unit AS ItemUnit,
		|	RetailSalesReceiptItemList.ItemKey.Unit AS ItemKeyUnit,
		|	RetailSalesReceiptItemList.ItemKey.Item AS Item,
		|	RetailSalesReceiptItemList.Ref.Date AS Period,
		|	RetailSalesReceiptItemList.Ref AS RetailSalesReceipt,
		|	RetailSalesReceiptItemList.Key AS RowKeyUUID,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	RetailSalesReceiptItemList.BusinessUnit AS BusinessUnit,
		|	RetailSalesReceiptItemList.RevenueType AS RevenueType,
		|	RetailSalesReceiptItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN RetailSalesReceiptItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	RetailSalesReceiptItemList.NetAmount AS NetAmount,
		|	RetailSalesReceiptItemList.OffersAmount AS OffersAmount
		|FROM
		|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
		|WHERE
		|	RetailSalesReceiptItemList.Ref = &Ref";
EndFunction

Function GetQueryTextRetailSalesReceiptTaxList()
	Return
			"SELECT
			|	RetailSalesReceiptTaxList.Ref AS Document,
			|	RetailSalesReceiptTaxList.Ref.Date AS Period,
			|	RetailSalesReceiptTaxList.Ref.Currency AS Currency,
			|	RetailSalesReceiptTaxList.Key AS RowKeyUUID,
			|	RetailSalesReceiptTaxList.Tax AS Tax,
			|	RetailSalesReceiptTaxList.Analytics AS Analytics,
			|	RetailSalesReceiptTaxList.TaxRate AS TaxRate,
			|	RetailSalesReceiptTaxList.Amount AS Amount,
			|	RetailSalesReceiptTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
			|	RetailSalesReceiptTaxList.ManualAmount AS ManualAmount,
			|	RetailSalesReceiptItemList.NetAmount AS NetAmount
			|FROM
			|	Document.RetailSalesReceipt.TaxList AS RetailSalesReceiptTaxList
			|		INNER JOIN Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
			|		ON RetailSalesReceiptTaxList.Ref = RetailSalesReceiptItemList.Ref
			|		AND RetailSalesReceiptItemList.Ref = &Ref
			|		AND RetailSalesReceiptTaxList.Ref = &Ref
			|		AND RetailSalesReceiptItemList.Key = RetailSalesReceiptTaxList.Key
			|WHERE
			|	RetailSalesReceiptTaxList.Ref = &Ref";
EndFunction

Function GetQueryTextRetailSalesReceiptPaymentList()
	Return "SELECT
		   |	RetailSalesReceiptPayments.Ref.Company,
		   |	RetailSalesReceiptPayments.Ref.Currency,
		   |	RetailSalesReceiptPayments.Account,
		   |	SUM(RetailSalesReceiptPayments.Amount) AS Amount,
		   |	RetailSalesReceiptPayments.Ref.Date AS Period
		   |FROM
		   |	Document.RetailSalesReceipt.Payments AS RetailSalesReceiptPayments
		   |WHERE
		   |	RetailSalesReceiptPayments.Ref = &Ref
		   |GROUP BY
		   |	RetailSalesReceiptPayments.Ref.Company,
		   |	RetailSalesReceiptPayments.Ref.Currency,
		   |	RetailSalesReceiptPayments.Account,
		   |	RetailSalesReceiptPayments.Ref.Date";
EndFunction	

Function GetQueryText_RetailSalesReceipt_RetailCash()
	Return 
	"SELECT
	|	RetailSalesReceiptPayments.Ref.Company,
	|	RetailSalesReceiptPayments.Ref.BusinessUnit,
	|	RetailSalesReceiptPayments.Ref.Currency,
	|	RetailSalesReceiptPayments.Account,
	|	SUM(RetailSalesReceiptPayments.Amount) AS Amount,
	|	RetailSalesReceiptPayments.Ref.Date AS Period,
	|	RetailSalesReceiptPayments.PaymentType,
	|	RetailSalesReceiptPayments.PaymentTerminal,
	|	RetailSalesReceiptPayments.BankTerm,
	|	RetailSalesReceiptPayments.Percent,
	|	SUM(RetailSalesReceiptPayments.Commission) AS Commission
	|FROM
	|	Document.RetailSalesReceipt.Payments AS RetailSalesReceiptPayments
	|WHERE
	|	RetailSalesReceiptPayments.Ref = &Ref
	|GROUP BY
	|	RetailSalesReceiptPayments.Ref.Company,
	|	RetailSalesReceiptPayments.Ref.BusinessUnit,
	|	RetailSalesReceiptPayments.Ref.Currency,
	|	RetailSalesReceiptPayments.Account,
	|	RetailSalesReceiptPayments.Ref.Date,
	|	RetailSalesReceiptPayments.PaymentType,
	|	RetailSalesReceiptPayments.PaymentTerminal,
	|	RetailSalesReceiptPayments.BankTerm,
	|	RetailSalesReceiptPayments.Percent";
EndFunction

Function GetQueryTextRetailSalesReceiptSalesTurnovers()
	Return "SELECT
	|	RetailSalesReceiptItemList.Ref.Company AS Company,
	|	RetailSalesReceiptItemList.Ref.Currency AS Currency,
	|	RetailSalesReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailSalesReceiptItemList.Quantity) AS Quantity,
	|	SUM(ISNULL(RetailSalesReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailSalesReceiptItemList.Ref.Date AS Period,
	|	RetailSalesReceiptItemList.Ref AS RetailSalesReceipt,
	|	SUM(RetailSalesReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailSalesReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailSalesReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailSalesReceiptItemList.Key AS RowKey,
	|	RetailSalesReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber
	|INTO tmp
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|		LEFT JOIN Document.RetailSalesReceipt.SerialLotNumbers AS RetailSalesReceiptSerialLotNumbers
	|		ON RetailSalesReceiptItemList.Key = RetailSalesReceiptSerialLotNumbers.Key
	|		AND RetailSalesReceiptItemList.Ref = RetailSalesReceiptSerialLotNumbers.Ref
	|		AND RetailSalesReceiptItemList.Ref = &Ref
	|		AND RetailSalesReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailSalesReceiptItemList.Ref.Company,
	|	RetailSalesReceiptItemList.Ref.Currency,
	|	RetailSalesReceiptItemList.ItemKey,
	|	RetailSalesReceiptItemList.Ref.Date,
	|	RetailSalesReceiptItemList.Ref,
	|	RetailSalesReceiptItemList.Key,
	|	RetailSalesReceiptSerialLotNumbers.SerialLotNumber
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.Currency AS Currency,
	|	tmp.ItemKey AS ItemKey,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN tmp.Quantity
	|		ELSE tmp.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmp.Period AS Period,
	|	tmp.RetailSalesReceipt AS RetailSalesReceipt,
	|	tmp.RowKey AS RowKey,
	|	tmp.SerialLotNumber AS SerialLotNumber,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.OffersAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.OffersAmount
	|	END AS OffersAmount
	|FROM
	|	tmp AS tmp";
EndFunction

Function GetQueryText_RetailSalesReceipt_RetailSales()
	Return 
	"SELECT
	|	RetailSalesReceiptItemList.Ref.Company AS Company,
	|	RetailSalesReceiptItemList.Ref.BusinessUnit AS BusinessUnit,
	|	RetailSalesReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailSalesReceiptItemList.Quantity) AS Quantity,
	|	SUM(ISNULL(RetailSalesReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailSalesReceiptItemList.Ref.Date AS Period,
	|	RetailSalesReceiptItemList.Ref AS RetailSalesReceipt,
	|	SUM(RetailSalesReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailSalesReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailSalesReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailSalesReceiptItemList.Key AS RowKey,
	|	RetailSalesReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber,
	|	RetailSalesReceiptItemList.Store
	|INTO tmp
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|		LEFT JOIN Document.RetailSalesReceipt.SerialLotNumbers AS RetailSalesReceiptSerialLotNumbers
	|		ON RetailSalesReceiptItemList.Key = RetailSalesReceiptSerialLotNumbers.Key
	|		AND RetailSalesReceiptItemList.Ref = RetailSalesReceiptSerialLotNumbers.Ref
	|		AND RetailSalesReceiptItemList.Ref = &Ref
	|		AND RetailSalesReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailSalesReceiptItemList.Ref.Company,
	|	RetailSalesReceiptItemList.Ref.BusinessUnit,
	|	RetailSalesReceiptItemList.ItemKey,
	|	RetailSalesReceiptItemList.Ref.Date,
	|	RetailSalesReceiptItemList.Ref,
	|	RetailSalesReceiptItemList.Key,
	|	RetailSalesReceiptSerialLotNumbers.SerialLotNumber,
	|	RetailSalesReceiptItemList.Store
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.BusinessUnit AS BusinessUnit,
	|	tmp.ItemKey AS ItemKey,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN tmp.Quantity
	|		ELSE tmp.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmp.Period AS Period,
	|	tmp.RetailSalesReceipt AS RetailSalesReceipt,
	|	tmp.RowKey AS RowKey,
	|	tmp.SerialLotNumber AS SerialLotNumber,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.OffersAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.OffersAmount
	|	END AS OffersAmount,
	|	tmp.Store
	|FROM
	|	tmp AS tmp";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Period AS Period,
		|	QueryTable.RetailSalesReceipt AS RetailSalesReceipt,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.RevenueType AS RevenueType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.OffersAmount AS OffersAmount,
		|	QueryTable.IsService AS IsService,
		|	QueryTable.BasisDocument AS BasisDocument
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey
		|;
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Period AS Period,
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.RevenueType AS RevenueType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	SUM(tmp.NetAmount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.RevenueType,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.ItemKey";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// StockReservation 
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// SalesTurnovers
	SalesTurnovers = AccumulationRegisters.SalesTurnovers.GetLockFields(DocumentDataTables.SalesTurnovers);
	SalesTurnovers.LockInfo.Fields["SalesInvoice"] = "RetailSalesReceipt";
	DataMapWithLockFields.Insert(SalesTurnovers.RegisterName, SalesTurnovers.LockInfo);
	
	// StockBalance 
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// TaxesTurnovers
	TaxesTurnovers = AccumulationRegisters.TaxesTurnovers.GetLockFields(DocumentDataTables.TaxesTurnovers);
	DataMapWithLockFields.Insert(TaxesTurnovers.RegisterName, TaxesTurnovers.LockInfo);
	
	// RevenuesTurnovers
	RevenuesTurnovers = AccumulationRegisters.RevenuesTurnovers.GetLockFields(DocumentDataTables.RevenuesTurnovers);
	DataMapWithLockFields.Insert(RevenuesTurnovers.RegisterName, RevenuesTurnovers.LockInfo);
	
	// AccountBalance
	AccountBalance = AccumulationRegisters.AccountBalance.GetLockFields(DocumentDataTables.AccountBalance);
	DataMapWithLockFields.Insert(AccountBalance.RegisterName, AccountBalance.LockInfo);
	
	// RetailSales
	RetailSales = AccumulationRegisters.RetailSales.GetLockFields(DocumentDataTables.RetailSales);
	DataMapWithLockFields.Insert(RetailSales.RegisterName, RetailSales.LockInfo);
	
	// RetailCash
	RetailCash = AccumulationRegisters.RetailCash.GetLockFields(DocumentDataTables.RetailCash);
	DataMapWithLockFields.Insert(RetailCash.RegisterName, RetailCash.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation));
	
	
	// SalesTurnovers
	Parameters.DocumentDataTables.SalesTurnovers.Columns.RetailSalesReceipt.Name = "SalesInvoice";
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.SalesTurnovers));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance));
	
	// RevenuesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RevenuesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.RevenuesTurnovers,
			Parameters.IsReposting));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AccountBalance));

	// RetailSales
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RetailSales,
		New Structure("RecordSet", Parameters.DocumentDataTables.RetailSales));
		
	// RetailCash
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RetailCash,
		New Structure("RecordSet", Parameters.DocumentDataTables.RetailCash));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region PrintForm

Function GetPrintForm(Ref, PrintTemplate, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion
