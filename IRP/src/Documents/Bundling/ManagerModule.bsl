#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Specification = FindOrCreateSpecificationByProperties(Ref, AddInfo);
	ItemKey = Catalogs.ItemKeys.FindOrCreateRefBySpecification(Specification, Ref.ItemBundle, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	BundlingItemList.Ref.Company AS Company,
		|	BundlingItemList.Ref.Store AS Store,
		|	BundlingItemList.ItemKey AS ItemKey,
		|	SUM(BundlingItemList.Quantity) * BundlingItemList.Ref.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	BundlingItemList.Unit,
		|	BundlingItemList.ItemKey.Item.Unit AS ItemUnit,
		|	BundlingItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	BundlingItemList.ItemKey.Item AS Item,
		|	BundlingItemList.Ref.Date AS Period,
		|	BundlingItemList.Ref AS ReceiptBasis,
		|	BundlingItemList.Ref AS ShipmentBasis,
		|	BundlingItemList.Key AS RowKey
		|FROM
		|	Document.Bundling.ItemList AS BundlingItemList
		|WHERE
		|	BundlingItemList.Ref = &Ref
		|GROUP BY
		|	BundlingItemList.Ref.Company,
		|	BundlingItemList.Ref.Store,
		|	BundlingItemList.ItemKey,
		|	BundlingItemList.Unit,
		|	BundlingItemList.ItemKey.Item.Unit,
		|	BundlingItemList.ItemKey.Unit,
		|	BundlingItemList.ItemKey.Item,
		|	BundlingItemList.Ref.Date,
		|	BundlingItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef),
		|   BundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_ItemList = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_ItemList);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Bundling.Company,
		|	Bundling.Store,
		|	&ItemKey,
		|	Bundling.Quantity,
		|	0 AS BasisQuantity,
		|	Bundling.Unit,
		|	Bundling.ItemBundle.Unit AS ItemUnit,
		|	&ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	Bundling.ItemBundle AS Item,
		|	Bundling.Date AS Period,
		|	Bundling.Ref AS ReceiptBasis,
		|	Bundling.Ref AS ShipmentBasis,
		|   &RowKey AS RowKey
		|FROM
		|	Document.Bundling AS Bundling
		|WHERE
		|	Bundling.Ref = &Ref";
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
		|// 1//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|   QueryTable.RowKey AS RowKey
		|INTO tmp_Header
		|FROM
		|	&QueryTable_Header AS QueryTable
		|;
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|	tmp.Store,
		|   tmp.RowKey
		|;
		|// 4//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp_Header AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Store,
		|	tmp.Period
		|;
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
		|   tmp.RowKey
		|;
		|// 6//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SUM(tmp_ItemList.Quantity / tmp_Header.Quantity) AS Quantity,
		|	tmp_ItemList.ItemKey AS ItemKey,
		|	tmp_Header.ItemKey AS ItemKeyBundle,
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
	Tables.Insert("BundleContents", QueryResults[6].Unload());
	
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
	
	// BundleContents 
	BundleContents = InformationRegisters.BundleContents.GetLockFields(DocumentDataTables.BundleContents);
	DataMapWithLockFields.Insert(BundleContents.RegisterName, BundleContents.LockInfo);
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.ItemList_StockReservation_Outgoing);
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// GoodsInTransitIncoming (Incoming) 
		GoodsInTransitIncoming = 
		AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.ItemList_StockBalance_Incoming);
		DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
		
		// GoodsInTransitOutgoing (Outgoing) 
		GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.ItemList_StockBalance_Outgoing);
		DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.ItemList_StockReservation_Outgoing);
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// GoodsInTransitIncoming (Incoming) 
		GoodsInTransitIncoming = 
		AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.ItemList_StockBalance_Incoming);
		DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
		
		// StockBalance (Outgoing) 
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.ItemList_StockBalance_Outgoing);
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming)	 	
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Outgoing);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Incoming);
		
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// StockBalance (Incoming) 
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.ItemList_StockBalance_Incoming);
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
		// GoodsInTransitOutgoing (Outgoing) 
		GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.ItemList_StockBalance_Outgoing);
		DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 		
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Outgoing);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockReservation_Incoming);
		
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// StockBalance (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Outgoing);
		ArrayOfTables.Add(DocumentDataTables.ItemList_StockBalance_Incoming);
		
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
	Else
		Raise R()["Exc_002"];
	EndIf;
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// BundleContents 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.BundleContents,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.BundleContents,
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
	Else
		Raise R()["Exc_002"];
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

#Region Specifications

Function FindOrCreateSpecificationByProperties(Ref, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	BundlingItemList.Key,
		|	BundlingItemList.ItemKey.Item AS Item,
		|	ItemKeysAddAttributes.Property AS Attribute,
		|	ItemKeysAddAttributes.Value
		|FROM
		|	Catalog.ItemKeys.AddAttributes AS ItemKeysAddAttributes
		|		INNER JOIN Document.Bundling.ItemList AS BundlingItemList
		|		ON BundlingItemList.ItemKey = ItemKeysAddAttributes.Ref
		|		AND BundlingItemList.Ref = &Ref
		|GROUP BY
		|	BundlingItemList.ItemKey.Item,
		|	ItemKeysAddAttributes.Property,
		|	ItemKeysAddAttributes.Value,
		|	BundlingItemList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BundlingItemList.Key,
		|	BundlingItemList.ItemKey.Item AS Item,
		|	SUM(BundlingItemList.Quantity) AS Quantity
		|FROM
		|	Document.Bundling.ItemList AS BundlingItemList
		|WHERE
		|	BundlingItemList.Ref = &Ref
		|GROUP BY
		|	BundlingItemList.ItemKey.Item,
		|	BundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	ArrayOfQueryResults = Query.ExecuteBatch();
	
	ArrayOfSpecifications = Catalogs.Specifications.FindOrCreateRefByProperties(ArrayOfQueryResults[0].Unload()
			, ArrayOfQueryResults[1].Unload()
			, Ref.ItemBundle
			, AddInfo);
	If ArrayOfSpecifications.Count() Then
		Return ArrayOfSpecifications[0];
	Else
		Return Catalogs.Specifications.EmptyRef();
	EndIf;
EndFunction

#EndRegion