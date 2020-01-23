Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("Amount");
EndProcedure