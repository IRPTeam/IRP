Function CheckChequeBondsOfCurrency(ChequeBonds, Currency) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	ChequeBonds.Ref
	|FROM
	|	Catalog.ChequeBonds AS ChequeBonds
	|WHERE
	|	ChequeBonds.Ref IN (&ChequeBonds)
	|	AND Not ChequeBonds.Currency = &Currency";

	Query.SetParameter("ChequeBonds", ChequeBonds);
	Query.SetParameter("Currency", Currency);

	QueryResult = Query.Execute();

	Return QueryResult.Unload().UnloadColumn("Ref");

EndFunction

Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymblosIfCameFromExcel(Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	

	// for remove
//	StandardProcessing = False;
//
//	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
//		Or Not Parameters.Filter.Property("AdditionalParameters") Then
//		Return;
//	EndIf;
//
//	QueryTable = GetChoiceDataTable(Parameters);
//	ChoiceData = New ValueList();
//	For Each Row In QueryTable Do
//		ChoiceData.Add(Row.Ref, Row.Presentation);
//	EndDo;
EndProcedure

Function GetChoiceDataTable(Parameters) Export
	Filter = "";
	
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.ChequeBonds);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);
	
	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);
	
	Return Query.Execute().Unload();



// for remove
//	QueryBuilderText =
//	"SELECT ALLOWED TOP 50
//	|	Table.Ref AS Ref,
//	|	Table.Presentation
//	|FROM
//	|	Catalog.ChequeBonds AS Table
//	|WHERE
//	|	Table.Description LIKE ""%%"" + &SearchString + ""%%""
//	|";
//	QueryBuilder = New QueryBuilder(QueryBuilderText);
//	QueryBuilder.FillSettings();
//	If TypeOf(Parameters) = Type("Structure") And Parameters.Filter.Property("CustomSearchFilter") Then
//		ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
//		For Each Filter In ArrayOfFilters Do
//			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
//			NewFilter.Use = True;
//			NewFilter.ComparisonType = Filter.ComparisonType;
//			NewFilter.Value = Filter.Value;
//		EndDo;
//	EndIf;
//	Query = QueryBuilder.GetQuery();
//
//	Query.SetParameter("SearchString", Parameters.SearchString);
//
//	Return Query.Execute().Unload();
EndFunction

