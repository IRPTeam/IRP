#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocBundlingServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocBundlingServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocBundlingServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocBundlingClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

#Region ItemList

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocBundlingClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocBundlingClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocBundlingClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocBundlingClient.ItemListItemOnChange(Object, ThisObject, Item);
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

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocBundlingClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocBundlingClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocBundlingClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemItemBundle

&AtClient
Procedure ItemBundleOnChange(Item)
	DocBundlingClient.ItemBundleOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemBundleStartChoice(Item, ChoiceData, StandardProcessing)
	DocBundlingClient.ItemBundleStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemBundleEditTextChange(Item, Text, StandardProcessing)
	DocBundlingClient.ItemBundleEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocBundlingClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocBundlingClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocBundlingClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocBundlingClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocBundlingClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure SearchByBarcode(Command)
	DocBundlingClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocBundlingClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure QuantityOnChange(Item)
	DocBundlingClient.QuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure UnitOnChange(Item)
	DocBundlingClient.UnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	DocBundlingClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocBundlingClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion
