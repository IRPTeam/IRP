
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
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
		ThisObject.ProductionPlanningExists = QuerySelection.Ref;
	EndIf;
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure TypeOnChange(Item)
	If Object.Type = PredefinedValue("Enum.PlanningPeriodTypes.Financial") Then
		Object.BusinessUnits.Clear();
	EndIf;	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	IsFilled_ProductionPlanningExists = ValueIsFilled(Form.ProductionPlanningExists);
	
	Form.ReadOnly = IsFilled_ProductionPlanningExists;
	Form.Items.ProductionPlanningExists.Visible = IsFilled_ProductionPlanningExists;
	Form.Items.BusinessUnits.Visible = Object.Type = PredefinedValue("Enum.PlanningPeriodTypes.Manufacturing");
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

