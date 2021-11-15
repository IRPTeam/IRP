
Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters, AddInfo);
EndProcedure

#Region ItemCompany

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

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, "ItemList");

	//Object.LegalName = DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName);
	//DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	FilterPartnerType = "";
	If Object.TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor") Then
		FilterPartnerType = "Vendor";
	ElsIf Object.TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Sales") Then
		FilterPartnerType = "Customer";
	EndIf;
	If Not IsBlankString(FilterPartnerType) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(FilterPartnerType, True,
			DataCompositionComparisonType.Equal));
		OpenSettings.FormParameters.Insert("Filter", New Structure(FilterPartnerType, True));
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
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.LegalNameOnChange(Object, Form, "ItemList");
	//DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export

	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
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
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region Store

//Procedure SetCurrentStore(Form, Store) Export
//	Form.CurrentStore = Store;
//EndProcedure

//Procedure ChangeItemListStore(ItemList, Store) Export
//	For Each Row In ItemList Do
//		If Row.Store <> Store Then
//			Row.Store = Store;
//		EndIf;
//	EndDo;
//EndProcedure

Procedure StoreOnChange(Object, Form, Item) Export
	ViewClient_V2.StoreOnChange(Object, Form, "ItemList");
	
//	If Not ValueIsFilled(Form.Store) Then
//
//		ObjectData = DocumentsClientServer.GetStructureFillStores();
//		FillPropertyValues(ObjectData, Object);
//		Form.Store = DocumentsServer.GetCurrentStore(ObjectData);
//
//	EndIf;
//
//	If Form.Store <> Form.StoreBeforeChange And Object.ItemList.Count() Then
//		ShowQueryBox(New NotifyDescription("StoreOnChangeContinue", ThisObject, New Structure("Form, Object", Form,
//			Object)), R().QuestionToUser_005, QuestionDialogMode.YesNoCancel);
//		Return;
//	EndIf;
//	DocumentsClient.SetCurrentStore(Object, Form, Form.Store);
//	DocShipmentConfirmationClient.ChangeItemListStore(Object.ItemList, Form.Store);
EndProcedure

//Procedure StoreOnChangeContinue(Answer, AdditionalParameters) Export
//	If Answer = DialogReturnCode.Yes And AdditionalParameters.Property("Form") Then
//		Form = AdditionalParameters.Form;
//		For Each Row In Form.Object.ItemList Do
//			Row.Store = Form.Store;
//		EndDo;
//		Form.Items.Store.InputHint = "";
//		Form.StoreBeforeChange = Form.Store;
//		DocumentsClient.SetCurrentStore(AdditionalParameters.Object, Form, Form.Store);
//	ElsIf AdditionalParameters.Property("Form") Then
//		Form = AdditionalParameters.Form;
//
//		ObjectData = DocumentsClientServer.GetStructureFillStores();
//		FillPropertyValues(ObjectData, AdditionalParameters.Object);
//		DocumentsClientServer.FillStores(ObjectData, Form);
//	Else
//		Return;
//	EndIf;
//EndProcedure

#EndRegion

#Region ItemList

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ItemListItemOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
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
EndProcedure

Procedure ItemListItemKeyOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form);
EndProcedure

Procedure ItemListStoreOnChange(Object, Form, Item) Export
	ViewClient_V2.ItemListStoreOnChange(Object, Form);
EndProcedure

Procedure ItemListUnitOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form);
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	Actions = New Structure("CalculateQuantityInBaseUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

Procedure ItemListQuantityOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form);
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	Actions = New Structure("CalculateQuantityInBaseUnit");
//	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

Procedure ItemListOnChange(Object, Form, Item = Undefined, CurrentRowData = Undefined) Export
	Return;
	//DocumentsClient.FillRowIDInItemList(Object);
	//CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
	
	//If Form.Items.ItemList.CurrentItem <> Undefined And Form.Items.ItemList.CurrentItem.Name = "ItemListStore" Then
	//	DocumentsClient.SetCurrentStore(Object, Form, Form.Items.ItemList.CurrentData.Store);
	//EndIf;

	//If Not CurrentData = Undefined Then
	//	DocumentsClient.FillUnfilledStoreInRow(Object, CurrentData, Form.CurrentStore);
	//EndIf;

	//ObjectData = DocumentsClientServer.GetStructureFillStores();
	//FillPropertyValues(ObjectData, Object);
	//DocumentsClientServer.FillStores(ObjectData, Form);
	
	//RowIDInfoClient.UpdateQuantity(Object, Form);
EndProcedure

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

Procedure ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo = Undefined) Export
	Return;
	//CurrentData = Item.CurrentData;
	//If CurrentData = Undefined Then
	//	Return;
	//EndIf;
	//If Clone Then
	//	CurrentData.Key = New UUID();
	//EndIf;
	//RowIDInfoClient.ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ItemListAfterDeleteRow(Object, Form);
	//DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo);	
EndProcedure

Procedure ItemListOnActivateRow(Object, Form, Item = Undefined, CurrentRowData = Undefined, AddInfo = Undefined) Export
	Return;
//	CurrentData = DocumentsClient.GetCurrentRowDataList(Form.Items.ItemList, CurrentRowData);
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//
//	If ValueIsFilled(CurrentData.Store) And CurrentData.Store <> Form.CurrentStore Then
//		DocumentsClient.SetCurrentStore(Object, Form, CurrentData.Store);
//	EndIf;
EndProcedure

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#Region GroupTitle

#Region Item
Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = DocumentsClient.GetArrayOfFiltersForSelectItemWithoutServiceFilter();
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
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

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form);
EndProcedure
