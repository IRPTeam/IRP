
Function CheckUnitForItem(ItemObject) Export 
	Return GetItemInfo.CheckUnitForItem(ItemObject);
EndFunction

Function CheckUnitForItemKey(ItemObject) Export
	Return GetItemInfo.CheckUnitForItemKey(ItemObject);
EndFunction

Procedure CheckUniqueDescriptions(Cancel, Object) Export
	CommonFunctionsServer.__CheckUniqueDescriptions(Cancel, Object);
EndProcedure