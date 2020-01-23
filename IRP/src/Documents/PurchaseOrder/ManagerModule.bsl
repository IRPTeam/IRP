#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	Tables.Insert("OrderBalance_PurchaseBasis", New ValueTable());
	Tables.Insert("OrderBalance_New", New ValueTable());
	Tables.Insert("OrderBalance_Current", New ValueTable());
	
	Tables.Insert("InventoryBalance", New ValueTable());
	Tables.Insert("GoodsInTransitIncoming", New ValueTable());
	Tables.Insert("StockBalance", New ValueTable());
	Tables.Insert("StockReservation_Receipt", New ValueTable());
	Tables.Insert("StockReservation_Expense", New ValueTable());
	Tables.Insert("ReceiptOrders", New ValueTable());
	Tables.Insert("GoodsReceiptSchedule_Receipt", New ValueTable());
	Tables.Insert("GoodsReceiptSchedule_Expense", New ValueTable());
	Tables.Insert("OrderProcurement", New ValueTable());
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	PurchaseOrdertemList.Ref.Company AS Company,
		|	PurchaseOrdertemList.Store AS Store,
		|	PurchaseOrdertemList.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseOrdertemList.Ref.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	PurchaseOrdertemList.Ref AS Order,
		|	PurchaseOrdertemList.PurchaseBasis AS PurchaseBasis,
		|	PurchaseOrdertemList.ItemKey.Item AS Item,
		|	PurchaseOrdertemList.ItemKey AS ItemKey,
		|	SUM(PurchaseOrdertemList.Quantity) AS Quantity,
		|	PurchaseOrdertemList.Unit,
		|	PurchaseOrdertemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseOrdertemList.ItemKey.Unit AS ItemKeyUnit,
		|	0 AS BasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Period AS Period,
		|	PurchaseOrdertemList.Key AS RowKey,
		|	PurchaseOrdertemList.BusinessUnit AS BusinessUnit,
		|	PurchaseOrdertemList.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN PurchaseOrdertemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	PurchaseOrdertemList.DeliveryDate AS DeliveryDate,
		|	CASE
		|		WHEN PurchaseOrdertemList.PurchaseBasis REFS Document.InternalSupplyRequest
		|		AND
		|		NOT PurchaseOrdertemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UseInternalSupplyRequest,
		|   CASE
		|		WHEN PurchaseOrdertemList.PurchaseBasis REFS Document.SalesOrder
		|		AND
		|		NOT PurchaseOrdertemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UseSalesOrder	
		|FROM
		|	Document.PurchaseOrder.ItemList AS PurchaseOrdertemList
		|WHERE
		|	PurchaseOrdertemList.Ref = &Ref
		|GROUP BY
		|	PurchaseOrdertemList.Ref.Company,
		|	PurchaseOrdertemList.Store,
		|	PurchaseOrdertemList.Ref.GoodsReceiptBeforePurchaseInvoice,
		|	PurchaseOrdertemList.ItemKey,
		|	PurchaseOrdertemList.PurchaseBasis,
		|	PurchaseOrdertemList.Unit,
		|	PurchaseOrdertemList.ItemKey.Item.Unit,
		|	PurchaseOrdertemList.ItemKey.Unit,
		|	PurchaseOrdertemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	PurchaseOrdertemList.Ref,
		|	PurchaseOrdertemList.Key,
		|	PurchaseOrdertemList.BusinessUnit,
		|	PurchaseOrdertemList.ExpenseType,
		|	PurchaseOrdertemList.Store.UseGoodsReceipt,
		|	CASE
		|		WHEN PurchaseOrdertemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END,
		|	PurchaseOrdertemList.DeliveryDate,
		|	CASE
		|		WHEN PurchaseOrdertemList.PurchaseBasis REFS Document.InternalSupplyRequest
		|		AND
		|		NOT PurchaseOrdertemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END,
		|	CASE
		|		WHEN PurchaseOrdertemList.PurchaseBasis REFS Document.SalesOrder
		|		AND
		|		NOT PurchaseOrdertemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END	
		|HAVING
		|	SUM(PurchaseOrdertemList.Quantity) <> 0";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	QueryTable.UseGoodsReceipt AS UseGoodsReceipt,
		|	QueryTable.Order AS Order,
		|	QueryTable.PurchaseBasis AS PurchaseBasis,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType AS ExpenseType,
		|	QueryTable.IsService AS IsService,
		|   QueryTable.DeliveryDate AS DeliveryDate,
		|   QueryTable.UseInternalSupplyRequest AS UseInternalSupplyRequest,
		|   QueryTable.UseSalesOrder AS UseSalesOrder
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|// 2//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.PurchaseBasis AS Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.UseInternalSupplyRequest
		|GROUP BY
		|	tmp.Store,
		|	tmp.PurchaseBasis,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|// 3//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|   AND NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 4//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|   tmp.RowKey
		|;
		|
		|// 5//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 6////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|
		|// 7///////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|   AND tmp.UseSalesOrder
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|
		|// 8//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Order AS GoodsReceipt,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|   tmp.RowKey
		|;
		|
		|// 9//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|// 10//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|	AND tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|// 11////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|   tmp.PurchaseBasis AS Order,
		|   tmp.Store AS Store,
		|   tmp.ItemKey AS ItemKey,
		|   tmp.RowKey AS RowKey,
		|   SUM(tmp.Quantity) AS Quantity,
		|   tmp.Period
		|FROM 
		|	tmp AS tmp
		|WHERE
		|   tmp.UseSalesOrder
		|GROUP BY
		|	tmp.Company,
		|   tmp.PurchaseBasis,
		|   tmp.Store,
		|   tmp.ItemKey,
		|   tmp.RowKey,
		|   tmp.Period   
		|";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance_New = QueryResults[1].Unload();
	Tables.OrderBalance_PurchaseBasis = QueryResults[2].Unload();
	Tables.OrderBalance_Current
	= PostingServer.GetCurrentRecords(Ref, Metadata.AccumulationRegisters.OrderBalance);
	
	Tables.InventoryBalance = QueryResults[3].Unload();
	Tables.GoodsInTransitIncoming = QueryResults[4].Unload();
	Tables.StockBalance = QueryResults[5].Unload();
	Tables.StockReservation_Receipt = QueryResults[6].Unload();
	Tables.StockReservation_Expense = QueryResults[7].Unload();
	
	Tables.ReceiptOrders = QueryResults[8].Unload();
	
	Tables.GoodsReceiptSchedule_Receipt = QueryResults[9].Unload();
	Tables.GoodsReceiptSchedule_Expense = QueryResults[10].Unload();
	Tables.OrderProcurement = QueryResults[11].Unload();
	
	Parameters.IsReposting = Tables.OrderBalance_Current.Count() > 0;
	
	If Parameters.IsReposting Then
		ArrayOfJoiningTables = New Array();
		
		ArrayOfJoiningTables.Add(Tables.OrderBalance_New);
		ArrayOfJoiningTables.Add(Tables.OrderBalance_PurchaseBasis);
		ArrayOfJoiningTables.Add(Tables.OrderBalance_Current);
		
		OrderBalance_Reposting = PostingServer.JoinTables(ArrayOfJoiningTables,
				"Store, Order, ItemKey");
		Tables.Insert("OrderBalance_Reposting", OrderBalance_Reposting);
	EndIf;
	
	Return Tables;
EndFunction

// Tables for lock
Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	If Parameters.IsReposting Then
		
		// OrderBalance
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("Order", "Order");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
			New Structure("Fields, Data", Fields, DocumentDataTables.OrderBalance_Reposting));
	Else
		
		// OrderBalance
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("Order", "Order");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
			New Structure("Fields, Data", Fields, DocumentDataTables.OrderBalance_New));
		
	EndIf;
	
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
		New Structure("Fields, Data", Fields, DocumentDataTables.StockReservation_Expense));
	
	// ReceiptOrders
	Fields = New Map();
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	Fields.Insert("GoodsReceipt", "GoodsReceipt");
	
	DataMapWithLockFields.Insert("AccumulationRegister.ReceiptOrders",
		New Structure("Fields, Data", Fields, DocumentDataTables.ReceiptOrders));
	
	// GoodsReceiptSchedule
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Order", "Order");
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.GoodsReceiptSchedule",
		New Structure("Fields, Data", Fields, DocumentDataTables.GoodsReceiptSchedule_Expense));
	
	// OrderProcurement
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Order", "Order");
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.OrderProcurement",
		New Structure("Fields, Data", Fields, DocumentDataTables.OrderProcurement));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance (SyplyRequest + New) 
	// OrderBalance_PurchaseBasis [Expense] 
	// OrderBalance_New [Receipt]
	ArrayOfTables = New Array();
	
	Table1 = Parameters.DocumentDataTables.OrderBalance_PurchaseBasis.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	If Table1.Count() Then
		ArrayOfTables.Add(Table1);
	EndIf;
	
	Table2 = Parameters.DocumentDataTables.OrderBalance_New.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	If Table2.Count() Then
		ArrayOfTables.Add(Table2);
	EndIf;
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Store, Order, ItemKey, RowKey, Quantity"),
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
	// StockReservation_Receipt [Receipt]  
	// StockReservation_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Store, ItemKey, Quantity"),
			Parameters.IsReposting));
	
	// ReceiptOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReceiptOrders,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReceiptOrders,
			Parameters.IsReposting));
	
	// GoodsReceiptSchedule
	// GoodsReceiptSchedule_Receipt [Receipt]  
	// GoodsReceiptSchedule_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.GoodsReceiptSchedule_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.GoodsReceiptSchedule_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsReceiptSchedule,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Order, Store, ItemKey, RowKey, Quantity, DeliveryDate"),
			Parameters.IsReposting));
	
	// OrderProcurement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderProcurement,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderProcurement,
			Parameters.IsReposting));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	
	Tables.Insert("OrderBalance_Current"
		, PostingServer.GetCurrentRecords(Ref, Metadata.AccumulationRegisters.OrderBalance));
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.OrderBalance_Current));
	
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion