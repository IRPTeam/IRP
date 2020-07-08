Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.GoodsReceiptSchedule");
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Order", "Order");
	Fields.Insert("Store", "Store");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction