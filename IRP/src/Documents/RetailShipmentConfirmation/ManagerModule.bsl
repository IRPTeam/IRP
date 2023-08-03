#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.IsReposting = False;
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
	|	ItemList.Store AS Store,
	|	ItemList.QuantityInBaseUnit AS Quantity
	|INTO tmpItemList
	|FROM
	|	Document.RetailShipmentConfirmation.ItemList AS ItemList
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
	|	Document.RetailShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
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
	|	Document.RetailShipmentConfirmation.SourceOfOrigins AS SourceOfOrigins
	|WHERE
	|	SourceOfOrigins.Ref = &Ref
	|;
	|
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

	Query = New Query;
	Query.Text =
	"SELECT
	|	ConsignorBatches.Key,
	|	ConsignorBatches.ItemKey,
	|	ConsignorBatches.SerialLotNumber,
	|	ConsignorBatches.SourceOfOrigin,
	|	ConsignorBatches.Store,
	|	ConsignorBatches.Batch,
	|	ConsignorBatches.Quantity
	|FROM
	|	Document.RetailShipmentConfirmation.ConsignorBatches AS ConsignorBatches
	|WHERE
	|	ConsignorBatches.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	ConsignorBatches = QueryResult.Unload();

	ConsignorBatches = CommissionTradeServer.GetRegistrateConsignorBatches(Parameters.Object, ItemListTable, ConsignorBatches);

	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "SELECT * INTO ConsignorBatches FROM &T1 AS T1";
	Query.SetParameter("T1", ConsignorBatches);
	Query.Execute();
	
	Return Tables;
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
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.ShipmentConfirmation.ItemList");

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters),
		PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters),
		AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.ShipmentConfirmation.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region Posting_Info

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

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function ItemList()
	Return 
		"SELECT
		|	RowIDInfo.Ref AS Ref,
		|	RowIDInfo.Key AS Key,
		|	MAX(RowIDInfo.RowID) AS RowID
		|INTO TableRowIDInfo
		|FROM
		|	Document.RetailShipmentConfirmation.RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Ref = &Ref
		|GROUP BY
		|	RowIDInfo.Ref,
		|	RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Ref AS RetailShipmentConfirmation,
		|	ItemList.Quantity AS UnitQuantity,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Unit,
		|	ItemList.Ref.Date AS Period,
		|	TableRowIDInfo.RowID AS RowKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	NOT ItemList.SalesOrder.Ref IS NULL AS SalesOrderExists,
		|	Value(Document.RetailSalesReceipt.EmptyRef) AS RetailSalesReceipt,
		|	FALSE AS RetailSalesReceiptExists,
		|	ItemList.Ref.Branch AS Branch,
		|	ItemList.Key,
		|	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.OwnStocks) AS IsOwnStocks,
		|	ItemList.InventoryOrigin = VALUE(Enum.InventoryOriginTypes.ConsignorStocks) AS IsConsignorStocks
		|INTO ItemList
		|FROM
		|	Document.RetailShipmentConfirmation.ItemList AS ItemList
		|		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		|		ON ItemList.Key = TableRowIDInfo.Key
		|WHERE
		|	ItemList.Ref = &Ref";
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
		|	ItemList.Store AS Store
		|INTO SerialLotNumbers
		|FROM
		|	Document.RetailShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.RetailShipmentConfirmation.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";
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
		|	Document.RetailShipmentConfirmation.SourceOfOrigins AS SourceOfOrigins
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

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(R8013B_ConsignorBatchWiseBalance());
	Return QueryArray;
EndFunction

Function R2011B_SalesOrdersShipment()
	Return 
		"SELECT
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Company AS Company,
		|	ItemList.Branch AS Branch,
		|	ItemList.SalesOrder AS Order,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.RowKey AS RowKey,
		|	ItemList.Quantity AS Quantity
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesOrderExists";
EndFunction

Function R4010B_ActualStocks()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
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
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Store,
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
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.RetailSalesReceipt AS RetailSalesReceipt,
		|	ItemList.SalesOrderExists AS SalesOrderExists,
		|	ItemList.RetailSalesReceiptExists AS RetailSalesReceiptExists,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO ItemListGroup
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.RetailSalesReceipt,
		|	ItemList.SalesOrderExists,
		|	ItemList.RetailSalesReceiptExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	StockReservation.Store AS Store,
		|	StockReservation.Order AS Basis,
		|	StockReservation.ItemKey AS ItemKey,
		|	StockReservation.QuantityBalance AS Quantity
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.SalesOrder
		|		FROM
		|			ItemList AS ItemList)) AS StockReservation
		|WHERE
		|	StockReservation.QuantityBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	StockReservation.Store,
		|	StockReservation.Order,
		|	StockReservation.ItemKey,
		|	StockReservation.QuantityBalance
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.RetailSalesReceipt
		|		FROM
		|			ItemList AS ItemList)) AS StockReservation
		|WHERE
		|	StockReservation.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period AS Period,
		|	ItemListGroup.Store AS Store,
		|	ItemListGroup.ItemKey AS ItemKey,
		|	ItemListGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemListGroup AS ItemListGroup
		|		LEFT JOIN TmpStockReservation AS TmpStockReservation
		|		ON (ItemListGroup.Store = TmpStockReservation.Store)
		|		AND (ItemListGroup.ItemKey = TmpStockReservation.ItemKey)
		|		AND (TmpStockReservation.Basis = ItemListGroup.SalesOrder
		|		OR TmpStockReservation.Basis = ItemListGroup.RetailSalesReceipt)
		|WHERE
		|	ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP ItemListGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
EndFunction

Function R4012B_StockReservation()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.RetailSalesReceipt,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO ItemListGroup
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesOrderExists
		|	OR ItemList.RetailSalesReceiptExists
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.RetailSalesReceipt
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	*
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.SalesOrder
		|		FROM
		|			ItemListGroup AS ItemList))
		|
		|UNION ALL
		|
		|SELECT
		|	*
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.RetailSalesReceipt
		|		FROM
		|			ItemListGroup AS ItemList))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period AS Period,
		|	ItemList.SalesOrder AS Order,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Store AS Store,
		|	CASE
		|		WHEN StockReservation.QuantityBalance > ItemList.Quantity
		|			THEN ItemList.Quantity
		|		ELSE StockReservation.QuantityBalance
		|	END AS Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	ItemListGroup AS ItemList
		|		INNER JOIN TmpStockReservation AS StockReservation
		|		ON (ItemList.SalesOrder = StockReservation.Order
		|		OR ItemList.RetailSalesReceipt = StockReservation.Order)
		|		AND ItemList.ItemKey = StockReservation.ItemKey
		|		AND ItemList.Store = StockReservation.Store
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP ItemListGroup";
EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return 
		"SELECT
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	CASE
		|		WHEN ItemList.RetailSalesReceiptExists
		|			Then ItemList.RetailSalesReceipt
		|		ELSE ItemList.RetailShipmentConfirmation
		|	END AS Basis,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Quantity AS Quantity
		|INTO R4032B_GoodsInTransitOutgoing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R4014B_SerialLotNumber()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	SerialLotNumbers.Company,
		|	SerialLotNumbers.Branch,
		|	SerialLotNumbers.Store,
		|	SerialLotNumbers.ItemKey,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	FALSE";
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
		|	Document.RetailShipmentConfirmation.ItemList AS ItemList
		|		INNER JOIN Document.RetailShipmentConfirmation.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
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
		|	ConsignorBatches.Store AS Store,
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
		|	ConsignorBatchWiseBalance.Store,
		|	SUM(ISNULL(ConsignorBatchWiseBalance.Quantity, 0)) AS Quantity,
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
		|	ConsignorBatchWiseBalance.Store,
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
		|	ConsignorBatchWiseBalance_1.Store,
		|	ConsignorBatchWiseBalance_1.SourceOfOrigin,
		|	ConsignorBatchWiseBalance_1.SerialLotNumber,
		|	ConsignorBatchWiseBalance_1.Quantity
		|INTO R8013B_ConsignorBatchWiseBalance
		|FROM
		|	ConsignorBatchWiseBalance_1 AS ConsignorBatchWiseBalance_1";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	StoreList = Obj.ItemList.Unload(, "Store");
	StoreList.GroupBy("Store");
	AccessKeyMap.Insert("Store", StoreList.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion




