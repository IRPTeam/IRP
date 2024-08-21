#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocCashReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocCashReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocCashReceiptClient.OnOpen(Object, ThisObject, Cancel);
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
	StrAll = "CurrencyExchange,
	|PaymentList.BasisDocument,
	|PaymentList.Partner,
	|PaymentList.PlaningTransactionBasis,
	|PaymentList.Agreement,
	|PaymentList.LegalNameContract,
	|PaymentList.Payer,
	|PaymentList.AmountExchange,
	|PaymentList.Order,
	|PaymentList.MoneyTransfer,
	|PaymentList.RetailCustomer,
	|PaymentList.SendingAccount,
	|PaymentList.SendingBranch,
	|PaymentList.Project";

	ArrayOfAllAttributes = New Array();
	For Each ArrayItem In StrSplit(StrAll, ",") Do
		ArrayOfAllAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	CashTransferOrder   = PredefinedValue("Enum.IncomingPaymentTransactionType.CashTransferOrder");
	CurrencyExchange    = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange");
	PaymentFromCustomer = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	ReturnFromVendor    = PredefinedValue("Enum.IncomingPaymentTransactionType.ReturnFromVendor");
	CashIn              = PredefinedValue("Enum.IncomingPaymentTransactionType.CashIn");
	RetailCustomerAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance");
	EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	OtherPartner        = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherPartner");
	
	// visible columns
	If TransactionType = CashTransferOrder Then
		StrByType = "
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.SendingAccount,
		|PaymentList.SendingBranch";
	ElsIf TransactionType = CashIn Then
		StrByType = "
		|PaymentList.MoneyTransfer";		
	ElsIf TransactionType = CurrencyExchange Then
		StrByType = "
		|CurrencyExchange,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.Partner,
		|PaymentList.AmountExchange,
		|PaymentList.SendingAccount,
		|PaymentList.SendingBranch";
	ElsIf TransactionType = PaymentFromCustomer Or TransactionType = ReturnFromVendor Then
		StrByType = "
		|PaymentList.BasisDocument,
		|PaymentList.Partner,
		|PaymentList.Agreement,
		|PaymentList.Payer,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.LegalNameContract,
		|PaymentList.Project";
		If TransactionType = PaymentFromCustomer Then
			StrByType = StrByType + ", PaymentList.Order";
		EndIf;
	ElsIf TransactionType = OtherPartner Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.Agreement,
		|PaymentList.Payer,
		|PaymentList.LegalNameContract";		
	ElsIf TransactionType = RetailCustomerAdvance Then
		StrByType = "
		|PaymentList.RetailCustomer,
		|PaymentList.Order";
	ElsIf TransactionType = EmployeeCashAdvance Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.Agreement,
		|PaymentList.BasisDocument";		
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
	IsPaymentFormCustomer = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	
	ArrayTypes = New Array();
	
	If IsCurrencyExchange Or IsCashTransferOrder Then
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") 
				And ValueIsFilled(Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		Form.Items.CurrencyExchange.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CurrencyExchange);
		Form.Items.CashAccount.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.CashAccount);
		Form.Items.Company.ReadOnly 	= BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		Form.Items.Currency.ReadOnly 	= BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);		
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
	Else
		ArrayTypes.Add(Type("DocumentRef.OutgoingPaymentOrder"));
	EndIf;
	Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	Form.Items.PaymentListPaymentByDocuments.Enabled = Not Form.ReadOnly;

	Form.Items.PaymentListPaymentByDocuments.Visible = IsPaymentFormCustomer;
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
	DocCashReceiptClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocCashReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocCashReceiptClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT

&AtClient
Procedure AccountOnChange(Item)
	DocCashReceiptClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CashAccountEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocCashReceiptClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYMENT_LIST

&AtClient
Procedure PaymentListSelection(Item, RowSelected, Field, StandardProcessing)
	DocCashReceiptClient.PaymentListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocCashReceiptClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocCashReceiptClient.PaymentListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

#Region PARTNER

&AtClient
Procedure PaymentListPartnerOnChange(Item)
	DocCashReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region PAYER

&AtClient
Procedure PaymentListPayerOnChange(Item)
	DocCashReceiptClient.PaymentListPayerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayerEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure PaymentListAgreementOnChange(Item)
	DocCashReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item)
	DocCashReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region PLANNING_TRANSACTION_BASIS

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item)
	DocCashReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListTransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region MONEY_TRANSFER

&AtClient
Procedure PaymentListMoneyTransferOnChange(Item)
	DocCashReceiptClient.PaymentListMoneyTransferOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListMoneyTransferStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListMoneyTransferStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region _ORDER

&AtClient
Procedure PaymentListOrderStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure PaymentListNetAmountOnChange(Item)
	DocCashReceiptClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure PaymentListTotalAmountOnChange(Item)
	DocCashReceiptClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure PaymentListTaxAmountOnChange(Item)
	DocCashReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure PaymentListVatRateOnChange(Item) Export
	DocCashReceiptClient.PaymentListVatRateOnChange(Object, ThisObject, Item);
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
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure WorkstationOnChange(Item)
	DocCashReceiptClient.WorkstationOnChange(Object, ThisObject, Item);
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

