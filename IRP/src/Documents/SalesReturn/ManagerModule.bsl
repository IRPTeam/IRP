#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
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
		|	SUM(SalesReturnItemList.Quantity) AS Quantity,
		|	SUM(SalesReturnItemList.TotalAmount) AS TotalAmount,
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
		|	SalesReturnItemList.SalesInvoice AS SalesInvoice,
		|	SalesReturnItemList.Key AS RowKey,
		|	SalesReturnItemList.Ref.IsOpeningEntry AS IsOpeningEntry
		|FROM
		|	Document.SalesReturn.ItemList AS SalesReturnItemList
		|WHERE
		|	SalesReturnItemList.Ref = &Ref
		|GROUP BY
		|	SalesReturnItemList.Ref.Company,
		|	SalesReturnItemList.Ref.Partner,
		|	SalesReturnItemList.Ref.LegalName,
		|	CASE
		|		WHEN SalesReturnItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND SalesReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN SalesReturnItemList.Ref.Agreement.StandardAgreement
		|		ELSE SalesReturnItemList.Ref.Agreement
		|	END,
		|	ISNULL(SalesReturnItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	SalesReturnItemList.Store,
		|	SalesReturnItemList.Store.UseGoodsReceipt,
		|	SalesReturnItemList.ItemKey,
		|	SalesReturnItemList.SalesReturnOrder,
		|	SalesReturnItemList.Ref,
		|	CASE
		|		WHEN SalesReturnItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN SalesReturnItemList.Ref
		|		ELSE UNDEFINED
		|	END,
		|	SalesReturnItemList.Unit,
		|	SalesReturnItemList.ItemKey.Item.Unit,
		|	SalesReturnItemList.ItemKey.Unit,
		|	SalesReturnItemList.ItemKey.Item,
		|	SalesReturnItemList.Ref.Date,
		|	VALUE(Catalog.Units.EmptyRef),
		|	SalesReturnItemList.SalesInvoice,
		|	SalesReturnItemList.Key,
		|	SalesReturnItemList.Ref.IsOpeningEntry";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
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
		|
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.SalesInvoice AS SalesInvoice,
		|	QueryTable.RowKey AS RowKey,
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
		|	tmp.Order AS Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Order <> VALUE(Document.SalesReturnOrder.EmptyRef)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|// 2//////////////////////////////////////////////////////////////////////////////
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
		|WHERE
		|	tmp.Order = VALUE(Document.SalesReturnOrder.EmptyRef)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.SalesInvoice,
		|	tmp.RowKey
		|;
		|
		|// 3//////////////////////////////////////////////////////////////////////////////
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
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 4//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.UseGoodsReceipt
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|// 5//////////////////////////////////////////////////////////////////////////////
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
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 6//////////////////////////////////////////////////////////////////////////////
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
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 7//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(Amount) AS Amount,
		|	Period
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
		|	tmp.Period,
		|	Period
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
		|
		|// 9//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(Amount) AS Amount,
		|	Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period,
		|	Period
		|;
		|// 10//////////////////////////////////////////////////////////////////////////////
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
		|";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("OrderBalance", QueryResults[1].Unload());
	Tables.Insert("SalesTurnovers", QueryResults[2].Unload());
	Tables.Insert("InventoryBalance", QueryResults[3].Unload());
	Tables.Insert("GoodsInTransitIncoming", QueryResults[4].Unload());
	Tables.Insert("StockBalance", QueryResults[5].Unload());
	Tables.Insert("StockReservation", QueryResults[6].Unload());
	Tables.Insert("PartnerApTransactions", QueryResults[7].Unload());
	// For lock
	Tables.Insert("AdvanceToSuppliers_Lock", QueryResults[8].Unload());
	// For Registrations
	Tables.Insert("AdvanceToSuppliers_Registrations", New ValueTable());
	Tables.Insert("ReconciliationStatement", QueryResults[9].Unload());
	Tables.Insert("SalesReturnTurnovers", QueryResults[10].Unload());
	Parameters.IsReposting = False;
	
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
		New Structure("Fields, Data", Fields, DocumentDataTables.OrderBalance));
	
	// SalesTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("SalesInvoice", "SalesInvoice");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.SalesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.SalesTurnovers));
	
	// SalesReturnTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("SalesInvoice", "SalesInvoice");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.SalesReturnTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.SalesReturnTurnovers));
	
	// InventoryBalance
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.InventoryBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.InventoryBalance));
	
	// GoodsInTransitIncoming	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ReceiptBasis", "ReceiptBasis");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
		New Structure("Fields, Data", Fields, DocumentDataTables.GoodsInTransitIncoming));
	
	// StockBalance	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.StockBalance));
	
	// StockReservation	
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
		New Structure("Fields, Data", Fields, DocumentDataTables.StockReservation));
	
	// PartnerApTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerApTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerApTransactions));
	
	// AdvanceToSuppliers (Lock use In PostingCheckBeforeWrite)
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceToSuppliers",
		New Structure("Fields, Data", Fields, DocumentDataTables.AdvanceToSuppliers_Lock));
	
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
	// Advance to suppliers
	Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations =
		AccumulationRegisters.AdvanceToSuppliers.GetTableExpenceAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceToSuppliers_Lock);
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
			Parameters.IsReposting));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockReservation,
			Parameters.IsReposting));
	
	// PartnerApTransactions
	// PartnerApTransactions [Receipt]  
	// AdvanceToSuppliers_Registrations [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations.Copy();
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
			Parameters.DocumentDataTables.AdvanceToSuppliers_Registrations));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
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

