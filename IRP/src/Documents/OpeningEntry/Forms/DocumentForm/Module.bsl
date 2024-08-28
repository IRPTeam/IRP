
#Region FORM

&AtClient
Var MainTables;

&AtServer
Procedure OnReadAtServer(CurrentObject) Export
	DocOpeningEntryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibleCustomersPaymentTerms(Object, ThisObject);
	SetVisibleVendorsPaymentTerms(Object, ThisObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibleCustomersPaymentTerms(Object, ThisObject);
		SetVisibleVendorsPaymentTerms(Object, ThisObject);
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocOpeningEntryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
	DocOpeningEntryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocOpeningEntryClient.OnOpen(Object, ThisObject, Cancel, MainTables);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	CurrentData =  Items.AccountReceivableByDocuments.CurrentData;
	If CurrentData <> Undefined Then
		SetVisibleCustomersPaymentTerms(Object, ThisObject, CurrentData);
	EndIf;

	CurrentData =  Items.AccountPayableByDocuments.CurrentData;
	If CurrentData <> Undefined Then
		SetVisibleVendorsPaymentTerms(Object, ThisObject, CurrentData);
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.EditCurrenciesAccountBalance.Enabled                = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAdvanceFromCustomers.Enabled          = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAdvanceToSuppliers.Enabled            = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAccountReceivableByAgreements.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAccountReceivableByDocuments.Enabled  = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAccountPayableByAgreements.Enabled    = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAccountPayableByDocuments.Enabled     = Not Form.ReadOnly;
	Form.Items.EditCurrenciesReceiptFromConsignor.Enabled          = Not Form.ReadOnly;
	Form.Items.EditCurrenciesEmployeeCashAdvance.Enabled           = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAdvanceFromRetailCustomers.Enabled    = Not Form.ReadOnly;
	Form.Items.EditCurrenciesSalaryPayment.Enabled                 = Not Form.ReadOnly;
	Form.Items.EditCurrenciesCashInTransit.Enabled                 = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAccountPayableOther.Enabled           = Not Form.ReadOnly;
	Form.Items.EditCurrenciesAccountReceivableOther.Enabled        = Not Form.ReadOnly;
	Form.Items.EditCurrenciesFixedAssets.Enabled                   = Not Form.ReadOnly;
	Form.Items.EditCurrenciesTaxesIncoming.Enabled                 = Not Form.ReadOnly;
	Form.Items.EditCurrenciesTaxesOutgoing.Enabled                 = Not Form.ReadOnly;
	
	UseCommissionTrading = FOServer.IsUseCommissionTrading();
	
	Form.Items.GroupReceiptFromConsignor.Visible = UseCommissionTrading;

	Form.Items.PartnerTradeAgent.Visible    = UseCommissionTrading;
	Form.Items.LegalNameTradeAgent.Visible  = UseCommissionTrading;
	Form.Items.AgreementTradeAgent.Visible  = UseCommissionTrading;
	Form.Items.ShipmentToTradeAgent.Visible = UseCommissionTrading;

	Form.Items.GroupShipmentToTradeAgent.Visible = UseCommissionTrading;

	Form.Items.PartnerConsignor.Visible     = UseCommissionTrading;
	Form.Items.LegalNameConsignor.Visible   = UseCommissionTrading;
	Form.Items.AgreementConsignor.Visible   = UseCommissionTrading;
	Form.Items.ReceiptFromConsignor.Visible = UseCommissionTrading;
	
	Form.Items.SalaryPayment.Visible              = FOServer.IsUseSalary();
	Form.Items.EmployeeList.Visible               = FOServer.IsUseSalary();
	Form.Items.AdvanceFromRetailCustomers.Visible = FOServer.IsUseRetail();
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibleCustomersPaymentTerms(Object, Form, CurrentData = Undefined)
	For Each Row In Object.CustomersPaymentTerms Do
		If CurrentData = Undefined Then
			Row.IsVisible = False;
		Else
			Row.IsVisible = True;
		EndIf;
	EndDo;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibleVendorsPaymentTerms(Object, Form, CurrentData = Undefined)
	For Each Row In Object.VendorsPaymentTerms Do
		If CurrentData = Undefined Then
			Row.IsVisible = False;
		Else
			Row.IsVisible = True;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocOpeningEntryClient.CompanyOnChange(Object, ThisObject, Item, MainTables);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocOpeningEntryClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocOpeningEntryClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocOpeningEntryClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region INVENTORY

&AtClient
Procedure InventoryBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.InventoryBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure InventoryAfterDeleteRow(Item)
	DocOpeningEntryClient.InventoryAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region INVENTORY_COLUMNS

#Region _ITEM

&AtClient
Procedure InventoryItemOnChange(Item)
	DocOpeningEntryClient.InventoryItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure InventoryItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocOpeningEntryClient.InventoryItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure InventoryItemEditTextChange(Item, Text, StandardProcessing)
	DocOpeningEntryClient.InventoryItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ITEM_KEY

&AtClient
Procedure InventoryItemKeyOnChange(Item)
	DocOpeningEntryClient.InventoryItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBERS

&AtClient
Procedure InventorySerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items.Inventory.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SerialLotNumberClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure InventorySerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.Inventory.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

#EndRegion

#Region SOURCE_OF_ORIGINS

&AtClient
Procedure InventorySourceOfOriginStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items.Inventory.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SourceOfOriginClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure InventorySourceOfOriginEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.Inventory.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SourceOfOriginClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

#EndRegion

#Region INVENTORY_QUANTITY

&AtClient
Procedure InventoryQuantityOnChange(Item)
	DocOpeningEntryClient.ItemListQuantityOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region INVENTORY_PRICE

&AtClient
Procedure InventoryPriceOnChange(Item)
	DocOpeningEntryClient.ItemListPriceOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#Region INVENTORY_AMOUNT

&AtClient
Procedure InventoryAmountOnChange(Item)
	DocOpeningEntryClient.ItemListAmountOnChange(Object, ThisObject);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region FIXED_ASSETS

&AtClient
Procedure FixedAssetsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.FixedAssetsBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure FixedAssetsAfterDeleteRow(Item)
	DocOpeningEntryClient.FixedAssetsAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT_BALANCE

&AtClient
Procedure AccountBalanceBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.AccountBalanceBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);	
EndProcedure

