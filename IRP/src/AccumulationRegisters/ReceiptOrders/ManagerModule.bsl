
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.ReceiptOrders");
	Fields = New Map();
	Fields.Insert("Order", "Order");
	Fields.Insert("GoodsReceipt", "GoodsReceipt");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction

	