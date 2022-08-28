#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ChequeBonds");
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
	ViewClient_V2.CurrencyOnChange(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region STATUS
	
Procedure StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.FormName = "Catalog.ObjectStatuses.Form.ChoiceForm";
	OpenSettings.ArrayOfFilters = New Array;
	
	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
	Else
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
	EndIf;
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", Parent, DataCompositionComparisonType.InHierarchy));
	
	DocumentsClient.StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);																																
EndProcedure						

Procedure StatusEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	EditSettings = DocumentsClient.GetOpenSettingsStructure();

	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
	Else
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
	EndIf;
	
	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", Parent, DataCompositionComparisonType.InHierarchy));	
	
	DocumentsClient.StatusEditTextChange(Object, Form, Item, Text, StandardProcessing, EditSettings);
EndProcedure

#EndRegion

#Region CHEQUE_BONDS

Procedure ChequeBondsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ChequeBondsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ChequeBondsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ChequeBondsAfterDeleteRow(Object, Form);
EndProcedure

#Region CHEQUE_BONDS_COLUMNS

#Region CHEQUE

Procedure ChequeBondsChequeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsChequeOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsChequeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Currency", Object.Currency, DataCompositionComparisonType.Equal));
	
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.FormParameters.Insert("Currency", Object.Currency);
		OpenSettings.FormParameters.Insert("FilterByCurrency", True);
	EndIf;
	
	OpenSettings.FillingData = New Structure("Currency", Object.Currency);
	OpenSettings.FormName = "Catalog.ChequeBonds.ChoiceForm";
	
	DocumentsClient.OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsChequeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Currency"    , Object.Currency, ComparisonType.Equal));
	
	AdditionalParameters = New Structure();
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region NEW_STATUS

Procedure ChequeBondsNewStatusOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsNewStatusOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsNewStatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ChoiceData = New ValueList();
	For Each StatusRef In ObjectStatusesServer.GetAvailableStatusesByCheque(Object.Ref, CurrentData.Cheque) Do
		ChoiceData.Add(StatusRef, String(StatusRef));
	EndDo;
EndProcedure

Procedure ChequeBondsNewStatusEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	StandardProcessing = False;
	
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(Text) Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Filter_RefInList", True);
	AdditionalParameters.Insert("RefList", ObjectStatusesServer.GetAvailableStatusesByCheque(Object.Ref, CurrentData.Cheque));
	
	ArrayOfFilteredStatusRefs = ObjectStatusesServer.GetObjectStatusesChoiceDataTable(Text, ArrayOfFilters, AdditionalParameters);
	If Not ArrayOfFilteredStatusRefs.Count() Then
		Return;
	EndIf;
	
	ObjectStatusesClient.StatusEditTextChange(Form, Object, ArrayOfFilters, AdditionalParameters, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PARTNER

Procedure ChequeBondsPartnerOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsPartnerOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.ChequeBonds.CurrentData.LegalName) Then
		OpenSettings.FormParameters.Insert("Company", Form.Items.ChequeBonds.CurrentData.LegalName);
		OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Company", Form.Items.ChequeBonds.CurrentData.LegalName);
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.ChequeBonds.CurrentData.LegalName) Then
		AdditionalParameters.Insert("Company", Form.Items.ChequeBonds.CurrentData.LegalName);
		AdditionalParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure ChequeBondsLegalNameOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsLegalNameOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.ChequeBonds.CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Form.Items.ChequeBonds.CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Form.Items.ChequeBonds.CurrentData.Partner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.ChequeBonds.CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", Form.Items.ChequeBonds.CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region AGREEMENT

Procedure ChequeBondsAgreementOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsAgreementOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
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
	OpenSettings.FillingData.Insert("LegalName", CurrentData.LegalName);
	OpenSettings.FillingData.Insert("Company", Object.Company);

	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsAgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
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
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

Procedure ChequeBondsBasisDocumentOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsBasisDocumentOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;

	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure());
	If ValueIsFilled(CurrentData.LegalName) Then
		Parameters.Filter.Insert("LegalName", CurrentData.LegalName);
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);

	Parameters.Insert("FilterFromCurrentData", "Partner, Agreement");
	
	NotifyParameters = New Structure("Object, Form", Object, Form);
	Notify = New NotifyDescription("ChequeBondsBasisDocumentStartChoiceEnd", ThisObject, NotifyParameters);
	Parameters.Insert("Notify", Notify);
	
	IsPartnerCheque = ServiceSystemServer.GetObjectAttribute(CurrentData.Cheque, "Type")
		= PredefinedValue("Enum.ChequeBondTypes.PartnerCheque");
		
	If IsPartnerCheque Then
		// partner cheque
		Parameters.Insert("TableName", "DocumentsForIncomingPayment");
		Parameters.Insert("OpeningEntryTableName1", "AccountPayableByDocuments");
		Parameters.Insert("OpeningEntryTableName2", "AccountReceivableByDocuments");
		Parameters.Insert("DebitNoteTableName", "Transactions");
	Else
		// own cheque
		Parameters.Insert("TableName", "DocumentsForOutgoingPayment");
		Parameters.Insert("OpeningEntryTableName1", "AccountPayableByDocuments");
		Parameters.Insert("OpeningEntryTableName2", "AccountReceivableByDocuments");
		Parameters.Insert("CreditNoteTableName", "Transactions");
	EndIf;
	
	Parameters.Insert("Ref", Object.Ref);
	Parameters.Insert("IsReturnTransactionType", False);
	JorDocumentsClient.BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters);
EndProcedure

Procedure ChequeBondsBasisDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData <> Undefined Then
		ViewClient_V2.SetChequeBondsBasisDocument(Object, Form, CurrentData, Result.BasisDocument);
	EndIf;
EndProcedure

#EndRegion

#Region _ORDER

Procedure ChequeBondsOrderOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsOrderOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsOrderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;

	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure());
	If ValueIsFilled(CurrentData.LegalName) Then
		Parameters.Filter.Insert("LegalName", CurrentData.LegalName);
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);
	
	IsPartnerCheque = ServiceSystemServer.GetObjectAttribute(CurrentData.Cheque, "Type")
		= PredefinedValue("Enum.ChequeBondTypes.PartnerCheque");
	
	If IsPartnerCheque Then
		// partner cheque
		Parameters.Filter.Insert("Type", Type("DocumentRef.SalesOrder"));
		If ValueIsFilled(CurrentData.BasisDocument) 
			And TypeOf(CurrentData.BasisDocument) = Type("DocumentRef.SalesInvoice") Then
			Parameters.Filter.Insert("RefInList",
			DocumentsServer.GetArrayOfSalesOrdersBySalesInvoice(CurrentData.BasisDocument));
		EndIf;
	Else
		// own cheque
		Parameters.Filter.Insert("Type", Type("DocumentRef.PurchaseOrder"));
		If ValueIsFilled(CurrentData.BasisDocument) 
			And TypeOf(CurrentData.BasisDocument) = Type("DocumentRef.PurchaseInvoice") Then
			Parameters.Filter.Insert("RefInList",
			DocumentsServer.GetArrayOfPurchaseOrdersByPurchaseInvoice(CurrentData.BasisDocument));
		EndIf;
	EndIf;
	
	Parameters.Insert("FilterFromCurrentData", "Partner, Agreement");
	
	NotifyParameters = New Structure("Object, Form", Object, Form);
	Notify = New NotifyDescription("ChequeBondsOrderStartChoiceEnd", ThisObject, NotifyParameters);
	Parameters.Insert("Notify"    , Notify);
	
	If IsPartnerCheque Then
		Parameters.Insert("TableName" , "DocumentsForIncomingPayment");	
	Else
		Parameters.Insert("TableName" , "DocumentsForOutgoingPayment");	
	EndIf;
	
	Parameters.Insert("Ref"       , Object.Ref);
	Parameters.Insert("IsReturnTransactionType", False);
	JorDocumentsClient.BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters);
EndProcedure

Procedure ChequeBondsOrderStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData <> Undefined Then
		ViewClient_V2.SetChequeBondsOrder(Object, Form, CurrentData, Result.BasisDocument);
	EndIf;
EndProcedure

#EndRegion

#Region ACCOUNT

Procedure ChequeBondsAccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type"    , PredefinedValue("Enum.CashAccountTypes.Bank"), DataCompositionComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Currency", CurrentData.Currency                         , DataCompositionComparisonType.Equal));
	
	CommonFormActions.AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure ChequeBondsAccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Type"    , PredefinedValue("Enum.CashAccountTypes.Bank"), ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClient.CreateFilterItem("Currency", CurrentData.Currency                         , ComparisonType.Equal));

	CommonFormActions.AccountEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

Procedure ChequeBondsFinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFinancialMovementType", True,
		DataCompositionComparisonType.Equal));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	DocumentsClient.ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsFinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFinancialMovementType", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	DocumentsClient.ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
