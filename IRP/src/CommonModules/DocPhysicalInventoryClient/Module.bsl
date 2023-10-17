
#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters);
EndProcedure

#EndRegion

#Region STORE

Procedure StoreOnChange(Object, Form, Item) Export
	ViewClient_V2.StoreObjectAttrOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo);	
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
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

#Region PHYS_COUNT

Procedure ItemListPhysCountOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListPhysCountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region MANUAL_COUNT

Procedure ItemListManualFixedCountOnChange(Object, Form, CurrentData = Undefined) Export
	ViewClient_V2.ItemListManualFixedCountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region COMMANDS

Procedure CreatePhysicalCount(ObjectRef) Export
	CountDocsToCreate = 0;
	AddInfo =  New Structure("ObjectRef", ObjectRef);
	AddInfo.Insert("CountDocsToCreate", CountDocsToCreate);

	NotifyDescription = New NotifyDescription("CreatePhysicalCountEnd", ThisObject, AddInfo);
	ShowInputNumber(NotifyDescription, CountDocsToCreate, R().QuestionToUser_017, 3, 0);	
EndProcedure

Procedure CreatePhysicalCountEnd(CountDocsToCreate, AdditionalParameters) Export
	If ValueIsFilled(CountDocsToCreate) Then
		AdditionalParameters.Insert("CountDocsToCreate", CountDocsToCreate);
		DocPhysicalInventoryServer.CreatePhysicalCount(AdditionalParameters.ObjectRef, AdditionalParameters);
		Notify("CreatedPhysicalCountByLocations", , AdditionalParameters.ObjectRef);
		NotifyChanged(Type("DocumentRef.PhysicalCountByLocation"));
	EndIf;
EndProcedure

#EndRegion

