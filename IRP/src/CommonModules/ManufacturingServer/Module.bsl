
Function GetUniquePlanningPeriodByDate(Date, BusinessUnit) Export
	Query = New Query();
	Query.Text = 
		"SELECT TOP 2
		|	Table.Ref AS Ref
		|FROM
		|	Catalog.PlanningPeriods.BusinessUnits AS TableBusinessUnits
		|		INNER JOIN Catalog.PlanningPeriods AS Table
		|		ON Table.Ref = TableBusinessUnits.Ref
		|		AND &Date BETWEEN Table.StartDate AND Table.EndDate
		|		AND NOT Table.DeletionMark
		|		AND TableBusinessUnits.BusinessUnit = &BusinessUnit";
	Query.SetParameter("Date", Date);
	Query.SetParameter("BusinessUnit", BusinessUnit);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() = 1 Then
		QuerySelection.Next();
		Return QuerySelection.Ref;
	EndIf;
	Return Catalogs.PlanningPeriods.EmptyRef();
EndFunction
