
#Region FORM

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
	
//	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
//	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object, AddInfo);
//	SerialLotNumberClient.UpdateSerialLotNumbersTree(Object, Form);
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object, AddInfo);
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters, AddInfo);
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ItemList");
	
	//DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
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
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region ITEMLIST

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
	
//	If Clone Then
//		Return;
//	EndIf;
//	Cancel = True;
//	NewRow = Object.ItemList.Add();
//	Form.Items.ItemList.CurrentRow = NewRow.GetID();
//	UserSettingsClientServer.FillingRowFromSettings(Object, "Object.ItemList", NewRow, True);
//	Form.Items.ItemList.ChangeRow();
//	ItemListOnChange(Object, Form, Item);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item, AddInfo = Undefined) Export
	ViewClient_V2.ItemListAfterDeleteRow(Object, Form);
	
//	SerialLotNumberClient.DeleteUnusedSerialLotNumbers(Object);
//	SerialLotNumberClient.UpdateSerialLotNumbersTree(Object, Form);
//	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo);	
EndProcedure

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

#EndRegion

//Procedure ItemListOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
//	DocumentsClient.FillRowIDInItemList(Object);
//	RowIDInfoClient.UpdateQuantity(Object, Form);
//EndProcedure


//Procedure ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo = Undefined) Export
//	CurrentData = Item.CurrentData;
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	If Clone Then
//		CurrentData.Key = New UUID();
//	EndIf;
//	RowIDInfoClient.ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo);
//EndProcedure

#Region ITEMLIST_ITEM

Procedure ItemListItemOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	ViewClient_V2.ItemListItemOnChange(Object, Form);
	
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
//
//	SerialLotNumberClient.UpdateUseSerialLotNumber(Object, Form, AddInfo);
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

#Region ITEMLIST_ITEMKEY

Procedure ItemListItemKeyOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form);
	
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//
//	CalculationSettings = New Structure();
//	CalculationSettings.Insert("UpdateUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, CalculationSettings);
//	SerialLotNumberClient.UpdateUseSerialLotNumber(Object, Form, AddInfo);
EndProcedure

#EndRegion

#Region ITEMLIST_UNIT

Procedure ItemListUnitOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form);
	
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	Actions = New Structure("CalculateQuantityInBaseUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#Region ITEMLIST_QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form);
	
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	Actions = New Structure("CalculateQuantityInBaseUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
//	SerialLotNumberClient.UpdateSerialLotNumbersTree(Object, Form);
EndProcedure

#EndRegion

#Region ITEMLIST_EXPENSETYPE

Procedure ItemListExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ItemListExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
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

#Region SERIALLOTNUMBERS

Procedure ItemListSerialLotNumbersPresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing,
	AddInfo = Undefined) Export
	DocumentsClient.ItemListSerialLotNumbersPutServerDataToAddInfo(Object, Form, AddInfo);
	SerialLotNumberClient.PresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, AddInfo);
EndProcedure

Procedure ItemListSerialLotNumbersPresentationClearing(Object, Form, Item, StandardProcessing, AddInfo = Undefined) Export
	SerialLotNumberClient.PresentationClearing(Object, Form, Item, AddInfo);
EndProcedure

#EndRegion

#Region SERVICE

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form);
EndProcedure

Procedure PickupItemsEnd(Result, AdditionalParameters) Export
	If Not ValueIsFilled(Result) Or Not AdditionalParameters.Property("Object") Or Not AdditionalParameters.Property(
		"Form") Then
		Return;
	EndIf;

	FilterString = "Item, ItemKey, Unit";
	FilterStructure = New Structure(FilterString);
	For Each ResultElement In Result Do
		FillPropertyValues(FilterStructure, ResultElement);
		ExistingRows = AdditionalParameters.Object.ItemList.FindRows(FilterStructure);
		If ExistingRows.Count() Then
			Row = ExistingRows[0];
		Else
			Row = AdditionalParameters.Object.ItemList.Add();
			FillPropertyValues(Row, ResultElement, FilterString);
		EndIf;
		Row.Quantity = Row.Quantity + ResultElement.Quantity;
	EndDo;
	//ItemListOnChange(AdditionalParameters.Object, AdditionalParameters.Form, Undefined, Undefined);
EndProcedure

Procedure OpenPickupItems(Object, Form, Command) Export
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyDescription = New NotifyDescription("PickupItemsEnd", DocStockAdjustmentAsWriteOffClient, NotifyParameters);
	OpenFormParameters = New Structure();
	StoreArray = New Array();
	StoreArray.Add(Object.Store);

	If Command.AssociatedTable <> Undefined Then
		OpenFormParameters.Insert("AssociatedTableName", Command.AssociatedTable.Name);
		OpenFormParameters.Insert("Object", Object);
	EndIf;

	OpenFormParameters.Insert("Stores", StoreArray);
	OpenFormParameters.Insert("EndPeriod", CommonFunctionsServer.GetCurrentSessionDate());
	OpenForm("CommonForm.PickUpItems", OpenFormParameters, Form, , , , NotifyDescription);
EndProcedure

#EndRegion
