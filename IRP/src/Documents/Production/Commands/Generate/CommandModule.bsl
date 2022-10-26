
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	OpeningParameters = GetChoiceProductionParameters(CommandParameter);
	Notify = New NotifyDescription("ChoiceProductionContinue", ThisObject);
	OpenForm("Document.Production.Form.ChoiceProductionForm"
	,OpeningParameters, CommandExecuteParameters.Source, New UUID()
	,,,Notify,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ChoiceProductionContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	FillingData = ManufacturingServer.GetProductionFillingData(Result);
	OpenForm("Document.Production.ObjectForm", 
	New Structure("FillingValues", FillingData), , New UUID());
EndProcedure

&AtServer
Function GetChoiceProductionParameters(ProductionPlanningRef)
	Parameters = New Structure();
	Parameters.Insert("Company"              , ProductionPlanningRef.Company);
	Parameters.Insert("PlanningPeriod"       , ProductionPlanningRef.PlanningPeriod);
	Parameters.Insert("ProductionPlanning"   , ProductionPlanningRef);
	Parameters.Insert("ArrayOfBusinessUnits" , New Array());
	For Each Row In ProductionPlanningRef.BillOfMaterialsList Do
		If Parameters.ArrayOfBusinessUnits.Find(Row.BusinessUnit) = Undefined Then
			Parameters.ArrayOfBusinessUnits.Add(Row.BusinessUnit);
		EndIf;
	EndDo;
	Return Parameters;
EndFunction
