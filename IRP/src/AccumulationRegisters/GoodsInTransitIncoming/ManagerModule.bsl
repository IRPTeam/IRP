Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.GoodsInTransitIncoming");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, ReceiptBasis, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.GoodsInTransitIncoming", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	
// Doc.GoodsReceipt - expense
	
	Query = New Query();
	Query.TempTablesManager = 
	PostingServer.PrepareRecordsTables(GetLockFieldNames(), ItemList_InDocument, Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	ItemList.ReceiptBasis,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.GoodsInTransitIncoming.Balance(, (ReceiptBasis, ItemKey, Store, RowKey) IN
	|			(SELECT
	|				ItemList.ReceiptBasis,
	|				ItemList.ItemKey,
	|				ItemList.Store,
	|				ItemList.RowKey
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.ReceiptBasis = ItemList.ReceiptBasis
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.Store = ItemList.Store
	|		AND RegisterBalance.RowKey = ItemList.RowKey
	|WHERE
	|	CASE
	|		WHEN ItemList.ReceiptBasis REFS Document.GoodsReceipt
	|			THEN RegisterBalance.QuantityBalance > 0
	|		ELSE RegisterBalance.QuantityBalance < 0
	|	END
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Unposting" , Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns"  , "ReceiptBasis, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns"    , "Quantity");
		ErrorParameters.Insert("FilterColumns" , "ReceiptBasis, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation"     , "Receipt");
		ErrorParameters.Insert("RecordType"    , RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction
