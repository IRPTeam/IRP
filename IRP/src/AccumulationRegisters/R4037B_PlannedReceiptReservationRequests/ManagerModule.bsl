Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R4037B_PlannedReceiptReservationRequests");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, ItemKey, Order";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref,
		"AccumulationRegister.R4037B_PlannedReceiptReservationRequests", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting,
	AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R4037B_PlannedReceiptReservationRequests") Then
		Return True;
	EndIf;

	Query = New Query();
	Query.TempTablesManager = PostingServer.PrepareRecordsTables(GetLockFieldNames(), "ItemKey", ItemList_InDocument,
		Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	RegisterBalance.Store,
	|	RegisterBalance.Order,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R4037B_PlannedReceiptReservationRequests.Balance(, (Store, ItemKey, Order) IN
	|			(SELECT
	|				ItemList.Store,
	|				ItemList.ItemKey,
	|				ItemList.Order
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON  RegisterBalance.Store = ItemList.Store
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.Order = ItemList.Order
	|WHERE
	|	RegisterBalance.QuantityBalance < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Unposting", Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Order, Store, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "Quantity");
		ErrorParameters.Insert("FilterColumns", "Order, Store, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Incoming reservation");
		ErrorParameters.Insert("RecordType", RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;
EndFunction

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Store - CatalogRef.Stores -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion