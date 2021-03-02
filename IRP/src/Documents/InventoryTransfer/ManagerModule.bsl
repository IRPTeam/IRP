#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("TransferOrderBalance"     , PostingServer.CreateTable(AccReg.TransferOrderBalance));
	Tables.Insert("StockReservation_Expense" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Receipt" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Expense"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Receipt"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Transit"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("GoodsInTransitIncoming"   , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("GoodsInTransitOutgoing"   , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextInventoryTransferItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.TransferOrderBalance     = QueryResults[1].Unload();
	Tables.StockReservation_Expense = QueryResults[2].Unload();
	Tables.StockReservation_Receipt = QueryResults[4].Unload();
	Tables.StockBalance_Expense     = QueryResults[5].Unload();
	Tables.StockBalance_Receipt     = QueryResults[3].Unload();
	Tables.GoodsInTransitIncoming   = QueryResults[6].Unload();
	Tables.GoodsInTransitOutgoing   = QueryResults[7].Unload();
	Tables.StockBalance_Transit     = QueryResults[8].Unload();
	
	Header = New Structure();
	Header.Insert("StoreReceiverUseGoodsReceipt", Ref.StoreReceiver.UseGoodsReceipt);
	Header.Insert("StoreSenderUseShipmentConfirmation", Ref.StoreSender.UseShipmentConfirmation);
	
	Tables.Insert("Header", Header);
	
	Parameters.IsReposting = False;

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function GetQueryTextInventoryTransferItemList()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO RowIDInfo
	|FROM
	|	Document.InventoryTransfer.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	InventoryTransferItemList.Ref.Company AS Company,
	|	InventoryTransferItemList.Ref.StoreSender AS StoreSender,
	|	InventoryTransferItemList.Ref.StoreReceiver AS StoreReceiver,
	|	InventoryTransferItemList.Ref.StoreTransit AS StoreTransit,
	|	InventoryTransferItemList.InventoryTransferOrder AS Order,
	|	InventoryTransferItemList.ItemKey AS ItemKey,
	|	InventoryTransferItemList.Quantity AS Quantity,
	|	0 AS BasisQuantity,
	|	InventoryTransferItemList.Unit,
	|	RowIDInfo.RowID AS RowKey,
	|	InventoryTransferItemList.ItemKey.Item.Unit AS ItemUnit,
	|	InventoryTransferItemList.ItemKey.Unit AS ItemKeyUnit,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
	|	InventoryTransferItemList.ItemKey.Item AS Item,
	|	InventoryTransferItemList.Ref.Date AS Period,
	|	InventoryTransferItemList.Ref AS ReceiptBasis,
	|	InventoryTransferItemList.Ref AS ShipmentBasis
	|FROM
	|	Document.InventoryTransfer.ItemList AS InventoryTransferItemList
	|		LEFT JOIN RowIDInfo AS RowIDInfo
	|		ON InventoryTransferItemList.Key = RowIDInfo.Key
	|WHERE
	|	InventoryTransferItemList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
	"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.StoreSender AS StoreSender,
		|	QueryTable.StoreReceiver AS StoreReceiver,
		|	QueryTable.StoreTransit AS StoreTransit,
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
		|// 1 - OrderBalance//////////////////////////////////////////////////////////////////////////////
		|SELECT
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
		|	tmp.StoreSender,
		|	tmp.StoreReceiver,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|// 2 - StockReservation_Expense //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Order = VALUE(Document.InventoryTransferOrder.EmptyRef)
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 3 - StockBalance_Receipt//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 4 - StockReservation_Receipt //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 5 - StockBalance_Expense //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|// 6 - GoodsInTransitIncoming//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|   tmp.RowKey
		|;
		|// 7 - GoodsInTransitOutgoing //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|;
		|// 8 - StockBalance_Transit //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|Where
		|	tmp.StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.StoreTransit,
		|	tmp.ItemKey,
		|	tmp.Period
		|";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();		
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// TransferOrderBalance 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TransferOrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.TransferOrderBalance,
			Parameters.IsReposting));
	
	If Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) StockReservation_Expense [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockReservation_Expense,
				True));
		
		
		// GoodsInTransitIncoming (Receiver) GoodsInTransitIncoming [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitIncoming,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Sender) GoodsInTransitOutgoing [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitOutgoing,
				Parameters.IsReposting));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) StockReservation_Expense [Expense] 		 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockReservation_Expense,
				True));
		
		// GoodsInTransitIncoming (Receiver) GoodsInTransitIncoming [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitIncoming,
				Parameters.IsReposting));
		
		// StockBalance (Sender) 
		// StockBalance_Expense [Expense]
		// StockBalance_Transit [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockBalance_Transit.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		// StockReservation_Expense [Expense] 
		// StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
		// StockBalance (Receiver) StockBalance_Receipt [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Receipt,
				True));
		
		// GoodsInTransitOutgoing (Sender) GoodsInTransitOutgoing [Receipt] 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitOutgoing,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		// StockReservation_Expense [Expense]  
		// StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
		
		// StockBalance (Sender and Receiver) 
		// StockBalance_Expense [Expense]  
		// StockBalance_Receipt [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockBalance_Receipt.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
	EndIf;
	
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
	DataMapWithLockFields = New Map();
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
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	EndIf;
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);
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
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4021B_StockTransferOrdersReceipt());
	QueryArray.Add(R4022B_StockTransferOrdersShipment());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4050B_StockInventory());
	
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	InventoryTransferItemList.Ref.Date AS Period,
		|	InventoryTransferItemList.Ref.Company AS Company,
		|	InventoryTransferItemList.Ref.StoreSender,
		|	InventoryTransferItemList.Ref.StoreReceiver,
		|	InventoryTransferItemList.Ref.StoreTransit,
		|	NOT InventoryTransferItemList.Ref.StoreTransit.Ref IS NULL AS UseStoreTransit,
		|	InventoryTransferItemList.InventoryTransferOrder AS InventoryTransferOrder,
		|	NOT InventoryTransferItemList.InventoryTransferOrder.Ref IS NULL AS InventoryTransferOrderExists,
		|	InventoryTransferItemList.ItemKey,
		|	InventoryTransferItemList.QuantityInBaseUnit AS Quantity,
		|	InventoryTransferItemList.Ref AS Basis,
		|	InventoryTransferItemList.Ref.UseGoodsReceipt AS UseGoodsReceipt,
		|	InventoryTransferItemList.Ref.UseShipmentConfirmation AS UseShipmentConfirmation
		|INTO ItemList
		|FROM
		|	Document.InventoryTransfer.ItemList AS InventoryTransferItemList
		|WHERE
		|	InventoryTransferItemList.Ref = &Ref";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.StoreSender AS Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity,
		|	ItemList.Period
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.UseShipmentConfirmation
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.StoreReceiver AS Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity,
		|	ItemList.Period
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.UseGoodsReceipt";
EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.StoreSender AS Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT InventoryTransferOrderExists
		|	AND NOT ItemList.UseShipmentConfirmation
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.StoreReceiver,
		|	ItemLIst.ItemKey,
		|	ItemList.Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT InventoryTransferOrderExists
		|	AND NOT ItemList.UseGoodsReceipt";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	ItemList.Period AS Period,
		|	ItemList.StoreSender AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		|	SUM(ItemList.Quantity) AS Quantity,
		|	ItemList.UseShipmentConfirmation AS UseShipmentConfirmation
		|INTO TmpItemListGroup
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.UseShipmentConfirmation
		|	AND ItemList.InventoryTransferOrderExists
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.StoreSender,
		|	ItemList.ItemKey,
		|	ItemList.InventoryTransferOrder,
		|	ItemList.UseShipmentConfirmation
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R4012B_StockReservationBalance.Store AS Store,
		|	R4012B_StockReservationBalance.ItemKey AS ItemKey,
		|	R4012B_StockReservationBalance.Order AS Order,
		|	R4012B_StockReservationBalance.QuantityBalance AS QuantityBalance
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.InventoryTransferOrder
		|		FROM
		|			TmpItemListGroup AS ItemList)) AS R4012B_StockReservationBalance
		|WHERE
		|	R4012B_StockReservationBalance.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period AS Period,
		|	ItemListGroup.InventoryTransferOrder AS Order,
		|	ItemListGroup.ItemKey AS ItemKey,
		|	ItemListGroup.Store AS Store,
		|	CASE
		|		WHEN StockReservation.QuantityBalance > ItemListGroup.Quantity
		|			THEN ItemListGroup.Quantity
		|		ELSE StockReservation.QuantityBalance
		|	END AS Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	TmpItemListGroup AS ItemListGroup
		|		INNER JOIN TmpStockReservation AS StockReservation
		|		ON ItemListGroup.InventoryTransferOrder = StockReservation.Order
		|		AND ItemListGroup.ItemKey = StockReservation.ItemKey
		|		AND ItemListGroup.Store = StockReservation.Store";
EndFunction

Function R4021B_StockTransferOrdersReceipt()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.StoreReceiver AS Store,
		|	ItemList.InventoryTransferOrderExists AS Order,
		|	*
		|INTO R4021B_StockTransferOrdersReceipt
		|FROM 
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.InventoryTransferOrderExists
		|	AND NOT ItemList.UseGoodsReceipt";
EndFunction

Function R4022B_StockTransferOrdersShipment()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.StoreSender AS Store,
		|	ItemList.InventoryTransferOrderExists AS Order,
		|	*
		|INTO R4022B_StockTransferOrdersShipment
		|FROM 
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.InventoryTransferOrderExists
		|	AND NOT ItemList.UseShipmentConfirmation";
EndFunction

Function R4031B_GoodsInTransitIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.StoreReceiver AS Store,
		|	ItemList.Basis,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4031B_GoodsInTransitIncoming
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UseGoodsReceipt";
EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.StoreSender AS Store,
		|	ItemList.Basis,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4032B_GoodsInTransitOutgoing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UseShipmentConfirmation";		
EndFunction

Function R4050B_StockInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.StoreSender AS Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.StoreReceiver,
		|	ItemLIst.ItemKey,
		|	ItemList.Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction
	
#EndRegion	

