Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.OrderBalance");	
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, Order, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.OrderBalance", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export

// Doc.SalesOrder            - receipt
// Doc.SalesInvoice          - expense
// Doc.PurchaseOrder         - receipt, expense
// Doc.InternalSupplyRequest - receipt
// Doc.PurchaseInvoice       - expense

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
	|		INNER JOIN AccumulationRegister.OrderBalance.Balance(, (Order, ItemKey, Store, RowKey) IN
	|			(SELECT
	|				ItemList.Order,
	|				ItemList.ItemKey,
	|				ItemList.Store,
	|				ItemList.RowKey
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.Order = ItemList.Order
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.Store = ItemList.Store
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
		ErrorParameters.Insert("Operation"     , "Ordering");
		ErrorParameters.Insert("RecordType"    , RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction	
