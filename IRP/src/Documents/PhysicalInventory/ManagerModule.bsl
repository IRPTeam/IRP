#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
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
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod",
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;
	
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "QuantityColumnName", "Difference");
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);

		Filter = New Structure("RecordType", AccumulationRecordType.Expense);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PhysicalInventory.ItemList", AddInfo);
		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PhysicalInventory.ItemList", AddInfo);
	Else
		// is unposting
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PhysicalInventory.ItemList", AddInfo);
	EndIf;	
EndProcedure

#EndRegion

#Region PostingService

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
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4052T_StockAdjustmentAsSurplus());
	QueryArray.Add(R4051T_StockAdjustmentAsWriteOff());
	QueryArray.Add(T3010S_RowIDInfo());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	ItemList.Ref.Date AS Period,
		   |	ItemList.Ref.Store AS Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	ItemList.Ref AS Basis,
		   |	CASE
		   |		WHEN ItemList.Difference > 0
		   |			THEN ItemList.Difference
		   |		ELSE 0
		   |	END AS SurplusQuantity,
		   |	CASE
		   |		WHEN ItemList.Difference < 0
		   |			THEN -ItemList.Difference
		   |		ELSE 0
		   |	END AS WriteOffQuantity,
		   |	&StatusInfoPosting AS StatusInfoPosting
		   |INTO ItemList
		   |FROM
		   |	Document.PhysicalInventory.ItemList AS ItemList
		   |WHERE
		   |	ItemList.Ref = &Ref
		   |	AND ItemList.Difference <> 0
		   |	AND &StatusInfoPosting";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.SurplusQuantity AS Quantity,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SurplusQuantity <> 0
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.WriteOffQuantity AS Quantity,
		   |	*
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.WriteOffQuantity <> 0";
EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.SurplusQuantity AS Quantity,
		   |	*
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SurplusQuantity <> 0 
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.WriteOffQuantity AS Quantity,
		   |	*
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.WriteOffQuantity <> 0";
EndFunction

Function R4052T_StockAdjustmentAsSurplus()
	Return "SELECT
		   |	ItemList.SurplusQuantity AS Quantity,
		   |	*
		   |INTO R4052T_StockAdjustmentAsSurplus
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.SurplusQuantity <> 0";
EndFunction

Function R4051T_StockAdjustmentAsWriteOff()
	Return "SELECT
		   |	ItemList.WriteOffQuantity AS Quantity,
		   |	*
		   |INTO R4051T_StockAdjustmentAsWriteOff
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.WriteOffQuantity <> 0";
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
		|	Document.PhysicalInventory.ItemList AS ItemList
		|		INNER JOIN Document.PhysicalInventory.RowIDInfo AS RowIDInfo
		|		ON RowIDInfo.Ref = &Ref
		|		AND ItemList.Ref = &Ref
		|		AND RowIDInfo.Key = ItemList.Key
		|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

#EndRegion

#Region Public

// Get item list with filling phys count.
// 
// Parameters:
//  Ref - DocumentRef.PhysicalInventory - Ref
// 
// Returns:
//  ValueTable - Get item list with filling phys count:
//  * Key - String
//  * Item - CatalogRef.Items
//  * ItemKey - CatalogRef.ItemKeys
//  * SerialLotNumber - CatalogRef.SerialLotNumbers
//  * Unit - CatalogRef.Units
//  * ExpCount - Number
//  * PhysCount - Number
//  * Difference - Number
Function GetItemListWithFillingPhysCount(Ref) Export
	Query = New Query();
	Query.Text = GetQueryTextFillPhysCount_ByItemList();

	Query.SetParameter("Ref", Ref);

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

