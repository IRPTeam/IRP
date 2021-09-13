#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
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
	
	PricesByProperties = New ValueTable();
	PricesByProperties.Columns.Add("PriceList"  , New TypeDescription("DocumentRef.PriceList"));
	PricesByProperties.Columns.Add("PriceKey"   , New TypeDescription("CatalogRef.PriceKeys"));
	PricesByProperties.Columns.Add("Item"       , New TypeDescription("CatalogRef.Items"));
	PricesByProperties.Columns.Add("InputUnit"  , New TypeDescription("CatalogRef.Units"));
	PricesByProperties.Columns.Add("InputPrice" , New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	PricesByProperties.Columns.Add("Price"      , New TypeDescription(Metadata.DefinedTypes.typePrice.Type));

	If Ref.PriceListType = Enums.PriceListTypes.PriceByProperties Then
		PricesByProperties = Catalogs.PriceKeys.GetTableByPriceList(Ref);
	EndIf;
	StrParams.Insert("PricesByProperties", PricesByProperties);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(PricesByItems());
	QueryArray.Add(PricesByItemKeys());
	QueryArray.Add(PricesByProperties());
	Return QueryArray;
EndFunction

Function PricesByItemKeys()
	Return
	"SELECT
	|	PriceListItemKeyList.Ref.Date AS Period,
	|	PriceListItemKeyList.Ref.PriceType AS PriceType,
	|	PriceListItemKeyList.ItemKey,
	|	PriceListItemKeyList.InputUnit,
	|	PriceListItemKeyList.InputPrice,
	|	PriceListItemKeyList.Price
	|INTO PricesByItemKeys
	|FROM
	|	Document.PriceList.ItemKeyList AS PriceListItemKeyList
	|WHERE
	|	PriceListItemKeyList.Ref = &Ref";
EndFunction

Function PricesByItems()
	Return
	"SELECT
	|	PriceListItemList.Ref.Date AS Period,
	|	PriceListItemList.Ref.PriceType AS PriceType,
	|	PriceListItemList.Item,
	|	PriceListItemList.InputUnit,
	|	PriceListItemList.InputPrice,
	|	PriceListItemList.Price
	|INTO PricesByItems
	|FROM
	|	Document.PriceList.ItemList AS PriceListItemList
	|WHERE
	|	PriceListItemList.Ref = &Ref";
EndFunction

Function PricesByProperties()
	Return
	"SELECT
	|	PricesByProperties.PriceList,
	|	PricesByProperties.PriceKey,
	|	PricesByProperties.Item,
	|	PricesByProperties.InputUnit,
	|	PricesByProperties.InputPrice,
	|	PricesByProperties.Price
	|INTO tmp
	|FROM
	|	&PricesByProperties AS PricesByProperties
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.PriceList,
	|	tmp.PriceKey,
	|	tmp.Item,
	|	tmp.InputUnit,
	|	tmp.InputPrice,
	|	tmp.Price,
	|	DocPriceList.Date AS Period,
	|	DocPriceList.PriceType
	|INTO PricesByProperties
	|FROM
	|	Document.PriceList AS DocPriceList
	|		INNER JOIN tmp AS tmp
	|		ON tmp.PriceList = DocPriceList.Ref
	|		AND DocPriceList.Ref = &Ref";
EndFunction

#EndRegion