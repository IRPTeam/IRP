Function GetItemKeyByItem(Item) Export
	Return Catalogs.ItemKeys.GetUniqueItemKeyByItem(Item);
EndFunction

Function GetArrayOfItemKeysByItem(Item) Export
	Return Catalogs.Items.GetArrayOfItemKeysByItem(Item);
EndFunction

Function GetItemKeyUnit(Val ItemKey) Export
	ItemKeyUnit = ItemKey.Unit;
	If Not ValueIsFilled(ItemKeyUnit) And ValueIsFilled(ItemKey.Item) Then
		Return ItemKey.Item.Unit;
	EndIf;
	Return ItemKeyUnit;
EndFunction

Function StoreMustHave(Value) Export

	If Not ValueIsFilled(Value) Then
		Return True;
	EndIf;

	If TypeOf(Value) = Type("CatalogRef.Items") Then
		Return Not Value.ItemType.Type = PredefinedValue("Enum.ItemTypes.Service");
	ElsIf TypeOf(Value) = Type("CatalogRef.ItemKeys") Then
		Return Not Value.Item.ItemType.Type = PredefinedValue("Enum.ItemTypes.Service");
	ElsIf TypeOf(Value) = Type("CatalogRef.ItemTypes") Then
		Return Not Value.Type = PredefinedValue("Enum.ItemTypes.Service");
	Else
		Return False;
	EndIf;

EndFunction