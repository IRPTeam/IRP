#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("StockReservation"     , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("SalesTurnovers"       , PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("StockBalance"         , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("SalesReturnTurnovers" , PostingServer.CreateTable(AccReg.SalesReturnTurnovers));
	Tables.Insert("AccountBalance"       , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("RetailSales"          , PostingServer.CreateTable(AccReg.RetailSales));
	Tables.Insert("RetailCash"           , PostingServer.CreateTable(AccReg.RetailCash));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	QuantityByUnit = QuantityByUnit(Ref);
	
	PostingServer.CalculateQuantityByUnit(QuantityByUnit);
	
	Query = New Query();
	Query.Text = GetQueryText_AllTables();
	Query.SetParameter("QueryTable", QuantityByUnit);
	QueryResults = Query.ExecuteBatch();
	
	Tables.Insert("StockBalance", QueryResults[1].Unload());
	Tables.Insert("StockReservation", QueryResults[2].Unload());
	Tables.Insert("SalesReturnTurnovers", QueryResults[3].Unload());
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextRetailReturnReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultPaymentList.Unload();
	Tables.Insert("AccountBalance", QueryTablePaymentList);
	
	QuerySalesTurnovers = New Query();
	QuerySalesTurnovers.Text = GetQueryTextRetailReturnReceiptSalesTurnovers();
	QuerySalesTurnovers.SetParameter("Ref", Ref);
	QueryResultSalesTurnovers = QuerySalesTurnovers.Execute();
	QueryTableSalesTurnovers = QueryResultSalesTurnovers.Unload();
	Tables.Insert("SalesTurnovers", QueryTableSalesTurnovers);
			
	QueryRetailSales = New Query();
	QueryRetailSales.Text = GetQueryText_RetailReturnReceipt_RetailSales();
	QueryRetailSales.SetParameter("Ref", Ref);
	QueryResultRetailSales = QueryRetailSales.Execute();
	QueryTableRetailSales = QueryResultRetailSales.Unload();
	Tables.RetailSales = QueryTableRetailSales;
		
	QueryRetailCash = New Query();
	QueryRetailCash.Text = GetQueryText_RetailReturnReceipt_RetailCash();
	QueryRetailCash.SetParameter("Ref", Ref);
	QueryResultRetailCash = QueryRetailCash.Execute();
	QueryTableRetailCash = QueryResultRetailCash.Unload();			
	Tables.RetailCash = QueryTableRetailCash;
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function GetQueryText_AllTables()
	Return 
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.SalesReturn AS ReceiptBasis,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RetailSalesReceipt AS RetailSalesReceipt,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.IsService AS IsService
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1. StockBalance //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 2. StockReservation //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 3. SalesReturnTurnovers //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.RetailSalesReceipt,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RetailSalesReceipt,
		|	tmp.RowKey
		|";
EndFunction

Function QuantityByUnit(Ref)
	Query = New Query();
	Query.Text =
	"SELECT
		|	RetailReturnReceiptItemList.Ref.Company AS Company,
		|	RetailReturnReceiptItemList.Store AS Store,
		|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
		|	RetailReturnReceiptItemList.Ref AS SalesReturn,
		|	RetailReturnReceiptItemList.Quantity AS Quantity,
		|	RetailReturnReceiptItemList.TotalAmount AS TotalAmount,
		|	RetailReturnReceiptItemList.Ref.Partner AS Partner,
		|	RetailReturnReceiptItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN RetailReturnReceiptItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND RetailReturnReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN RetailReturnReceiptItemList.Ref.Agreement.StandardAgreement
		|		ELSE RetailReturnReceiptItemList.Ref.Agreement
		|	END AS Agreement,
		|	ISNULL(RetailReturnReceiptItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	0 AS BasisQuantity,
		|	RetailReturnReceiptItemList.Unit,
		|	RetailReturnReceiptItemList.ItemKey.Item.Unit AS ItemUnit,
		|	RetailReturnReceiptItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	RetailReturnReceiptItemList.ItemKey.Item AS Item,
		|	RetailReturnReceiptItemList.Ref.Date AS Period,
		|	CASE
		|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
		|			THEN RetailReturnReceiptItemList.Ref
		|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
		|	END AS RetailSalesReceipt,
		|	RetailReturnReceiptItemList.Key AS RowKey,
		|	CASE
		|		WHEN RetailReturnReceiptItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService
		|FROM
		|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
		|WHERE
		|	RetailReturnReceiptItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	Return QueryResults.Unload();
EndFunction

Function GetQueryText_RetailReturnReceipt_RetailCash()
	Return 
	"SELECT
	|	RetailReturnReceiptPayments.Ref.BusinessUnit AS BusinessUnit,
	|	RetailReturnReceiptPayments.Ref.Company AS Company,
	|	RetailReturnReceiptPayments.Ref.Currency AS Currency,
	|	RetailReturnReceiptPayments.Account,
	|	-SUM(RetailReturnReceiptPayments.Amount) AS Amount,
	|	RetailReturnReceiptPayments.Ref.Date AS Period,
	|	RetailReturnReceiptPayments.PaymentType,
	|	RetailReturnReceiptPayments.PaymentTerminal,
	|	RetailReturnReceiptPayments.Percent,
	|	SUM(RetailReturnReceiptPayments.Commission) AS Commission
	|FROM
	|	Document.RetailReturnReceipt.Payments AS RetailReturnReceiptPayments
	|WHERE
	|	RetailReturnReceiptPayments.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptPayments.Ref.BusinessUnit,
	|	RetailReturnReceiptPayments.Ref.Company,
	|	RetailReturnReceiptPayments.Ref.Currency,
	|	RetailReturnReceiptPayments.Account,
	|	RetailReturnReceiptPayments.Ref.Date,
	|	RetailReturnReceiptPayments.PaymentType,
	|	RetailReturnReceiptPayments.PaymentTerminal,
	|	RetailReturnReceiptPayments.Percent";
EndFunction

Function GetQueryText_RetailReturnReceipt_RetailSales()
	Return 
	"SELECT
	|	RetailReturnReceiptItemList.Ref.BusinessUnit AS BusinessUnit,
	|	RetailReturnReceiptItemList.Ref.Company AS Company,
	|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailReturnReceiptItemList.Quantity) AS Quantity,
	|	SUM(ISNULL(RetailReturnReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailReturnReceiptItemList.Ref.Date AS Period,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.Ref
	|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
	|	END AS RetailSalesReceipt,
	|	SUM(RetailReturnReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailReturnReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailReturnReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailReturnReceiptItemList.Key AS RowKey,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber,
	|	RetailReturnReceiptItemList.Store
	|INTO tmp
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|		LEFT JOIN Document.RetailReturnReceipt.SerialLotNumbers AS RetailReturnReceiptSerialLotNumbers
	|		ON RetailReturnReceiptItemList.Key = RetailReturnReceiptSerialLotNumbers.Key
	|		AND RetailReturnReceiptItemList.Ref = RetailReturnReceiptSerialLotNumbers.Ref
	|		AND RetailReturnReceiptItemList.Ref = &Ref
	|		AND RetailReturnReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptItemList.Ref.BusinessUnit,
	|	RetailReturnReceiptItemList.Ref.Company,
	|	RetailReturnReceiptItemList.ItemKey,
	|	RetailReturnReceiptItemList.Ref.Date,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.Ref
	|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
	|	END,
	|	RetailReturnReceiptItemList.Key,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber,
	|	RetailReturnReceiptItemList.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.BusinessUnit AS BusinessUnit,
	|	tmp.ItemKey AS ItemKey,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN -tmp.Quantity
	|		ELSE -tmp.QuantityBySerialLtNumbers
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
	|				ELSE -tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE -tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE -tmp.OffersAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.OffersAmount
	|	END AS OffersAmount,
	|	tmp.Store
	|FROM
	|	tmp AS tmp";
EndFunction

Function GetQueryTextRetailReturnReceiptSalesTurnovers()
	Return "SELECT
	|	RetailReturnReceiptItemList.Ref.Company AS Company,
	|	RetailReturnReceiptItemList.Ref.Currency AS Currency,
	|	RetailReturnReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailReturnReceiptItemList.Quantity) AS Quantity,
	|	SUM(ISNULL(RetailReturnReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailReturnReceiptItemList.Ref.Date AS Period,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.Ref
	|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
	|	END AS RetailSalesReceipt,
	|	SUM(RetailReturnReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailReturnReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailReturnReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailReturnReceiptItemList.Key AS RowKey,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber
	|INTO tmp
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|		LEFT JOIN Document.RetailReturnReceipt.SerialLotNumbers AS RetailReturnReceiptSerialLotNumbers
	|		ON RetailReturnReceiptItemList.Key = RetailReturnReceiptSerialLotNumbers.Key
	|		AND RetailReturnReceiptItemList.Ref = RetailReturnReceiptSerialLotNumbers.Ref
	|		AND RetailReturnReceiptItemList.Ref = &Ref
	|		AND RetailReturnReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptItemList.Ref.Company,
	|	RetailReturnReceiptItemList.Ref.Currency,
	|	RetailReturnReceiptItemList.ItemKey,
	|	RetailReturnReceiptItemList.Ref.Date,
	|	RetailReturnReceiptItemList.Ref,
	|	RetailReturnReceiptItemList.Key,
	|	RetailReturnReceiptSerialLotNumbers.SerialLotNumber,
	|	CASE
	|		WHEN RetailReturnReceiptItemList.RetailSalesReceipt = VALUE(Document.RetailSalesReceipt.EmptyRef)
	|			THEN RetailReturnReceiptItemList.Ref
	|		ELSE RetailReturnReceiptItemList.RetailSalesReceipt
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.Currency AS Currency,
	|	tmp.ItemKey AS ItemKey,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN tmp.Quantity
	|		ELSE tmp.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmp.Period AS Period,
	|	tmp.RetailSalesReceipt AS RetailSalesReceipt,
	|	tmp.RowKey AS RowKey,
	|	tmp.SerialLotNumber AS SerialLotNumber,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	-CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	-CASE
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

Function GetQueryTextRetailReturnReceiptPaymentList()
	Return "SELECT
	|	RetailReturnReceiptPayments.Ref.Company,
	|	RetailReturnReceiptPayments.Ref.Currency,
	|	RetailReturnReceiptPayments.Account,
	|	SUM(RetailReturnReceiptPayments.Amount) AS Amount,
	|	RetailReturnReceiptPayments.Ref.Date AS Period
	|FROM
	|	Document.RetailReturnReceipt.Payments AS RetailReturnReceiptPayments
	|WHERE
	|	RetailReturnReceiptPayments.Ref = &Ref
	|GROUP BY
	|	RetailReturnReceiptPayments.Ref.Company,
	|	RetailReturnReceiptPayments.Ref.Currency,
	|	RetailReturnReceiptPayments.Account,
	|	RetailReturnReceiptPayments.Ref.Date";
EndFunction	

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
		
	// SalesTurnovers
	SalesTurnovers = AccumulationRegisters.SalesTurnovers.GetLockFields(DocumentDataTables.SalesTurnovers);
	SalesTurnovers.LockInfo.Fields["SalesInvoice"] = "RetailSalesReceipt";
	DataMapWithLockFields.Insert(SalesTurnovers.RegisterName, SalesTurnovers.LockInfo);
	
	// StockBalance 
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);

	// StockReservation 
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
	// AccountBalance
	AccountBalance = AccumulationRegisters.AccountBalance.GetLockFields(DocumentDataTables.AccountBalance);
	DataMapWithLockFields.Insert(AccountBalance.RegisterName, AccountBalance.LockInfo);	
	
	// RetailSales
	RetailSales = AccumulationRegisters.RetailSales.GetLockFields(DocumentDataTables.RetailSales);
	DataMapWithLockFields.Insert(RetailSales.RegisterName, RetailSales.LockInfo);
	
	// RetailCash
	RetailCash = AccumulationRegisters.RetailCash.GetLockFields(DocumentDataTables.RetailCash);
	DataMapWithLockFields.Insert(RetailCash.RegisterName, RetailCash.LockInfo);
	
	// SalesReturnTurnovers
	SalesReturnTurnovers = AccumulationRegisters.SalesReturnTurnovers.GetLockFields(DocumentDataTables.SalesReturnTurnovers);
	SalesReturnTurnovers.LockInfo.Fields["SalesInvoice"] = "RetailSalesReceipt";
	DataMapWithLockFields.Insert(SalesReturnTurnovers.RegisterName, SalesReturnTurnovers.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// SalesTurnovers
	Parameters.DocumentDataTables.SalesTurnovers.Columns.RetailSalesReceipt.Name = "SalesInvoice";
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesTurnovers,
			Parameters.IsReposting));
	
	// SalesReturnTurnovers
	Parameters.DocumentDataTables.SalesReturnTurnovers.Columns.RetailSalesReceipt.Name = "SalesInvoice";
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesReturnTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesReturnTurnovers,
			Parameters.IsReposting));
		
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockBalance,
			True));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockReservation,
			True));
		
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
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
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Exists);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Exists);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
	
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.RetailReturnReceipt.ItemList");
	If Not Cancel And Not AccReg.StockReservation.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
															   Parameters.DocumentDataTables.StockReservation, 
															   Parameters.DocumentDataTables.StockReservation_Exists, 
															   AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.StockBalance.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
															   Parameters.DocumentDataTables.StockBalance, 
															   Parameters.DocumentDataTables.StockBalance_Exists, 
															   AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion
