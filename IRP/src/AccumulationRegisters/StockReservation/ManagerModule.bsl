
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.StockReservation");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));	
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Store, ItemKey";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.StockReservation", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export
	
	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_StockReservation") Then
		Return True;
	EndIf;
	
	Tables = New Structure();
	Tables.Insert("ItemList_InDocument" , ItemList_InDocument);
	Tables.Insert("Records_InDocument"  , Records_InDocument);
	Tables.Insert("Records_Exists"      , Records_Exists);
	
	Return PostingServer.CheckBalance_StockReservation(Ref, Tables, RecordType, Unposting, AddInfo);
EndFunction
