#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"                          , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation"                      , PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("PurchaseTurnovers"                     , PostingServer.CreateTable(AccReg.PurchaseTurnovers));
	Tables.Insert("StockReservation"                      , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("InventoryBalance"                      , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitOutgoing"                , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance"                          , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("PartnerArTransactions"                 , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("AdvanceFromCustomers_Lock"             , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("PartnerArTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("ReconciliationStatement"               , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("PurchaseReturnTurnovers"               , PostingServer.CreateTable(AccReg.PurchaseReturnTurnovers));
	
	Tables.Insert("StockReservation_Exists"               , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"                   , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextPurchaseReturnItemList();
	
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance               = QueryResults[1].Unload();
	Tables.OrderReservation           = QueryResults[2].Unload();
	Tables.PurchaseTurnovers          = QueryResults[3].Unload();
	Tables.StockReservation           = QueryResults[4].Unload();
	Tables.InventoryBalance           = QueryResults[5].Unload();
	Tables.GoodsInTransitOutgoing     = QueryResults[6].Unload();
	Tables.StockBalance               = QueryResults[7].Unload();
	Tables.PartnerArTransactions      = QueryResults[8].Unload();
	Tables.AdvanceFromCustomers_Lock  = QueryResults[9].Unload();
	Tables.ReconciliationStatement    = QueryResults[10].Unload();
	Tables.PurchaseReturnTurnovers    = QueryResults[11].Unload();

#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Function GetQueryTextPurchaseReturnItemList()
	Return
		"SELECT
		|	PurchaseReturnItemList.Ref.Company AS Company,
		|	PurchaseReturnItemList.Store AS Store,
		|	PurchaseReturnItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	PurchaseReturnItemList.ItemKey AS ItemKey,
		|	PurchaseReturnItemList.Quantity AS Quantity,
		|	PurchaseReturnItemList.TotalAmount AS TotalAmount,
		|	PurchaseReturnItemList.Ref.Partner AS Partner,
		|	PurchaseReturnItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN PurchaseReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PurchaseReturnItemList.Ref.Agreement.StandardAgreement
		|		ELSE PurchaseReturnItemList.Ref.Agreement
		|	END AS Agreement,
		|	ISNULL(PurchaseReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	0 AS BasisQuantity,
		|	PurchaseReturnItemList.Unit,
		|	PurchaseReturnItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseReturnItemList.ItemKey.Unit AS ItemKeyUnit,
		|	PurchaseReturnItemList.ItemKey.Item AS Item,
		|	PurchaseReturnItemList.Ref.Date AS Period,
		|	PurchaseReturnItemList.PurchaseReturnOrder,
		|	PurchaseReturnItemList.PurchaseInvoice,
		|	PurchaseReturnItemList.Ref AS ShipmentBasis,
		|	CASE
		|		WHEN PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN PurchaseReturnItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	PurchaseReturnItemList.Key AS RowKey,
		|	PurchaseReturnItemList.NetAmount AS NetAmount,
		|	CASE
		|		WHEN PurchaseReturnItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService
		|FROM
		|	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		|WHERE
		|	PurchaseReturnItemList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.UseShipmentConfirmation,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Period AS Period,
		|	QueryTable.PurchaseReturnOrder,
		|	QueryTable.PurchaseInvoice,
		|	QueryTable.ShipmentBasis,
		|	QueryTable.BasisDocument,
		|	QueryTable.NetAmount,
		|	QueryTable.IsService,
		|	QueryTable.RowKey
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 1. ItemList_OrderBalance //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.PurchaseReturnOrder AS Order,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.PurchaseReturnOrder <> VALUE(Document.PurchaseReturnOrder.EmptyRef)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.PurchaseReturnOrder,
		|	tmp.RowKey
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 2. ItemList_OrderReservation //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.PurchaseReturnOrder <> VALUE(Document.PurchaseReturnOrder.EmptyRef)
		|	AND Not tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 3. ItemList_PurchaseTurnovers //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.PurchaseInvoice AS PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(tmp.Amount) AS Amount,
		|	-SUM(tmp.NetAmount) AS NetAmount,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.PurchaseReturnOrder = VALUE(Document.PurchaseReturnOrder.EmptyRef)
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 4. ItemList_StockReservation //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.PurchaseInvoice AS PurchaseInvoice
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.PurchaseReturnOrder = VALUE(Document.PurchaseReturnOrder.EmptyRef)
		|	AND NOT UseShipmentConfirmation
		|	AND Not tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.PurchaseInvoice
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 5. ItemList_InventoryBalance //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	Not tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 6. ItemList_GoodsInTransitOutgoing //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.UseShipmentConfirmation
		|	AND Not tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|	tmp.RowKey
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 7. ItemList_StockBalance //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseShipmentConfirmation
		|	AND Not tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 8. ItemList_PartnerArTransactions //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
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
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|
		|// 9. ItemList_AdvanceFromCustomers_Lock //////////////////////////////////////////////////////////////////////////////
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
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|// 10. ReconciliationStatement //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
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
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|// 11. PurchaseReturnTurnovers //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.PurchaseInvoice AS PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// PurchaseTurnovers
	PurchaseTurnovers = AccumulationRegisters.PurchaseTurnovers.GetLockFields(DocumentDataTables.PurchaseTurnovers);
	DataMapWithLockFields.Insert(PurchaseTurnovers.RegisterName, PurchaseTurnovers.LockInfo);
	
	// PurchaseReturnTurnovers
	PurchaseReturnTurnovers = AccumulationRegisters.PurchaseReturnTurnovers.GetLockFields(DocumentDataTables.PurchaseReturnTurnovers);
	DataMapWithLockFields.Insert(PurchaseReturnTurnovers.RegisterName, PurchaseReturnTurnovers.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// OrderReservation 
	OrderReservation = AccumulationRegisters.OrderReservation.GetLockFields(DocumentDataTables.OrderReservation);
	DataMapWithLockFields.Insert(OrderReservation.RegisterName, OrderReservation.LockInfo);
	// StockReservation  
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// GoodsInTransitOutgoing 
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// StockBalance	
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// PartnerArTransactions
	PartnerArTransactions = AccumulationRegisters.PartnerArTransactions.GetLockFields(DocumentDataTables.PartnerArTransactions);
	DataMapWithLockFields.Insert(PartnerArTransactions.RegisterName, PartnerArTransactions.LockInfo);
	
	// AdvanceFromCustomers (Lock use In PostingCheckBeforeWrite)
	AdvanceFromCustomers = AccumulationRegisters.AdvanceFromCustomers.GetLockFields(DocumentDataTables.AdvanceFromCustomers_Lock);
	DataMapWithLockFields.Insert(AdvanceFromCustomers.RegisterName, AdvanceFromCustomers.LockInfo);
	
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

	// Advance from customers
	Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance =
		AccumulationRegisters.AdvanceFromCustomers.GetTableAdvanceFromCustomers_OffsetOfAdvance(
		Parameters.Object.RegisterRecords,
		Parameters.PointInTime,
		Parameters.DocumentDataTables.AdvanceFromCustomers_Lock);
			
	If Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Count() Then
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
    	|	AccountsStatementBalance.AdvanceToSuppliersBalance AS AdvanceFromCustomersBalance,
    	|	tmp.Amount AS AdvanceFromCustomers
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
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("PartnerArTransactions_OffsetOfAdvance_AccountStatement",
    	Query.Execute().Unload());
    EndIf;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance));
	
	// PurchaseTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.PurchaseTurnovers));
	
	// PurchaseReturnTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseReturnTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.PurchaseReturnTurnovers));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.InventoryBalance));
	
	// OrderReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderReservation));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet,WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			True));
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance,
			True));
	
	// PartnerArTransactions
	// PartnerArTransactions [Receipt]  
	// PartnerArTransactions_OffsetOfAdvance [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
			Parameters.IsReposting));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance));
	
    // AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	For Each row In Table1 Do
		row.TransactionAP = - row.TransactionAP;
	EndDo;
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	For Each row In Table2 Do
		row.TransactionAP = - row.TransactionAP;
	EndDo;
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table3.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	For Each row In Table3 Do
		row.AdvanceToSuppliers = - row.AdvanceToSuppliers;
	EndDo;
	ArrayOfTables.Add(Table3);
	
	If Parameters.DocumentDataTables.Property("PartnerArTransactions_OffsetOfAdvance_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance_AccountStatement.Copy();
		PostingServer.AddColumnsToAccountsStatementTable(Table4);
		Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table4);
	EndIf;
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSuppliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReconciliationStatement));
			
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
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseReturn.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(SerialLotNumbers());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R1031B_ReceiptInvoicing());	
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	ShipmentConfirmations.Key,
		|	ShipmentConfirmations.ShipmentConfirmation,
		|	SUM(ShipmentConfirmations.Quantity) AS Quantity
		|INTO ShipmentConfirmations
		|FROM
		|	Document.PurchaseReturn.ShipmentConfirmations AS ShipmentConfirmations
		|WHERE
		|	ShipmentConfirmations.Ref = &Ref
		|GROUP BY
		|	ShipmentConfirmations.Key,
		|	ShipmentConfirmations.ShipmentConfirmation
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PurchaseReturnItemList.Ref.Company AS Company,
		|	PurchaseReturnItemList.Store AS Store,
		|	PurchaseReturnItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	PurchaseReturnItemList.ItemKey AS ItemKey,
		|	PurchaseReturnItemList.PurchaseReturnOrder AS PurchaseReturnOrder,
		|	PurchaseReturnItemList.Ref AS PurchaseReturn,
		|	CASE
		|		WHEN PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN PurchaseReturnItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	PurchaseReturnItemList.QuantityInBaseUnit AS Quantity,
		|	PurchaseReturnItemList.TotalAmount AS TotalAmount,
		|	PurchaseReturnItemList.Ref.Partner AS Partner,
		|	PurchaseReturnItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN PurchaseReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PurchaseReturnItemList.Ref.Agreement.StandardAgreement
		|		ELSE PurchaseReturnItemList.Ref.Agreement
		|	END AS Agreement,
		|	ISNULL(PurchaseReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	PurchaseReturnItemList.Ref.Date AS Period,
		|	CASE
		|		WHEN PurchaseReturnItemList.PurchaseInvoice.Ref IS NULL
		|		OR VALUETYPE(PurchaseReturnItemList.PurchaseInvoice) <> TYPE(Document.PurchaseInvoice)
		|			THEN PurchaseReturnItemList.Ref
		|		ELSE PurchaseReturnItemList.PurchaseInvoice
		|	END AS SalesInvoice,
		|	PurchaseReturnItemList.Key,
		|	PurchaseReturnItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService
		|INTO ItemList
		|FROM
		|	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		|WHERE
		|	PurchaseReturnItemList.Ref = &Ref";
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
		|	Document.PurchaseReturn.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.PurchaseReturn.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS QueryTable
		|WHERE 
		|	TRUE";

EndFunction

Function R1031B_ReceiptInvoicing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ShipmentConfirmations.ShipmentConfirmation AS Basis,
		|	ShipmentConfirmations.Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|INTO R1031B_ReceiptInvoicing
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ShipmentConfirmations AS ShipmentConfirmations
		|		ON ItemList.Key = ShipmentConfirmations.Key
		|WHERE
		|	TRUE";
EndFunction

#EndRegion