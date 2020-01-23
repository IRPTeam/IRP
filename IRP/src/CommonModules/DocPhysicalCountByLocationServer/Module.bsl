Function GetItemKeysArray(ItemKey) Export
	ItemKeyArray = New Array;
	TableOfItemKeys = Catalogs.ItemKeys.GetTableBySpecification(ItemKey);
	For Each TableOfItemKeysRow In TableOfItemKeys Do
		NewRowItemKey = New Structure;
		NewRowItemKey.Insert("ItemKey", TableOfItemKeysRow.ItemKey);
		NewRowItemKey.Insert("Item", TableOfItemKeysRow.ItemKey.Item);
		NewRowItemKey.Insert("ExpectedQuantity", TableOfItemKeysRow.Quantity);
		ItemKeyArray.Add(NewRowItemKey);
	EndDo;
	Return ItemKeyArray;
EndFunction