

#Region Service
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R5011B_PartnersAging");
	LockInfo = New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames()));
	Result.Insert("LockInfo", LockInfo);	
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Partner, Agreement, Invoice, Currency";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.R5011B_PartnersAging", RecordType, AddInfo);
EndFunction
#EndRegion
