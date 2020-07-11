&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("Item") Then
		ItemFilter = Parameters.Item;
		UseItemFilter = True;
	EndIf;
	
	If UseItemFilter Then
		ChoiceParameterLinks = New Array;
		For Each ChoiceParameterLink In Items.ItemKey.ChoiceParameterLinks Do
			ChoiceParameterLinks.Add(ChoiceParameterLink);
		EndDo;
		ChoiceParameterLinks.Add(New ChoiceParameterLink("Filter.Item", "ItemFilter"));
		Items.ItemKey.ChoiceParameterLinks = New FixedArray(ChoiceParameterLinks);
	EndIf;
	
	ItemKeyItem = ServiceSystemServer.GetObjectAttribute(Record.ItemKey, "Item");
	
	If Not ValueIsFilled(Record.Unit) And ValueIsFilled(Record.ItemKey) Then
		Record.Unit = CatItemsServer.GetItemKeyUnit(Record.ItemKey);
	EndIf;
	
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ItemKeyItem = ServiceSystemServer.GetObjectAttribute(Record.ItemKey, "Item");
EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	ItemKeyItem = ServiceSystemServer.GetObjectAttribute(Record.ItemKey, "Item");
	Record.Unit = CatItemsServer.GetItemKeyUnit(Record.ItemKey);
EndProcedure

