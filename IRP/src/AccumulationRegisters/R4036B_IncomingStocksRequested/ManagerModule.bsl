Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R4036B_IncomingStocksRequested");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "ItemKey, Order";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.R4036B_IncomingStocksRequested",
		RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting,
	AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "R4036B_IncomingStocksRequested") Then
		Return True;
	EndIf;

	Query = New Query();
	Query.TempTablesManager = PostingServer.PrepareRecordsTables(GetLockFieldNames(), "ItemKey", ItemList_InDocument,
		Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	RegisterBalance.IncomingStore,
	|	RegisterBalance.RequesterStore,
	|	RegisterBalance.Order,
	|	RegisterBalance.Requester,
	|	RegisterBalance.QuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	-RegisterBalance.QuantityBalance AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R4036B_IncomingStocksRequested.Balance(, (IncomingStore, RequesterStore, ItemKey,
	|			Order, Requester) IN
	|			(SELECT
	|				ItemList.IncomingStore,
	|				ItemList.RequesterStore,
	|				ItemList.ItemKey,
	|				ItemList.Order,
	|				ItemList.Requester
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.IncomingStore = ItemList.IncomingStore
	|		AND RegisterBalance.RequesterStore = ItemList.RequesterStore
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND RegisterBalance.Order = ItemList.Order
	|		AND RegisterBalance.Requester = ItemList.Requester
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
		ErrorParameters.Insert("GroupColumns",
			"Order, IncomingStore, RequesterStore, Requester, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "Quantity");
		ErrorParameters.Insert("FilterColumns",
			"Order, IncomingStore, RequesterStore, Requester, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Incoming requested");
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

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure