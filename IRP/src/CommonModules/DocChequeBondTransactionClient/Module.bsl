#Region FormEvents

Procedure OnOpen(Object, Form, Cancel) Export
	Form.CurrentCompany = Object.Company;
	DocumentsClient.OnOpen(Object, Form, Cancel);
EndProcedure

Procedure CheckCashAccountStart(Object, Form, Item, Cancel = Undefined) Export
	
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then 
		Return;
	EndIf;
	
	If Item.CurrentItem.Name = "ChequeBondsCashAccount" Then
		CanModify = True;
		If Not ValueIsFilled(CurrentData.NewStatus) Then
			CanModify = False;
		Else
			PostingData = ObjectStatusesServer.PutStatusPostingToStructure(CurrentData.NewStatus);
			If PostingData.PlaningCashTransactions = PredefinedValue("Enum.DocumentPostingTypes.Nothing")
				And PostingData.AccountBalance = PredefinedValue("Enum.DocumentPostingTypes.Nothing") Then
				CanModify = False;
			EndIf;
		EndIf;
		
		If Cancel <> Undefined Then
			If Not CanModify Then
				Cancel = True;
			EndIf;
		Else
			Item.CurrentItem.ReadOnly = Not CanModify;
		EndIf;
	EndIf;
EndProcedure

Procedure ChequeBondsOnActivateRow(Object, Form, Item) Export
	
	CurrentData = Item.CurrentData;
	
	If CurrentData = Undefined Then 
		Return; 
	EndIf;
	
	Form.CurrentPartner = CurrentData.Partner;
	Form.CurrentLegalName = CurrentData.LegalName;
	Form.CurrentAgreement = CurrentData.Agreement;
	
	Form.Items.PaymentList.RowFilter = New FixedStructure("Key", CurrentData.Key);
	
	SetVisibleEnabled(Object, Form, CurrentData);
EndProcedure

Procedure SetVisibleEnabled(Object, Form, CurrentData) Export

	ChequeType = ServiceSystemServer.GetObjectAttribute(CurrentData.Cheque, "Type");
	Form.Items.PaymentListPartnerArBasisDocument.Visible =  ChequeType = PredefinedValue("Enum.ChequeBondTypes.PartnerCheque");
	Form.Items.PaymentListPartnerApBasisDocument.Visible =  ChequeType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque");
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	Form.Items.PaymentList.ReadOnly = Not AgreementInfo.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments");
	
	PaymentListReadOnly = Not AgreementInfo.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments");
	Form.Items.PaymentList.ReadOnly = PaymentListReadOnly;
	Form.Items.PaymentListFillDocuments.Enabled = Not PaymentListReadOnly;
	
EndProcedure

Procedure CurrencyOnChange(Object, Form, Item) Export
	
	If Form.CurrentCurrency = Object.Currency Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(Object.Currency) Then
		Form.CurrentCurrency = Object.Currency;
		Return;
	EndIf;
	
	ChequeBonds = New Array();
	
	If Object.ChequeBonds.Count() = 0 Then
		Form.CurrentCurrency = Object.Currency;
		Return;
	EndIf;
	
	For Each RowChequeBond In Object.ChequeBonds Do
		ChequeBonds.Add(RowChequeBond.Cheque);
	EndDo;
	
	ChequesResult = DocChequeBondTransactionServer.CurrencyOnChange(ChequeBonds, Object.Currency);
	
	If ChequesResult.Count() = 0 Then
		Form.CurrentCurrency = Object.Currency;
		Return;
	EndIf;
	
	Parameters = New Structure();
	Parameters.Insert("Item", Item);
	Parameters.Insert("Form", Form);
	Parameters.Insert("Object", Object);
	Parameters.Insert("ChequesResult", ChequesResult);
	
	QuestionToUserNotify = New NotifyDescription("CurrencyOnChangeEnd", ThisObject, Parameters);
	
	ShowQueryBox(QuestionToUserNotify, StrTemplate(R().QuestionToUser_003, Item.Title), QuestionDialogMode.YesNo);
EndProcedure

Procedure CurrencyOnChangeEnd(Result, Parameters) Export
	If Result <> DialogReturnCode.Yes Then
		Parameters.Object.Currency = Parameters.Form.CurrentCurrency;
		Return;
	EndIf;
	Object = Parameters.Object;
	For Each Cheque In Parameters.ChequesResult Do
		RowArray = Object.ChequeBonds.FindRows(New Structure("Cheque", Cheque));
		For Each RowCheque In RowArray Do
			Rows = Object.PaymentList.FindRows(New Structure("Key", RowCheque.Key));
			For Each DeleteRow In Rows Do
				Object.PaymentList.Delete(DeleteRow);	
			EndDo;
			Object.ChequeBonds.Delete(RowCheque);
		EndDo;
	EndDo;
	Parameters.Form.CurrentCurrency = Object.Currency;
	
	Parameters.Form.Currencies_HeaderOnChange(Parameters.Item);
EndProcedure

Procedure CompanyOnChange(Object, Form, Item) Export
	If Form.CurrentCompany = Object.Company Then
		Return;
	EndIf;
	
	If Object.PaymentList.Count() OR Object.ChequeBonds.Count() Then
		Parameters = New Structure();
		Parameters.Insert("Item", Item);
		Parameters.Insert("Form", Form);
		Parameters.Insert("Object", Object);
		
		QuestionToUserNotify = New NotifyDescription("CompanyOnChangeEnd", ThisObject, Parameters);
		ShowQueryBox(QuestionToUserNotify,StrTemplate(R().QuestionToUser_003, Item.Title), QuestionDialogMode.YesNo);
		Return;
	EndIf;
	Form.CurrentCompany = Object.Company;
EndProcedure

Procedure CompanyOnChangeEnd(Result, Parameters) Export
	If Result <> DialogReturnCode.Yes Then
		Parameters.Object.Company = Parameters.Form.CurrentCompany;
		Return;
	EndIf;
	
	Object = Parameters.Object;
	Object.PaymentList.Clear();
	
	Agreements = New Array();
	
	For Each RowChequeBonds In Object.ChequeBonds Do
		Agreements.Add(RowChequeBonds.Agreement);
	EndDo;
	
	InvalidAgreements = DocChequeBondTransactionServer.InvalidAgreements(Agreements, Object.Company);
	
	For Each InvalidAgreement In InvalidAgreements Do
		
		InvalidRows = Object.ChequeBonds.FindRows(New Structure("Agreement",InvalidAgreement));

		For Each InvalidRow In InvalidRows Do
			Object.ChequeBonds.Delete(InvalidRow);
		EndDo;
	EndDo;
	Parameters.Form.CurrentCompany = Object.Company;
	
EndProcedure

Procedure ShowApArDocument(Form, Item, RowSelected, Field, StandardProcessing) Export
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Field.Name = Item.Name + "PartnerArBasisDocument" Then
		ShowValue(, CurrentData.PartnerArBasisDocument);
	ElsIf Field.Name = Item.Name + "PartnerApBasisDocument" Then
		ShowValue(, CurrentData.PartnerApBasisDocument);
	Else
		Return;
	EndIf;
	
EndProcedure

Procedure PaymentListOnStartEdit(Object, Form, Item, NewRow, Clone) Export
	Return;
EndProcedure

#EndRegion

#Region Commands

Procedure FillCheques(Form, Object) Export
	
	ParametersData = New Structure();
	Filter = New Structure();
	Filter.Insert("Currency", Object.Currency);
	Filter.Insert("DeletionMark", False);
	
	ParametersData.Insert("Filter", Filter);
	
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Object", Object);
	NotifyDescription = New NotifyDescription("FillChequesContinue", DocChequeBondTransactionClient, NotifyParameters);
	
	OpenForm("Catalog.ChequeBonds.Form.PickUpForm", ParametersData, Form, , , , NotifyDescription);
	
EndProcedure

Procedure FillChequesContinue(Result, AdditionalParameters) Export
	If NOT ValueIsFilled(Result)
		OR Not AdditionalParameters.Property("Object")
		OR Not AdditionalParameters.Property("Form") Then
		Return;
	EndIf;
	 
	For Each ResultElement In Result Do
		NewChequeBondRow = AdditionalParameters.Object.ChequeBonds.Add();
		NewChequeBondRow.Key = New UUID();
		NewChequeBondRow.Cheque = ResultElement.ChequeBond;
		FillChequeBondsRow(NewChequeBondRow, AdditionalParameters.Object);
	EndDo;
	
EndProcedure

Procedure FillDocuments(Form, Object) Export
	
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FiltersStructure = New Structure();
	FiltersStructure.Insert("Key", CurrentData.Key);
	FiltersStructure.Insert("Companies", Object.Company);
	FiltersStructure.Insert("Partners", CurrentData.Partner);
	FiltersStructure.Insert("LegalNames", CurrentData.LegalName);
	FiltersStructure.Insert("Agreements", CurrentData.Agreement);
	FiltersStructure.Insert("Cheque", CurrentData.Cheque);
	FiltersStructure.Insert("ChequeAmount", CurrentData.Amount);
	FiltersStructure.Insert("Currencies", Object.Currency);
	FiltersStructure.Insert("QueryType", "ChequeBondTransaction");
	FiltersStructure.Insert("EndDate", EndOfDay(Object.Date));
	
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Object", Object);
	
	NotifyDescription = New NotifyDescription("FillDocumentsEnd", DocChequeBondTransactionClient, NotifyParameters);
	
	PickedRows = Object.PaymentList.FindRows(New Structure("Key", CurrentData.Key));
	RowsArray = New Array();
	For Each PickedRow In PickedRows Do
		RowStructure = New Structure("Key, PartnerArBasisDocument, PartnerApBasisDocument, Amount");
		
		FillPropertyValues(RowStructure, PickedRow);
		RowsArray.Add(RowStructure);
	EndDo;
	
	ParametersData = New Structure();
	ParametersData.Insert("RowsArray", RowsArray);
	ParametersData.Insert("FiltersStructure", FiltersStructure);

	OpenForm("CommonForm.PickUpDocuments", ParametersData, Form, , , , NotifyDescription);
	
EndProcedure

Procedure FillDocumentsEnd(Result, AdditionalParameters) Export
	If NOT ValueIsFilled(Result)
		OR Not AdditionalParameters.Property("Object")
		OR Not AdditionalParameters.Property("Form") Then
		Return;
	EndIf;
	
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	CurrentData = AdditionalParameters.Form.Items.ChequeBonds.CurrentData;
	
	FilterString = "Key, PartnerArBasisDocument, PartnerApBasisDocument";
	FilterStructure = New Structure(FilterStructure);
	DeleteRows = Object.PaymentList.FindRows(New Structure("Key", CurrentData.Key));
	
	For Each Row In DeleteRows Do
		Object.PaymentList.Delete(Row);
	EndDo;
	
	For Each ResultElement In Result Do
		FillPropertyValues(FilterStructure, ResultElement);
		Row = AdditionalParameters.Object.PaymentList.Add();
		FillPropertyValues(Row, ResultElement, FilterString);
		Row.Key = CurrentData.Key;
		Row.Amount = ResultElement.AmountBalance;
	EndDo;
	
	Form.Items.PaymentList.RowFilter = New FixedStructure("Key", CurrentData.Key);
EndProcedure
#EndRegion

#Region ItemTableCheque

Procedure ChequeBondsChequeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	If Object.Currency.IsEmpty() Then 
		Return; 
	EndIf;
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Currency", 
																Object.Currency, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.FormParameters.Insert("Currency", Object.Currency);
		OpenSettings.FormParameters.Insert("FilterByCurrency", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Currency", Object.Currency);
	
	DocumentsClient.ChequeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsChequeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Currency) Then
		AdditionalParameters.Insert("Currency", Object.Currency);
		AdditionalParameters.Insert("FilterByCurrency", True);
	EndIf;
	
	DocumentsClient.ChequeEditTextChange(Object, 
	                                     Form, 
	                                     Item, 
	                                     Text, 
	                                     StandardProcessing, 
	                                     ArrayOfFilters, 
	                                     AdditionalParameters);
EndProcedure

