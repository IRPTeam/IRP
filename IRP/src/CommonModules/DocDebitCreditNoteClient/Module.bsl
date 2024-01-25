#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, Form.TabularSections);
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, Form.TabularSections);
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

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, Form.TabularSections);
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, Form.TabularSections);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.TransactionTypeOnChange(Object, Form, Form.TabularSections);
EndProcedure

#EndRegion

#Region PARTNER

Procedure PartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.PartnerOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	// filter - Customer
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, DataCompositionComparisonType.Equal));
	//OpenSettings.FormParameters = New Structure();
	//OpenSettings.FormParameters.Insert("Filter", New Structure("Customer", True));
	//OpenSettings.FillingData = New Structure("Customer", True);

	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	// filter - Customer
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, ComparisonType.Equal));
	
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.LegalNameOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure LegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		AdditionalParameters.Insert("Partner", Object.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure AgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.AgreementOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	// filter - Customer
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"), DataCompositionComparisonType.Equal));
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
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
	
	// filter - Customer
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	// filter - Customer
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"), ComparisonType.Equal));
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", Object.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region OFFSET_OF_ADVANCES_INVOICES

Procedure OffsetOfAdvancesInvoicesSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.OffsetOfAdvancesInvoicesSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure OffsetOfAdvancesInvoicesBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.OffsetOfAdvancesInvoicesBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure OffsetOfAdvancesInvoicesBeforeDeleteRow(Object, Form, Item, Cancel) Export
	Return;
EndProcedure

Procedure OffsetOfAdvancesInvoicesAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.OffsetOfAdvancesInvoicesAfterDeleteRow(Object, Form);
EndProcedure

#Region INVOICE

Procedure OffsetOfAdvancesInvoicesInvoiceOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.OffsetOfAdvancesInvoicesInvoiceOnChange(Object, Form, CurrentData);
EndProcedure

Procedure OffsetOfAdvancesInvoicesInvoiceStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
		
	Parameters = New Structure("Filter", New Structure());
	Parameters.Filter.Insert("Partner"   , Object.Partner);
	Parameters.Filter.Insert("Agreement" , Object.Agreement);
	Parameters.Filter.Insert("LegalName" , Object.LegalName);
	Parameters.Filter.Insert("Currency" , Object.Currency);
	
	Parameters.Insert("Ref", Object.Ref);
	
	Notify = New NotifyDescription("OffsetOfAdvancesInvoicesInvoiceStartChoiceEnd", 
		ThisObject, New Structure("Form, Object", Form, Object));
	OpenForm("Document.DebitCreditNote.Form.ChoiceInvoiceForm", 
		Parameters, Item, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

Procedure OffsetOfAdvancesInvoicesInvoiceStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = NotifyParameters.Form;
	Object = NotifyParameters.Object;
	CurrentData = Form.Items.OffsetOfAdvancesInvoices.CurrentData;
	If CurrentData <> Undefined Then
		ViewClient_V2.SetOffsetOfAdvancesInvoicesInvoice(Object, Form, CurrentData, Result.Invoice);
		ViewClient_V2.SetOffsetOfAdvancesInvoicesOrder(Object,   Form, CurrentData, Result.Order);
		ViewClient_V2.SetOffsetOfAdvancesInvoicesAmount(Object,  Form, CurrentData, Result.Amount);
	EndIf;
EndProcedure

#EndRegion

#Region ORDER

Procedure OffsetOfAdvancesInvoicesOrderOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.OffsetOfAdvancesInvoicesOrderOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region AMOUNT

Procedure OffsetOfAdvancesInvoicesAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.OffsetOfAdvancesInvoicesAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#Region OFFSET_OF_ADVANCES_PAYMANTS

Procedure OffsetOfAdvancesPaymentsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	Cancel = True;
	CurrentData = Form.Items.OffsetOfAdvancesInvoices.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	KeyOwner = CurrentData.Key;
	ViewClient_V2.OffsetOfAdvancesPaymentsBeforeAddRow(Object, Form, Cancel, Clone, Undefined, KeyOwner);
EndProcedure

#Region DOCUMENT

Procedure OffsetOfAdvancesPaymentsDocumentOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.OffsetOfAdvancesPaymentsDocumentOnChange(Object, Form, CurrentData);
EndProcedure

Procedure OffsetOfAdvancesPaymentsDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	CurrentData_Invoices = Form.Items.OffsetOfAdvancesInvoices.CurrentData;
	If CurrentData_Invoices = Undefined Then
		Return;
	EndIf;
		
	Parameters = New Structure("Filter", New Structure());
	Parameters.Filter.Insert("Partner"   , Object.Partner);
	Parameters.Filter.Insert("Agreement" , Object.Agreement);
	Parameters.Filter.Insert("LegalName" , Object.LegalName);
	Parameters.Filter.Insert("Currency"  , Object.Currency);
	Parameters.Filter.Insert("Order"     , CurrentData_Invoices.Order);
	
	
	Parameters.Insert("Ref", Object.Ref);
	
	Notify = New NotifyDescription("OffsetOfAdvancesPaymentsDocumentStartChoiceEnd", 
		ThisObject, New Structure("Form, Object", Form, Object));
	OpenForm("Document.DebitCreditNote.Form.ChoicePaymentDocumentForm", 
		Parameters, Item, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

Procedure OffsetOfAdvancesPaymentsDocumentStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = NotifyParameters.Form;
	Object = NotifyParameters.Object;
	CurrentData = Form.Items.OffsetOfAdvancesPayments.CurrentData;
	If CurrentData <> Undefined Then
		ViewClient_V2.SetOffsetOfAdvancesPaymentsDocument(Object, Form, CurrentData, Result.Document);
		ViewClient_V2.SetOffsetOfAdvancesPaymentsOrder(Object,    Form, CurrentData, Result.Order);
		ViewClient_V2.SetOffsetOfAdvancesPaymentsAmount(Object,   Form, CurrentData, Result.Amount);
	EndIf;
EndProcedure
		
#Endregion

#Region ORDER

Procedure OffsetOfAdvancesPaymentsOrderOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.OffsetOfAdvancesPaymentsOrderOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#Region AMOUNT

Procedure OffsetOfAdvancesPaymentsAmountOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.OffsetOfAdvancesPaymentsAmountOnChange(Object, Form, CurrentData);
EndProcedure

#EndRegion

#EndRegion

#Region SEND_PARTNER

Procedure SendPartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.SendPartnerOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure SendPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	// filter - Customer
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, DataCompositionComparisonType.Equal));
	//OpenSettings.FormParameters = New Structure();
	//OpenSettings.FormParameters.Insert("Filter", New Structure("Customer", True));
	//OpenSettings.FillingData = New Structure("Customer", True);

	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SendPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	// filter - Customer
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, ComparisonType.Equal));
	
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region SEND_LEGAL_NAME

Procedure SendLegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.SendLegalNameOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure SendLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SendLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		AdditionalParameters.Insert("Partner", Object.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region SEND_AGREEMENT

Procedure SendAgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.SendAgreementOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure SendAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	// filter - Customer
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"), DataCompositionComparisonType.Equal));
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
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
	
	// filter - Customer
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SendAgreementEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	// filter - Customer
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"), ComparisonType.Equal));
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", Object.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region SEND_DOCUMENTS

Procedure SendDocumentsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.SendDocumentsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure SendDocumentsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.SendDocumentsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure SendDocumentsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.SendDocumentsAfterDeleteRow(Object, Form);
EndProcedure

#EndRegion

#Region RECEIVE_PARTNER

Procedure ReceivePartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceivePartnerOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure ReceivePartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	// filter - Customer
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, DataCompositionComparisonType.Equal));
	//OpenSettings.FormParameters = New Structure();
	//OpenSettings.FormParameters.Insert("Filter", New Structure("Customer", True));
	//OpenSettings.FillingData = New Structure("Customer", True);

	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ReceivePartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	// filter - Customer
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, ComparisonType.Equal));
	
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region RECEIVE_LEGAL_NAME

Procedure ReceiveLegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveLegalNameOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure ReceiveLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ReceiveLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		AdditionalParameters.Insert("Partner", Object.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region RECEIVE_AGREEMENT

Procedure ReceiveAgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveAgreementOnChange(Object, Form, Form.TabularSections);
EndProcedure

Procedure ReceiveAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	// filter - Customer
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"), DataCompositionComparisonType.Equal));
	//OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
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
	
	// filter - Customer
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ReceiveAgreementEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	// filter - Customer
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", PredefinedValue("Enum.AgreementTypes.Customer"), ComparisonType.Equal));
	//ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", Object.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region RECEIVE_DOCUMENTS

Procedure ReceiveDocumentsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.ReceiveDocumentsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure ReceiveDocumentsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ReceiveDocumentsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ReceiveDocumentsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ReceiveDocumentsAfterDeleteRow(Object, Form);
EndProcedure

#EndRegion
