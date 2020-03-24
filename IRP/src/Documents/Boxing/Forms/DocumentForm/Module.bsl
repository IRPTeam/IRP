#Region FormEvents

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocBoxingServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	FillBoxProperties();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocBoxingServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AddAttributesTable = New ValueTable();
	AddAttributesTable.Columns.Add("Property");
	AddAttributesTable.Columns.Add("Value");
	
	If ValueIsFilled(ThisObject.SavedData)
		And WriteParameters.WriteMode = DocumentWriteMode.Posting Then
		SavedDataStructure = CommonFunctionsServer.DeserializeXMLUseXDTO(ThisObject.SavedData);
		
		For Each Row In SavedDataStructure.ArrayOfAttributesInfo Do
			NewRow = AddAttributesTable.Add();
			NewRow.Property = ThisObject[Row.Name_owner];
			NewRow.Value = ThisObject[Row.Name];
		EndDo;
		
	EndIf;
	CurrentObject.AdditionalProperties.Insert("AddAttributesTable", AddAttributesTable);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocBoxingServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocBoxingClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure



#EndRegion

#Region ItemList

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocBoxingClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocBoxingClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocBoxingClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocBoxingClient.ItemListItemOnChange(Object, ThisObject, Item);
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
	DocBoxingClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocBoxingClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocBoxingClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure DateOnChange(Item)
	DocBoxingClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocBoxingClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure


&AtServer
Procedure FillBoxProperties()
	ItemKeyRef = Catalogs.ItemKeys.GetRefByBoxing(Object.Ref, Object.ItemBox);
	FormInfo = New Structure();
	FormInfo.Insert("Ref", ItemKeyRef);
	FormInfo.Insert("Item", Object.ItemBox);
	FormInfo.Insert("ItemType", ?(ValueIsFilled(Object.ItemBox), Object.ItemBox.ItemType, Catalogs.ItemTypes.EmptyRef()));
	FormInfo.Insert("AddAttributes", ItemKeyRef.AddAttributes);
	
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject
		, "GroupBoxProperties"
		, New Structure("FormInfo", FormInfo));
EndProcedure

&AtClient
Procedure ItemBoxOnChange(Item)
	DocBoxingClient.ItemBoxOnChange(Object, ThisObject, Item);
	FillBoxProperties();
EndProcedure

&AtClient
Procedure SearchByBarcode(Command)
	DocBoxingClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocBoxingClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocBoxingClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocBoxingClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocBoxingClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocBoxingClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion


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