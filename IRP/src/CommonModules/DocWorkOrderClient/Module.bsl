#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
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

#Region PARTNER

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, "ItemList");
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Filter", New Structure("Customer", True));
	OpenSettings.FillingData = New Structure("Customer", True);

	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, ComparisonType.Equal));
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

Procedure AgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.AgreementOnChange(Object, Form, "ItemList");
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
		"Enum.AgreementTypes.Customer"), DataCompositionComparisonType.Equal));
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
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"),
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

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Object, Form, Item) Export
	ViewClient_V2.PriceIncludeTaxOnChange(Object, Form);
EndProcedure

#EndRegion

#Region STATUS

Procedure StatusOnChange(Object, Form, Item) Export
	ViewClient_V2.StatusOnChange(Object, Form, "ItemList");
EndProcedure

#EndRegion

#Region MATERIALS

Procedure MaterialsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	Cancel = True;
	ItemListCurrentData = Form.Items.ItemList.CurrentData;
	If ItemListCurrentData = Undefined Then
		Return;
	EndIf;
	KeyOwner = ItemListCurrentData.Key;
	ViewClient_V2.MaterialsBeforeAddRow(Object, Form, Cancel, Clone, Undefined, KeyOwner);
EndProcedure

#Region MATERIALS_COLUMNS

#Region _ITEM

Procedure MaterialsItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure MaterialsItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Product"),
		DataCompositionComparisonType.Equal));
	
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure MaterialsItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Product"), ComparisonType.Equal));
	
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure MaterialsItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region UNIT

Procedure MaterialsUnitOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsUnitOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region QUANTITY

Procedure MaterialsQuantityOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.MaterialsQuantityOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region WORKERS

Procedure WorkersBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.WorkersBeforeAddRow(Object, Form, Cancel, Clone);
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

#Region _ITEM

Procedure ItemListItemOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"),
		DataCompositionComparisonType.Equal));
	
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.Equal));
	
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ITEM_KEY

Procedure ItemListItemKeyOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListItemKeyOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region BILL_OF_MATERIALS

Procedure ItemListBillOfMaterialsOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListBillOfMaterialsOnChange(Object, Form, CurrentData);
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

#Region TAX_RATE

Procedure ItemListTaxValueOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ItemListTaxRateOnChange(Object, Form);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
