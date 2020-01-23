#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AddAttributesTable = New ValueTable();
	If TypeOf(AddInfo) = Type("Structure") And AddInfo.Property("AddAttributesTable") Then
		AddAttributesTable = AddInfo.AddAttributesTable;
	EndIf;
	
	ItemKey = Catalogs.ItemKeys.FindOrCreateRefByBoxing(Ref, Ref.ItemBox, AddAttributesTable, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	BoxingItemList.Ref.Company AS Company,
		|	BoxingItemList.Ref.Store AS Store,
		|	BoxingItemList.Ref.Receipt AS Receipt,
		|	BoxingItemList.Ref.WriteOff AS WriteOff,
		|	BoxingItemList.ItemKey AS ItemKey,
		|	SUM(BoxingItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	BoxingItemList.Unit,
		|	BoxingItemList.ItemKey.Item.Unit AS ItemUnit,
		|	BoxingItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	BoxingItemList.ItemKey.Item AS Item,
		|	BoxingItemList.Ref.Date AS Period,
		|	BoxingItemList.Ref AS ReceiptBasis,
		|	BoxingItemList.Ref AS ShipmentBasis,
		|   BoxingItemList.Key AS RowKey
		|FROM
		|	Document.Boxing.ItemList AS BoxingItemList
		|WHERE
		|	BoxingItemList.Ref = &Ref
		|GROUP BY
		|	BoxingItemList.Ref.Company,
		|	BoxingItemList.Ref.Store,
		|	BoxingItemList.ItemKey,
		|	BoxingItemList.Unit,
		|	BoxingItemList.ItemKey.Item.Unit,
		|	BoxingItemList.ItemKey.Unit,
		|	BoxingItemList.ItemKey.Item,
		|	BoxingItemList.Ref.Date,
		|	BoxingItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef),
		|	BoxingItemList.Ref.Receipt,
		|	BoxingItemList.Ref.WriteOff,
		|   BoxingItemList.Key";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_ItemList = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_ItemList);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Boxing.Company,
		|	Boxing.Store,
		|	Boxing.Receipt,
		|	Boxing.WriteOff,
		|	&ItemKey,
		|	1 AS Quantity,
		|	0 AS BasisQuantity,
		|	Boxing.ItemBox.Unit AS Unit,
		|	Boxing.ItemBox.Unit AS ItemUnit,
		|	&ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	Boxing.ItemBox AS Item,
		|	Boxing.Date AS Period,
		|	Boxing.Ref AS ReceiptBasis,
		|	Boxing.Ref AS ShipmentBasis,
		|   &RowKey AS RowKey
		|FROM
		|	Document.Boxing AS Boxing
		|WHERE
		|	Boxing.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("ItemKeyUnit", ItemKey.Unit);
	Query.SetParameter("RowKey", Ref.UUID());
	QueryResults = Query.Execute();
	
	QueryTable_Header = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_Header);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.Receipt AS Receipt,
		|	QueryTable.WriteOff AS WriteOff,
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
		|	QueryTable.Receipt AS Receipt,
		|	QueryTable.WriteOff AS WriteOff,
		|	QueryTable.ItemKey AS ItemKey,
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
		|WHERE
		|	tmp.WriteOff
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
		|	tmp.Receipt
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
		|	tmp.Receipt
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
		|WHERE
		|	tmp.WriteOff
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|;
		|
		|// 6//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SUM(tmp_ItemList.Quantity / tmp_Header.Quantity) AS Quantity,
		|	tmp_ItemList.ItemKey AS ItemKey,
		|	tmp_Header.ItemKey AS ItemKeyBox,
		|	tmp_Header.Period AS Period
		|FROM
		|	tmp_Header AS tmp_Header
		|		LEFT JOIN tmp_ItemList AS tmp_ItemList
		|		ON TRUE
		|GROUP BY
		|	tmp_ItemList.ItemKey,
		|	tmp_Header.ItemKey,
		|	tmp_Header.Period";
	
	Query.SetParameter("QueryTable_ItemList", QueryTable_ItemList);
	Query.SetParameter("QueryTable_Header", QueryTable_Header);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("ItemList_StockReservation_Outgoing", QueryResults[2].Unload());
	Tables.Insert("ItemList_StockBalance_Incoming", QueryResults[3].Unload());
	Tables.Insert("ItemList_StockReservation_Incoming", QueryResults[4].Unload());
	Tables.Insert("ItemList_StockBalance_Outgoing", QueryResults[5].Unload());
	Tables.Insert("BoxContents", QueryResults[6].Unload());
	
	Header = New Structure();
	Header.Insert("StoreUseGoodsReceipt", Ref.Store.UseGoodsReceipt);
	Header.Insert("StoreUseShipmentConfirmation", Ref.Store.UseShipmentConfirmation);
	
	Tables.Insert("Header", Header);
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// BoxContents 		
	Fields = New Map();
	Fields.Insert("ItemKeyBox", "ItemKeyBox");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("InformationRegister.BoxContents",
		New Structure("Fields, Data", Fields,
			DocumentDataTables.BoxContents));
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockReservation_Outgoing));
		
		// GoodsInTransitIncoming (Incoming) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ReceiptBasis", "ReceiptBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Incoming));
		
		// GoodsInTransitOutgoing (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ShipmentBasis", "ShipmentBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Outgoing));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockReservation_Outgoing));
		
		// GoodsInTransitIncoming (Incoming) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ReceiptBasis", "ReceiptBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitIncoming",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Incoming));
		
		
		// StockBalance (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockBalance",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Outgoing));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming)	 	
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Outgoing);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Incoming);
		
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
				DocumentDataTables.ItemList_StockBalance_Incoming));
		
		// GoodsInTransitOutgoing (Outgoing) 
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ShipmentBasis", "ShipmentBasis");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.GoodsInTransitOutgoing",
			New Structure("Fields, Data", Fields,
				DocumentDataTables.ItemList_StockBalance_Outgoing));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Outgoing);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Incoming);
		
		Fields = New Map();
		Fields.Insert("Store", "Store");
		Fields.Insert("ItemKey", "ItemKey");
		
		DataMapWithLockFields.Insert("AccumulationRegister.StockReservation",
			New Structure("Fields, Data", Fields,
				PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey")));
		
		// StockBalance (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Outgoing);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Incoming);
		
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
	
	// BoxContents 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.BoxContents,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.BoxContents,
			Parameters.IsReposting));
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) ItemList_StockReservation_Outgoing [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockReservation_Outgoing,
				Parameters.IsReposting));
		
		
		// GoodsInTransitIncoming (Incoming) ItemList_StockBalance_Incoming [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Incoming,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Outgoing) ItemList_StockBalance_Outgoing [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Outgoing,
				Parameters.IsReposting));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) ItemList_StockReservation_Outgoing [Expense] 		 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockReservation_Outgoing,
				Parameters.IsReposting));
		
		// GoodsInTransitIncoming (Incoming) ItemList_StockBalance_Incoming [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Incoming,
				Parameters.IsReposting));
		
		// StockBalance (Outgoing) ItemList_StockBalance_Outgoing [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.ItemList_StockBalance_Outgoing,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		// ItemList_StockReservation_Outgoing [Expense] 
		// ItemList_StockReservation_Incoming [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockReservation_Outgoing = Parameters.DocumentDataTables.ItemList_StockReservation_Outgoing.Copy();
		ItemList_StockReservation_Outgoing.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Outgoing.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Outgoing);
		
		ItemList_StockReservation_Incoming = Parameters.DocumentDataTables.ItemList_StockReservation_Incoming.Copy();
		ItemList_StockReservation_Incoming.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Incoming.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Incoming);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
		// StockBalance (Incoming) ItemList_StockBalance_Incoming 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Incoming,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Outgoing) ItemList_StockBalance_Outgoing [Receipt] 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.ItemList_StockBalance_Outgoing,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		// ItemList_StockReservation_Outgoing [Expense]  
		// ItemList_StockReservation_Incoming [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockReservation_Outgoing = Parameters.DocumentDataTables.ItemList_StockReservation_Outgoing.Copy();
		ItemList_StockReservation_Outgoing.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Outgoing.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Outgoing);
		
		ItemList_StockReservation_Incoming = Parameters.DocumentDataTables.ItemList_StockReservation_Incoming.Copy();
		ItemList_StockReservation_Incoming.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockReservation_Incoming.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockReservation_Incoming);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				Parameters.IsReposting));
		
		
		// StockBalance (Outgoing and Incoming) 
		// ItemList_StockBalance_Outgoing [Expense]  
		// ItemList_StockBalance_Incoming [Receipt]
		ArrayOfTables = New Array();
		ItemList_StockBalance_Outgoing = Parameters.DocumentDataTables.ItemList_StockBalance_Outgoing.Copy();
		ItemList_StockBalance_Outgoing.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockBalance_Outgoing.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(ItemList_StockBalance_Outgoing);
		
		ItemList_StockBalance_Incoming = Parameters.DocumentDataTables.ItemList_StockBalance_Incoming.Copy();
		ItemList_StockBalance_Incoming.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		ItemList_StockBalance_Incoming.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(ItemList_StockBalance_Incoming);
		
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

