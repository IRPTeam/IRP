Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.TransferOrderBalance");
	Fields = New Map();
	Fields.Insert("StoreSender", "StoreSender");
	Fields.Insert("StoreReceiver", "StoreReceiver");
	Fields.Insert("Order", "Order");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction