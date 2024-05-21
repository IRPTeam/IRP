
Function GetOperationsDefinition()
	Map = New Map();
	AO = Catalogs.AccountingOperations;
	// Bank payment
	// Transaction type - Payment to vendor
	Map.Insert(AO.BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	Map.Insert(AO.BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	// Transaction type - Return to customer
	Map.Insert(AO.BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	Map.Insert(AO.BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	// Transaction type - Cash transfer order
	Map.Insert(AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.CashTransferOrder));
	// Transaction type - Currency exchange
	Map.Insert(AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.CurrencyExchange));
	// Transaction type - Other partner
	Map.Insert(AO.BankPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.OtherPartner));	
	// Transaction type - Other expense
	Map.Insert(AO.BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.OtherExpense));	
	// Transaction type - Salary payment
	Map.Insert(AO.BankPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.SalaryPayment));	
	// Transaction type - Employee cash advance
	Map.Insert(AO.BankPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.EmployeeCashAdvance));
	
	// Bank receipt
	// Transaction type - Payment from customer
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	Map.Insert(AO.BankReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	// Transaction type - Return from vendor
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	Map.Insert(AO.BankReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	// Transaction type - Cash transfer order
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.CashTransferOrder));
	//  Transaction type - Currency exchange
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CurrencyExchange,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.CurrencyExchange));
	Map.Insert(AO.BankReceipt_DR_R3021B_CashInTransit_CR_R5021T_Revenues,
		New Structure("ByRow, TransactionType", False, Enums.IncomingPaymentTransactionType.CurrencyExchange));
	Map.Insert(AO.BankReceipt_DR_R5022T_Expenses_CR_R3021B_CashInTransit,
		New Structure("ByRow, TransactionType", False, Enums.IncomingPaymentTransactionType.CurrencyExchange));
	// Transaction type - Other partner
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R5015B_OtherPartnersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.OtherPartner));
	// Transaction type - Other income
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R5021_Revenues,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.OtherIncome));

	// Cash payment
	//  Transaction type - Payment to vendor
	Map.Insert(AO.CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	Map.Insert(AO.CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.PaymentToVendor));
	//  Transaction type - Return to customer
	Map.Insert(AO.CashPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	Map.Insert(AO.CashPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers, 
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer));
	//  Transaction type - Cash transfer order
	Map.Insert(AO.CashPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.CashTransferOrder));	
	//  Transaction type - Other partner
	Map.Insert(AO.CashPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.OtherPartner));	
	//  Transaction type - Other partner
	Map.Insert(AO.CashPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.SalaryPayment));	
	//  Transaction type - Employee cash advance
	Map.Insert(AO.CashPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand,
		New Structure("ByRow, TransactionType", True, Enums.OutgoingPaymentTransactionTypes.EmployeeCashAdvance));
	
	// Cash receipt
	//  Transaction type - Payment from customer
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	Map.Insert(AO.CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.PaymentFromCustomer));
	//  Transaction type - Return from vendor
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	Map.Insert(AO.CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.ReturnFromVendor));
	//  Transaction type - Cash transfer order
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming_CashTransferOrder,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.CashTransferOrder));	
	//  Transaction type - Other partner
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R5015B_OtherPartnersTransactions,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.OtherPartner));
	
	// Cash expense
	Map.Insert(AO.CashExpense_DR_R5022T_Expenses_CR_R3010B_CashOnHand , New Structure("ByRow", True));
	
	// Cash revenue
	Map.Insert(AO.CashRevenue_DR_R3010B_CashOnHand_CR_R5021_Revenues , New Structure("ByRow", True));
		
	// Debit note
	Map.Insert(AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
		
	// Credit note
	Map.Insert(AO.CreditNote_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions , New Structure("ByRow", True));
				
	// Purchase invoice
	// receipt inventory
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	// offset of advabces
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors,
		New Structure("ByRow, TransactionType", False, Enums.PurchaseTransactionTypes.Purchase));
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", False, Enums.PurchaseTransactionTypes.Purchase));
	
	Map.Insert(AO.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	
	// Sales invoice
	// sales inventory
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	// offset of advances
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", False, Enums.SalesTransactionTypes.Sales));
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_CurrencyRevaluation,
		New Structure("ByRow, TransactionType", False, Enums.SalesTransactionTypes.Sales));
	
	Map.Insert(AO.SalesInvoice_DR_R5021T_Revenues_CR_R2040B_TaxesIncoming,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	Map.Insert(AO.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	
	// Retail sales receipt
	Map.Insert(AO.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory , New Structure("ByRow", True));

	// Foreign currency revaluation
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues , New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers , New Structure("ByRow, RequestTable", True, True));
	
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3010B_CashOnHand , New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R3010B_CashOnHand_CR_R5021T_Revenues , New Structure("ByRow, RequestTable", True, True));
	
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R9510B_SalaryPayment, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R9510B_SalaryPayment_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3015B_CashAdvance, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R3015B_CashAdvance_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));

	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));
	
	// Money transfer
	Map.Insert(AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand    , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues   , New Structure("ByRow", False));
	Map.Insert(AO.MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit   , New Structure("ByRow", False));

	// Commissioning of fixed assets
	Map.Insert(AO.CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory, New Structure("ByRow", True));

	// Decommissioning of fixed assets
	Map.Insert(AO.DecommissioningOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", True));
	
	// Modernization of fixed assets
	Map.Insert(AO.ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory, New Structure("ByRow", True));
	Map.Insert(AO.ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", True));
 
 	// Fixed asstet transfer
	Map.Insert(AO.FixedAssetTransfer_DR_R8510B_BookValueOfFixedAsset_CR_R8510B_BookValueOfFixedAsset, New Structure("ByRow", False));
	
	// Depreciation calculation
	Map.Insert(AO.DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset, New Structure("ByRow", True));
	
	// Payroll
	Map.Insert(AO.Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual                , New Structure("ByRow, ReferTableName", True, "AccrualList"));
	Map.Insert(AO.Payroll_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes , New Structure("ByRow, ReferTableName", True, "SalaryTaxList"));
	Map.Insert(AO.Payroll_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes      , New Structure("ByRow, ReferTableName", True, "SalaryTaxList"));
	Map.Insert(AO.Payroll_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue    , New Structure("ByRow, ReferTableName", True, "DeductionList"));
	Map.Insert(AO.Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue , New Structure("ByRow, ReferTableName", True, "DeductionList"));
	Map.Insert(AO.Payroll_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance             , New Structure("ByRow, ReferTableName", True, "CashAdvanceDeductionList"));
	
	// Debit\Credit note
	Map.Insert(AO.DebitCreditNote_R5020B_PartnersBalance, New Structure("ByRow", False));
	Map.Insert(AO.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset, New Structure("ByRow", False));
	Map.Insert(AO.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset, New Structure("ByRow", False));
	
	ArrayOfAccrualsTransactionTypes = New Array();
	ArrayOfAccrualsTransactionTypes.Add(Enums.AccrualsTransactionType.Accrual);
	ArrayOfAccrualsTransactionTypes.Add(Enums.AccrualsTransactionType.Void);
	
	// Expense accruals
	Map.Insert(AO.ExpenseAccruals_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses, New Structure("ByRow, TransactionType", True, ArrayOfAccrualsTransactionTypes));
	Map.Insert(AO.ExpenseAccruals_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses, New Structure("ByRow, TransactionType", True, Enums.AccrualsTransactionType.Reverse));
	
	// Revenue accruals
	Map.Insert(AO.RevenueAccruals_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues, New Structure("ByRow,TransactionType", True, ArrayOfAccrualsTransactionTypes));
	Map.Insert(AO.RevenueAccruals_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues, New Structure("ByRow, TransactionType", True, Enums.AccrualsTransactionType.Reverse));
	
	// Employee cash advance
	Map.Insert(AO.EmployeeCashAdvance_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance, New Structure("ByRow", True));
	Map.Insert(AO.EmployeeCashAdvance_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance, New Structure("ByRow", True));
	
	// Sales return
	Map.Insert(AO.SalesReturn_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers, 
		New Structure("ByRow, TransactionType", False, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	Map.Insert(AO.SalesReturn_DR_R5021T_Revenues_CR_R2021B_CustomersTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	Map.Insert(AO.SalesReturn_DR_R5021T_Revenues_CR_R1040B_TaxesOutgoing, 
		New Structure("ByRow, TransactionType", True, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	Map.Insert(AO.SalesReturn_DR_R5022T_Expenses_CR_R4050B_StockInventory, 
		New Structure("ByRow, TransactionType", True, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	// Purchase return
	Map.Insert(AO.PurchaseReturn_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions, 
		New Structure("ByRow, TransactionType", False, Enums.PurchaseReturnTransactionTypes.ReturnToVendor));
	
	Map.Insert(AO.PurchaseReturn_DR_R1021B_VendorsTransactions_CR_R4050B_StockInventory, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseReturnTransactionTypes.ReturnToVendor));
	
	Map.Insert(AO.PurchaseReturn_DR_R2040B_TaxesIncoming_CR_R1021B_VendorsTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseReturnTransactionTypes.ReturnToVendor));
		
	Return Map;
EndFunction

Function GetSupportedDocuments() Export
	ArrayOfDocuments = New Array();
	For Each type In Metadata.DefinedTypes.typeAccountingDocuments.Type.Types() Do
		t = new(type);
		ArrayOfDocuments.Add(t.Metadata());
	EndDo;
	Return ArrayOfDocuments;
EndFunction

#Region Service

Function GetAccountingAnalyticsResult(Parameters) Export
	AccountingAnalytics = New Structure();
	AccountingAnalytics.Insert("Operation" , Parameters.Operation);
	AccountingAnalytics.Insert("LedgerType", Parameters.LedgerType);
	
	// Debit
	AccountingAnalytics.Insert("Debit", Undefined);
	AccountingAnalytics.Insert("DebitExtDimensions", New Array());
	
	// Credit
	AccountingAnalytics.Insert("Credit", Undefined);
	AccountingAnalytics.Insert("CreditExtDimensions", New Array());
	Return AccountingAnalytics;
EndFunction

Function GetAccountingDataResult()
	Result = New Structure();
	Result.Insert("CurrencyDr", Undefined);
	Result.Insert("CurrencyAmountDr", 0);
	Result.Insert("CurrencyCr", Undefined);
	Result.Insert("CurrencyAmountCr", 0);
	
	Result.Insert("QuantityDr", 0);
	Result.Insert("QuantityCr", 0);
	
	Result.Insert("Amount", 0);
	Return Result;
EndFunction

Function IsAdvance(RowData) Export
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	If RowData.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments
		And Not ValueIsFilled(RowData.BasisDocument) Then
			Return True;
	EndIf;
	Return False; // IsTransaction
EndFunction

Procedure SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintDebitExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Procedure SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintCreditExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Function ExtractValueByType(ObjectData, RowData, ArrayOfTypes, AdditionalAnalyticsValues)
	If AdditionalAnalyticsValues <> Undefined Then
		For Each KeyValue In AdditionalAnalyticsValues Do
			If ArrayOfTypes.Find(TypeOf(AdditionalAnalyticsValues[KeyValue.Key])) <> Undefined Then
				Return AdditionalAnalyticsValues[KeyValue.Key];
			EndIf;
		EndDo;	
	EndIf;

	If RowData <> Undefined Then
		If TypeOf(RowData) = Type("ValueTableRow") Then
			For Each RowItem In RowData Do
				If ArrayOfTypes.Find(TypeOf(RowItem)) <> Undefined Then
					Return RowItem;
				EndIf;
			EndDo;
		ElsIf TypeOf(RowData) = Type("Structure") Then	
			For Each KeyValue In RowData Do
				If ArrayOfTypes.Find(TypeOf(RowData[KeyValue.Key])) <> Undefined Then
					Return RowData[KeyValue.Key];
				EndIf;
			EndDo;
		Else
			Raise "Unsupported type of row data";
		EndIf;
	EndIf;
	
	For Each KeyValue In ObjectData Do
		If ArrayOfTypes.Find(TypeOf(ObjectData[KeyValue.Key])) <> Undefined Then
			Return ObjectData[KeyValue.Key];
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Function GetDataByAccountingAnalytics(BasisRef, AnalyticRow) Export
	Parameters = New Structure();
	Parameters.Insert("Recorder" , BasisRef);
	Parameters.Insert("RowKey"   , AnalyticRow.Key);
	Parameters.Insert("Operation", AnalyticRow.Operation);
	Parameters.Insert("CurrencyMovementType", AnalyticRow.LedgerType.CurrencyMovementType);
	Parameters.Insert("IsCurrencyRevaluation", 
		TypeOf(BasisRef) = Type("DocumentRef.ForeignCurrencyRevaluation"));
		
	Data = GetAccountingData(Parameters);
	
	Result = GetAccountingDataResult();

	If Data = Undefined Then
		Return Result;
	EndIf;
	
	If Data.Property("Amount") Then
		Result.Amount = Data.Amount;
	EndIf;
	
	If  Not ValueIsFilled(AnalyticRow.AccountDebit) Or  Not ValueIsFilled(AnalyticRow.AccountCredit) Then
		Return Result;
	EndIf;
			
	If Data.Property("CurrencyDr") Then
		Result.CurrencyDr = Data.CurrencyDr;
	EndIf;

	If Data.Property("CurrencyAmountDr") Then
		Result.CurrencyAmountDr = Data.CurrencyAmountDr;
	EndIf;

	If Data.Property("CurrencyCr") Then
		Result.CurrencyCr = Data.CurrencyCr;
	EndIf;

	If Data.Property("CurrencyAmountCr") Then
		Result.CurrencyAmountCr = Data.CurrencyAmountCr;
	EndIf;

	If Data.Property("QuantityDr") Then
		Result.QuantityDr = Data.QuantityDr;
	EndIf;

	If Data.Property("QuantityCr") Then
		Result.QuantityCr = Data.QuantityCr;
	EndIf;

	Return Result;	
EndFunction

Function GetLedgerTypesByCompany(Ref, Date, Company) Export
	If Not ValueIsFilled(Company) Then
		Return New Array();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CompanyLedgerTypesSliceLast.LedgerType
	|FROM
	|	InformationRegister.CompanyLedgerTypes.SliceLast(&Period, Company = &Company) AS CompanyLedgerTypesSliceLast
	|WHERE
	|	CompanyLedgerTypesSliceLast.Use";
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period" , Period);
	Query.SetParameter("Company", Company);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfLedgerTypes = QueryTable.UnloadColumn("LedgerType");
	Return ArrayOfLedgerTypes;
EndFunction

Function GetAccountingOperationsByLedgerType(Object, Period, LedgerType, MainTableName)
	MetadataName = Object.Ref.Metadata().Name;
	AccountingOperationGroup = Catalogs.AccountingOperations["Document_" + MetadataName];
	Query = New Query();
	Query.Text =
	"SELECT
	|	LedgerTypeOperationsSliceLast.AccountingOperation AS AccountingOperation
	|FROM
	|	InformationRegister.LedgerTypeOperations.SliceLast(&Period, LedgerType = &LedgerType
	|	AND AccountingOperation.Parent = &AccountingOperationGroup) AS LedgerTypeOperationsSliceLast
	|WHERE
	|	LedgerTypeOperationsSliceLast.Use";
	Query.SetParameter("Period", Period);
	Query.SetParameter("LedgerType", LedgerType);
	Query.SetParameter("AccountingOperationGroup", AccountingOperationGroup);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfAccountingOperations = New Array();
	
	OperationsDefinition = GetOperationsDefinition();
	
	DocTransactionType = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "TransactionType") Then
		DocTransactionType = Object.TransactionType;
	EndIf;
	
	While QuerySelection.Next() Do
		Def = OperationsDefinition.Get(QuerySelection.AccountingOperation);
		ByRow = ?(Def = Undefined, False, Def.ByRow);
		
		RequestTable = False;
		If Def <> Undefined And Def.Property("RequestTable") Then
			RequestTable = Def.RequestTable;
		EndIf;
		
		ReferTableName = Undefined;
		If Def <> Undefined And Def.Property("ReferTableName") Then
			ReferTableName = Def.ReferTableName;
		EndIf;
		
		// Filters
				
		If Def <> Undefined And Def.Property("TransactionType") Then
			If TypeOf(Def.TransactionType) = Type("Array") Then
				If Def.TransactionType.Find(DocTransactionType) = Undefined Then
					Continue;
				EndIf;
			Else 
				If Def.TransactionType <> DocTransactionType Then
					Continue;
				EndIf;
			EndIf;
		EndIf;
		
		If ValueIsFilled(ReferTableName)
			And ValueIsFilled(MainTableName)
			And ReferTableName <> MainTableName Then
			Continue;
		EndIf;
		
		NewAccountingOperation = New Structure();
		NewAccountingOperation.Insert("Operation"    , QuerySelection.AccountingOperation);
		NewAccountingOperation.Insert("ByRow"        , ByRow);
		NewAccountingOperation.Insert("RequestTable" , RequestTable);
		NewAccountingOperation.Insert("MetadataName" , MetadataName);
		NewAccountingOperation.Insert("ReferTableName" , ReferTableName);
		ArrayOfAccountingOperations.Add(NewAccountingOperation);
	EndDo;
	Return ArrayOfAccountingOperations;
EndFunction

Function GetLedgerTypeVariants() Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypeVariants.Ref
	|FROM
	|	Catalog.LedgerTypeVariants AS LedgerTypeVariants
	|WHERE
	|	NOT LedgerTypeVariants.DeletionMark";
	QueryResult = Query.Execute();
	Result = New Array();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		Result.Add(QuerySelection.Ref);
	EndDo;
	Return Result;
EndFunction

Function SplitAccountingOperationsByTransactionTypes(DocumentInfo) Export
	Result = New Structure();
	Result.Insert("With_TransactionType", New Map());
	Result.Insert("Without_TransactionType", New Array());
	
	OperationsDefinition = GetOperationsDefinition();
	
	For Each KeyValue In OperationsDefinition Do
		If KeyValue.Key.Parent = DocumentInfo Then
			If KeyValue.Value.Property("TransactionType") And ValueIsFilled(KeyValue.Value.TransactionType) Then
				If Result.With_TransactionType.Get(KeyValue.Value.TransactionType) = Undefined Then
					Result.With_TransactionType.Insert(KeyValue.Value.TransactionType, New Array());
				EndIf;
				
				Result.With_TransactionType[KeyValue.Value.TransactionType].Add(KeyValue.Key);
				
			Else
				
				Result.Without_TransactionType.Add(KeyValue.Key);
				
			EndIf;
		EndIf;
	EndDo;
	
	Return Result;	
EndFunction

#EndRegion

#Region Accounts

Function GetAccountParameters(Parameters) Export
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Parameters.ObjectData.Ref, Parameters.ObjectData.Date);
	AccountParameters = New Structure();
	AccountParameters.Insert("Period", Period);
	AccountParameters.Insert("Company", Parameters.ObjectData.Company);
	AccountParameters.Insert("LedgerTypeVariant", Parameters.LedgerType.LedgerTypeVariant);
	Return AccountParameters;
EndFunction

Function GetT9010S_AccountsItemKey(AccountParameters, ItemKey) Export
	Return AccountingServerReuse.GetT9010S_AccountsItemKey_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		ItemKey);
EndFunction

Function __GetT9010S_AccountsItemKey(Period, Company, LedgerTypeVariant, ItemKey) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ByItemKey.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey = &ItemKey
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL) AS ByItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	ByItem.Account,
	|	2
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item = &Item
	|	AND ItemType.Ref IS NULL) AS ByItem
	|
	|UNION ALL
	|
	|SELECT
	|	ByItemType.Account,
	|	3
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType = &ItemType) AS ByItemType
	|
	|UNION ALL
	|
	|SELECT
	|	ByType.Account,
	|	4
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL
	|	AND TypeOfItemType = &TypeOfItemType) AS ByType
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	5
	|FROM
	|	InformationRegister.T9010S_AccountsItemKey.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL
	|	AND TypeOfItemType.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("LedgerTypeVariant"  , LedgerTypeVariant);
	Query.SetParameter("ItemKey"  , ItemKey);
	Query.SetParameter("Item"     , ItemKey.Item);
	Query.SetParameter("ItemType" , ItemKey.Item.ItemType);
	Query.SetParameter("TypeOfItemType" , ItemKey.Item.ItemType.Type);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetT9011S_AccountsCashAccount(AccountParameters, CashAccount, Currency) Export
	Return AccountingServerReuse.GetT9011S_AccountsCashAccount_Reuse(AccountParameters.Period,
		AccountParameters.Company,
		AccountParameters.LedgerTypeVariant,
		CashAccount, Currency);
EndFunction

Function __GetT9011S_AccountsCashAccount(Period, Company, LedgerTypeVariant, CashAccount, Currency) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByCashAccount.Company,
	|	ByCashAccount.CashAccount,
	|	ByCashAccount.Account,
	|	ByCashAccount.AccountTransit,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9011S_AccountsCashAccount.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND CashAccount = &CashAccount AND Currency = &Currency) AS ByCashAccount
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.CashAccount,
	|	ByCompany.Account,
	|	ByCompany.AccountTransit,
	|	2
	|FROM
	|	InformationRegister.T9011S_AccountsCashAccount.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND CashAccount.Ref IS NULL AND Currency.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.CashAccount,
	|	Accounts.Account,
	|	Accounts.AccountTransit,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"      , Period);
	Query.SetParameter("Company"     , Company);
	Query.SetParameter("LedgerTypeVariant"     , LedgerTypeVariant);
	Query.SetParameter("CashAccount" , CashAccount);
	Query.SetParameter("Currency"    , Currency);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account, AccountTransit");
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
		Result.AccountTransit = QuerySelection.AccountTransit;
	EndIf;
	Return Result;
EndFunction

Function GetT9012S_AccountsPartner(AccountParameters, Partner, Agreement, Currency) Export
	Return AccountingServerReuse.GetT9012S_AccountsPartner_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant,
		Partner, Agreement, Currency);
EndFunction

Function __GetT9012S_AccountsPartner(Period, Company, LedgerTypeVariant, Partner, Agreement, Currency) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByAgreement.AccountAdvancesVendor,
	|	ByAgreement.AccountTransactionsVendor,
	|	1 AS Priority
	|INTO Accounts_Vendor
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountAdvancesVendor,
	|	ByPartner.AccountTransactionsVendor,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCurrency.AccountAdvancesVendor,
	|	ByCurrency.AccountTransactionsVendor,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Currency = &Currency
	|	AND Agreement.Ref IS NULL
	|	AND Partner.Ref IS NULL) AS ByCurrency
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountAdvancesVendor,
	|	ByCompany.AccountTransactionsVendor,
	|	4
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Vendor
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByCompany
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ByAgreement.AccountAdvancesCustomer,
	|	ByAgreement.AccountTransactionsCustomer,
	|	1 AS Priority
	|INTO Accounts_Customer
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountAdvancesCustomer,
	|	ByPartner.AccountTransactionsCustomer,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCurrency.AccountAdvancesCustomer,
	|	ByCurrency.AccountTransactionsCustomer,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Currency = &Currency
	|	AND Agreement.Ref IS NULL
	|	AND Partner.Ref IS NULL) AS ByCurrency
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountAdvancesCustomer,
	|	ByCompany.AccountTransactionsCustomer,
	|	4
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Customer
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByCompany
	|;
	|
	|/////////////////////////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ByAgreement.AccountTransactionsOther,
	|	1 AS Priority
	|INTO Accounts_Other
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.AccountTransactionsOther,
	|	2
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL
	|	AND Currency.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCurrency.AccountTransactionsOther,
	|	3
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Currency = &Currency
	|	AND Agreement.Ref IS NULL
	|	AND Partner.Ref IS NULL) AS ByCurrency
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.AccountTransactionsOther,
	|	4
	|FROM
	|	InformationRegister.T9012S_AccountsPartner.SliceLast(&Period, Other
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.AccountAdvancesVendor,
	|	Accounts.AccountTransactionsVendor,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts_Vendor AS Accounts
	|
	|ORDER BY
	|	Priority
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.AccountAdvancesCustomer,
	|	Accounts.AccountTransactionsCustomer,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts_Customer AS Accounts
	|
	|ORDER BY
	|	Priority
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.AccountTransactionsOther,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts_Other AS Accounts
	|
	|ORDER BY
	|	Priority";

	Query.SetParameter("Period"    , Period);
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("LedgerTypeVariant"   , LedgerTypeVariant);
	Query.SetParameter("Partner"   , Partner);
	Query.SetParameter("Agreement" , Agreement);
	Query.SetParameter("Currency"  , Currency);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = New Structure();
	Result.Insert("AccountAdvancesVendor"        , Undefined);
	Result.Insert("AccountTransactionsVendor"    , Undefined);
	Result.Insert("AccountAdvancesCustomer"      , Undefined);
	Result.Insert("AccountTransactionsCustomer"  , Undefined);
	Result.Insert("AccountTransactionsOther"     , Undefined);

	QuerySelection_Vendor = QueryResults[3].Select();
	If QuerySelection_Vendor.Next() Then
		Result.AccountAdvancesVendor = QuerySelection_Vendor.AccountAdvancesVendor;
		Result.AccountTransactionsVendor = QuerySelection_Vendor.AccountTransactionsVendor;
	EndIf;
	
	QuerySelection_Customer = QueryResults[4].Select();
	If QuerySelection_Customer.Next() Then
		Result.AccountAdvancesCustomer = QuerySelection_Customer.AccountAdvancesCustomer;
		Result.AccountTransactionsCustomer = QuerySelection_Customer.AccountTransactionsCustomer;
	EndIf;
	
	QuerySelection_Other = QueryResults[5].Select();
	If QuerySelection_Other.Next() Then
		Result.AccountTransactionsOther = QuerySelection_Other.AccountTransactionsOther;
	EndIf;
	
	Return Result;
EndFunction

Function GetT9013S_AccountsTax(AccountParameters, TaxInfo) Export
	Return AccountingServerReuse.GetT9013S_AccountsTax_Reuse(AccountParameters.Period,
		AccountParameters.Company,
		AccountParameters.LedgerTypeVariant,
		TaxInfo.Tax, TaxInfo.VatRate);	
EndFunction

Function __GetT9013S_AccountsTax(Period, Company, LedgerTypeVariant, Tax, VatRate) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByVatRate.Company,
	|	ByVatRate.Tax,
	|	ByVatRate.VatRate,
	|	ByVatRate.IncomingAccount,
	|	ByVatRate.OutgoingAccount,
	|	0 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Tax = &Tax
	|	AND VatRate = &VatRate) AS ByVatRate
	|
	|UNION ALL
	|
	|SELECT
	|	ByTax.Company,
	|	ByTax.Tax,
	|	ByTax.VatRate,
	|	ByTax.IncomingAccount,
	|	ByTax.OutgoingAccount,
	|	1
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Tax = &Tax
	|	AND VatRate.Ref IS NULL) AS ByTax
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.Tax,
	|	ByCompany.VatRate,
	|	ByCompany.IncomingAccount,
	|	ByCompany.OutgoingAccount,
	|	2
	|FROM
	|	InformationRegister.T9013S_AccountsTax.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Tax.Ref IS NULL
	|	AND VatRate.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Accounts.Company,
	|	Accounts.Tax,
	|	Accounts.VatRate,
	|	Accounts.IncomingAccount,
	|	Accounts.OutgoingAccount,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"  , Period);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("Tax"     , Tax);
	Query.SetParameter("VatRate" , VatRate);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("IncomingAccount, OutgoingAccount", Undefined, Undefined);
	If QuerySelection.Next() Then
		Result.IncomingAccount = QuerySelection.IncomingAccount;
		Result.OutgoingAccount = QuerySelection.OutgoingAccount;
	EndIf;
	Return Result;
EndFunction

Function GetT9014S_AccountsExpenseRevenue(AccountParameters, ExpenseRevenue, ProfitLossCenter) Export
	Return AccountingServerReuse.GetT9014S_AccountsExpenseRevenue_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		ExpenseRevenue,
		ProfitLossCenter);
EndFunction

Function __GetT9014S_AccountsExpenseRevenue(Period, Company, LedgerTypeVariant, ExpenseRevenue, ProfitLossCenter) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Table.AccountExpense,
	|	1 AS Priority
	|INTO AccountsExpense
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Expense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountExpense,
	|	2
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Expense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountExpense,
	|	3
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Expense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountExpense,
	|	4
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Expense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|;
	|
	|//1//////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.AccountOtherPeriodsExpense,
	|	1 AS Priority
	|INTO AccountsOtherPeriodsExpense
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsExpense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountOtherPeriodsExpense,
	|	2
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsExpense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountOtherPeriodsExpense,
	|	3
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsExpense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountOtherPeriodsExpense,
	|	4
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsExpense
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|;
	|
	|//2//////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.AccountRevenue,
	|	1 AS Priority
	|INTO AccountsRevenue
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Revenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountRevenue,
	|	2
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Revenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountRevenue,
	|	3
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Revenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountRevenue,
	|	4
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, Revenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|;
	|
	|//3//////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.AccountOtherPeriodsRevenue,
	|	1 AS Priority
	|INTO AccountsOtherPeriodsRevenue
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsRevenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountOtherPeriodsRevenue,
	|	2
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsRevenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue = &ExpenseRevenue
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountOtherPeriodsRevenue,
	|	3
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsRevenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter = &ProfitLossCenter) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountOtherPeriodsRevenue,
	|	4
	|FROM
	|	InformationRegister.T9014S_AccountsExpenseRevenue.SliceLast(&Period, OtherPeriodsRevenue
	|	AND Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND ExpenseRevenue.Ref IS NULL
	|	AND ProfitLossCenter.Ref IS NULL) AS Table
	|;
	|
	|//4//////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Table.AccountExpense,
	|	Table.Priority AS Priority
	|FROM
	|	AccountsExpense AS Table
	|
	|ORDER BY
	|	Priority
	|;
	|//5///////////////
	|SELECT TOP 1
	|	Table.AccountOtherPeriodsExpense,
	|	Table.Priority AS Priority
	|FROM
	|	AccountsOtherPeriodsExpense AS Table
	|
	|ORDER BY
	|	Priority
	|;
	|//6///////////////
	|SELECT TOP 1
	|	Table.AccountRevenue,
	|	Table.Priority AS Priority
	|FROM
	|	AccountsRevenue AS Table
	|
	|ORDER BY
	|	Priority
	|;
	|
	|//7//////////////////////////////////////////////////////////////////////////////
	|SELECT TOP 1
	|	Table.AccountOtherPeriodsRevenue,
	|	Table.Priority AS Priority
	|FROM
	|	AccountsOtherPeriodsRevenue AS Table
	|
	|ORDER BY
	|	Priority";
	
	
	Query.SetParameter("Period"  , Period);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("ExpenseRevenue" , ExpenseRevenue);
	Query.SetParameter("ProfitLossCenter" , ProfitLossCenter);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = New Structure();
	Result.Insert("AccountExpense", Undefined);
	Result.Insert("AccountOtherPeriodsExpense", Undefined);
	Result.Insert("AccountRevenue", Undefined);
	Result.Insert("AccountOtherPeriodsRevenue", Undefined);
	
	QuerySelection_Expense = QueryResults[4].Select();
	If QuerySelection_Expense.Next() Then
		Result.AccountExpense = QuerySelection_Expense.AccountExpense;
	EndIf;
	
	QuerySelection_OtherPeriodsExpense = QueryResults[5].Select();
	If QuerySelection_OtherPeriodsExpense.Next() Then
		Result.AccountOtherPeriodsExpense = QuerySelection_OtherPeriodsExpense.AccountOtherPeriodsExpense;
	EndIf;
	
	QuerySelection_Revenue = QueryResults[6].Select();
	If QuerySelection_Revenue.Next() Then
		Result.AccountRevenue = QuerySelection_Revenue.AccountRevenue;
	EndIf;
	
	QuerySelection_OtherPeriodsRevenue = QueryResults[7].Select();
	If QuerySelection_OtherPeriodsRevenue.Next() Then
		Result.AccountOtherPeriodsRevenue = QuerySelection_OtherPeriodsRevenue.AccountOtherPeriodsRevenue;
	EndIf;
	
	Return Result;
EndFunction

Function GetT9015S_AccountsFixedAsset(AccountParameters, FixedAsset) Export
	Return AccountingServerReuse.GetT9015S_AccountsFixedAsset_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		FixedAsset);
EndFunction

Function __GetT9015S_AccountsFixedAsset(Period, Company, LedgerTypeVariant, FixedAsset) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ByFixedAsset.Account,
	|	ByFixedAsset.AccountDepreciation,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9015S_AccountsFixedAsset.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND FixedAsset = &FixedAsset
	|	AND Type.Ref IS NULL) AS ByFixedAsset
	|
	|UNION ALL
	|
	|SELECT
	|	ByType.Account,
	|	ByType.AccountDepreciation,
	|	2
	|FROM
	|	InformationRegister.T9015S_AccountsFixedAsset.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND FixedAsset.Ref IS NULL
	|	AND Type = &Type ) AS ByType
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Account,
	|	ByCompany.AccountDepreciation,
	|	3
	|FROM
	|	InformationRegister.T9015S_AccountsFixedAsset.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND FixedAsset.Ref IS NULL
	|	AND Type.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.AccountDepreciation,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("FixedAsset" , FixedAsset);
	Query.SetParameter("Type"       , FixedAsset.Type);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account, AccountDepreciation");
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
		Result.AccountDepreciation = QuerySelection.AccountDepreciation;
	EndIf;
	Return Result;
EndFunction

Function GetT9016S_AccountsEmployee(AccountParameters, Employee) Export
	Return AccountingServerReuse.GetT9016S_AccountsEmployee_Reuse(
		AccountParameters.Period, 
		AccountParameters.Company, 
		AccountParameters.LedgerTypeVariant, 
		Employee);
EndFunction

Function __GetT9016S_AccountsEmployee(Period, Company, LedgerTypeVariant, Employee) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	Table.AccountSalaryPayment,
	|	Table.AccountCashAdvance,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.T9016S_AccountsEmployee.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Employee = &Employee) AS Table
	|
	|UNION ALL
	|
	|SELECT
	|	Table.AccountSalaryPayment,
	|	Table.AccountCashAdvance,
	|	2
	|FROM
	|	InformationRegister.T9016S_AccountsEmployee.SliceLast(&Period, Company = &Company
	|	AND LedgerTypeVariant = &LedgerTypeVariant
	|	AND Employee.Ref IS NULL) AS Table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.AccountSalaryPayment,
	|	Accounts.AccountCashAdvance,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("LedgerTypeVariant" , LedgerTypeVariant);
	Query.SetParameter("Employee" , Employee);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("AccountSalaryPayment, AccountCashAdvance");
	If QuerySelection.Next() Then
		Result.AccountSalaryPayment = QuerySelection.AccountSalaryPayment;
		Result.AccountCashAdvance = QuerySelection.AccountCashAdvance;
	EndIf;
	Return Result;
EndFunction

#EndRegion

Procedure UpdateAccountingTables(Object, 
							     AccountingRowAnalytics,
							     AccountingExtDimensions,
							     MainTableName, 
							     Filter_LedgerType = Undefined, 
							     IgnoreFixed = False,
							     AddInfo = Undefined) Export
	
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date);
	LedgerTypes = GetLedgerTypesByCompany(Object.Ref, Period, Object.Company);
	
	OperationsByLedgerType = New Array();
	For Each LedgerType In LedgerTypes Do
		// filter by ledger type
		If Filter_LedgerType <> Undefined And Filter_LedgerType <> LedgerType Then
			Continue;
		EndIf;
		OperationsInfo = GetAccountingOperationsByLedgerType(Object, Period, LedgerType, MainTableName);
		For Each OperationInfo In OperationsInfo Do
			OperationsByLedgerType.Add(New Structure("LedgerType, OperationInfo", LedgerType, OperationInfo));
		EndDo;
	EndDo;
			
	ClearAccountingTables(Object, AccountingRowAnalytics, AccountingExtDimensions, Period, LedgerTypes, MainTableName);
	
	ObjectData = GetDocumentData(Object, Undefined, Undefined).ObjectData;
	
	For Each Operation In OperationsByLedgerType Do
		If Operation.OperationInfo.ByRow Then
			Continue;
		EndIf;
		Parameters = New Structure();
		Parameters.Insert("Object"        , Object);
		Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
		Parameters.Insert("LedgerType"    , Operation.LedgerType);
		Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
		Parameters.Insert("MainTableName" , MainTableName);
		Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
		Parameters.Insert("ObjectData"    , ObjectData);
		Parameters.Insert("RowData"       , Undefined);
		Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
		Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
		
		FillAccountingRowAnalytics(Parameters);
	EndDo;
	
	If MainTableName = Undefined Then
		For Each Operation In OperationsByLedgerType Do
			If Not Operation.OperationInfo.RequestTable Then
				Continue;
			EndIf;
			
			DataTable = Documents[Operation.OperationInfo.MetadataName].GetAccountingDataTable(Operation.OperationInfo.Operation, AddInfo);
			
			For Each Row In DataTable Do
				Parameters = New Structure();
				Parameters.Insert("Object"        , Object);
				Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
				Parameters.Insert("LedgerType"    , Operation.LedgerType);
				Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
				Parameters.Insert("MainTableName" , MainTableName);
				Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
				Parameters.Insert("ObjectData"    , ObjectData);
				Parameters.Insert("RowData"       , Row);
				Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
				Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
			
				FillAccountingRowAnalytics(Parameters, Row);
			EndDo;
			
		EndDo;
	Else
		For Each Row In Object[MainTableName] Do
			RowData = GetDocumentData(Object, Row, MainTableName).RowData;
			For Each Operation In OperationsByLedgerType Do
				If Not Operation.OperationInfo.ByRow Then
					Continue;
				EndIf;
				Parameters = New Structure();
				Parameters.Insert("Object"        , Object);
				Parameters.Insert("Operation"     , Operation.OperationInfo.Operation);
				Parameters.Insert("LedgerType"    , Operation.LedgerType);
				Parameters.Insert("MetadataName"  , Operation.OperationInfo.MetadataName);
				Parameters.Insert("MainTableName" , MainTableName);
				Parameters.Insert("IgnoreFixed"   , IgnoreFixed);
				Parameters.Insert("ObjectData"    , ObjectData);
				Parameters.Insert("RowData"       , RowData);
				Parameters.Insert("AccountingRowAnalytics"  , AccountingRowAnalytics);
				Parameters.Insert("AccountingExtDimensions" , AccountingExtDimensions);
			
				FillAccountingRowAnalytics(Parameters, Row);
			EndDo;
		EndDo;
	EndIf;
	
	AccountingRowAnalytics.FillValues(Object.Ref, "Document");
	AccountingExtDimensions.FillValues(Object.Ref, "Document");
EndProcedure

Function GetDocumentData(Object, TableRow, MainTableName)
	Result = New Structure("ObjectData, RowData", New Structure(), New Structure());
	// data from row
	If TableRow <> Undefined Then
		TabularSections =  Object.Ref.Metadata().TabularSections;
		For Each Column In TabularSections[MainTableName].Attributes Do
			Result.RowData.Insert(Column.Name, TableRow[Column.Name]);	
		EndDo;
				
		If CommonFunctionsClientServer.ObjectHasProperty(TableRow, "VatRate") Then
			TaxInfo = New Structure();
			TaxInfo.Insert("Key", TableRow.Key);
			TaxInfo.Insert("Tax", TaxesServer.GetVatRef());
			TaxInfo.Insert("VatRate", TableRow.VatRate);
			Result.RowData.Insert("TaxInfo", TaxInfo);
		EndIf;
		
	Else
		Result.RowData.Insert("Key", "");
	EndIf;
	
	// data from object
	If Object <> Undefined Then
		For Each Attr In Object.Ref.Metadata().Attributes Do
			Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
		EndDo;
		For Each Attr In Object.Ref.Metadata().StandardAttributes Do
			Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
		EndDo;
	EndIf;
	
	Return Result;
EndFunction

Procedure FillAccountingRowAnalytics(Parameters, Row = Undefined)
	AnalyticRow = Undefined;
	RowKey = "";
	Filter = New Structure();
	If Row <> Undefined Then
		RowKey = Row.Key;
		Filter.Insert("Key" , RowKey);
	EndIf;
	Filter.Insert("Operation"  , Parameters.Operation);
	Filter.Insert("LedgerType" , Parameters.LedgerType);
	
	AnalyticRows = Parameters.AccountingRowAnalytics.FindRows(Filter);
	
	If AnalyticRows.Count() > 1 Then
		Raise StrTemplate("More than 1 analytic rows by filter: Key[%1] Operation[%2] LedgerType[%3]", Filter.Key, Filter.Operation, Filter.LedgerType);
	ElsIf AnalyticRows.Count() = 1 Then
		AnalyticRow = AnalyticRows[0];
		If AnalyticRow.IsFixed And Not Parameters.IgnoreFixed Then
			Return;
		EndIf;
	Else
		AnalyticRow = Parameters.AccountingRowAnalytics.Add();
		AnalyticRow.Key = RowKey;		
	EndIf;
	AnalyticRow.IsFixed = False;
	
	AnalyticParameters = New Structure();
	AnalyticParameters.Insert("ObjectData"   , Parameters.ObjectData);
	AnalyticParameters.Insert("RowData"      , Parameters.RowData);
	AnalyticParameters.Insert("Operation"    , Parameters.Operation);
	AnalyticParameters.Insert("LedgerType"   , Parameters.LedgerType);
	AnalyticParameters.Insert("MetadataName" , Parameters.MetadataName);
	
	AnalyticData = Documents[Parameters.MetadataName].GetAccountingAnalytics(AnalyticParameters);
	If AnalyticData = Undefined Then
		Raise StrTemplate("Document [%1] not supported accounting operation [%2]", 
			Parameters.MetadataName, Parameters.Operation);
	EndIf;
		
	AnalyticRow.Operation = AnalyticData.Operation;
	AnalyticRow.LedgerType = AnalyticData.LedgerType;
	
	AnalyticRow.AccountDebit = AnalyticData.Debit;
	FillAccountingExtDimensions(AnalyticData.DebitExtDimensions, Parameters.AccountingExtDimensions);
	
	AnalyticRow.AccountCredit = AnalyticData.Credit;
	FillAccountingExtDimensions(AnalyticData.CreditExtDimensions, Parameters.AccountingExtDimensions);
