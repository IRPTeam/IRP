Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
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
	Return;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		FillingData = New Structure();
		FillingData.Insert("TransactionType", Enums.DebitCreditNoteTransactionTpes.OffsetOfAdvances);
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
	ElsIf TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		// staddard filling
		Return;
	EndIf;
EndProcedure
