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
	IncomingStocksServer.ClosureIncomingStocks(Parameters);
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
	IncomingStocksServer.ClosureIncomingStocks_Unposting(Parameters);
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
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export

	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.InventoryTransfer.ItemList");

	If Not Unposting Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		R4014B_SerialLotNumber =  PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters, True);

		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);
		Exists_R4014B_SerialLotNumber =  PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters, True);

		// Expense

		Filter = New Structure("RecordType", AccumulationRecordType.Expense);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);

		If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
			R4014B_SerialLotNumber.Copy(Filter),
			Exists_R4014B_SerialLotNumber.Copy(Filter),
			AccumulationRecordType.Expense, Unposting, AddInfo) Then
			Cancel = True;
		EndIf;

		// Receipt

		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);

		If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
			R4014B_SerialLotNumber.Copy(Filter),
			Exists_R4014B_SerialLotNumber.Copy(Filter),
			AccumulationRecordType.Receipt, Unposting, AddInfo) Then
			Cancel = True;
		EndIf;
	Else
		// is unposting
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransfer.ItemList", AddInfo);
	EndIf;
EndProcedure

#EndRegion

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
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
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(ConsignorBatches());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4021B_StockTransferOrdersReceipt());
	QueryArray.Add(R4022B_StockTransferOrdersShipment());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R8013B_ConsignorBatchWiseBallance());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	InventoryTransferItemList.Ref.Date AS Period,
		|	InventoryTransferItemList.Ref.Company AS Company,
		|	InventoryTransferItemList.Ref.Branch AS Branch,
		|	InventoryTransferItemList.Ref.StoreSender,
		|	InventoryTransferItemList.Ref.StoreReceiver,
		|	InventoryTransferItemList.Ref.StoreTransit,
		|	NOT InventoryTransferItemList.Ref.StoreTransit.Ref IS NULL AS UseStoreTransit,
		|	CASE
		|		WHEN InventoryTransferItemList.ProductionPlanning.Ref IS NULL
		|			THEN InventoryTransferItemList.InventoryTransferOrder
		|		ELSE InventoryTransferItemList.ProductionPlanning
		|	END AS InventoryTransferOrder,
		|	CASE
		|		WHEN NOT InventoryTransferItemList.ProductionPlanning.Ref IS NULL
		|			THEN TRUE
		|		WHEN NOT InventoryTransferItemList.InventoryTransferOrder.Ref IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS InventoryTransferOrderExists,
		|	InventoryTransferItemList.ItemKey,
		|	InventoryTransferItemList.QuantityInBaseUnit AS Quantity,
		|	InventoryTransferItemList.Ref AS Basis,
		|	InventoryTransferItemList.Ref.UseGoodsReceipt AS UseGoodsReceipt,
		|	InventoryTransferItemList.Ref.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	InventoryTransferItemList.ProductionPlanning AS ProductionPlanning,
		|	NOT InventoryTransferItemList.ProductionPlanning.Ref IS NULL AS UseProductionPlanning,
		|	InventoryTransferItemList.Key AS Key,
		|	InventoryTransferItemList.InventoryOrigin = VALUE(Enum.InventoryOrigingTypes.OwnStocks) AS IsOwnStocks,
		|	InventoryTransferItemList.InventoryOrigin = VALUE(Enum.InventoryOrigingTypes.ConsignorStocks) AS IsConsignorStocks
		|INTO ItemList
		|FROM
		|	Document.InventoryTransfer.ItemList AS InventoryTransferItemList
		|WHERE
		|	InventoryTransferItemList.Ref = &Ref";
EndFunction

Function SerialLotNumbers()
	Return 
	"SELECT
	|	SerialLotNumbers.Ref.Date AS Period,
	|	SerialLotNumbers.Ref.Company AS Company,
	|	SerialLotNumbers.Ref.Branch AS Branch,
	|	SerialLotNumbers.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.SerialLotNumber.StockBalanceDetail AS StockBalanceDetail,
	|	SerialLotNumbers.Quantity,
	|	ItemList.ItemKey AS ItemKey,
	|	SerialLotNumbers.Ref.UseGoodsReceipt AS UseGoodsReceipt,
	|	SerialLotNumbers.Ref.UseShipmentConfirmation AS UseShipmentConfirmation
	|INTO SerialLotNumbers
	|FROM
	|	Document.InventoryTransfer.SerialLotNumbers AS SerialLotNumbers
	|		LEFT JOIN Document.InventoryTransfer.ItemList AS ItemList
	|		ON SerialLotNumbers.Key = ItemList.Key
	|		AND ItemList.Ref = &Ref
	|WHERE
	|	SerialLotNumbers.Ref = &Ref";
EndFunction

Function IncomingStocksReal()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.StoreReceiver AS Store,
		|	ItemList.ItemKey,
		|	ItemList.ProductionPlanning AS Order,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO IncomingStocksReal
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UseProductionPlanning
		|	AND NOT ItemList.UseGoodsReceipt
		|GROUP BY
		|	ItemList.ItemKey,
		|	ItemList.Period,
		|	ItemList.ProductionPlanning,
		|	ItemList.StoreReceiver";
EndFunction

Function ConsignorBatches()
	Return
		"SELECT
		|	ConsignorBatchesInfo.Key,
		|	ConsignorBatchesInfo.ItemKey,
		|	ConsignorBatchesInfo.Store,
		|	ConsignorBatchesInfo.Batch,
		|	ConsignorBatchesInfo.Quantity
		|INTO ConsignorBatchesInfo
		|FROM
		|	Document.InventoryTransfer.ConsignorBatches AS ConsignorBatchesInfo
		|WHERE
		|	ConsignorBatchesInfo.Ref = &Ref";
EndFunction	

Function R4010B_ActualStocks()
	Return 
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	ItemList.Period,
	|	ItemList.StoreSender AS Store,
	|	ItemList.ItemKey,
	|	CASE
	|		WHEN SerialLotNumbers.StockBalanceDetail
	|			THEN SerialLotNumbers.SerialLotNumber
	|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
	|	END AS SerialLotNumber,
	|	SUM(CASE
	|		WHEN SerialLotNumbers.SerialLotNumber IS NULL
	|			THEN ItemList.Quantity
	|		ELSE SerialLotNumbers.Quantity
	|	END) AS Quantity
	|INTO R4010B_ActualStocks
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
	|		ON ItemList.Key = SerialLotNumbers.Key
	|WHERE
	|	NOT ItemList.UseShipmentConfirmation
	|GROUP BY
	|	VALUE(AccumulationRecordType.Expense),
	|	ItemList.Period,
	|	ItemList.StoreSender,
	|	ItemList.ItemKey,
	|	CASE
	|		WHEN SerialLotNumbers.StockBalanceDetail
	|			THEN SerialLotNumbers.SerialLotNumber
	|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
	|	END
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt),
	|	ItemList.Period,
	|	ItemList.StoreReceiver AS Store,
	|	ItemList.ItemKey,
	|	CASE
	|		WHEN SerialLotNumbers.StockBalanceDetail
	|			THEN SerialLotNumbers.SerialLotNumber
	|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
	|	END AS SerialLotNumber,
	|	SUM(CASE
	|		WHEN SerialLotNumbers.SerialLotNumber IS NULL
	|			THEN ItemList.Quantity
	|		ELSE SerialLotNumbers.Quantity
	|	END) AS Quantity
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
	|		ON ItemList.Key = SerialLotNumbers.Key
	|WHERE
	|	NOT ItemList.UseGoodsReceipt
	|GROUP BY
	|	VALUE(AccumulationRecordType.Receipt),
	|	ItemList.Period,
	|	ItemList.StoreReceiver,
	|	ItemList.ItemKey,
	|	CASE
	|		WHEN SerialLotNumbers.StockBalanceDetail
	|			THEN SerialLotNumbers.SerialLotNumber
	|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
	|	END";
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
		|	NOT ItemList.InventoryTransferOrderExists
		|	AND NOT ItemList.UseShipmentConfirmation
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.StoreReceiver,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.UseGoodsReceipt
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	FreeStocks.Period,
		|	FreeStocks.Store,
		|	FreeStocks.ItemKey,
		|	FreeStocks.Quantity
		|FROM
		|	FreeStocks AS FreeStocks";
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
		|		AND ItemListGroup.Store = StockReservation.Store
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	IncomingStocksRequested.Period,
		|	IncomingStocksRequested.Requester,
		|	IncomingStocksRequested.ItemKey,
		|	IncomingStocksRequested.RequesterStore,
		|	IncomingStocksRequested.Quantity
		|FROM
		|	IncomingStocksRequested AS IncomingStocksRequested";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4036B_IncomingStocksRequested
		|FROM
		|	IncomingStocksRequested AS IncomingStocksRequested
		|WHERE
		|	TRUE";
EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	NOT SerialLotNumbers.UseShipmentConfirmation
		   |		AND FALSE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	*
		   |FROM
		   |	SerialLotNumbers AS SerialLotNumbers
		   |WHERE
		   |	NOT SerialLotNumbers.UseGoodsReceipt
		   |		AND FALSE";
EndFunction

Function R4021B_StockTransferOrdersReceipt()
	Return "SELECT
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
	Return "SELECT
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
	Return "SELECT
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
	Return "SELECT
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
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsOwnStocks
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreSender,
		|	ItemList.ItemKey
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreReceiver,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS Quantity
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsOwnStocks
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreReceiver,
		|	ItemList.ItemKey";
EndFunction

Function T3010S_RowIDInfo()
	Return
		"SELECT
		|	RowIDInfo.RowRef AS RowRef,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	RowIDInfo.RowID AS RowID,
		|	RowIDInfo.Basis AS Basis,
		|	ItemList.Key AS Key,
		|	0 AS Price,
		|	UNDEFINED AS Currency,
		|	ItemList.Unit AS Unit
		|INTO T3010S_RowIDInfo
		|FROM
		|	Document.InventoryTransfer.ItemList AS ItemList
		|		INNER JOIN Document.InventoryTransfer.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function T6020S_BatchKeysInfo()
	Return
	"SELECT
	|	ItemList.Period,
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	ItemList.Company,
	|	ItemList.StoreReceiver AS Store,
	|	ItemList.ItemKey,
	|	ConsignorBatchesInfo.Batch AS BatchConsignor,
	|	SUM(case when ConsignorBatchesInfo.Quantity is null then ItemList.Quantity else ConsignorBatchesInfo.Quantity end) AS Quantity
	|INTO T6020S_BatchKeysInfo
	|FROM
	|	ItemList AS ItemList
	|	LEFT JOIN ConsignorBatchesInfo AS ConsignorBatchesInfo ON
	|	ItemList.Key = ConsignorBatchesInfo.Key
	|WHERE
	|	TRUE
	|GROUP BY
	|	ItemList.Period,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	ItemList.Company,
	|	ItemList.StoreReceiver,
	|	ItemList.ItemKey,
	|	ConsignorBatchesInfo.Batch
	|
	|UNION ALL
	|
	|SELECT
	|	ItemList.Period,
	|	VALUE(Enum.BatchDirection.Expense),
	|	ItemList.Company,
	|	ItemList.StoreSender,
	|	ItemList.ItemKey,
	|	ConsignorBatchesInfo.Batch,
	|	SUM(case when ConsignorBatchesInfo.Quantity is null then ItemList.Quantity else ConsignorBatchesInfo.Quantity end) AS Quantity
	|FROM
	|	ItemList AS ItemList
	|	LEFT JOIN ConsignorBatchesInfo AS ConsignorBatchesInfo ON
	|	ItemList.Key = ConsignorBatchesInfo.Key
	|WHERE
	|	TRUE
	|GROUP BY
	|	ItemList.Period,
	|	VALUE(Enum.BatchDirection.Expense),
	|	ItemList.Company,
	|	ItemList.StoreSender,
	|	ItemList.ItemKey,
	|	ConsignorBatchesInfo.Batch";
EndFunction

Function R8013B_ConsignorBatchWiseBallance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ConsignorBatchesInfo.Batch,
		|	ConsignorBatchesInfo.ItemKey,
		|	ConsignorBatchesInfo.Store,
		|	ConsignorBatchesInfo.Quantity
		|INTO R8013B_ConsignorBatchWiseBallance
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ConsignorBatchesInfo AS ConsignorBatchesInfo
		|		ON ItemList.IsConsignorStocks
		|		AND ItemList.Key = ConsignorBatchesInfo.Key
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ConsignorBatchesInfo.Batch,
		|	ConsignorBatchesInfo.ItemKey,
		|	ItemList.StoreReceiver,
		|	ConsignorBatchesInfo.Quantity
		|
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ConsignorBatchesInfo AS ConsignorBatchesInfo
		|		ON ItemList.IsConsignorStocks
		|		AND ItemList.Key = ConsignorBatchesInfo.Key";
EndFunction
