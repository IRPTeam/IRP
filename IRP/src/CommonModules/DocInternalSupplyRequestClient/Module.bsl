
#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters, AddInfo);
EndProcedure

#EndRegion

#Region COMAPNY

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

#Region ITEM_LIST

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo);
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

#Region ITEM_LIST_COLUMNS

#Region _ITEM

Procedure ItemListItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
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

Procedure ItemListItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure ItemListUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region SERVICE

#Region DESCRIPTION

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form);
EndProcedure

Procedure OpenPickupItems(Object, Form, Command) Export
	DocumentsClient.OpenPickupItems(Object, Form, Command);
EndProcedure

#EndRegion
