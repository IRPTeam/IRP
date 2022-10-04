Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	MF_ProductionPlanning.Ref
	|FROM
	|	Document.MF_ProductionPlanning AS MF_ProductionPlanning
	|WHERE
	|	MF_ProductionPlanning.Company = &Company
	|	AND MF_ProductionPlanning.BusinessUnit = &BusinessUnit
	|	AND MF_ProductionPlanning.PlanningPeriod = &PlanningPeriod
	|	AND MF_ProductionPlanning.Ref <> &Ref
	|	AND NOT MF_ProductionPlanning.DeletionMark
	|	AND MF_ProductionPlanning.Posted";
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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	Return;
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
