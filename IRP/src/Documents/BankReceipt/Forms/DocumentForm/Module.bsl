#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocBankReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocBankReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocBankReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocBankReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Function GetVisibleAttributesByTransactionType(TransactionType)
	StrAll = "TransitAccount, CurrencyExchange,
	|PaymentList.BasisDocument,
	|PaymentList.Partner,
	|PaymentList.PlaningTransactionBasis,
	|PaymentList.Agreement,
	|PaymentList.LegalNameContract,
	|PaymentList.Payer,
	|PaymentList.AmountExchange,
	|PaymentList.POSAccount,
	|PaymentList.Order,
	|PaymentList.PaymentType,
	|PaymentList.PaymentTerminal,
	|PaymentList.BankTerm,
	|PaymentList.RevenueType,
	|PaymentList.RetailCustomer,
	|PaymentList.SendingAccount,
	|PaymentList.SendingBranch,
	|PaymentList.Project,
	|PaymentList.ProfitLossCenter,
	|PaymentList.ExpenseType,
	|PaymentList.AdditionalAnalytic,
	|PaymentList.CommissionPercent,
	|PaymentList.Commission,
	|PaymentList.CommissionFinancialMovementType";
	
	ArrayOfAllAttributes = New Array();
	For Each ArrayItem In StrSplit(StrAll, ",") Do
		ArrayOfAllAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	CashTransferOrder   = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	CurrencyExchange    = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	PaymentFromCustomer = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	ReturnFromVendor    = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor");
	TransferFromPOS     = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS");
	PaymentFromCustomerByPOS = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS");
	ReceiptByCheque     = PredefinedValue("Enum.IncomingPaymentTransactionType.ReceiptByCheque");
	RetailCustomerAdvance  = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance");
	EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	OtherIncome         = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherIncome");
	OtherPartner        = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherPartner");
	
	If TransactionType = CashTransferOrder Then
		StrByType = "
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.SendingAccount,
		|PaymentList.SendingBranch,
		|PaymentList.ProfitLossCenter,
		|PaymentList.ExpenseType,
		|PaymentList.AdditionalAnalytic,
		|PaymentList.CommissionPercent,
		|PaymentList.Commission,
		|PaymentList.CommissionFinancialMovementType";
	ElsIf TransactionType = CurrencyExchange Then
		StrByType = "
		|TransitAccount, 
		|CurrencyExchange,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.AmountExchange,
		|PaymentList.SendingAccount,
		|PaymentList.SendingBranch,
		|PaymentList.ProfitLossCenter,
		|PaymentList.ExpenseType,
		|PaymentList.AdditionalAnalytic,
		|PaymentList.CommissionPercent,
		|PaymentList.Commission,
		|PaymentList.CommissionFinancialMovementType";
	ElsIf TransactionType = PaymentFromCustomer 
		Or TransactionType = ReturnFromVendor 
		Or TransactionType = PaymentFromCustomerByPOS Then
		
		StrByType = "
		|PaymentList.BasisDocument,
		|PaymentList.Partner,
		|PaymentList.Agreement,
		|PaymentList.Payer,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.LegalNameContract";
		If TransactionType = PaymentFromCustomer Then
			StrByType = StrByType + ", PaymentList.Order";
		EndIf;
		
		If TransactionType = PaymentFromCustomerByPOS Then
			StrByType = StrByType + ", 
			|PaymentList.PaymentType,
			|PaymentList.PaymentTerminal,
			|PaymentList.BankTerm,
			|PaymentList.ProfitLossCenter,
			|PaymentList.ExpenseType,
			|PaymentList.AdditionalAnalytic,
			|PaymentList.CommissionPercent,
			|PaymentList.Commission,
			|PaymentList.CommissionFinancialMovementType";
		EndIf;
		
		If TransactionType = PaymentFromCustomer Or TransactionType = ReturnFromVendor Then
			StrByType = StrByType + ", PaymentList.Project";
		EndIf;
		
	ElsIf TransactionType = OtherPartner Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.Agreement,
		|PaymentList.Payer,
		|PaymentList.LegalNameContract,
		|PaymentList.BasisDocument";
	ElsIf TransactionType = TransferFromPOS Then
		StrByType = "
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.POSAccount,
		|PaymentList.ProfitLossCenter,
		|PaymentList.ExpenseType,
		|PaymentList.AdditionalAnalytic,
		|PaymentList.CommissionPercent,
		|PaymentList.Commission,
		|PaymentList.CommissionFinancialMovementType";
	ElsIf TransactionType = ReceiptByCheque Then
		StrByType = "
		|PaymentList.PlaningTransactionBasis";
	ElsIf TransactionType = RetailCustomerAdvance Then
		StrByType = "
		|PaymentList.RetailCustomer,
		|PaymentList.PaymentType,
		|PaymentList.PaymentTerminal,
		|PaymentList.BankTerm,
		|PaymentList.Order,
		|PaymentList.CommissionPercent,
		|PaymentList.Commission";
	ElsIf TransactionType = EmployeeCashAdvance Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.Agreement,
		|PaymentList.BasisDocument";
	ElsIf TransactionType = OtherIncome Then
		StrByType = "
		|PaymentList.RevenueType,
		|PaymentList.ProfitLossCenter,
		|PaymentList.AdditionalAnalytic";
	EndIf;
	
	ArrayOfVisibleAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfVisibleAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	Return New Structure("AllAttributes, VisibleAttributes", ArrayOfAllAttributes, ArrayOfVisibleAttributes);
EndFunction

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	AttributesForChangeVisible = GetVisibleAttributesByTransactionType(Object.TransactionType);
	For Each Attr In AttributesForChangeVisible.AllAttributes Do
		ItemName = StrReplace(Attr, ".", "");
		Visibility = (AttributesForChangeVisible.VisibleAttributes.Find(Attr) <> Undefined);
		Form.Items[TrimAll(ItemName)].Visible = Visibility;
	EndDo;

	IsCurrencyExchange    = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	IsCashTransferOrder   = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	IsTransferFromPOS     = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS");
	IsReceiptByCheque     = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.ReceiptByCheque");
	IsPaymentFormCustomer = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");

	ArrayTypes = New Array();
	
	If IsCurrencyExchange Or IsCashTransferOrder Or IsTransferFromPOS Then
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

		If IsTransferFromPOS Then
			ArrayTypes.Add(Type("DocumentRef.CashStatement"));
		Else
			ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
		EndIf;
	ElsIf IsReceiptByCheque Then
		ArrayTypes.Add(Type("DocumentRef.ChequeBondTransactionItem"));
	Else
		ArrayTypes.Add(Type("DocumentRef.OutgoingPaymentOrder"));
	EndIf;
	Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	
	Form.Items.TransitAccount.ReadOnly = ValueIsFilled(Object.TransitAccount);
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	Form.Items.PaymentListPaymentByDocuments.Enabled = Not Form.ReadOnly;

	Form.Items.PaymentListPaymentByDocuments.Visible = IsPaymentFormCustomer;
	
	Form.Items.ExpenseType.Visible  = IsCurrencyExchange;
	Form.Items.LossCenter.Visible   = IsCurrencyExchange;
	Form.Items.RevenueType.Visible  = IsCurrencyExchange;
	Form.Items.ProfitCenter.Visible = IsCurrencyExchange;
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocBankReceiptClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocBankReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocBankReceiptClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT

&AtClient
Procedure AccountOnChange(Item)
	DocBankReceiptClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSIT_ACCOUNT

&AtClient
Procedure TransitAccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.TransitAccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.TransitAccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocBankReceiptClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYMENT_LIST

&AtClient
Procedure PaymentListSelection(Item, RowSelected, Field, StandardProcessing)
	DocBankReceiptClient.PaymentListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocBankReceiptClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocBankReceiptClient.PaymentListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region PARTNER

&AtClient
Procedure PaymentListPartnerOnChange(Item)
	DocBankReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PAYER

&AtClient
Procedure PaymentListPayerOnChange(Item)
	DocBankReceiptClient.PaymentListPayerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayerEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure PaymentListAgreementOnChange(Item)
	DocBankReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item)
	DocBankReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region PLANNING_TRANSACTION_BASIS

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item)
	DocBankReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region _ORDER

&AtClient
Procedure PaymentListOrderStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

&AtClient
Procedure PaymentListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure PaymentListNetAmountOnChange(Item)
	DocBankReceiptClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure PaymentListTotalAmountOnChange(Item)
	DocBankReceiptClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure PaymentListTaxAmountOnChange(Item)
	DocBankReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure PaymentListVatRateOnChange(Item) Export
	DocBankReceiptClient.PaymentListVatRateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMISSION

&AtClient
Procedure PaymentListCommissionOnChange(Item)
	DocBankReceiptClient.PaymentListCommissionOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYMENT_TYPE

&AtClient
Procedure PaymentListPaymentTypeOnChange(Item)
	DocBankReceiptClient.PaymentListPaymentTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region BANK_TERM

&AtClient
Procedure PaymentListBankTermOnChange(Item)
	DocBankReceiptClient.PaymentListBankTermOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMISSION_PERCENT

&AtClient
Procedure PaymentListCommissionPercentOnChange(Item)
	DocBankReceiptClient.PaymentListCommissionPercentOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#Region SERVICE

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V8(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	UpdateAccountingData();
	AccountingClient.OpenFormEditAccounting(Object, ThisObject, CurrentData, "PaymentList");
EndProcedure

&AtServer
Procedure UpdateAccountingData()
	_AccountingRowAnalytics = ThisObject.AccountingRowAnalytics.Unload();
	_AccountingExtDimensions = ThisObject.AccountingExtDimensions.Unload();
	AccountingClientServer.UpdateAccountingTables(Object, 
			                                      _AccountingRowAnalytics, 
		                                          _AccountingExtDimensions, "PaymentList");
	ThisObject.AccountingRowAnalytics.Load(_AccountingRowAnalytics);
	ThisObject.AccountingExtDimensions.Load(_AccountingExtDimensions);
EndProcedure

&AtClient
Procedure PaymentByDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("SelectedDocuments", New Array());
	FormParameters.Insert("SelectedPositionWithoutDocuments", New Array());
	
	FormParameters.Insert("Ref"           , Object.Ref);
	FormParameters.Insert("Company"       , Object.Company);
	FormParameters.Insert("Branch"        , Object.Branch);
	FormParameters.Insert("Currency"      , Object.Currency);
	FormParameters.Insert("AllowedTypes"  , New Array());
	
	FormParameters.AllowedTypes.Add(Type("DocumentRef.SalesInvoice"));
	
	FormParameters.Insert("RegisterName", "R2021B_CustomersTransactions");
	
	For Each Row In Object.PaymentList Do
		If ValueIsFilled(Row.BasisDocument) Then
			FormParameters.SelectedDocuments.Add(Row.BasisDocument);
		Else
			PositionStructure = New Structure("Partner, Agreement");
			FillPropertyValues(PositionStructure, Row);
			FormParameters.SelectedPositionWithoutDocuments.Add(PositionStructure);	
		EndIf;
	EndDo;
	Notify = New NotifyDescription("PaymentByDocumentSelectionEnd", ThisObject);		
	OpenForm("CommonForm.PaymentDistribution", FormParameters, ThisObject,,,,Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure PaymentByDocumentSelectionEnd(Result, NotifyParams) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each Row In Result Do
		ViewClient_V2.PaymentListAddFilledRow(Object, ThisObject, Row);
	EndDo;
EndProcedure

#EndRegion

#Region ACQUIRING

&AtClient
Procedure PayByCard(Command)
	
	If Not IsBlankString(Object.RRNCode) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().EqAc_AlreadyhasTransaction, "Object.RRNCode", "RRNCode");
		Return;
	EndIf;
		
	Write();
	
	Hardware = CommonFunctionsServer.GetRefAttribute(Object.Account, "Acquiring");
	
	Settings = EquipmentAcquiringAPIClient.OpenPaymentFormSettings();
	Settings.Amount = Object.DocumentAmount;
	Settings.Hardware = Hardware;
	
	NotifyOnClose = New NotifyDescription("PayByCardEnd", ThisObject);
	
	OpenForm("CommonForm.PaymentByAcquiring", New Structure("OpenSettings", Settings), ThisObject, , , , NotifyOnClose, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

// Pay by card end.
// 
// Parameters:
//  Result - See EquipmentAcquiringAPIClient.PayByPaymentCardSettings
//  AddInfo - Undefined - Add info
&AtClient
Procedure PayByCardEnd(Result, AddInfo) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	Object.RRNCode = Result.Out.RRNCode;
	Object.PaymentInfo = CommonFunctionsServer.SerializeJSON(Result);
	
	Write();
	
EndProcedure

#EndRegion
