
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName"	, "AccumulationRegister.RetailCash");
	Fields = New Map();
	Fields.Insert("Company"			, "Company");
	Fields.Insert("PaymentType"		, "PaymentType");
	Fields.Insert("Account"			, "Account");
	Fields.Insert("PaymentTerminal"	, "PaymentTerminal");
	Result.Insert("LockInfo"		, New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction