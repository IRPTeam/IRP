#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("StockAdjustmentAsWriteOff" , PostingServer.CreateTable(AccReg.StockAdjustmentAsWriteOff));
	Tables.Insert("StockAdjustmentAsSurplus"  , PostingServer.CreateTable(AccReg.StockAdjustmentAsSurplus));
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
		Return Tables;
	EndIf;
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextPhysicalInventoryItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);

	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.StockAdjustmentAsWriteOff = QueryResults[1].Unload();
	Tables.StockAdjustmentAsSurplus  = QueryResults[2].Unload();
	
#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction
	
Function GetQueryTextPhysicalInventoryItemList()
	Return
		"SELECT
		|	PhysicalInventoryItemList.Ref AS BasisDocument,
		|	PhysicalInventoryItemList.Ref.Store AS Store,
		|	PhysicalInventoryItemList.ItemKey AS ItemKey,
		|	PhysicalInventoryItemList.Difference AS Quantity,
		|	PhysicalInventoryItemList.Ref.Date AS Period,
		|	0 AS BasisQuantity,
		|	PhysicalInventoryItemList.Unit,
		|	PhysicalInventoryItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PhysicalInventoryItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	PhysicalInventoryItemList.ItemKey.Item AS Item
		|FROM
		|	Document.PhysicalInventory.ItemList AS PhysicalInventoryItemList
		|WHERE
		|	PhysicalInventoryItemList.Ref = &Ref
		|	AND PhysicalInventoryItemList.Difference <> 0";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	CASE
		|		WHEN QueryTable.BasisQuantity > 0
		|			THEN QueryTable.BasisQuantity
		|		ELSE 0
		|	END AS SurplusQuantity,
		|	-CASE
		|		WHEN QueryTable.BasisQuantity < 0
		|			THEN QueryTable.BasisQuantity
		|		ELSE 0
		|	END AS WriteOffQuantity,
		|	QueryTable.Period AS Period
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.BasisDocument AS BasisDocument,
		|	SUM(tmp.WriteOffQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.BasisDocument,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.WriteOffQuantity) <> 0
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.BasisDocument AS BasisDocument,
		|	SUM(tmp.SurplusQuantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.BasisDocument,
		|	tmp.Period
		|HAVING
		|	SUM(tmp.SurplusQuantity) <> 0";
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
		
	// StockAdjustmentAsWriteOff
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockAdjustmentAsWriteOff,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockAdjustmentAsWriteOff));
	
	// StockAdjustmentAsSurplus
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockAdjustmentAsSurplus,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockAdjustmentAsSurplus));

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
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod", New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		Parameters.Insert("RecordType", AccumulationRecordType.Receipt);
	EndIf;
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PhysicalInventory.ItemList", AddInfo);
EndProcedure

#EndRegion

Function GetItemListWithFillingPhysCount(Ref) Export
	Query = New Query();
	Query.Text = GetQueryTextFillPhysCount_ByItemList();
	
	Query.SetParameter("Ref", Ref);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetQueryTextFillPhysCount_ByItemList()
	Return
	"SELECT
	|	NestedSelect.ItemKey.Item AS Item,
	|	NestedSelect.ItemKey AS ItemKey,
	|	NestedSelect.Unit AS Unit,
	|	SUM(NestedSelect.ExpCount) AS ExpCount,
	|	SUM(NestedSelect.PhysCount) AS PhysCount,
	|	SUM(NestedSelect.PhysCount) - SUM(NestedSelect.ExpCount) AS Difference
	|FROM
	|	(SELECT
	|		PhysicalInventoryItemList.ItemKey AS ItemKey,
	|		PhysicalInventoryItemList.Unit AS Unit,
	|		SUM(PhysicalInventoryItemList.ExpCount) AS ExpCount,
	|		0 AS PhysCount
	|	FROM
	|		Document.PhysicalInventory.ItemList AS PhysicalInventoryItemList
	|	WHERE
	|		PhysicalInventoryItemList.Ref = &Ref
	|	
	|	GROUP BY
	|		PhysicalInventoryItemList.ItemKey,
	|		PhysicalInventoryItemList.Unit
	|	
	|	UNION ALL
	|	
	|	SELECT
	|		PhysicalCountByLocationItemList.ItemKey,
	|		PhysicalCountByLocationItemList.Unit,
	|		0,
	|		SUM(PhysicalCountByLocationItemList.PhysCount)
	|	FROM
	|		Document.PhysicalCountByLocation.ItemList AS PhysicalCountByLocationItemList
	|	WHERE
	|		PhysicalCountByLocationItemList.Ref.PhysicalInventory = &Ref
	|		AND NOT PhysicalCountByLocationItemList.Ref.DeletionMark
	|	
	|	GROUP BY
	|		PhysicalCountByLocationItemList.ItemKey,
	|		PhysicalCountByLocationItemList.Unit) AS NestedSelect
	|
	|GROUP BY
	|	NestedSelect.ItemKey.Item,
	|	NestedSelect.ItemKey,
	|	NestedSelect.Unit";
