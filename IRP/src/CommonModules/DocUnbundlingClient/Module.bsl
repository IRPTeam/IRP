
#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");	
//	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

#EndRegion


#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
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

#Region STORE

Procedure StoreOnChange(Object, Form, Item) Export
	ViewClient_V2.StoreObjectAttrOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure QuantityOnChange(Object, Form, Item) Export
	ViewClient_V2.QuantityOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
//	Object.QuantityInBaseUnit = DocUnbundlingServer.CalculateQuantityInBaseUnit(Object.ItemKeyBundle, Object.Unit,
//		Object.Quantity);
EndProcedure

#EndRegion

#Region UNIT

Procedure UnitOnChange(Object, Form, Item) Export
	ViewClient_V2.UnitOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
//	Object.QuantityInBaseUnit = DocUnbundlingServer.CalculateQuantityInBaseUnit(Object.ItemKeyBundle, Object.Unit,
//		Object.Quantity);
EndProcedure

#EndRegion

#Region ITEM_BUNDLE

Procedure ItemBundleOnChange(Object, Form, Item) Export
	ViewClient_V2.ItemBundleOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure ItemBundleStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemBundleEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY_BUNDLE

Procedure ItemKeyBundleOnChange(Object, Form, Item) Export
	ViewClient_V2.ItemKeyBundleOnChange(Object, Form, "ItemList");
//	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ItemListAfterDeleteRow(Object, Form);
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

Procedure ItemListItemOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemOnChange(Object, Form, CurrentData);
	
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	CurrentData.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentData.Item);
//	If ValueIsFilled(CurrentData.ItemKey) 
//		And ServiceSystemServer.GetObjectAttribute(CurrentData.ItemKey, "Item")	<> CurrentData.Item Then
//		CurrentData.ItemKey = Undefined;
//	EndIf;
//
//	CalculationSettings = New Structure();
//	CalculationSettings.Insert("UpdateUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, CalculationSettings);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

//Procedure ItemListOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
//	DocumentsClient.FillRowIDInItemList(Object);
//EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form, CurrentData);
	
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	Actions = New Structure("CalculateQuantityInBaseUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#Region UNIT

Procedure ItemListUnitOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form, CurrentData);

//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	Actions = New Structure("CalculateQuantityInBaseUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
