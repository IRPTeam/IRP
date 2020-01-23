#Region FormEvents

Procedure OnOpen(Object, Form, Cancel) Export
	DocPhysicalCountByLocationClient.ItemListOnChange(Object, Form);
EndProcedure

#EndRegion

#Region Barcode

Procedure BarcodeOnChange(Object, Form, Item) Export
	Form.IsProcessedItemKey = True;
	Parameters = New Structure;
	Parameters.Insert("Form", Form);
	Parameters.Insert("Object", Object);
	Parameters.Insert("DocumentClientModule", ThisObject);
	BarcodeClient.InputBarcodeEnd(Object.Barcode, Parameters);
EndProcedure

Procedure SearchItemKeyByBarcode(Object, Form, Command) Export
	Form.IsProcessedItemKey = True;
	DocumentsClient.SearchByBarcode(Command, Object, Form, ThisObject);
EndProcedure

Procedure SearchByBarcode(Object, Form, Command) Export
	Form.IsProcessedItemKey = False;
	DocumentsClient.SearchByBarcode(Command, Object, Form, ThisObject);
EndProcedure

Procedure BarcodeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	Form.IsProcessedItemKey = True;
	Parameters = New Structure;
	Parameters.Insert("Form", Form);
	Parameters.Insert("Object", Object);
	Parameters.Insert("DocumentClientModule", ThisObject);
	BarcodeClient.InputBarcodeEnd(Item.EditText, Parameters);
EndProcedure

#EndRegion


#Region Items

Procedure PickupItemsEnd(FoundedItems, Parameters) Export
	Object = Parameters.Object;
	Form = Parameters.Form;
	If Parameters.Form.IsProcessedItemKey Then
		Object.ItemKey = FoundedItems[0].ItemKey;
		Object.Barcode = FoundedItems[0].Barcode;
		Form.Item = FoundedItems[0].Item;
		ChoiceItemKeyEnd(Object, Form);
	Else
		Filter = New Structure;
		Filter.Insert("ItemKey", FoundedItems[0].ItemKey);
		FoundedRows = Object.ItemList.FindRows(Filter);
		If FoundedRows.Count() Then
			NewRow = FoundedRows[0];
		Else
			NewRow = Object.ItemList.Add();
			NewRow.ItemKey = FoundedItems[0].ItemKey;
			NewRow.Item = FoundedItems[0].Item;
		EndIf;
		NewRow.Quantity = NewRow.Quantity + FoundedItems[0].Quantity;
		DocPhysicalCountByLocationClient.ItemListOnChange(Object, Form);
	EndIf;
EndProcedure

Procedure ChoiceItemKeyEnd(Object, Form) Export
	Object.ItemList.Clear();
	ItemKeyArray = DocPhysicalCountByLocationServer.GetItemKeysArray(Object.ItemKey);
	For Each TableOfItemKeysRow In ItemKeyArray Do
		NewRowItemKey = Object.ItemList.Add();
		NewRowItemKey.ItemKey = TableOfItemKeysRow.ItemKey;
		NewRowItemKey.Item = TableOfItemKeysRow.Item;
		NewRowItemKey.ExpectedQuantity = TableOfItemKeysRow.ExpectedQuantity;
		NewRowItemKey.Quantity = 0;
		NewRowItemKey.IsFromSpecification = True;
		DocPhysicalCountByLocationClient.ItemListOnChange(Object, Form);
	EndDo;
	Form.Items.GroupPages.CurrentPage = Form.Items.GroupItems;
EndProcedure

Procedure ItemOnChange(Object, Form, Item = Undefined) Export
	
	Object.ItemKey = CatItemsServer.GetItemKeyByItem(Object.Item);
	
	If ValueIsFilled(Object.ItemKey)
		And ServiceSystemServer.GetObjectAttribute(Object.ItemKey, "Item") <> Object.Item Then
		Object.ItemKey = Undefined;
	EndIf;
	
EndProcedure

Procedure ItemKeyOnChange(Object, Form, Item = Undefined) Export
	
	FoundedItems = New Array;
	FoundedItems.Add(New Structure("ItemKey", Object.ItemKey));
	Parameters = New Structure;
	Parameters.Insert("Form", Form);
	Parameters.Insert("Object", Object);
	ChoiceItemKeyEnd(FoundedItems, Parameters);
	
EndProcedure

Procedure ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure ItemListOnChange(Object, Form, Item = Undefined) Export
	
	For Each Row In Object.ItemList Do
		Row.Item = ServiceSystemServer.GetObjectAttribute(Row.ItemKey, "Item");
		Row.Title = "" + Row.Item + " " + Row.ItemKey;
		Row.Difference = Row.ExpectedQuantity - Row.Quantity;
	EndDo;
	
	If Not ValueIsFilled(Form.Item) And ValueIsFilled(Object.ItemKey) Then
		Form.Item = ServiceSystemServer.GetObjectAttribute(Object.ItemKey, "Item");
	EndIf;
	
EndProcedure

#EndRegion

