
#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ItemList");
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
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ItemList");
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

#Region ITEM_KEY

Procedure ItemListItemKeyOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure ItemListUnitOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
