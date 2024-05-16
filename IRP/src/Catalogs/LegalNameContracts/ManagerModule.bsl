
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("Company") Then
		Return;
	EndIf;

	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	CatalogsServer.SetParametersForDataChoosing(Catalogs.LegalNameContracts, Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);
EndProcedure

Function GetChoiceDataTable(Parameters)
	Filter = "";
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "CustomSearchFilter" OR FilterItem.Key = "AdditionalParameters" Then
			Continue; // Service properties
		EndIf;
		If FilterItem.Key = "Company" Then
			Filter = Filter
				+ "
			|	AND Table." + FilterItem.Key + " IN (&" + FilterItem.Key + ", Value(Catalog.Companies.EmptyRef))";			
		Else
			Filter = Filter
				+ "
			|	AND Table." + FilterItem.Key + " = &" + FilterItem.Key;
		EndIf;
	EndDo;			 
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.LegalNameContracts);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);
	For Each Filter In Parameters.Filter Do
		Query.SetParameter(Filter.Key, Filter.Value);
	EndDo;
	
	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);

	Return Query.Execute().Unload();	
EndFunction