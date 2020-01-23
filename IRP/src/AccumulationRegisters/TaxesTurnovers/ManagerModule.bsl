
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.TaxesTurnovers");
	Fields = New Map();
	Fields.Insert("Document", "Document");
	Fields.Insert("Tax", "Tax");
	Fields.Insert("Analytics", "Analytics");
	Fields.Insert("TaxRate", "TaxRate");
	Fields.Insert("IncludeToTotalAmount", "IncludeToTotalAmount");
	Fields.Insert("RowKey", "RowKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction