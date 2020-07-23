Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.CashAdvance");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("Currency", "Currency");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction