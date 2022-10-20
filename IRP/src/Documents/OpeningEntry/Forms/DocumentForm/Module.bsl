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

#EndRegion

#EndRegion

#Region ACCOUNT_BALANCE

&AtClient
Procedure AccountBalanceBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocOpeningEntryClient.AccountBalanceBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter)	
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
Procedure AccountReceivableByAgreementsOnActivateCell(Item)
	AccountByAgreementsMainTableOnActivateCell("AccountReceivableByAgreements", Item);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsOnActivateCell(Item)
	AccountByDocumentsMainTableOnActivateCell("AccountReceivableByDocuments", Item);
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
Function AccountByAgreementsMainTablePartnerOnChange(Item, AgreementType, ApArPostingDetail)
	TableName = StrReplace(Item.Name, "Partner", "");
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner", CurrentData.Partner);
	AgreementParameters.Insert("Agreement", CurrentData.Agreement);
	AgreementParameters.Insert("CurrentDate", Object.Date);

	AgreementParameters.Insert("ArrayOfFilters", New Array());
	AgreementParameters.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("Type", AgreementType, ComparisonType.Equal));
	AgreementParameters.ArrayOfFilters.Add(
	DocumentsClientServer.CreateFilterItem("ApArPostingDetail", ApArPostingDetail, ComparisonType.Equal));

	CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
	Return TableName;
EndFunction

&AtClient
Function AccountByDocumentsMainTablePartnerOnChange(Item, AgreementType, ApArPostingDetail)
	TableName = StrReplace(Item.Name, "Partner", "");
	CurrentData = Items[TableName].CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner", CurrentData.Partner);
	AgreementParameters.Insert("Agreement", CurrentData.Agreement);
	AgreementParameters.Insert("CurrentDate", Object.Date);
	AgreementParameters.Insert("PartnerType", AgreementType);
	AgreementParameters.Insert("ApArPostingDetail", ApArPostingDetail);
	AgreementParameters.Insert("ArrayOfFilters", New Array());

	CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	CurrentData.Currency = AgreementInfo.Currency;
	Return TableName;
EndFunction

&AtClient
Procedure AccountPayableByAgreementsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByAgreementsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Vendor"),
		PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure AccountReceivableByAgreementsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByAgreementsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Customer"),
		PredefinedValue("Enum.ApArPostingDetail.ByAgreements"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure AccountPayableByDocumentsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByDocumentsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Vendor"),
		PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
EndProcedure

&AtClient
Procedure AccountReceivableByDocumentsPartnerOnChange(Item, AddInfo = Undefined) Export
	TableName = AccountByDocumentsMainTablePartnerOnChange(Item, PredefinedValue("Enum.AgreementTypes.Customer"),
		PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
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
	DocumentsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
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
	CountLeftSymbols = 29;
	TableName  = Left("AccountReceivableByAgreementsAgreement", CountLeftSymbols);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", TableName);
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
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion

MainTables = "AccountBalance, AdvanceFromCustomers, AdvanceToSuppliers,
		|AccountPayableByAgreements, AccountPayableByDocuments,
		|AccountReceivableByDocuments, AccountReceivableByAgreements,
		|Inventory";

