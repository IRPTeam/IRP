
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		If ValueIsFilled(Record.Account) And Record.Account.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.Account.Code), "Account", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountDepreciation) And Record.AccountDepreciation.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountDepreciation.Code), "AccountDepreciation", ThisObject);
		EndIf;		
	EndDo;
EndProcedure
