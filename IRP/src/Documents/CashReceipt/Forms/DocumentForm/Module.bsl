
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
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
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
Procedure DetailsByRowOnChange(Item)
	DocCashReceiptClient.DetailsByRowOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure FormUpdateFormAttributes(Direction) Export
	UpdateFormAttributes(Object, ThisObject, Direction);
EndProcedure

&AtClientAtServerNoContext
Procedure UpdateFormAttributes(Object, Form, Direction)
	AttributesMapping = GetFormAttributeMapping();
	
	If Direction = "FromListToHeader" Then
		For Each Row In AttributesMapping Do
			Form[Row.Value] = GetLineAttributeValue(Object, Form, Row.Key);
		EndDo;	
	ElsIf Direction = "FromHeaderToList" Then
		For Each Row In AttributesMapping Do
			SetLineAttributeValue(Object, Form, Row.Key, Form[Row.Value]);
		EndDo;		
	Else
		Raise StrTemplate(R().UnsupportedDirection, Direction);
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Function GetLineAttributeByNoSplitsAttribute(Object, Form, NoSplitsAttributeName)
	AttributesMapping = GetFormAttributeMapping();
	For Each Row In AttributesMapping Do
		If Upper(Row.Value) = Upper(NoSplitsAttributeName) Then
			Return Row.Key;
		EndIf;
	EndDo;
	Return Undefined;
Endfunction

&AtClientAtServerNoContext
Procedure SetLineAttributeValue(Object, Form, AttributeName, Value)
	If Object.PaymentList.Count() = 1 Then
		Object.PaymentList[0][StrSplit(AttributeName, ".")[1]] = Value;
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Function GetLineAttributeValue(Object, Form, AttributeName)
	If Object.PaymentList.Count() = 1 Then
		Return Object.PaymentList[0][StrSplit(AttributeName, ".")[1]];
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtClientAtServerNoContext
Function GetFormAttributeMapping() Export
	Map = New Map();
	Map.Insert("PaymentList.Employee"                , "PaymentListEmployeeNoSplits");
	Map.Insert("PaymentList.PaymentPeriod"           , "PaymentListPaymentPeriodNoSplits");
	Map.Insert("PaymentList.CalculationType"         , "PaymentListCalculationTypeNoSplits");
	Map.Insert("PaymentList.RetailCustomer"          , "PaymentListRetailCustomerNoSplits");
	Map.Insert("PaymentList.Partner"                 , "PaymentListPartnerNoSplits");
	Map.Insert("PaymentList.LegalName"               , "PaymentListLegalNameNoSplits");
	Map.Insert("PaymentList.Agreement"               , "PaymentListAgreementNoSplits");
	Map.Insert("PaymentList.LegalNameContract"       , "PaymentListLegalNameContractNoSplits");
	Map.Insert("PaymentList.BasisDocument"           , "PaymentListBasisDocumentNoSplits");
	Map.Insert("PaymentList.Project"                 , "PaymentListProjectNoSplits");
	Map.Insert("PaymentList.Order"                   , "PaymentListOrderNoSplits");
	Map.Insert("PaymentList.VatRate"                 , "PaymentListVatRateNoSplits");
	Map.Insert("PaymentList.NetAmount"               , "PaymentListNetAmountNoSplits");
	Map.Insert("PaymentList.TaxAmount"               , "PaymentListTaxAmountNoSplits");
	Map.Insert("PaymentList.TotalAmount"             , "PaymentListTotalAmountNoSplits");
	Map.Insert("PaymentList.FinancialMovementType"   , "PaymentListFinancialMovementTypeNoSplits");
	Map.Insert("PaymentList.CashFlowCenter"          , "PaymentListCashFlowCenterNoSplits");
	Map.Insert("PaymentList.SendingAccount"          , "PaymentListSendingAccountNoSplits");
	Map.Insert("PaymentList.SendingBranch"           , "PaymentListSendingBranchNoSplits");
	Map.Insert("PaymentList.AmountExchange"          , "PaymentListAmountExchangeNoSplits");
	Map.Insert("PaymentList.PlaningTransactionBasis" , "PaymentListPlaningTransactionBasisNoSplits");
	Map.Insert("PaymentList.MoneyTransfer"           , "PaymentListMoneyTransferNoSplits");
	Return Map;
EndFunction

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
	|PaymentList.LegalName,
	|PaymentList.AmountExchange,
	|PaymentList.Order,
	|PaymentList.MoneyTransfer,
	|PaymentList.RetailCustomer,
	|PaymentList.SendingAccount,
	|PaymentList.SendingBranch,
	|PaymentList.Project,
	|PaymentList.Employee,
	|PaymentList.PaymentPeriod,
	|PaymentList.CalculationType";

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
	SalaryReturn        = PredefinedValue("Enum.IncomingPaymentTransactionType.SalaryReturn");
	
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
		|PaymentList.LegalName,
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
		|PaymentList.LegalName,
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
	ElsIf TransactionType = SalaryReturn Then
		StrByType = "
		|PaymentList.Employee,
		|PaymentList.PaymentPeriod,
		|PaymentList.CalculationType";
	EndIf;

	ArrayOfVisibleAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfVisibleAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	Return New Structure("AllAttributes, VisibleAttributes", ArrayOfAllAttributes, ArrayOfVisibleAttributes);
