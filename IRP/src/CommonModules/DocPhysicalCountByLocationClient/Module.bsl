Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

Procedure ItemListOnChange(Object, Form, Item = Undefined, CalculationSettings = Undefined) Export
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

Procedure ItemListItemOnChange(Object, Form, Item = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);
	If ValueIsFilled(CurrentRow.ItemKey)
		And ServiceSystemServer.GetObjectAttribute(CurrentRow.ItemKey, "Item") <> CurrentRow.Item Then
		CurrentRow.ItemKey = Undefined;
	EndIf;
	
	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object,
		CurrentRow,
		CalculationSettings);
EndProcedure

#Region PickUpItems

Procedure PickupItemsEnd(Result, AdditionalParameters) Export
	If Not ValueIsFilled(Result)
		Or Not AdditionalParameters.Property("Object")
		Or Not AdditionalParameters.Property("Form") Then
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
		Row.PhysCount = Row.PhysCount + ResultElement.Quantity;
		Row.Difference = Row.PhysCount - Row.ExpCount;
	EndDo;
	ItemListOnChange(AdditionalParameters.Object, AdditionalParameters.Form, Undefined, Undefined);
EndProcedure

Procedure OpenPickupItems(Object, Form, Command) Export
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyDescription = New NotifyDescription("PickupItemsEnd", DocPhysicalCountByLocationClient, NotifyParameters);
	OpenFormParameters = New Structure;
	StoreArray = New Array;
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

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithNotServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

Procedure StoreOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#Region GroupTitleDecorationsEvents

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

