
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
		
		If ValueIsFilled(Record.AccountRevenue) And Record.AccountRevenue.NotUsedForRecords Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record.AccountRevenue.Code), "AccountRevenue", ThisObject);
		EndIf;		
	EndDo;
EndProcedure
