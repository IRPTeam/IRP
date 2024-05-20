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
	ArrayOfFilters = New Array();
	
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance") Then
		AccountTypeList = New ValueList();
		AccountTypeList.Add(PredefinedValue("Enum.CashAccountTypes.Bank"));
		AccountTypeList.Add(PredefinedValue("Enum.CashAccountTypes.POS"));
		ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", AccountTypeList, DataCompositionComparisonType.InList));
	Else
		CashAccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
		If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS") Then
			CashAccountType = PredefinedValue("Enum.CashAccountTypes.POS");
		EndIf;
		ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountType, DataCompositionComparisonType.Equal));
	EndIf;
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance") Then
		AccountTypeList = New ValueList();
		AccountTypeList.Add(PredefinedValue("Enum.CashAccountTypes.Bank"));
		AccountTypeList.Add(PredefinedValue("Enum.CashAccountTypes.POS"));
		ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", AccountTypeList, ComparisonType.InList));
	Else
		CashAccountType = PredefinedValue("Enum.CashAccountTypes.Bank");
		If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS") Then
			CashAccountType = PredefinedValue("Enum.CashAccountTypes.POS");
		EndIf;
		ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", CashAccountType, ComparisonType.Equal));
	EndIf;
	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region TRANSIT_ACCOUNT

Procedure TransitAccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure TransitAccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Transit"), ComparisonType.Equal));

	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
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
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData    = New Structure();
	
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, DataCompositionComparisonType.Equal));
	Else
		If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payee) Then
			OpenSettings.FormParameters.Insert("Company", Form.Items.PaymentList.CurrentData.Payee);
			OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
		EndIf;
		OpenSettings.FillingData.Insert("Company", Form.Items.PaymentList.CurrentData.Payee);
	EndIf;
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	
	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance") Then
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, ComparisonType.Equal));
	Else
		If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payee) Then
			AdditionalParameters.Insert("Company", Form.Items.PaymentList.CurrentData.Payee);
			AdditionalParameters.Insert("FilterPartnersByCompanies", True);
		EndIf;
	EndIf;
	
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region PAYEE

Procedure PaymentListPayeeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListLegalNameOnChange(Object, Form, CurrentData);
EndProcedure

Procedure PaymentListPayeeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Form.Items.PaymentList.CurrentData.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPayeeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
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
	OpenSettings.Insert("Partner", CurrentData.Partner);
	OpenSettings.Insert("IncludeFilterByPartner", True);
	OpenSettings.Insert("IncludePartnerSegments", True);
	OpenSettings.Insert("EndOfUseDate", Object.Date);
	OpenSettings.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.Insert("LegalName", CurrentData.Payee);
	OpenSettings.Insert("Company", Object.Company);

	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.TransactionType, OpenSettings);
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
		
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, Object.TransactionType, AdditionalParameters);
		
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

	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance") Then
		Parameters = New Structure();
		Parameters.Insert("Filter", New Structure());
		Parameters.Filter.Insert("Partner", CurrentData.Partner);
		Parameters.Filter.Insert("DeletionMark", False);
		OpenForm("Document.EmployeeCashAdvance.ChoiceForm", Parameters, Item);
		Return;
	EndIf;
	
	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure());
	If ValueIsFilled(CurrentData.Payee) Then
		Parameters.Filter.Insert("LegalName", CurrentData.Payee);
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);

	Parameters.Insert("FilterFromCurrentData", "Partner, Agreement");
	
	NotifyParameters = New Structure("Object, Form", Object, Form);
	Notify = New NotifyDescription("PaymentListBasisDocumentStartChoiceEnd", ThisObject, NotifyParameters);
	Parameters.Insert("Notify", Notify);
	Parameters.Insert("TableName", "DocumentsForOutgoingPayment");
	Parameters.Insert("OpeningEntryTableName1", "AccountPayableByDocuments");
	Parameters.Insert("OpeningEntryTableName2", "AccountReceivableByDocuments");
	Parameters.Insert("CreditNoteTableName", "Transactions");
	Parameters.Insert("Ref", Object.Ref);
	Parameters.Insert("IsReturnTransactionType", 
		Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer")
		Or Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS"));
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
		If CurrentData.TotalAmount = 0 Then
			ViewClient_V2.SetPaymentListTotalAmount(Object, Form, CurrentData, Result.Amount);
		EndIf;
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
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Sender", Object.Account,
			DataCompositionComparisonType.Equal));
	EndIf;
		
	// Company
	If ValueIsFilled(Object.Company) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company", Object.Company,
			DataCompositionComparisonType.Equal));
	EndIf;
		
	// Currency
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("SendCurrency", Object.Currency,
			DataCompositionComparisonType.Equal));
	EndIf;

	If Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", True,
			DataCompositionComparisonType.Equal));

		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	ElsIf Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", False,
			DataCompositionComparisonType.Equal));

		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
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
		Parameters.Filter.Insert("LegalName", CurrentData.Payee);
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);
	Parameters.Filter.Insert("Type", Type("DocumentRef.PurchaseOrder"));
	
	If ValueIsFilled(CurrentData.BasisDocument) 
		And TypeOf(CurrentData.BasisDocument) = Type("DocumentRef.PurchaseInvoice") Then
		Parameters.Filter.Insert("RefInList",
		DocumentsServer.GetArrayOfPurchaseOrdersByPurchaseInvoice(CurrentData.BasisDocument));
	EndIf;
	
	Parameters.Insert("FilterFromCurrentData", "Partner, Agreement");
	
	NotifyParameters = New Structure("Object, Form", Object, Form);
	Notify = New NotifyDescription("PaymentListOrderStartChoiceEnd", ThisObject, NotifyParameters);
	Parameters.Insert("Notify"    , Notify);
	Parameters.Insert("TableName" , "DocumentsForOutgoingPayment");	
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

#Region VAT_RATE

Procedure PaymentListVatRateOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListVatRateOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region PAYMENT_TYPE

Procedure PaymentListPaymentTypeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListPaymentTypeOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region BANK_TERM

Procedure PaymentListBankTermOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.PaymentListBankTermOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion
