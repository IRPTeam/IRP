#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	UnbundlingItemList.Ref.Company AS Company,
		|	UnbundlingItemList.Ref.Store AS Store,
		|	UnbundlingItemList.ItemKey AS ItemKey,
		|	SUM(UnbundlingItemList.Quantity) * UnbundlingItemList.Ref.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	UnbundlingItemList.Unit,
		|	UnbundlingItemList.ItemKey.Item.Unit AS ItemUnit,
		|	UnbundlingItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	UnbundlingItemList.ItemKey.Item AS Item,
		|	UnbundlingItemList.Ref.Date AS Period,
		|	UnbundlingItemList.Ref AS ReceiptBasis,
		|	UnbundlingItemList.Ref AS ShipmentBasis,
		|   UnbundlingItemList.Key AS RowKey
		|FROM
		|	Document.Unbundling.ItemList AS UnbundlingItemList
		|WHERE
		|	UnbundlingItemList.Ref = &Ref
		|GROUP BY
		|	UnbundlingItemList.Ref.Company,
		|	UnbundlingItemList.Ref.Store,
		|	UnbundlingItemList.ItemKey,
		|	UnbundlingItemList.Unit,
		|	UnbundlingItemList.ItemKey.Item.Unit,
		|	UnbundlingItemList.ItemKey.Unit,
		|	UnbundlingItemList.ItemKey.Item,
		|	UnbundlingItemList.Ref.Date,
		|	UnbundlingItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef),
		|   UnbundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_ItemList = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_ItemList);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Unbundling.Company,
		|	Unbundling.Store,
		|	Unbundling.ItemKeyBundle AS ItemKey,
		|	Unbundling.Quantity,
		|	0 AS BasisQuantity,
		|	Unbundling.Unit,
		|	Unbundling.ItemKeyBundle.Item.Unit AS ItemUnit,
		|	Unbundling.ItemKeyBundle.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	Unbundling.ItemKeyBundle.Item AS Item,
		|	Unbundling.Date AS Period,
		|	Unbundling.Ref AS ReceiptBasis,
		|	Unbundling.Ref AS ShipmentBasis,
		|   &RowKey AS RowKey
		|FROM
		|	Document.Unbundling AS Unbundling
		|WHERE
		|	Unbundling.Ref = &Ref";
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
		|   tmp.RowKey";
	
	Query.SetParameter("QueryTable_ItemList", QueryTable_ItemList);
	Query.SetParameter("QueryTable_Header", QueryTable_Header);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("ItemList_StockReservation_Incoming", QueryResults[2].Unload());
	Tables.Insert("ItemList_StockBalance_Outgoing", QueryResults[3].Unload());
	Tables.Insert("ItemList_StockReservation_Outgoing", QueryResults[4].Unload());
	Tables.Insert("ItemList_StockBalance_Incoming", QueryResults[5].Unload());
	
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

