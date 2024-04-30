Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	ViewClient_V2.OnOpen(Object, Form, );
EndProcedure

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, );
EndProcedure

#EndRegion

#Region Item

Procedure PriceKeyListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType", Object.ItemType,
		DataCompositionComparisonType.Equal));

	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PriceKeyListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType", Object.ItemType, ComparisonType.Equal));

	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure ItemKeyListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	ItemStartChoice(Object, Form, "InputTypeItemKeyList", Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ItemKeyListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ItemEditTextChange(Object, Form, "InputTypeItemKeyList", Item, Text, StandardProcessing);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	ItemStartChoice(Object, Form, "InputTypeItemList", Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ItemEditTextChange(Object, Form, "InputTypeItemList", Item, Text, StandardProcessing);
EndProcedure

Procedure ItemStartChoice(Object, Form, InputTypeName, Item, ChoiceData, StandardProcessing)
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemEditTextChange(Object, Form, InputTypeName, Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));

	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion