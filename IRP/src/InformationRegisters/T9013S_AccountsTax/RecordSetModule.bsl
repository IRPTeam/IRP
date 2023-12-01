
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		Cancel = True;
		If ValueIsFilled(Record.Account) And Record.Account.NotUsedForRecords Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.Account.Code), "Account", ThisObject);
		EndIf;
	EndDo;
EndProcedure
