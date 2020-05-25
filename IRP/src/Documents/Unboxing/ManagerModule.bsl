#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	UnboxingItemList.Ref.Company AS Company,
		|	UnboxingItemList.Ref.Store AS Store,
		|	UnboxingItemList.ItemKey AS ItemKey,
		|	SUM(UnboxingItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	UnboxingItemList.Unit,
		|	UnboxingItemList.ItemKey.Item.Unit AS ItemUnit,
		|	UnboxingItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	UnboxingItemList.ItemKey.Item AS Item,
		|	UnboxingItemList.Ref.Date AS Period,
		|	UnboxingItemList.Ref AS ReceiptBasis,
		|	UnboxingItemList.Ref AS ShipmentBasis,
		|   UnboxingItemList.Key AS RowKey
		|FROM
		|	Document.Unboxing.ItemList AS UnboxingItemList
		|WHERE
		|	UnboxingItemList.Ref = &Ref
		|GROUP BY
		|	UnboxingItemList.Ref.Company,
		|	UnboxingItemList.Ref.Store,
		|	UnboxingItemList.ItemKey,
		|	UnboxingItemList.Unit,
		|	UnboxingItemList.ItemKey.Item.Unit,
		|	UnboxingItemList.ItemKey.Unit,
		|	UnboxingItemList.ItemKey.Item,
		|	UnboxingItemList.Ref.Date,
		|	UnboxingItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef),
		|   UnboxingItemList.Key";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_ItemList = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_ItemList);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Unboxing.Company,
		|	Unboxing.Store,
		|	Unboxing.ItemKeyBox AS ItemKey,
		|	Unboxing.WriteOff AS WriteOff,
		|	1 AS Quantity,
		|	0 AS BasisQuantity,
		|	Unboxing.ItemKeyBox.Item.Unit AS Unit,
		|	Unboxing.ItemKeyBox.Item.Unit AS ItemUnit,
		|	Unboxing.ItemKeyBox.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	Unboxing.ItemKeyBox.Item AS Item,
		|	Unboxing.Date AS Period,
		|	Unboxing.Ref AS ReceiptBasis,
		|	Unboxing.Ref AS ShipmentBasis,
		|   &RowKey AS RowKey
		|FROM
		|	Document.Unboxing AS Unboxing
		|WHERE
		|	Unboxing.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("RowKey", Ref.UUID());
	
	QueryResults = Query.Execute();
	
	QueryTable_Header = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_Header);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|   QueryTable.RowKey AS RowKey
		|INTO tmp_ItemList
		|FROM
		|	&QueryTable_ItemList AS QueryTable
		|;
		|
		|// 1//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.WriteOff AS WriteOff,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|   QueryTable.RowKey
		|INTO tmp_Header
		|FROM
		|	&QueryTable_Header AS QueryTable
		|;
		|
		|// 2//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp_ItemList AS tmp
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
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp_Header AS tmp
		|WHERE
		|	tmp.WriteOff
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|	tmp.Store,
		|   tmp.RowKey
		|;
		|
		|// 4//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp_Header AS tmp
		|WHERE
		|	tmp.WriteOff
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Store,
		|	tmp.Period
		|;
		|
		|// 5//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp_ItemList AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey";
	
	Query.SetParameter("QueryTable_ItemList", QueryTable_ItemList);
	Query.SetParameter("QueryTable_Header", QueryTable_Header);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("ItemList_StockReservation_Receipt", QueryResults[2].Unload());
	Tables.Insert("ItemList_StockBalance_WriteOff", QueryResults[3].Unload());
	Tables.Insert("ItemList_StockReservation_WriteOff", QueryResults[4].Unload());
	Tables.Insert("ItemList_StockBalance_Receipt", QueryResults[5].Unload());
	
	Header = New Structure();
	Header.Insert("StoreUseGoodsReceipt", Ref.Store.UseGoodsReceipt);
	Header.Insert("StoreUseShipmentConfirmation", Ref.Store.UseShipmentConfirmation);
	
	Tables.Insert("Header", Header);
	
	Tables.Insert("QueryTable_ItemList", QueryTable_ItemList);
	Tables.Insert("QueryTable_Header", QueryTable_Header);
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockReservation_WriteOff));
		
		// GoodsInTransitIncoming (Incoming) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ReceiptBasis", "ReceiptBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Receipt));
		
		// GoodsInTransitOutgoing (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ShipmentBasis", "ShipmentBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_WriteOff));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockReservation_WriteOff));
		
		// GoodsInTransitIncoming (Incoming) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ReceiptBasis", "ReceiptBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Receipt));
		
		
		// StockBalance (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_WriteOff));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming)	 	
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_WriteOff);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Receipt);
		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey")));
		
		// StockBalance (Incoming) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Receipt));
		
		// GoodsInTransitOutgoing (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ShipmentBasis", "ShipmentBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_WriteOff));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_WriteOff);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Receipt);
		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey")));
		
		// StockBalance (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_WriteOff);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Receipt);
		
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
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) ItemList_StockReservation_WriteOff [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockReservation_WriteOff,
				Parameters.IsReposting));
		
		
		// GoodsInTransitIncoming (Incoming) ItemList_StockBalance_Receipt [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Receipt,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Outgoing) ItemList_StockBalance_WriteOff [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_WriteOff,
				Parameters.IsReposting));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) ItemList_StockReservation_WriteOff [Expense] 		 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockReservation_WriteOff,
				Parameters.IsReposting));
		
		// GoodsInTransitIncoming (Incoming) ItemList_StockBalance_Receipt [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Receipt,
				Parameters.IsReposting));
		
		// StockBalance (Outgoing) ItemList_StockBalance_WriteOff [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockBalance_WriteOff,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		// ItemList_StockReservation_WriteOff [Expense] 
		// ItemList_StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockReservation_WriteOff = Parameters.DocumentDataTables.ItemList_StockReservation_WriteOff.Copy();
		ItemList_StockReservation_WriteOff.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_WriteOff.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_WriteOff);
		
		ItemList_StockReservation_Receipt = Parameters.DocumentDataTables.ItemList_StockReservation_Receipt.Copy();
		ItemList_StockReservation_Receipt.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Receipt.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Receipt);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
		// StockBalance (Incoming) ItemList_StockBalance_Receipt 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Receipt,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Outgoing) ItemList_StockBalance_WriteOff [Receipt] 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_WriteOff,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		// ItemList_StockReservation_WriteOff [Expense]  
		// ItemList_StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockReservation_WriteOff = Parameters.DocumentDataTables.ItemList_StockReservation_WriteOff.Copy();
		ItemList_StockReservation_WriteOff.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_WriteOff.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_WriteOff);
		
		ItemList_StockReservation_Receipt = Parameters.DocumentDataTables.ItemList_StockReservation_Receipt.Copy();
		ItemList_StockReservation_Receipt.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Receipt.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Receipt);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
		// StockBalance (Outgoing and Incoming) 
		// ItemList_StockBalance_WriteOff [Expense]  
		// ItemList_StockBalance_Receipt [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockBalance_WriteOff = Parameters.DocumentDataTables.ItemList_StockBalance_WriteOff.Copy();
		ItemList_StockBalance_WriteOff.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockBalance_WriteOff.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockBalance_WriteOff);
		
		ItemList_StockBalance_Receipt = Parameters.DocumentDataTables.ItemList_StockBalance_Receipt.Copy();
		ItemList_StockBalance_Receipt.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockBalance_Receipt.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockBalance_Receipt);
		
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

