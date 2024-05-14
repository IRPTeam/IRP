#Region Service

Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.R4010B_ActualStocks");
	LockInfo = New Structure("Data, Fields", Data, PostingServer.GetLockFieldsMap(GetLockFieldNames()));
	Result.Insert("LockInfo", LockInfo);
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "";
EndFunction

Function GetExistsRecords(Ref, RecordType = Undefined, AddInfo = Undefined) Export
	Return PostingServer.GetExistsRecordsFromAccRegister(Ref, "AccumulationRegister.R4010B_ActualStocks", RecordType, AddInfo);
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R4010B_ActualStocks") Then
		Return True;
	EndIf;

	Tables = New Structure();
	Tables.Insert("ItemList_InDocument", ItemList_InDocument);
	Tables.Insert("Records_InDocument", Records_InDocument);
	Tables.Insert("Records_Exists", Records_Exists);

	Return PostingServer.CheckBalance_R4010B_ActualStocks(Ref, Tables, RecordType, Unposting, AddInfo);
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Store - CatalogRef.Stores -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion