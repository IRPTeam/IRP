
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		If ValueIsFilled(Record.AccountSalaryPayment) And Record.AccountSalaryPayment.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountSalaryPayment.Code), "AccountSalaryPayment", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountCashAdvance) And Record.AccountCashAdvance.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountCashAdvance.Code), "AccountCashAdvance", ThisObject);
		EndIf;		
	EndDo;
EndProcedure
