#Region FORM

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
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

Procedure SenderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CashAccountTypes = New ValueList();
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Bank"));
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Cash"));
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountTypes, DataCompositionComparisonType.InList));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure SenderEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CashAccountTypes = New ValueList();
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Bank"));
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Cash"));
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountTypes, ComparisonType.InList));
	
	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
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

Procedure ReceiverStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CashAccountTypes = New ValueList();
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Bank"));
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Cash"));
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountTypes, DataCompositionComparisonType.InList));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure ReceiverEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CashAccountTypes = New ValueList();
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Bank"));
	CashAccountTypes.Add(PredefinedValue("Enum.CashAccountTypes.Cash"));
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountTypes, ComparisonType.InList));
	
	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
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

#Region CASH_ADVANCE_HOLDER

Procedure CashAdvanceHolderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure("Customer", True);
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CashAdvanceHolderTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
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