// Get item list with filling exp count.
// 
// Parameters:
//  Ref - DocumentRef.PhysicalInventory - Ref
//  Store - CatalogRef.Stores - Store
//  ItemList - Undefined - Item list
// 
// Returns:
//  ValueTable - Get item list with filling exp count
Function GetItemListWithFillingExpCount(Ref, Store, ItemList = Undefined) Export
	Query = New Query();

	If ItemList = Undefined Then
		Query.Text = GetQueryTextFillExpCount();
	Else
		Query.Text = GetQueryTextFillExpCount_ByItemList();

		AccReg = Metadata.AccumulationRegisters.R4010B_ActualStocks;

		ItemListTyped = New ValueTable();
		ItemListTyped.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
		ItemListTyped.Columns.Add("LineNumber", New TypeDescription("Number"));
		ItemListTyped.Columns.Add("Store", AccReg.Dimensions.Store.Type);
		ItemListTyped.Columns.Add("ItemKey", AccReg.Dimensions.ItemKey.Type);
		ItemListTyped.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"));
		ItemListTyped.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
		ItemListTyped.Columns.Add("PhysCount", New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
		For Each Row In ItemList Do
			FillPropertyValues(ItemListTyped.Add(), Row);
		EndDo;

		Query.SetParameter("ItemList", ItemListTyped);
	EndIf;

	If ValueIsFilled(Ref) Then
		Query.SetParameter("Period", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		Query.SetParameter("Period", Undefined);
	EndIf;

	Query.SetParameter("Store", Store);
	Query.SetParameter("useSerialLotNumber", Ref.UseSerialLot);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	If QueryTable.Columns.Find("Key") = Undefined Then
		QueryTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	EndIf;

	If QueryTable.Columns.Find("LineNumber") <> Undefined Then
		QueryTable.Columns.Delete("LineNumber");
	EndIf;

	For Each Row In QueryTable Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
	Return QueryTable;
EndFunction

#EndRegion

#Region Service

Function GetQueryTextFillPhysCount_ByItemList()
	Return "SELECT
	|	PhysicalInventoryItemList.Key AS Key,
	|	PhysicalInventoryItemList.ItemKey AS ItemKey,
	|	PhysicalInventoryItemList.SerialLotNumber AS SerialLotNumber,
	|	PhysicalInventoryItemList.Unit AS Unit,
	|	SUM(PhysicalInventoryItemList.ExpCount) AS ExpCount
	|INTO ExpectedItems
	|FROM
	|	Document.PhysicalInventory.ItemList AS PhysicalInventoryItemList
	|WHERE
	|	PhysicalInventoryItemList.Ref = &Ref
	|
	|GROUP BY
	|	PhysicalInventoryItemList.Key,
	|	PhysicalInventoryItemList.ItemKey,
	|	PhysicalInventoryItemList.SerialLotNumber,
	|	PhysicalInventoryItemList.Unit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ExpectedItems.Key AS Key,
	|	PhysicalCountByLocationItemList.ItemKey AS ItemKey,
	|	PhysicalCountByLocationItemList.SerialLotNumber AS SerialLotNumber,
	|	PhysicalCountByLocationItemList.Unit AS Unit,
	|	SUM(PhysicalCountByLocationItemList.PhysCount) AS PhysCount
	|INTO ItemsAtLocations
	|FROM
	|	Document.PhysicalCountByLocation.ItemList AS PhysicalCountByLocationItemList
	|		LEFT JOIN ExpectedItems AS ExpectedItems
	|		ON (ExpectedItems.ItemKey = PhysicalCountByLocationItemList.ItemKey)
	|			AND (ExpectedItems.SerialLotNumber = PhysicalCountByLocationItemList.SerialLotNumber)
	|			AND (ExpectedItems.Unit = PhysicalCountByLocationItemList.Unit)
	|WHERE
	|	PhysicalCountByLocationItemList.Ref.PhysicalInventory = &Ref
	|	AND NOT PhysicalCountByLocationItemList.Ref.DeletionMark
	|	AND PhysicalCountByLocationItemList.Ref.Status.Posting
	|
	|GROUP BY
	|	PhysicalCountByLocationItemList.ItemKey,
	|	PhysicalCountByLocationItemList.SerialLotNumber,
	|	PhysicalCountByLocationItemList.Unit,
	|	ExpectedItems.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ExpectedItems.Key AS Key,
	|	ExpectedItems.ItemKey AS ItemKey,
	|	ExpectedItems.SerialLotNumber AS SerialLotNumber,
	|	ExpectedItems.Unit AS Unit,
	|	ExpectedItems.ExpCount AS ExpCount,
	|	0 AS PhysCount
	|INTO TotalItems
	|FROM
	|	ExpectedItems AS ExpectedItems
	|
	|UNION ALL
	|
	|SELECT
	|	ItemsAtLocations.Key,
	|	ItemsAtLocations.ItemKey,
	|	ItemsAtLocations.SerialLotNumber,
	|	ItemsAtLocations.Unit,
	|	0,
	|	ItemsAtLocations.PhysCount
	|FROM
	|	ItemsAtLocations AS ItemsAtLocations
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TotalItems.Key AS Key,
	|	TotalItems.ItemKey.Item AS Item,
	|	TotalItems.ItemKey AS ItemKey,
	|	TotalItems.SerialLotNumber AS SerialLotNumber,
	|	TotalItems.Unit AS Unit,
	|	SUM(TotalItems.ExpCount) AS ExpCount,
	|	SUM(TotalItems.PhysCount) AS PhysCount,
	|	SUM(TotalItems.ExpCount - TotalItems.PhysCount) AS Difference
	|FROM
	|	TotalItems AS TotalItems
	|
	|GROUP BY
	|	TotalItems.Key,
	|	TotalItems.ItemKey.Item,
	|	TotalItems.ItemKey,
	|	TotalItems.SerialLotNumber,
	|	TotalItems.Unit
	|";
EndFunction

Function GetQueryTextFillExpCount()
	Return "SELECT
	|	ActualStocks.Store,
	|	ActualStocks.ItemKey.Item AS Item,
	|	ActualStocks.ItemKey,
	|	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber,
	|	CASE
	|		WHEN ActualStocks.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN ActualStocks.ItemKey.Unit
	|		ELSE ActualStocks.ItemKey.Item.Unit
	|	END AS Unit,
	|	ActualStocks.QuantityBalance AS ExpCount,
	|	0 AS PhysCount
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks.Balance(&Period, Store = &Store
	|	AND CASE
	|		WHEN &useSerialLotNumber
	|			THEN ItemKey.Item.ItemType.UseSerialLotNumber
	|		ELSE TRUE
	|	END) AS ActualStocks
	|
	|UNION ALL
	|
	|SELECT
	|	SerialLotNumberBalance.Store,
	|	SerialLotNumberBalance.ItemKey.Item,
	|	SerialLotNumberBalance.ItemKey,
	|	SerialLotNumberBalance.SerialLotNumber,
	|	CASE
	|		WHEN SerialLotNumberBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN SerialLotNumberBalance.ItemKey.Unit
	|		ELSE SerialLotNumberBalance.ItemKey.Item.Unit
	|	END,
	|	SerialLotNumberBalance.QuantityBalance,
	|	0
	|FROM
	|	AccumulationRegister.R4014B_SerialLotNumber.Balance(&Period, Store = &Store
	|	AND &useSerialLotNumber) AS SerialLotNumberBalance";
EndFunction

Function GetQueryTextFillExpCount_ByItemList()
	Return "SELECT
		   |	tmp.Key AS Key,
		   |	tmp.LineNumber AS LineNumber,
		   |	tmp.Store AS Store,
		   |	tmp.ItemKey AS ItemKey,
		   |	tmp.Unit AS Unit,
		   |	tmp.SerialLotNumber AS SerialLotNumber,
		   |	tmp.PhysCount AS PhysCount
		   |INTO ItemList
		   |FROM
		   |	&ItemList AS tmp
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ActualStocks.Store,
		   |	ActualStocks.ItemKey.Item AS Item,
		   |	ActualStocks.ItemKey,
		   |	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber,
		   |	CASE
		   |		WHEN ActualStocks.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		   |			THEN ActualStocks.ItemKey.Unit
		   |		ELSE ActualStocks.ItemKey.Item.Unit
		   |	END AS Unit,
		   |	ActualStocks.QuantityBalance AS ExpCount,
		   |	0 AS PhysCount
		   |INTO ActualStocks
		   |FROM
		   |	AccumulationRegister.R4010B_ActualStocks.Balance(&Period, Store = &Store
		   |	AND CASE
		   |		WHEN &useSerialLotNumber
		   |			THEN ItemKey.Item.ItemType.UseSerialLotNumber
		   |		ELSE TRUE
		   |	END) AS ActualStocks
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	SerialLotNumberBalance.Store,
		   |	SerialLotNumberBalance.ItemKey.Item,
		   |	SerialLotNumberBalance.ItemKey,
		   |	SerialLotNumberBalance.SerialLotNumber,
		   |	CASE
		   |		WHEN SerialLotNumberBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		   |			THEN SerialLotNumberBalance.ItemKey.Unit
		   |		ELSE SerialLotNumberBalance.ItemKey.Item.Unit
		   |	END,
		   |	SerialLotNumberBalance.QuantityBalance,
		   |	0
		   |FROM
		   |	AccumulationRegister.R4014B_SerialLotNumber.Balance(&Period, Store = &Store
		   |	AND &useSerialLotNumber) AS SerialLotNumberBalance
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	ItemList.Key,
		   |	ISNULL(ItemList.Store, ActualStocks.Store) AS Store,
		   |	ISNULL(ItemList.ItemKey, ActualStocks.ItemKey) AS ItemKey,
		   |	ISNULL(ItemList.ItemKey.Item, ActualStocks.ItemKey.Item) AS Item,
		   |	ISNULL(ItemList.SerialLotNumber, ActualStocks.SerialLotNumber) AS SerialLotNumber,
		   |	ISNULL(ItemList.Unit, ActualStocks.Unit) AS Unit,
		   |	ISNULL(ItemList.PhysCount, 0) AS PhysCount,
		   |	ISNULL(ActualStocks.ExpCount, 0) AS ExpCount,
		   |	ISNULL(ItemList.LineNumber, -1) AS LineNumber
		   |FROM
		   |	ItemList AS ItemList
		   |		FULL JOIN ActualStocks AS ActualStocks
		   |		ON ItemList.Store = ActualStocks.Store
		   |		AND ItemList.ItemKey = ActualStocks.ItemKey
		   |		AND ItemList.SerialLotNumber = ActualStocks.SerialLotNumber
		   |ORDER BY
		   |	LineNumber";
EndFunction

#EndRegion
