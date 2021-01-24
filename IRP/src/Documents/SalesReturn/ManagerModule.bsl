#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"                          , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("InventoryBalance"                      , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitIncoming"                , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("StockBalance"                          , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation"                      , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("PartnerApTransactions"                 , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("AdvanceToSuppliers_Lock"               , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("PartnerApTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReconciliationStatement"               , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("SalesReturnTurnovers"                  , PostingServer.CreateTable(AccReg.SalesReturnTurnovers));
	Tables.Insert("SalesTurnovers"                        , PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("Aging_Expense"                         , PostingServer.CreateTable(AccReg.Aging));
	Tables.Insert("PartnerArTransactions"                 , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextSalesReturnItemList();
	
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
	
	QuerySalesTurnovers = New Query();
	QuerySalesTurnovers.Text = GetQueryTextSalesReturnSalesTurnovers();
	QuerySalesTurnovers.SetParameter("Ref", Ref);
	QueryResultSalesTurnovers = QuerySalesTurnovers.Execute();
	QueryTableSalesTurnovers = QueryResultSalesTurnovers.Unload();
	
	Tables.OrderBalance                     = QueryResults[1].Unload();
	Tables.InventoryBalance                 = QueryResults[2].Unload();
	Tables.GoodsInTransitIncoming           = QueryResults[3].Unload();
	Tables.StockBalance                     = QueryResults[4].Unload();
	Tables.StockReservation                 = QueryResults[5].Unload();
	Tables.PartnerApTransactions            = QueryResults[6].Unload();
	Tables.AdvanceToSuppliers_Lock          = QueryResults[7].Unload();
	Tables.ReconciliationStatement          = QueryResults[8].Unload();
	Tables.SalesReturnTurnovers             = QueryResults[9].Unload();
	Tables.PartnerArTransactions            = QueryResults[10].Unload();
	
	Tables.SalesTurnovers = QueryTableSalesTurnovers;
	
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExequteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function GetQueryTextSalesReturnItemList()
	Return	"SELECT
	|	SalesReturnItemList.Ref.Company AS Company,
	|	SalesReturnItemList.Store AS Store,
	|	SalesReturnItemList.Store.UseGoodsReceipt AS UseGoodsReceipt,
	|	SalesReturnItemList.ItemKey AS ItemKey,
	|	SalesReturnItemList.SalesReturnOrder AS SalesReturnOrder,
	|	SalesReturnItemList.Ref AS SalesReturn,
	|	CASE
	|		WHEN SalesReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN SalesReturnItemList.Ref
	|		ELSE UNDEFINED
	|	END AS BasisDocument,
	|	SalesReturnItemList.Quantity AS Quantity,
	|	SalesReturnItemList.TotalAmount AS TotalAmount,
	|	SalesReturnItemList.Ref.Partner AS Partner,
	|	SalesReturnItemList.Ref.LegalName AS LegalName,
	|	CASE
	|		WHEN SalesReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
	|		AND SalesReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
	|			THEN SalesReturnItemList.Ref.Agreement.StandardAgreement
	|		ELSE SalesReturnItemList.Ref.Agreement
	|	END AS Agreement,
	|	ISNULL(SalesReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
	|	0 AS BasisQuantity,
	|	SalesReturnItemList.Unit,
	|	SalesReturnItemList.ItemKey.Item.Unit AS ItemUnit,
	|	SalesReturnItemList.ItemKey.Unit AS ItemKeyUnit,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
	|	SalesReturnItemList.ItemKey.Item AS Item,
	|	SalesReturnItemList.Ref.Date AS Period,
	|	CASE
	|		WHEN SalesReturnItemList.SalesInvoice.Date IS NULL
	|		OR VALUETYPE(SalesReturnItemList.SalesInvoice) <> TYPE(Document.SalesInvoice)
	|			THEN SalesReturnItemList.Ref
	|		ELSE SalesReturnItemList.SalesInvoice
	|	END AS SalesInvoice,
	|	SalesReturnItemList.SalesInvoice AS AgingSalesInvoice,
	|	SalesReturnItemList.Key AS RowKey,
	|	CASE
	|		WHEN SalesReturnItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsService
	|FROM
	|	Document.SalesReturn.ItemList AS SalesReturnItemList
	|WHERE
	|	SalesReturnItemList.Ref = &Ref";
EndFunction

Function GetQueryTextSalesReturnSalesTurnovers()
	Return "SELECT
	|	SalesReturnItemList.Ref.Company AS Company,
	|	SalesReturnItemList.Ref.Currency AS Currency,
	|	SalesReturnItemList.ItemKey AS ItemKey,
	|	SalesReturnItemList.Quantity AS Quantity,
	|	ISNULL(SalesReturnSerialLotNumbers.Quantity, 0) AS QuantityBySerialLtNumbers,
	|	SalesReturnItemList.Ref.Date AS Period,
	|	CASE
	|		WHEN SalesReturnItemList.SalesInvoice.Date IS NULL
	|		OR VALUETYPE(SalesReturnItemList.SalesInvoice) <> TYPE(Document.SalesInvoice)
	|			THEN SalesReturnItemList.Ref
	|		ELSE SalesReturnItemList.SalesInvoice
	|	END AS SalesInvoice,
	|	SalesReturnItemList.TotalAmount AS Amount,
	|	SalesReturnItemList.NetAmount AS NetAmount,
	|	SalesReturnItemList.OffersAmount AS OffersAmount,
	|	SalesReturnItemList.Key AS RowKey,
	|	SalesReturnSerialLotNumbers.SerialLotNumber AS SerialLotNumber
	|INTO tmp
	|FROM
	|	Document.SalesReturn.ItemList AS SalesReturnItemList
	|		LEFT JOIN Document.SalesReturn.SerialLotNumbers AS SalesReturnSerialLotNumbers
	|		ON SalesReturnItemList.Key = SalesReturnSerialLotNumbers.Key
	|		AND SalesReturnItemList.Ref = SalesReturnSerialLotNumbers.Ref
	|		AND SalesReturnItemList.Ref = &Ref
	|		AND SalesReturnSerialLotNumbers.Ref = &Ref
	|WHERE
	|	SalesReturnItemList.Ref = &Ref
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
	|	tmp.SalesInvoice AS SalesINvoice,
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

Function GetQueryTextQueryTable()
	Return 	"SELECT
	|	QueryTable.Company AS Company,
	|	QueryTable.Partner AS Partner,
	|	QueryTable.LegalName AS LegalName,
	|	QueryTable.Agreement AS Agreement,
	|	QueryTable.Currency AS Currency,
	|	QueryTable.TotalAmount AS Amount,
	|	QueryTable.Store AS Store,
	|	QueryTable.UseGoodsReceipt AS UseGoodsReceipt,
	|	QueryTable.ItemKey AS ItemKey,
	|	QueryTable.SalesReturnOrder AS Order,
	|	QueryTable.SalesReturn AS ReceiptBasis,
	|	QueryTable.BasisDocument AS BasisDocument,
	|	QueryTable.BasisQuantity AS Quantity,
	|	QueryTable.BasisUnit AS Unit,
	|	QueryTable.Period AS Period,
	|	QueryTable.SalesInvoice AS SalesInvoice,
	|	QueryTable.AgingSalesInvoice AS AgingSalesInvoice,
	|	QueryTable.RowKey AS RowKey,
	|	QueryTable.IsService AS IsService
	|INTO tmp
	|FROM
	|	&QueryTable AS QueryTable
	|;
	|
	|// 1. OrderBalance //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Order AS Order,
	|	tmp.Quantity AS Quantity,
	|	tmp.Unit AS Unit,
	|	tmp.Period,
	|	tmp.RowKey
	|FROM
	|	tmp AS tmp
	|WHERE
	|	tmp.Order <> VALUE(Document.SalesReturnOrder.EmptyRef)
	|;
	|
	|// 2. InventoryBalance //////////////////////////////////////////////////////////////////////////////
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
	|	Not tmp.IsService
	|GROUP BY
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Unit,
	|	tmp.Period
	|;
	|
	|// 3. GoodsInTransitIncoming //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.ReceiptBasis,
	|	tmp.Quantity AS Quantity,
	|	tmp.Unit AS Unit,
	|	tmp.Period,
	|	tmp.RowKey
	|FROM
	|	tmp AS tmp
	|WHERE
	|	tmp.UseGoodsReceipt
	|	AND Not tmp.IsService
	|;
	|
	|// 4. StockBalance //////////////////////////////////////////////////////////////////////////////
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
	|	NOT tmp.UseGoodsReceipt
	|	AND Not tmp.IsService
	|GROUP BY
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Unit,
	|	tmp.Period
	|;
	|
	|// 5. StockReservation //////////////////////////////////////////////////////////////////////////////
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
	|	NOT tmp.UseGoodsReceipt
	|	AND Not tmp.IsService
	|GROUP BY
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Unit,
	|	tmp.Period
	|;
	|
	|// 6. PartnerApTransactions //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.BasisDocument AS BasisDocument,
	|	tmp.Partner AS Partner,
	|	tmp.LegalName AS LegalName,
	|	tmp.Agreement AS Agreement,
	|	tmp.Currency AS Currency,
	|	SUM(Amount) AS Amount,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.BasisDocument,
	|	tmp.Partner,
	|	tmp.LegalName,
	|	tmp.Agreement,
	|	tmp.Currency,
	|	tmp.Period
	|;
	|
	|// 7. AdvanceToSuppliers_Lock //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.BasisDocument AS BasisDocument,
	|	tmp.Partner AS Partner,
	|	tmp.LegalName AS LegalName,
	|	tmp.Agreement AS Agreement,
	|	tmp.Currency AS Currency,
	|	SUM(tmp.Amount) AS DocumentAmount,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.BasisDocument,
	|	tmp.Partner,
	|	tmp.LegalName,
	|	tmp.Agreement,
	|	tmp.Currency,
	|	tmp.Period
	|;
	|
	|// 8. ReconciliationStatement //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.LegalName AS LegalName,
	|	tmp.Currency AS Currency,
	|	SUM(Amount) AS Amount,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.LegalName,
	|	tmp.Currency,
	|	tmp.Period
	|;
	|
	|// 9. SalesReturnTurnovers //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Currency,
	|	tmp.ItemKey,
	|	-SUM(tmp.Quantity) AS Quantity,
	|	-SUM(tmp.Amount) AS Amount,
	|	tmp.Period,
	|	tmp.SalesInvoice,
	|	tmp.RowKey
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.Currency,
	|	tmp.ItemKey,
	|	tmp.Period,
	|	tmp.SalesInvoice,
	|	tmp.RowKey
	|;
	|// 10. PartnerArTransactions //////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.AgingSalesInvoice AS BasisDocument,
	|	tmp.Partner AS Partner,
	|	tmp.LegalName AS LegalName,
	|	tmp.Agreement AS Agreement,
	|	tmp.Currency AS Currency,
	|	SUM(Amount) AS Amount,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|WHERE
	|	NOT tmp.SalesInvoice.Date IS NULL
	|GROUP BY
	|	tmp.Company,
	|	tmp.AgingSalesInvoice,
	|	tmp.Partner,
	|	tmp.LegalName,
	|	tmp.Agreement,
	|	tmp.Currency,
	|	tmp.Period
	|";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// SalesTurnovers
	SalesTurnovers = AccumulationRegisters.SalesTurnovers.GetLockFields(DocumentDataTables.SalesTurnovers);
	DataMapWithLockFields.Insert(SalesTurnovers.RegisterName, SalesTurnovers.LockInfo);
	
	// SalesReturnTurnovers
	SalesReturnTurnovers = AccumulationRegisters.SalesReturnTurnovers.GetLockFields(DocumentDataTables.SalesReturnTurnovers);
	DataMapWithLockFields.Insert(SalesReturnTurnovers.RegisterName, SalesReturnTurnovers.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// GoodsInTransitIncoming
	GoodsInTransitIncoming = AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// PartnerApTransactions
	PartnerApTransactions = AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
	// AdvanceToSuppliers
	AdvanceToSuppliers = AccumulationRegisters.AdvanceToSuppliers.GetLockFields(DocumentDataTables.AdvanceToSuppliers_Lock);
	DataMapWithLockFields.Insert(AdvanceToSuppliers.RegisterName, AdvanceToSuppliers.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement = AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion

	// Advance to suppliers
	Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance =
		AccumulationRegisters.AdvanceToSuppliers.GetTableAdvanceToSuppliers_OffsetOfAdvance(
		Parameters.Object.RegisterRecords,
		Parameters.PointInTime,
		Parameters.DocumentDataTables.AdvanceToSuppliers_Lock);
	
	// Aging expense
	Parameters.DocumentDataTables.Aging_Expense = 
		AccumulationRegisters.Aging.GetTableAging_Expense_OnMoneyReceipt(
		Parameters.PointInTime,
		Parameters.DocumentDataTables.PartnerArTransactions, Undefined);
	
	If Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Count() Then
    	Query = New Query();
    	Query.Text = 
    	"SELECT
    	|	tmp.Company,
    	|	tmp.Partner,
    	|	tmp.LegalName,
    	|	tmp.BasisDocument,
    	|	tmp.Currency,
    	|	tmp.Amount
    	|INTO tmp
    	|FROM
    	|	&QueryTable AS tmp
    	|;
    	|////////////////////////////////////////////////////////////////////////////////
    	|SELECT
    	|	AccountsStatementBalance.Company,
    	|	AccountsStatementBalance.Partner,
    	|	AccountsStatementBalance.LegalName,
    	|	AccountsStatementBalance.Currency,
    	|	&Period AS Period,
    	|	AccountsStatementBalance.AdvanceFromCustomersBalance AS AdvanceFromCustomersBalance,
    	|	tmp.Amount AS AdvanceToSuppliers
    	|FROM
    	|	AccumulationRegister.AccountsStatement.Balance(&PointInTime, (Company, Partner, LegalName, Currency) IN
    	|		(SELECT
    	|			tmp.Company,
    	|			tmp.Partner,
    	|			tmp.LegalName,
    	|			tmp.Currency
    	|		FROM
    	|			tmp AS tmp)) AS AccountsStatementBalance
    	|		INNER JOIN tmp AS tmp
    	|		ON AccountsStatementBalance.Company = tmp.Company
    	|		AND AccountsStatementBalance.Partner = tmp.Partner
    	|		AND AccountsStatementBalance.LegalName = tmp.LegalName
    	|		AND AccountsStatementBalance.Currency = tmp.Currency";
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("PartnerApTransactions_OffsetOfAdvance_AccountStatement",
    	Query.Execute().Unload());
    EndIf;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
	// SalesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesTurnovers,
			Parameters.IsReposting));
	
	// SalesReturnTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesReturnTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesReturnTurnovers,
			Parameters.IsReposting));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.InventoryBalance,
			Parameters.IsReposting));
	
	// GoodsInTransitIncoming
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitIncoming,
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
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	For Each row In Table1 Do
		row.TransactionAR = - row.TransactionAR;
	EndDo;
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	For Each row In Table2 Do
		row.TransactionAR = - row.TransactionAR;
	EndDo;
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table3.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	For Each row In Table3 Do
		row.AdvanceToSuppliers = - row.AdvanceToSuppliers;
	EndDo;
	ArrayOfTables.Add(Table3);
	
	If Parameters.DocumentDataTables.Property("PartnerApTransactions_OffsetOfAdvance_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance_AccountStatement.Copy();
		PostingServer.AddColumnsToAccountsStatementTable(Table4);
		Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table4);
	EndIf;
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAR, AdvanceFromCustomers, 
				|TransactionAP, AdvanceToSuppliers"),
			Parameters.IsReposting));
	
	// PartnerApTransactions
	// PartnerApTransactions [Receipt]  
	// PartnerApTransactions_OffsetOfAdvance [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
			Parameters.IsReposting));
	
	// AdvanceToSuppliers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerApTransactions_OffsetOfAdvance));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// Aging
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.Aging,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.Aging_Expense));
	
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion	

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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesReturn.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(SerialLotNumbers());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4014B_SerialLotNumber());	
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	OpeningEntryInventory.Ref,
		|	OpeningEntryInventory.Key,
		|	OpeningEntryInventory.ItemKey,
		|	OpeningEntryInventory.Store,
		|	OpeningEntryInventory.Quantity,
		|	NOT OpeningEntryInventory.SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef) AS isSerialLotNumberSet,
		|	OpeningEntryInventory.SerialLotNumber,
		|	OpeningEntryInventory.Ref.Date AS Period,
		|	OpeningEntryInventory.Ref.Company AS Company
		|INTO ItemList
		|FROM
		|	Document.OpeningEntry.Inventory AS OpeningEntryInventory
		|WHERE
		|	OpeningEntryInventory.Ref = &Ref";
EndFunction

Function SerialLotNumbers()
	Return
		"SELECT
		|	SerialLotNumbers.Ref.Date AS Period,
		|	SerialLotNumbers.Ref.Company AS Company,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey
		|INTO SerialLotNumbers
		|FROM
		|	Document.SalesReturn.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.SalesReturn.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS QueryTable
		|WHERE 
		|	TRUE";

EndFunction

#EndRegion
