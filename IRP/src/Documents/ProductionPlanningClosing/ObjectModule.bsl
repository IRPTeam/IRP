Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	ProductionPlanningClosing.Ref
	|FROM
	|	Document.ProductionPlanningClosing AS ProductionPlanningClosing
	|WHERE
	|	ProductionPlanningClosing.Company = &Company
	|	AND ProductionPlanningClosing.BusinessUnit = &BusinessUnit
	|	AND ProductionPlanningClosing.ProductionPlanning.PlanningPeriod = &PlanningPeriod
	|	AND ProductionPlanningClosing.Ref <> &Ref
	|	AND NOT ProductionPlanningClosing.DeletionMark
	|	AND ProductionPlanningClosing.Posted";
	Query.SetParameter("Company"       , ThisObject.Company);
	Query.SetParameter("BusinessUnit"  , ThisObject.BusinessUnit);
	Query.SetParameter("PlanningPeriod", ThisObject.ProductionPlanning.PlanningPeriod);
	Query.SetParameter("Ref", ThisObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_009, 
		ThisObject.Company, 
		ThisObject.BusinessUnit,  
		ThisObject.ProductionPlanning.PlanningPeriod);
		CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.ProductionPlanning", "Object");
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "ProductionPlanning" Then
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
			ThisObject.ProductionPlanning = FillingData.ProductionPlanning;
			ThisObject.Company            = FillingData.Company;
			ThisObject.BusinessUnit       = FillingData.BusinessUnit;
		EndIf;
	EndIf;
EndProcedure

