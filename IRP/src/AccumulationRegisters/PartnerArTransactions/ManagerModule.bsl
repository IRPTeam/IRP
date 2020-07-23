Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.PartnerArTransactions");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction