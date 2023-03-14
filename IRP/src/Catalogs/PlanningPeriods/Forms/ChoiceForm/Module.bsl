
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("Filter") And Parameters.Filter.Property("BusinessUnit") Then
		ThisObject.FilterBusinessUnit = Parameters.Filter.BusinessUnit;
		UpdateFilters();
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If Clone Or Not ValueIsFilled(ThisObject.FilterBusinessUnit) Then
		Return;
	EndIf;
	Cancel = True;
	OpeningParameters = New Structure();
	OpeningParameters.Insert("FillingValues", New Structure());
	OpeningParameters.FillingValues.Insert("BusinessUnit", ThisObject.FilterBusinessUnit);
	OpenForm("Catalog.PlanningPeriods.ObjectForm", OpeningParameters, ThisObject, ThisObject.UUID);	
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "PlanningPeriodWrite" Then
		UpdateFilters();
	EndIf;
EndProcedure

&AtServer
Procedure UpdateFilters()
	If Not ValueIsFilled(ThisObject.FilterBusinessUnit) Then
		Return;
	EndIf;
	Query = New Query;
	Query.Text =
	"SELECT
	|	Table.Ref AS Ref
	|FROM
	|	Catalog.PlanningPeriods.BusinessUnits AS TableBusinessUnits
	|		INNER JOIN Catalog.PlanningPeriods AS Table
	|		ON Table.Ref = TableBusinessUnits.Ref
	|		AND NOT Table.DeletionMark
	|		AND TableBusinessUnits.BusinessUnit = &BusinessUnit
	|GROUP BY
	|	Table.Ref";
	Query.SetParameter("BusinessUnit", ThisObject.FilterBusinessUnit);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ListOfRefs = New ValueList;
	While QuerySelection.Next() Do
		ListOfRefs.Add(QuerySelection.Ref);
	EndDo;
	ArrayForDelete = New Array();
	FieldRef = New DataCompositionField("Ref");
	For Each Filter In ThisObject.List.Filter.Items Do
		If Filter.LeftValue = FieldRef Then
			ArrayForDelete.Add(Filter);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		ThisObject.List.Filter.Items.Delete(ItemForDelete);
	EndDo;
	
	FilterItem = ThisObject.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.LeftValue = New DataCompositionField("Ref");
	FilterItem.RightValue = ListOfRefs;
	FilterItem.ComparisonType = DataCompositionComparisonType.InList;	
EndProcedure
