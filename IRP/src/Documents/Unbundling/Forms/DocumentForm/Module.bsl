#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetEnableWaysToFillItemListByBundle();
	DocUnbundlingServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
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
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocUnbundlingServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetEnableWaysToFillItemListByBundle();
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetEnableWaysToFillItemListByBundle();
	DocUnbundlingServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocUnbundlingClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocUnbundlingClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

#EndRegion

&AtClient
Procedure FillItemListBySpecification(Command)
	FillItemListBySpecificationAtServer();
EndProcedure

&AtServer
Procedure FillItemListBySpecificationAtServer()
	Object.ItemList.Clear();
	TableOfItemKeys = Catalogs.ItemKeys.GetTableBySpecification(Object.ItemKeyBundle);
	For Each Row In TableOfItemKeys Do
		NewRow = Object.ItemList.Add();
		NewRow.Key = New UUID();
		FillPropertyValues(NewRow, Row);
	EndDo;
	DocumentsServer.FillItemList(Object, ThisObject);
EndProcedure

&AtClient
Procedure FillItemListByBundleContent(Command)
	FillItemListByBundleContentAtServer();
EndProcedure

&AtServer
Procedure FillItemListByBundleContentAtServer()
	Object.ItemList.Clear();
	TableOfItemKeys = Catalogs.ItemKeys.GetTableByBundleContent(Object.ItemKeyBundle);
	For Each Row In TableOfItemKeys Do
		NewRow = Object.ItemList.Add();
		NewRow.Key = New UUID();
		FillPropertyValues(NewRow, Row);
	EndDo;
	DocumentsServer.FillItemList(Object, ThisObject);
EndProcedure

#Region ItemList

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocUnbundlingClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocUnbundlingClient.ItemListItemOnChange(Object, ThisObject, Item);
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
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocBundlingClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocBundlingClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocUnbundlingClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocUnbundlingClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocUnbundlingClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure ItemKeyBundleOnChange(Item)
	DocUnbundlingClient.ItemKeyBundleOnChange(Object, ThisObject, Item);
	SetEnableWaysToFillItemListByBundle();
EndProcedure

&AtServer
Procedure SetEnableWaysToFillItemListByBundle()
	WaysToFilling = Catalogs.ItemKeys.GetWaysToFillItemListByBundle(Object.ItemKeyBundle);
	
	Items.FillItemListBySpecification.Enabled = WaysToFilling.BySpecification;
	Items.FillItemListByBundling.Enabled = WaysToFilling.ByBundling;
EndProcedure

#Region ItemItemBundle

&AtClient
Procedure ItemBundleOnChange(Item)
	DocUnbundlingClient.ItemBundleOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemBundleStartChoice(Item, ChoiceData, StandardProcessing)
	DocUnbundlingClient.ItemBundleStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemBundleEditTextChange(Item, Text, StandardProcessing)
	DocUnbundlingClient.ItemBundleEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure StoreOnChange(Item)
	DocUnbundlingClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure QuantityOnChange(Item)
	DocUnbundlingClient.QuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure UnitOnChange(Item)
	DocUnbundlingClient.UnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocUnbundlingClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocUnbundlingClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	DocUnbundlingClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocUnbundlingClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocUnbundlingClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocUnbundlingClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocUnbundlingClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocUnbundlingClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocUnbundlingClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
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