EndProcedure

Procedure FillAccountingExtDimensions(ArrayOfData, AccountingExtDimensions)
	For Each ExtDim In ArrayOfData Do
		Filter = New Structure();
		If ValueIsFilled(ExtDim.Key) Then
			Filter.Insert("Key" , ExtDim.Key);
		EndIf;
		Filter.Insert("AnalyticType" , ExtDim.AnalyticType);
		Filter.Insert("Operation"    , ExtDim.Operation);
		Filter.Insert("LedgerType"   , ExtDim.LedgerType);
		AccountingExtDimensionRows = AccountingExtDimensions.FindRows(Filter);
		For Each RowForDelete In AccountingExtDimensionRows Do
			AccountingExtDimensions.Delete(RowForDelete);
		EndDo;
	EndDo;
	
	For Each ExtDim In ArrayOfData Do
		NewRow = AccountingExtDimensions.Add();
		NewRow.Key              = ExtDim.Key;
		NewRow.AnalyticType     = ExtDim.AnalyticType;
		NewRow.Operation        = ExtDim.Operation;
		NewRow.LedgerType       = ExtDim.LedgerType;
		NewRow.ExtDimensionType = ExtDim.ExtDimensionType;
		NewRow.ExtDimension     = ExtDim.ExtDimension;
	EndDo;
EndProcedure

Procedure ClearAccountingTables(Object, AccountingRowAnalytics, AccountingExtDimensions, Period, LedgerTypes, MainTableName)
	// AccountingRowAnalytics
	
	Def = GetOperationsDefinition();
	
	ArrayForDelete = New Array();
	For Each Row In AccountingRowAnalytics Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
	
		OpDef = Def.Get(Row.Operation);
		If OpDef.Property("ReferTableName") And OpDef.ReferTableName <> MainTableName Then
			Continue;
		EndIf;
	
		Operations = New Array();	
		OperationsInfo = GetAccountingOperationsByLedgerType(Object, Period, Row.LedgerType, MainTableName);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Not ValueIsFilled(MainTableName) Then
			ArrayForDelete.Add(Row);
		Else		
			If Not ValueIsFilled(Row.Key) Then
				Continue;
			EndIf;
			If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		AccountingRowAnalytics.Delete(ItemForDelete);
	EndDo;
	
	// AccountingExtDimensions
	ArrayForDelete.Clear();
	For Each Row In AccountingExtDimensions Do
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		OpDef = Def.Get(Row.Operation);
		If OpDef.Property("ReferTableName") And OpDef.ReferTableName <> MainTableName Then
			Continue;
		EndIf;
	
		Operations = New Array();	
		OperationsInfo = GetAccountingOperationsByLedgerType(Object, Period, Row.LedgerType, MainTableName);
		For Each OperationInfo In OperationsInfo Do
			Operations.Add(OperationInfo.Operation);
		EndDo;
		
		If Operations.Find(Row.Operation) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Not ValueIsFilled(MainTableName) Then
			ArrayForDelete.Add(Row);
		Else	
			If Not ValueIsFilled(Row.Key) Then
				Continue;
			EndIf;
			If Not Object[MainTableName].FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		AccountingExtDimensions.Delete(ItemForDelete);
	EndDo;
EndProcedure

Function GetAccountingData_LandedCost(Parameters, IsReverse=False)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Ref,
	|	ItemList.Key,
	|	ItemList.ItemKey,
	|	ItemList.Store,
	|	ItemList.QuantityInBaseUnit
	|INTO ItemList
	|FROM
	|	Document.%1.ItemList AS ItemList
	|WHERE
	|	ItemList.Ref = &Recorder and ItemList.Key = &RowKey
	|	AND %2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	R6020B_BatchBalance.Company.LandedCostCurrencyMovementType.Currency AS Currency,
	|	ItemList.QuantityInBaseUnit AS Quantity,
	|	sum(isnull(R6020B_BatchBalance.Quantity, 0)) AS QuantityBatchBalance,
	|	sum(isnull(R6020B_BatchBalance.TotalNetAmount, 0)) AS AmountBatchBalance,
	|	0 AS Amount
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R6020B_BatchBalance AS R6020B_BatchBalance
	|		ON R6020B_BatchBalance.Store = ItemList.Store
	|		AND R6020B_BatchBalance.ItemKey = ItemList.ItemKey
	|		AND R6020B_BatchBalance.Recorder = ItemList.Ref
	|GROUP BY
	|	ItemList.Key,
	|	R6020B_BatchBalance.Company.LandedCostCurrencyMovementType.Currency,
	|	ItemList.QuantityInBaseUnit";
	
	AdditionalCondition = "TRUE";
	If Parameters.Recorder.MeTadata() = Metadata.Documents.ModernizationOfFixedAsset Then		
		AdditionalCondition = "ItemList.ModernizationType = VALUE(Enum.ModernizationTypes.Mount)";
	EndIf;
	
	Query.Text = StrTemplate(Query.Text, Parameters.Recorder.MeTadata().Name, AdditionalCondition);
	
	OperationsDefinition = GetOperationsDefinition();
	Property = OperationsDefinition.Get(Parameters.Operation);
	ByRow = ?(Property = Undefined, False, Property.ByRow);
	
	RowKey = "";
	If ByRow Then
		RowKey = Parameters.RowKey;
	EndIf;
	
	Query.SetParameter("Recorder" , Parameters.Recorder);
	Query.SetParameter("RowKey"   , RowKey);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	TotalAmount   = 0;
	TotalQuantity = 0;
	If QueryTable.Count() Then
		TotalAmount   = QueryTable[0].AmountBatchBalance;
		TotalQuantity = QueryTable[0].QuantityBatchBalance;
	EndIf;
	
	For Each Row In QueryTable Do
		If Row.Quantity = TotalQuantity Then
			Row.Amount = TotalAmount;
		Else
			Row.Amount = ?(Row.QuantityBatchBalance = 0, 0, (TotalAmount / TotalQuantity) * Row.Quantity);
			TotalQuantity = TotalQuantity - Row.Quantity;
			TotalAmount   = TotalAmount - Row.Amount;
		EndIf;
	EndDo;
	
	RecordSet_AccountingAmounts = AccumulationRegisters.T1040T_AccountingAmounts.CreateRecordSet();
	
	TableAccountingAmounts = RecordSet_AccountingAmounts.UnloadColumns();
	TableAccountingAmounts.Columns.Delete(TableAccountingAmounts.Columns.PointInTime);
	CalculatedTableAccountingAmounts = TableAccountingAmounts.Copy();
		
	For Each Row In QueryTable Do		
		// Accounting amounts
		NewRow_AccountingAmounts = TableAccountingAmounts.Add();
		FillPropertyValues(NewRow_AccountingAmounts, Row);
		NewRow_AccountingAmounts.Period = Parameters.Recorder.Date;
		NewRow_AccountingAmounts.RowKey = Row.Key;
		NewRow_AccountingAmounts.Operation = Parameters.Operation;
	EndDo;
	
	// Currency calculation
	
	CurrenciesTableParams = New Structure();
	CurrenciesTableParams.Insert("Ref"            , Parameters.Recorder);
	CurrenciesTableParams.Insert("Date"           , Parameters.Recorder.Date);
	CurrenciesTableParams.Insert("Company"        , Parameters.Recorder.Company);
	CurrenciesTableParams.Insert("Currency"       , Parameters.Recorder.Company.LandedCostCurrencyMovementType.Currency);
	CurrenciesTableParams.Insert("Agreement"      , Undefined);
	CurrenciesTableParams.Insert("RowKey"         , "");
	CurrenciesTableParams.Insert("DocumentAmount" , 0);
	CurrenciesTableParams.Insert("Currencies"     , New Array());
	
	CurrenciesTable = Parameters.Recorder.Currencies.UnloadColumns();
	CurrenciesServer.UpdateCurrencyTable(CurrenciesTableParams, CurrenciesTable);
	
	CurrenciesParameters = New Structure();
	PostingDataTables = New Map();
	
	TableAccountingAmountsSettings = PostingServer.PostingTableSettings(TableAccountingAmounts, RecordSet_AccountingAmounts);
	PostingDataTables.Insert(RecordSet_AccountingAmounts.Metadata(), TableAccountingAmountsSettings);
		
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	CurrenciesParameters.Insert("Object", Parameters.Recorder);
	CurrenciesParameters.Insert("Metadata", Parameters.Recorder.Metadata());
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	CurrenciesParameters.Insert("IsLandedCost", True);
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, CurrenciesTable);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.T1040T_AccountingAmounts Then
			For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
				FillPropertyValues(CalculatedTableAccountingAmounts.Add(), RowPostingInfo);
			EndDo;
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"select
	|	table.Currency,
	|	table.Amount,
	|	table.Operation,
	|	table.CurrencyMovementType,
	|	table.RowKey
	|into table
	|from
	|	&table as table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Amounts.Currency,
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	table AS Amounts
	|WHERE
	|	Amounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Amounts.RowKey = &RowKey
	|GROUP BY
	|	Amounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	table AS Amounts
	|WHERE
	|	Amounts.CurrencyMovementType = &CurrencyMovementType
	|	AND Amounts.RowKey = &RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Quantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS Quantities
	|WHERE
	|	Quantities.Recorder = &Recorder
	|	AND Quantities.RowKey = &RowKey";
	
	Query.SetParameter("table"                , CalculatedTableAccountingAmounts);
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	Query.SetParameter("Operation"            , Parameters.Operation);
	Query.SetParameter("RowKey"           	  , RowKey);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		_Amount = 0;
		If ValueIsFilled(QuerySelection.Amount) Then
			_Amount = QuerySelection.Amount;
		EndIf;
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = ?(IsReverse, -_Amount, _Amount);
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = ?(IsReverse, -_Amount, _Amount);
	EndIf;
	
	// Amount
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		_Amount = 0;
		If ValueIsFilled(QuerySelection.Amount) Then
			_Amount = QuerySelection.Amount;
		EndIf;
		Result.Amount = ?(IsReverse, -_Amount, _Amount);
	EndIf;
	
	// Quantity
	QuerySelection = QueryResults[3].Select();
	If QuerySelection.Next() Then
		_Quantity = 0;
		If ValueIsFilled(QuerySelection.Quantity) Then
			_Quantity = QuerySelection.Quantity;
		EndIf;
		Result.QuantityCr = ?(IsReverse, -_Quantity, _Quantity);
		Result.QuantityDr = ?(IsReverse, -_Quantity, _Quantity);
	EndIf;
	
	Return Result;	
