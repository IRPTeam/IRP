Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.CashInTransit");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("FromAccount", "FromAccount");
	Fields.Insert("ToAccount", "ToAccount");
	Fields.Insert("Currency", "Currency");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction