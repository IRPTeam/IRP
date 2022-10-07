
Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
	 	If FillingData.Property("BusinessUnit") And ValueIsFilled(FillingData.BusinessUnit) Then
			ThisObject.BusinessUnits.Add().BusinessUnit = FillingData.BusinessUnit;
			ThisObject.Type = Enums.PlanningPeriodTypes.Manufacturing;
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.IsFolder Then
		Return;
	EndIf;
	If ThisObject.BeginDate > ThisObject.EndDate Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_006, ThisObject.BeginDate, ThisObject.EndDate);
		CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.BeginDate", "Object");
	EndIf;
	
	If Cancel = True Then
		Return;
	EndIf;
	
	For Each Row In ThisObject.BusinessUnits Do
		ArrayOfErrors = CheckDates(ThisObject.Ref, Row.BusinessUnit, ThisObject.BeginDate, ThisObject.EndDate);
		For Each ItemOfErrors In ArrayOfErrors Do
			Cancel = True;
			If ItemOfErrors.BeginDate Then
				MessageText = StrTemplate(R().MF_Error_007, ThisObject.BeginDate, ItemOfErrors.Period);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.BeginDate", "Object");
			EndIf;
			
			If ItemOfErrors.EndDate Then
				MessageText = StrTemplate(R().MF_Error_008, ThisObject.EndDate, ItemOfErrors.Period);
				CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.EndDate", "Object");
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Function CheckDates(Ref, BusinessUnit, BeginDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PlanningPeriods.Ref AS Ref,
	|	CASE
	|		WHEN &BeginDate BETWEEN PlanningPeriods.BeginDate AND PlanningPeriods.EndDate
	|		OR PlanningPeriods.BeginDate BETWEEN &BeginDate AND &EndDate
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS BeginDate,
	|	CASE
	|		WHEN &EndDate BETWEEN PlanningPeriods.BeginDate AND PlanningPeriods.EndDate
	|		OR PlanningPeriods.EndDate BETWEEN &BeginDate AND &EndDate
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS EndDate
	|FROM
	|	Catalog.PlanningPeriods.BusinessUnits AS PlanningPeriodsBusinessUnits
	|		INNER JOIN Catalog.PlanningPeriods AS PlanningPeriods
	|		ON PlanningPeriodsBusinessUnits.Ref = PlanningPeriods.Ref
	|		AND PlanningPeriodsBusinessUnits.BusinessUnit = &BusinessUnit
	|		AND PlanningPeriodsBusinessUnits.Ref <> &Ref
	|		AND PlanningPeriods.Ref <> &Ref
	|		AND (&BeginDate BETWEEN PlanningPeriods.BeginDate AND PlanningPeriods.EndDate
	|		OR &EndDate BETWEEN PlanningPeriods.BeginDate AND PlanningPeriods.EndDate
	|		OR (PlanningPeriods.BeginDate BETWEEN &BeginDate AND &EndDate
	|		OR PlanningPeriods.EndDate BETWEEN &BeginDate AND &EndDate))";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("BusinessUnit" , BusinessUnit);
	Query.SetParameter("BeginDate"    , BeginDate);
	Query.SetParameter("EndDate"      , EndDate);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ArrayOfErrors = New Array();
	While QuerySelection.Next() Do
		PeriodError = New Structure();
		PeriodError.Insert("BeginDate" , QuerySelection.BeginDate);
		PeriodError.Insert("EndDate"   , QuerySelection.EndDate);
		PeriodError.Insert("Period"    , QuerySelection.Ref);
		ArrayOfErrors.Add(PeriodError);
	EndDo;
	Return ArrayOfErrors;
EndFunction
