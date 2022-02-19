#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure AccountOnChange(Object, Form, Item) Export
	ViewClient_V2.AccountOnChange(Object, Form, "PaymentList");
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

#Region PAYMENT_LIST

Procedure PaymentListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export
	If Upper(Field.Name) = Upper("PaymentListTaxAmount") Then
		CurrentData = Form.Items.PaymentList.CurrentData;
		If CurrentData <> Undefined Then
			DocumentsClient.ItemListSelectionPutServerDataToAddInfo(Object, Form, AddInfo);
			Parameters = New Structure();
			Parameters.Insert("CurrentData", CurrentData);
			Parameters.Insert("Item", Item);
			Parameters.Insert("Field", Field);
			TaxesClient.ChangeTaxAmount(Object, Form, Parameters, StandardProcessing, AddInfo);
		EndIf;
	EndIf;
EndProcedure

Procedure PaymentListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.PaymentListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure PaymentListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.PaymentListAfterDeleteRow(Object, Form);
EndProcedure

#Region EXPENSE_TYPE

Procedure PaymentListExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

Procedure PaymentListRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.RevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.RevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

Procedure PaymentListFinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListFinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region DONT_CALCULATE_ROW

Procedure PaymentListDontCalculateRowOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListDontCalculateRowOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region NET_AMOUNT

Procedure PaymentListNetAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListNetAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

Procedure PaymentListTotalAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListTotalAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

Procedure ItemListTaxAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListTaxAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region TAX_RATE

Procedure ItemListTaxValueOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListTaxRateOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

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
