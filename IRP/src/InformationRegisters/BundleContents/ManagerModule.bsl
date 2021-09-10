Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "InformationRegister.BundleContents");
	Fields = New Map();
	Fields.Insert("ItemKeyBundle", "ItemKeyBundle");
	Fields.Insert("ItemKey", "ItemKey");
	Result.Insert("LockInfo", New Structure("Data, Fields", Data, Fields));
	Return Result;
EndFunction