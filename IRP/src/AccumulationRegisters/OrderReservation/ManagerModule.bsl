Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.OrderReservation");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.OrderReservation", RecordType, AddInfo);
EndFunction
