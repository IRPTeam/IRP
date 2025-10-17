#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	AddNewSingleRow(Object, Form);
	ViewClient_V2.OnOpen(Object, Form, "PaymentList");
EndProcedure

Procedure AddNewSingleRow(Object, Form)
	If Object.DetailsByRow Then
		If Object.PaymentList.Count() = 0 Then
			NewRowCancel = False;
			ViewClient_V2.PaymentListBeforeAddRow(Object, Form, NewRowCancel, False);
		EndIf;
	EndIf;	
EndProcedure

#EndRegion

#Region DETAILS_BY_ROW

Procedure DetailsByRowOnChange(Object, Form, Item) Export
	AddNewSingleRow(Object, Form);
	ViewClient_V2.DetailsByRowOnChange(Object, Form, "PaymentList");
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

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "PaymentList");
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure AccountOnChange(Object, Form, Item) Export
	ViewClient_V2.CashAccountOnChange(Object, Form, "PaymentList");
EndProcedure

Function GetCashAccountTypeByTransaction(TransactionType)
	CashAccountType = PredefinedValue("Enum.CashAccountTypes.Cash");
	If TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn") Then
		CashAccountType = PredefinedValue("Enum.CashAccountTypes.POSCashAccount");
	EndIf;
	Return CashAccountType;
EndFunction

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Cash"), DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type", PredefinedValue("Enum.CashAccountTypes.Cash"), ComparisonType.Equal));

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

Procedure PaymentListPartnerOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListPartnerOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

Procedure PaymentListPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData    = New Structure();
	
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, DataCompositionComparisonType.Equal));
	Else
		If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, DataCompositionComparisonType.Equal));
		EndIf;
		
		If CurrentData = Undefined Then
			CurrentData = Form.Items.PaymentList.CurrentData;
		EndIf;
		
		If ValueIsFilled(CurrentData.LegalName) Then
			OpenSettings.FormParameters.Insert("Company", CurrentData.LegalName);
			OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
		EndIf;
		OpenSettings.FillingData.Insert("Company", CurrentData.LegalName);
	EndIf;
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, CurrentData = Undefined) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance") Then
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, ComparisonType.Equal));
	Else
		If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
			ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Employee", True, ComparisonType.Equal));
		EndIf;
		
		If CurrentData = Undefined Then
			CurrentData = Form.Items.PaymentList.CurrentData;
		EndIf;
		
		If ValueIsFilled(CurrentData.LegalName) Then
			AdditionalParameters.Insert("Company", CurrentData.LegalName);
			AdditionalParameters.Insert("FilterPartnersByCompanies", True);
		EndIf;
	EndIf;
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure PaymentListLegalNameOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListLegalNameOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

Procedure PaymentListLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	
	If CurrentData = Undefined Then
			CurrentData = Form.Items.PaymentList.CurrentData;
		EndIf;
		
	If ValueIsFilled(CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", CurrentData.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PaymentListLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing, CurrentData = Undefined) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;
		
	If ValueIsFilled(CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure PaymentListAgreementOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListAgreementOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;

	Parameters = New Structure();
	Parameters.Insert("Partner"  , CurrentData.Partner);
	Parameters.Insert("LegalName", CurrentData.LegalName);
	Parameters.Insert("Company"  , Object.Company);

	DocumentsClient.AgreementStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, Object.TransactionType, Parameters);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing, CurrentData = Undefined) Export
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;

	Parameters = New Structure();
	Parameters.Insert("Partner", CurrentData.Partner);
	
	DocumentsClient.AgreementTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, Object.TransactionType, Parameters);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

Procedure PaymentListBasisDocumentOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListBasisDocumentOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

Procedure PaymentListBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	StandardProcessing = False;
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("CurrentData", CurrentData);
	
	Notify = New CallbackDescription("PaymentListBasisDocumentStartChoiceEnd", ThisObject, NotifyParameters);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Branch", Object.Branch);
	FormParameters.Insert("Partner", CurrentData.Partner);
	FormParameters.Insert("Agreement", CurrentData.Agreement);
	FormParameters.Insert("LegalName", CurrentData.LegalName);
	FormParameters.Insert("TransactionType", Object.TransactionType);
	FormParameters.Insert("Date", Object.Date);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("Document", CurrentData.BasisDocument);
		
	OpenForm("CommonForm.ChoicePaymentBasis", FormParameters, Form,,,,Notify,FormWindowOpeningMode.LockOwnerWindow); 
EndProcedure

Procedure PaymentListBasisDocumentStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = NotifyParameters.Form;
	Object = NotifyParameters.Object;
	CurrentData = NotifyParameters.CurrentData;
	If CurrentData <> Undefined Then
		ViewClient_V2.SetPaymentListBasisDocument(Object, Form, CurrentData, Result.BasisDocument);
		If CurrentData.TotalAmount = 0 Then
			ViewClient_V2.SetPaymentListTotalAmount(Object, Form, CurrentData, Result.Amount);
		EndIf;
		Form.FormUpdateFormAttributes("FromListToHeader");
	EndIf;
