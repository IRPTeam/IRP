#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocInventoryTransferOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ThisObject.InputType = "Item";
	ChangeInputType();
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocInventoryTransferOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocInventoryTransferOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion


&AtClient
Procedure InputTypeOnChange(Item)
	ChangeInputType();
EndProcedure

&AtClient
Procedure ChangeInputType()
	If InputType = "Item" Then
		Items.ItemListItem.TypeRestriction = New TypeDescription("CatalogRef.Items");
	Else
		Items.ItemListItem.TypeRestriction = New TypeDescription("CatalogRef.Boxes");
	EndIf;
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocInventoryTransferOrderClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtServerNoContext
Function GetAttributeValueByName(Ref, AttrName) Export
	Return Ref[AttrName];
EndFunction

&AtClient
Procedure ItemListItemOnChange(Item)
	DocInventoryTransferOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
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
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure


#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocInventoryTransferOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocInventoryTransferOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocInventoryTransferOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemStatus

&AtClient
Procedure StatusOnChange(Item)
	DocInventoryTransferOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemStoreSender

&AtClient
Procedure StoreSenderOnChange(Item)
	DocInventoryTransferOrderClient.StoreSenderOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemStoreReceiver

&AtClient
Procedure StoreReceiverOnChange(Item)
	DocInventoryTransferOrderClient.StoreReceiverOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure OpenPickupItems(Command)
	DocInventoryTransferOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocInventoryTransferOrderClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocInventoryTransferOrderClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure


#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocInventoryTransferOrderClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command)
	DocInventoryTransferOrderClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

