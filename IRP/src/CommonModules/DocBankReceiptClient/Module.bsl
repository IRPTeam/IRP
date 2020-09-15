
#Region FormEvents

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

Procedure SetAvailability(Object, Form) Export
	ArrayAll = New Array();
	ArrayByType = New Array();
	DocBankReceiptServer.FillAttributesByType(Object.TransactionType, ArrayAll, ArrayByType);
	DocumentsClientServer.SetVisibilityItemsByArray(Form.Items, ArrayAll, ArrayByType);
	
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange")
		OR Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder") Then
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder")
				And ValueIsFilled(Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		Form.Items.CurrencyExchange.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CurrencyExchange);
		Form.Items.Account.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Account);
		Form.Items.Company.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		Form.Items.Currency.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);

		ArrayTypes = New Array();
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	Else
		ArrayTypes = New Array();
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		ArrayTypes.Add(Type("DocumentRef.IncomingPaymentOrder"));
		ArrayTypes.Add(Type("DocumentRef.OutgoingPaymentOrder"));
		ArrayTypes.Add(Type("DocumentRef.ChequeBondTransactionItem"));
		Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	EndIf;
EndProcedure

#EndRegion

#Region FormItemsEvents

Procedure DateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CurrencyOnChange(Object, Form, Item) Export
	Form.CurrentCurrency = Object.Currency;
	If Object.Currency <> ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency") Then
		Object.Account = Undefined;
		Form.CurrentAccount = Object.Account;
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Function CurrencySettings(Object, Form, AddInfo = Undefined) Export
	Return New Structure();
EndFunction

#Region ItemTransactionType

Procedure TransactionTypeOnChange(Object, Form, Item) Export
	CleanDataByTransactionType(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CleanDataByTransactionType(Object, Form) Export
	SetTransitAccount(Object, Form);
	
	If Object.PaymentList.Count() = 0 Or Object.TransactionType = Form.CurrentTransactionType Then
		Return;
	EndIf;
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object", Object);
	AdditionalParameters.Insert("Form", Form);
	
	ShowQueryBox(New NotifyDescription("CleanDataByTransactionTypeContinue", ThisObject, AdditionalParameters), 
					R().QuestionToUser_014, QuestionDialogMode.OKCancel);
EndProcedure

Procedure CleanDataByTransactionTypeContinue(Result, AdditionalParameters) Export
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	
	If Result = DialogReturnCode.OK Then
		ArrayAll = New Array();
		ArrayByType = New Array();
		DocBankReceiptServer.FillAttributesByType(AdditionalParameters.Object.TransactionType, ArrayAll, ArrayByType);
		DocumentsClientServer.CleanDataByArray(AdditionalParameters.Object, ArrayAll, ArrayByType);
		For Each Row In Object.PaymentList Do
			Row.PlaningTransactionBasis = Undefined;
		EndDo;
	Else
		Object.TransactionType = Form.CurrentTransactionType;
		SetTransitAccount(Object, Form);
		Form.SetVisibilityAvailability();
	EndIf;
	
	Form.CurrentTransactionType = Object.TransactionType;
EndProcedure

#EndRegion

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Item);
EndProcedure

Function CompanySettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, CalculateSettings");
	Actions = New Structure();
	Actions.Insert("ChangeAccount"	, "ChangeAccount");
	Settings.Insert("TableName"		, "PaymentList");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Account";
	Settings.FormAttributes = "";
	Settings.CalculateSettings = New Structure();
	Settings.Insert("AccountType", PredefinedValue("Enum.CashAccountTypes.Bank"));
	Return Settings;
EndFunction

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	False, DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", 
																	True, DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("Our", True);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ItemAccount

Procedure AccountOnChange(Object, Form, Item = Undefined) Export
	If Form.CurrentAccount = Object.Account Then
		Return;
	EndIf;
	
	SetTransitAccount(Object, Form);
	
	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
	If ValueIsFilled(AccountCurrency) Then
		Object.Currency = AccountCurrency;
		Form.CurrentCurrency = Object.Currency;
	EndIf;
	
	Form.CurrentAccount = Object.Account;
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure SetTransitAccount(Object, Form) Export
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
		TransitAccount = ServiceSystemServer.GetObjectAttribute(Object.Account, "TransitAccount");	
		Object.TransitAccount = TransitAccount;
		Form.Items.TransitAccount.ReadOnly = ValueIsFilled(Object.TransitAccount);	
	EndIf;
EndProcedure

Procedure AccountStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																								PredefinedValue("Enum.CashAccountTypes.Bank"),
																								,
																								DataCompositionComparisonType.Equal));
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Bank"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, Form.UUID, , Form.URL);
EndProcedure

Procedure AccountEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																			PredefinedValue("Enum.CashAccountTypes.Bank"),
																			ComparisonType.Equal));
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

#EndRegion

#Region ItemPaymentList

Procedure PaymentListOnChange(Object, Form, Item) Export
	For Each Row In Object.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
	SetAvailability(Object, Form);
EndProcedure

Procedure PaymentListOnActivateRow(Object, Form, Item) Export
	Return;
EndProcedure

Procedure PaymentListBasisDocumentOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(CurrentData.BasisDocument) Then
		CurrentData.BasisDocument = Undefined;
	EndIf;

EndProcedure

Procedure PaymentListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	If Clone Then
		Return;
	EndIf;
	Cancel = True;
	NewRow = Object.PaymentList.Add();
	Form.Items.PaymentList.CurrentRow = NewRow.GetID();
	Form.Items.PaymentList.ChangeRow();
	PaymentListOnChange(Object, Form, Item);
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData <> Undefined
		And Not Saas.SeparationUsed() Then
		CurrentData.Partner = DocBankReceiptServer.GetPartnerByLegalName(CurrentData.Payer, CurrentData.Partner);
		PaymentListPartnerOnChange(Object, Form, Item);
	EndIf;
EndProcedure

Procedure PaymentListPlaningTransactionBasisOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If ValueIsFilled(CurrentData.PlaningTransactionBasis) 
		And TypeOf(CurrentData.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") Then
		CashTransferOrderInfo = DocCashTransferOrderServer.GetInfoForFillingBankReceipt(CurrentData.PlaningTransactionBasis);
			If Not ValueIsFilled(Object.Account) Then
				Object.Account = CashTransferOrderInfo.Account;
			EndIf;
			
			If Not ValueIsFilled(Object.Company) Then
				Object.Company = CashTransferOrderInfo.Company;
			EndIf;
			
			If Not ValueIsFilled(Object.Currency) Then
				Object.Currency = CashTransferOrderInfo.Currency;
			EndIf;
			
			If Not ValueIsFilled(Object.CurrencyExchange) Then
				Object.CurrencyExchange = CashTransferOrderInfo.CurrencyExchange;
			EndIf;
			
			ArrayOfPlaningTransactionBasises = New Array();
			ArrayOfPlaningTransactionBasises.Add(CurrentData.PlaningTransactionBasis);
			ArrayOfBalance = DocBankReceiptServer.GetDocumentTable_CashTransferOrder_ForClient(ArrayOfPlaningTransactionBasises);
			If ArrayOfBalance.Count() Then
				RowOfBalance = ArrayOfBalance[0];
				CurrentData.Amount = RowOfBalance.Amount;
				CurrentData.AmountExchange = RowOfBalance.AmountExchange;
			EndIf;
	EndIf;
	
	DocumentsClient.PaymentListPlaningTransactionBasisOnChange(Object, Form, Item);
EndProcedure

Procedure TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	
	If ValueIsFilled(Object.Account) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Receiver", Object.Account, DataCompositionComparisonType.Equal));
	EndIf;
	
	If ValueIsFilled(Object.Company) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", True, DataCompositionComparisonType.Equal));
		
		If ValueIsFilled(Object.Currency) Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ReceiveCurrency", Object.Currency, DataCompositionComparisonType.Equal));
		EndIf;
		
		If ValueIsFilled(Object.CurrencyExchange) Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("SendCurrency", Object.CurrencyExchange, DataCompositionComparisonType.Equal));
		EndIf;
		
		ArrayOfSelectedDocuments = New Array();
		For Each Row In Object.PaymentList Do
			ArrayOfSelectedDocuments.Add(Row.PlaningTransactionBasis);
		EndDo;
		
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("ArrayOfSelectedDocuments", ArrayOfSelectedDocuments);
		
		OpenSettings.FormParameters.Insert("OwnerRef", Object.Ref);
		
		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
		
	ElsIf Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder") Then
		If ValueIsFilled(Object.Currency) Then
			OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ReceiveCurrency", Object.Currency, DataCompositionComparisonType.Equal));
		EndIf;
		
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsCurrencyExchange", False, DataCompositionComparisonType.Equal));
		
		ArrayOfSelectedDocuments = New Array();
		For Each Row In Object.PaymentList Do
			ArrayOfSelectedDocuments.Add(Row.PlaningTransactionBasis);
		EndDo;
		
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("ArrayOfSelectedDocuments", ArrayOfSelectedDocuments);
		
		OpenSettings.FormParameters.Insert("OwnerRef", Object.Ref);
		
		DocumentsClient.TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	EndIf;

EndProcedure

Procedure OnActiveCell(Object, Form, Item, Cancel = Undefined) Export
	If Item.CurrentItem = Undefined Then
		Return;
	EndIf;
	
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	CanModify = True;
	
	If Item.CurrentItem.Name = "PaymentListBasisDocument" Then
	
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
		If Not AgreementInfo.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
			CanModify = False;
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

Procedure PaymentListBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	
	StandardProcessing = False;
	
	TransferParameters = New Structure;
	TransferParameters.Insert("Unmarked", True);
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Partner) Then
		TransferParameters.Insert("Partner", Form.Items.PaymentList.CurrentData.Partner);
	EndIf;
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Payer) Then
		TransferParameters.Insert("LegalName", Form.Items.PaymentList.CurrentData.Payer);
	EndIf;
	If ValueIsFilled(Form.Items.PaymentList.CurrentData.Agreement) Then
		TransferParameters.Insert("Agreement", Form.Items.PaymentList.CurrentData.Agreement);
	EndIf;
	TransferParameters.Insert("Posted", True);
	
	FilterStructure = JorDocumentsForIncomingPaymentServer.CreateFilterByParameters(TransferParameters);
	FormParameters = New Structure("CustomFilter", FilterStructure);
	
	NotifyChoiceFormCloseParameters = New Structure();
	NotifyChoiceFormCloseParameters.Insert("Form", Form);
	
	NotifyChoiceFormClose = New NotifyDescription("PaymentListBasisDocumentStartChoiceEnd", 
			ThisObject, NotifyChoiceFormCloseParameters);
	
	OpenForm("DocumentJournal.DocumentsForIncomingPayment.Form.ChoiceForm",
		FormParameters,
		Item,
		Form.UUID,
		,
		Form.URL,
		NotifyChoiceFormClose,
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

Procedure PaymentListBasisDocumentStartChoiceEnd(Result, AdditionalParameters) Export
	If ValueIsFilled(Result) Then
		Form = AdditionalParameters.Form;
		Form.Items.PaymentList.CurrentData.BasisDocument = Result;
	EndIf;
EndProcedure

#Region Partner

Procedure PaymentListPartnerOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Then
		Return;
	EndIf;

	If ValueIsFilled(CurrentData.Partner) Then
		CurrentData.Payer = DocumentsServer.GetLegalNameByPartner(CurrentData.Partner, CurrentData.Payer);
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, CurrentData.Partner);
		AgreementParameters.Insert("Agreement"		, CurrentData.Agreement);
		AgreementParameters.Insert("CurrentDate"	, Object.Date);
		AgreementParameters.Insert("ArrayOfFilters"	, New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		NewAgreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
		If Not CurrentData.Agreement = NewAgreement Then
			CurrentData.Agreement = NewAgreement;
			PaymentListAgreementOnChange(Object, Form);
		EndIf;
	EndIf;
EndProcedure

Procedure PaymentListPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark",
																		False, DataCompositionComparisonType.Equal));
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
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
				ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region Agreement

Procedure PaymentListAgreementOnChange(Object, Form, Item = Undefined) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement);
	
	CurrentData.ApArPostingDetail = AgreementInfo.ApArPostingDetail;
	If Not AgreementInfo.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		CurrentData.BasisDocument = Undefined;
	ElsIf Not CurrentData.BasisDocument = Undefined And
		 Not ServiceSystemServer.GetObjectAttribute(CurrentData.BasisDocument, "Agreement") = CurrentData.Agreement Then 
		CurrentData.BasisDocument = Undefined;
	EndIf;
	 
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
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
	OpenSettings.FillingData.Insert("LegalName"	, CurrentData.Payer);
	OpenSettings.FillingData.Insert("Company"	, Object.Company);
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
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

#Region Payer

Procedure PaymentListPayerOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	If ValueIsFilled(CurrentData.Payer) Then
		CurrentData.Partner = DocCashReceiptServer.GetPartnerByLegalName(CurrentData.Payer, CurrentData.Partner);
	EndIf;
EndProcedure

Procedure PaymentListPayerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		False, DataCompositionComparisonType.Equal));
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
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing,
				ArrayOfFilters, AdditionalParameters);
EndProcedure
#EndRegion

#EndRegion

#EndRegion

#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object, Form, Item) Export
	DocumentsClient.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

#Region Common

Procedure FillUnfilledPayerInRow(Object, Item, Payer) Export
	If Not ValueIsFilled(Item.CurrentData.Payer) Then
		IdentifyRow = Item.CurrentRow;
		RowPaymentList = Object.PaymentList.FindByID(IdentifyRow);
		RowPaymentList.Payer = Payer;
	EndIf;
EndProcedure

#EndRegion

