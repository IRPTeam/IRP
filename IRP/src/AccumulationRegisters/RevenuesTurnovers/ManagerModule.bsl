
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.RevenuesTurnovers");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BusinessUnit", "BusinessUnit");
	Fields.Insert("RevenueType", "RevenueType");
	Fields.Insert("ItemKey", "ItemKey");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("AdditionalAnalytic", "AdditionalAnalytic");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction