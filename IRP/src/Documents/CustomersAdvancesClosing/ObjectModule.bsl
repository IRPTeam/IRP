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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	ArrayOfErrors = PeriodClosingServer.GetOverlappingPeriods(ThisObject.Company, 
		ThisObject.BeginOfPeriod, 
		ThisObject.EndOfPeriod, 
		"CustomersAdvancesClosing", "BeginOfPeriod", "EndOfPeriod", ThisObject.Ref);
	For Each Error In ArrayOfErrors Do
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(Error.Msg, "BeginOfPeriod", ThisObject);
	EndDo;	
EndProcedure
