#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Specification = FindOrCreateSpecificationByProperties(Ref, AddInfo);
	ItemKey = Catalogs.ItemKeys.FindOrCreateRefBySpecification(Specification, Ref.ItemBundle, AddInfo);

	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref, ItemKey));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Return New Structure();
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
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);

		Filter = New Structure("RecordType", AccumulationRecordType.Expense);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(
			Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(
			Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Bundling.ItemList", AddInfo);
		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(
			Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(
			Filter));

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ErrorQuantityField", "Object.Quantity");
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Bundling.ItemList", AddInfo);
	Else
		// is unposting
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ErrorQuantityField", "Object.Quantity");
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Bundling.ItemList", AddInfo);
	EndIf;
EndProcedure

#EndRegion

#Region Specifications

Function FindOrCreateSpecificationByProperties(Ref, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	BundlingItemList.Key,
	|	BundlingItemList.ItemKey.Item AS Item,
	|	ItemKeysAddAttributes.Property AS Attribute,
	|	ItemKeysAddAttributes.Value
	|FROM
	|	Catalog.ItemKeys.AddAttributes AS ItemKeysAddAttributes
	|		INNER JOIN Document.Bundling.ItemList AS BundlingItemList
	|		ON BundlingItemList.ItemKey = ItemKeysAddAttributes.Ref
	|		AND BundlingItemList.Ref = &Ref
	|GROUP BY
	|	BundlingItemList.ItemKey.Item,
	|	ItemKeysAddAttributes.Property,
	|	ItemKeysAddAttributes.Value,
	|	BundlingItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BundlingItemList.Key,
	|	BundlingItemList.ItemKey.Item AS Item,
	|	SUM(BundlingItemList.Quantity) AS Quantity
	|FROM
	|	Document.Bundling.ItemList AS BundlingItemList
	|WHERE
	|	BundlingItemList.Ref = &Ref
	|GROUP BY
	|	BundlingItemList.ItemKey.Item,
	|	BundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	ArrayOfQueryResults = Query.ExecuteBatch();

	ArrayOfSpecifications = Catalogs.Specifications.FindOrCreateRefByProperties(ArrayOfQueryResults[0].Unload(),
		ArrayOfQueryResults[1].Unload(), Ref.ItemBundle, AddInfo);
	If ArrayOfSpecifications.Count() Then
		Return ArrayOfSpecifications[0];
	Else
		Return Catalogs.Specifications.EmptyRef();
	EndIf;
EndFunction

#EndRegion

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref, ItemKey = Undefined)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	StrParams.Insert("ItemKey", ItemKey);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(Header());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(BundleContents());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	BundlingItemList.Ref.Date AS Period,
		   |	BundlingItemList.Ref.Company AS Company,
		   |	BundlingItemList.Ref.Store AS Store,
		   |	BundlingItemList.ItemKey AS ItemKey,
		   |	BundlingItemList.QuantityInBaseUnit * BundlingItemList.Ref.QuantityInBaseUnit AS Quantity
		   |INTO ItemList
		   |FROM
		   |	Document.Bundling.ItemList AS BundlingItemList
		   |WHERE
		   |	BundlingItemList.Ref = &Ref";
EndFunction

Function Header()
	Return "SELECT
		   |	Bundling.Date AS Period,
		   |	Bundling.Company,
		   |	Bundling.Store,
		   |	&ItemKey,
		   |	Bundling.QuantityInBaseUnit AS Quantity,
		   |	Bundling.Ref
		   |INTO Header	
		   |FROM
		   |	Document.Bundling AS Bundling
		   |WHERE
		   |	Bundling.Ref = &Ref";
EndFunction

Function BundleContents()
	Return "SELECT
		   |	Header.Period AS Period,
		   |	SUM(ItemList.Quantity / Header.Quantity) AS Quantity,
		   |	ItemList.ItemKey AS ItemKey,
		   |	Header.ItemKey AS ItemKeyBundle
		   |INTO BundleContents
		   |FROM
		   |	Header AS Header
		   |		LEFT JOIN ItemList AS ItemList
		   |		ON TRUE
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	Header.Period,
		   |	ItemList.ItemKey,
		   |	Header.ItemKey";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Header.Period,
		   |	Header.Store,
		   |	Header.ItemKey,
		   |	Header.Quantity
		   |FROM
		   |	Header AS Header
		   |WHERE
		   |	TRUE";
EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Quantity
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Header.Period,
		   |	Header.Store,
		   |	Header.ItemKey,
		   |	Header.Quantity
		   |FROM
		   |	Header AS Header
		   |WHERE
		   |	TRUE";
EndFunction