&AtClient
Procedure AccountBalanceAfterDeleteRow(Item)
	DocOpeningEntryClient.AccountBalanceAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region ACCOUNT_BALANCE_COLUMNS

#Region ACCOUNT

&AtClient
Procedure AccountBalanceAccountOnChange(Item)
	DocOpeningEntryClient.AccountBalanceAccountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region CASH_IN_TRANSIT

&AtClient
Procedure CashInTransitBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.CashInTransitBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure CashInTransitAfterDeleteRow(Item)
	DocOpeningEntryClient.CashInTransitAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region CASH_IN_TRANSIT_COLUMNS

#Region RECEIPTING_ACCOUNT

&AtClient
Procedure CashInTransitReceiptingAccountOnChange(Item)
	DocOpeningEntryClient.CashInTransitReceiptingAccountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region EMPLOYEE_CASH_ADVANCE

&AtClient
Procedure EmployeeCashAdvanceBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.EmployeeCashAdvanceBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure EmployeeCashAdvanceAfterDeleteRow(Item)
	DocOpeningEntryClient.EmployeeCashAdvanceAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region EMPLOYEE_CASH_ADVANCE_COLUMNS

#Region ACCOUNT

&AtClient
Procedure EmployeeCashAdvanceAccountOnChange(Item)
	DocOpeningEntryClient.EmployeeCashAdvanceAccountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region ADVANCE_FROM_RETAIL_CUSTOMER

&AtClient
Procedure AdvanceFromRetailCustomersBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.AdvanceFromRetailCustomersBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure AdvanceFromRetailCustomersAfterDeleteRow(Item)
	DocOpeningEntryClient.AdvanceFromRetailCustomersAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SALARY_PAYMENT

