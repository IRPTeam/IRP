#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	InventoryTransferItemList.Ref.Company AS Company,
		|	InventoryTransferItemList.Ref.StoreSender AS StoreSender,
		|	InventoryTransferItemList.Ref.StoreReceiver AS StoreReceiver,
		|	InventoryTransferItemList.InventoryTransferOrder AS Order,
		|	InventoryTransferItemList.ItemKey AS ItemKey,
		|	SUM(InventoryTransferItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	InventoryTransferItemList.Unit,
		|	InventoryTransferItemList.Key AS RowKey,
		|	InventoryTransferItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InventoryTransferItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InventoryTransferItemList.ItemKey.Item AS Item,
		|	InventoryTransferItemList.Ref.Date AS Period,
		|	InventoryTransferItemList.Ref AS ReceiptBasis,
		|	InventoryTransferItemList.Ref AS ShipmentBasis
		|FROM
		|	Document.InventoryTransfer.ItemList AS InventoryTransferItemList
		|WHERE
		|	InventoryTransferItemList.Ref = &Ref
		|GROUP BY
		|	InventoryTransferItemList.Ref.Company,
		|	InventoryTransferItemList.Ref.StoreSender,
		|	InventoryTransferItemList.Ref.StoreReceiver,
		|	InventoryTransferItemList.InventoryTransferOrder,
		|	InventoryTransferItemList.Key,
		|	InventoryTransferItemList.ItemKey,
		|	InventoryTransferItemList.Unit,
		|	InventoryTransferItemList.ItemKey.Item.Unit,
		|	InventoryTransferItemList.ItemKey.Unit,
		|	InventoryTransferItemList.ItemKey.Item,
		|	InventoryTransferItemList.Ref.Date,
		|	InventoryTransferItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef)";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.StoreSender AS StoreSender,
		|	QueryTable.StoreReceiver AS StoreReceiver,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.StoreReceiver,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Order <> VALUE(Document.InventoryTransferOrder.EmptyRef)
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.StoreReceiver,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|// 2//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Order = VALUE(Document.InventoryTransferOrder.EmptyRef)
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 3//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|;
		|
		|// 4//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 5//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("ItemList_TransferOrderBalance", QueryResults[1].Unload());
	Tables.Insert("ItemList_StockReservation_Sender", QueryResults[2].Unload());
	Tables.Insert("ItemList_StockBalance_Receiver", QueryResults[3].Unload());
	Tables.Insert("ItemList_StockReservation_Receiver", QueryResults[4].Unload());
	Tables.Insert("ItemList_StockBalance_Sender", QueryResults[5].Unload());
	
	Header = New Structure();
	Header.Insert("StoreReceiverUseGoodsReceipt", Ref.StoreReceiver.UseGoodsReceipt);
	Header.Insert("StoreSenderUseShipmentConfirmation", Ref.StoreSender.UseShipmentConfirmation);
	
	Tables.Insert("Header", Header);
	
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
		New Structure("Fields, Data", Fields, DocumentDataTables.ItemList_TransferOrderBalance));
	
	If Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockReservation_Sender));
		
		// GoodsInTransitIncoming (Receiver) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ReceiptBasis", "ReceiptBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Receiver));
		
		// GoodsInTransitOutgoing (Sender) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ShipmentBasis", "ShipmentBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Sender));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) 		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockReservation_Sender));
		
		// GoodsInTransitIncoming (Receiver) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ReceiptBasis", "ReceiptBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Receiver));
		
		
		// StockBalance (Sender) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Sender));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver)	 	
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Sender);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Receiver);
		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey")));
		
		
		// StockBalance (Receiver) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Receiver));
		
		// GoodsInTransitOutgoing (Sender) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ShipmentBasis", "ShipmentBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Sender));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Sender);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Receiver);
		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey")));
		
		// StockBalance (Sender and Receiver) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Sender);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Receiver);
		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
			New Structure("Fields, Data", Fields,
				PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey")));
		
	EndIf;
	
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
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ItemList_TransferOrderBalance,
			Parameters.IsReposting));
	
	If Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) ItemList_StockReservation_Sender [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockReservation_Sender,
				Parameters.IsReposting));
		
		
		// GoodsInTransitIncoming (Receiver) ItemList_StockBalance_Receiver [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Receiver,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Sender) ItemList_StockBalance_Sender [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Sender,
				Parameters.IsReposting));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) ItemList_StockReservation_Sender [Expense] 		 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockReservation_Sender,
				Parameters.IsReposting));
		
		// GoodsInTransitIncoming (Receiver) ItemList_StockBalance_Receiver [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Receiver,
				Parameters.IsReposting));
		
		// StockBalance (Sender) ItemList_StockBalance_Sender [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockBalance_Sender,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		// ItemList_StockReservation_Sender [Expense] 
		// ItemList_StockReservation_Receiver [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockReservation_Sender = Parameters.DocumentDataTables.ItemList_StockReservation_Sender.Copy();
		ItemList_StockReservation_Sender.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Sender.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Sender);
		
		ItemList_StockReservation_Receiver = Parameters.DocumentDataTables.ItemList_StockReservation_Receiver.Copy();
		ItemList_StockReservation_Receiver.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Receiver.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Receiver);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
		// StockBalance (Receiver) ItemList_StockBalance_Receiver 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Receiver,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Sender) ItemList_StockBalance_Sender [Receipt] 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Sender,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		// ItemList_StockReservation_Sender [Expense]  
		// ItemList_StockReservation_Receiver [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockReservation_Sender = Parameters.DocumentDataTables.ItemList_StockReservation_Sender.Copy();
		ItemList_StockReservation_Sender.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Sender.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Sender);
		
		ItemList_StockReservation_Receiver = Parameters.DocumentDataTables.ItemList_StockReservation_Receiver.Copy();
		ItemList_StockReservation_Receiver.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Receiver.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Receiver);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
		
		// StockBalance (Sender and Receiver) 
		// ItemList_StockBalance_Sender [Expense]  
		// ItemList_StockBalance_Receiver [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockBalance_Sender = Parameters.DocumentDataTables.ItemList_StockBalance_Sender.Copy();
		ItemList_StockBalance_Sender.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockBalance_Sender.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockBalance_Sender);
		
		ItemList_StockBalance_Receiver = Parameters.DocumentDataTables.ItemList_StockBalance_Receiver.Copy();
		ItemList_StockBalance_Receiver.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockBalance_Receiver.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockBalance_Receiver);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
	EndIf;
	
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

