#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Tables.Insert("ItemListTransferOrderBalance", New ValueTable());
	Tables.Insert("ItemListStockReservation", New ValueTable());
	Tables.Insert("ItemList_OrderBalance", New ValueTable());
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	InventoryTransferOrderItemList.Ref.Company AS Company,
		|	InventoryTransferOrderItemList.Ref.StoreSender AS StoreSender,
		|	InventoryTransferOrderItemList.Ref.StoreReceiver AS StoreReceiver,
		|	InventoryTransferOrderItemList.Ref AS Order,
		|	InventoryTransferOrderItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	InventoryTransferOrderItemList.ItemKey AS ItemKey,
		|	SUM(InventoryTransferOrderItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	InventoryTransferOrderItemList.Unit,
		|	InventoryTransferOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InventoryTransferOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InventoryTransferOrderItemList.ItemKey.Item AS Item,
		|	&Period AS Period,
		|	InventoryTransferOrderItemList.Key AS RowKey
		|FROM
		|	Document.InventoryTransferOrder.ItemList AS InventoryTransferOrderItemList
		|WHERE
		|	InventoryTransferOrderItemList.Ref = &Ref
		|GROUP BY
		|	InventoryTransferOrderItemList.Ref.Company,
		|	InventoryTransferOrderItemList.Ref.StoreSender,
		|	InventoryTransferOrderItemList.Ref.StoreReceiver,
		|	InventoryTransferOrderItemList.Ref,
		|	InventoryTransferOrderItemList.InternalSupplyRequest,
		|	InventoryTransferOrderItemList.ItemKey,
		|	InventoryTransferOrderItemList.Unit,
		|	InventoryTransferOrderItemList.ItemKey.Item.Unit,
		|	InventoryTransferOrderItemList.ItemKey.Unit,
		|	InventoryTransferOrderItemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	InventoryTransferOrderItemList.Key";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.StoreSender AS StoreSender,
		|	QueryTable.StoreReceiver AS StoreReceiver,
		|	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS StoreSender,
		|	tmp.StoreReceiver AS StoreReceiver,
		|	tmp.Order AS Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.StoreReceiver,
		|	tmp.Order,
		|	tmp.RowKey,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.InternalSupplyRequest AS Order,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.InternalSupplyRequest <> VALUE(Document.InternalSupplyRequest.EmptyRef)
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.InternalSupplyRequest,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.ItemListTransferOrderBalance = QueryResults[1].Unload();
	Tables.ItemListStockReservation = QueryResults[2].Unload();
	Tables.ItemList_OrderBalance = QueryResults[3].Unload();
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// TransferOrderBalance
	Fields = New Map();
	Fields.Insert("StoreSender", "StoreSender");
	Fields.Insert("StoreReceiver", "StoreReceiver");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.TransferOrderBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemListTransferOrderBalance));
	
	// StockReservation
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemListStockReservation));
	
	// OrderBalance
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_OrderBalance));
	
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// TransferOrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TransferOrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ItemListTransferOrderBalance,
			Parameters.IsReposting));
	
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemListStockReservation,
			Parameters.IsReposting));
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_OrderBalance,
			Parameters.IsReposting));
	
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

