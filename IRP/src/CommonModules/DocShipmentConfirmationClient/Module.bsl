Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", 
																		True, DataCompositionComparisonType.Equal));
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

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item) Export
	Object.LegalName = DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName);
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	FilterPartnerType = "";
	If Object.TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor") Then
		FilterPartnerType = "Vendor";
	ElsIf Object.TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Sales") Then
		FilterPartnerType = "Customer";
	EndIf;
	If Not IsBlankString(FilterPartnerType) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(FilterPartnerType, True, DataCompositionComparisonType.Equal));
		OpenSettings.FormParameters.Insert("Filter", New Structure(FilterPartnerType , True));
		OpenSettings.FillingData = New Structure(FilterPartnerType, True);
	EndIf;
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	FilterPartnerType = "";
	If Object.TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor") Then
		FilterPartnerType = "Vendor";
	ElsIf Object.TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Sales") Then
		FilterPartnerType = "Customer";
	EndIf;
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(FilterPartnerType, True, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.Partner);
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure LegalNameTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		AdditionalParameters.Insert("Partner", Object.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

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

Procedure ItemListOnChange(Object, Form, Item = Undefined, CalculationSettings = Undefined) Export
	
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
	
	If Form.Items.ItemList.CurrentItem <> Undefined
		AND Form.Items.ItemList.CurrentItem.Name = "ItemListStore" Then
		DocumentsClient.SetCurrentStore(Object, Form, Form.Items.ItemList.CurrentData.Store);
	EndIf;
	
	If Form.Items.ItemList.CurrentData <> Undefined Then
		DocumentsClient.FillUnfilledStoreInRow(Object, Form.Items.ItemList, Form.CurrentStore);
	EndIf;
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, Object);
	DocumentsClientServer.FillStores(ObjectData, Form);
	RowIDInfoClient.UpdateQuantity(Object, Form);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
EndProcedure

Procedure ItemListOnActivateRow(Object, Form, Item) Export
	If Form.Items.ItemList.CurrentData = Undefined Then
		Return;
	EndIf;
	
	CurrentRow = Form.Items.ItemList.CurrentData;
	
	If ValueIsFilled(CurrentRow.Store)
		And CurrentRow.Store <> Form.CurrentStore Then
		DocumentsClient.SetCurrentStore(Object, Form, CurrentRow.Store);
	EndIf;
EndProcedure

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#Region Store

Procedure SetCurrentStore(Form, Store) Export
	Form.CurrentStore = Store;
EndProcedure

Procedure ChangeItemListStore(ItemList, Store) Export
	For Each Row In ItemList Do
		If Row.Store <> Store Then
			Row.Store = Store;
		EndIf;
	EndDo;
EndProcedure

Procedure StoreOnChange(Object, Form, Item) Export
	
	If Not ValueIsFilled(Form.Store) Then
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		Form.Store = DocumentsServer.GetCurrentStore(ObjectData);
		
	EndIf;
	
	If Form.Store <> Form.StoreBeforeChange
		And Object.ItemList.Count() Then
		ShowQueryBox(New NotifyDescription("StoreOnChangeContinue", ThisObject, New Structure("Form, Object", Form, Object)),
			R().QuestionToUser_005,
			QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocumentsClient.SetCurrentStore(Object, Form, Form.Store);
	DocShipmentConfirmationClient.ChangeItemListStore(Object.ItemList, Form.Store);
EndProcedure

Procedure StoreOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes
		And AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		For Each Row In Form.Object.ItemList Do
			Row.Store = Form.Store;
		EndDo;
		Form.Items.Store.InputHint = "";
		Form.StoreBeforeChange = Form.Store;
		DocumentsClient.SetCurrentStore(AdditionalParameters.Object, Form, Form.Store);
	ElsIf AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, AdditionalParameters.Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
	Else
		Return;
	EndIf;
EndProcedure

#EndRegion

#Region GroupTitle

#Region Item
Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithNotServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

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

#EndRegion

Procedure PickupItemsEnd(Result, AdditionalParameters) Export
	If NOT ValueIsFilled(Result)
		OR Not AdditionalParameters.Property("Object")
		OR Not AdditionalParameters.Property("Form") Then
		Return;
	EndIf;
	
	FilterString = "Item, ItemKey, Unit, SerialLotNumber";
	FilterStructure = New Structure(FilterString);
	For Each ResultElement In Result Do
		FillPropertyValues(FilterStructure, ResultElement);
		ExistingRows = AdditionalParameters.Object.ItemList.FindRows(FilterStructure);
		If ExistingRows.Count() Then
			Row = ExistingRows[0];
		Else
			Row = AdditionalParameters.Object.ItemList.Add();
			FillPropertyValues(Row, ResultElement, FilterString);
			Row.Store = AdditionalParameters.Form.Store;
		EndIf;
		Row.Quantity = Row.Quantity + ResultElement.Quantity;
	EndDo;
	ItemListOnChange(AdditionalParameters.Object, AdditionalParameters.Form, Undefined, Undefined);
EndProcedure

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form);
EndProcedure

#Region ItemListItemsEvents

#Region Unit

Procedure ItemListUnitOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Actions = New Structure("CalculateQuantityInBaseUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#Region Quantity

Procedure ItemListQuantityOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Actions = New Structure("CalculateQuantityInBaseUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#EndRegion
