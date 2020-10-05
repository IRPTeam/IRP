Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.OrderBalance");	
	
	Fields = New Map();
	ArrayOfFieldNames = StrSplit(GetLockFieldNames(), ",");
	For Each ItemFieldName In ArrayOfFieldNames Do
		Fields.Insert(TrimAll(ItemFieldName), TrimAll(ItemFieldName));
	EndDo;
	
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, Order, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	OrderBalance.Store,
	|	OrderBalance.Order,
	|	OrderBalance.ItemKey,
	|	OrderBalance.RowKey,
	|	OrderBalance.Quantity
	|FROM
	|	AccumulationRegister.OrderBalance AS OrderBalance
	|WHERE
	|	OrderBalance.Recorder = &Recorder
	|	AND CASE
	|		WHEN &Filter_RecordType
	|			THEN OrderBalance.RecordType = &RecordType
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
                      OrderBalance_InDocument, 
                      OrderBalance_Exists,
                      RecordType, 
                      Unposting, 
                      AddInfo = Undefined) Export

// Doc.SalesOrder            - receipt
// Doc.SalesInvoice          - expense
// Doc.PurchaseOrder         - receipt, expense
// Doc.InternalSupplyRequest - receipt
// Doc.PurchaseInvoice       - expense

	Query = New Query();
	Query.Text =
	"SELECT
	|	Record_InDocument.Store,
	|	Record_InDocument.Order,
	|	Record_InDocument.ItemKey,
	|	Record_InDocument.RowKey,
	|	Record_InDocument.Quantity
	|INTO Record_InDocument
	|FROM
	|	&OrderBalance_InDocument AS Record_InDocument
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
	|	Record_Exists.Order,
	|	Record_Exists.Store,
	|	Record_Exists.ItemKey,
	|	Record_Exists.RowKey,
	|	Record_Exists.Quantity
	|INTO Record_Exists
	|FROM
	|	&OrderBalance_Exists AS Record_Exists
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Record_InDocument.Store,
	|	Record_InDocument.Order,
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
	|	Record.Order,
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
	|	Record_Exists.Order,
	|	Record_Exists.ItemKey,
	|	Record_Exists.Store,
	|	Record_Exists.Quantity,
	|	UNDEFINED,
	|	Record_Exists.RowKey AS RowKey
	|FROM
	|	Record_Exists AS Record_Exists
	|		LEFT JOIN Record AS Record
	|		ON Record_Exists.Order = Record.Order
	|		AND Record_Exists.Store = Record.Store
	|		AND Record_Exists.ItemKey = Record.ItemKey
	|		AND Record_Exists.RowKey = Record.RowKey
	|WHERE
	|	Record.Order IS NULL
	|	AND NOT &Unposting
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	Query.SetParameter("Ref"                     , Ref);
	Query.SetParameter("OrderBalance_InDocument" , OrderBalance_InDocument);
	Query.SetParameter("ItemList_InDocument"     , ItemList_InDocument);
	Query.SetParameter("OrderBalance_Exists"     , OrderBalance_Exists);
	Query.SetParameter("Unposting"               , Unposting);
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

