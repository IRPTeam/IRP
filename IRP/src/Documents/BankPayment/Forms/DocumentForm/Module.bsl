
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocBankPaymentServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	DocBankPaymentServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
	AccountingServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocBankPaymentServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocBankPaymentClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure DetailsByRowOnChange(Item)
	DocBankPaymentClient.DetailsByRowOnChange(Object, ThisObject, Item);
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
	Map.Insert("PaymentList.PaymentType"             , "PaymentListPaymentTypeNoSplits");
	Map.Insert("PaymentList.PaymentTerminal"         , "PaymentListPaymentTerminalNoSplits");
	Map.Insert("PaymentList.BankTerm"                , "PaymentListBankTermNoSplits");
	Map.Insert("PaymentList.ApArPostingDetail"       , "PaymentListApArPostingDetailNoSplits");
	Map.Insert("PaymentList.BasisDocument"           , "PaymentListBasisDocumentNoSplits");
	Map.Insert("PaymentList.Project"                 , "PaymentListProjectNoSplits");
	Map.Insert("PaymentList.Order"                   , "PaymentListOrderNoSplits");
	Map.Insert("PaymentList.VatRate"                 , "PaymentListVatRateNoSplits");
	Map.Insert("PaymentList.NetAmount"               , "PaymentListNetAmountNoSplits");
	Map.Insert("PaymentList.TaxAmount"               , "PaymentListTaxAmountNoSplits");
	Map.Insert("PaymentList.TotalAmount"             , "PaymentListTotalAmountNoSplits");
	Map.Insert("PaymentList.FinancialMovementType"   , "PaymentListFinancialMovementTypeNoSplits");
	Map.Insert("PaymentList.CashFlowCenter"          , "PaymentListCashFlowCenterNoSplits");
	Map.Insert("PaymentList.ReceiptingAccount"       , "PaymentListReceiptingAccountNoSplits");
	Map.Insert("PaymentList.ReceiptingBranch"        , "PaymentListReceiptingBranchNoSplits");
	Map.Insert("PaymentList.PlaningTransactionBasis" , "PaymentListPlaningTransactionBasisNoSplits");
	Map.Insert("PaymentList.ProfitLossCenter"        , "PaymentListProfitLossCenterNoSplits");
	Map.Insert("PaymentList.ExpenseType"             , "PaymentListExpenseTypeNoSplits");
	Map.Insert("PaymentList.RevenueType"             , "PaymentListRevenueTypeNoSplits");
	Map.Insert("PaymentList.Branch"                  , "PaymentListBranchNoSplits");
	Map.Insert("PaymentList.Tax"                     , "PaymentListTaxNoSplits");
	Map.Insert("PaymentList.TaxDiscountAmount"       , "PaymentListTaxDiscountAmountNoSplits");
	Map.Insert("PaymentList.AdditionalAnalytic"      , "PaymentListAdditionalAnalyticNoSplits");

	Return Map;
EndFunction