EndProcedure

#EndRegion

#Region PLANNING_TRANSACTION_BASIS

Procedure PaymentListPlaningTransactionBasisOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListPlanningTransactionBasisOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

Procedure PaymentListTransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
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
	OpenSettings.ArrayOfFilters.Add(
		DocumentsClientServer.CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	
	// CashAccount
	If ValueIsFilled(Object.CashAccount) Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("Receiver", Object.CashAccount, DataCompositionComparisonType.Equal));
	EndIf;

	// Company
	If ValueIsFilled(Object.Company) Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	// Currency
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("ReceiveCurrency", Object.Currency, DataCompositionComparisonType.Equal));
	EndIf;

	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", True, DataCompositionComparisonType.Equal));

		If ValueIsFilled(Object.CurrencyExchange) Then
			OpenSettings.ArrayOfFilters.Add(
				DocumentsClientServer.CreateFilterItem("SendCurrency", Object.CurrencyExchange, DataCompositionComparisonType.Equal));
		EndIf;

		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	ElsIf Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder") Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", False, DataCompositionComparisonType.Equal));

		If ValueIsFilled(Object.Currency) Then
			OpenSettings.ArrayOfFilters.Add(
				DocumentsClientServer.CreateFilterItem("ReceiveCurrency", Object.Currency, DataCompositionComparisonType.Equal));
		EndIf;
		
		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	EndIf;
EndProcedure

#EndRegion

#Region MONEY_TRANSFER

Procedure PaymentListMoneyTransferOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListMoneyTransferOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

Procedure PaymentListMoneyTransferStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;

	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("OwnerRef", Object.Ref);
	
	ArrayOfSelectedDocuments = New Array();
	For Each Row In Object.PaymentList Do
		ArrayOfSelectedDocuments.Add(Row.MoneyTransfer);
	EndDo;
	OpenSettings.FormParameters.Insert("ArrayOfSelectedDocuments", ArrayOfSelectedDocuments);

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(
		DocumentsClientServer.CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	
	// CashAccount
	If ValueIsFilled(Object.CashAccount) Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("Receiver", Object.CashAccount, DataCompositionComparisonType.Equal));
	EndIf;

	// Company
	If ValueIsFilled(Object.Company) Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	// Currency
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.ArrayOfFilters.Add(
			DocumentsClientServer.CreateFilterItem("ReceiveCurrency", Object.Currency, DataCompositionComparisonType.Equal));
	EndIf;
	
	DocumentsClient.MoneyTransferStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

#EndRegion

#Region _ORDER

Procedure PaymentListOrderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	StandardProcessing = False;
	If CurrentData = Undefined Then
		CurrentData = Form.Items.PaymentList.CurrentData;
	EndIf;

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("CurrentData", CurrentData);
	
	Notify = New CallbackDescription("PaymentListOrderStartChoiceEnd", ThisObject, NotifyParameters);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Partner", CurrentData.Partner);
	FormParameters.Insert("LegalName", CurrentData.LegalName);
	FormParameters.Insert("Agreement", CurrentData.Agreement);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("IsOrder", True);
	FormParameters.Insert("Document", CurrentData.Order);
		
	OpenForm("CommonForm.ChoiceTransactionBasis", FormParameters, Form,,,,Notify,FormWindowOpeningMode.LockOwnerWindow); 
EndProcedure

Procedure PaymentListOrderStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	CurrentData = AdditionalParameters.CurrentData;
	If CurrentData <> Undefined Then		
		ViewClient_V2.SetPaymentListOrder(Object, Form, CurrentData, Result.BasisDocument);
	EndIf;
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

Procedure PaymentListMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, CurrentData = Undefined) Export
	DocumentsClient.FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure PaymentListMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, CurrentData = Undefined) Export
	DocumentsClient.FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region NET_AMOUNT

Procedure PaymentListNetAmountOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListNetAmountOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

Procedure PaymentListTotalAmountOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListTotalAmountOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

Procedure ItemListTaxAmountOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListTaxAmountOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

#EndRegion

#Region VAT_RATE

Procedure PaymentListVatRateOnChange(Object, Form, Item, CurrentData = Undefined, FormAttributeUpdateDirection = Undefined) Export
	ViewClient_V2.PaymentListVatRateOnChange(Object, Form, CurrentData, FormAttributeUpdateDirection);
EndProcedure

#EndRegion

#EndRegion

#Region WORKSTATION

Procedure WorkstationOnChange(Object, Form, Item) Export
	ViewClient_V2.WorkstationOnChange(Object, Form, "PaymentList");
EndProcedure

#EndRegion