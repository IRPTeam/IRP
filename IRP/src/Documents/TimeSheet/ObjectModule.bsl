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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	ThisObject.BeginDate = BegOfMonth(CommonFunctionsServer.GetCurrentSessionDate());
	ThisObject.EndDate = EndOfMonth(CommonFunctionsServer.GetCurrentSessionDate());
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not ValueIsFilled(ThisObject.BeginDate) 
		Or Not ValueIsFilled(ThisObject.EndDate)
		Or ThisObject.BeginDate > ThisObject.EndDate Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Salary_Err_001, "Period");
		Cancel = True;
	EndIf; 
EndProcedure
