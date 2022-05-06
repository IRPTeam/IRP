
#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
	UpdateView(Object, Form);
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters, AddInfo);
EndProcedure

// Update view.
// 
// Parameters:
//  Object - See Document.PhysicalInventory.Form.DocumentForm.Object
//  Form - See Document.PhysicalInventory.Form.DocumentForm
Procedure UpdateView(Object, Form) Export
	Form.Items.ItemListSerialLotNumber.Visible = Object.UseSerialLot; 
EndProcedure

#EndRegion

#Region STORE

Procedure StoreOnChange(Object, Form, Item) Export
	ViewClient_V2.StoreObjectAttrOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region USE_SERIAL_LOT_NUMBERS

Procedure UseSerialLotOnChange(Object, Form, Item) Export
	UpdateView(Object, Form);
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	If Upper(Field.Name) = Upper("ItemListPhysicalCountByLocationPresentation") Then
		CurrentData = Form.Items.ItemList.CurrentData;
		If CurrentData = Undefined Then
			Return;
		EndIf;
		StandardProcessing = False;
		If ValueIsFilled(CurrentData.PhysicalCountByLocation) Then
			FormParameters = New Structure("Key", CurrentData.PhysicalCountByLocation);
			OpenForm("Document.PhysicalCountByLocation.ObjectForm", FormParameters, Form);
		EndIf;
	EndIf;
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
	ShowInputNumber(NotifyDescription, CountDocsToCreate, R().QuestionToUser_017, 2, 0);	
EndProcedure

Procedure CreatePhysicalCountEnd(CountDocsToCreate, AdditionalParameters) Export
	If ValueIsFilled(CountDocsToCreate) Then
		AdditionalParameters.Insert("CountDocsToCreate", CountDocsToCreate);
		DocPhysicalInventoryServer.CreatePhysicalCount(AdditionalParameters.ObjectRef, AdditionalParameters);
		Notify("CreatedPhysicalCountByLocations", , AdditionalParameters.ObjectRef);
	EndIf;
EndProcedure

// Fill exp count.
// 
// Parameters:
//  Object - See Document.PhysicalInventory.Form.DocumentForm.Object
//  Form - See Document.PhysicalInventory.Form.DocumentForm
Procedure FillExpCount(Object, Form) Export
	If DocPhysicalInventoryServer.HavePhysicalCountByLocation(Object.Ref) Then
		ShowMessageBox(Undefined, R().InfoMessage_006);
		Return;
	EndIf;
	
	ItemCounts = DocPhysicalInventoryServer.GetItemListWithFillingExpCount(Object.Ref, Object.Store);
	
	FillItemList(Object, Form, ItemCounts);
	Object.RowIDInfo.Clear();
EndProcedure

Procedure UpdateExpCount(Object, Form) Export
	ItemList = New Array();
	For Each Row In Object.ItemList Do
		NewRow = New Structure("Key, LineNumber, Store, ItemKey, Unit, PhysCount");
		FillPropertyValues(NewRow, Row);
		NewRow.Store = Object.Store;
		ItemList.Add(NewRow);
	EndDo;
	FillItemList(Object, Form, DocPhysicalInventoryServer.GetItemListWithFillingExpCount(Object.Ref, Object.Store, ItemList));
EndProcedure

Procedure UpdatePhysCount(Object, Form) Export
	ArrayItemRowWithFillingPhysCount = DocPhysicalInventoryServer.GetItemListWithFillingPhysCount(Object.Ref); 
	UpdateItemList(Object, Form, ArrayItemRowWithFillingPhysCount);
EndProcedure

Procedure FillItemList(Object, Form, Result)
	Object.ItemList.Clear();
	For Each Row In Result Do
		NewRow = Object.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Difference = NewRow.PhysCount - NewRow.ExpCount;
	EndDo;
EndProcedure

// Update item list.
// 
// Parameters:
//  Object - See Document.PhysicalInventory.Form.DocumentForm.Object
//  Form  - See Document.PhysicalInventory.Form.DocumentForm
//  Result - Array of See DocPhysicalInventoryServer.GetItemRowWithFillingPhysCount - Result
Procedure UpdateItemList(Object, Form, Result)
	For Each ItemListRow In Object.ItemList Do
		ItemListRow.PhysCount = 0;
		ItemListRow.Difference = ItemListRow.PhysCount - ItemListRow.ExpCount;
	EndDo;

	For Each Row In Result Do
		ItemListFoundRows = Object.ItemList.FindRows(New Structure("Unit, ItemKey", Row.Unit, Row.ItemKey));
		If ItemListFoundRows.Count() Then
			ItemListRow = ItemListFoundRows[0];
		Else
			ItemListRow = Object.ItemList.Add();
		EndIf;
		FillPropertyValues(ItemListRow, Row);
	EndDo;
EndProcedure

#EndRegion