&AtClient
Procedure SalaryPaymentBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.SalaryPaymentBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure SalaryPaymentAfterDeleteRow(Item)
	DocOpeningEntryClient.SalaryPaymentAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region EMPLOYEE_LIST

&AtClient
Procedure EmployeeListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.EmployeeListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure EmployeeListAfterDeleteRow(Item)
	DocOpeningEntryClient.EmployeeListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure EmployeeListSalaryTypeOnChange(Item)
	DocOpeningEntryClient.EmployeeListSalaryTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAXES_INCOMING
		
&AtClient
Procedure TaxesIncomingBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.TaxesIncomingBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure TaxesIncomingAfterDeleteRow(Item)
	DocOpeningEntryClient.TaxesIncomingAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesIncomingVatRateOnChange(Item)
	DocOpeningEntryClient.TaxesIncomingVatRateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesIncomingNetAmountOnChange(Item)
	DocOpeningEntryClient.TaxesIncomingNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesIncomingTaxAmountOnChange(Item)
	DocOpeningEntryClient.TaxesIncomingTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesIncomingTotalAmountOnChange(Item)
	DocOpeningEntryClient.TaxesIncomingTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAXES_OUTGOING

&AtClient
Procedure TaxesOutgoingBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.TaxesOutgoingBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure TaxesOutgoingAfterDeleteRow(Item)
	DocOpeningEntryClient.TaxesOutgoingAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesOutgoingVatRateOnChange(Item)
	DocOpeningEntryClient.TaxesOutgoingVatRateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesOutgoingNetAmountOnChange(Item)
	DocOpeningEntryClient.TaxesOutgoingNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesOutgoingTaxAmountOnChange(Item)
	DocOpeningEntryClient.TaxesOutgoingTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxesOutgoingTotalAmountOnChange(Item)
	DocOpeningEntryClient.TaxesOutgoingTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure MainTableOnChange(Item)
	For Each Row In Object[Item.Name] Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure MainTableLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items[StrReplace(Item.Name, "LegalName", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", CurrentData.Partner);

	DocumentsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure AdvanceFromCustomersOnActivateCell(Item)
	AdvanceMainTableOnActivateCell("AdvanceFromCustomers", Item);
EndProcedure

&AtClient
Procedure AdvanceToSuppliersOnActivateCell(Item)
	AdvanceMainTableOnActivateCell("AdvanceToSuppliers", Item);
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountPayableByAgreements", Item);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsOnActivateCell(Item)
	AccountByDocumentsMainTableOnActivateCell("AccountPayableByDocuments", Item);
EndProcedure

&AtClient
Procedure AccountPayableOtherOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountPayableOther", Item);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountReceivableByAgreements", Item);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsOnActivateCell(Item)
	AccountByDocumentsMainTableOnActivateCell("AccountReceivableByDocuments", Item);
EndProcedure

&AtClient
Procedure AccountReceivableOtherOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountReceivableOther", Item);
EndProcedure

&AtClient
Procedure AdvanceMainTableOnActivateCell(TableName, Item)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Items[TableName + "LegalName"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
EndProcedure

&AtClient
Procedure AccountByAgreementsMainTableOnActivateCell(TableName, Item)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Items[TableName + "LegalName"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
	Items[TableName + "Agreement"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
EndProcedure

&AtClient
Procedure AccountByDocumentsMainTableOnActivateCell(TableName, Item)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Items[TableName + "LegalName"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
	Items[TableName + "Agreement"].ReadOnly = Not ValueIsFilled(CurrentData.Partner);
EndProcedure

&AtClient
Procedure AdvanceMainTablePartnerOnChange(Item)
	CurrentData = Items[StrReplace(Item.Name, "Partner", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
EndProcedure

&AtClient
Procedure AccountByAgreementsMainTablePartnerOnChange(Item, AgreementType, ApArPostingDetail)
	TableName = StrReplace(Item.Name, "Partner", "");
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner", CurrentData.Partner);
	AgreementParameters.Insert("Agreement", CurrentData.Agreement);
	AgreementParameters.Insert("CurrentDate", Object.Date);
	AgreementParameters.Insert("Company", Object.Company);

	AgreementParameters.Insert("ArrayOfFilters", New Array());
	AgreementParameters.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("Type", AgreementType, ComparisonType.Equal));
	AgreementParameters.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("ApArPostingDetail", ApArPostingDetail, ComparisonType.Equal));

	CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
EndProcedure

&AtClient
Procedure AccountByDocumentsMainTablePartnerOnChange(Item, AgreementType, ApArPostingDetail)
	TableName = StrReplace(Item.Name, "Partner", "");
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner", CurrentData.Partner);
	AgreementParameters.Insert("Agreement", CurrentData.Agreement);
	AgreementParameters.Insert("CurrentDate", Object.Date);
	AgreementParameters.Insert("Company", Object.Company);
	AgreementParameters.Insert("PartnerType", AgreementType);
	AgreementParameters.Insert("ApArPostingDetail", ApArPostingDetail);
	AgreementParameters.Insert("ArrayOfFilters", New Array());

	CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsPartnerOnChange(Item, AddInfo = Undefined) Export
	AccountByAgreementsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Vendor"),
		PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
EndProcedure

&AtClient
Procedure AccountPayableOtherPartnerOnChange(Item, AddInfo = Undefined) Export
	AccountByAgreementsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Other"),
		PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsPartnerOnChange(Item, AddInfo = Undefined) Export
	AccountByAgreementsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Customer"),
		PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
EndProcedure

&AtClient
Procedure AccountReceivableOtherPartnerOnChange(Item, AddInfo = Undefined) Export
	AccountByAgreementsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Other"),
		PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsPartnerOnChange(Item, AddInfo = Undefined) Export
	AccountByDocumentsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Vendor"),
		PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsPartnerOnChange(Item, AddInfo = Undefined) Export
	AccountByDocumentsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Customer"),
		PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
EndProcedure

&AtClient
Procedure MainTableLegalNameEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items[StrReplace(Item.Name, "LegalName", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementStartChoice("AccountReceivableByAgreements", PredefinedValue("Enum.AgreementTypes.Customer"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementStartChoice("AccountReceivableByDocuments", PredefinedValue("Enum.AgreementTypes.Customer"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementStartChoice("AccountPayableByAgreements", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementStartChoice("AccountPayableByDocuments", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountReceivableOtherAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementStartChoice("AccountReceivableOther", PredefinedValue("Enum.AgreementTypes.Other"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableOtherAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementStartChoice("AccountPayableOther", PredefinedValue("Enum.AgreementTypes.Other"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AdvanceFromCustomersAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementStartChoice("AdvanceFromCustomers", PredefinedValue("Enum.AgreementTypes.Customer"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AdvanceToSuppliersAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementStartChoice("AdvanceToSuppliers", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementStartChoice(TableName, AgreementType, ArrayOfApArPostingDetail, Item, ChoiceData, StandardProcessing)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType,
		DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ApArPostingDetail", ArrayOfApArPostingDetail,
		DataCompositionComparisonType.InList));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner", CurrentData.Partner);
	OpenSettings.FillingData.Insert("LegalName", CurrentData.LegalName);
	OpenSettings.FillingData.Insert("Company", Object.Company);
	OpenSettings.FillingData.Insert("Type", AgreementType);
	OpenSettings.FillingData.Insert("ApArPostingDetail", ArrayOfApArPostingDetail[0]);

	DocumentsClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementEditTextChange("AccountReceivableByAgreements", PredefinedValue("Enum.AgreementTypes.Customer"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);

EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementEditTextChange("AccountReceivableByDocuments", PredefinedValue("Enum.AgreementTypes.Customer"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByAgreementsAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementEditTextChange("AccountPayableByAgreements", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementEditTextChange("AccountPayableByDocuments", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountReceivableOtherAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementEditTextChange("AccountReceivableOther", PredefinedValue("Enum.AgreementTypes.Other"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountPayableOtherAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));

	AgreementEditTextChange("AccountPayableOther", PredefinedValue("Enum.AgreementTypes.Other"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AdvanceFromCustomersAgreementEditTextChange(Item, Text, StandardProcessing)
	ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementEditTextChange("AdvanceFromCustomers", PredefinedValue("Enum.AgreementTypes.Customer"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AdvanceToSuppliersAgreementEditTextChange(Item, Text, StandardProcessing)
		ArrayOfApArPostingDetail = New Array();
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement"));
	ArrayOfApArPostingDetail.Add(PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));

	AgreementEditTextChange("AdvanceToSuppliers", PredefinedValue("Enum.AgreementTypes.Vendor"),
		ArrayOfApArPostingDetail, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(TableName, AgreementType, ArrayOfApArPostingDetail, Item, Text, StandardProcessing)
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType, ComparisonType.Equal));
	ListOfApArPostingDetail = New ValueList();
	ListOfApArPostingDetail.LoadValues(ArrayOfApArPostingDetail);
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ApArPostingDetail", ListOfApArPostingDetail,
		ComparisonType.InList));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	DocumentsClient.AgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

&AtClient
Procedure AgreementOnChange(Item, AddInfo = Undefined) Export
	TableName = Left(Item.Name, StrFind(Item.Name, "Agreement", SearchDirection.FromEnd) - 1);
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
EndProcedure

&AtClient
Procedure CustomersPaymentTermsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	CurrentData = Items.AccountReceivableByDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	NewRow = Object.CustomersPaymentTerms.Add();
	NewRow.Key = CurrentData.Key;
	NewRow.IsVisible = True;
EndProcedure

&AtClient
Procedure VendorsPaymentTermsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	CurrentData = Items.AccountPayableByDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	NewRow = Object.VendorsPaymentTerms.Add();
	NewRow.Key = CurrentData.Key;
	NewRow.IsVisible = True;
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsAfterDeleteRow(Item, AddInfo = Undefined) Export
	ArrayForDelete = New Array();
	For Each Row In Object.CustomersPaymentTerms Do
		If Not Object.AccountReceivableByDocuments.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.CustomersPaymentTerms.Delete(ItemForDelete);
	EndDo;
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsAfterDeleteRow(Item, AddInfo = Undefined) Export
	ArrayForDelete = New Array();
	For Each Row In Object.VendorsPaymentTerms Do
		If Not Object.AccountPayableByDocuments.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Object.VendorsPaymentTerms.Delete(ItemForDelete);
	EndDo;
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsOnActivateRow(Item, AddInfo = Undefined) Export
	CurrentData =  Items.AccountReceivableByDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	SetVisibleCustomersPaymentTerms(Object, ThisObject, CurrentData);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsOnActivateRow(Item, AddInfo = Undefined) Export
	CurrentData =  Items.AccountPayableByDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	SetVisibleVendorsPaymentTerms(Object, ThisObject, CurrentData);
EndProcedure

#Region SERVICE

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure EditCurrenciesAccountBalance(Command)
	CurrentData = ThisObject.Items.AccountBalance.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesFixedAssets(Command)
	CurrentData = ThisObject.Items.FixedAssets.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V11(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesCashInTransit(Command)
	CurrentData = ThisObject.Items.CashInTransit.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure EditCurrenciesEmployeeCashAdvance(Command)
	CurrentData = ThisObject.Items.EmployeeCashAdvance.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAdvanceFromRetailCustomers(Command)
	CurrentData = ThisObject.Items.AdvanceFromRetailCustomers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesSalaryPayment(Command)
	CurrentData = ThisObject.Items.SalaryPayment.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAdvanceFromCustomers(Command)
	CurrentData = ThisObject.Items.AdvanceFromCustomers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAdvanceToSuppliers(Command)
	CurrentData = ThisObject.Items.AdvanceToSuppliers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAccountReceivableByAgreements(Command)
	CurrentData = ThisObject.Items.AccountReceivableByAgreements.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAccountReceivableByDocuments(Command)
	CurrentData = ThisObject.Items.AccountReceivableByDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAccountReceivableOther(Command)
	CurrentData = ThisObject.Items.AccountReceivableOther.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure EditCurrenciesAccountPayableByAgreements(Command)
	CurrentData = ThisObject.Items.AccountPayableByAgreements.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAccountPayableByDocuments(Command)
	CurrentData = ThisObject.Items.AccountPayableByDocuments.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesAccountPayableOther(Command)
	CurrentData = ThisObject.Items.AccountPayableOther.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V4(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure EditCurrenciesReceiptFromConsignor(Command)
	CurrentData = ThisObject.Items.ReceiptFromConsignor.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V9(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesTaxesIncoming(Command)
	CurrentData = ThisObject.Items.TaxesIncoming.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V2(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditCurrenciesTaxesOutgoing(Command)
	CurrentData = ThisObject.Items.TaxesOutgoing.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V2(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

#Region PARTNER_TRADE_AGENT

&AtClient
Procedure PartnerTradeAgentOnChange(Item)
	ViewClient_V2.PartnerTradeAgentOnChange(Object, ThisObject, "ShipmentToTradeAgent");
EndProcedure

&AtClient
Procedure PartnerTradeAgentStartChoice(Item, ChoiceData, StandardProcessing)
	TransactionType = PredefinedValue("Enum.SalesTransactionTypes.ShipmentToTradeAgent");
	DocumentsClient.PartnerStartChoice_TransactionTypeFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, TransactionType);
EndProcedure

&AtClient
Procedure PartnerTradeAgentEditTextChange(Item, Text, StandardProcessing)
	TransactionType = PredefinedValue("Enum.SalesTransactionTypes.ShipmentToTradeAgent");
	DocumentsClient.PartnerTextChange_TransactionTypeFilter(Object, ThisObject, Item, Text, StandardProcessing, TransactionType);	
EndProcedure

#EndRegion

#Region LEGAL_NAME_TRADE_AGENT

&AtClient
Procedure LegalNameTradeAgentOnChange(Item)
	ViewClient_V2.LegalNameOnChange(Object, ThisObject, "ShipmentToTradeAgent");
EndProcedure

&AtClient
Procedure LegalNameTradeAgentStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.LegalNameStartChoice_PartnerFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PartnerTradeAgent);
EndProcedure

&AtClient
Procedure LegalNameTradeAgentEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.LegalNameTextChange_PartnerFilter(Object, ThisObject, Item, Text, StandardProcessing, Object.PartnerTradeAgent);
EndProcedure

#EndRegion

#Region AGREEMENT_TRADE_AGENT

&AtClient
Procedure AgreementTradeAgentOnChange(Item)
	ViewClient_V2.AgreementTradeAgentOnChange(Object, ThisObject, "ShipmentToTradeAgent");
EndProcedure

&AtClient
Procedure AgreementTradeAgentStartChoice(Item, ChoiceData, StandardProcessing)
	TransactionType = PredefinedValue("Enum.SalesTransactionTypes.ShipmentToTradeAgent");
	_Parameters = New Structure();
	_Parameters.Insert("Partner"   , Object.PartnerTradeAgent);
	_Parameters.Insert("Agreement" , Object.AgreementTradeAgent);
	_Parameters.Insert("LegalName" , Object.LegalNameTradeAgent);
	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, TransactionType, _Parameters);
EndProcedure

&AtClient
Procedure AgreementTradeAgentEditTextChange(Item, Text, StandardProcessing)
	TransactionType = PredefinedValue("Enum.SalesTransactionTypes.ShipmentToTradeAgent");
	_Parameters = New Structure();
	_Parameters.Insert("Partner"   , Object.PartnerTradeAgent);
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, ThisObject, Item, Text, StandardProcessing, TransactionType, _Parameters);
EndProcedure

#EndRegion

#Region PARTNER_CONSIGNOR

&AtClient
Procedure PartnerConsignorOnChange(Item)
	ViewClient_V2.PartnerConsignorOnChange(Object, ThisObject, "ReceiptFromConsignor");
EndProcedure

&AtClient
Procedure PartnerConsignorStartChoice(Item, ChoiceData, StandardProcessing)
	TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.ReceiptFromConsignor");
	DocumentsClient.PartnerStartChoice_TransactionTypeFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, TransactionType);	
EndProcedure

&AtClient
Procedure PartnerConsignorEditTextChange(Item, Text, StandardProcessing)
	TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.ReceiptFromConsignor");
	DocumentsClient.PartnerTextChange_TransactionTypeFilter(Object, ThisObject, Item, Text, StandardProcessing, TransactionType);	
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONSIGNOR

&AtClient
Procedure LegalNameConsignorOnChange(Item)
	ViewClient_V2.LegalNameOnChange(Object, ThisObject, "ReceiptFromConsignor");
EndProcedure

&AtClient
Procedure LegalNameConsignorStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.LegalNameStartChoice_PartnerFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PartnerConsignor);
EndProcedure

&AtClient
Procedure LegalNameConsignorEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.LegalNameTextChange_PartnerFilter(Object, ThisObject, Item, Text, StandardProcessing, Object.PartnerConsignor);
EndProcedure

#EndRegion

#Region AGREEMENT_CONSIGNOR

&AtClient
Procedure AgreementConsignorOnChange(Item)
	ViewClient_V2.AgreementConsignorOnChange(Object, ThisObject, "ReceiptFromConsignor");
EndProcedure

&AtClient
Procedure AgreementConsignorStartChoice(Item, ChoiceData, StandardProcessing)
	TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.ReceiptFromConsignor");
	_Parameters = New Structure();
	_Parameters.Insert("Partner"   , Object.PartnerConsignor);
	_Parameters.Insert("Agreement" , Object.AgreementConsignor);
	_Parameters.Insert("LegalName" , Object.LegalNameConsignor);
	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing, TransactionType, _Parameters);
EndProcedure

&AtClient
Procedure AgreementConsignorEditTextChange(Item, Text, StandardProcessing)
	TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.ReceiptFromConsignor");
	_Parameters = New Structure();
	_Parameters.Insert("Partner"   , Object.PartnerConsignor);
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, ThisObject, Item, Text, StandardProcessing, TransactionType, _Parameters);
EndProcedure

#EndRegion

#Region SHIPMENT_TO_TRADE_AGENT

&AtClient
Procedure ShipmentToTradeAgentBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	ViewClient_V2.ShipmentToTradeAgentBeforeAddRow(Object, ThisObject, Cancel, Clone);
EndProcedure

&AtClient
Procedure ShipmentToTradeAgentAfterDeleteRow(Item)
	ViewClient_V2.ShipmentToTradeAgentAfterDeleteRow(Object, ThisObject);
EndProcedure

#Region SHIPMENT_TO_TRADE_AGENT_COLUMNS

#Region _ITEM

&AtClient
Procedure ShipmentToTradeAgentItemOnChange(Item)
	ViewClient_V2.ShipmentToTradeAgentItemOnChange(Object, ThisObject, Undefined);
EndProcedure

&AtClient
Procedure ShipmentToTradeAgentItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.ItemListItemStartChoice_IsNotServiceFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ShipmentToTradeAgentItemEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.ItemListItemEditTextChange_IsNotServiceFilter(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _ITEM_KEY

&AtClient
Procedure ShipmentToTradeAgentItemKeyOnChange(Item)
	ViewClient_V2.ShipmentToTradeAgentItemKeyOnChange(Object, ThisObject, Undefined);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ShipmentToTradeAgentQuantityOnChange(Item)
	ViewClient_V2.ShipmentToTradeAgentQuantityOnChange(Object, ThisObject, Undefined);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBER

&AtClient
Procedure ShipmentToTradeAgentSerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items.ShipmentToTradeAgent.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SerialLotNumberClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);	
EndProcedure

&AtClient
Procedure ShipmentToTradeAgentSerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.ShipmentToTradeAgent.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);	
EndProcedure

#EndRegion

#Region SOURCE_OF_ORIGINS

&AtClient
Procedure ShipmentToTradeAgentSourceOfOriginStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items.ShipmentToTradeAgent.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SourceOfOriginClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure ShipmentToTradeAgentSourceOfOriginEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.ShipmentToTradeAgent.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SourceOfOriginClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region RECEIP_FROM_CONSIGNOR

&AtClient
Procedure ReceiptFromConsignorBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	ViewClient_V2.ReceiptFromConsignorBeforeAddRow(Object, ThisObject, Cancel, Clone);
EndProcedure

&AtClient
Procedure ReceiptFromConsignorAfterDeleteRow(Item)
	ViewClient_V2.ReceiptFromConsignorAfterDeleteRow(Object, ThisObject);
EndProcedure

#Region RECEIP_FROM_CONSIGNOR_COLUMNS

#Region _ITEM

&AtClient
Procedure ReceiptFromConsignorItemOnChange(Item)
	ViewClient_V2.ReceiptFromConsignorItemOnChange(Object, ThisObject, Undefined);
EndProcedure

&AtClient
Procedure ReceiptFromConsignorItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.ItemListItemStartChoice_IsNotServiceFilter(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ReceiptFromConsignorItemEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.ItemListItemEditTextChange_IsNotServiceFilter(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _ITEM_KEY

&AtClient
Procedure ReceiptFromConsignorItemKeyOnChange(Item)
	ViewClient_V2.ReceiptFromConsignorItemKeyOnChange(Object, ThisObject, Undefined);
EndProcedure

#EndRegion

#Region QUANTITY

&AtClient
Procedure ReceiptFromConsignorQuantityOnChange(Item)
	ViewClient_V2.ReceiptFromConsignorQuantityOnChange(Object, ThisObject, Undefined);
EndProcedure

#EndRegion

#Region PRICE

&AtClient
Procedure ReceiptFromConsignorPriceOnChange(Item)
	ViewClient_V2.ReceiptFromConsignorPriceOnChange(Object, ThisObject, Undefined);
EndProcedure

#EndRegion

#Region AMOUNT

&AtClient
Procedure ReceiptFromConsignorAmountOnChange(Item)
	ViewClient_V2.ReceiptFromConsignorAmountOnChange(Object, ThisObject, Undefined);
EndProcedure

#EndRegion

#Region SERIAL_LOT_NUMBER

&AtClient
Procedure ReceiptFromConsignorSerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items.ReceiptFromConsignor.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SerialLotNumberClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure ReceiptFromConsignorSerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.ReceiptFromConsignor.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

#EndRegion

#Region SOURCE_OF_ORIGIN

&AtClient
Procedure ReceiptFromConsignorSourceOfOriginStartChoice(Item, ChoiceData, StandardProcessing)
	CurrentData = Items.ReceiptFromConsignor.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SourceOfOriginClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure ReceiptFromConsignorSourceOfOriginEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.ReceiptFromConsignor.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item"    , CurrentData.Item);
	FormParameters.Insert("ItemKey" , CurrentData.ItemKey);

	SourceOfOriginClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

#EndRegion

#EndRegion

#EndRegion

MainTables = "AccountBalance, AdvanceFromCustomers, AdvanceToSuppliers,
		|AccountPayableByAgreements, AccountPayableByDocuments,
		|AccountReceivableByDocuments, AccountReceivableByAgreements,
		|Inventory,
		|ShipmentToTradeAgent, ReceiptFromConsignor,
		|EmployeeCashAdvance, AdvanceFromRetailCustomers, SalaryPayment, EmployeeList,
		|AccountReceivableOther, AccountPayableOther, CashInTransit, FixedAssets, TaxesIncoming, TaxesOutgoing";

