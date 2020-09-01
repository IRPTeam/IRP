
Function IsItemKeyWithSerialLotNumbers(ItemKey, AddInfo = Undefined) Export
	If Not ValueIsFilled(ItemKey) Then
		Return False;
	EndIf;
	
	Return ItemKey.Item.ItemType.UseSerialLotNumber;
EndFunction	
