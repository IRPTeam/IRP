#Region Service
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R3021B_CashInTransitIncoming");
	LockInfo = New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames()));
	Result.Insert("LockInfo", LockInfo);
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.R3021B_CashInTransitIncoming",
		RecordType, AddInfo);
EndFunction
#EndRegion