&AtClientAtServerNoContext
Function GetVisibleAttributesByTransactionType(TransactionType)
	StrAll = "TransitAccount,
	|PaymentList.Partner,
	|PaymentList.LegalName,
	|PaymentList.Agreement,
	|PaymentList.LegalNameContract,
	|PaymentList.BasisDocument,
	|PaymentList.PlaningTransactionBasis,
	|PaymentList.Order,
	|PaymentList.PaymentType,
	|PaymentList.PaymentTerminal,
	|PaymentList.BankTerm,
	|PaymentList.RetailCustomer,
	|PaymentList.Employee,
	|PaymentList.PaymentPeriod,
	|PaymentList.CalculationType,
	|PaymentList.ReceiptingAccount,
	|PaymentList.ReceiptingBranch,
	|PaymentList.Project,
	|PaymentList.ExpenseType,
	|PaymentList.ProfitLossCenter,
	|PaymentList.AdditionalAnalytic,
	|PaymentList.Tax,
	|PaymentList.TaxDiscountAmount,
	|PaymentList.RevenueType";
		
	ArrayOfAllAttributes = New Array();
	For Each ArrayItem In StrSplit(StrAll, ",") Do
		ArrayOfAllAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	
	CashTransferOrder = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	CurrencyExchange  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	PaymentToVendor   = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	ReturnToCustomer  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer");
	ReturnToCustomerByPOS  = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS");
	PaymentByCheque     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentByCheque");
	PaymentByCheque     = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentByCheque");
	RetailCustomerAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance");
	EmployeeCashAdvance = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance");
	SalaryPayment       = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.SalaryPayment");
	OtherPartner        = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.OtherPartner");
	OtherExpense        = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.OtherExpense");
	
	If TransactionType = CashTransferOrder Then
		StrByType = "
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.ReceiptingAccount,
		|PaymentList.ReceiptingBranch";
	ElsIf TransactionType = CurrencyExchange Then
		StrByType = "
		|TransitAccount, 
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.ReceiptingAccount,
		|PaymentList.ReceiptingBranch";
	ElsIf TransactionType = PaymentToVendor 
		Or TransactionType = ReturnToCustomer
		Or TransactionType = ReturnToCustomerByPOS Then
		StrByType = "
		|PaymentList.BasisDocument,
		|PaymentList.Partner,
		|PaymentList.Agreement,
		|PaymentList.LegalName,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.LegalNameContract";
		If TransactionType = PaymentToVendor Then
			StrByType = StrByType + ", PaymentList.Order";
		EndIf;
		
		If TransactionType = ReturnToCustomerByPOS Then
			StrByType = StrByType + ", 
			|PaymentList.PaymentType,
			|PaymentList.PaymentTerminal,
			|PaymentList.BankTerm";
		EndIf;	
		
		If TransactionType = PaymentToVendor Or TransactionType = ReturnToCustomer Then
			StrByType = StrByType + ", PaymentList.Project";
		EndIf;
		
	ElsIf TransactionType = OtherPartner Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.Agreement,
		|PaymentList.LegalName,
		|PaymentList.LegalNameContract,
		|PaymentList.AdditionalAnalytic,
		|PaymentList.Tax,
		|PaymentList.TaxDiscountAmount,
		|PaymentList.ProfitLossCenter,
		|PaymentList.RevenueType";
	ElsIf TransactionType = PaymentByCheque Then
		StrByType = "
		|PaymentList.PlaningTransactionBasis";
	ElsIf TransactionType = RetailCustomerAdvance Then
		StrByType = "
		|PaymentList.RetailCustomer,
		|PaymentList.PaymentType,
		|PaymentList.PaymentTerminal,
		|PaymentList.BankTerm,
		|PaymentList.Order";
	ElsIf TransactionType = EmployeeCashAdvance Then
		StrByType = "
		|PaymentList.Partner,
		|PaymentList.PlaningTransactionBasis,
		|PaymentList.Agreement,
		|PaymentList.BasisDocument";
	ElsIf TransactionType = SalaryPayment Then
		StrByType = "
		|PaymentList.Employee,
		|PaymentList.PaymentPeriod,
		|PaymentList.CalculationType";
	ElsIf TransactionType = OtherExpense Then
		StrByType = "
		|PaymentList.ExpenseType,
		|PaymentList.ProfitLossCenter,
		|PaymentList.AdditionalAnalytic";
	EndIf;
	
	ArrayOfVisibleAttributes = New Array();
	For Each ArrayItem In StrSplit(StrByType, ",") Do
		ArrayOfVisibleAttributes.Add(StrReplace(TrimAll(ArrayItem), Chars.NBSp, ""));
	EndDo;
	Return New Structure("AllAttributes, VisibleAttributes", ArrayOfAllAttributes, ArrayOfVisibleAttributes);
EndFunction

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

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
	
	IsCurrencyExchange    = Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange");
	IsCashTransferOrder   = Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CashTransferOrder");
	IsPaymentByCheque     = Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentByCheque");
	IsSalaryPayment       = Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.SalaryPayment");
	IsPaymentToVendor     = Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.PaymentToVendor");
	
	ArrayTypes = New Array();
	
	If IsCurrencyExchange Or IsCashTransferOrder Then
		BasedOnCashTransferOrder = False;
		BasedOnCashTransferOrder = False;
		For Each Row In Object.PaymentList Do
			If TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder") 
				And ValueIsFilled(Row.PlaningTransactionBasis) Then
				BasedOnCashTransferOrder = True;
				Break;
			EndIf;
		EndDo;
		Form.Items.Account.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Account);
		Form.Items.Company.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Company);
		Form.Items.Currency.ReadOnly = BasedOnCashTransferOrder And ValueIsFilled(Object.Currency);
	
		ArrayTypes.Add(Type("DocumentRef.CashTransferOrder"));
			
	ElsIf IsPaymentByCheque Then
		ArrayTypes.Add(Type("DocumentRef.ChequeBondTransactionItem"));
	Else
		ArrayTypes.Add(Type("DocumentRef.OutgoingPaymentOrder"));
	EndIf;
	Form.Items.PaymentListPlaningTransactionBasis.TypeRestriction = New TypeDescription(ArrayTypes);
	Form.Items.PaymentListPlaningTransactionBasisNoSplits.TypeRestriction = New TypeDescription(ArrayTypes);
	
	Form.Items.PaymentListBasisDocumentNoSplits.ReadOnly = 
		(Form.PaymentListApArPostingDetailNoSplits <> PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	
	Form.Items.TransitAccount.ReadOnly = ValueIsFilled(Object.TransitAccount);
	
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;	
	Form.Items.EditCurrenciesNoSplits.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccountingNoSplits.Enabled = Not Form.ReadOnly;
	
	Form.Items.PaymentListChoiceByAccrual.Enabled    = Not Form.ReadOnly;
	Form.Items.PaymentListPaymentByDocuments.Enabled = Not Form.ReadOnly;
	Form.Items.PaymentListChoiceByAccrual.Visible    = IsSalaryPayment;
	Form.Items.PaymentListPaymentByDocuments.Visible = IsPaymentToVendor;
	
	Form.Items.PaymentListBranch.Visible             = IsSalaryPayment;
	Form.Items.PaymentListBranchNoSplits.Visible     = IsSalaryPayment;
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
	DocBankPaymentClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocBankPaymentClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CURRENCY

&AtClient
Procedure CurrencyOnChange(Item)
	DocBankPaymentClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ACCOUNT

&AtClient
Procedure AccountOnChange(Item)
	DocBankPaymentClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSIT_ACCOUNT

&AtClient
Procedure TransitAccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.TransitAccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.TransitAccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TRANSACTION_TYPE

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocBankPaymentClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region PAYMENT_LIST

&AtClient
Procedure PaymentListSelection(Item, RowSelected, Field, StandardProcessing)
	DocBankPaymentClient.PaymentListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocBankPaymentClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocBankPaymentClient.PaymentListAfterDeleteRow(Object, ThisObject, Item);
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
	DocBankPaymentClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListPartnerOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region LEGAL_NAME

&AtClient
Procedure PaymentListLegalNameOnChange(Item)
	DocBankPaymentClient.PaymentListLegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.PaymentListLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListLegalNameNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListLegalNameOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListLegalNameNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListLegalNameNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region AGREEMENT

&AtClient
Procedure PaymentListAgreementOnChange(Item)
	DocBankPaymentClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListAgreementOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
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

#Region PAYMENT_TYPE

&AtClient
Procedure PaymentListPaymentTypeOnChange(Item)
	DocBankPaymentClient.PaymentListPaymentTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPaymentTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListPaymentTypeOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region PAYMENT_TERMINAL

&AtClient
Procedure PaymentListPaymentTerminalOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListPaymentTerminalNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region BANK_TERM

&AtClient
Procedure PaymentListBankTermOnChange(Item)
	DocBankPaymentClient.PaymentListBankTermOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBankTermNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListBankTermOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region BASIS_DOCUMENT

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item)
	DocBankPaymentClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
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

