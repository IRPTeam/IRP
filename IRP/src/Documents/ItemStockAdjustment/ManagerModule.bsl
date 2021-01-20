#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExequteQuery(Ref, QueryArray, Parameters);
	
	Return Tables;	
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref, True);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters, True);
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
	PostingServer.GetLockDataSource(DataMapWithLockFields, Parameters, True);
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
	Return;
EndProcedure

#EndRegion

#Region PostingInfo

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R4051T_StockAdjustmentAsWriteOff());
	QueryArray.Add(R4052T_StockAdjustmentAsSurplus());
	QueryArray.Add(StockBalance());
	QueryArray.Add(StockReservation());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	ItemStockAdjustmentItemList.Ref,
		|	ItemStockAdjustmentItemList.Key,
		|	ItemStockAdjustmentItemList.ItemKey,
		|	ItemStockAdjustmentItemList.Unit,
		|	ItemStockAdjustmentItemList.Quantity,
		|	ItemStockAdjustmentItemList.QuantityInBaseUnit AS Quantity,
		|	ItemStockAdjustmentItemList.ItemKeyWriteOff,
		|	ItemStockAdjustmentItemList.Ref.Date AS Period,
		|	ItemStockAdjustmentItemList.Ref.Company AS Company,
		|	ItemStockAdjustmentItemList.Ref.Store AS Store
		|INTO ItemList
		|FROM
		|	Document.ItemStockAdjustment.ItemList AS ItemStockAdjustmentItemList
		|WHERE
		|	ItemStockAdjustmentItemList.Ref = &Ref";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.ItemKey AS ItemKey,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS QueryTable
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.ItemKeyWriteOff AS ItemKey,
		|	*
		|FROM
		|	ItemList AS QueryTable";

EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.ItemKey AS ItemKey,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS QueryTable
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.ItemKeyWriteOff AS ItemKey,
		|	*
		|FROM
		|	ItemList AS QueryTable";

EndFunction

Function R4050B_StockInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.ItemKey AS ItemKey,
		|	*
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS QueryTable
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.ItemKeyWriteOff AS ItemKey,
		|	*
		|FROM
		|	ItemList AS QueryTable";

EndFunction

Function R4051T_StockAdjustmentAsWriteOff()
	Return
		"SELECT 
		|	*
		|INTO R4051T_StockAdjustmentAsWriteOff
		|FROM
		|	ItemList AS QueryTable
		|WHERE True";

EndFunction

Function R4052T_StockAdjustmentAsSurplus()
	Return
		"SELECT 
		|	QueryTable.ItemKeyWriteOff AS ItemKey,
		|	*
		|INTO R4052T_StockAdjustmentAsSurplus
		|FROM
		|	ItemList AS QueryTable
		|WHERE True";

EndFunction

Function StockBalance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.ItemKey AS ItemKey,
		|	*
		|INTO StockBalance
		|FROM
		|	ItemList AS QueryTable
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.ItemKeyWriteOff AS ItemKey,
		|	*
		|FROM
		|	ItemList AS QueryTable";

EndFunction

Function StockReservation()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.ItemKey AS ItemKey,
		|	*
		|INTO StockReservation
		|FROM
		|	ItemList AS QueryTable
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.ItemKeyWriteOff AS ItemKey,
		|	*
		|FROM
		|	ItemList AS QueryTable";

EndFunction

#EndRegion