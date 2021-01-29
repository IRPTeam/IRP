
#Region FormEventHandlers
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPlannedReceiptReservationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPlannedReceiptReservationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocPlannedReceiptReservationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocPlannedReceiptReservationClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocPlannedReceiptReservationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocPlannedReceiptReservationClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocPlannedReceiptReservationClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure StoreOnChange(Item)
	DocPlannedReceiptReservationClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	DocPlannedReceiptReservationClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers
#Region ItemList

&AtClient
Procedure ItemListOnChange(Item) Export
	DocPlannedReceiptReservationClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

#Region Item
&AtClient
Procedure ItemListItemOnChange(Item)
	DocPlannedReceiptReservationClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPlannedReceiptReservationClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPlannedReceiptReservationClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure
#EndRegion

#Region ItemKey
&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocPlannedReceiptReservationClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure
#EndRegion

#Region Unit
&AtClient
Procedure ItemListUnitOnChange(Item)
	DocPlannedReceiptReservationClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Quantity
&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocPlannedReceiptReservationClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure
#EndRegion

#EndRegion
#EndRegion

#Region FormCommandsEventHandlers
&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure
#EndRegion

#Region Public

#EndRegion

#Region Private

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocPlannedReceiptReservationClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocPlannedReceiptReservationClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocPlannedReceiptReservationClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocPlannedReceiptReservationClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocPlannedReceiptReservationClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#EndRegion
