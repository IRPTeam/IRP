
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
	CurrenciesServer.BeforeWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
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
Procedure DetailsByRowOnChange(Item)
	DocBankReceiptClient.DetailsByRowOnChange(Object, ThisObject, Item);
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
		Raise StrTemplate("Unsupported direction [%1]", Direction);
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
	Map.Insert("PaymentList.Employee"                         ,"PaymentListEmployeeNoSplits");
	Map.Insert("PaymentList.PaymentPeriod"                    ,"PaymentListPaymentPeriodNoSplits");
	Map.Insert("PaymentList.CalculationType"                  ,"PaymentListCalculationTypeNoSplits");
	Map.Insert("PaymentList.RetailCustomer"                   ,"PaymentListRetailCustomerNoSplits");
	Map.Insert("PaymentList.Partner"                          ,"PaymentListPartnerNoSplits");
	Map.Insert("PaymentList.Payer"                            ,"PaymentListPayerNoSplits");
	Map.Insert("PaymentList.Agreement"                        ,"PaymentListAgreementNoSplits");
	Map.Insert("PaymentList.LegalNameContract"                ,"PaymentListLegalNameContractNoSplits");
	Map.Insert("PaymentList.PaymentType"                      ,"PaymentListPaymentTypeNoSplits");
	Map.Insert("PaymentList.PaymentTerminal"                  ,"PaymentListPaymentTerminalNoSplits");
	Map.Insert("PaymentList.BankTerm"                         ,"PaymentListBankTermNoSplits");
	Map.Insert("PaymentList.BasisDocument"                    ,"PaymentListBasisDocumentNoSplits");
	Map.Insert("PaymentList.Project"                          ,"PaymentListProjectNoSplits");
	Map.Insert("PaymentList.Order"                            ,"PaymentListOrderNoSplits");
	Map.Insert("PaymentList.VatRate"                          ,"PaymentListVatRateNoSplits");
	Map.Insert("PaymentList.NetAmount"                        ,"PaymentListNetAmountNoSplits");
	Map.Insert("PaymentList.TaxAmount"                        ,"PaymentListTaxAmountNoSplits");
	Map.Insert("PaymentList.TotalAmount"                      ,"PaymentListTotalAmountNoSplits");
	Map.Insert("PaymentList.FinancialMovementType"            ,"PaymentListFinancialMovementTypeNoSplits");
	Map.Insert("PaymentList.CashFlowCenter"                   ,"PaymentListCashFlowCenterNoSplits");
	Map.Insert("PaymentList.SendingAccount"                   ,"PaymentListSendingAccountNoSplits");
	Map.Insert("PaymentList.SendingBranch"                    ,"PaymentListSendingBranchNoSplits");
	Map.Insert("PaymentList.RevenueType"                      ,"PaymentListRevenueTypeNoSplits");
	Map.Insert("PaymentList.POSAccount"                       ,"PaymentListPOSAccountNoSplits");
	Map.Insert("PaymentList.AmountExchange"                   ,"PaymentListAmountExchangeNoSplits");
	Map.Insert("PaymentList.PlaningTransactionBasis"          ,"PaymentListPlaningTransactionBasisNoSplits");
	Map.Insert("PaymentList.CommissionPercent"                ,"PaymentListCommissionPercentNoSplits");
	Map.Insert("PaymentList.Commission"                       ,"PaymentListCommissionNoSplits");
	Map.Insert("PaymentList.CommissionFinancialMovementType"  ,"PaymentListCommissionFinancialMovementTypeNoSplits");
	Map.Insert("PaymentList.ProfitLossCenter"                 ,"PaymentListProfitLossCenterNoSplits");
	Map.Insert("PaymentList.ExpenseType"                      ,"PaymentListExpenseTypeNoSplits");
	Map.Insert("PaymentList.AdditionalAnalytic"               ,"PaymentListAdditionalAnalyticNoSplits");
	Map.Insert("PaymentList.Branch"                           ,"PaymentListBranchNoSplits");
	Map.Insert("PaymentList.ApArPostingDetail"                ,"PaymentListApArPostingDetailNoSplits");
	Return Map;
