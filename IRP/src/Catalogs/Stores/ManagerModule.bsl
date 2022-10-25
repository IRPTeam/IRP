// @strict-types

// Choice data get processing.
// 
// Parameters:
//  ChoiceData - ValueList - Choice data
//  Parameters - Structure - Parameters:
//   * SearchString - String, Undefined - the search string; contains a Undefined value for quick selection
//   * Filter - Structure - the search filter
//   * ChoiceFoldersAndItems - FoldersAndItemsUse - specifies whether folders and items are included
//   * StringSearchMode - SearchStringModeOnInputByString - the search method if the input by string feature is used
//   * FullTextSearch - FullTextSearchOnInputByString - specifies whether full-text search is used with the input by string feature
//   * ChoiceDataGettingMode - ChoiceDataGetModeOnInputByString - specifies search run mode
//  StandardProcessing - Boolean - Standard processing
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString) Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	
EndProcedure

// Get choice data table.
// 
// Parameters:
//  Parameters - Structure - Parameters:
//   * SearchString - String, Undefined - the search string; contains a Undefined value for quick selection
//   * Filter - Structure - the search filter
//   * ChoiceFoldersAndItems - FoldersAndItemsUse - specifies whether folders and items are included
//   * StringSearchMode - SearchStringModeOnInputByString - the search method if the input by string feature is used
//   * FullTextSearch - FullTextSearchOnInputByString - specifies whether full-text search is used with the input by string feature
//   * ChoiceDataGettingMode - ChoiceDataGetModeOnInputByString - specifies search run mode
// 
// Returns:
//  ValueTable - Get choice data table
Function GetChoiceDataTable(Parameters)
	
	Filter = "";
	For Each FilterItem In Parameters.Filter Do
		Filter = Filter + 
			?(FilterItem.Key = "Company",
		"
		|	AND (" + Format(Not ValueIsFilled(FilterItem.Value), "BF=FALSE; BT=TRUE;") + 
			" OR Table.Company = VALUE(Catalog.Companies.EmptyRef) OR Table.Company = &Company)",
		"
		|	AND Table."+FilterItem.Key+" = &"+FilterItem.Key);
	EndDo;
	
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.Stores);
	Settings.Insert("Filter", Filter);
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);
	For Each FilterItem In Parameters.Filter Do
		Query.SetParameter(FilterItem.Key, FilterItem.Value);
	EndDo;
	
	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);

	Return Query.Execute().Unload();	
EndFunction