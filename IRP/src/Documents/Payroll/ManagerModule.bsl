#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R9510B_SalaryPayment.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(AccrualList());
	QueryArray.Add(DeductionList());
	QueryArray.Add(CashAdvanceDeductionList());
	QueryArray.Add(SalaryTaxList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(R9545T_PaidVacations());
	QueryArray.Add(R9555T_PaidSickLeaves());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function AccrualList()
	Return 
		"SELECT
		|	AccrualList.Key,
		|	AccrualList.Ref.Date AS Period,
		|	AccrualList.Ref.Company AS Company,
		|	AccrualList.Ref.Branch AS Branch,
		|	AccrualList.Ref.Currency AS Currency,
		|	AccrualList.Ref.PaymentPeriod AS PaymentPeriod,
		|	AccrualList.Ref.CalculationType AS CalculationType,
		|	AccrualList.Employee,
		|	AccrualList.ExpenseType,
		|	AccrualList.ProfitLossCenter,
		|	AccrualList.Amount,
		|	AccrualList.PaidVacationDays,
		|	AccrualList.PaidSickLeaveDays
		|INTO AccrualList
		|FROM
		|	Document.Payroll.AccrualList AS AccrualList
		|WHERE
		|	AccrualList.Ref = &Ref";
EndFunction

Function DeductionList()
	Return "SELECT
		   |	DeductionList.Key,
		   |	DeductionList.Ref.Date AS Period,
		   |	DeductionList.Ref.Company AS Company,
		   |	DeductionList.Ref.Branch AS Branch,
		   |	DeductionList.Ref.Currency AS Currency,
		   |	DeductionList.Ref.PaymentPeriod AS PaymentPeriod,
		   |	DeductionList.Ref.CalculationType AS CalculationType,
		   |	DeductionList.Employee,
		   |	DeductionList.ExpenseType,
		   |	DeductionList.ProfitLossCenter,
		   |	DeductionList.IsRevenue,
		   |	DeductionList.Amount
		   |INTO DeductionList
		   |FROM
		   |	Document.Payroll.DeductionList AS DeductionList
		   |WHERE
		   |	DeductionList.Ref = &Ref";
EndFunction

Function CashAdvanceDeductionList()
	Return "SELECT
		   |	CashAdvanceDeductionList.Key,
		   |	CashAdvanceDeductionList.Ref.Date AS Period,
		   |	CashAdvanceDeductionList.Ref.Company AS Company,
		   |	CashAdvanceDeductionList.Ref.Branch AS Branch,
		   |	CashAdvanceDeductionList.Ref.Currency AS Currency,
		   |	CashAdvanceDeductionList.Ref.PaymentPeriod AS PaymentPeriod,
		   |	CashAdvanceDeductionList.Ref.CalculationType AS CalculationType,
		   |	CashAdvanceDeductionList.Employee,
		   |	CashAdvanceDeductionList.Agreement,
		   |	CashAdvanceDeductionList.Amount
		   |INTO CashAdvanceDeductionList
		   |FROM
		   |	Document.Payroll.CashAdvanceDeductionList AS CashAdvanceDeductionList
		   |WHERE
		   |	CashAdvanceDeductionList.Ref = &Ref";
EndFunction

Function SalaryTaxList()
	Return
		"SELECT
		|	PayrollSalaryTaxList.Ref.Date AS Period,
		|	PayrollSalaryTaxList.Key AS Key,
		|	PayrollSalaryTaxList.Ref.Company AS Company,
		|	PayrollSalaryTaxList.Ref.Branch AS Branch,
		|	PayrollSalaryTaxList.Ref.Currency AS Currency,
		|	PayrollSalaryTaxList.Ref.Partner AS Partner,
		|	PayrollSalaryTaxList.Ref.LegalName AS LegalName,
		|	PayrollSalaryTaxList.Ref.Agreement AS Agreement,
		|	PayrollSalaryTaxList.Ref.PaymentPeriod AS PaymentPeriod,
		|	PayrollSalaryTaxList.Ref.CalculationType AS CalculationType,
		|	PayrollSalaryTaxList.Employee AS Employee,
		|	PayrollSalaryTaxList.ExpenseType AS ExpenseType,
		|	PayrollSalaryTaxList.ProfitLossCenter AS ProfitLossCenter,
		|	PayrollSalaryTaxList.Amount AS Amount,
		|	PayrollSalaryTaxList.Tax.TaxPayer = VALUE(Enum.TaxPayers.Employee) AS IsEmployeePayer,
		|	PayrollSalaryTaxList.Tax.TaxPayer = VALUE(Enum.TaxPayers.Company) AS IsCompanyPayer,
		|	PayrollSalaryTaxList.Tax
		|INTO SalaryTaxList
		|FROM
		|	Document.Payroll.SalaryTaxList AS PayrollSalaryTaxList
		|WHERE
		|	PayrollSalaryTaxList.Ref = &Ref"	
EndFunction

#EndRegion

#Region Posting_MainTables

Function R5022T_Expenses()
	Return 
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Key,
		|	AccrualList.Company,
		|	AccrualList.Branch,
		|	AccrualList.Currency,
		|	AccrualList.ExpenseType,
		|	AccrualList.ProfitLossCenter,
		|	AccrualList.Amount AS Amount
		|INTO R5022T_Expenses
		|FROM
		|	AccrualList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Company,
		|	DeductionList.Branch,
		|	DeductionList.Currency,
		|	DeductionList.ExpenseType,
		|	DeductionList.ProfitLossCenter,
		|	-DeductionList.Amount AS Amount
		|FROM
		|	DeductionList
		|WHERE
		|	NOT DeductionList.IsRevenue
		|
		|UNION ALL
		|
		|SELECT
		|	SalaryTaxList.Period,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Company,
		|	SalaryTaxList.Branch,
		|	SalaryTaxList.Currency,
		|	SalaryTaxList.ExpenseType,
		|	SalaryTaxList.ProfitLossCenter,
		|	SalaryTaxList.Amount
		|FROM
		|	SalaryTaxList
		|WHERE
		|	SalaryTaxList.IsCompanyPayer";
EndFunction

Function R5021T_Revenues()
	Return 
		"SELECT
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Company,
		|	DeductionList.Branch,
		|	DeductionList.Currency,
		|	DeductionList.ExpenseType AS RevenueType,
		|	DeductionList.ProfitLossCenter,
		|	DeductionList.Amount AS Amount
		|INTO R5021T_Revenues
		|FROM
		|	DeductionList
		|WHERE
		|	DeductionList.IsRevenue";
EndFunction

Function R9510B_SalaryPayment()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	AccrualList.Period,
		|	AccrualList.Key,
		|	AccrualList.Company,
		|	AccrualList.Branch,
		|	AccrualList.Currency,
		|	AccrualList.PaymentPeriod,
		|	AccrualList.CalculationType,
		|	AccrualList.Employee,
		|	AccrualList.Amount
		|INTO R9510B_SalaryPayment
		|FROM
		|	AccrualList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Company,
		|	DeductionList.Branch,
		|	DeductionList.Currency,
		|	DeductionList.PaymentPeriod,
		|	DeductionList.CalculationType,
		|	DeductionList.Employee,
		|	DeductionList.Amount
		|FROM
		|	DeductionList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	CashAdvanceDeductionList.Period,
		|	CashAdvanceDeductionList.Key,
		|	CashAdvanceDeductionList.Company,
		|	CashAdvanceDeductionList.Branch,
		|	CashAdvanceDeductionList.Currency,
		|	CashAdvanceDeductionList.PaymentPeriod,
		|	CashAdvanceDeductionList.CalculationType,
		|	CashAdvanceDeductionList.Employee,
		|	CashAdvanceDeductionList.Amount
		|FROM
		|	CashAdvanceDeductionList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	SalaryTaxList.Period,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Company,
		|	SalaryTaxList.Branch,
		|	SalaryTaxList.Currency,
		|	SalaryTaxList.PaymentPeriod,
		|	SalaryTaxList.CalculationType,
		|	SalaryTaxList.Employee,
		|	SalaryTaxList.Amount
		|FROM
		|	SalaryTaxList
		|WHERE
		|	SalaryTaxList.IsEmployeePayer";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	CashAdvanceDeductionList.Period,
		|	CashAdvanceDeductionList.Key,
		|	CashAdvanceDeductionList.Company,
		|	CashAdvanceDeductionList.Branch,
		|	CashAdvanceDeductionList.Currency,
		|	CashAdvanceDeductionList.Employee AS Partner,
		|	CashAdvanceDeductionList.Agreement,
		|	CashAdvanceDeductionList.Amount
		|INTO R3027B_EmployeeCashAdvance
		|FROM
		|	CashAdvanceDeductionList
		|WHERE
		|	TRUE";
EndFunction

Function R9545T_PaidVacations()
	Return
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Company,
		|	AccrualList.Employee,
		|	AccrualList.PaidVacationDays AS Paid
		|INTO R9545T_PaidVacations
		|FROM
		|	AccrualList AS AccrualList
		|WHERE
		|	AccrualList.PaidVacationDays <> 0";
EndFunction

Function R9555T_PaidSickLeaves()
	Return
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Company,
		|	AccrualList.Employee,
		|	AccrualList.PaidSickLeaveDays AS Paid
		|INTO R9555T_PaidSickLeaves
		|FROM
		|	AccrualList AS AccrualList
		|WHERE
		|	AccrualList.PaidSickLeaveDays <> 0";	
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	SalaryTaxList.Period,
		|	SalaryTaxList.Company,
		|	SalaryTaxList.Branch,
		|	SalaryTaxList.Partner,
		|	SalaryTaxList.LegalName,
		|	SalaryTaxList.Currency,
		|	SalaryTaxList.Agreement,
		|	UNDEFINED AS Basis,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Amount AS Amount
		|INTO R5015B_OtherPartnersTransactions
		|FROM
		|	SalaryTaxList AS SalaryTaxList
		|WHERE
		|	TRUE";
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_Payroll();
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Key AS RowKey,
		|	AccrualList.Key AS Key,
		|	AccrualList.Currency,
		|	AccrualList.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	AccrualList AS AccrualList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	SalaryTaxList.Period,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Currency,
		|	SalaryTaxList.Amount,
		|	VALUE(Catalog.AccountingOperations.Payroll_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes),
		|	UNDEFINED
		|FROM
		|	SalaryTaxList AS SalaryTaxList
		|WHERE
		|	SalaryTaxList.IsEmployeePayer
		|
		|UNION ALL
		|
		|SELECT
		|	SalaryTaxList.Period,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Key,
		|	SalaryTaxList.Currency,
		|	SalaryTaxList.Amount,
		|	VALUE(Catalog.AccountingOperations.Payroll_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes),
		|	UNDEFINED
		|FROM
		|	SalaryTaxList AS SalaryTaxList
		|WHERE
		|	SalaryTaxList.IsCompanyPayer
		|
		|UNION ALL
		|
		|SELECT
		|	CashAdvanceDeductionList.Period,
		|	CashAdvanceDeductionList.Key,
		|	CashAdvanceDeductionList.Key,
		|	CashAdvanceDeductionList.Currency,
		|	CashAdvanceDeductionList.Amount,
		|	VALUE(Catalog.AccountingOperations.Payroll_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance),
		|	UNDEFINED
		|FROM
		|	CashAdvanceDeductionList AS CashAdvanceDeductionList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Key,
		|	DeductionList.Currency,
		|	DeductionList.Amount,
		|	VALUE(Catalog.AccountingOperations.Payroll_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue),
		|	UNDEFINED
		|FROM
		|	DeductionList AS DeductionList
		|WHERE
		|	DeductionList.IsRevenue
		|
		|UNION ALL
		|
		|SELECT
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Key,
		|	DeductionList.Currency,
		|	-DeductionList.Amount,
		|	VALUE(Catalog.AccountingOperations.Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue),
		|	UNDEFINED
		|FROM
		|	DeductionList AS DeductionList
		|WHERE
		|	NOT DeductionList.IsRevenue";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	
	If Parameters.Operation = Operations.Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual Then
		
		Return GetAnalytics_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual(Parameters); // Expenses - Salary payment
	
	ElsIf Parameters.Operation = Operations.Payroll_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes Then 
		
		Return GetAnalytics_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes(Parameters); // Salary payment - Other partner transactions
	
	ElsIf Parameters.Operation = Operations.Payroll_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes Then
		
		Return GetAnalytics_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes(Parameters); // Expenses - Other partner transaction
	
	ElsIf Parameters.Operation = Operations.Payroll_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance Then
		
		Return GetAnalytics_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance(Parameters); // Salary payment - Employee cash advance
		
	ElsIf Parameters.Operation = Operations.Payroll_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue Then
		
		Return GetAnalytics_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue(Parameters); // Salary payment - Revenues
		
	ElsIf Parameters.Operation = Operations.Payroll_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue Then
		
		Return GetAnalytics_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue(Parameters); // Expenses - Salary payment (minus)
		
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Expenses - Salary payment (accrual)*
Function GetAnalytics_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Accrual(Parameters)
	
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.ExpenseType,
	                                                          Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee);
	AccountingAnalytics.Credit = Credit.AccountSalaryPayment;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	Return AccountingAnalytics;
