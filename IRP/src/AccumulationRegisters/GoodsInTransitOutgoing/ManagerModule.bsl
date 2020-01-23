
Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.GoodsInTransitOutgoing");
	Fields = New Map();
	Fields.Insert("Store", "Store");
	Fields.Insert("ShipmentBasis", "ShipmentBasis");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction