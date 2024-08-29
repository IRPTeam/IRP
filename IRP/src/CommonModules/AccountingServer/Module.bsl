
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
	// Transaction type - salary return
	Map.Insert(AO.BankReceipt_DR_R3010B_CashOnHand_CR_R9510B_SalaryPayment,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.SalaryReturn));

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
	//  Transaction type - Salary return
	Map.Insert(AO.CashReceipt_DR_R3010B_CashOnHand_CR_R9510B_SalaryPayment,
		New Structure("ByRow, TransactionType", True, Enums.IncomingPaymentTransactionType.SalaryReturn));
	
	// Cash expense
	Map.Insert(AO.CashExpense_DR_R5022T_Expenses_CR_R3010B_CashOnHand , New Structure("ByRow", True));
	
	// Cash revenue
	Map.Insert(AO.CashRevenue_DR_R3010B_CashOnHand_CR_R5021_Revenues , New Structure("ByRow", True));
		
	// Debit note
	Map.Insert(AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R2040B_TaxesIncoming , New Structure("ByRow", True));
	Map.Insert(AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming , New Structure("ByRow", True));
		
	// Credit note
	Map.Insert(AO.CreditNote_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions , New Structure("ByRow", True));
	Map.Insert(AO.CreditNote_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions , New Structure("ByRow", True));
				
	// Purchase invoice
	// receipt inventory
	Map.Insert(AO.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	// offset of advabces
	Map.Insert(AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors,
		New Structure("ByRow, TransactionType", False, Enums.PurchaseTransactionTypes.Purchase));
	
	Map.Insert(AO.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions,
		New Structure("ByRow, TransactionType", True, Enums.PurchaseTransactionTypes.Purchase));
	
	// Sales invoice
	// sales inventory
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues,
		New Structure("ByRow, TransactionType", True, Enums.SalesTransactionTypes.Sales));
	// offset of advances
	Map.Insert(AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions,
		New Structure("ByRow, TransactionType", False, Enums.SalesTransactionTypes.Sales));
	
	Map.Insert(AO.SalesInvoice_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming,
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
	
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1040B_TaxesOutgoing, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R1040B_TaxesOutgoing_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));
	
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2040B_TaxesIncoming, New Structure("ByRow, RequestTable", True, True));
	Map.Insert(AO.ForeignCurrencyRevaluation_DR_R2040B_TaxesIncoming_CR_R5021T_Revenues, New Structure("ByRow, RequestTable", True, True));
	
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
	Map.Insert(AO.DebitCreditNote_DR_R5020B_PartnersBalance_CR_R5021_Revenues, New Structure("ByRow", False));
	Map.Insert(AO.DebitCreditNote_DR_R5022T_Expenses_CR_R5020B_PartnersBalance, New Structure("ByRow", False));
	
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
	Map.Insert(AO.EmployeeCashAdvance_DR_R1040B_TaxesOutgoing_CR_R3027B_EmployeeCashAdvance, New Structure("ByRow", True));
	
	// Sales return
	Map.Insert(AO.SalesReturn_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers, 
		New Structure("ByRow, TransactionType", False, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	Map.Insert(AO.SalesReturn_DR_R5021T_Revenues_CR_R2021B_CustomersTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	Map.Insert(AO.SalesReturn_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions, 
		New Structure("ByRow, TransactionType", True, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	Map.Insert(AO.SalesReturn_DR_R5022T_Expenses_CR_R4050B_StockInventory, 
		New Structure("ByRow, TransactionType", True, Enums.SalesReturnTransactionTypes.ReturnFromCustomer));
	
	// Purchase return
	Map.Insert(AO.PurchaseReturn_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions, 
		New Structure("ByRow, TransactionType", False, Enums.PurchaseReturnTransactionTypes.ReturnToVendor));
	
	Map.Insert(AO.PurchaseReturn_DR_R1021B_VendorsTransactions_CR_R4050B_StockInventory, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseReturnTransactionTypes.ReturnToVendor));
	
	Map.Insert(AO.PurchaseReturn_DR_R1021B_VendorsTransactions_CR_R2040B_TaxesIncoming, 
		New Structure("ByRow, TransactionType", True, Enums.PurchaseReturnTransactionTypes.ReturnToVendor));
	
	// Taxes operation	
	ArrayOfTaxesOperationTransactionTypes_Offset = New Array();
	ArrayOfTaxesOperationTransactionTypes_Offset.Add(Enums.TaxesOperationTransactionType.TaxOffsetAndPayment);
	ArrayOfTaxesOperationTransactionTypes_Offset.Add(Enums.TaxesOperationTransactionType.TaxOffset);
	
	Map.Insert(AO.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R1040B_TaxesOutgoing, 
		New Structure("ByRow, TransactionType", True, ArrayOfTaxesOperationTransactionTypes_Offset));
		
	ArrayOfTaxesOperationTransactionTypes_Payment = New Array();
	ArrayOfTaxesOperationTransactionTypes_Payment.Add(Enums.TaxesOperationTransactionType.TaxOffsetAndPayment);
	ArrayOfTaxesOperationTransactionTypes_Payment.Add(Enums.TaxesOperationTransactionType.TaxPayment);
	
	Map.Insert(AO.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R5015B_OtherPartnersTransactions, 
		New Structure("ByRow, TransactionType", True, ArrayOfTaxesOperationTransactionTypes_Payment));
		
	Map.Insert(AO.TaxesOperation_DR_R5015B_OtherPartnersTransactions_CR_R1040B_TaxesOutgoing, 
		New Structure("ByRow, TransactionType", True, ArrayOfTaxesOperationTransactionTypes_Payment));
	
	// External accounting operation
	Map.Insert(AO.ExternalAccountingOperation, New Structure("ByRow", True));
	
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
		Number = 1;
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(ExtDim.ExtDimensionType, Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintDebitExtDimension(Parameters, 
																					  ExtDim.ExtDimensionType, 
																					  ExtDimValue,
																					  AdditionalAnalyticsValues,
																					  Number);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
			Number = Number + 1;
		EndDo;
	EndIf;
EndProcedure

Procedure SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsValues = Undefined) Export
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		Number = 1;
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(ExtDim.ExtDimensionType, Parameters.ObjectData, Parameters.RowData, ArrayOfTypes, AdditionalAnalyticsValues);
			ExtDimValue = Documents[Parameters.MetadataName].GetHintCreditExtDimension(Parameters, 
																					   ExtDim.ExtDimensionType, 
																					   ExtDimValue,
																					   AdditionalAnalyticsValues,
																					   Number);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , ?(Parameters.RowData = Undefined, "", Parameters.RowData.Key));
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Operation"    , Parameters.Operation);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
			Number = Number + 1;
		EndDo;
	EndIf;
EndProcedure

Function ExtractValueByType(ExtDimensionType, ObjectData, RowData, ArrayOfTypes, AdditionalAnalyticsValues)
	If AdditionalAnalyticsValues <> Undefined Then
		For Each KeyValue In AdditionalAnalyticsValues Do
			
			Value = AdditionalAnalyticsValues[KeyValue.Key];
			ValueType = TypeOf(Value);
			
			If ArrayOfTypes.Find(ValueType) <> Undefined Then
				
				If ValueType = Type("CatalogRef.ExtDimensions") Then
					
					If ValueIsFilled(Value) And Value.Owner = ExtDimensionType Then
						Return Value;
					EndIf;
					
				Else	
					Return Value;
				EndIf;
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
	Parameters.Insert("IsDebitCreditNoteDifference", 
		AnalyticRow.Operation = Catalogs.AccountingOperations.DebitCreditNote_DR_R5020B_PartnersBalance_CR_R5021_Revenues
		Or AnalyticRow.Operation = Catalogs.AccountingOperations.DebitCreditNote_DR_R5022T_Expenses_CR_R5020B_PartnersBalance);
			
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
	
	If TypeOf(Ref) = Type("DocumentRef.ExternalAccountingOperation") Then
		Array = New Array();
		If ArrayOfLedgerTypes.Find(Ref.LedgerType) <> Undefined Then
			Array.Add(Ref.LedgerType);
		EndIf;
		MatchingLedgerTypes = GetMatchingLedgerTypes(Ref.LedgerType);
		
		For Each MatchingLedgerType In MatchingLedgerTypes Do
			If ArrayOfLedgerTypes.Find(MatchingLedgerType) <> Undefined Then
				Array.Add(MatchingLedgerType);
			EndIf;
		EndDo;
		
		Return Array;
	EndIf;
	
	Return ArrayOfLedgerTypes;
EndFunction

Function GetMatchingLedgerTypes(LedgerType)
	Return AccountingServerReuse.GetMatchingLedgerTypes(LedgerType);
EndFunction

Function __GetMatchingLedgerTypes(LedgerType) Export
	Query = New Query();
	Query.Text = 
	"SELECT DISTINCT
	|	Reg.TargetLedgerType AS LedgerType
	|FROM
	|	InformationRegister.T9068S_AccountingMappingAccountsMatching AS Reg
	|WHERE
	|	Reg.SourceLedgerType = &LedgerType";
	
	Query.SetParameter("LedgerType", LedgerType);
	QueryResult = Query.Execute();
	
	QueryTable = QueryResult.Unload();
	
	Return QueryTable.UnloadColumn("LedgerType");
EndFunction

Function GetAccountingOperationsByLedgerType(Object, Period, LedgerType, MainTableName)
	
	DocTransactionType = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "TransactionType") Then
		DocTransactionType = Object.TransactionType;
	EndIf;
	
	Return AccountingServerReuse.GetAccountingOperationsByLedgerType(Object.Ref, 
	                                                                 Period,
	                                                                 DocTransactionType,
	                                                                 LedgerType,
	                                                                 MainTableName);
EndFunction

Function __GetAccountingOperationsByLedgerType(Ref, Period, DocTransactionType, LedgerType, MainTableName) Export
	MetadataName = Ref.Metadata().Name;
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
	|	ByVatRate.IncomingAccountReturn,
	|	ByVatRate.OutgoingAccount,
	|	ByVatRate.OutgoingAccountReturn,
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
	|	ByTax.IncomingAccountReturn,
	|	ByTax.OutgoingAccount,
	|	ByTax.OutgoingAccountReturn,
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
	|	ByCompany.IncomingAccountReturn,
	|	ByCompany.OutgoingAccount,
	|	ByCompany.OutgoingAccountReturn,
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
	|	Accounts.IncomingAccountReturn,
	|	Accounts.OutgoingAccount,
	|	Accounts.OutgoingAccountReturn,
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
	Result = New Structure("IncomingAccount, OutgoingAccount, IncomingAccountReturn, OutgoingAccountReturn");
	If QuerySelection.Next() Then
		Result.IncomingAccount = QuerySelection.IncomingAccount;
		Result.IncomingAccountReturn = QuerySelection.IncomingAccountReturn;
		Result.OutgoingAccount = QuerySelection.OutgoingAccount;
		Result.OutgoingAccountReturn = QuerySelection.OutgoingAccountReturn;
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
	
	ArrayOfNotUsedOperations = New Array();
	
	For Each Operation In OperationsByLedgerType Do
		If Operation.OperationInfo.ByRow Then
			Continue;
		EndIf;
				
		If IsNotUsedOperation(Operation.OperationInfo.Operation, ObjectData, Undefined) Then
			AddNotUsedOperation(ArrayOfNotUsedOperations, Operation.OperationInfo.Operation, Undefined);
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
		
	If MainTableName = Undefined Then // reques table
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
				
				If IsNotUsedOperation(Operation.OperationInfo.Operation, ObjectData, RowData) Then
					AddNotUsedOperation(ArrayOfNotUsedOperations, Operation.OperationInfo.Operation, Row.Key);
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
	
	RemoveNotUsedOperations(ArrayOfNotUsedOperations, AccountingRowAnalytics);
	RemoveNotUsedOperations(ArrayOfNotUsedOperations, AccountingExtDimensions);
EndProcedure

Function IsNotUsedOperation(Operation, ObjectData, RowData)
	// custom flter for each document
	DocMetadata = ObjectData.Ref.Metadata();
	
	If DocMetadata = Metadata.Documents.SalesInvoice Then
		Return IsNotUsedOperation_SalesInvoice(Operation, ObjectData, RowData);
	ElsIf DocMetadata = Metadata.Documents.SalesReturn Then
		Return IsNotUsedOperation_SalesReturn(Operation, ObjectData, RowData);
	ElsIf DocMetadata = Metadata.Documents.CreditNote Then
		Return IsNotUsedOperation_CreditNote(Operation, ObjectData, RowData);
	ElsIf DocMetadata = Metadata.Documents.DebitNote Then
		Return IsNotUsedOperation_DebitNote(Operation, ObjectData, RowData);		
	ElsIf DocMetadata = Metadata.Documents.DebitCreditNote Then
		Return IsNotUsedOperation_DebitCreditNote(Operation, ObjectData, RowData);
	ElsIf DocMetadata = Metadata.Documents.TaxesOperation Then
		Return IsNotUsedOperation_TaxesOperation(Operation, ObjectData, RowData);				
	ElsIf DocMetadata = Metadata.Documents.Payroll Then
		Return IsNotUsedOperation_Payroll(Operation, ObjectData, RowData);
	ElsIf DocMetadata = Metadata.Documents.EmployeeCashAdvance Then
		Return IsNotUsedOperation_EmployeeCashAdvance(Operation, ObjectData, RowData);		
	EndIf;
	
	Return False; // is used operation
EndFunction

Procedure AddNotUsedOperation(ArrayOfNotUsedOperations, Operation, RowKey = Undefined)
	ArrayOfNotUsedOperations.Add(New Structure("Operation, RowKey", Operation, RowKey));
EndProcedure

Procedure RemoveNotUsedOperations(ArrayOfNotUsedOperations, AccountingTable)
	ArrayForDelete = New Array();
	For Each ItemOfNotUsedOperation In ArrayOfNotUsedOperations Do
		For Each Row In AccountingTable Do
			If Row.Operation = ItemOfNotUsedOperation.Operation Then
				If ValueIsFilled(ItemOfNotUsedOperation.RowKey) Then
					If Row.Key = ItemOfNotUsedOperation.RowKey Then
						ArrayForDelete.Add(Row);
					EndIf;
				Else
					ArrayForDelete.Add(Row);
				EndIf;
			EndIf;
		EndDo;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		AccountingTable.Delete(ItemForDelete);
	EndDo;
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
	
		If Row.Operation.DeletionMark Then
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
			If Not Row.IsFixed Then
				ArrayForDelete.Add(Row);
			EndIf;
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
		_IsFixed = False;
		_Filter = New Structure("Key, Operation, LedgerType", Row.Key, Row.Operation, Row.LedgerType);
		_Rows = AccountingRowAnalytics.FindRows(_Filter);
		If _Rows.Count() Then
			_IsFixed = _Rows[0].IsFixed;
		EndIf;
		
		If LedgerTypes.Find(Row.LedgerType) = Undefined Then
			ArrayForDelete.Add(Row);
			Continue;
		EndIf;
		
		If Row.Operation.DeletionMark Then
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
			If Not _IsFixed Then
				ArrayForDelete.Add(Row);
			EndIf;
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
	|	case 
	|		when &IsRevaluationCurrency then 
	|			Amounts.RevaluatedCurrency 
	|		else 
	|			case when not Amounts.DrCurrency.ref is null then
	|				Amounts.DrCurrency
	|			else
	|				Amounts.Currency end end as DrCurrency,
	|
	|	case 
	|		when &IsRevaluationCurrency then 
	|			Amounts.RevaluatedCurrency 
	|		else 
	|			case when not Amounts.CrCurrency.ref is null then
	|				Amounts.CrCurrency
	|			else
	|				Amounts.Currency end end as CrCurrency,
	|
	|
	|	SUM(case 
	|			when &IsRevaluationCurrency Or &IsDebitCreditNoteDifference then 
	|			0 
	|			else
	|				case when Amounts.DrCurrencyAmount <> 0 then
	|					Amounts.DrCurrencyAmount
	|				else
	|					Amounts.Amount end end) AS DrCurrencyAmount,
	|
	|	SUM(case 
	|			when &IsRevaluationCurrency Or &IsDebitCreditNoteDifference then 
	|			0 
	|			else
	|				case when Amounts.CrCurrencyAmount <> 0 then
	|					Amounts.CrCurrencyAmount
	|				else
	|					Amounts.Amount end end) AS CrCurrencyAmount
	|
	|
	|
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
	|	case 
	|		when &IsRevaluationCurrency then 
	|			Amounts.RevaluatedCurrency 
	|		else 
	|			case when not Amounts.DrCurrency.ref is null then
	|				Amounts.DrCurrency
	|			else
	|				Amounts.Currency end end,
	|
	|	case 
	|		when &IsRevaluationCurrency then 
	|			Amounts.RevaluatedCurrency 
	|		else 
	|			case when not Amounts.CrCurrency.ref is null then
	|				Amounts.CrCurrency
	|			else
	|				Amounts.Currency end end
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
	Query.SetParameter("IsDebitCreditNoteDifference", Parameters.IsDebitCreditNoteDifference);
	
	If Parameters.IsCurrencyRevaluation Then
		Query.SetParameter("RevaluationCurrency", Parameters.CurrencyMovementType);
		Query.SetParameter("IsRevaluationCurrency", True);
	Else
		Query.SetParameter("RevaluationCurrency", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
		Query.SetParameter("IsRevaluationCurrency", False);
	EndIf;
		
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	// Currency amount
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.DrCurrency;
		Result.CurrencyAmountDr = QuerySelection.DrCurrencyAmount;
		Result.CurrencyCr       = QuerySelection.CrCurrency;
		Result.CurrencyAmountCr = QuerySelection.CrCurrencyAmount;
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

#Region OperationFilters

Function IsNotUsedOperation_SalesInvoice(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If Operation = AO.SalesInvoice_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		If RowData <> Undefined And RowData.IsService Then
			Return True;
		ENdIf;
	EndIf;
	Return False;
EndFunction

Function IsNotUsedOperation_SalesReturn(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If Operation = AO.SalesReturn_DR_R5022T_Expenses_CR_R4050B_StockInventory Then
		If RowData <> Undefined And RowData.IsService Then
			Return True;
		ENdIf;
	EndIf;
	Return False;
EndFunction

Function IsNotUsedOperation_CreditNote(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If RowData = Undefined Then
		Return True;
	EndIf;
	
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	
	IsVendor   = RowData.Agreement.Type = Enums.AgreementTypes.Vendor;
	IsCustomer = RowData.Agreement.Type = Enums.AgreementTypes.Customer;
	IsOther    = RowData.Agreement.Type = Enums.AgreementTypes.Other;
	
	If IsVendor And Operation = AO.CreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors Then
		Return False;
	ElsIf IsCustomer And Operation = AO.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions Then
		Return False;
	ElsIf IsVendor And Operation = AO.CreditNote_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions Then
		Return False;
	ElsIf IsCustomer And Operation = AO.CreditNote_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions Then
		Return False;
	ElsIf IsOther And Operation = AO.CreditNote_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions Then
		Return False;
	ElsIf IsVendor And Operation = AO.CreditNote_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions Then
		Return Not ValueIsFilled(RowData.TaxAmount);
	ElsIf IsCustomer And Operation = AO.CreditNote_DR_R1040B_TaxesOutgoing_CR_R2021B_CustomersTransactions Then
		Return Not ValueIsFilled(RowData.TaxAmount);
	EndIf;
	Return True;
EndFunction

Function IsNotUsedOperation_DebitNote(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If RowData = Undefined Then
		Return True;
	EndIf;
	
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	
	IsVendor   = RowData.Agreement.Type = Enums.AgreementTypes.Vendor;
	IsCustomer = RowData.Agreement.Type = Enums.AgreementTypes.Customer;
	IsOther    = RowData.Agreement.Type = Enums.AgreementTypes.Other;
	
	If IsVendor And Operation = AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors Then
		Return False;
	ElsIf IsVendor And Operation = AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues Then
		Return False;
	ElsIf IsCustomer And Operation = AO.DebitNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions Then
		Return False;
	ElsIf IsCustomer And Operation = AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues Then
		Return False;
	ElsIf IsOther And Operation = AO.DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues Then
		Return False;
	ElsIf IsVendor And Operation = AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R2040B_TaxesIncoming Then
		Return Not ValueIsFilled(RowData.TaxAmount);
	ElsIf IsCustomer And Operation = AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming Then
		Return Not ValueIsFilled(RowData.TaxAmount);
	EndIf;
	Return True;
EndFunction

Function IsNotUsedOperation_DebitCreditNote(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	
	If Operation = AO.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset Then
		If ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer 
			Or ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer Then
			Return False;
		EndIf;
		Return True;
	ElsIf Operation = AO.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset Then
		If ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor
			Or ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionVendor Then
			Return False;
		EndIf;
		Return True;	
	EndIf;
	
	Return False;
EndFunction

Function IsNotUsedOperation_TaxesOperation(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If RowData = Undefined Then
		Return True;
	EndIf;
	
	If Operation = AO.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R1040B_TaxesOutgoing Then
		If ValueIsFilled(RowData.IncomingVatRate) And ValueIsFilled(RowData.OutgoingVatRate) Then
			Return False;
		Else
			Return True;
		EndIf;
	ElsIf Operation = AO.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R5015B_OtherPartnersTransactions Then
		If ValueIsFilled(RowData.IncomingVatRate) And Not ValueIsFilled(RowData.OutgoingVatRate) Then
			Return False;
		Else
			Return True;
		EndIf;
	ElsIf Operation = AO.TaxesOperation_DR_R5015B_OtherPartnersTransactions_CR_R1040B_TaxesOutgoing Then
		If Not ValueIsFilled(RowData.IncomingVatRate) And ValueIsFilled(RowData.OutgoingVatRate) Then
			Return False;
		Else
			Return True;
		EndIf;
	EndIf;
	Return True;
EndFunction

Function IsNotUsedOperation_Payroll(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If RowData = Undefined Then
		Return True;
	EndIf;
	
	If Operation = AO.Payroll_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes Then
		If ValueIsFilled(RowData.Tax) And RowData.Tax.TaxPayer <> Enums.TaxPayers.Employee Then
			Return True;
		Else
			Return False;
		EndIf;
	ElsIf Operation = AO.Payroll_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes Then
		If ValueIsFilled(RowData.Tax) And RowData.Tax.TaxPayer <> Enums.TaxPayers.Company Then
			Return True;
		Else
			Return False;
		EndIf;
	EndIf;
	Return False;
EndFunction

Function IsNotUsedOperation_EmployeeCashAdvance(Operation, ObjectData, RowData)
	AO = Catalogs.AccountingOperations;
	If RowData = Undefined Then
		Return True;
	EndIf;
	If Operation = AO.EmployeeCashAdvance_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance Then
		If Not ValueIsFilled(RowData.Invoice) Then
			Return False;
		EndIf;
	ElsIf Operation = AO.EmployeeCashAdvance_DR_R1040B_TaxesOutgoing_CR_R3027B_EmployeeCashAdvance Then
		If Not ValueIsFilled(RowData.Invoice) Then
			Return False;
		EndIf;
	ElsIf Operation = AO.EmployeeCashAdvance_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance Then
		If ValueIsFilled(RowData.Invoice) Then
			Return False;
		EndIf;
	EndIf;	
	Return True;
EndFunction

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

Function SortAccountingAnalyticRows(_AccountingRowAnalytics, BasisDoc) Export
	If ValueIsFilled(BasisDoc) Then
		MainTable = AccountingClientServer.GetDocumentMainTable(BasisDoc);	
		If ValueIsFilled(MainTable) And BasisDoc[MainTable].Count()
			And CommonFunctionsClientServer.ObjectHasProperty(BasisDoc[MainTable][0], "Key") Then
		
			_AccountingRowAnalytics.Columns.Add("_tmp_order_1");
			_AccountingRowAnalytics.Columns.Add("_tmp_order_2");
			
			For Each AnalyticRow In _AccountingRowAnalytics Do
				AnalyticRow._tmp_order_2 = AnalyticRow.Operation.Order;
			EndDo;
			
			For Each BasisRow In BasisDoc[MainTable] Do
				If Not ValueIsFilled(BasisRow.Key) Then
					Continue;
				EndIf;
				
				AnalyticRows = _AccountingRowAnalytics.FindRows(New Structure("Key", BasisRow.Key));
				
				For Each AnalyticRow In AnalyticRows Do
					AnalyticRow._tmp_order_1 = BasisRow.LineNumber;
				EndDo;
				
			EndDo;
			
			_AccountingRowAnalytics.Sort("_tmp_order_1, _tmp_order_2");
				
		EndIf;
	EndIf;	
EndFunction	
	
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

	Return DataTable;
EndFunction

Function GetNewDataRegisterRecords(BasisDoc, AccountingRowAnalytics, AccountingExtDimensions) Export
	DataTable = CreateAccountingDataTable();
	
	AvailableLedgerTypes = GetLedgerTypesByCompany(BasisDoc, BasisDoc.Date, BasisDoc.Company);
	
	Errors = New Array();
	
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
				If Not (ValueIsFilled(Row.AccountCredit) And Row.AccountCredit.OffBalance) Then
					Errors.Add(StrTemplate(R().Error_153, Row.Operation, TrimAll(Row.Key)));
					Continue;
				EndIf;
			EndIf;
			
			If Not ValueIsFilled(Row.AccountCredit) Then
				If Not (ValueIsFilled(Row.AccountDebit) And Row.AccountDebit.OffBalance) Then
					Errors.Add(StrTemplate(R().Error_154, Row.Operation, TrimAll(Row.Key)));
					Continue;
				EndIf;
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
	
	Return New Structure("DataTable, Errors", DataTable, Errors);
EndFunction

Function RegisterRecords_AccountingData(BasisDoc)	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(BasisDoc);
	RecordSet.Read();
	_AccountingRowAnalytics = RecordSet.Unload();
	
	SortAccountingAnalyticRows(_AccountingRowAnalytics, BasisDoc);
	
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(BasisDoc);
	RecordSet.Read();
	_AccountingExtDimensions = RecordSet.Unload();
	
	NewRecords = GetNewDataRegisterRecords(BasisDoc, _AccountingRowAnalytics, _AccountingExtDimensions);	
	
	OldRecords_DataTable = GetCurrentDataRegisterRecords(BasisDoc, "");
	
	IgnoredColumns = "LineNumber,PointInTime";
	
	RegisterRecords = New Map();
	If Not CommonFunctionsServer.TablesIsEqual(OldRecords_DataTable, NewRecords.DataTable, IgnoredColumns) Then
		RegisterRecords.Insert(AccountingRegisters.Basic.CreateRecordSet().Metadata(), NewRecords.DataTable);	
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

Function GetExcludeDocumentTypes_AccountingAnalytics() Export
	Array = New Array();
	Array.Add(Type("DocumentRef.CalculationMovementCosts"));
	Array.Add(Type("DocumentRef.CustomersAdvancesClosing"));
	Array.Add(Type("DocumentRef.VendorsAdvancesClosing"));
	Array.Add(Type("DocumentRef.ForeignCurrencyRevaluation"));
	Array.Add(Type("DocumentRef.JournalEntry"));
	Return Array;
EndFunction

Function GetExcludeDocumentTypes_AccountingTranslation() Export
	Array = New Array();
	Array.Add(Type("DocumentRef.CalculationMovementCosts"));
	Array.Add(Type("DocumentRef.CustomersAdvancesClosing"));
	Array.Add(Type("DocumentRef.VendorsAdvancesClosing"));
	Array.Add(Type("DocumentRef.JournalEntry"));
	Return Array;
EndFunction

#EndRegion

#Region BackgroundJob

Procedure CheckAndFixAccounting(Settings) Export
	Settings.ExcludeDocumentTypes = GetExcludeDocumentTypes_AccountingAnalytics();
	DocList = FixDocumentProblemsServer.GetDocumentList(Settings);     
	
	// step 1. analytics
	RegInfoArray = CheckAsJob_AccountingAnalytics(DocList);
	If RegInfoArray.Count() Then
		FixAsJob(RegInfoArray);
		// control check after fix
		RegInfoArray = CheckAsJob_AccountingAnalytics(DocList);
		If RegInfoArray.Count() Then
			Return; // can not fix, write error to log
		EndIf;
	EndIf;
	
	Settings.ExcludeDocumentTypes = GetExcludeDocumentTypes_AccountingTranslation();
	DocList = FixDocumentProblemsServer.GetDocumentList(Settings);     
		
	// step 2. translations
	RegInfoArray = CheckAsJob_AccountingTranslation(DocList);
	If RegInfoArray.Count() Then
		FixAsJob(RegInfoArray);
		// control check after fix
		RegInfoArray = CheckAsJob_AccountingTranslation(DocList);
		If RegInfoArray.Count() Then
			Return; // can not fix, write error to log
		EndIf;		
	EndIf;	
EndProcedure

Function CheckAsJob_AccountingAnalytics(DocList)
	JobDataSettings = FixDocumentProblemsServer.GetJobsForCheckPostingDocuments(DocList, 
		"AccountingServer.CheckDocumentArray_AccountingAnalytics");
	Return RunJob(JobDataSettings);
EndFunction

Function CheckAsJob_AccountingTranslation(DocList)
	JobDataSettings = FixDocumentProblemsServer.GetJobsForCheckPostingDocuments(DocList, 
		"AccountingServer.CheckDocumentArray_AccountingTranslation");
	Return RunJob(JobDataSettings);
EndFunction


Function FixAsJob(RegInfoArray)
	Tree = BackgroundJobAPIServer.RegInfoArrayToPostingInfo(RegInfoArray);
	JobDataSettings = FixDocumentProblemsServer.GetJobsForWriteRecordSet(Tree);
	Return RunJob(JobDataSettings);
EndFunction

Function RunJob(JobDataSettings)
	_JobList = BackgroundJobAPIServer.GetJobList();
	BackgroundJobAPIServer.FillJobList(JobDataSettings, _JobList);
	BackgroundJobAPIServer.RunJobsFromServer(JobDataSettings, _JobList);           

	For Each JobRow In _JobList Do
		If Not JobRow.Status = Enums.JobStatus.Completed Then
			Raise "One job is failed";
		EndIf; 
	EndDo;     
	
	RegInfoArray = New Array();
	For Each JobRow In _JobList Do
		ArrayOfData = CommonFunctionsServer.GetFromCache(JobRow.DataAddress);
		For Each ItemOfData In ArrayOfData Do
			RegInfoArray.Add(ItemOfData);
		EndDo;
	EndDo;
	
	Return RegInfoArray;
EndFunction

#EndRegion

#Region AccountingService

Procedure LoadAccountingRecordsByPeriod(IntegrationSettings, StartDate, EndDate, RegisterName = "") Export
	TotalArrayOfDates = New Array();
	If BegOfDay(StartDate) = BegOfDay(EndDate) Then
		TotalArrayOfDates.Add(BegOfDay(StartDate));
	ELse
		_Date = BegOfDay(StartDate);
		While _Date <= BegOfDay(EndDate) Do
			TotalArrayOfDates.Add(_Date);
			_Date = EndOfDay(_Date) + 1;
		EndDo;
	EndIf;

	LoadAccountingRecords(IntegrationSettings, TotalArrayOfDates, RegisterName);
EndProcedure

Procedure LoadAccountingRecordsAll(IntegrationSettings, RegisterName = "") Export
	ExternalRegisters = GetExternalRegisters(IntegrationSettings);	
	
	TotalArrayOfDates = New Array();
	
	For Each ExternalRegister In ExternalRegisters Do
		
		If ValueIsFilled(RegisterName) And Upper(RegisterName) <> Upper(TrimAll(ExternalRegister.ExternalName)) Then
			Continue;
		EndIf;
	
		QueryParams = New Structure();
		QueryParams.Insert("RegisterName", TrimAll(ExternalRegister.ExternalName));
		QueryParams.Insert("NodeCode", IntegrationSettings.UniqueID);
		ResponseData = SendGETRequest(IntegrationSettings, "changesdates", QueryParams);
		For Each ChangesDate In ResponseData.Data Do
			_ChangesDate = ReadJSONDate(ChangesDate, JSONDateFormat.ISO);
			If TotalArrayOfDates.Find(_ChangesDate) = Undefined Then
				TotalArrayOfDates.Add(_ChangesDate);
			EndIf;
		EndDo;
	EndDo;
		
	LoadAccountingRecords(IntegrationSettings, TotalArrayOfDates, RegisterName);
EndProcedure

Procedure LoadAccountingOpeningEntry(IntegrationSettings, Date, RegisterName = "") Export
	ExternalRegisters = GetExternalRegisters(IntegrationSettings);	
	For Each ExternalRegister In ExternalRegisters Do
		
		If ValueIsFilled(RegisterName) And Upper(RegisterName) <> Upper(TrimAll(ExternalRegister.ExternalName)) Then
			Continue;
		EndIf;
		
		RequestData = New Structure();
		RequestData.Insert("Date", EndOfDay(Date));
		RequestData.Insert("RegisterName", TrimAll(ExternalRegister.ExternalName));
	
		Json = SendPOSTRequest(IntegrationSettings, "get_opening_entry", RequestData);
		ResponseData = CommonFunctionsServer.DeserializeJSON(Json);
		For Each Data In ResponseData.Data Do
			If Data.Records.Count() Then
				CreateExternalAccountingOperation(IntegrationSettings, Data, ExternalRegister.LedgerType);
			Else
				DeleteExternalAccountingOperation(IntegrationSettings, Data, ExternalRegister.LedgerType);
			EndIf;
		EndDo;
		
	EndDo;
EndProcedure

Procedure LoadAccountingRecords(IntegrationSettings, ArrayOfDates, RegisterName)
	
	ExternalRegisters = GetExternalRegisters(IntegrationSettings);	
	
	For Each ExternalRegister In ExternalRegisters Do
		
		If ValueIsFilled(RegisterName) And Upper(RegisterName) <> Upper(TrimAll(ExternalRegister.ExternalName)) Then
			Continue;
		EndIf;
		
		For Each ChangesDate In ArrayOfDates Do
			RequestData = New Structure();
			RequestData.Insert("StartDate", BegOfDay(ChangesDate));
			RequestData.Insert("EndDate", EndOfDay(ChangesDate));
			RequestData.Insert("NodeCode", IntegrationSettings.UniqueID);
			RequestData.Insert("RegisterName", TrimAll(ExternalRegister.ExternalName));
	
			Json = SendPOSTRequest(IntegrationSettings, "get_changes", RequestData);
			ResponseData = CommonFunctionsServer.DeserializeJSON(Json);
			
			HaveError = False;
			
			ArrayOfRecorders = New Array();
			
			For Each Data In ResponseData.Data Do
				
				RecorderInfo = New Structure();
				RecorderInfo.Insert("RecorderRef", Data.RecorderRef);
				RecorderInfo.Insert("RecorderName", Data.RecorderName);
				ArrayOfRecorders.Add(RecorderInfo);
				
				If Data.Records.Count() Then
					If Not CreateExternalAccountingOperation(IntegrationSettings, Data, ExternalRegister.LedgerType) Then
						HaveError = True;
					EndIf;
				Else
					If Not DeleteExternalAccountingOperation(IntegrationSettings, Data, ExternalRegister.LedgerType) Then
						HaveError = True;
					EndIf;
				EndIf;
			EndDo;
			
			If Not HaveError And ResponseData.MessageNo <> 0 Then
				RequestData = New Structure();
				RequestData.Insert("NodeCode", IntegrationSettings.UniqueID);
				RequestData.Insert("RegisterName", TrimAll(ExternalRegister.ExternalName));
				RequestData.Insert("MessageNo", ResponseData.MessageNo);
				RequestData.Insert("Recorders", ArrayOfRecorders);
				SendPOSTRequest(IntegrationSettings, "DeleteChanges", RequestData);
			EndIf;
						
		EndDo;
	EndDo;
	
EndProcedure

Function GetExternalRegisters(IntegrationSettings)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExternalName,
	|	Reg.LedgerType
	|FROM
	|	InformationRegister.T9064S_AccountingMappingRegisters AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings";
	Query.SetParameter("IntegrationSettings", IntegrationSettings);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function DeleteExternalAccountingOperation(IntegrationSettings, Data, LedgerType)
	DataTable = GetEmptyTableForResponseData();
	NewRow = DataTable.Add();
	FillPropertyValues(NewRow, Data);
	NewRow.RecorderDate = ReadJSONDate(Data.RecorderDate, JSONDateFormat.ISO);
	NewRow.RecorderRef  = ?(ValueIsFilled(Data.RecorderRef)     , New UUID(Data.RecorderRef)   , Undefined);	
	NewRow.LedgerType = LedgerType;
	
	Query = New Query();
	Query.Text = GetDataTableQueryText();
	Query.SetParameter("IntegrationSettings", IntegrationSettings);
	Query.SetParameter("DataTable", DataTable);
	
	QueryResult = Query.Execute();
	
	QueryTable = QueryResult.Unload(); 
	
	If QueryTable.Count() Then
		If ValueIsFilled(QueryTable[0].DocRef) Then
			DocObject = QueryTable[0].DocRef.GetObject();
		Else
			Return True;
		EndIf;
				
		FillPropertyValues(DocObject, QueryTable[0], , "Posted");
		DocObject.Date = QueryTable[0].RecorderDate;
		DocObject.Records.Clear();
		DocObject.Write(DocumentWriteMode.UndoPosting);
	EndIf;
	Return True;
EndFunction

Function CreateExternalAccountingOperation(IntegrationSettings, Data, LedgerType)
	DataTable = GetEmptyTableForResponseData();
	For Each Record In Data.Records Do
		NewRow = DataTable.Add();
		FillPropertyValues(NewRow, Data);
		FillPropertyValues(NewRow, Record);
		NewRow.RecorderDate = ReadJSONDate(Data.RecorderDate, JSONDateFormat.ISO);
		NewRow.RecorderRef  = ?(ValueIsFilled(Data.RecorderRef)     , New UUID(Data.RecorderRef)   , Undefined);
		
		NewRow.Period         = ReadJSONDate(Record.Period, JSONDateFormat.ISO);
		NewRow.CompanyRef     = ?(ValueIsFilled(Record.CompanyRef)    , New UUID(Record.CompanyRef)    , Undefined);
		NewRow.CurrencyRef    = ?(ValueIsFilled(Record.CurrencyRef)   , New UUID(Record.CurrencyRef)   , Undefined);
		NewRow.CurrencyDrRef  = ?(ValueIsFilled(Record.CurrencyDrRef) , New UUID(Record.CurrencyDrRef) , Undefined);
		NewRow.CurrencyCrRef  = ?(ValueIsFilled(Record.CurrencyCrRef) , New UUID(Record.CurrencyCrRef) , Undefined);
		NewRow.AccountDrRef   = ?(ValueIsFilled(Record.AccountDrRef)  , New UUID(Record.AccountDrRef)  , Undefined);
		NewRow.AccountCrRef   = ?(ValueIsFilled(Record.AccountCrRef)  , New UUID(Record.AccountCrRef)  , Undefined);
		NewRow.LedgerType = LedgerType;
		
		For Each ExtDimension In Record.ExtDimensionValueDr Do
			FillExtDimensionsRow(NewRow, ExtDimension, "Dr");	
		EndDo;
		
		For Each ExtDimension In Record.ExtDimensionValueCr Do
			FillExtDimensionsRow(NewRow, ExtDimension, "Cr");	
		EndDo;
		
	EndDo;
	
	Query = New Query();
	Query.Text = GetDataTableQueryText();
	Query.SetParameter("IntegrationSettings", IntegrationSettings);
	Query.SetParameter("DataTable", DataTable);
	
	QueryResult = Query.Execute();
	
	QueryTable = QueryResult.Unload(); 
	
	If QueryTable.Count() Then
		If Not ValueIsFilled(QueryTable[0].DocRef) Then
			DocObject = Documents.ExternalAccountingOperation.CreateDocument();
		Else
			DocObject = QueryTable[0].DocRef.GetObject();
		EndIf;
				
		FillPropertyValues(DocObject, QueryTable[0], , "Posted");
		DocObject.Date = QueryTable[0].RecorderDate;
		
		DocObject.Records.Clear();
		DocObject.Errors.Clear();
		
		For Each Row In QueryTable Do
			FindOrCreateAnalytic(IntegrationSettings, Row, Row, "Dr");
			FindOrCreateAnalytic(IntegrationSettings, Row, Row, "Cr");
			
			NewRow = DocObject.Records.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Key = New UUID();
			
			// errors
			If Not ValueIsFilled(NewRow.Company) And ValueIsFilled(NewRow.CompanyRef) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_155, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.Currency) And ValueIsFilled(NewRow.CurrencyRef) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_156, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.AccountDr) And ValueIsFilled(NewRow.AccountDrRef) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_157, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.AccountCr) And ValueIsFilled(NewRow.AccountCrRef) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_158, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.CurrencyDr) And ValueIsFilled(NewRow.CurrencyDrRef) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_159, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.CurrencyCr) And ValueIsFilled(NewRow.CurrencyCrRef) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_160, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.InternalExtDimensionValueDr1) And ValueIsFilled(NewRow.ExtDimensionValueDr1) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_161, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.ExtDimensionTypeDr1) And ValueIsFilled(NewRow.ExtDimensionRefDr1) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_162, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.InternalExtDimensionValueDr2) And ValueIsFilled(NewRow.ExtDimensionValueDr2) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_163, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.ExtDimensionTypeDr2) And ValueIsFilled(NewRow.ExtDimensionRefDr2) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_164, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.InternalExtDimensionValueDr3) And ValueIsFilled(NewRow.ExtDimensionValueDr3) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_165, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.ExtDimensionTypeDr3) And ValueIsFilled(NewRow.ExtDimensionRefDr3) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_166, NewRow.Key);
			EndIf;
						
			If Not ValueIsFilled(NewRow.InternalExtDimensionValueCr1) And ValueIsFilled(NewRow.ExtDimensionValueCr1) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_167, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.ExtDimensionTypeCr1) And ValueIsFilled(NewRow.ExtDimensionRefCr1) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_168, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.InternalExtDimensionValueCr2) And ValueIsFilled(NewRow.ExtDimensionValueCr2) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_169, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.ExtDimensionTypeCr2) And ValueIsFilled(NewRow.ExtDimensionRefCr2) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_170, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.InternalExtDimensionValueCr3) And ValueIsFilled(NewRow.ExtDimensionValueCr3) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_171, NewRow.Key);
			EndIf;
			
			If Not ValueIsFilled(NewRow.ExtDimensionTypeCr3) And ValueIsFilled(NewRow.ExtDimensionRefCr3) Then
				DocObject.Errors.Add().Error = StrTemplate(R().Error_172, NewRow.Key);
			EndIf;
			
		EndDo;
		
		If QueryTable[0].Posted Then
			DocObject.Write(DocumentWriteMode.Posting);
		Else
			DocObject.Write(DocumentWriteMode.UndoPosting);
		EndIf;
	EndIf;
	
	Return DocObject.Errors.Count() = 0;
EndFunction

Function GetEmptyTableForResponseData()
	Doc_StandardAttr = Metadata.Documents.ExternalAccountingOperation.StandardAttributes;
	
	Type_LedgerType = New TypeDescription("CatalogRef.LedgerTypes");
	
	Type_UUID     = New TypeDescription("UUID");
	Type_Boolean  = New TypeDescription("Boolean");
	Type_Desc     = Metadata.DefinedTypes.typeDescription.Type;
	Type_Amount   = Metadata.DefinedTypes.typeAmount.Type;
	Type_Quantity = Metadata.DefinedTypes.typeQuantity.Type;
	
	EmptyTable = New ValueTable();
	
	EmptyTable.Columns.Add("RecorderRef"          , Type_UUID);
	EmptyTable.Columns.Add("RecorderPresentation" , Type_Desc);
	EmptyTable.Columns.Add("RecorderName"         , Type_Desc);
	EmptyTable.Columns.Add("LedgerType"           , Type_LedgerType);
	EmptyTable.Columns.Add("RecorderDate"         , Doc_StandardAttr.Date.Type);
	EmptyTable.Columns.Add("IsOpeningEntry"       , Type_Boolean);
	
	EmptyTable.Columns.Add("Posted"               , Type_Boolean);
	EmptyTable.Columns.Add("DeletionMark"         , Type_Boolean);
	
	EmptyTable.Columns.Add("Period"                , Doc_StandardAttr.Date.Type);	
	EmptyTable.Columns.Add("Activity"              , Type_Boolean);
	EmptyTable.Columns.Add("OperationTitle"        , Type_Desc);
	
	EmptyTable.Columns.Add("CompanyRef"            , Type_UUID);
	EmptyTable.Columns.Add("CompanyPresentation"   , Type_Desc);
	
	EmptyTable.Columns.Add("CurrencyRef"           , Type_UUID);
	EmptyTable.Columns.Add("CurrencyPresentation"  , Type_Desc);
	EmptyTable.Columns.Add("Amount"                , Type_Amount);
	
	// debit
	EmptyTable.Columns.Add("ChartNameDr"           , Type_Desc);
	EmptyTable.Columns.Add("AccountDrRef"          , Type_UUID);
	EmptyTable.Columns.Add("AccountDrPresentation" , Type_Desc);
	
	EmptyTable.Columns.Add("CurrencyDrRef"         , Type_UUID);
	EmptyTable.Columns.Add("CurrencyDrPresentation", Type_Desc);
	EmptyTable.Columns.Add("AmountCurrencyDr"      , Type_Amount);
	EmptyTable.Columns.Add("QuantityDr"            , Type_Quantity);
	
	// credit
	EmptyTable.Columns.Add("ChartNameCr"           , Type_Desc);
	EmptyTable.Columns.Add("AccountCrRef"          , Type_UUID);
	EmptyTable.Columns.Add("AccountCrPresentation" , Type_Desc);
	
	EmptyTable.Columns.Add("CurrencyCrRef"         , Type_UUID);
	EmptyTable.Columns.Add("CurrencyCrPresentation", Type_Desc);
	EmptyTable.Columns.Add("AmountCurrencyCr"      , Type_Amount);
	EmptyTable.Columns.Add("QuantityCr"            , Type_Quantity);
	
	CreateExtDimensionsColumns(EmptyTable, "Dr");
	CreateExtDimensionsColumns(EmptyTable, "Cr");
		
	Return EmptyTable;
EndFunction

Procedure CreateExtDimensionsColumns(Table, AnalyticType)
	Type_UUID     = New TypeDescription("UUID");
	Type_Boolean  = New TypeDescription("Boolean");
	Type_Desc     = Metadata.DefinedTypes.typeDescription.Type;
	Type_Analytic = New TypeDescription(Metadata.ChartsOfCharacteristicTypes.AccountingExtraDimensionTypes.Type.Types());
	
	i = 1;
	While i <= 3 Do
		
		Table.Columns.Add("ExtDimensionRef"   + AnalyticType + i , Type_UUID);
		Table.Columns.Add("BaseClass"         + AnalyticType + i , Type_Desc);
		Table.Columns.Add("Class"             + AnalyticType + i , Type_Desc);
		Table.Columns.Add("IsRef"             + AnalyticType + i , Type_Boolean);
		Table.Columns.Add("ExtDimensionValue" + AnalyticType + i , Type_Desc);
		Table.Columns.Add("Description_ru"    + AnalyticType + i , Type_Desc);
		Table.Columns.Add("Description_en"    + AnalyticType + i , Type_Desc);
		Table.Columns.Add("Description_tr"    + AnalyticType + i , Type_Desc);
		
		Table.Columns.Add("InternalExtDimensionValue" + AnalyticType + i , Type_Analytic);
		
		i = i + 1;
	EndDo;
	
EndProcedure

Procedure FillExtDimensionsRow(Row, ExtDimension, AnalyticType)
	Row["ExtDimensionRef"   + AnalyticType + ExtDimension.Number] = New UUID(ExtDimension.ExtDimensionRef);
	Row["BaseClass"         + AnalyticType + ExtDimension.Number] = ExtDimension.BaseClass;
	Row["Class"             + AnalyticType + ExtDimension.Number] = ExtDimension.Class;
	Row["IsRef"             + AnalyticType + ExtDimension.Number] = ExtDimension.IsRef;
	
	Row["ExtDimensionValue" + AnalyticType + ExtDimension.Number] = ?(ExtDimension.IsRef, ExtDimension.Value.Ref, ExtDimension.Value.Name);
	
	ArrayOfDescriptions = LocalizationReuse.AllDescription();
	
	For Each Description In ArrayOfDescriptions Do
		PropertyName = Description + + AnalyticType + ExtDimension.Number;
		If CommonFunctionsClientServer.ObjectHasProperty(Row, PropertyName) 
			And CommonFunctionsClientServer.ObjectHasProperty(ExtDimension.Value, Description) Then
			Row[PropertyName] = ExtDimension.Value[Description];
		EndIf;
	EndDo;
EndProcedure

Procedure FindOrCreateAnalytic(IntegrationSettings, Source, Target, AnalyticType)

	i = 1;
	While i <= 3 Do
		_ExtDimensionRef   = Source["ExtDimensionRef"   + AnalyticType + i]; 
		_ExternalBaseClass = Source["BaseClass"         + AnalyticType + i]; 
		_ExternalClass     = Source["Class"             + AnalyticType + i]; 
		_ExtDimensionValue = Source["ExtDimensionValue" + AnalyticType + i]; 
		
		ArrayOfDescriptions = LocalizationReuse.AllDescription();
		
		NewObjData = New Structure();
		
		For Each Description In ArrayOfDescriptions Do
			PropertyName = Description + AnalyticType + i;
			If CommonFunctionsClientServer.ObjectHasProperty(Source, PropertyName) Then
				NewObjData.Insert(Description, Source[PropertyName]);
			EndIf;
		EndDo;
		
		_ExtDimensionType  = Source["ExtDimensionType"  + AnalyticType + i];
		_InternalBaseClass = Source["InternalBaseClass" + AnalyticType + i];
		_InternalClass     = Source["InternalClass"     + AnalyticType + i];
		
		If (ValueIsFilled(_ExtDimensionRef) And ValueIsFilled(_ExtDimensionValue))
			And Not ValueIsFilled(_ExtDimensionType) Then
			Raise StrTemplate("Not defined ext. dimension type for [%1] [%2] [%3]",
				_ExtDimensionRef, _ExternalBaseClass, _ExternalClass);
		EndIf;
		
		If ValueIsFilled(_ExtDimensionValue) Then
			
			ExternalIsRef = Upper(_ExternalBaseClass) = Upper("Catalogs") Or Upper(_ExternalBaseClass) = Upper("Documents");
			InternalIsRef = Upper(_InternalBaseClass) = Upper("Catalogs") Or Upper(_InternalBaseClass) = Upper("Documents");
			
			NewObjData.Insert("InternalBaseClass" , _InternalBaseClass);
			NewObjData.Insert("InternalClass"     , _InternalClass);			
			NewObjData.Insert("ExternalBaseClass" , _ExternalBaseClass);
			NewObjData.Insert("ExternalClass"     , _ExternalClass);
			
			If ExternalIsRef Then				
				Target["InternalExtDimensionValue" + AnalyticType + i] 
				= FindOrCreateRefAnalytic(IntegrationSettings, _ExtDimensionValue, _ExtDimensionType, NewObjData, InternalIsRef);
			
			ELsIf Not ExternalIsRef Then 
				Target["InternalExtDimensionValue" + AnalyticType + i] 
					= FindOrCreateEnumAnalytic(IntegrationSettings, _ExtDimensionValue, _ExtDimensionType, NewObjData, InternalIsRef);
			EndIf;
			
		EndIf;
		
		i = i + 1;
	EndDo;

EndProcedure

Function FindOrCreateRefAnalytic(IntegrationSettings, ExternalRef, ExtDimensionType, NewObjData, InternalIsRef) Export
	_ExternalRef_UUID = New UUID(ExternalRef);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExtDimensionValue
	|FROM
	|	InformationRegister.T9066S_AccountingMappingExtDimensionRefValues AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.ExternalRef = &ExternalRef
	|	AND Reg.ExtDimensionType = &ExtDimensionType";
	
	Query.SetParameter("IntegrationSettings" , IntegrationSettings);
	Query.SetParameter("ExternalRef"         , _ExternalRef_UUID);
	Query.SetParameter("ExtDimensionType"    , ExtDimensionType);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	_ExtDimensionValue = Undefined;
	If QuerySelection.Next() Then
		_ExtDimensionValue = QuerySelection.ExtDimensionValue;
	EndIf;
	
	If Not InternalIsRef And Not ValueIsFilled(_ExtDimensionValue) Then
		Raise StrTemplate("Not found value for external ref [%1]", ExternalRef);
	EndIf;
			
	NewRefData = FindOrCreateCatalogRef(_ExtDimensionValue, ExtDimensionType, NewObjData);
		
	If NewRefData.IsNewObject Then
		RecordsSet = InformationRegisters.T9066S_AccountingMappingExtDimensionRefValues.CreateRecordSet();
		RecordsSet.Filter.IntegrationSettings.Set(IntegrationSettings);
		RecordsSet.Filter.ExternalRef.Set(_ExternalRef_UUID);
		RecordsSet.Filter.ExtDimensionType.Set(ExtDimensionType);
		
		Record = RecordsSet.Add();
		Record.IntegrationSettings = IntegrationSettings;
		Record.ExternalRef         = _ExternalRef_UUID;
		Record.ExtDimensionType    = ExtDimensionType;
		
		Record.ExtDimensionValue = NewRefData.Ref;
		
		RecordsSet.Write();
	EndIf;
	
	Return NewRefData.Ref;
EndFunction

Function FindOrCreateEnumAnalytic(IntegrationSettings, ExternalValue, ExtDimensionType, NewObjData, InternalIsRef) Export
	
	_ExternalValue = "" + NewObjData.ExternalBaseClass + "." + NewObjData.ExternalClass + "." + ExternalValue;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Reg.ExtDimensionValue
	|FROM
	|	InformationRegister.T9067S_AccountingMappingExtDimensionEnumValues AS Reg
	|WHERE
	|	Reg.IntegrationSettings = &IntegrationSettings
	|	AND Reg.ExternalValue = &ExternalValue
	|	AND Reg.ExtDimensionType = &ExtDimensionType";
	
	Query.SetParameter("IntegrationSettings" , IntegrationSettings);
	Query.SetParameter("ExternalValue"       , _ExternalValue);
	Query.SetParameter("ExtDimensionType"    , ExtDimensionType);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	_ExtDimensionValue = Undefined;
	If QuerySelection.Next() Then
		_ExtDimensionValue = QuerySelection.ExtDimensionValue;
	EndIf;
	
	If Not InternalIsRef And Not ValueIsFilled(_ExtDimensionValue) Then
		Raise StrTemplate("Not found value for external value [%1]", _ExternalValue);
	EndIf;
	
	NewRefData = FindOrCreateCatalogRef(_ExtDimensionValue, ExtDimensionType, NewObjData);
		
	If NewRefData.IsNewObject Then
		RecordsSet = InformationRegisters.T9067S_AccountingMappingExtDimensionEnumValues.CreateRecordSet();
		RecordsSet.Filter.IntegrationSettings.Set(IntegrationSettings);
		RecordsSet.Filter.ExternalValue.Set(_ExternalValue);
		RecordsSet.Filter.ExtDimensionType.Set(ExtDimensionType);
		
		Record = RecordsSet.Add();
		Record.IntegrationSettings = IntegrationSettings;
		Record.ExternalValue       = _ExternalValue;
		Record.ExtDimensionType    = ExtDimensionType;
		
		Record.ExtDimensionValue = NewRefData.Ref;
		
		RecordsSet.Write();
	EndIf;
	
	Return NewRefData.Ref;