EndFunction

Function GetAccountingData(Parameters)

	If Parameters.Operation = Catalogs.AccountingOperations.RetailSalesReceipt_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.DecommissioningOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset Then
		Return GetAccountingData_LandedCost(Parameters);
	EndIf;
	
	If Parameters.Operation = Catalogs.AccountingOperations.SalesReturn_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		Return GetAccountingData_LandedCost(Parameters, True);
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Amounts.Currency,
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS Amounts
	|WHERE
	|	Amounts.Recorder = &Recorder
	|	AND Amounts.Operation = &Operation
	|	AND Amounts.CurrencyMovementType = &RevaluationCurrency
	|	AND case
	|		when &FilterByRowKey
	|			then Amounts.RowKey = &RowKey
	|		else True
	|	end
	|GROUP BY
	|	Amounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Amounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS Amounts
	|WHERE
	|	Amounts.Recorder = &Recorder
	|	AND Amounts.Operation = &Operation
	|	AND Amounts.CurrencyMovementType = &CurrencyMovementType
	|	AND case
	|		when &FilterByRowKey
	|			then Amounts.RowKey = &RowKey
	|		else True
	|	end
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(Quantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS Quantities
	|WHERE
	|	Quantities.Recorder = &Recorder
	|	AND case
	|		when &FilterByRowKey
	|			then Quantities.RowKey = &RowKey
	|		else True
	|	end";
	
	OperationsDefinition = GetOperationsDefinition();
	Property = OperationsDefinition.Get(Parameters.Operation);
	ByRow = ?(Property = Undefined, False, Property.ByRow);
	
	RowKey = "";
	If ByRow Then
		RowKey = Parameters.RowKey;
	EndIf;
	
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	Query.SetParameter("Operation"            , Parameters.Operation);
	Query.SetParameter("FilterByRowKey"       , ValueIsFilled(RowKey));
	Query.SetParameter("RowKey"           	  , RowKey);
	
	If Parameters.IsCurrencyRevaluation Then
		Query.SetParameter("RevaluationCurrency", Parameters.CurrencyMovementType);
	Else
		Query.SetParameter("RevaluationCurrency", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	EndIf;
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	EndIf;
	
	// Amount
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	EndIf;
	
	// Quantity
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		Result.QuantityCr = QuerySelection.Quantity;
		Result.QuantityDr = QuerySelection.Quantity;
	EndIf;
	
	Return Result;	
EndFunction

#Region Event_Handlers

// Form

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	UpdateFormTables(Object, Form);
EndProcedure

Procedure BeforeWriteAtServer(Object, Form, Cancel, CurrentObject, WriteParameters) Export
	CurrentObject.AdditionalProperties.Insert("AccountingRowAnalytics"  , Form.AccountingRowAnalytics.Unload());
	CurrentObject.AdditionalProperties.Insert("AccountingExtDimensions" , Form.AccountingExtDimensions.Unload());
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	UpdateFormTables(Object, Form);
EndProcedure

Procedure UpdateFormTables(Object, Form)
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	RecordSet.Read();
	Form.AccountingRowAnalytics.Load(RecordSet.Unload());
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	RecordSet.Read();
	Form.AccountingExtDimensions.Load(RecordSet.Unload());
EndProcedure	

// Object

Procedure OnWrite(Object, Cancel, MainTableName = Undefined) Export
	
	If ValueIsFilled(MainTableName) Then
		_MainTableName = MainTableName;
	Else
		_MainTableName = AccountingClientServer.GetDocumentMainTable(Object);
	EndIf;
	
	_AccountingRowAnalytics = CommonFunctionsClientServer.GetFromAddInfo(Object.AdditionalProperties, "AccountingRowAnalytics", Undefined);
	If _AccountingRowAnalytics = Undefined Then
		RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
		RecordSet.Filter.Document.Set(Object.Ref);
		RecordSet.Read();
		_AccountingRowAnalytics = RecordSet.Unload();
	EndIf;
			
	_AccountingExtDimensions = CommonFunctionsClientServer.GetFromAddInfo(Object.AdditionalProperties, "AccountingExtDimensions", Undefined);
	If _AccountingExtDimensions = Undefined Then
		RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
		RecordSet.Filter.Document.Set(Object.Ref);
		RecordSet.Read();
		_AccountingExtDimensions = RecordSet.Unload();
	EndIf;
		
	AccountingClientServer.UpdateAccountingTables(Object, 
		                                         _AccountingRowAnalytics, 
		                                         _AccountingExtDimensions,
		                                         _MainTableName);
		
	Object.AdditionalProperties.Insert("AccountingRowAnalytics"  , _AccountingRowAnalytics);
	Object.AdditionalProperties.Insert("AccountingExtDimensions" , _AccountingExtDimensions);
EndProcedure

// Manager

Procedure CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo) Export
	_AccountingRowAnalytics  = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "AccountingRowAnalytics", Undefined);
	_AccountingExtDimensions = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "AccountingExtDimensions", Undefined);
	
	If _AccountingRowAnalytics = Undefined Or _AccountingExtDimensions = Undefined Then
		Return;
	EndIf;
	
	_AccountingRowAnalytics.FillValues(Ref, "Document");
	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Load(_AccountingRowAnalytics);
	RecordSet.Write();
		
	_AccountingExtDimensions.FillValues(Ref, "Document");
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Load(_AccountingExtDimensions);
	RecordSet.Write();	
EndProcedure

#EndRegion

#Region JournalEntry

Function GetTableOfJEDocuments(ArrayOfBasisDocuments, ArrayOfLedgerTypes) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Doc.Document,
	|	Doc.LedgerType
	|INTO Documents
	|FROM
	|	&Documents AS Doc
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Documents.Document AS Basis,
	|	JournalEntry.Ref AS JournalEntry,
	|	Documents.LedgerType
	|FROM
	|	Documents AS Documents
	|		LEFT JOIN Document.JournalEntry AS JournalEntry
	|		ON Documents.Document = JournalEntry.Basis
	|		AND NOT JournalEntry.DeletionMark
	|		AND JournalEntry.LedgerType = Documents.LedgerType";

	DocumentTable = New ValueTable();
	DocumentTable.Columns.Add("Document", Metadata.Documents.JournalEntry.Attributes.Basis.Type);
	DocumentTable.Columns.Add("LedgerType", New TypeDescription("CatalogRef.LedgerTypes"));
	
	For Each Ref In ArrayOfBasisDocuments Do
		AvailableLedgerTypes = GetLedgerTypesByCompany(Ref, Ref.Date, Ref.Company);
		For Each LedgerTpe In ArrayOfLedgerTypes Do
			If AvailableLedgerTypes.Find(LedgerTpe) = Undefined Then
				Continue;
			EndIf;		
			NewRow = DocumentTable.Add();
			NewRow.Document = Ref;
			NewRow.LedgerType = LedgerTpe;
		EndDo;
	EndDo;
	
	Query.SetParameter("Documents"  , DocumentTable);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	TableOfJEDocuments = New ValueTable();
	TableOfJEDocuments.Columns.Add("BasisDocument");
	TableOfJEDocuments.Columns.Add("JEDocument");
	
	For Each Row In QueryTable Do
		If ValueIsFilled(Row.JournalEntry) Then
			JEDocObject = Row.JournalEntry.GetObject();
		Else
			JEDocObject = Documents.JournalEntry.CreateDocument();
		EndIf;
		JEDocObject.Fill(New Structure("Basis, LedgerType", Row.Basis, Row.LedgerType));
		JEDocObject.Date = Row.Basis.Date;
		NewRow = TableOfJEDocuments.Add();
		NewRow.BasisDocument = Row.Basis;
		NewRow.JEDocument = JEDocObject;
	EndDo;
	Return TableOfJEDocuments;
EndFunction

Procedure CreateJE_ByArrayRefs(ArrayOfBasisDocuments, ArrayOfLedgerTypes) Export	
	TableOfJEDocuments = GetTableOfJEDocuments(ArrayOfBasisDocuments, ArrayOfLedgerTypes);
	For Each Row In TableOfJEDocuments Do
		CommonFunctionsClientServer.PutToAddInfo(Row.JEDocument.AdditionalProperties, "WriteOnForm", True);
		Row.JEDocument.Write(DocumentWriteMode.Write);
	EndDo;	
EndProcedure

#EndRegion

#Region FixDocumentProblems

Function IsAccountingAnalyticsRegister(RegisterName) Export
	Return Upper(RegisterName) = Upper(Metadata.InformationRegisters.T9050S_AccountingRowAnalytics.FullName())
		Or Upper(RegisterName) = Upper(Metadata.InformationRegisters.T9051S_AccountingExtDimensions.FullName());
EndFunction

Function IsAccountingDataRegister(RegisterName) Export
	Return Upper(RegisterName) = Upper(Metadata.AccountingRegisters.Basic.FullName());
EndFunction

Function GetExtDimType_ByNumber(ExtDimNumber, Account) Export
	If Account.ExtDimensionTypes.Count() < ExtDimNumber Then
		Return Undefined;
	EndIf;
	
	Return Account.ExtDimensionTypes[ExtDimNumber - 1].ExtDimensionType;
EndFunction

Function GetExtDimNumber_ByType(ExtDimType, Account) Export
	Number = 1;
	For Each Row In Account.ExtDimensionTypes Do
		If Row.ExtDimensionType = ExtDimType Then
			Return Number;
		EndIf;
		Number = Number + 1;
	EndDo;
	Return Undefined;
EndFunction

