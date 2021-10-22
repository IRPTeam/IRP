#Region FormEvents

Procedure OnOpen(Object, Form, Cancel) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

#EndRegion

#Region FormItemsEvents

Procedure DateOnChange(Object, Form, Item) Export

#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
#EndIf

EndProcedure

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Item);
EndProcedure

Function CompanySettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, CalculateSettings");
	Actions = New Structure();
	Actions.Insert("ChangeAccount", "ChangeAccount");
	Settings.Insert("TableName", "PaymentList");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Account";
	Settings.FormAttributes = "";
	Actions = GetCalculateRowsActions();
	Actions.Delete("CalculateTaxByTotalAmount");
	Actions.Delete("CalculateNetAmountByTotalAmount");
	Settings.CalculateSettings = Actions;
	Return Settings;
EndFunction

#EndRegion

#Region AccountEvents

Procedure AccountOnChange(Object, Form, Item = Undefined) Export

	CurrencyBeforeChange = Form.Currency;
	AccountBeforeChange = Form.CurrentAccount;

	Form.Currency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");

	If Not ValueIsFilled(Form.Currency) Then
		Form.CurrentAccount = Object.Account;

		Return;
	EndIf;

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Form", Form);
	AdditionalParameters.Insert("Object", Object);
	AdditionalParameters.Insert("CurrencyBeforeChange", CurrencyBeforeChange);
	AdditionalParameters.Insert("AccountBeforeChange", AccountBeforeChange);
	AdditionalParameters.Insert("Item", Item);

	If Form.Currency <> CurrencyBeforeChange And Object.PaymentList.Count() Then
		ShowQueryBox(New NotifyDescription("AccountOnChangeContinue", ThisObject, AdditionalParameters),
			R().QuestionToUser_006, QuestionDialogMode.YesNo);
	EndIf;

#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
#EndIf

EndProcedure

Procedure AccountOnChangeContinue(Result, AdditionalParameters) Export

	Object = AdditionalParameters.Object;
	Form = AdditionalParameters.Form;

	If Result = DialogReturnCode.No Then
		Form.Currency		= AdditionalParameters.CurrencyBeforeChange;
		Form.CurrentAccount	= AdditionalParameters.AccountBeforeChange;
		Object.Account		= AdditionalParameters.AccountBeforeChange;
	ElsIf Result = DialogReturnCode.Yes Then
		Form.CurrentAccount = AdditionalParameters.Object.Account;
		For Each RowPaymentList In AdditionalParameters.Object.PaymentList Do
			RowPaymentList.Currency = Form.Currency;
		EndDo;
	Else
		Raise R().Error_032;
	EndIf;
	Notify("CallbackHandler", Undefined, Form);
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
		"Enum.CashAccountTypes.Transit"), , DataCompositionComparisonType.NotEqual));
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Cash"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
		"Enum.CashAccountTypes.Transit"), ComparisonType.NotEqual));
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

#EndRegion

#Region PaymentListEvents

Procedure PaymentListOnStartEdit(Object, Form, Item, NewRow, Clone) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If Clone Then
		CurrentData.Key = New UUID();

		Settings = New Structure();
		Actions = New Structure("CalculateTax");
		Settings.Insert("Actions", Actions);
		Rows = New Array();
		Rows.Add(CurrentData);
		Settings.Insert("Rows", Rows);
		CalculateItemsRows(Object, Form, Settings);
		Return;
	EndIf;
EndProcedure

Procedure PaymentListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	If Clone Then
		Return;
	EndIf;
	Cancel = True;
	NewRow = Object.PaymentList.Add();
	Form.Items.PaymentList.CurrentRow = NewRow.GetID();
	UserSettingsClient.FillingRowFromSettings(Object, "Object.PaymentList", NewRow, True);
	NewRow.Currency = Form.Currency;
	Form.Items.PaymentList.ChangeRow();
	PaymentListOnChange(Object, Form, Item);
EndProcedure

Procedure PaymentListOnChange(Object, Form, Item) Export
	For Each Row In Object.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

Procedure PaymentListAfterDeleteRow(Object, Form, Item) Export
	CalculationStringsClientServer.ClearDependentData(Object, New Structure("TableParent", "PaymentList"));
	Form.Taxes_CreateTaxTree();
EndProcedure

Procedure PaymentListCurrencyOnChange(Object, Form) Export

	CurrentData = Form.Items.PaymentList.CurrentData;

	If CurrentData = Undefined Then
		Return;
	EndIf;

EndProcedure

Procedure PaymentListNetAmountOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Settings = New Structure();
	Actions = GetCalculateRowsActions();
	Actions.Delete("CalculateTaxByTotalAmount");
	Actions.Delete("CalculateNetAmountByTotalAmount");
	Settings.Insert("Actions", Actions);
	Rows = New Array();
	Rows.Add(CurrentData);
	Settings.Insert("Rows", Rows);
	CalculateItemsRows(Object, Form, Settings);
EndProcedure

Procedure PaymentListTotalAmountOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Settings = New Structure();
	Actions = GetCalculateRowsActions();
	Actions.Delete("CalculateTotalAmountByNetAmount");
	Actions.Delete("CalculateTaxByNetAmount");

	Settings.Insert("Actions", Actions);
	Rows = New Array();
	Rows.Add(CurrentData);
	Settings.Insert("Rows", Rows);
	CalculateItemsRows(Object, Form, Settings);
EndProcedure

Function GetCalculateRowsActions() Export
	Actions = New Structure();
	Actions.Insert("CalculateTaxByTotalAmount");
	Actions.Insert("CalculateTaxByNetAmount");
	Actions.Insert("CalculateTotalAmountByNetAmount");
	Actions.Insert("CalculateNetAmountByTotalAmount");
	Return Actions;
EndFunction

Procedure CalculateItemsRows(Object, Form, Settings) Export
	CalculationStringsClientServer.CalculateItemsRows(Object, Form, Settings.Rows, Settings.Actions,
		TaxesClient.GetArrayOfTaxInfo(Form));
EndProcedure

Function GetArrayOfTaxInfo(Form) Export
	SavedData = TaxesClientServer.GetSavedData(Form, TaxesServer.GetAttributeNames().CacheName);
	If SavedData.Property("ArrayOfColumnsInfo") Then
		Return SavedData.ArrayOfColumnsInfo;
	EndIf;
	Return New Array();
EndFunction

Function CurrencySettings(Object, Form, AddInfo = Undefined) Export
	Return New Structure();
EndFunction

#Region FinancialMovementType

Procedure PaymentListFinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListFinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ExpenseType

Procedure PaymentListExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region RevenueType

Procedure PaymentListRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.RevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.RevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

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
