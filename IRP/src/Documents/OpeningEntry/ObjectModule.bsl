Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

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
	For Each Row In ThisObject.AccountReceivableByDocuments Do
		ArrayOfPaymentTerms = ThisObject.PaymentTerms.FindRows(New Structure("Key", Row.Key));
		AmountPaymentTerms = 0;
		For Each RowPaymentTerms In ArrayOfPaymentTerms Do
			AmountPaymentTerms = AmountPaymentTerms + RowPaymentTerms.Amount;
		EndDo;
		If AmountPaymentTerms <> 0 And Row.Amount <> AmountPaymentTerms Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
			StrTemplate(R().Error_086, Row.Amount, AmountPaymentTerms), "AccountReceivableByDocuments[" + Format(
			(Row.LineNumber - 1), "NZ=0; NG=0;") + "].Amount", ThisObject);
		EndIf;
	EndDo;
EndProcedure


