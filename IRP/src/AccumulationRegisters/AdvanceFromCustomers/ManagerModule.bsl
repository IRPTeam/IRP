Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.AdvanceFromCustomers");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction

Function GetTableExpenceAdvance(RegisterRecords, PointInTime, QueryTable) Export
	RegisterRecords.AdvanceFromCustomers.Clear();
	RegisterRecords.AdvanceFromCustomers.Write();
	Return PostingServer.GetTableExpenceAdvance(PointInTime, QueryTable, "ReceiptDocument");
EndFunction