Procedure ChequeBondsChequeOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FillChequeBondsRow(CurrentData, Object);
	CleanPaymentList(Object, Form);
	SetVisibleEnabled(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsNewStatusOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If ObjectStatusesServer.StatusHasPostingType(CurrentData.NewStatus, 
								PredefinedValue("Enum.DocumentPostingTypes.Reversal")) Then
		FillPaymentListRows(Form, CurrentData, Object);
	EndIf;
EndProcedure

Procedure ChequeBondsBeforeDeleteRow(Object, Form, Item, Cancel) Export
	If  Item.CurrentData = Undefined Then
		Return;
	EndIf;
	
	Rows = Object.PaymentList.FindRows(New Structure("Key", Item.CurrentData.Key));
	For Each DeleteRow In Rows Do
		Object.PaymentList.Delete(DeleteRow);	
	EndDo;
EndProcedure

	
Procedure FillChequeBondsRow(RowData, Object)
	FillPropertyValues(RowData, DocChequeBondTransactionServer.GetChequeInfo(Object.Ref, RowData.Cheque));
EndProcedure

Procedure FillPaymentListRows(Form, RowData, Object) Export

	Parameters = New Structure();
	Parameters.Insert("Key", 		RowData.Key);
	Parameters.Insert("Cheque", 	RowData.Cheque);
	Parameters.Insert("Status", RowData.Status);
	Parameters.Insert("NewStatus", RowData.NewStatus);
	Parameters.Insert("PaymentList", Form.PaymentList);

	DocChequeBondTransactionServer.GetPaymentListFillingData(Object.Ref, Parameters);

	FindedRows = Object.PaymentList.FindRows(New Structure("Key", Parameters.Key));
	For Each FindedRow In FindedRows Do
		Object.PaymentList.Delete(FindedRow);
	EndDo;

	For Each Row In Parameters.PaymentList Do
		NewRow = Object.PaymentList.Add();
		NewRow.Key = Parameters.Key;
		FillPropertyValues(NewRow, Row);
	EndDo;
	
	Form.PaymentList.Clear();
	
EndProcedure

Procedure CleanPaymentList(Object, Form) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	DependentLines = Object.PaymentList.FindRows(New Structure("Key", CurrentData.Key));
	
	If CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement).Type = PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		For Each DependentLine In DependentLines Do
			Object.PaymentList.Delete(DependentLine);
			Return;
		EndDo;
	EndIf;
	
	ChequeType = ServiceSystemServer.GetObjectAttribute(CurrentData.Cheque, "Type");
	If ChequeType = PredefinedValue("Enum.ChequeBondTypes.PartnerCheque") Then
		ColomnName = "PartnerArBasisDocument";
	ElsIf ChequeType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		ColomnName = "PartnerApBasisDocument"; 
	Else
		For Each DependentLine In DependentLines Do
			Object.PaymentList.Delete(DependentLine);
			Return;
		EndDo;
	EndIf;
	
	СontrolDocuments = New Array();
	For Each DependentLine In DependentLines Do
		If ValueIsFilled(DependentLine[ColomnName]) Then
			СontrolDocuments.Add(DependentLine[ColomnName]);
		Else
			Object.PaymentList.Delete(DependentLine);
		EndIf;
	EndDo;
	
	If СontrolDocuments.Count() = 0 Then
		Return;
	EndIf;
	
	СontrolStructure = New Structure(, );
	СontrolStructure.Insert("Company", Object.Company);
	СontrolStructure.Insert("Partner", Form.CurrentPartner);
	СontrolStructure.Insert("LegalName", Form.CurrentLegalName);
	СontrolStructure.Insert("Agreement", Form.CurrentAgreement);
	СontrolStructure.Insert("СontrolDocument", СontrolDocuments);
	СontrolStructure.Insert("EndDate", Object.Date - 1);
	СontrolStructure.Insert("UseCurrencyFilter", ValueIsFilled(Object.Currency));
	СontrolStructure.Insert("Currency", Object.Currency);
	
	InvalidDocuments = DocChequeBondTransactionServer.InvalidDocuments(СontrolStructure);
	
	For Each DependentLine In DependentLines Do
		If InvalidDocuments.Find(DependentLine[ColomnName]) = Undefined Then
			Continue;
		Else
			Object.PaymentList.Delete(DependentLine);
		EndIf;
	EndDo;

