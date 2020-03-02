Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	Form.InputTypePriceKeyList = "Item";
	Form.InputTypeItemList = "Item";
	Form.InputTypeItemKeyList = "Item";
	DocPriceListClient.ChangeInputType(Object, Form);
EndProcedure

#Region ItemInputType

Procedure InputTypeOnChange(Object, Form, Item) Export
	DocPriceListClient.ChangeInputType(Object, Form);
EndProcedure

Procedure ChangeInputType(Object, Form) Export
	
	InputTypeStructure = New Structure();
	InputTypeStructure.Insert("InputTypePriceKeyList", "PriceKeyListItem");
	InputTypeStructure.Insert("InputTypeItemList", "ItemListItem");
	InputTypeStructure.Insert("InputTypeItemKeyList", "ItemKeyListItem");
	
	For Each Row In InputTypeStructure Do
		If Form[Row.Key] = "Item" Then
			Form.Items[Row.Value].TypeRestriction = New TypeDescription("CatalogRef.Items");
		Else
			Form.Items[Row.Value].TypeRestriction = New TypeDescription("CatalogRef.Boxes");
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Item

Procedure PriceKeyListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark"
			, True, DataCompositionComparisonType.NotEqual));
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType"
			, Object.ItemType, DataCompositionComparisonType.Equal));
	
	If Form.InputTypePriceKeyList = "Item" Then
		DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	Else
		DocumentsClient.BoxesStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	EndIf;
EndProcedure

Procedure PriceKeyListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType", Object.ItemType, ComparisonType.Equal));
	
	If Form.InputTypePriceKeyList = "Item" Then
		DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
	Else
		DocumentsClient.BoxesEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
	EndIf;
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
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	
	If Form[InputTypeName] = "Item" Then
		DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	Else
		DocumentsClient.BoxesStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	EndIf;
EndProcedure

Procedure ItemEditTextChange(Object, Form, InputTypeName, Item, Text, StandardProcessing)
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	If Form[InputTypeName] = "Item" Then
		DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
	Else
		DocumentsClient.BoxesEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
	EndIf;
EndProcedure

#EndRegion

