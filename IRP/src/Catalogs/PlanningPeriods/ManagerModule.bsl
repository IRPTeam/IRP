
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If Parameters.Property("Filter") And Parameters.Filter.Property("BusinessUnit") Then
		
		StandardProcessing = False;
		Query = New Query();
		Query.Text = 
		"SELECT
		|	Table.Ref AS Ref
		|FROM
		|	Catalog.PlanningPeriods.BusinessUnits AS TableBusinessUnits
		|		INNER JOIN Catalog.PlanningPeriods AS Table
		|		ON Table.Ref = TableBusinessUnits.Ref
		|		AND NOT Table.DeletionMark
		|		AND TableBusinessUnits.BusinessUnit = &BusinessUnit
		|		AND Table.Description LIKE ""%"" + &SearchString + ""%""";
		Query.SetParameter("BusinessUnit" , Parameters.Filter.BusinessUnit);
		Query.SetParameter("SearchString" , Parameters.SearchString);
	
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		ChoiceData = New ValueList();
		While QuerySelection.Next() Do
			ChoiceData.Add(QuerySelection.Ref);
		EndDo;
		
	EndIf;
EndProcedure
