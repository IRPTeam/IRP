
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.PartnerApTransactions");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Partner, LegalName, Agreement, Currency";
EndFunction

Function GetTablePartnerApTransactions_OffsetOfAdvance(RegisterRecords, PointInTime, AdvanceToSuppliers, PartnerApTransactions) Export
	RegisterRecords.PartnerApTransactions.Clear();
	RegisterRecords.PartnerApTransactions.Write();
	Return PostingServer.GetTable_OffsetOfAdvance_OnAdvance(PointInTime, AdvanceToSuppliers, PartnerApTransactions, "PaymentDocument");
EndFunction