#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	PurchaseReturnItemList.Ref.Company AS Company,
		|	PurchaseReturnItemList.Store AS Store,
		|	PurchaseReturnItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	PurchaseReturnItemList.ItemKey AS ItemKey,
		|	SUM(PurchaseReturnItemList.Quantity) AS Quantity,
		|	SUM(PurchaseReturnItemList.TotalAmount) AS TotalAmount,
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
		|	PurchaseReturnItemList.Ref.IsOpeningEntry AS IsOpeningEntry
		|FROM
		|	Document.PurchaseReturn.ItemList AS PurchaseReturnItemList
		|WHERE
		|	PurchaseReturnItemList.Ref = &Ref
		|GROUP BY
		|	PurchaseReturnItemList.Ref.Company,
		|	PurchaseReturnItemList.Ref.Partner,
		|	PurchaseReturnItemList.Ref.LegalName,
		|	CASE
		|		WHEN PurchaseReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PurchaseReturnItemList.Ref.Agreement.StandardAgreement
		|		ELSE PurchaseReturnItemList.Ref.Agreement
		|	END,
		|	ISNULL(PurchaseReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	PurchaseReturnItemList.Store,
		|	PurchaseReturnItemList.Store.UseShipmentConfirmation,
		|	PurchaseReturnItemList.ItemKey,
		|	PurchaseReturnItemList.Unit,
		|	PurchaseReturnItemList.ItemKey.Item.Unit,
		|	PurchaseReturnItemList.ItemKey.Unit,
		|	VALUE(Catalog.Units.EmptyRef),
		|	PurchaseReturnItemList.ItemKey.Item,
		|	PurchaseReturnItemList.Ref.Date,
		|	PurchaseReturnItemList.PurchaseReturnOrder,
		|	PurchaseReturnItemList.PurchaseInvoice,
		|	PurchaseReturnItemList.Ref,
		|	CASE
		|		WHEN PurchaseReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN PurchaseReturnItemList.Ref
		|		ELSE UNDEFINED
		|	END,
		|	PurchaseReturnItemList.Key,
		|	PurchaseReturnItemList.Ref.IsOpeningEntry";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
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
		|
		|	QueryTable.RowKey,
		|	QueryTable.IsOpeningEntry AS IsOpeningEntry
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1//////////////////////////////////////////////////////////////////////////////
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
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.PurchaseReturnOrder,
		|	tmp.RowKey
		|;
		|
		|// 2//////////////////////////////////////////////////////////////////////////////
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
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 3//////////////////////////////////////////////////////////////////////////////
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
		|// 4//////////////////////////////////////////////////////////////////////////////
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
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.PurchaseInvoice
		|;
		|
		|// 5//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 6//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.UseShipmentConfirmation
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|;
		|
		|// 7//////////////////////////////////////////////////////////////////////////////
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
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 8//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
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
		|// 9//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS DocumentAmount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.BasisDocument,
		|
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|// 10//////////////////////////////////////////////////////////////////////////////
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
		|// 11//////////////////////////////////////////////////////////////////////////////
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
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	Tables.Insert("ItemList_OrderBalance", QueryResults[1].Unload());
	Tables.Insert("ItemList_OrderReservation", QueryResults[2].Unload());
	Tables.Insert("ItemList_PurchaseTurnovers", QueryResults[3].Unload());
	Tables.Insert("ItemList_StockReservation", QueryResults[4].Unload());
	Tables.Insert("ItemList_InventoryBalance", QueryResults[5].Unload());
	Tables.Insert("ItemList_GoodsInTransitOutgoing", QueryResults[6].Unload());
	Tables.Insert("ItemList_StockBalance", QueryResults[7].Unload());
	Tables.Insert("ItemList_PartnerArTransactions", QueryResults[8].Unload());
	// For lock
	Tables.Insert("ItemList_AdvanceFromCustomers_Lock", QueryResults[9].Unload());
	// For Registrations
	Tables.Insert("ItemList_AdvanceFromCustomers_Registrations", New ValueTable());
	Tables.Insert("ReconciliationStatement", QueryResults[10].Unload());
	Tables.Insert("PurchaseReturnTurnovers", QueryResults[11].Unload());
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_OrderBalance));
	
	// PurchaseTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("PurchaseInvoice", "PurchaseInvoice");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.PurchaseTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_PurchaseTurnovers));
	
	// PurchaseReturnTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("PurchaseInvoice", "PurchaseInvoice");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.PurchaseReturnTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.PurchaseReturnTurnovers));
	
	// InventoryBalance
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.InventoryBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_InventoryBalance));
	
	// OrderReservation 
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.OrderReservation",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_OrderReservation));
	
	// StockReservation  
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_StockReservation));
	
	// GoodsInTransitOutgoing 
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ShipmentBasis", "ShipmentBasis");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_GoodsInTransitOutgoing));
	
	// StockBalance	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_StockBalance));
	
	// PartnerArTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerArTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_PartnerArTransactions));
	
	// AdvanceFromCustomers (Lock use In PostingCheckBeforeWrite)
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceFromCustomers",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_AdvanceFromCustomers_Lock));
	
	// ReconciliationStatement
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.ReconciliationStatement",
		New Structure("Fields, Data", Fields, DocumentDataTables.ReconciliationStatement));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance from customers
	Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations =
		AccumulationRegisters.AdvanceFromCustomers.GetTableExpenceAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Lock);
			
	If Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations.Count() Then
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
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("AdvanceFromCustomers_Registrations_AccountStatement",
    	Query.Execute().Unload());
    EndIf;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_OrderBalance));
	
	// PurchaseTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ItemList_PurchaseTurnovers));
	
	// PurchaseReturnTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseReturnTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.PurchaseReturnTurnovers));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_InventoryBalance));
	
	// OrderReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_OrderReservation));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_StockReservation));
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ItemList_GoodsInTransitOutgoing));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_StockBalance));
	
	// PartnerArTransactions
	// ItemList_PartnerArTransactions [Receipt]  
	// ItemList_AdvanceFromCustomers_Registrations [Expense]
	ArrayOfTables = New Array();
	ItemList_PartnerArTransactions
	= Parameters.DocumentDataTables.ItemList_PartnerArTransactions.Copy();
	ItemList_PartnerArTransactions.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	ItemList_PartnerArTransactions.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(ItemList_PartnerArTransactions);
	
	ItemList_AdvanceFromCustomers_Registrations
	= Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations.Copy();
	ItemList_AdvanceFromCustomers_Registrations.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	ItemList_AdvanceFromCustomers_Registrations.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(ItemList_AdvanceFromCustomers_Registrations);
	
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
			Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations));
	
    // AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.ItemList_PartnerArTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	For Each row in Table1 Do
		row.TransactionAP = - row.TransactionAP;
	EndDo;
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations.Copy();
	Table2.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	For Each row in Table2 Do
		row.TransactionAP = - row.TransactionAP;
	EndDo;
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.ItemList_AdvanceFromCustomers_Registrations.Copy();
	Table3.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	For Each row in Table3 Do
		row.AdvanceToSuppliers = - row.AdvanceToSuppliers;
	EndDo;
	ArrayOfTables.Add(Table3);
	
	If Parameters.DocumentDataTables.Property("AdvanceFromCustomers_Registrations_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations_AccountStatement.Copy();
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

