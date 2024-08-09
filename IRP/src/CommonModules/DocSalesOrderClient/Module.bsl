#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
#If Not MobileClient And Not MobileAppClient Then
	MessageText = DocSalesOrderServer.CheckItemList(Object.Ref);
	If Not MessageText = "" Then
		Status(Object.Ref, , MessageText);
	EndIf;
#EndIf

	RowIDInfoClient.AfterWriteAtClient(Object, Form, WriteParameters);
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
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

#Region ACCOUNT
Procedure AccountOnChange(Object, Form, Item) Export
	ViewClient_V2.AccountOnChange(Object, Form, "ItemList");
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	ArrayOfFilters = New Array();
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure
#EndRegion

#Region TRANSACTION_TYPE

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.TransactionTypeOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region RETAIL_CUSTOMER

Procedure RetailCustomerOnChange(Object, Form, Item) Export
	ViewClient_V2.RetailCustomerOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region PARTNER

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, "ItemList");
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.PartnerStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.TransactionType);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.PartnerTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, Object.TransactionType);
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

Procedure AgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.AgreementOnChange(Object, Form, "ItemList");
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.TransactionType);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, Object.TransactionType);
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

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Object, Form, Item) Export
	ViewClient_V2.PriceIncludeTaxOnChange(Object, Form);
EndProcedure

#EndRegion

#Region STATUS

Procedure StatusOnChange(Object, Form, Item) Export
#If Not MobileClient Then
	ViewClient_V2.StatusOnChange(Object, Form, "ItemList");
#EndIf
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
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

#Region PARTNER_ITEM

Procedure ItemListPartnerItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListPartnerItemOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region _ITEM

Procedure ItemListItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData <> Undefined Then
		FilterItemByPartnerItem = DocumentsServer.GetItemAndItemKeyByPartnerItem(CurrentData.PartnerItem);
		If ValueIsFilled(FilterItemByPartnerItem.Item) Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", FilterItemByPartnerItem.Item,
				DataCompositionComparisonType.Equal));
		EndIf;
	EndIf;

	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));

	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData <> Undefined Then
		FilterItemByPartnerItem = DocumentsServer.GetItemAndItemKeyByPartnerItem(CurrentData.PartnerItem);
		If ValueIsFilled(FilterItemByPartnerItem.Item) Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Ref", FilterItemByPartnerItem.Item,
				ComparisonType.Equal));
		EndIf;
	EndIf;

	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemListItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
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

#Region QUANTITY_IN_BASE_UNIT

Procedure ItemListQuantityInBaseUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityInBaseUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY_IS_FIXED

Procedure ItemListQuantityIsFixedOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListQuantityIsFixedOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region PRICE_TYPE

Procedure ItemListPriceTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListPriceTypeOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region PRICE

Procedure ItemListPriceOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListPriceOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region NET_AMOUNT

Procedure ItemListNetAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListNetAmountOnChange(Object, Form, CurrentData);
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

#Region VAT_RATE

Procedure ItemListVatRateOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListVatRateOnChange(Object, Form);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

Procedure ItemListRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.RevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ItemListRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.RevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CANCEL

Procedure ItemListCancelOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListCancelOnChange(Object, Form);
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

#Region PROCUREMENT_METHODS

Procedure SetProcurementMethods(Object, Form, Command) Export
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyDescription = New NotifyDescription("PickupProcurementEnd", ThisObject, NotifyParameters);
	OpenForm("Enum.ProcurementMethods.ChoiceForm", , Form, , , , NotifyDescription);
EndProcedure

Procedure PickupProcurementEnd(Result, AdditionalParameters) Export
	If Result = Undefined Or Result = DialogReturnCode.Cancel Then
		Return;
	EndIf;

	ProcurementMethod = Result.ProcurementMethods[0];

	For Each SelectedRow In AdditionalParameters.Form.Items.ItemList.SelectedRows Do
		AdditionalParameters.Form.Items.ItemList.RowData(SelectedRow).ProcurementMethod = ProcurementMethod;
	EndDo;
EndProcedure

#EndRegion

#Region PAYMENT_TYPE

Procedure PaymentsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.PaymentsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure PaymentsPaymentTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentsPaymentTypeOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentsBankTermOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentsBankTermOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentsAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentsAmountOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentsPercentOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentsPercentOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentsCommissionOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentsCommissionOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentsAccountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentsAccountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

