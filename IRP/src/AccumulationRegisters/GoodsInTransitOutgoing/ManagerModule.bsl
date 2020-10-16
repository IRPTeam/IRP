Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.GoodsInTransitOutgoing");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, ShipmentBasis, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.GoodsInTransitOutgoing", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export

// Doc.SalesInvoice - receipt
// Doc.ShipmentConfirmation - expense
// Doc.GoodsReceipt - expense
// Doc.SalesOrder - receipt
	
	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_GoodsInTransitOutgoing") Then
		Return True;
	EndIf;

	Query = New Query();
	Query.TempTablesManager = 
	PostingServer.PrepareRecordsTables(GetLockFieldNames(), ItemList_InDocument, Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	ItemList.ShipmentBasis,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.GoodsInTransitOutgoing.Balance(, (ShipmentBasis, ItemKey, Store, RowKey) IN
	|			(SELECT
	|				ItemList.ShipmentBasis,
	|				ItemList.ItemKey,
	|				ItemList.Store,
	|				ItemList.RowKey
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.ShipmentBasis = ItemList.ShipmentBasis
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.Store = ItemList.Store
	|		AND RegisterBalance.RowKey = ItemList.RowKey
	|WHERE
	|	CASE
	|		WHEN VALUETYPE(ItemList.ShipmentBasis) = TYPE(Document.ShipmentConfirmation)
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
		ErrorParameters.Insert("GroupColumns"  , "ShipmentBasis, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns"    , "Quantity");
		ErrorParameters.Insert("FilterColumns" , "ShipmentBasis, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation"     , "Shipping");
		ErrorParameters.Insert("RecordType"    , RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction	