EndProcedure

#EndRegion

#Region ItemTablePartner

Procedure TablePartnerOnChange(Object, Form, Item) Export
	CurrentData = Item.Parent.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If CurrentData.Partner <> Form.CurrentPartner Then
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, CurrentData.Partner);
		AgreementParameters.Insert("Agreement"		, CurrentData.Agreement);
		AgreementParameters.Insert("CurrentDate"	, Object.Date);
		AgreementParameters.Insert("ArrayOfFilters"	, New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
		CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
		CurrentData.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
		SetVisibleEnabled(Object, Form, CurrentData);
	EndIf;
	Form.CurrentPartner = CurrentData.Partner;
	Form.CurrentLegalName = CurrentData.LegalName;
	Form.CurrentAgreement = CurrentData.Agreement;
	CleanPaymentList(Object, Form);
EndProcedure

Procedure TablePartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TablePartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure TableAgreementOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	SetVisibleEnabled(Object, Form, CurrentData);
	Form.CurrentPartner = CurrentData.Partner;
	Form.CurrentLegalName = CurrentData.LegalName;
	Form.CurrentAgreement = CurrentData.Agreement;
	
	CleanPaymentList(Object, Form);
EndProcedure

Procedure TableAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	CurrentData = Item.Parent.CurrentData;
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind",
																		PredefinedValue("Enum.AgreementKinds.Standard"), 
																		DataCompositionComparisonType.NotEqual));
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
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TableAgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	
	CurrentData = Item.Parent.CurrentData;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
																	PredefinedValue("Enum.AgreementKinds.Standard"), 
																	ComparisonType.NotEqual));												
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, 
														StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																		PredefinedValue("Enum.CashAccountTypes.Transit"),
																		,
																		DataCompositionComparisonType.NotEqual));
	If ValueIsFilled(Object.Currency) Then
		Currenseies = New Array();
		Currenseies.Add(PredefinedValue("Catalog.Currencies.EmptyRef"));
		Currenseies.Add(Object.Currency);
		StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Currency",
																		Currenseies,
																		,
																		DataCompositionComparisonType.InList));
	EndIf;																		
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																		PredefinedValue("Enum.CashAccountTypes.Transit"),
																		ComparisonType.NotEqual));
																		If ValueIsFilled(Object.Currency) Then
	Currenseies = New Array();
	Currenseies.Add(PredefinedValue("Catalog.Currencies.EmptyRef"));
	Currenseies.Add(Object.Currency);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Currency",
																		Currenseies,
																		,
																		DataCompositionComparisonType.InList));
	EndIf;
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

#EndRegion

#Region TableChequeBonds

Procedure TableChequeBondsLegalNameOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If CurrentData.LegalName <> Form.CurrentLegalName Then
		If Not ValueIsFilled(CurrentData.Partner) Then		
			Partners = CatPartnersServer.GetPartnersByCompanies(CurrentData.LegalName);
			If Partners.Count() = 1 Then
				CurrentData.Partner = Partners[0];
			EndIf;
		EndIf;
	EndIf;
	Form.CurrentPartner = CurrentData.Partner;
	Form.CurrentLegalName = CurrentData.LegalName;
	Form.CurrentAgreement = CurrentData.Agreement;
	
	CleanPaymentList(Object, Form);
EndProcedure

Procedure StatusSelectionStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	CurrentData = Item.Parent.CurrentData;
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", CurrentData.Partner);
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TableChequeBondsLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", CurrentData.Partner);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TableChequeBondsLegalNameTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.ChequeBonds.CurrentData;
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
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region Statuses
	
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
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", 
																Parent, DataCompositionComparisonType.InHierarchy));
	
	DocumentsClient.StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);																																
EndProcedure						

Procedure StatusEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	EditSettings = DocumentsClient.GetOpenSettingsStructure();

	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
	Else
		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
	EndIf;
	
	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", 
																Parent, DataCompositionComparisonType.InHierarchy));	
	
	DocumentsClient.StatusEditTextChange(Object, Form, Item, Text, StandardProcessing, EditSettings);
EndProcedure
	
#EndRegion
	