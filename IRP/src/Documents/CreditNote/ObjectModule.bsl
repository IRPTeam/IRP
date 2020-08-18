Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
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
	For Each Row In ThisObject.Transactions Do
		If Row.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments And Not ValueIsFilled(
			Row.BasisDocument) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_077, Row.LineNumber), "Transactions["
				+ Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].BasisDocument", ThisObject);
		EndIf;
	EndDo;
EndProcedure