EndFunction

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	DetailsByRowEnabled = (Object.PaymentList.Count() <= 1);
	Form.Items.DetailsByRow.Enabled          = DetailsByRowEnabled;
	Form.Items.DetailsByRowNoSplits.Enabled  = DetailsByRowEnabled;
	
	Form.Items.GroupByRow.Visible    = Object.DetailsByRow;
	Form.Items.GroupByList.Visible   = Not Object.DetailsByRow;
		
	AttributesMapping = GetFormAttributeMapping();
	AttributesForChangeVisible = GetVisibleAttributesByTransactionType(Object.TransactionType);
	For Each Attr In AttributesForChangeVisible.AllAttributes Do
		ItemName = TrimAll(StrReplace(Attr, ".", ""));
		Visibility = (AttributesForChangeVisible.VisibleAttributes.Find(Attr) <> Undefined);
		Form.Items[ItemName].Visible = Visibility;
		
		NoSplitsAttribute = AttributesMapping.Get(Attr);
		If NoSplitsAttribute <> Undefined Then
			Form.Items[NoSplitsAttribute].Visible = Visibility;
		EndIf;
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
	Form.Items.PaymentListPlaningTransactionBasisNoSplits.TypeRestriction = New TypeDescription(ArrayTypes);
	
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesNoSplits.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccountingNoSplits.Enabled = Not Form.ReadOnly;
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

#Region EMPLOYEE

&AtClient
Procedure PaymentListEmployeeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListEmployeeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region PAYMENT_PERIOD

&AtClient
Procedure PaymentListPaymentPeriodOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListPaymentPeriodNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region CALCULATION_TYPE

&AtClient
Procedure PaymentListCalculationTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListCalculationTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region RETAIL_CUSTOMER

&AtClient
Procedure PaymentListRetailCustomerOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListRetailCustomerNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

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

&AtClient
Procedure PaymentListPartnerNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure PaymentListLegalNameOnChange(Item)
	DocCashReceiptClient.PaymentListLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListLegalNameNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListLegalNameOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListLegalNameNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListLegalNameNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
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

&AtClient
Procedure PaymentListAgreementNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region LEGAL_NAME_CONTRACT

&AtClient
Procedure PaymentListLegalNameContractOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListLegalNameContractNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region SENDING_ACCOUNT

&AtClient
Procedure PaymentListSendingAccountOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListSendingAccountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region SENDING_BRANCH

&AtClient
Procedure PaymentListSendingBranchOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListSendingBranchNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure PaymentListVatRateOnChange(Item) Export
	DocCashReceiptClient.PaymentListVatRateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListVatRateNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListVatRateOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure PaymentListNetAmountOnChange(Item)
	DocCashReceiptClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListNetAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListNetAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure PaymentListTaxAmountOnChange(Item)
	DocCashReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTaxAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure PaymentListTotalAmountOnChange(Item)
	DocCashReceiptClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTotalAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
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

&AtClient
Procedure PaymentListBasisDocumentNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
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

&AtClient
Procedure PaymentListPlaningTransactionBasisNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListTransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region _ORDER

&AtClient
Procedure PaymentListOrderOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListOrderStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOrderNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListOrderNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region CASH_FLOW_CENTER

&AtClient
Procedure PaymentListCashFlowCenterOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListCashFlowCenterNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region PROJECT

&AtClient
Procedure PaymentListProjectOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListProjectNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListFinancialMovementTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocCashReceiptClient.PaymentListMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
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

&AtClient
Procedure PaymentListMoneyTransferNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocCashReceiptClient.PaymentListMoneyTransferOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListMoneyTransferNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocCashReceiptClient.PaymentListMoneyTransferStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region AMOUNT_EXCANGE

&AtClient
Procedure PaymentListAmountExchangeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListAmountExchangeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
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
	_EditCurrencies(CurrentData);
EndProcedure

&AtClient
Procedure EditCurrenciesNoSplits(Command)
	_EditCurrencies(Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure _EditCurrencies(CurrentData)
	FormParameters = CurrenciesClientServer.GetParameters_V8(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New CallbackDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure EditAccounting(Command)
	CurrentData = ThisObject.Items.PaymentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	_EditAccounting(CurrentData);
EndProcedure

&AtClient
Procedure EditAccountingNoSplits(Command)
	_EditAccounting(Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure _EditAccounting(CurrentData)
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
	Notify = New CallbackDescription("PaymentByDocumentSelectionEnd", ThisObject);		
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

&AtClient
Procedure SetNewNumber(Command)
	SetNewNumberAtServer();
EndProcedure

&AtServer
Procedure SetNewNumberAtServer()
	If Object.NumeratorRules.IsEmpty() Then
		Object.NumeratorRules = 
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object.Date);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

#EndRegion

