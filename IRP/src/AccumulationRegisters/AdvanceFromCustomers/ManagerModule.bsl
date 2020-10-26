
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.AdvanceFromCustomers");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Partner, LegalName, Currency";
EndFunction

Function GetTableAdvanceFromCustomers_OffsetOfAdvance(RegisterRecords, PointInTime, QueryTable) Export
	RegisterRecords.AdvanceFromCustomers.Clear();
	RegisterRecords.AdvanceFromCustomers.Write();
	Return PostingServer.GetTable_OffsetOfAdvance_OnTransaction(PointInTime, QueryTable, "ReceiptDocument");
EndFunction