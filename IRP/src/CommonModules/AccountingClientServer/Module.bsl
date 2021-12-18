
Function GetParameters(Object, CurrentData) Export
	Parameters = New Structure();
	ObjectData = New Structure("Ref, Date, Company");
	FillPropertyValues(ObjectData, Object);
	Parameters.Insert("ArrayOfLadgerTypes", AccountingServer.GetLadgerTypesByCompany(ObjectData));
	Parameters.Insert("Key", CurrentData.Key);
	Parameters.Insert("AccountingAnalytics", GetAccountingAnalytics(Object, CurrentData));
	Return Parameters;
EndFunction

Function GetAccountingAnalytics(Object, CurrentData)
	If TypeOf(Object.Ref) = Type("DocumentRef.BankPayment") Then
		RowData = New Structure("Key, Partner, Agreement, BasisDocument");
		FillPropertyValues(RowData, CurrentData);
		ObjectData = New Structure("Ref, Date, Company, Account");
		FillPropertyValues(ObjectData, Object);
		Return AccountingServer.GetAccountingAnalytics_BankPayment(ObjectData, RowData);
	EndIf;
EndFunction