EndFunction

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
	|PaymentList.CommissionFinancialMovementType,
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
	TransferFromPOS     = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS");
	PaymentFromCustomerByPOS = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS");
	ReceiptByCheque     = PredefinedValue("Enum.IncomingPaymentTransactionType.ReceiptByCheque");
	RetailCustomerAdvance  = PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance");
	EmployeeCashAdvance = PredefinedValue("Enum.IncomingPaymentTransactionType.EmployeeCashAdvance");
	OtherIncome         = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherIncome");
	OtherPartner        = PredefinedValue("Enum.IncomingPaymentTransactionType.OtherPartner");
	SalaryReturn        = PredefinedValue("Enum.IncomingPaymentTransactionType.SalaryReturn");
		
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
	IsTransferFromPOS     = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.TransferFromPOS");
	IsReceiptByCheque     = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.ReceiptByCheque");
	IsPaymentFormCustomer = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.PaymentFromCustomer");
	IsSalaryReturn		  = Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.SalaryReturn");

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
	Form.Items.PaymentListPlaningTransactionBasisNoSplits.TypeRestriction = New TypeDescription(ArrayTypes);
	
	Form.Items.PaymentListBasisDocumentNoSplits.ReadOnly = 
		(Form.PaymentListApArPostingDetailNoSplits <> PredefinedValue("Enum.ApArPostingDetail.ByDocuments"));
	
	Form.Items.TransitAccount.ReadOnly = ValueIsFilled(Object.TransitAccount);
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.EditCurrenciesNoSplits.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccounting.Enabled = Not Form.ReadOnly;
	Form.Items.EditAccountingNoSplits.Enabled = Not Form.ReadOnly;
	Form.Items.PaymentListPaymentByDocuments.Enabled = Not Form.ReadOnly;

	Form.Items.PaymentListPaymentByDocuments.Visible = IsPaymentFormCustomer;
	
	Form.Items.ExpenseType.Visible  = IsCurrencyExchange;
	Form.Items.LossCenter.Visible   = IsCurrencyExchange;
	Form.Items.RevenueType.Visible  = IsCurrencyExchange;
	Form.Items.ProfitCenter.Visible = IsCurrencyExchange;
	
	Form.Items.PaymentListBranch.Visible = IsSalaryReturn;
	Form.Items.PaymentListBranchNoSplits.Visible = IsSalaryReturn;
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

#Region COMMISSION_FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListCommissionFinancialMovementTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListCommissionFinancialMovementTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
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

#Region NET_AMOUNT

&AtClient
Procedure PaymentListNetAmountOnChange(Item)
	DocBankReceiptClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListNetAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListNetAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region TAX_AMOUNT

&AtClient
Procedure PaymentListTaxAmountOnChange(Item)
	DocBankReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTaxAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.ItemListTaxAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region TOTAL_AMOUNT

&AtClient
Procedure PaymentListTotalAmountOnChange(Item)
	DocBankReceiptClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTotalAmountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region VAT_RATE

&AtClient
Procedure PaymentListVatRateOnChange(Item) Export
	DocBankReceiptClient.PaymentListVatRateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListVatRateNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListVatRateOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

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

&AtClient
Procedure PaymentListPartnerNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListPartnerNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
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

&AtClient
Procedure PaymentListPayerNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListPayerOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPayerNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListPayerNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
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

&AtClient
Procedure PaymentListAgreementNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListAgreementNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
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

#Region COMMISSION

&AtClient
Procedure PaymentListCommissionOnChange(Item)
	DocBankReceiptClient.PaymentListCommissionOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListCommissionNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListCommissionOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region PAYMENT_TYPE

&AtClient
Procedure PaymentListPaymentTypeOnChange(Item)
	DocBankReceiptClient.PaymentListPaymentTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPaymentTypeNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListPaymentTypeOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region BANK_TERM

&AtClient
Procedure PaymentListBankTermOnChange(Item)
	DocBankReceiptClient.PaymentListBankTermOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBankTermNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListBankTermOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

#EndRegion

#Region COMMISSION_PERCENT

&AtClient
Procedure PaymentListCommissionPercentOnChange(Item)
	DocBankReceiptClient.PaymentListCommissionPercentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListCommissionPercentNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListCommissionPercentOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
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

#Region EXPENSE_TYPE

&AtClient
Procedure PaymentListExpenseTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	DocBankReceiptClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region REVENUE_TYPE

&AtClient
Procedure PaymentListRevenueTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	DocBankReceiptClient.PaymentListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListRevenueTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region FINANCIAL_MOVEMENT_TYPE

&AtClient
Procedure PaymentListFinancialMovementTypeOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	DocBankReceiptClient.PaymentListFinancialMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

&AtClient
Procedure PaymentListFinancialMovementTypeNoSplitsEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListFinancialMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region POS_ACCOUNT

&AtClient
Procedure PaymentListPOSAccountOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListPOSAccountNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	UpdateFormAttributes(Object, ThisObject, "FromHeaderToList");
EndProcedure

#EndRegion

#Region AMOUNT_EXCHANGE

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

#Region BASIS_DOCUMENT

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item)
	DocBankReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
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

&AtClient
Procedure PaymentListPlaningTransactionBasisNoSplitsOnChange(Item)
	LineAttribute = GetLineAttributeByNoSplitsAttribute(Object, ThisObject, Item.Name);
	If LineAttribute <> Undefined Then
		SetLineAttributeValue(Object, ThisObject, LineAttribute, ThisObject[Item.Name]);
	EndIf;
	DocBankReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item, Object.PaymentList[0], "FromHeaderToList");
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisNoSplitsStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	DocBankReceiptClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
EndProcedure

#EndRegion

#Region _ORDER

&AtClient
Procedure PaymentListOrderOnChange(Item)
	UpdateFormAttributes(Object, ThisObject, "FromListToHeader");
EndProcedure

&AtClient
Procedure PaymentListOrderStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
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
	DocBankReceiptClient.PaymentListOrderStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, Object.PaymentList[0]);
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
