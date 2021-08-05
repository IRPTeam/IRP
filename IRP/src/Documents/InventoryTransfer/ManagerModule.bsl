#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return New Structure();
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();		
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
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
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);
		
		Filter = New Structure("RecordType", AccumulationRecordType.Expense);
		
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks"          , FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks"        , ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks"   , Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks" , Exists_ActualStocksTable.Copy(Filter));
		
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);
		
		
		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks"          , FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks"        , ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks"   , Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks" , Exists_ActualStocksTable.Copy(Filter));
		
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);
	Else
		// is unposting
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);
	EndIf;
EndProcedure

#EndRegion

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
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
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
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
		|	InventoryTransferItemList.Ref.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	InventoryTransferItemList.Ref.Branch AS Branch
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
		|NOT ItemList.UseGoodsReceipt";
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
		|	ItemList.Company,
		|	ItemList.Branch,
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
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreReceiver,
		|	ItemLIst.ItemKey,
		|	ItemList.Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