Function GetExtDimValue_ByType(ExtDimType, ExtDimensionRows)
	If Not ValueIsFilled(ExtDimType) Then
		Return Undefined;
	EndIf;
	
	For Each Row In ExtDimensionRows Do
		If TypeOf(ExtDimensionRows) = Type("Array") Then
			If Row.ExtDimensionType = ExtDimType Then
				Return Row.ExtDimension;
			EndIf;
		Else
			If Row.Key = ExtDimType Then
				Return Row.Value;
			EndIf;
		EndIf;
	EndDo;
	
	Return Undefined;
EndFunction

Procedure SetExtDimValue_ByNumberCr(ExtDimNumber, Record, Value)
	If Not ValueIsFilled(Value) Then
		Return;
	EndIf;
	
	If TypeOf(Record) = Type("AccountingRegisterRecord.Basic") Then
		ExtDimType = GetExtDimType_ByNumber(ExtDimNumber, Record.AccountCr);
	
		If Not ValueIsFilled(ExtDimType) Then
			Return;
		EndIf;
	
		Record.ExtDimensionsCr[ExtDimType] = Value;
	Else
		Record["ExtDimensionCr" + String(ExtDimNumber)] = Value;
	EndIf;	
EndProcedure

Procedure SetExtDimValue_ByNumberDr(ExtDimNumber, Record, Value)
	If Not ValueIsFilled(Value) Then
		Return;
	EndIf;
	If TypeOf(Record) = Type("AccountingRegisterRecord.Basic") Then	
		ExtDimType = GetExtDimType_ByNumber(ExtDimNumber, Record.AccountDr);
	
		If Not ValueIsFilled(ExtDimType) Then
			Return;
		EndIf;
	
		Record.ExtDimensionsDr[ExtDimType] = Value;
	Else
		Record["ExtDimensionDr" + String(ExtDimNumber)] = Value;
	EndIf;
EndProcedure

Function CreateAccountingDataTable() Export
	RegMetadata = Metadata.AccountingRegisters.Basic;
	ExtDimMetadata = Metadata.ChartsOfCharacteristicTypes.AccountingExtraDimensionTypes;
	ExtDimType = New TypeDescription("ChartOfCharacteristicTypesRef.AccountingExtraDimensionTypes");
	ChartOfAccountType = New TypeDescription("ChartOfAccountsRef.Basic");
		
	DataTable = New ValueTable();
		
	DataTable.Columns.Add("Period", RegMetadata.StandardAttributes.Period.Type);
		
	DataTable.Columns.Add("Company"  , RegMetadata.Dimensions.Company.Type);
	DataTable.Columns.Add("LedgerType", RegMetadata.Dimensions.LedgerType.Type);
		
	DataTable.Columns.Add("Operation", RegMetadata.Attributes.Operation.Type);
	DataTable.Columns.Add("IsFixed"  , RegMetadata.Attributes.IsFixed.Type);
	DataTable.Columns.Add("IsByRow"  , RegMetadata.Attributes.IsByRow.Type);
	DataTable.Columns.Add("Key"      , RegMetadata.Attributes.Key.Type);
		
	DataTable.Columns.Add("AccountDr", ChartOfAccountType);
		
	DataTable.Columns.Add("ExtDimDrType1", ExtDimType);
	DataTable.Columns.Add("ExtDimDrType2", ExtDimType);
	DataTable.Columns.Add("ExtDimDrType3", ExtDimType);
		
	DataTable.Columns.Add("ExtDimDrValue1", ExtDimMetadata.Type);
	DataTable.Columns.Add("ExtDimDrValue2", ExtDimMetadata.Type);
	DataTable.Columns.Add("ExtDimDrValue3", ExtDimMetadata.Type);
		
	DataTable.Columns.Add("AccountCr", ChartOfAccountType);
		
	DataTable.Columns.Add("ExtDimCrType1", ExtDimType);
	DataTable.Columns.Add("ExtDimCrType2", ExtDimType);
	DataTable.Columns.Add("ExtDimCrType3", ExtDimType);
		
	DataTable.Columns.Add("ExtDimCrValue1", ExtDimMetadata.Type);
	DataTable.Columns.Add("ExtDimCrValue2", ExtDimMetadata.Type);
	DataTable.Columns.Add("ExtDimCrValue3", ExtDimMetadata.Type);
	
	DataTable.Columns.Add("CurrencyDr"      , RegMetadata.Dimensions.Currency.Type);
	DataTable.Columns.Add("CurrencyAmountDr", RegMetadata.Resources.CurrencyAmount.Type);
	DataTable.Columns.Add("QuantityDr"      , RegMetadata.Resources.Quantity.Type);
	
	DataTable.Columns.Add("CurrencyCr"      , RegMetadata.Dimensions.Currency.Type);
	DataTable.Columns.Add("CurrencyAmountCr", RegMetadata.Resources.CurrencyAmount.Type);
	DataTable.Columns.Add("QuantityCr"      , RegMetadata.Resources.Quantity.Type);
	
	DataTable.Columns.Add("Amount" , RegMetadata.Resources.Amount.Type);
			
	Return DataTable;
EndFunction

Procedure SortAccountingDataTable(DataTable)
	ArrayOfColumns = New Array();
	For Each Column In DataTable.Columns Do
		If StrStartsWith(Column.Name, "Ext") Then
			Continue;
		EndIf;
		ArrayOfColumns.Add(TrimAll(Column.Name));
	EndDo;
	
	DataTable.Sort(StrConcat(ArrayOfColumns, ","));
EndProcedure

Function GetCurrentAnalyticsRegisterRecords(Doc, RegisterName) Export
	If Upper(RegisterName) = Upper(Metadata.InformationRegisters.T9050S_AccountingRowAnalytics.FullName()) Then
		RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
		SortColumns = "Document, Key, Operation, LedgerType, AccountDebit, AccountCredit, IsFixed";
	ElsIf Upper(RegisterName) = Upper(Metadata.InformationRegisters.T9051S_AccountingExtDimensions.FullName()) Then
		RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
		SortColumns = "Document, Key, Operation, LedgerType, AnalyticType, ExtDimensionType, ExtDimension";
	Else
		Raise StrTemplate("Unsupported reister name [%1]", RegisterName);
	EndIf;
	
	RecordSet.Filter.Document.Set(Doc);
	RecordSet.Read();
	Records = RecordSet.Unload();
	Records.Sort(SortColumns);
	
	Return Records;
EndFunction

Function RegisterRecords_AccountingAnalytics(Doc)

	// T9050S_AccountingRowAnalytics
	RecordSet_T9050S = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet_T9050S.Filter.Document.Set(Doc);
	RecordSet_T9050S.Read();
	Old_AccountingRowAnalytics = RecordSet_T9050S.Unload();
	New_AccountingRowAnalytics = Old_AccountingRowAnalytics.Copy();
			
	// T9051S_AccountingExtDimensions
	RecordSet_T9051S = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet_T9051S.Filter.Document.Set(Doc);
	RecordSet_T9051S.Read();
	Old_AccountingExtDimensions = RecordSet_T9051S.Unload();
	New_AccountingExtDimensions = Old_AccountingExtDimensions.Copy();
		
	New_AccountingRowAnalytics = Old_AccountingRowAnalytics.Copy();
	New_AccountingExtDimensions = Old_AccountingExtDimensions.Copy();
	
	AccountingClientServer.UpdateAccountingTables(Doc, New_AccountingRowAnalytics, New_AccountingExtDimensions, 
		AccountingClientServer.GetDocumentMainTable(Doc));
		
	IgnoredColumns = "UUID";
	
	SortColumns_AccountingRowAnalytics = "Document, Key, Operation, LedgerType, AccountDebit, AccountCredit, IsFixed";
	SortColumns_AccountingExtDimensions = "Document, Key, Operation, LedgerType, AnalyticType, ExtDimensionType, ExtDimension";
	
	Old_AccountingRowAnalytics.Sort(SortColumns_AccountingRowAnalytics);
	New_AccountingRowAnalytics.Sort(SortColumns_AccountingRowAnalytics);
	
	Old_AccountingExtDimensions.Sort(SortColumns_AccountingExtDimensions);
	New_AccountingExtDimensions.Sort(SortColumns_AccountingExtDimensions);
	
	RegisterRecords = New Map();
	If Not CommonFunctionsServer.TablesIsEqual(Old_AccountingRowAnalytics, New_AccountingRowAnalytics, IgnoredColumns) Then
		RegisterRecords.Insert(RecordSet_T9050S.Metadata(), New_AccountingRowAnalytics);	
	EndIf;
	
	If Not CommonFunctionsServer.TablesIsEqual(Old_AccountingExtDimensions, New_AccountingExtDimensions, IgnoredColumns) Then
		RegisterRecords.Insert(RecordSet_T9051S.Metadata(), New_AccountingExtDimensions);	
	EndIf;
	
	Return RegisterRecords;
EndFunction

Procedure SetDataRegisterRecords(DataTable, LedgerType, RecordSet) Export
	For Each Row In DataTable Do
		If Row.LedgerType <> LedgerType Then
			Continue;
		EndIf;
		
		Record = RecordSet.Add();
		FillPropertyValues(Record, Row);
		
		SetExtDimValue_ByNumberDr(1, Record, Row.ExtDimDrValue1);
		SetExtDimValue_ByNumberDr(2, Record, Row.ExtDimDrValue2);
		SetExtDimValue_ByNumberDr(3, Record, Row.ExtDimDrValue3);
		
		SetExtDimValue_ByNumberCr(1, Record, Row.ExtDimCrValue1);
		SetExtDimValue_ByNumberCr(2, Record, Row.ExtDimCrValue2);
		SetExtDimValue_ByNumberCr(3, Record, Row.ExtDimCrValue3);
	EndDo;
EndProcedure

Function GetCurrentDataRegisterRecords(BasisDoc, RegisterName) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	JournalEntry.Ref AS JERef
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	JournalEntry.Basis = &Basis
	|	AND JournalEntry.LedgerType IN (&LedgerTypes)
	|	AND NOT JournalEntry.DeletionMark";
	Query.SetParameter("Basis", BasisDoc);
	Query.SetParameter("LedgerTypes", GetLedgerTypesByCompany(BasisDoc, BasisDoc.Date, BasisDoc.Company));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	DataTable = CreateAccountingDataTable();
	
	While QuerySelection.Next() Do
		RecordSet = AccountingRegisters.Basic.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.JERef);
		RecordSet.Read();
		For Each Record In RecordSet Do
			NewRow = DataTable.Add();
			
			FillPropertyValues(NewRow, Record);
		
			NewRow.ExtDimDrType1 = GetExtDimType_ByNumber(1, Record.AccountDr);
			NewRow.ExtDimDrType2 = GetExtDimType_ByNumber(2, Record.AccountDr);
			NewRow.ExtDimDrType3 = GetExtDimType_ByNumber(3, Record.AccountDr);
		
			NewRow.ExtDimDrValue1 = GetExtDimValue_ByType(NewRow.ExtDimDrType1, Record.ExtDimensionsDr);
			NewRow.ExtDimDrValue2 = GetExtDimValue_ByType(NewRow.ExtDimDrType2, Record.ExtDimensionsDr);
			NewRow.ExtDimDrValue3 = GetExtDimValue_ByType(NewRow.ExtDimDrType3, Record.ExtDimensionsDr);
				
			NewRow.ExtDimCrType1 = GetExtDimType_ByNumber(1, Record.AccountCr);
			NewRow.ExtDimCrType2 = GetExtDimType_ByNumber(2, Record.AccountCr);
			NewRow.ExtDimCrType3 = GetExtDimType_ByNumber(3, Record.AccountCr);
		
			NewRow.ExtDimCrValue1 = GetExtDimValue_ByType(NewRow.ExtDimCrType1, Record.ExtDimensionsCr);
			NewRow.ExtDimCrValue2 = GetExtDimValue_ByType(NewRow.ExtDimCrType2, Record.ExtDimensionsCr);
			NewRow.ExtDimCrValue3 = GetExtDimValue_ByType(NewRow.ExtDimCrType3, Record.ExtDimensionsCr);
			
		EndDo;
	EndDo;
	SortAccountingDataTable(DataTable);
	Return DataTable;
EndFunction

Function GetNewDataRegisterRecords(BasisDoc, AccountingRowAnalytics, AccountingExtDimensions) Export
	DataTable = CreateAccountingDataTable();
	
	AvailableLedgerTypes = GetLedgerTypesByCompany(BasisDoc, BasisDoc.Date, BasisDoc.Company);
	
	For Each LedgerType In AvailableLedgerTypes Do
	For Each Row In AccountingRowAnalytics Do
		If LedgerType <> Row.LedgerType Then
			Continue;
		EndIf;
		
		DataByAnalytics = GetDataByAccountingAnalytics(BasisDoc, Row);
		
		If Not ValueIsFilled(DataByAnalytics.Amount) Then
			Continue;
		EndIf;
		
		If Not ValueIsFilled(Row.AccountDebit) Then
			Raise StrTemplate("Debit is empty [%1] [%2]", Row.Operation, Row.Key);
		EndIf;
		
		If Not ValueIsFilled(Row.AccountCredit) Then
			Raise StrTemplate("Credit is empty [%1] [%2]", Row.Operation, Row.Key);
		EndIf;
				
		Record = DataTable.Add();
		Record.Period     = BasisDoc.Date;
		Record.Company    = BasisDoc.Company;
		Record.LedgerType = Row.LedgerType;
		Record.Operation  = Row.Operation;
		Record.IsFixed    = Row.IsFixed;
		Record.IsByRow    = ValueIsFilled(Row.Key);
		Record.Key        = Row.Key;
		
		Filter = New Structure();
		Filter.Insert("Key"          , Row.Key);
		Filter.Insert("Operation"    , Row.Operation);
		Filter.Insert("LedgerType"   , Row.LedgerType);
		Filter.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.EmptyRef());
		
		// Debit analytics
		Record.AccountDr = Row.AccountDebit;
		
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Debit;
		AccountingExtDimDr = AccountingExtDimensions.FindRows(Filter);
		
		Record.ExtDimDrType1 = GetExtDimType_ByNumber(1, Record.AccountDr);
		Record.ExtDimDrType2 = GetExtDimType_ByNumber(2, Record.AccountDr);
		Record.ExtDimDrType3 = GetExtDimType_ByNumber(3, Record.AccountDr);
		
		Record.ExtDimDrValue1 = GetExtDimValue_ByType(Record.ExtDimDrType1, AccountingExtDimDr);
		Record.ExtDimDrValue2 = GetExtDimValue_ByType(Record.ExtDimDrType2, AccountingExtDimDr);
		Record.ExtDimDrValue3 = GetExtDimValue_ByType(Record.ExtDimDrType3, AccountingExtDimDr);
		
		// Credit analytics
		Record.AccountCr = Row.AccountCredit;
		
		Filter.AnalyticType = Enums.AccountingAnalyticTypes.Credit;
		AccountingExtDimCr = AccountingExtDimensions.FindRows(Filter);
		
		Record.ExtDimCrType1 = GetExtDimType_ByNumber(1, Record.AccountCr);
		Record.ExtDimCrType2 = GetExtDimType_ByNumber(2, Record.AccountCr);
		Record.ExtDimCrType3 = GetExtDimType_ByNumber(3, Record.AccountCr);
		
		Record.ExtDimCrValue1 = GetExtDimValue_ByType(Record.ExtDimCrType1, AccountingExtDimCr);
		Record.ExtDimCrValue2 = GetExtDimValue_ByType(Record.ExtDimCrType2, AccountingExtDimCr);
		Record.ExtDimCrValue3 = GetExtDimValue_ByType(Record.ExtDimCrType3, AccountingExtDimCr);
				
		// Debit currency
		If Row.AccountDebit.Currency Then
			Record.CurrencyDr       = DataByAnalytics.CurrencyDr;
			Record.CurrencyAmountDr = DataByAnalytics.CurrencyAmountDr;
		EndIf;
		
		// Credit currency
		If Row.AccountCredit.Currency Then
			Record.CurrencyCr       = DataByAnalytics.CurrencyCr;
			Record.CurrencyAmountCr = DataByAnalytics.CurrencyAmountCr;
		EndIf;
		
		// Debit quantity
		If Row.AccountDebit.Quantity Then
			Record.QuantityDr = DataByAnalytics.QuantityDr;
		EndIf;
		
		// Credit quantity
		If Row.AccountCredit.Quantity Then
			Record.QuantityCr = DataByAnalytics.QuantityCr;
		EndIf;
		
		Record.Amount = DataByAnalytics.Amount;
	EndDo;
	EndDo;
	SortAccountingDataTable(DataTable);
	Return DataTable;
EndFunction

Function RegisterRecords_AccountingData(BasisDoc)	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(BasisDoc);
	RecordSet.Read();
	_AccountingRowAnalytics = RecordSet.Unload();
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(BasisDoc);
	RecordSet.Read();
	_AccountingExtDimensions = RecordSet.Unload();
	
	NewRecords_DataTable = GetNewDataRegisterRecords(BasisDoc, _AccountingRowAnalytics, _AccountingExtDimensions);	
	
	OldRecords_DataTable = GetCurrentDataRegisterRecords(BasisDoc, "");
	
	IgnoredColumns = "LineNumber,PointInTime";
	
	RegisterRecords = New Map();
	If Not CommonFunctionsServer.TablesIsEqual(OldRecords_DataTable, NewRecords_DataTable, IgnoredColumns) Then
		RegisterRecords.Insert(AccountingRegisters.Basic.CreateRecordSet().Metadata(), NewRecords_DataTable);	
	EndIf;
	Return RegisterRecords;		
EndFunction

Function CheckDocumentArray(DocumentArray, CheckType, isJob)
	Errors = New Array;
	
	If isJob And DocumentArray.Count() = 0 Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Empty doc list: " + DocumentArray.Count();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
		Return Errors;
	EndIf;

	If Not Metadata.DefinedTypes.typeAccountingDocuments.Type.ContainsType(TypeOf(DocumentArray[0])) Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Document type: " + DocumentArray[0].Metadata().Name + " not supported document type.";
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
		Return Errors;
	EndIf;

	If isJob Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.Log = "Start check: " + DocumentArray.Count();
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
	
	Count = 0; 
	LastPercentLogged = 0;
	StartDate = CurrentUniversalDateInMilliseconds();
	For Each Doc In DocumentArray Do
		BeginTransaction();
		
		DocObject = Doc;
		Try
			If CheckType = "AccountingAnalytics" Then
				RegisteredRecords = RegisterRecords_AccountingAnalytics(Doc);
			ElsIf CheckType = "AccountingData" Then
				RegisteredRecords = RegisterRecords_AccountingData(Doc);
			Else
				Raise StrTemplate("Unsupported check type [%1]", CheckType);
			EndIf;
			
			If RegisteredRecords.Count() > 0 Then
				Result = New Structure;
				Result.Insert("Ref", Doc);
				Result.Insert("RegInfo", New Array);
				Result.Insert("Error", "");
				For Each Reg In RegisteredRecords Do
					RegInfo = New Structure;
					RegInfo.Insert("RegName", Reg.Key.FullName());
					RegInfo.Insert("NewPostingData", Reg.Value);
					Result.RegInfo.Add(RegInfo);
				EndDo;
				
				Errors.Add(Result);
			EndIf;
		Except
			Msg = BackgroundJobAPIServer.NotifySettings();
			Msg.Log = "Error: " + DocObject + ":" + Chars.LF + ErrorProcessing.DetailErrorDescription(ErrorInfo());
			BackgroundJobAPIServer.NotifyStream(Msg);
			
			Result = New Structure;
			Result.Insert("Ref", Doc);
			Result.Insert("RegInfo", New Array);
			Result.Insert("Error", Msg.Log);
			Errors.Add(Result);
		EndTry;
		
		RollbackTransaction();
		
		Count = Count + 1;
		
		Percent = 100 * Count / DocumentArray.Count();
		If isJob And (Percent - LastPercentLogged >= 1) Then  
			LastPercentLogged = Int(Percent);
			Msg = BackgroundJobAPIServer.NotifySettings();
			DateDiff = CurrentUniversalDateInMilliseconds() - StartDate;
			Msg.Speed = Format(1000 * Count / DateDiff, "NFD=2; NG=") + " doc/sec";
			Msg.Percent = Percent;
			BackgroundJobAPIServer.NotifyStream(Msg);
		EndIf;

	EndDo;
	
	If isJob Then
		Msg = BackgroundJobAPIServer.NotifySettings();
		Msg.End = True;
		Msg.DataAddress = CommonFunctionsServer.PutToCache(Errors);
		BackgroundJobAPIServer.NotifyStream(Msg);
	EndIf;
	
	Return Errors;
EndFunction

Function CheckDocumentArray_AccountingAnalytics(DocumentArray, isJob = False) Export
	Return CheckDocumentArray(DocumentArray, "AccountingAnalytics", isJob);
EndFunction

Function CheckDocumentArray_AccountingTranslation(DocumentArray, isJob = False) Export
	Return CheckDocumentArray(DocumentArray, "AccountingData", isJob);
EndFunction

#EndRegion


