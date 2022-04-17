#Region Service

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
