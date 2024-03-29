#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
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

	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
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
	QueryArray.Add(Transactions());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1022B_VendorsPaymentPlanning());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function Transactions()
	Return "SELECT
		   |	Transactions.Ref.Date AS Period,
		   |	Transactions.Ref.Company AS Company,
		   |	Transactions.Partner,
		   |	Transactions.LegalName,
		   |	Transactions.Agreement,
		   |	CASE
		   |		WHEN Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN Transactions.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |
		   |	case when Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) Then
		   |	Transactions.Agreement else Undefined end AS AdvanceAgreement,
		   |
		   |	Transactions.Ref AS AdvancesOrTransactionDocument,
		   |	Transactions.Ref AS Ref,
		   |	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		   |	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		   |	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Other) AS IsOther,
		   |	Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) AS IsPostingDetail_ByDocuments,
		   |	Transactions.Currency,
		   |	Transactions.Key,
		   |	Transactions.Amount,
		   |	Transactions.Ref.Branch AS Branch,
		   |	Transactions.LegalNameContract AS LegalNameContract,
		   |	Transactions.ProfitLossCenter,
		   |	Transactions.AdditionalAnalytic,
		   |	Transactions.ExpenseType,
		   |	Transactions.Project
		   |INTO Transactions
		   |FROM
		   |	Document.CreditNote.Transactions AS Transactions
		   |WHERE
		   |	Transactions.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	Transactions";
EndFunction

Function R5022T_Expenses()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Transactions.Amount AS AmountWithTaxes,
		   |	*
		   |INTO R5022T_Expenses
		   |FROM
		   |	Transactions";
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_CreditNote();
EndFunction

Function R2021B_CustomersTransactions()
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_CreditNote();
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Transactions.Period AS Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Currency,
		   |	Transactions.LegalName,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	Transactions.Key,
		   |	Transactions.Amount
		   |INTO R5015B_OtherPartnersTransactions
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsOther";
EndFunction

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_CreditNote();
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_CreditNote();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_CreditNote();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_CreditNote();
EndFunction

Function R1022B_VendorsPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Ref AS Basis,
		   |	Transactions.LegalName AS LegalName,
		   |	Transactions.Partner AS Partner,
		   |	Transactions.Agreement AS Agreement,
		   |	SUM(Transactions.Amount) AS Amount
		   |INTO R1022B_VendorsPaymentPlanning
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsVendor
		   |	AND Transactions.IsPostingDetail_ByDocuments
		   |GROUP BY
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Ref,
		   |	Transactions.LegalName,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function T2014S_AdvancesInfo() 
	Return InformationRegisters.T2014S_AdvancesInfo.T2014S_AdvancesInfo_CreditNote();
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_CreditNote();
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
		|	Transactions.Period,
		|	Transactions.Key AS RowKey,
		|	Transactions.Key AS Key,
		|	Transactions.Currency,
		|	Transactions.Amount,
		|	VALUE(Catalog.AccountingOperations.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R5022T_Expenses) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.CreditNote_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
		|
		|UNION ALL
		|
		|SELECT
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Key,
		|	Transactions.Currency,
		|	Transactions.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.CreditNote_DR_R1021B_VendorsTransactions_CR_R5022T_Expenses),
		|	UNDEFINED
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	If Parameters.Operation = Catalogs.AccountingOperations.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R5022T_Expenses Then
		Return GetAnalytics_CustomerAdvancesExpenses(Parameters); // Customer advances - Expenses
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CreditNote_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_OffsetOfAdvancesCustomer(Parameters); // Customers transactions - Advances from customer 
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CreditNote_DR_R1021B_VendorsTransactions_CR_R5022T_Expenses Then
		Return GetAnalytics_VendorTransactionExpenses(Parameters); // Vendor transactions - Expenses
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Vendors advances - Revenues
Function GetAnalytics_CustomerAdvancesExpenses(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	                                                   
	AccountingAnalytics.Debit = Debit.AccountAdvancesCustomer;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, Parameters.RowData.ExpenseType);
	If ValueIsFilled(Credit.Account) Then
		AccountingAnalytics.Credit = Credit.Account;
	EndIf;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Customers transactions - Advances from customers
Function GetAnalytics_OffsetOfAdvancesCustomer(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.RowData.Currency);
	                                                      
	If ValueIsFilled(Accounts.AccountTransactionsCustomer) Then
		AccountingAnalytics.Debit = Accounts.AccountTransactionsCustomer;
	EndIf;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	If ValueIsFilled(Accounts.AccountAdvancesCustomer) Then
		AccountingAnalytics.Credit = Accounts.AccountAdvancesCustomer;
	EndIf;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Vendor transactions - Expenses
Function GetAnalytics_VendorTransactionExpenses(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	                                                   
	If ValueIsFilled(Debit.AccountTransactionsVendor) Then
		AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
	EndIf;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, Parameters.RowData.ExpenseType);
	If ValueIsFilled(Credit.Account) Then
		AccountingAnalytics.Credit = Credit.Account;
	EndIf;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion
