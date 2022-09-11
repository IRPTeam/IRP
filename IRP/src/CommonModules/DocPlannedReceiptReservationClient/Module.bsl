﻿
#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters);
EndProcedure

#EndRegion

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo);	
EndProcedure

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("OurCompany", True);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

Procedure StoreOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure DateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#Region FormTableItemsEventHandlers
#Region ItemList

Procedure ItemListOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
	DocumentsClient.FillRowIDInItemList(Object);
	RowIDInfoClient.UpdateQuantity(Object, Form);
EndProcedure

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo = Undefined) Export
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Clone Then
		CurrentData.Key = New UUID();
	EndIf;
	RowIDInfoClient.ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
EndProcedure

#Region Item

Procedure ItemListItemOnChange(Object, Form, Item = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);
	If ValueIsFilled(CurrentRow.ItemKey) And ServiceSystemServer.GetObjectAttribute(CurrentRow.ItemKey, "Item")
		<> CurrentRow.Item Then
		CurrentRow.ItemKey = Undefined;
	EndIf;

	// #depreacted
//	CalculationSettings = New Structure();
//	CalculationSettings.Insert("UpdateUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentRow, CalculationSettings);

	UnitInfo = GetItemInfo.ItemUnitInfo(CurrentRow.ItemKey);
	CurrentRow.Unit = UnitInfo.Unit;
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ItemKey
Procedure ItemListItemKeyOnChange(Object, Form, Item) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	UnitInfo = GetItemInfo.ItemUnitInfo(CurrentRow.ItemKey);
	CurrentRow.Unit = UnitInfo.Unit;
EndProcedure
#EndRegion

#Region Quantity
Procedure ItemListQuantityOnChange(Object, Form, Item) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	CurrentRow.QuantityInBaseUnit = ModelServer_V2.ConvertQuantityToQuantityInBaseUnit(CurrentRow.ItemKey, CurrentRow.Unit, CurrentRow.Quantity);
EndProcedure
#EndRegion

#Region Unit

Procedure ItemListUnitOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;

	CurrentRow.QuantityInBaseUnit = ModelServer_V2.ConvertQuantityToQuantityInBaseUnit(CurrentRow.ItemKey, CurrentRow.Unit, CurrentRow.Quantity);
EndProcedure

#EndRegion

#EndRegion
#EndRegion