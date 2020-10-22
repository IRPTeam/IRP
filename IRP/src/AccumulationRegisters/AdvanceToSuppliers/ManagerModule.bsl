Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.AdvanceToSuppliers");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction

Function GetTableExpenceAdvance(RegisterRecords, PointInTime, QueryTable) Export
	RegisterRecords.AdvanceToSuppliers.Clear();
	RegisterRecords.AdvanceToSuppliers.Write();
	Return PostingServer.GetTable_OffsetOfAdvance_OnTransaction(PointInTime, QueryTable, "PaymentDocument");
EndFunction