#Region _ORDER

&AtClient
Procedure PaymentListOrderOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListOrderStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOrderNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListOrderNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure PaymentListVatRateOnChange(Item) Export
	DocBankPaymentClient.PaymentListVatRateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListVatRateNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListVatRateOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region NET_AMOUNT

&AtClient
Procedure PaymentListNetAmountOnChange(Item)
	DocBankPaymentClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListNetAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListNetAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure PaymentListTaxAmountOnChange(Item)
	DocBankPaymentClient.PaymentListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTaxAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListTaxAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure PaymentListTotalAmountOnChange(Item)
	DocBankPaymentClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTotalAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListFinancialMovementTypeOnChange(Item)
	DocBankPaymentClient.PaymentListFinancialMovementTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListFinancialMovementTypeOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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

#Region RECEPTING_ACCOUNT

&AtClient
Procedure PaymentListReceiptingAccountOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListReceiptingAccountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region RECEIPTING_BRANCH

&AtClient
Procedure PaymentListReceiptingBranchOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListReceiptingBranchNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region PLANNING_TRANSACTION_BASIS

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item)
	DocBankPaymentClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankPaymentClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

#EndRegion

#Region PROFIT_LOSS_CENTER

&AtClient
Procedure PaymentListProfitLossCenterOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListProfitLossCenterNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region EXPENSE_TYPE

&AtClient
Procedure PaymentListExpenseTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankPaymentClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

&AtClient
Procedure PaymentListRevenueTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankPaymentClient.PaymentListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankPaymentClient.PaymentListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region _BRANCH

&AtClient
Procedure PaymentListBranchOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListBranchNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region _TAX

&AtClient
Procedure PaymentListTaxOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListTaxNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region TAX_DISCOUNT_AMOUNT

&AtClient
Procedure PaymentListTaxDiscountAmountOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListTaxDiscountAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region ADDITIONAL_ANALYTIC

&AtClient
Procedure PaymentListAdditionalAnalyticOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListAdditionalAnalyticNoSplitsOnChange(Item)
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
Procedure ChoiceByAccrual(Command)
	DocPayrollClient.ChoiceByAccrual(Object, ThisObject);
EndProcedure

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
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
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
Procedure PaymentByDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("SelectedDocuments", New Array());
	FormParameters.Insert("SelectedPositionWithoutDocuments", New Array());
	
	FormParameters.Insert("Ref"           , Object.Ref);
	FormParameters.Insert("Company"       , Object.Company);
	FormParameters.Insert("Branch"        , Object.Branch);
	FormParameters.Insert("Currency"      , Object.Currency);
	FormParameters.Insert("AllowedTypes"  , New Array());
	
	FormParameters.AllowedTypes.Add(Type("DocumentRef.PurchaseInvoice"));
	
	FormParameters.Insert("RegisterName", "R1021B_VendorsTransactions");
	
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

#Region ACQUIRING

&AtClient
Procedure ReturnToCard(Command)
	
	If Not IsBlankString(Object.RRNCode) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().EqAc_AlreadyhasTransaction, "Object.RRNCode", "RRNCode");
		Return;
	EndIf;
	
	Write();
	
	Hardware = CommonFunctionsServer.GetRefAttribute(Object.Account, "Acquiring");
	
	Settings = EquipmentAcquiringAPIClient.OpenPaymentFormSettings();
	Settings.Amount = Object.DocumentAmount;
	Settings.Hardware = Hardware;
	Settings.Interactive = True;
	Settings.isReturn = True;
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
	
	Object.RRNCode = Result.InOut.RRNCode;
	Object.PaymentInfo = CommonFunctionsServer.SerializeJSON(Result);
	
	Write();
	
EndProcedure

#EndRegion
