
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FillingData = GetFillingData(CommandParameter);
	OpenForm("Document.ProductionPlanningClosing.ObjectForm", 
	New Structure("FillingValues", FillingData), , New UUID());
EndProcedure

&AtServer
Function GetFillingData(ProductionPlanningRef)		
	FillingData = New Structure();
	FillingData.Insert("BasedOn"           ,"ProductionPlanning");
	FillingData.Insert("ProductionPlanning", ProductionPlanningRef);
	FillingData.Insert("PlanningPeriod"    , ProductionPlanningRef.PlanningPeriod);
	FillingData.Insert("Company"           , ProductionPlanningRef.Company);
	FillingData.Insert("BusinessUnit"      , ProductionPlanningRef.BusinessUnit);
	Return FillingData;
EndFunction