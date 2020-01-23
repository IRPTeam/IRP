
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	For Each Row In ThisObject.Transactions Do
		CurrenciesServer.CalculateAmount(ThisObject, Row.Amount, Row.Key);
	EndDo;
	For Each Row In ThisObject.Advances Do
		CurrenciesServer.CalculateAmount(ThisObject, Row.Amount, Row.Key);
	EndDo;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

