#Region Service
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R1021B_VendorsTransactions");
	LockInfo = New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames()));
	Result.Insert("LockInfo", LockInfo);
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Partner, LegalName, Currency";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.R1021B_VendorsTransactions",
		RecordType, AddInfo);
EndFunction
#EndRegion