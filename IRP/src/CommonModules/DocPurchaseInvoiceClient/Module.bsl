#Region FORM

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	DocumentsClient.AfterWriteAtClientPutServerDataToAddInfo(Object, Form, AddInfo);
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object, AddInfo);
	DocumentsClient.SetLockedRowsForItemListByTradeDocuments(Object, Form, "GoodsReceipts");
	DocumentsClient.UpdateTradeDocumentsTree(Object, Form, "GoodsReceipts", "GoodsReceiptsTree",
		"QuantityInGoodsReceipt");
	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters, AddInfo);
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item, AddInfo = Undefined) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ItemList");
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

#Region PARTNER

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, "ItemList");
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Vendor", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Filter", New Structure("Vendor", True));
	OpenSettings.FillingData = New Structure("Vendor", True);

	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Vendor", True, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.LegalNameOnChange(Object, Form, "ItemList");
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

#Region AGREEMENT

Procedure AgreementOnChange(Object, Form, Item, AddInfo = Undefined) Export
	ViewClient_V2.AgreementOnChange(Object, Form, "ItemList");
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
		"Enum.AgreementTypes.Vendor"), DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue(
		"Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", Object.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner", Object.Partner);
	OpenSettings.FillingData.Insert("LegalName", Object.LegalName);
	OpenSettings.FillingData.Insert("Company", Object.Company);
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Vendor"));

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"),
		ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", Object.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region STORE

Procedure StoreOnChange(Object, Form, Item) Export
	ViewClient_V2.StoreOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region DELIVERY_DATE

Procedure DeliveryDateOnChange(Object, Form, Item) Export
	ViewClient_V2.DeliveryDateOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

Procedure LegalNameContractOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Object, Form, Item) Export
	ViewClient_V2.PriceIncludeTaxOnChange(Object, Form);
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export
	If Upper(Field.Name) = Upper("ItemListTaxAmount") Then
		CurrentData = Form.Items.ItemList.CurrentData;
		If CurrentData <> Undefined Then
			DocumentsClient.ItemListSelectionPutServerDataToAddInfo(Object, Form, AddInfo);
			Parameters = New Structure();
			Parameters.Insert("CurrentData", CurrentData);
			Parameters.Insert("Item", Item);
			Parameters.Insert("Field", Field);
			TaxesClient.ChangeTaxAmount(Object, Form, Parameters, StandardProcessing, AddInfo);
		EndIf;
	EndIf;
	RowIDInfoClient.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

Procedure ItemListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ItemListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel) Export
	RowIDInfoClient.ItemListBeforeDeleteRow(Object, Form, Item, Cancel);
EndProcedure

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ItemListAfterDeleteRow(Object, Form);
EndProcedure

#Region ITEM_LIST_COLUMNS

#Region _ITEM

Procedure ItemListItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemListItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region PRICE_TYPE

Procedure ItemListPriceTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListPriceTypeOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure ItemListUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region PRICE

Procedure ItemListPriceOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListPriceOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

Procedure ItemListTotalAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListTotalAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

Procedure ItemListTaxAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListTaxAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

Procedure ItemListDontCalculateRowOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListDontCalculateRowOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region STORE

Procedure ItemListStoreOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListStoreOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region DELIVERY_DATE

Procedure ItemListDeliveryDateOnChange(Object, Form, Item) Export
	ViewClient_V2.ItemListDeliveryDateOnChange(Object, Form);
EndProcedure

#EndRegion

#Region TAX_RATE

Procedure ItemListTaxValueOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListTaxRateOnChange(Object, Form);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBERS

Procedure ItemListSerialLotNumbersPresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	DocumentsClient.ItemListSerialLotNumbersPutServerDataToAddInfo(Object, Form, AddInfo);
	SerialLotNumberClient.PresentationStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, AddInfo);
EndProcedure

Procedure ItemListSerialLotNumbersPresentationClearing(Object, Form, Item, StandardProcessing, AddInfo = Undefined) Export
	SerialLotNumberClient.PresentationClearing(Object, Form, Item, AddInfo);
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

Procedure ItemListExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ItemListExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region PAYMENT_TERMS

Procedure PaymentTermsDateOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.CalculatePaymentTermDuePeriod(Object, Form, Item, AddInfo);
EndProcedure

Procedure PaymentTermsOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.CalculatePaymentTermDateAndAmount(Object, Form, AddInfo);
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

#Region PICK_UP_ITEMS

Procedure OpenPickupItems(Object, Form, Command) Export
	DocumentsClient.OpenPickupItems(Object, Form, Command);
EndProcedure

Procedure SearchByBarcode(Barcode, Object, Form) Export
	PriceType = PredefinedValue("Catalog.PriceTypes.EmptyRef");
	If ValueIsFilled(Object.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		PriceType = AgreementInfo.PriceType;
	EndIf;
	DocumentsClient.SearchByBarcode(Barcode, Object, Form, , PriceType);
EndProcedure

#EndRegion
