#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	PriceListItemKeyList.Ref.Date AS Period,
	|	PriceListItemKeyList.Ref.PriceType AS PriceType,
	|	PriceListItemKeyList.ItemKey,
	|	PriceListItemKeyList.Price
	|FROM
	|	Document.PriceList.ItemKeyList AS PriceListItemKeyList
	|WHERE
	|	PriceListItemKeyList.Ref = &Ref
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PriceListItemList.Ref.Date AS Period,
	|	PriceListItemList.Ref.PriceType AS PriceType,
	|	PriceListItemList.Item,
	|	PriceListItemList.Price
	|FROM
	|	Document.PriceList.ItemList AS PriceListItemList
	|WHERE
	|	PriceListItemList.Ref = &Ref
	|;";

	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();

	Tables = New Structure();

	Tables.Insert("ItemKeyList", QueryResults[0].Unload());
	Tables.Insert("ItemList", QueryResults[1].Unload());

	PriceKeyList = New ValueTable();
	PriceKeyList.Columns.Add("PriceList", New TypeDescription("DocumentRef.PriceList"));
	PriceKeyList.Columns.Add("PriceKey", New TypeDescription("CatalogRef.PriceKeys"));
	PriceKeyList.Columns.Add("Item", New TypeDescription("CatalogRef.Items"));
	PriceKeyList.Columns.Add("Price", New TypeDescription(Metadata.DefinedTypes.typePrice.Type));

	If Ref.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		PriceKeyList = Catalogs.PriceKeys.GetTableByPriceList(Ref);
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT
	|	PriceKeyList.PriceList,
	|	PriceKeyList.PriceKey,
	|	PriceKeyList.Item,
	|	PriceKeyList.Price
	|INTO tmp
	|FROM
	|	&PriceKeyList AS PriceKeyList
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.PriceList,
	|	tmp.PriceKey,
	|	tmp.Item,
	|	tmp.Price,
	|	DocPriceList.Date AS Period,
	|	DocPriceList.PriceType
	|FROM
	|	Document.PriceList AS DocPriceList
	|		INNER JOIN tmp AS tmp
	|		ON tmp.PriceList = DocPriceList.Ref
	|		AND DocPriceList.Ref = &Ref";

	Query.SetParameter("PriceKeyList", PriceKeyList);
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();

	Tables.Insert("PriceKeyList", QueryResults[1].Unload());

	Parameters.IsReposting = False;

	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PricesByItemKeys
	Fields = New Map();
	Fields.Insert("PriceType", "PriceType");
	Fields.Insert("ItemKey", "ItemKey");

	DataMapWithLockFields.Insert("InformationRegister.PricesByItemKeys", New Structure("Fields, Data", Fields,
		DocumentDataTables.ItemKeyList));
	
	// Prices by items
	Fields = New Map();
	Fields.Insert("PriceType", "PriceType");
	Fields.Insert("Item", "Item");

	DataMapWithLockFields.Insert("InformationRegister.PricesByItems", New Structure("Fields, Data", Fields,
		DocumentDataTables.ItemList));
	
	// Prices by properties
	Fields = New Map();
	Fields.Insert("PriceType", "PriceType");
	Fields.Insert("PriceKey", "PriceKey");

	DataMapWithLockFields.Insert("InformationRegister.PricesByProperties", New Structure("Fields, Data", Fields,
		DocumentDataTables.PriceKeyList));

	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PricesByItemKeys
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PricesByItemKeys,
		New Structure("RecordSet, WriteInTransaction", Parameters.DocumentDataTables.ItemKeyList,
		Parameters.IsReposting));
	
	// Prices by items
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PricesByItems,
		New Structure("RecordSet, WriteInTransaction", Parameters.DocumentDataTables.ItemList, Parameters.IsReposting));
	
	// Prices by properties
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PricesByProperties,
		New Structure("RecordSet, WriteInTransaction", Parameters.DocumentDataTables.PriceKeyList,
		Parameters.IsReposting));

	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();

	Return QueryArray;
EndFunction

#EndRegion