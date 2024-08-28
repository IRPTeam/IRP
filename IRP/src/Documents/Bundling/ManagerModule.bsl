#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "BundlingPrint") = 0 Then
		Return BundlingPrint(Ref, Param);
	EndIf;
EndFunction

// Bundling print.
// 
// Parameters:
//  Ref - DocumentRef.Bundling
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Bundling print
Function BundlingPrint(Ref, Param)
		
	Template = GetTemplate("BundlingPrint");
	Template.LanguageCode = Param.LayoutLang;
	Query = New Query;
	Text =
	"SELECT
	|	DocumentHeader.Number AS Number,
	|	DocumentHeader.Date AS Date,
	|	DocumentHeader.Company.Description_en AS Company,
	|	DocumentHeader.Store.Description_en AS Store,
	|	DocumentHeader.Author AS Author,
	|	DocumentHeader.ItemBundle.Description_en AS Product,
	|	DocumentHeader.Quantity AS Quantity,
	|	DocumentHeader.Ref AS Ref
	|FROM
	|	Document.Bundling AS DocumentHeader
	|WHERE
	|	DocumentHeader.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentItemList.ItemKey.Item.Description_en AS Item,
	|	DocumentItemList.ItemKey.Description_en AS ItemKey,
	|	DocumentItemList.Quantity AS Quantity,
	|	DocumentItemList.Unit.Description_en AS Unit,
	|	DocumentItemList.Ref AS Ref,
	|	DocumentItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.Bundling.ItemList AS DocumentItemList
	|WHERE
	|	DocumentItemList.Ref = &Ref	
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Items.Item AS Item,
	|	Items.ItemKey AS ItemKey,
	|	Items.Quantity AS Quantity,
	|	Items.Unit AS Unit,
	|	Items.Ref AS Ref,
	|	Items.Key AS Key
	|FROM
	|	Items AS Items";

	LCode = Param.DataLang;
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Company", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Store", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.ItemBundle", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.ItemKey.Item", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.ItemKey", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.Unit", LCode);
	Query.Text = Text;                                                    

	Query.Parameters.Insert("Ref", Ref);
	Selection = Query.ExecuteBatch();
	SelectionHeader = Selection[0].Select();
	SelectionItems = Selection[2].Unload();
	SelectionItems.Indexes.Add("Ref");

	AreaCaption = Template.GetArea("Caption");
	AreaHeader = Template.GetArea("Header");
	AreaItemListHeader = Template.GetArea("ItemListHeader|ItemColumn");
	AreaItemList = Template.GetArea("ItemList|ItemColumn");
	AreaFooter = Template.GetArea("Footer");
	
	Spreadsheet = New SpreadsheetDocument;
	Spreadsheet.LanguageCode = Param.LayoutLang;

	While SelectionHeader.Next() Do
		AreaCaption.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaCaption);

		AreaHeader.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaHeader);

		Spreadsheet.Put(AreaItemListHeader);
				
		Choice	= New Structure("Ref", SelectionHeader.Ref);
		FindRow = SelectionItems.FindRows(Choice);

		Number = 0;
	
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);
			AreaItemList.Parameters.Number = Number;
			Spreadsheet.Put(AreaItemList);	
		EndDo;
	EndDo;

	AreaFooter.Parameters.Manager = SelectionHeader.Author;
	Spreadsheet.Put(AreaFooter);
	Spreadsheet = UniversalPrintServer.ResetLangSettings(Spreadsheet, Param.LayoutLang);
	Return Spreadsheet;
	
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Specification = FindOrCreateSpecificationByProperties(Ref, AddInfo);
	ItemKey = Catalogs.ItemKeys.FindOrCreateRefBySpecification(Specification, Ref.ItemBundle, AddInfo);

	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref, ItemKey));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Return New Structure;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref, True);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
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
	DataMapWithLockFields = New Map;
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
	CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo = Undefined) Export
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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref, ItemKey = Undefined)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	StrParams.Insert("ItemKey", ItemKey);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Header());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
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

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(BundleContents());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	Return QueryArray;
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

Function T6010S_BatchesInfo()
	Return "SELECT
		   |	Header.Period,
		   |	Header.Ref AS Document,
		   |	Header.Company
		   |INTO T6010S_BatchesInfo
		   |FROM
		   |	Header AS Header
		   |WHERE 
		   |	TRUE";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	VALUE(Enum.BatchDirection.Receipt) AS Direction,
		   |	Header.Period,
		   |	Header.Company,
		   |	Header.Store,
		   |	Header.ItemKey,
		   |	SUM(Header.Quantity) AS Quantity
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	Header AS Header
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(Enum.BatchDirection.Receipt),
		   |	Header.Period,
		   |	Header.Company,
		   |	Header.Store,
		   |	Header.ItemKey
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(Enum.BatchDirection.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(Enum.BatchDirection.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	AccessKeyMap.Insert("Store", Obj.Store);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Service

#Region Specifications

Function FindOrCreateSpecificationByProperties(Ref, AddInfo = Undefined) Export
	Query = New Query;
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

	ArrayOfSpecifications = Catalogs.Specifications.FindOrCreateRefByProperties(ArrayOfQueryResults[0].Unload(), ArrayOfQueryResults[1].Unload(), Ref.ItemBundle, AddInfo);
	If ArrayOfSpecifications.Count() Then
		Return ArrayOfSpecifications[0];
	Else
		Return Catalogs.Specifications.EmptyRef();
	EndIf;
EndFunction

#EndRegion

#EndRegion