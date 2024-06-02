
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		If ValueIsFilled(Record.IncomingAccount) And Record.IncomingAccount.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.IncomingAccount.Code), "IncomingAccount", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.IncomingAccountReturn) And Record.IncomingAccountReturn.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.IncomingAccountReturn.Code), "IncomingAccountReturn", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.OutgoingAccount) And Record.OutgoingAccount.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.OutgoingAccount.Code), "OutgoingAccount", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.OutgoingAccountReturn) And Record.OutgoingAccountReturn.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.OutgoingAccountReturn.Code), "OutgoingAccountReturn", ThisObject);
		EndIf;
	EndDo;
EndProcedure
