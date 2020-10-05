Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.GoodsInTransitIncoming");
	
	Fields = New Map();
	ArrayOfFieldNames = StrSplit(GetLockFieldNames(), ",");
	For Each ItemFieldName In ArrayOfFieldNames Do
		Fields.Insert(TrimAll(ItemFieldName), TrimAll(ItemFieldName));
	EndDo;
	
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, ReceiptBasis, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	GoodsInTransitIncoming.Store,
	|	GoodsInTransitIncoming.ReceiptBasis,
	|	GoodsInTransitIncoming.ItemKey,
	|	GoodsInTransitIncoming.RowKey,
	|	GoodsInTransitIncoming.Quantity
	|FROM
	|	AccumulationRegister.GoodsInTransitIncoming AS GoodsInTransitIncoming
	|WHERE
	|	GoodsInTransitIncoming.Recorder = &Recorder
	|	AND CASE
	|		WHEN &Filter_RecordType
	|			THEN GoodsInTransitIncoming.RecordType = &RecordType
	|		ELSE TRUE
	|	END";
	Query.SetParameter("Recorder", Ref);
	Query.SetParameter("Filter_RecordType", RecordType <> Undefined);
	Query.SetParameter("RecordType", RecordType);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function CheckBalance(Ref, 
                      ItemList_InDocument, 
                      GoodsInTransitIncoming_InDocument, 
                      GoodsInTransitIncoming_Exists,
                      RecordType, 
                      Unposting, 
                      AddInfo = Undefined) Export
// Doc.GoodsReceipt - expense

	Query = New Query();
	Query.Text =
	"SELECT
	|	Record_InDocument.Store,
	|	Record_InDocument.ReceiptBasis,
	|	Record_InDocument.ItemKey,
	|	Record_InDocument.RowKey,
	|	Record_InDocument.Quantity
	|INTO Record_InDocument
	|FROM
	|	&GoodsInTransitIncoming_InDocument AS Record_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_InDocument.LineNumber,
	|	ItemList_InDocument.RowKey
	|INTO ItemList_InDocument
	|FROM
	|	&ItemList_InDocument AS ItemList_InDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Record_Exists.ReceiptBasis,
	|	Record_Exists.Store,
	|	Record_Exists.ItemKey,
	|	Record_Exists.RowKey,
	|	Record_Exists.Quantity
	|INTO Record_Exists
	|FROM
	|	&GoodsInTransitIncoming_Exists AS Record_Exists
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Record_InDocument.Store,
	|	Record_InDocument.ReceiptBasis,
	|	Record_InDocument.ItemKey,
	|	Record_InDocument.RowKey,
	|	Record_InDocument.Quantity,
	|	ItemList_InDocument.LineNumber
	|INTO Record
	|FROM
	|	Record_InDocument AS Record_InDocument
	|		LEFT JOIN ItemList_InDocument AS ItemList_InDocument
	|		ON Record_InDocument.RowKey = ItemList_InDocument.RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Record.ReceiptBasis,
	|	Record.ItemKey,
	|	Record.Store,
	|	Record.Quantity,
	|	Record.LineNumber,
	|	Record.RowKey
	|INTO ItemList
	|FROM
	|	Record AS Record
	|
	|UNION ALL
	|
	|SELECT
	|	Record_Exists.ReceiptBasis,
	|	Record_Exists.ItemKey,
	|	Record_Exists.Store,
	|	Record_Exists.Quantity,
	|	UNDEFINED,
	|	Record_Exists.RowKey AS RowKey
	|FROM
	|	Record_Exists AS Record_Exists
	|		LEFT JOIN Record AS Record
	|		ON Record_Exists.ReceiptBasis = Record.ReceiptBasis
	|		AND Record_Exists.Store = Record.Store
	|		AND Record_Exists.ItemKey = Record.ItemKey
	|		AND Record_Exists.RowKey = Record.RowKey
	|WHERE
	|	Record.ReceiptBasis IS NULL
	|	AND NOT &Unposting
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	Query.SetParameter("Ref"                               , Ref);
	Query.SetParameter("GoodsInTransitIncoming_InDocument" , GoodsInTransitIncoming_InDocument);
	Query.SetParameter("ItemList_InDocument"               , ItemList_InDocument);
	Query.SetParameter("GoodsInTransitIncoming_Exists"     , GoodsInTransitIncoming_Exists);
	Query.SetParameter("Unposting"                         , Unposting);
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
