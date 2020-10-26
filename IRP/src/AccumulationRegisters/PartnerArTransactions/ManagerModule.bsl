
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.PartnerArTransactions");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Partner, LegalName, Agreement, Currency";
EndFunction

Function GetTablePartnerArTransactions_OffsetOfAdvance(RegisterRecords, PointInTime, AdvanceFromCustomers, PartnerArTransactions) Export
	RegisterRecords.PartnerArTransactions.Clear();
	RegisterRecords.PartnerArTransactions.Write();
	Return PostingServer.GetTable_OffsetOfAdvance_OnAdvance(PointInTime, AdvanceFromCustomers, PartnerArTransactions, "ReceiptDocument");
EndFunction