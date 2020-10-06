Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.OrderProcurement");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Order, Store, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.OrderProcurement", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	Query = New Query();
	Query.TempTablesManager = 
	PostingServer.PrepareRecordsTables(GetLockFieldNames(), ItemList_InDocument, Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	ItemList.Order,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.OrderProcurement.Balance(, (Company, Order, Store, ItemKey, RowKey) IN
	|			(SELECT
	|				ItemList.Company,
	|				ItemList.Order,
	|				ItemList.Store,
	|				ItemLIst.ItemKey,
	|				ItemList.RowKey
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.Company = ItemList.Company
	|		AND RegisterBalance.Order = ItemList.Order
	|		AND RegisterBalance.Store = ItemList.Store
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.RowKey = ItemList.RowKey
	|WHERE
	|	RegisterBalance.QuantityBalance < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Unposting" , Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();	
	
	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns"  , "Order, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns"    , "Quantity");
		ErrorParameters.Insert("FilterColumns" , "Order, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation"     , "Order procurement");
		ErrorParameters.Insert("RecordType"    , RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction
