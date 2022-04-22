#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocItemStockAdjustmentServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocItemStockAdjustmentServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocItemStockAdjustmentServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocItemStockAdjustmentClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Parameter);
	EndIf;
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocItemStockAdjustmentClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocItemStockAdjustmentClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocItemStockAdjustmentClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region STORE

&AtClient
Procedure StoreOnChange(Item)
	DocItemStockAdjustmentClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocItemStockAdjustmentClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ITEM_LIST

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocItemStockAdjustmentClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocItemStockAdjustmentClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure


#Region ITEM_LIST_COLUMNS

#Region _ITEM

&AtClient
Procedure ItemListItemOnChange(Item)
	DocItemStockAdjustmentClient.ItemListItemOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocItemStockAdjustmentClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocItemStockAdjustmentClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _ITEM_KEY

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocItemStockAdjustmentClient.ItemListItemKeyOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region UNIT

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocItemStockAdjustmentClient.ItemListUnitOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocItemStockAdjustmentClient.ItemListQuantityOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocItemStockAdjustmentClient);
	Str.Insert("Server", DocItemStockAdjustmentServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

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

#Region COMMANDS

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenScanForm(Command)
	DocumentsClient.OpenScanForm(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
