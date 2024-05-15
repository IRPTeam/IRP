
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Record In ThisObject Do
		If ValueIsFilled(Record.AccountExpense) And Record.AccountExpense.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountExpense.Code), "AccountExpense", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountOtherPeriodsExpense) And Record.AccountOtherPeriodsExpense.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountOtherPeriodsExpense.Code), "AccountOtherPeriodsExpense", ThisObject);
		EndIf;
		
		If ValueIsFilled(Record.AccountRevenue) And Record.AccountRevenue.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountRevenue.Code), "AccountRevenue", ThisObject);
		EndIf;		
		
		If ValueIsFilled(Record.AccountOtherPeriodsRevenue) And Record.AccountOtherPeriodsRevenue.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountOtherPeriodsRevenue.Code), "AccountOtherPeriodsRevenue", ThisObject);
		EndIf;		
	EndDo;
EndProcedure
