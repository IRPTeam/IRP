Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	
	If TypeOf(Parameters) <> Type("Structure")
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
			If Not Parameters.Filter.Count() Then
				StandardProcessing = False;
			EndIf;
		Return;
	EndIf;
	
	StandardProcessing = False;
	If Not ValueIsFilled(Parameters.SearchString) Then
		Return;
	EndIf;
	
	QueryTable = GetChoiseDataTable(Parameters);
	ChoiceData = New ValueList();
	For Each Row In QueryTable Do
		ChoiceData.Add(Row.Ref, Row.Presentation);
	EndDo;
EndProcedure

Function GetChoiseDataTable(Parameters) Export
	Filter = "
		|	AND CASE
		|		WHEN &Filter_RefInList
		|			THEN Table.Ref IN (&RefList)
		|		ELSE TRUE
		|	END
		|";

	Settings = New Structure;
	Settings.Insert("Name", "Catalog.ObjectStatuses");
	Settings.Insert("Filter", Filter);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);

	
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	If TypeOf(Parameters) = Type("Structure") And Parameters.Filter.Property("CustomSearchFilter") Then
		ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
		For Each Filter In ArrayOfFilters Do
			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
			NewFilter.Use = True;
			NewFilter.ComparisonType = 
			CommonFunctionsClientServer.CompositionComparisonTypeToComparisonType(Filter.ComparisonType);
			NewFilter.Value = Filter.Value;
		EndDo;
	EndIf;
	Query = QueryBuilder.GetQuery();
	
	Query.SetParameter("SearchString", Parameters.SearchString);
	
	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	QueryParameters = New Structure("Filter_RefInList, RefList", False, New Array());
	FillPropertyValues(QueryParameters, AdditionalParameters);
	For Each QueryParameter In QueryParameters Do
		Query.SetParameter(QueryParameter.Key, QueryParameter.Value);
	EndDo;
	Return Query.Execute().Unload();
EndFunction