EndFunction

Function FindOrCreateCatalogRef(ExsistsRef, ExtDimensionType, NewObjData)
	IsNewObject = False;
	If ValueIsFilled(ExsistsRef) Then
		Obj = ExsistsRef.GetObject();
	Else
		// create new Catalogs
		If Upper(NewObjData.InternalBaseClass) = Upper("Catalogs") Then
			IsNewObject = True;
			Obj = Catalogs[NewObjData.InternalClass].CreateItem();
			Obj.SetNewCode();
		Else
			Raise "Create new analytics with Document type not supported";
		EndIf;
	EndIf;

	FillPropertyValues(Obj, NewObjData);
	If TypeOf(Obj) = Type("CatalogObject.ExtDimensions") Then
		Obj.Owner = ExtDimensionType;
	EndIf;	
	Obj.DataExchange.Load = True;
	Obj.Write();
	Return New Structure("IsNewObject, Ref", IsNewObject, Obj.Ref);
EndFunction

Function GetDataTableQueryText()
	Return
	"SELECT
	|	DataTable.*
	|INTO DataTable
	|FROM
	|	&DataTable AS DataTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DataTable.*,
	|	Doc.Ref AS DocRef,
	|	RegCompanies.InternalRef AS Company,
	|	RegCurrenciesDr.InternalRef AS CurrencyDr,
	|	RegCurrenciesCr.InternalRef AS CurrencyCr,
	|	RegCurrencies.InternalRef AS Currency,
	|	AccountsDr.InternalRef AS AccountDr,
	|	AccountsCr.InternalRef AS AccountCr,
	|	ExtDimensionsDr1.InternalRef AS ExtDimensionTypeDr1,
	|	ExtDimensionsDr1.InternalBaseClass AS InternalBaseClassDr1,
	|	ExtDimensionsDr1.InternalClass AS InternalClassDr1,
	|	ExtDimensionsDr2.InternalRef AS ExtDimensionTypeDr2,
	|	ExtDimensionsDr2.InternalBaseClass AS InternalBaseClassDr2,
	|	ExtDimensionsDr2.InternalClass AS InternalClassDr2,
	|	ExtDimensionsDr3.InternalRef AS ExtDimensionTypeDr3,
	|	ExtDimensionsDr3.InternalBaseClass AS InternalBaseClassDr3,
	|	ExtDimensionsDr3.InternalClass AS InternalClassDr3,
	|	ExtDimensionsCr1.InternalRef AS ExtDimensionTypeCr1,
	|	ExtDimensionsCr1.InternalBaseClass AS InternalBaseClassCr1,
	|	ExtDimensionsCr1.InternalClass AS InternalClassCr1,
	|	ExtDimensionsCr2.InternalRef AS ExtDimensionTypeCr2,
	|	ExtDimensionsCr2.InternalBaseClass AS InternalBaseClassCr2,
	|	ExtDimensionsCr2.InternalClass AS InternalClassCr2,
	|	ExtDimensionsCr3.InternalRef AS ExtDimensionTypeCr3,
	|	ExtDimensionsCr3.InternalBaseClass AS InternalBaseClassCr3,
	|	ExtDimensionsCr3.InternalClass AS InternalClassCr3
	|FROM
	|	DataTable AS DataTable
	|		LEFT JOIN Document.ExternalAccountingOperation AS Doc
	|		ON case
	|			when DataTable.IsOpeningEntry
	|				then Doc.IsOpeningEntry
	|				and beginofperiod(Doc.Date, DAY) = beginofperiod(DataTable.Period, DAY)
	|			else Doc.RecorderRef = DataTable.RecorderRef
	|		end
	|		AND Doc.LedgerType = DataTable.LedgerType
	|		LEFT JOIN InformationRegister.T9063S_AccountingMappingCurrencies AS RegCurrenciesDr
	|		ON RegCurrenciesDr.ExternalRef = DataTable.CurrencyDrRef
	|		AND RegCurrenciesDr.IntegrationSettings = &IntegrationSettings
	|		LEFT JOIN InformationRegister.T9063S_AccountingMappingCurrencies AS RegCurrenciesCr
	|		ON RegCurrenciesCr.ExternalRef = DataTable.CurrencyCrRef
	|		AND RegCurrenciesCr.IntegrationSettings = &IntegrationSettings
	|		LEFT JOIN InformationRegister.T9063S_AccountingMappingCurrencies AS RegCurrencies
	|		ON RegCurrencies.ExternalRef = DataTable.CurrencyRef
	|		AND RegCurrencies.IntegrationSettings = &IntegrationSettings
	|		LEFT JOIN InformationRegister.T9062S_AccountingMappingCompanies AS RegCompanies
	|		ON RegCompanies.ExternalRef = DataTable.CompanyRef
	|		AND RegCompanies.IntegrationSettings = &IntegrationSettings
	|		LEFT JOIN InformationRegister.T9061S_AccountingMappingAccounts AS AccountsDr
	|		ON AccountsDr.ExternalRef = DataTable.AccountDrRef
	|		AND AccountsDr.ExternalChartName = DataTable.ChartNameDr
	|		AND AccountsDr.IntegrationSettings = &IntegrationSettings
	|		LEFT JOIN InformationRegister.T9061S_AccountingMappingAccounts AS AccountsCr
	|		ON AccountsCr.ExternalRef = DataTable.AccountCrRef
	|		AND AccountsCr.ExternalChartName = DataTable.ChartNameCr
	|		AND AccountsCr.IntegrationSettings = &IntegrationSettings
	|		// analytics Dr
	|		left join InformationRegister.T9065S_AccountingMappingExtDimensions AS ExtDimensionsDr1
	|		on ExtDimensionsDr1.IntegrationSettings = &IntegrationSettings
	|		and ExtDimensionsDr1.ExternalRef = DataTable.ExtDimensionRefDr1
	|		and ExtDimensionsDr1.ExternalBaseClass = DataTable.BaseClassDr1
	|		and ExtDimensionsDr1.ExternalClass = DataTable.ClassDr1
	|		left join InformationRegister.T9065S_AccountingMappingExtDimensions AS ExtDimensionsDr2
	|		on ExtDimensionsDr2.IntegrationSettings = &IntegrationSettings
	|		and ExtDimensionsDr2.ExternalRef = DataTable.ExtDimensionRefDr2
	|		and ExtDimensionsDr2.ExternalBaseClass = DataTable.BaseClassDr2
	|		and ExtDimensionsDr2.ExternalClass = DataTable.ClassDr2
	|		left join InformationRegister.T9065S_AccountingMappingExtDimensions AS ExtDimensionsDr3
	|		on ExtDimensionsDr3.IntegrationSettings = &IntegrationSettings
	|		and ExtDimensionsDr3.ExternalRef = DataTable.ExtDimensionRefDr3
	|		and ExtDimensionsDr3.ExternalBaseClass = DataTable.BaseClassDr3
	|		and ExtDimensionsDr3.ExternalClass = DataTable.ClassDr3
	|		// analytics Cr
	|		left join InformationRegister.T9065S_AccountingMappingExtDimensions AS ExtDimensionsCr1
	|		on ExtDimensionsCr1.IntegrationSettings = &IntegrationSettings
	|		and ExtDimensionsCr1.ExternalRef = DataTable.ExtDimensionRefCr1
	|		and ExtDimensionsCr1.ExternalBaseClass = DataTable.BaseClassCr1
	|		and ExtDimensionsCr1.ExternalClass = DataTable.ClassCr1
	|		left join InformationRegister.T9065S_AccountingMappingExtDimensions AS ExtDimensionsCr2
	|		on ExtDimensionsCr2.IntegrationSettings = &IntegrationSettings
	|		and ExtDimensionsCr2.ExternalRef = DataTable.ExtDimensionRefCr2
	|		and ExtDimensionsCr2.ExternalBaseClass = DataTable.BaseClassCr2
	|		and ExtDimensionsCr2.ExternalClass = DataTable.ClassCr2
	|		left join InformationRegister.T9065S_AccountingMappingExtDimensions AS ExtDimensionsCr3
	|		on ExtDimensionsCr3.IntegrationSettings = &IntegrationSettings
	|		and ExtDimensionsCr3.ExternalRef = DataTable.ExtDimensionRefCr3
	|		and ExtDimensionsCr3.ExternalBaseClass = DataTable.BaseClassCr3
	|		and ExtDimensionsCr3.ExternalClass = DataTable.ClassCr3";
