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
	|	ProductionPlanning.Ref
	|FROM
	|	Document.ProductionPlanning AS ProductionPlanning
	|WHERE
	|	ProductionPlanning.Company = &Company
	|	AND ProductionPlanning.BusinessUnit = &BusinessUnit
	|	AND ProductionPlanning.PlanningPeriod = &PlanningPeriod
	|	AND ProductionPlanning.Ref <> &Ref
	|	AND NOT ProductionPlanning.DeletionMark
	|	AND ProductionPlanning.Posted";
	Query.SetParameter("Company"       , ThisObject.Company);
	Query.SetParameter("BusinessUnit"  , ThisObject.BusinessUnit);
	Query.SetParameter("PlanningPeriod", ThisObject.PlanningPeriod);
	Query.SetParameter("Ref", ThisObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Cancel = True;
		MessageText = StrTemplate(R().MF_Error_003, 
		ThisObject.Company, 
		ThisObject.BusinessUnit,  
		ThisObject.PlanningPeriod);
		CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.PlanningPeriod", "Object");
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

