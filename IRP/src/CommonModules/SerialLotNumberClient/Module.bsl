Procedure PresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	StandardProcessing = False;
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Notify = New NotifyDescription("OnFinishEditSerialLotNumbers", ThisObject, 
		New Structure("Object, Form, AddInfo", Object, Form, AddInfo));
	OpeningParameters = New Structure();
	OpeningParameters.Insert("Item", CurrentData.Item);
	OpeningParameters.Insert("ItemKey", CurrentData.ItemKey);
	OpeningParameters.Insert("RowKey", CurrentData.Key);
	OpeningParameters.Insert("SerialLotNumbers", New Array());
	OpeningParameters.Insert("Quantity", CurrentData.Quantity);
	ArrayOfSelectedSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", CurrentData.Key));
	For Each Row In ArrayOfSelectedSerialLotNumbers Do
		OpeningParameters.SerialLotNumbers.Add(New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
	EndDo;

	OpenForm("Catalog.SerialLotNumbers.Form.EditListOfSerialLotNumbers", OpeningParameters, ThisObject, , , , Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure AddNewSerialLotNumbers(Result, Parameters, AddNewLot = False, AddInfo = Undefined) Export
	If TypeOf(Result) <> Type("Structure") Then
		Return;
	EndIf;
	If Not AddNewLot Then
		ArrayOfSerialLotNumbers = Parameters.Object.SerialLotNumbers.FindRows(New Structure("Key", Result.RowKey));
		For Each Row In ArrayOfSerialLotNumbers Do
			Parameters.Object.SerialLotNumbers.Delete(Row);
		EndDo;
	EndIf;
	
	For Each Row In Result.SerialLotNumbers Do
		NewRow = Parameters.Object.SerialLotNumbers.Add();
		NewRow.Key = Result.RowKey;
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	
	TotalQuantity = 0;
	For Each Row In Parameters.Object.SerialLotNumbers Do
		If Row.Key = Result.RowKey Then
			TotalQuantity = TotalQuantity + Row.Quantity;
		EndIf;
	EndDo;
	
	UpdateSerialLotNumbersPresentation(Parameters.Object);
	UpdateSerialLotNumbersTree(Parameters.Object, Parameters.Form);
	
	If CommonFunctionsClientServer.ObjectHasProperty(Parameters.Object, "ItemList") Then
		ArrayOfItemListRows = Parameters.Object.ItemList.FindRows(New Structure("Key", Result.RowKey));
		If ArrayOfItemListRows.Count() = 1 Then
			ViewClient_V2.SetItemListQuantity(Parameters.Object, Parameters.Form, ArrayOfItemListRows[0], TotalQuantity);
		EndIf;
	EndIf;
	SourceOfOriginClient.UpdateSourceOfOriginsQuantity(Parameters.Object, Parameters.Form);
EndProcedure

Procedure OnFinishEditSerialLotNumbers(Result, Parameters) Export
	AddNewSerialLotNumbers(Result, Parameters, False, Parameters.AddInfo);
EndProcedure

Procedure PresentationClearing(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Or Not CurrentData.Property("SerialLotNumberIsFilling") Then
		Return;
	EndIf;
	CurrentData.SerialLotNumberIsFilling = False;
	DeleteUnusedSerialLotNumbers(Object, CurrentData.Key);
	UpdateSerialLotNumbersTree(Object, Form);
	SourceOfOriginClient.UpdateSourceOfOriginsQuantity(Object, Form);
EndProcedure

Procedure PresentationClearingOnCopy(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Or Not CurrentData.Property("SerialLotNumberIsFilling") Then
		Return;
	EndIf;
	CurrentData.SerialLotNumberIsFilling = False;
	CurrentData.SerialLotNumbersPresentation.Clear();
EndProcedure

Procedure UpdateSerialLotNumbersPresentation(Object) Export
	For Each RowItemList In Object.ItemList Do
		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", RowItemList.Key));
		RowItemList.SerialLotNumbersPresentation.Clear();		
		SerialCount = 0;
		For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
			RowItemList.SerialLotNumbersPresentation.Add(RowSerialLotNumber.SerialLotNumber);
			SerialCount = SerialCount + RowSerialLotNumber.Quantity;
		EndDo;
		If RowItemList.UseSerialLotNumber Then
			RowItemList.SerialLotNumberIsFilling = SerialCount > 0;
		EndIf;
	EndDo;
EndProcedure

Procedure UpdateSerialLotNumbersTree(Object, Form) Export
	Form.SerialLotNumbersTree.GetItems().Clear();
	For Each RowItemList In Object.ItemList Do
		ArrayOfSerialLotNumbers = Object.SerialLotNumbers.FindRows(New Structure("Key", RowItemList.Key));
		If ArrayOfSerialLotNumbers.Count() Then
			NewRow0 = Form.SerialLotNumbersTree.GetItems().Add();
			NewRow0.Level = 1;
			NewRow0.Key = RowItemList.Key;
			NewRow0.Item = RowItemList.Item;
			NewRow0.ItemKey = RowItemList.ItemKey;
			NewRow0.ItemKeyQuantity = RowItemList.Quantity;

			For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
				NewRow1 = NewRow0.GetItems().Add();
				NewRow1.Level = 2;
				NewRow1.Key = RowItemList.Key;
				NewRow1.SerialLotNumber = RowSerialLotNumber.SerialLotNumber;
				NewRow1.Quantity = RowSerialLotNumber.Quantity;
				NewRow0.Quantity = NewRow0.Quantity + RowSerialLotNumber.Quantity;
			EndDo;
		EndIf;
	EndDo;

	If Form.Items.SerialLotNumbersTree.Visible Then
		For Each ItemTreeRows In Form.SerialLotNumbersTree.GetItems() Do
			Form.Items.SerialLotNumbersTree.Expand(ItemTreeRows.GetID());
		EndDo;
	EndIf;
EndProcedure

Procedure DeleteUnusedSerialLotNumbers(Object, KeyForDelete = Undefined) Export
	If KeyForDelete = Undefined Then
		ArrayOfUnusedRows = New Array();
		For Each Row In Object.SerialLotNumbers Do
			If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayOfUnusedRows.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayOfUnusedRows Do
			Object.SerialLotNumbers.Delete(Row);
		EndDo;
	Else
		ArrayRowsForDelete = Object.SerialLotNumbers.FindRows(New Structure("Key", KeyForDelete));
		For Each Row In ArrayRowsForDelete Do
			Object.SerialLotNumbers.Delete(Row);
		EndDo;
	EndIf;
EndProcedure

// Start choice.
// 
// Parameters:
//  Item - FormAllItems - Item
//  ChoiceData - ValueList - Choice data
//  StandardProcessing - Boolean - Standard processing
//  Object - See Catalog.SerialLotNumbers.Form.ItemForm.Object
//  Params - Structure:
//  	* Item - CatalogRef.Items
//  	* ItemKey - CatalogRef.ItemKeys
//  	* ItemType - CatalogRef.ItemTypes
Procedure StartChoice(Item, ChoiceData, StandardProcessing, Object, Params) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, DataCompositionComparisonType.NotEqual));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("ItemType", Params.ItemType);
	OpenSettings.FormParameters.Insert("Item", Params.Item);
	OpenSettings.FormParameters.Insert("ItemKey", Params.ItemKey);

	OpenSettings.FormParameters.Insert("FillingData", New Structure("SerialLotNumberOwner", Params.ItemKey));

	DocumentsClient.SerialLotNumberStartChoice(Undefined, Object, Item, ChoiceData, StandardProcessing,
		OpenSettings);
EndProcedure

// Edit text change.
// 
// Parameters:
//  Item - FormAllItems - Item
//  Text - String - Text
//  StandardProcessing - Boolean - Standard processing
//  Object - See Catalog.SerialLotNumbers.Form.ItemForm.Object
//  Params - Structure:
//  	* Item - CatalogRef.Items
//  	* ItemKey - CatalogRef.ItemKeys
//  	* ItemType - CatalogRef.ItemTypes
Procedure EditTextChange(Item, Text, StandardProcessing, Object, Params) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, ComparisonType.NotEqual));

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("ItemType", Params.ItemType);
	AdditionalParameters.Insert("Item", Params.Item);
	AdditionalParameters.Insert("ItemKey", Params.ItemKey);

	DocumentsClient.SerialLotNumbersEditTextChange(Undefined, Object, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

Procedure StartChoiceSingle(Object, Form, Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	StandardProcessing = False;
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Notify = New NotifyDescription("OnFinishEditSerialLotNumbersSingle", ThisObject, New Structure("Object, Form, AddInfo",
		Object, Form, AddInfo));
	OpeningParameters = New Structure();
	OpeningParameters.Insert("Item", CurrentData.Item);
	OpeningParameters.Insert("ItemKey", CurrentData.ItemKey);
	OpeningParameters.Insert("RowKey", CurrentData.Key);
	OpeningParameters.Insert("SerialLotNumbers", New Array());
	OpeningParameters.Insert("Quantity", CurrentData.PhysCount);
	OpeningParameters.Insert("Single", True);
	If Not CurrentData.SerialLotNumber.isEmpty() Then
		OpeningParameters.SerialLotNumbers.Add(
		New Structure("SerialLotNumber, Quantity", CurrentData.SerialLotNumber, CurrentData.PhysCount));
	EndIf;

	OpenForm("Catalog.SerialLotNumbers.Form.EditListOfSerialLotNumbers", OpeningParameters, ThisObject, , , , Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure AddNewSerialLotNumbersSingle(Result, Parameters, AddNewLot = False, AddInfo = Undefined) Export
	If TypeOf(Result) <> Type("Structure") Then
		Return;
	EndIf;
	If Not AddNewLot Then
		ArrayOfItemsRows = Parameters.Object.ItemList.FindRows(New Structure("Key", Result.RowKey));
		For Each ItemRow In ArrayOfItemsRows Do
			For Each Row In Result.SerialLotNumbers Do
				ItemRow.SerialLotNumber = Row.SerialLotNumber;
			EndDo;	
		EndDo;
	EndIf;
EndProcedure

Procedure OnFinishEditSerialLotNumbersSingle(Result, Parameters) Export
	AddNewSerialLotNumbersSingle(Result, Parameters, False, Parameters.AddInfo);
EndProcedure