EndFunction
	
Function SendGETRequest(IntegrationSettings, Action, QueryParameters = Undefined) Export
	
	ConnectionSettings = IntegrationClientServer.ConnectionSetting(IntegrationSettings);
	ConnectionSettings.Value.QueryType = "GET";
	
	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;
	
	ResourceParameters = New Structure();
	ResourceParameters.Insert("action", Action);
	
	RequestResult = IntegrationClientServer.SendRequest(ConnectionSettings.Value, ResourceParameters, QueryParameters);
	
	If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
		JsonObj = CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody);
	Else
		Raise RequestResult.ResponseBody;
	EndIf;
	
	Return JsonObj;
EndFunction
	
Function SendPOSTRequest(IntegrationSettings, Action, Data) Export
	
	ConnectionSettings = IntegrationClientServer.ConnectionSetting(IntegrationSettings);
	ConnectionSettings.Value.QueryType = "POST";
	
	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;
	
	ResourceParameters = New Structure();
	ResourceParameters.Insert("action", Action);
	
	RequestBody = CommonFunctionsServer.SerializeJSON(Data);
	
	RequestResult = IntegrationClientServer.SendRequest(ConnectionSettings.Value, ResourceParameters,,RequestBody);
	
	If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
		Return RequestResult.ResponseBody;
	Else
		Raise RequestResult.ResponseBody;
	EndIf;
	
	Return Undefined;
EndFunction

#EndRegion




