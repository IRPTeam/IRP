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

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False, DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, DataCompositionComparisonType.Equal));
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

#Region CURRENCY
	
Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure AccountOnChange(Object, Form, Item) Export
	ViewClient_V2.AccountOnChange(Object, Form, "PaymentList");
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CashAccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS") Then
		CashAccountType = PredefinedValue("Enum.CashAccountTypes.POS");
	EndIf;

	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountType, DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);

// for delete
//	StandardProcessing = False;
//	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
//	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	
	
//	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", 
//		CashAccountType, , DataCompositionComparisonType.Equal));
//	StartChoiceParameters.FillingData.Insert("Type", CashAccountType);
//	
//	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
	
//	OpeningSettings = DocumentsClient.GetOpenSettingsStructure();
//	OpeningSettings.FormName = "Catalog.CashAccounts.Form.ChoiceForm";
//	OpeningSettings.FormParameters = New Structure();
//	OpeningSettings.ArrayOfFilters = New Array();
//	OpeningSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False, DataCompositionComparisonType.Equal));
//	OpeningSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
//	OpeningSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", CashAccountType, DataCompositionComparisonType.Equal));
//	OpeningSettings.FillingData = New Structure("Type", CashAccountType);
//	
//	DocumentsClient.SetCurrentRow(Object, Form, Item, OpeningSettings.FormParameters, "Ref");
//	DocumentsClient.OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpeningSettings);
	
	//DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CashAccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS") Then
		CashAccountType = PredefinedValue("Enum.CashAccountTypes.POS");
	EndIf;

	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountType, ComparisonType.Equal));

	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);


// for remove
//	DefaultEditTextParameters = New Structure("Company", Object.Company);
//	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
		
//	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", CashAccountType, ComparisonType.Equal));
//	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
//	
//	ArrayOfFilters = New Array();
//	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
//	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company", Object.Company, ComparisonType.Equal));
//	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", CashAccountType, ComparisonType.Equal));
//	//AdditionalParameters = New Structure();
//	
//	ArrayOfChoiceParameters = New Array();
//	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
//	//ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
//	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region TRANSIT_ACCOUNT

Procedure TransitAccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
	
	// for remove
//	StandardProcessing = False;
//	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
//	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
//	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
//		"Enum.CashAccountTypes.Transit"), , DataCompositionComparisonType.Equal));
//	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Transit"));
//	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

Procedure TransitAccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), ComparisonType.Equal));

	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
	
	// for remove	
//	DefaultEditTextParameters = New Structure("Company", Object.Company);
//	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
//	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue(
//		"Enum.CashAccountTypes.Transit"), ComparisonType.Equal));
//	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.TransactionTypeOnChange(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region PAYMENT_LIST

Procedure PaymentListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.PaymentListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure PaymentListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.PaymentListBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure PaymentListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.PaymentListAfterDeleteRow(Object, Form);
EndProcedure

#Region PARTNER

Procedure PaymentListPartnerOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListPartnerOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentListPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payer) Then
		OpenSettings.FormParameters.Insert("Company", Form.Items.PaymentList.CurrentData.Payer);
		OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Company", Form.Items.PaymentList.CurrentData.Payer);
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payer) Then
		AdditionalParameters.Insert("Company", Form.Items.PaymentList.CurrentData.Payer);
		AdditionalParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region PAYER

Procedure PaymentListPayerOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListLegalNameOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentListPayerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Form.Items.PaymentList.CurrentData.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPayerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure PaymentListAgreementOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListAgreementOnChange(Object, Form, CurrentData);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue(
		"Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner", CurrentData.Partner);
	OpenSettings.FillingData.Insert("LegalName", CurrentData.Payer);
	OpenSettings.FillingData.Insert("Company", Object.Company);

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"),
		ComparisonType.NotEqual));

	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

Procedure PaymentListBasisDocumentOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListBasisDocumentOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentListBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;

	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure());
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payer) Then
		Parameters.Filter.Insert("LegalName", Form.Items.PaymentList.CurrentData.Payer);
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);

	Parameters.Insert("FilterFromCurrentData", "Partner, Agreement");
	
	NotifyParameters = New Structure("Object, Form", Object, Form);
	Notify = New NotifyDescription("PaymentListBasisDocumentStartChoiceEnd", ThisObject, NotifyParameters);
	Parameters.Insert("Notify", Notify);
	Parameters.Insert("TableName", "DocumentsForIncomingPayment");
	Parameters.Insert("OpeningEntryTableName1", "AccountPayableByDocuments");
	Parameters.Insert("OpeningEntryTableName2", "AccountReceivableByDocuments");
	Parameters.Insert("DebitNoteTableName", "Transactions");
	Parameters.Insert("Ref", Object.Ref);
	Parameters.Insert("IsReturnTransactionType", 
		Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor"));
	JorDocumentsClient.BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters);
EndProcedure

Procedure PaymentListBasisDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData <> Undefined Then
		ViewClient_V2.SetPaymentListBasisDocument(Object, Form, CurrentData, Result.BasisDocument);
		ViewClient_V2.SetPaymentListTotalAmount(Object, Form, CurrentData, Result.Amount);
	EndIf;
EndProcedure

#EndRegion

#Region PLANNING_TRANSACTION_BASIS

Procedure PaymentListPlaningTransactionBasisOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListPlanningTransactionBasisOnChange(Object, Form, CurrentData);
EndProcedure

Procedure TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("OwnerRef", Object.Ref);
	
	ArrayOfSelectedDocuments = New Array();
	For Each Row In Object.PaymentList Do
		ArrayOfSelectedDocuments.Add(Row.PlaningTransactionBasis);
	EndDo;
	OpenSettings.FormParameters.Insert("ArrayOfSelectedDocuments", ArrayOfSelectedDocuments);
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Posted", True,
		DataCompositionComparisonType.Equal));
	
	// Account
	If ValueIsFilled(Object.Account) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Receiver", Object.Account,
			DataCompositionComparisonType.Equal));
	EndIf;

	// Company
	If ValueIsFilled(Object.Company) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company", Object.Company,
			DataCompositionComparisonType.Equal));
	EndIf;
	
	// Currency
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ReceiveCurrency", Object.Currency,
			DataCompositionComparisonType.Equal));
	EndIf;

	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", True,
			DataCompositionComparisonType.Equal));

		If ValueIsFilled(Object.CurrencyExchange) Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("SendCurrency",
				Object.CurrencyExchange, DataCompositionComparisonType.Equal));
		EndIf;

		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	ElsIf Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", False,
			DataCompositionComparisonType.Equal));
			
		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	ElsIf Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS") Then
		StandardProcessing = False;
		FormParameters = New Structure();
		FormParameters.Insert("Company"    , Object.Company);
		FormParameters.Insert("Branch"     , Object.Branch);
		FormParameters.Insert("POSAccount" , CurrentData.POSAccount);
		OpenForm("Document.CashStatement.Form.ChoiceWIthBalancesForm", FormParameters, Item, , , , , FormWindowOpeningMode.LockOwnerWindow);
	EndIf;
EndProcedure

#EndRegion

#Region _ORDER

Procedure PaymentListOrderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;

	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure());
	If ValueIsFilled(CurrentData.Payee) Then
		Parameters.Filter.Insert("LegalName", CurrentData.Payer);
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);
	Parameters.Filter.Insert("Type", Type("DocumentRef.SalesOrder"));
	
	If ValueIsFilled(CurrentData.BasisDocument) 
		And TypeOf(CurrentData.BasisDocument) = Type("DocumentRef.SalesInvoice") Then
		Parameters.Filter.Insert("RefInList",
		DocumentsServer.GetArrayOfSalesOrdersBySalesInvoice(CurrentData.BasisDocument));
	EndIf;
	
	Parameters.Insert("FilterFromCurrentData", "Partner, Agreement");
	
	NotifyParameters = New Structure("Object, Form", Object, Form);
	Notify = New NotifyDescription("PaymentListOrderStartChoiceEnd", ThisObject, NotifyParameters);
	Parameters.Insert("Notify"    , Notify);
	Parameters.Insert("TableName" , "DocumentsForIncomingPayment");	
	Parameters.Insert("Ref"       , Object.Ref);
	Parameters.Insert("IsReturnTransactionType", False);
	JorDocumentsClient.BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters);
EndProcedure

Procedure PaymentListOrderStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData <> Undefined Then
		
		ViewClient_V2.SetPaymentListOrder(Object, Form, CurrentData, Result.BasisDocument);
		If Not ValueIsFilled(CurrentData.BasisDocument) Then
			ViewClient_V2.SetPaymentListTotalAmount(Object, Form, CurrentData, Result.Amount);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

Procedure PaymentListExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
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

#Region COMMISSION

&AtClient
Procedure PaymentListCommissionOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListCommissionOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region PAYMENT_TYPE

&AtClient
Procedure PaymentListPaymentTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListPaymentTypeOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region BANK_TERM

&AtClient
Procedure PaymentListBankTermOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListBankTermOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region COMMISSION_PERCENT

&AtClient
Procedure PaymentListCommissionPercentOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListCommissionPercentOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion
