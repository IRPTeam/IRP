Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)

	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;

	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = New ValueList();
	For Each Row In QueryTable Do
		ChoiceData.Add(Row.Ref, Row.Presentation);
	EndDo;
EndProcedure

Function GetChoiceDataTable(Parameters) Export

	Filter = "";
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.ExpenseAndRevenueTypes);
	Settings.Insert("Filter", Filter);

	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);

	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	If TypeOf(Parameters) = Type("Structure") And Parameters.Filter.Property("CustomSearchFilter") Then
		ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
		For Each Filter In ArrayOfFilters Do
			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
			NewFilter.Use = True;
			NewFilter.ComparisonType = Filter.ComparisonType;
			NewFilter.Value = Filter.Value;
		EndDo;
	EndIf;
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);
	QueryParametersStr = New Structure();

	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	For Each QueryParameter In QueryParametersStr Do
		KeyValue = ?(AdditionalParameters.Property(QueryParameter.Key), AdditionalParameters[QueryParameter.Key],
			QueryParameter.Value);
		Query.SetParameter(QueryParameter.Key, KeyValue);
	EndDo;
	Return Query.Execute().Unload();
EndFunction