EndFunction

// Salary payment - Other partner transactions (taxes)*
Function GetAnalytics_DR_R9510B_SalaryPayment_CR_R5015B_OtherPartnersTransactions_Taxes(Parameters)
	
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
		
	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee);
	AccountingAnalytics.Debit = Debit.AccountSalaryPayment;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.ObjectData.Partner,
	                                                    Parameters.ObjectData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	AdditonalAnalytics = New Structure();
	AdditonalAnalytics.Insert("Partner"   ,Parameters.ObjectData.Partner);
	AdditonalAnalytics.Insert("Agreement" ,Parameters.ObjectData.Agreement);
	
	AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditonalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Expenes - Other partner transactions (taxes)*
Function GetAnalytics_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions_Taxes(Parameters)
	
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
		
	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.ExpenseType,
	                                                          Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.ObjectData.Partner,
	                                                    Parameters.ObjectData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	AdditonalAnalytics = New Structure();
	AdditonalAnalytics.Insert("Partner"   ,Parameters.ObjectData.Partner);
	AdditonalAnalytics.Insert("Agreement" ,Parameters.ObjectData.Agreement);
	
	AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditonalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Salary payment - Employee cash advance (cash advance)*
Function GetAnalytics_DR_R9510B_SalaryPayment_CR_R3027B_EmployeeCashAdvance(Parameters)
	
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee); 
	AccountingAnalytics.Debit = Debit.AccountSalaryPayment;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee);
	AccountingAnalytics.Credit = Credit.AccountCashAdvance;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Salary payment - Revenues (deduction)*
Function GetAnalytics_DR_R9510B_SalaryPayment_CR_R5021T_Revenues_Deduction_IsRevenue(Parameters)
	
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee);
	AccountingAnalytics.Debit = Debit.AccountSalaryPayment;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.ExpenseType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Salary payment (deduction minus)* 
Function GetAnalytics_DR_R5022T_Expenses_CR_R9510B_SalaryPayment_Deduction_IsNotRevenue(Parameters)
	
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.ExpenseType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee);
	AccountingAnalytics.Credit = Credit.AccountSalaryPayment;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion