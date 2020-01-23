
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.SalesTurnovers");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("SalesInvoice", "SalesInvoice");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction