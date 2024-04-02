Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	CatalogsServer.SetParametersForDataChoosing(Catalogs.ObjectStatuses, Parameters);
	
	If Parameters.Property("Filter") And Parameters.Filter.Property("Ref") Then
		StandardProcessing = False;
		QueryTable = GetChoiceDataTable_ByUser(Parameters);
		
		ChoiceData = New ValueList();
		For Each Row In QueryTable Do
			ChoiceData.Add(Row.Ref, Row.Presentation);
		EndDo;
		
		Return;	
	EndIf;
	
	If TypeOf(Parameters) <> Type("Structure") Or Not Parameters.Filter.Property("AdditionalParameters") Then
		If Not Parameters.Filter.Count() Then
			StandardProcessing = False;
		EndIf;
		Return;
	EndIf;

	StandardProcessing = False;
	If Not ValueIsFilled(Parameters.SearchString) Then
		Return;
	EndIf;

	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = New ValueList();
	For Each Row In QueryTable Do
		ChoiceData.Add(Row.Ref, Row.Presentation);
	EndDo;
EndProcedure

Function GetChoiceDataTable(Parameters) Export
	Filter = "
			 |	AND CASE
			 |		WHEN &Filter_RefInList
			 |			THEN Table.Ref IN (&RefList)
			 |		ELSE TRUE
			 |	END
			 |";

	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.ObjectStatuses);
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

Function GetChoiceDataTable_ByUser(Parameters)
	Query = New Query();
	//@skip-check ql-constants-in-binary-operation
	Query.Text = 
	"SELECT
	|	ObjectStatuses.Ref,
	|	PRESENTATION(ObjectStatuses.Ref) AS Presentation
	|FROM
	|	Catalog.ObjectStatuses.Users AS ObjectStatusesUsers
	|		INNER JOIN Catalog.ObjectStatuses AS ObjectStatuses
	|		ON ObjectStatusesUsers.Ref = ObjectStatuses.Ref
	|		AND NOT ObjectStatuses.DeletionMark
	|		AND NOT ObjectStatuses.IsFolder
	|		AND ObjectStatuses.Parent = &Parent
	|		AND CASE
	|			WHEN &Filter_SearchString
	|				THEN ObjectStatuses.Description_en LIKE ""%"" + &SearchString + ""%""
	|			ELSE TRUE
	|		END
	|		AND ObjectStatusesUsers.User = &User";
	Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, "ObjectStatuses");
	
	Query.SetParameter("Parent"              , ProductionPlanningCorrection);
	Query.SetParameter("Filter_SearchString" , ValueIsFilled(Parameters.SearchString));
	Query.SetParameter("SearchString"        , ?(ValueIsFilled(Parameters.SearchString),Parameters.SearchString, ""));
	Query.SetParameter("User"                , SessionParameters.CurrentUser);
		
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction
