
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.ShipmentOrders");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Order, ShipmentConfirmation, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.ShipmentOrders", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	
// Doc.ShipmentConfirmation - receipt

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
	|		INNER JOIN AccumulationRegister.ShipmentOrders.Balance(, (Order, ShipmentConfirmation, ItemKey, RowKey) IN
	|			(SELECT
	|				ItemList.Order,
	|				ItemList.ShipmentConfirmation,
	|				ItemList.ItemKey,
	|				ItemList.RowKey
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.Order = ItemList.Order
	|		AND RegisterBalance.ShipmentConfirmation = ItemList.ShipmentConfirmation
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
		ErrorParameters.Insert("Operation"     , "Shipping order");
		ErrorParameters.Insert("RecordType"    , RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction