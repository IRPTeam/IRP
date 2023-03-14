#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export

	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);

	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);

EndProcedure

#EndRegion

#Region ItemItemList

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion