
#Region FormEvents

&AtClient
Procedure OnOpen(Cancel)
	ChangeListsVisible();
EndProcedure

#EndRegion


#Region Commands

&AtClient
Procedure SearchByBarcode(Command)
	DocumentsClient.SearchByBarcode(Command, Object, ThisObject, DocumentsClient);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocSalesOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SwitchList(Command)
	ChangeListsVisible();
EndProcedure

#EndRegion

&AtClient
Procedure ChangeListsVisible()
	ItemListVisible = Items.GroupItemList.Visible;
	Items.GroupItemList.Visible = Not ItemListVisible;
	Items.GroupExpItemList.Visible = ItemListVisible;
	Items.GroupPhysItemList.Visible = ItemListVisible;
EndProcedure


#Region ItemListEvents

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	//TODO: Insert the handler content
EndProcedure

#EndRegion