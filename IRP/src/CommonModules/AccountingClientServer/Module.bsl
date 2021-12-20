
Function GetParameters(Object, CurrentData, AccountingAnalyticsType) Export
	Parameters = New Structure();
	ObjectData = New Structure("Ref, Date, Company");
	FillPropertyValues(ObjectData, Object);
	Parameters.Insert("RowKey", CurrentData.Key);
	Parameters.Insert("DocumentRef", Object.Ref);
	Parameters.Insert("AccountingAnalyticsType", AccountingAnalyticsType);
	
	ArrayOfLadgerTypes = AccountingServer.GetLadgerTypesByCompany(ObjectData);
	Parameters.Insert("ArrayOfLadgerTypes", ArrayOfLadgerTypes);
	
	AccountingAnalytics = New Array();
	For Each LadgerType In ArrayOfLadgerTypes Do
		ArrayOfPartAnalytics = GetAccountingAnalytics(Object, CurrentData, LadgerType);
		For Each PartAnalytic In ArrayOfPartAnalytics Do
			AccountingAnalytics.Add(PartAnalytic);
		EndDo;
	EndDo;
	Parameters.Insert("AccountingAnalytics", AccountingAnalytics);
	
	Return Parameters;
EndFunction

Function GetAccountingAnalytics(Object, CurrentData, LadgerType)
	If TypeOf(Object.Ref) = Type("DocumentRef.BankPayment") Then
		RowData = New Structure("Key, Partner, Agreement, BasisDocument");
		FillPropertyValues(RowData, CurrentData);
		ObjectData = New Structure("Ref, Date, Company, Account");
		FillPropertyValues(ObjectData, Object);
		Return AccountingServer.GetAccountingAnalytics_BankPayment(ObjectData, RowData, LadgerType);
	EndIf;
EndFunction

Procedure DeleteUnusedRowsFromAnalyticsTable(Analytics, MainTable) Export
	ArrayForDelete = New Array();
	For Each Row In Analytics Do
		If Not MainTable.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Analytics.Delete(ItemForDelete);
	EndDo;
EndProcedure
