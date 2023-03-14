#Region EventHandlers

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not StrOccurrenceCount(AddInID, ".") Then
		CommonFunctionsClientServer.ShowUsersMessage(R().EqError_003, "AddInID", ThisObject);
		If Not Cancel Then
			Cancel = True;
		EndIf;
	EndIf;
EndProcedure

#EndRegion