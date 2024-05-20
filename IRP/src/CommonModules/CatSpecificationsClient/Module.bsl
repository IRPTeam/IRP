#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
#If Not MobileClient And Not MobileAppClient Then
	MessageText = DocSalesOrderServer.CheckItemList(Object.Ref);
	If Not MessageText = "" Then
		Status(Object.Ref, , MessageText);
	EndIf;
#EndIf

	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters);
EndProcedure

#EndRegion

 #Region ITEM_LIST

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ItemListAfterDeleteRow(Object, Form);
EndProcedure

#EndRegion

#Region _ITEM

Procedure ItemListItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData <> Undefined Then
		FilterItemByPartnerItem = DocumentsServer.GetItemAndItemKeyByPartnerItem(CurrentData.PartnerItem);
		If ValueIsFilled(FilterItemByPartnerItem.Item) Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", FilterItemByPartnerItem.Item,
				DataCompositionComparisonType.Equal));
		EndIf;
	EndIf;

	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));

	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData <> Undefined Then
		FilterItemByPartnerItem = DocumentsServer.GetItemAndItemKeyByPartnerItem(CurrentData.PartnerItem);
		If ValueIsFilled(FilterItemByPartnerItem.Item) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", FilterItemByPartnerItem.Item,
				ComparisonType.Equal));
		EndIf;
	EndIf;

	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemListItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure ItemListUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY_IN_BASE_UNIT

Procedure ItemListQuantityInBaseUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityInBaseUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

Procedure ItemListQuantityIsFixedOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityIsFixedOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion
