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
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Key AS Key,
	|	ItemList.InventoryOrigin AS InventoryOrigin,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Ref.StoreSender AS Store,
	|	ItemList.QuantityInBaseUnit AS Quantity
	|INTO tmpItemList
	|FROM
	|	Document.InventoryTransfer.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SerialLotNumbers.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|INTO tmpSerialLotNumbers
	|FROM
	|	Document.InventoryTransfer.SerialLotNumbers AS SerialLotNumbers
	|WHERE
	|	SerialLotNumbers.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SourceOfOrigins.Key,
	|	SourceOfOrigins.SerialLotNumber,
	|	SourceOfOrigins.SourceOfOrigin,
	|	SourceOfOrigins.Quantity
	|INTO tmpSourceOfOrigins
	|FROM
	|	Document.InventoryTransfer.SourceOfOrigins AS SourceOfOrigins
	|WHERE
	|	SourceOfOrigins.Ref = &Ref
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList.Key,
	|	tmpItemList.InventoryOrigin,
	|	tmpItemList.Company,
	|	tmpItemList.ItemKey,
	|	tmpItemList.Store,
	|	CASE
	|		WHEN tmpSerialLotNumbers.SerialLotNumber.Ref IS NULL
	|			THEN tmpItemList.Quantity
	|		ELSE tmpSerialLotNumbers.Quantity
	|	END AS Quantity,
	|	ISNULL(tmpSerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
	|INTO tmpItemList_1
	|FROM
	|	tmpItemList AS tmpItemList
	|		LEFT JOIN tmpSerialLotNumbers AS tmpSerialLotNumbers
	|		ON tmpItemList.Key = tmpSerialLotNumbers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpItemList_1.Key,
	|	tmpItemList_1.InventoryOrigin,
	|	tmpItemList_1.Company,
	|	tmpItemList_1.ItemKey,
	|	tmpItemList_1.Store,
	|	tmpItemList_1.SerialLotNumber,
	|	CASE
	|		WHEN ISNULL(tmpSourceOfOrigins.Quantity, 0) <> 0
	|			THEN ISNULL(tmpSourceOfOrigins.Quantity, 0)
	|		ELSE tmpItemList_1.Quantity
	|	END AS Quantity,
	|	ISNULL(tmpSourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin
	|FROM
	|	tmpItemList_1 AS tmpItemList_1
	|		LEFT JOIN tmpSourceOfOrigins AS tmpSourceOfOrigins
	|		ON tmpItemList_1.Key = tmpSourceOfOrigins.Key
	|		AND tmpItemList_1.SerialLotNumber = tmpSourceOfOrigins.SerialLotNumber";
	
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	ItemListTable = QueryResult.Unload();
	ConsignorBatches = CommissionTradeServer.GetRegistrateConsignorBatches(Parameters.Object, ItemListTable);
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
	Query.SetParameter("T1", ConsignorBatches);
	Query.Execute();
	
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
	QueryArray.Add(SourceOfOrigins());
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
	QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	QueryArray.Add(R9010B_SourceOfOriginStock());
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

Function SourceOfOrigins()
	Return
		"SELECT
		|	SourceOfOrigins.Key AS Key,
		|	CASE
		|		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
		|			THEN SourceOfOrigins.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	CASE
		|		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
		|			THEN SourceOfOrigins.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END AS SourceOfOrigin,
		|	SourceOfOrigins.SourceOfOrigin AS SourceOfOriginStock,
		|	SourceOfOrigins.SerialLotNumber AS SerialLotNumberStock,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO SourceOfOrigins
		|FROM
		|	Document.InventoryTransfer.SourceOfOrigins AS SourceOfOrigins
		|WHERE
		|	SourceOfOrigins.Ref = &Ref
		|GROUP BY
		|	SourceOfOrigins.Key,
		|	CASE
		|		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
		|			THEN SourceOfOrigins.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	CASE
		|		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
		|			THEN SourceOfOrigins.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END,
		|	SourceOfOrigins.SourceOfOrigin,
		|	SourceOfOrigins.SerialLotNumber";
EndFunction

Function R9010B_SourceOfOriginStock()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreSender AS Store,
		|	ItemList.ItemKey,
		|	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
		|	SourceOfOrigins.SerialLotNumber,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO R9010B_SourceOfOriginStock
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON ItemList.Key = SourceOfOrigins.Key
		|		AND NOT SourceOfOrigins.SourceOfOriginStock.Ref IS NULL
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreSender,
		|	ItemList.ItemKey,
		|	SourceOfOrigins.SourceOfOriginStock,
		|	SourceOfOrigins.SerialLotNumber
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
		|	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
		|	SourceOfOrigins.SerialLotNumber,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON ItemList.Key = SourceOfOrigins.Key
		|		AND NOT SourceOfOrigins.SourceOfOriginStock.Ref IS NULL
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.StoreReceiver,
		|	ItemList.ItemKey,
		|	SourceOfOrigins.SourceOfOriginStock,
		|	SourceOfOrigins.SerialLotNumber";
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
		|	ItemList.Key,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.StoreSender AS StoreSender,
		|	ItemList.StoreReceiver AS StoreReceiver,
		|	ItemList.ItemKey,
		|	ConsignorBatches.Batch AS BatchConsignor,
		|	ISNULL(ConsignorBatches.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
		|	CASE
		|		WHEN ConsignorBatches.Key IS NULL
		|			THEN False
		|		ELSE true
		|	END AS IsConsignorBatches,
		|
		|	ISNULL(ConsignorBatches.Quantity,0) AS ConsignorQuantity,
		|
		|	CASE
		|		WHEN ConsignorBatches.Quantity IS NULL
		|			THEN ItemList.Quantity
		|		ELSE ConsignorBatches.Quantity
		|	END AS Quantity
		|INTO BatchKeysInfo
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN ConsignorBatches AS ConsignorBatches
		|		ON ItemList.Key = ConsignorBatches.Key
		|WHERE
		|	TRUE
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.StoreSender,
		|	BatchKeysInfo.StoreReceiver,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.BatchConsignor,
		//|	SUM(CASE
		//|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		//|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		//|		ELSE BatchKeysInfo.Quantity
		//|	END) AS Quantity,
		|
		|CASE WHEN BatchKeysInfo.IsConsignorBatches THEN
	 	| BatchKeysInfo.ConsignorQuantity
		|ELSE
		|CASE
		|	WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|		THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|	ELSE BatchKeysInfo.Quantity
		|END
		|END AS Quantity,   
		|
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO BatchKeysInfo_1
		|FROM
		|	BatchKeysInfo AS BatchKeysInfo
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo.Key = SourceOfOrigins.Key
		|		AND CASE
		|			WHEN BatchKeysInfo.IsConsignorBatches
		|				THEN BatchKeysInfo.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
		|			ELSE TRUE
		|		END
//		|GROUP BY
//		|	BatchKeysInfo.Period,
//		|	BatchKeysInfo.Company,
//		|	BatchKeysInfo.StoreSender,
//		|	BatchKeysInfo.StoreReceiver,
//		|	BatchKeysInfo.ItemKey,
//		|	BatchKeysInfo.BatchConsignor,
//		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
//		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.Period,
		|	VALUE(Enum.BatchDirection.Expense) AS Direction,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.StoreSender AS Store,
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.BatchConsignor,
		|	SUM(BatchKeysInfo_1.Quantity) AS Quantity,
		|	BatchKeysInfo_1.SourceOfOrigin,
		|	BatchKeysInfo_1.SerialLotNumber
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|WHERE
		|	TRUE
		|
		|GROUP BY
		|	BatchKeysInfo_1.Period,
		|	VALUE(Enum.BatchDirection.Expense),
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.StoreSender,
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.BatchConsignor,
		|	BatchKeysInfo_1.SourceOfOrigin,
		|	BatchKeysInfo_1.SerialLotNumber
		
		|
		|UNION ALL
		|
		|SELECT
		|	BatchKeysInfo_1.Period,
		|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.StoreReceiver AS Store,
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.BatchConsignor,
		|	SUM(BatchKeysInfo_1.Quantity) AS Quantity,
		|	BatchKeysInfo_1.SourceOfOrigin,
		|	BatchKeysInfo_1.SerialLotNumber
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|WHERE
		|	TRUE
		|GROUP BY
		|	BatchKeysInfo_1.Period,
		|	VALUE(Enum.BatchDirection.Receipt),
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.StoreReceiver,
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.BatchConsignor,
		|	BatchKeysInfo_1.SourceOfOrigin,
		|	BatchKeysInfo_1.SerialLotNumber";
		
EndFunction

Function R8013B_ConsignorBatchWiseBalance()
	Return
		"SELECT
		|	ItemList.Key,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ConsignorBatches.Batch,
		|	ConsignorBatches.ItemKey,
		|	ConsignorBatches.SerialLotNumber,
		|	ConsignorBatches.Store AS StoreSender,
		|	ItemList.StoreReceiver AS StoreReceiver,
		|	ConsignorBatches.Quantity
		|INTO ConsignorBatchWiseBalance
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ConsignorBatches AS ConsignorBatches
		|		ON ItemList.IsConsignorStocks
		|		AND ItemList.Key = ConsignorBatches.Key
		|;
		|//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ConsignorBatchWiseBalance.Period,
		|	ConsignorBatchWiseBalance.Company,
		|	ConsignorBatchWiseBalance.Batch,
		|	ConsignorBatchWiseBalance.ItemKey,
		|	ConsignorBatchWiseBalance.StoreSender,
		|	ConsignorBatchWiseBalance.StoreReceiver,
//		|	SUM(CASE
//		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
//		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
//		|		ELSE ConsignorBatchWiseBalance.Quantity
//		|	END) AS Quantity,
		|	
		|	SUM(ISNULL(ConsignorBatchWiseBalance.Quantity,0)) AS Quantity,
		|
		|	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
		|	SourceOfOrigins.SerialLotNumberStock AS SerialLotNumber
		|INTO ConsignorBatchWiseBalance_1
		|FROM
		|	ConsignorBatchWiseBalance AS ConsignorBatchWiseBalance
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON ConsignorBatchWiseBalance.Key = SourceOfOrigins.Key
		|		AND ConsignorBatchWiseBalance.SerialLotNumber = SourceOfOrigins.SerialLotNumberStock
		|GROUP BY
		|	ConsignorBatchWiseBalance.Period,
		|	ConsignorBatchWiseBalance.Company,
		|	ConsignorBatchWiseBalance.Batch,
		|	ConsignorBatchWiseBalance.ItemKey,
		|	ConsignorBatchWiseBalance.StoreSender,
		|	ConsignorBatchWiseBalance.StoreReceiver,
		|	SourceOfOrigins.SourceOfOriginStock,
		|	SourceOfOrigins.SerialLotNumberStock
		|;
		|
		|//////////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ConsignorBatchWiseBalance_1.Period,
		|	ConsignorBatchWiseBalance_1.Company,
		|	ConsignorBatchWiseBalance_1.Batch,
		|	ConsignorBatchWiseBalance_1.ItemKey,
		|	ConsignorBatchWiseBalance_1.StoreSender AS Store,
		|	ConsignorBatchWiseBalance_1.SourceOfOrigin,
		|	ConsignorBatchWiseBalance_1.SerialLotNumber,
		|	ConsignorBatchWiseBalance_1.Quantity
		|INTO R8013B_ConsignorBatchWiseBalance
		|FROM
		|	ConsignorBatchWiseBalance_1 AS ConsignorBatchWiseBalance_1
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ConsignorBatchWiseBalance_1.Period,
		|	ConsignorBatchWiseBalance_1.Company,
		|	ConsignorBatchWiseBalance_1.Batch,
		|	ConsignorBatchWiseBalance_1.ItemKey,
		|	ConsignorBatchWiseBalance_1.StoreReceiver AS Store,
		|	ConsignorBatchWiseBalance_1.SourceOfOrigin,
		|	ConsignorBatchWiseBalance_1.SerialLotNumber,
		|	ConsignorBatchWiseBalance_1.Quantity
		|FROM
		|	ConsignorBatchWiseBalance_1 AS ConsignorBatchWiseBalance_1";
EndFunction