EndFunction

Function GetItemListWithFillingExpCount(Ref, Store, ItemList = Undefined) Export
	Query = New Query();
	 
	If ItemList = Undefined Then
		Query.Text = GetQueryTextFillExpCount();
	Else
		Query.Text = GetQueryTextFillExpCount_ByItemList();
		
		AccReg = Metadata.AccumulationRegisters.R4010B_ActualStocks;
		
		ItemListTyped = New ValueTable();
		ItemListTyped.Columns.Add("Key"               , New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
		ItemListTyped.Columns.Add("LineNumber"        , New TypeDescription("Number"));
		ItemListTyped.Columns.Add("Store"             , AccReg.Dimensions.Store.Type);
		ItemListTyped.Columns.Add("ItemKey"           , AccReg.Dimensions.ItemKey.Type);
		ItemListTyped.Columns.Add("Unit"              , New TypeDescription("CatalogRef.Units"));
		ItemListTyped.Columns.Add("PhysCount"         , New TypeDescription(Metadata.DefinedTypes.typeQuantity.Type));
		ItemListTyped.Columns.Add("ResponsiblePerson" , New TypeDescription("CatalogRef.Partners"));
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

Function GetQueryTextFillExpCount()
	Return 
	"SELECT
	|	R4010B_ActualStocks.Store,
	|	R4010B_ActualStocks.ItemKey.Item AS Item,
	|	R4010B_ActualStocks.ItemKey,
	|	CASE
	|		WHEN R4010B_ActualStocks.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN R4010B_ActualStocks.ItemKey.Unit
	|		ELSE R4010B_ActualStocks.ItemKey.Item.Unit
	|	END AS Unit,
	|	R4010B_ActualStocks.QuantityBalance AS ExpCount,
	|	0 AS PhysCount
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks.Balance(&Period, Store = &Store) AS R4010B_ActualStocks";
EndFunction

Function GetQueryTextFillExpCount_ByItemList()
	Return
	"SELECT
	|	tmp.Key AS Key,
	|	tmp.LineNumber AS LineNumber,
	|	tmp.Store AS Store,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.Unit AS Unit,
	|	tmp.PhysCount AS PhysCount,
	|	tmp.ResponsiblePerson AS ResponsiblePerson
	|INTO ItemList
	|FROM
	|	&ItemList AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R4010B_ActualStocks.Store,
	|	R4010B_ActualStocks.ItemKey,
	|	CASE
	|		WHEN R4010B_ActualStocks.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN R4010B_ActualStocks.ItemKey.Unit
	|		ELSE R4010B_ActualStocks.ItemKey.Item.Unit
	|	END AS Unit,
	|	R4010B_ActualStocks.QuantityBalance AS ExpCount
	|INTO ActualStocks
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks.Balance(&Period, Store IN
	|		(SELECT
	|			ItemList.Store
	|		FROM
	|			ItemList AS ItemList)) AS R4010B_ActualStocks
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	ISNULL(ItemList.Store, ActualStocks.Store) AS Store,
	|	ISNULL(ItemList.ItemKey, ActualStocks.ItemKey) AS ItemKey,
	|	ISNULL(ItemList.ItemKey.Item, ActualStocks.ItemKey.Item) AS Item,
	|	ISNULL(ItemList.Unit, ActualStocks.Unit) AS Unit,
	|	ISNULL(ItemList.PhysCount, 0) AS PhysCount,
	|	ISNULL(ActualStocks.ExpCount, 0) AS ExpCount,
	|	ISNULL(ItemList.LineNumber, -1) AS LineNumber,
	|	ISNULL(ItemList.ResponsiblePerson, VALUE(Catalog.Partners.EmptyRef)) AS ResponsiblePerson
	|FROM
	|	ItemList AS ItemList
	|		FULL JOIN ActualStocks AS ActualStocks
	|		ON ItemList.Store = ActualStocks.Store
	|		AND ItemList.ItemKey = ActualStocks.ItemKey
	|ORDER BY
	|	LineNumber";
EndFunction

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
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
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
	Return
		"SELECT
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
	Return
		"SELECT
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

#EndRegion
