#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPhysicalInventoryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPhysicalInventoryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPhysicalInventoryClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocPhysicalInventoryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

&AtClient
Procedure InputTypeOnChange(Item)
	DocPhysicalInventoryClient.InputTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocPhysicalInventoryClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocPhysicalInventoryClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object,
		CurrentRow,
		CalculationSettings);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocPhysicalInventoryClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPhysicalInventoryClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPhysicalInventoryClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocPhysicalInventoryClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocPhysicalInventoryClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure


#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocPhysicalInventoryClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command)
	DocPhysicalInventoryClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListPhysCountOnChange(Item)
	CurrentRow = Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CurrentRow.Difference = CurrentRow.PhysCount - CurrentRow.ExpCount;
EndProcedure

&AtClient
Procedure FillExpCount(Command)
	DocPhysicalInventoryClient.FillExpCount(Object, ThisObject);
EndProcedure

&AtClient
Procedure UpdateExpCount(Command)
	DocPhysicalInventoryClient.UpdateExpCount(Object, ThisObject);
EndProcedure




