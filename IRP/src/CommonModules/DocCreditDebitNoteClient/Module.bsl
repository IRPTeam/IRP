#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	CurrenciesClient.OnOpen(Object, Form, AddInfo);
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	CurrenciesClient.AfterWriteAtClient(Object, Form, "Transactions", AddInfo);
EndProcedure
	
#EndRegion

#Region _Date

Procedure DateOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	CurrenciesClient.DateOnChange(Object, Form, "Transactions", AddInfo);
EndProcedure

#EndRegion

#Region Company

Procedure CompanyOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	CurrenciesClient.CompanyOnChange(Object, Form, "Transactions", AddInfo);	
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", 
																	True, DataCompositionComparisonType.Equal));
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

#Region Partner

Procedure TransactionsPartnerOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.Transactions.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If ValueIsFilled(CurrentData.Partner) Then
		CurrentData.LegalName = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.LegalName);
	
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, CurrentData.Partner);
		AgreementParameters.Insert("Agreement"		, CurrentData.Agreement);
		AgreementParameters.Insert("CurrentDate"	, Object.Date);
		AgreementParameters.Insert("ArrayOfFilters"	, New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		NewAgreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
		If Not CurrentData.Agreement = NewAgreement Then
			CurrentData.Agreement = NewAgreement;
			TransactionsAgreementOnChange(Object, Form, Undefined, AddInfo);
		EndIf;
	EndIf;
	DocCreditDebitNoteClientServer.SetBasisDocumentReadOnly(Object, CurrentData);
EndProcedure

Procedure TransactionsPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TransactionsPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region Agreement

Procedure TransactionsAgreementOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	
	If AgreementInfo.ApArPostingDetail <> PredefinedValue("Enum.ApArPostingDetail.ByDocuments")
		Or CurrentData.Agreement <> 
		ServiceSystemServer.GetCompositeObjectAttribute(CurrentData.BasisDocument, "Agreement") Then
		CurrentData.BasisDocument = Undefined;
	EndIf;
	
	If CurrentData.Currency <> AgreementInfo.Currency Then
		CurrentData.Currency = AgreementInfo.Currency;
		TransactionsCurrencyOnChange(Object, Form, Undefined);
	EndIf;
	CurrenciesClient.AgreementOnChange(Object, Form, "Transactions", AddInfo);
	DocCreditDebitNoteClientServer.SetBasisDocumentReadOnly(Object, CurrentData);
EndProcedure

Procedure TransactionsAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, 
																	DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
																	PredefinedValue("Enum.AgreementKinds.Standard"), 
																	DataCompositionComparisonType.NotEqual));																
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner"						, CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner"			, True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments"			, True);
	OpenSettings.FormParameters.Insert("EndOfUseDate"					, Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate"	, True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"	, CurrentData.Partner);
	OpenSettings.FillingData.Insert("Company"	, Object.Company);
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TransactionsAgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
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
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region LegalName

Procedure TransactionsLegalNameOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If ValueIsFilled(CurrentData.LegalName) Then
		NewPartner = DocCreditDebitNoteServer.GetPartnerByLegalName(CurrentData.LegalName, CurrentData.Partner);
		If NewPartner <> CurrentData.Partner Then
			CurrentData.Partner = DocCreditDebitNoteServer.GetPartnerByLegalName(CurrentData.LegalName, CurrentData.Partner);
			TransactionsPartnerOnChange(Object, Form, Undefined);
		EndIf;
	EndIf;
	DocCreditDebitNoteClientServer.SetBasisDocumentReadOnly(Object, CurrentData);
EndProcedure

Procedure TransactionsLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.Transactions.CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Form.Items.Transactions.CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Form.Items.Transactions.CurrentData.Partner);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TransactionsLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.Transactions.CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", Form.Items.Transactions.CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, 
				ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region BasisDocument

Procedure TransactionsBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	CurrentData = Form.Items.Transactions.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure());
	If Not ValueIsFilled(CurrentData.Agreement) Then
		Parameters.Filter.Insert("Agreement_ApArPostingDetail", PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	EndIf;
	Parameters.Filter.Insert("Company", Object.Company);
	
	Parameters.Insert("FilterFromCurrentData", "Partner, LegalName, Agreement");
	
	Notify = New NotifyDescription("TransactionsBasisDocumentStartChoiceEnd", ThisObject, New Structure("Form", Form));
	Parameters.Insert("Notify"                 , Notify);
	Parameters.Insert("TableName"              , "DocumentsForCreditDebitNote");
	Parameters.Insert("OpeningEntryTableName1" , "AccountPayableByDocuments");
	Parameters.Insert("OpeningEntryTableName2" , "AccountReceivableByDocuments");
	Parameters.Insert("Ref"                    , Object.Ref);
	JorDocumentsClient.BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters);
EndProcedure

Procedure TransactionsBasisDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = AdditionalParameters.Form.Object;
	Form = AdditionalParameters.Form;
	CurrentData = AdditionalParameters.Form.Items.Transactions.CurrentData;
	If CurrentData <> Undefined Then
		CurrentData.BasisDocument = Result.BasisDocument;
		CurrentData.Partner       = Result.Partner;
		CurrentData.Agreement     = Result.Agreement;
		CurrentData.Currency      = Result.Currency;
		CurrentData.LegalName     = Result.LegalName;
		CurrentData.Amount        = Result.Amount;
		CurrenciesClient.AgreementOnChange(Object, Form, "Transactions");
	EndIf;
EndProcedure

#EndRegion

#Region Currency

&AtClient
Procedure TransactionsCurrencyOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrenciesClient.CurrencyOnChange(Object, Form, "Transactions", AddInfo);
EndProcedure

#EndRegion

#Region Amount

&AtClient
Procedure TransactionsAmountOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrenciesClient.AmountOnChange(Object, Form, "Transactions", AddInfo);
EndProcedure

#EndRegion

#Region Transactions

Procedure TransactionsBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	CurrenciesClient.BeforeDeleteRow(Object, Form, "Transactions", AddInfo);
EndProcedure

Procedure TransactionsOnActivateRow(Object, Form, Item, AddInfo = Undefined) Export
	CurrenciesClient.OnActivateRow(Object, Form, "Transactions", AddInfo);
EndProcedure
	
#EndRegion

#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion

#Region GroupTitle

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

#EndRegion

