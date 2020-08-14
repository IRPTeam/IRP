Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	BasisAttributeNameForClearing = "";
	If OperationType = Enums.CreditDebitNoteOperationsTypes.Payable Then
		BasisAttributeNameForClearing = "PartnerArTransactionsBasisDocument";
	ElsIf OperationType = Enums.CreditDebitNoteOperationsTypes.Receivable Then
		BasisAttributeNameForClearing = "PartnerApTransactionsBasisDocument";
	Else
		BasisAttributeNameForClearing = "";
	EndIf;
	
	If ValueIsFilled(BasisAttributeNameForClearing) Then
		For Each Row In ThisObject.Transactions Do
			Row[BasisAttributeNameForClearing] = Undefined;
		EndDo;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
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
