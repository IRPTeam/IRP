Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.PurchaseTurnovers");	
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));	
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, PurchaseInvoice, Currency, ItemKey";
EndFunction
