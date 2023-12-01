
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		Cancel = True;
		If ValueIsFilled(Record.AccountAdvancesVendor) And Record.AccountAdvancesVendor.NotUsedForRecords Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountAdvancesVendor.Code), "Account", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountTransactionsVendor) And Record.AccountTransactionsVendor.NotUsedForRecords Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountTransactionsVendor.Code), "Account", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountAdvancesCustomer) And Record.AccountAdvancesCustomer.NotUsedForRecords Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountAdvancesCustomer.Code), "Account", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountTransactionsCustomer) And Record.AccountTransactionsCustomer.NotUsedForRecords Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountTransactionsCustomer.Code), "Account", ThisObject);
		EndIf;
	EndDo;
EndProcedure
