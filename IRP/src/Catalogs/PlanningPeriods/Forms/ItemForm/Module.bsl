
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		If Parameters.Property("FillingValues") And
			Parameters.FillingValues.Property("BusinessUnit")And
			ValueIsFilled(Parameters.FillingValues.BusinessUnit) Then
			Object.BusinessUnits.Add().BusinessUnit = Parameters.FillingValues.BusinessUnit;
			Items.ProductionPlanningExists.Visible = False;
		EndIf;
	EndIf;

	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("PlanningPeriodWrite");
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	ProductionPlanning.Ref
	|FROM
	|	Document.ProductionPlanning AS ProductionPlanning
	|WHERE
	|	ProductionPlanning.PlanningPeriod = &PlanningPeriod
	|	AND ProductionPlanning.Ref.Posted
	|ORDER BY
	|	ProductionPlanning.Ref.Date";
	Query.SetParameter("PlanningPeriod" , Object.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		ThisObject.ReadOnly = True;
		ThisObject.ProductionPlanningExists = QuerySelection.Ref;
		Items.ProductionPlanningExists.Visible =  True;
	Else
		Items.ProductionPlanningExists.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure BusinessUnitsSelection(Item, RowSelected, Field, StandardProcessing)
		If Not ThisObject.ReadOnly Then
		Return;
	EndIf;
	CurrentData = Items.BusinessUnits.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CommonFormActions.OpenObjectForm(Field, "BusinessUnitsBusinessUnit", CurrentData.BusinessUnit, StandardProcessing);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion


