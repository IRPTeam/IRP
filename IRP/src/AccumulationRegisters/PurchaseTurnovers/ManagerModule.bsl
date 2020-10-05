Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.PurchaseTurnovers");	
	
	Fields = New Map();
	ArrayOfFieldNames = StrSplit(GetLockFieldNames(), ",");
	For Each ItemFieldName In ArrayOfFieldNames Do
		Fields.Insert(TrimAll(ItemFieldName), TrimAll(ItemFieldName));
	EndDo;
	
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, PurchaseInvoice, Currency, ItemKey";
EndFunction
