
Procedure EditTrialBallanceAccounts(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	Form.Modified = True;
	If TypeOf(Result.DocumentRef) = Type("DocumentRef.BankPayment") Then
		If Result.AccountingAnalyticsType = "AccountingRowAnalytics" Then
			For Each Row In Result.AccountingAnalytics Do
				NewRow = Form.CacheAccountingRowAnalytics.Add();
				FillPropertyValues(NewRow, Row);
			EndDo;
		EndIf;
	EndIf;
EndProcedure
