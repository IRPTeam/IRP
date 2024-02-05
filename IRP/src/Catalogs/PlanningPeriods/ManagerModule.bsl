
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If Parameters.Property("Filter") And Parameters.Filter.Property("BusinessUnit") Then
		
		StandardProcessing = False;
		
		CatalogsServer.SetParametersForDataChoosing(Catalogs.PlanningPeriods, Parameters);
		
		Filter = "";
		For Each FilterItem In Parameters.Filter Do
			If FilterItem.Key = "CustomSearchFilter" OR FilterItem.Key = "AdditionalParameters" Then
				Continue; // Service properties
			EndIf;
			If FilterItem.Key = "BusinessUnit" Then
				Continue; // Additional parameters
			EndIf;
			Filter = Filter
				+ "
			|	AND Table." + FilterItem.Key + " = &" + FilterItem.Key;
		EndDo;			 
		
		Query = New Query();
		Query.Text = 
		"SELECT
		|	Table.Ref AS Ref
		|FROM
		|	Catalog.PlanningPeriods.BusinessUnits AS TableBusinessUnits
		|		INNER JOIN Catalog.PlanningPeriods AS Table
		|		ON Table.Ref = TableBusinessUnits.Ref
		|		AND NOT Table.DeletionMark  " + Filter + "
		|		AND TableBusinessUnits.BusinessUnit = &BusinessUnit
		|		AND Table.Description LIKE ""%"" + &SearchString + ""%""";
		Query.SetParameter("SearchString" , Parameters.SearchString);
		For Each Filter In Parameters.Filter Do
			Query.SetParameter(Filter.Key, Filter.Value);
		EndDo;
	
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		ChoiceData = New ValueList();
		While QuerySelection.Next() Do
			ChoiceData.Add(QuerySelection.Ref);
		EndDo;
		
	EndIf;
EndProcedure
