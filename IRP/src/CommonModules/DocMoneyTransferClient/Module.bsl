#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "");
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False,
		DataCompositionComparisonType.Equal));
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

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region ACCOUNT_SENDER

Procedure SenderOnChange(Object, Form, Item) Export
	ViewClient_V2.AccountSenderOnChange(Object, Form);
EndProcedure

Procedure SenderEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	AccountTypes = New ValueList();
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Transit"));
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.POS"));
	FilterItem = DocumentsClientServer.CreateFilterItem("Type", AccountTypes, ComparisonType.NotInList);
	EditTextParameters.Filters.Add(FilterItem);
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

Procedure SenderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	AccountTypes = New ValueList();
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Transit"));
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.POS"));
	FilterItem = DocumentsClientServer.CreateFilterItem("Type", AccountTypes, , DataCompositionComparisonType.NotInList);
	StartChoiceParameters.CustomParameters.Filters.Add(FilterItem);
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

#EndRegion

#Region CURRENCY_SEND

Procedure SendCurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.SendCurrencyOnChange(Object, Form);
EndProcedure

#EndRegion

#Region AMOUNT_SEND

Procedure SendAmountOnChange(Object, Form, Item) Export
	ViewClient_V2.SendAmountOnChange(Object, Form);
EndProcedure

#EndRegion

#Region ACCOUNT_RECEIVER

Procedure ReceiverOnChange(Object, Form, Item) Export
	ViewClient_V2.AccountReceiverOnChange(Object, Form);
EndProcedure

Procedure ReceiverEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	AccountTypes = New ValueList();
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Transit"));
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.POS"));
	FilterItem = DocumentsClientServer.CreateFilterItem("Type", AccountTypes, ComparisonType.NotInList);
	EditTextParameters.Filters.Add(FilterItem);
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

Procedure ReceiverStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	AccountTypes = New ValueList();
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Transit"));
	AccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.POS"));
	FilterItem = DocumentsClientServer.CreateFilterItem("Type", AccountTypes, , DataCompositionComparisonType.NotInList);
	StartChoiceParameters.CustomParameters.Filters.Add(FilterItem);
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

#EndRegion

#Region CURRENCY_RECEIVE

Procedure ReceiveCurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveCurrencyOnChange(Object, Form);
EndProcedure

#EndRegion

#Region AMOUNT_RECEIVE

Procedure ReceiveAmountOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveAmountOnChange(Object, Form);
EndProcedure

#EndRegion

#Region CASH_TRANSFER_ORDER

Procedure CashTransferOrderOnChange(Object, Form, Item) Export
	ViewClient_V2.CashTransferOrderOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

Procedure FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region SERVICE

#Region DESCRIPTION

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
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

#EndRegion
