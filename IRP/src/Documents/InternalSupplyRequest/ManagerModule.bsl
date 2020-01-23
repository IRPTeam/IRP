#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	
	Tables.Insert("OrderBalance", New ValueTable());
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	InternalSupplyRequestItemList.Ref.Company AS Company,
		|	InternalSupplyRequestItemList.Ref.Store AS Store,
		|	InternalSupplyRequestItemList.ItemKey AS ItemKey,
		|	InternalSupplyRequestItemList.Ref AS InternalSupplyRequest,
		|	SUM(InternalSupplyRequestItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	InternalSupplyRequestItemList.Unit,
		|	InternalSupplyRequestItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InternalSupplyRequestItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InternalSupplyRequestItemList.ItemKey.Item AS Item,
		|	InternalSupplyRequestItemList.Ref.Date AS Period,
		|	InternalSupplyRequestItemList.Key AS RowKey
		|FROM
		|	Document.InternalSupplyRequest.ItemList AS InternalSupplyRequestItemList
		|WHERE
		|	InternalSupplyRequestItemList.Ref = &Ref
		|GROUP BY
		|	InternalSupplyRequestItemList.Ref.Company,
		|	InternalSupplyRequestItemList.Ref.Store,
		|	InternalSupplyRequestItemList.ItemKey,
		|	InternalSupplyRequestItemList.Ref,
		|	InternalSupplyRequestItemList.Unit,
		|	InternalSupplyRequestItemList.ItemKey.Item.Unit,
		|	InternalSupplyRequestItemList.ItemKey.Unit,
		|	InternalSupplyRequestItemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	InternalSupplyRequestItemList.Ref.Date,
		|	InternalSupplyRequestItemList.Key";
	
	Query.SetParameter("Ref", Ref);
	
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.InternalSupplyRequest AS Order,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|   QueryTable.RowKey
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|   tmp.RowKey";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance = QueryResults[1].Unload();
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	
	DataMapWithLockFields.Insert("AccumulationRegister.OrderBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.OrderBalance));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
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

