
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.ShipmentOrders");
	Fields = New Map();
	Fields.Insert("Order", "Order");
	Fields.Insert("ShipmentConfirmation", "ShipmentConfirmation");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction