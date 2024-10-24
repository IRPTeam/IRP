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

	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2040B_TaxesIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

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
	StrParams.Insert("Vat", TaxesServer.GetVatRef());
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
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(R2040B_TaxesIncoming());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function Transactions()
	Return 
		"SELECT
		|	Transactions.Ref.Date AS Period,
		|	Transactions.Ref.Company AS Company,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Agreement,
		|	CASE
		|		WHEN Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN Transactions.BasisDocument.Ref IS NULL
		|					THEN Transactions.Ref
		|				ELSE Transactions.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	case
		|		when Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			Then Transactions.Agreement
		|		else Undefined
		|	end AS AdvanceAgreement,
		|	Transactions.Ref AS AdvancesOrTransactionDocument,
		|	Transactions.Ref AS Ref,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Other) AS IsOther,
		|	Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) AS IsPostingDetail_ByDocuments,
		|	Transactions.Currency,
		|	Transactions.Key,
		|	Transactions.Amount,
		|	Transactions.NetAmount,
		|	Transactions.TaxAmount,
		|	Transactions.VatRate,
		|	Transactions.Ref.Branch AS Branch,
		|	Transactions.LegalNameContract AS LegalNameContract,
		|	Transactions.ProfitLossCenter,
		|	Transactions.RevenueType,
		|	Transactions.AdditionalAnalytic,
		|	Transactions.Project
		|INTO Transactions
		|FROM
		|	Document.DebitNote.Transactions AS Transactions
		|WHERE
		|	Transactions.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	Transactions";
EndFunction

Function R5021T_Revenues()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Amount AS AmountWithTaxes,
		   |	Transactions.NetAmount AS Amount,
		   |	*
		   |INTO R5021T_Revenues
		   |FROM
		   |	Transactions";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_DebitNote();
EndFunction

Function R2021B_CustomersTransactions()
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_DebitNote();
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_DebitNote();
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Currency,
		   |	Transactions.LegalName,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	UNDEFINED AS Basis,
		   |	Transactions.Amount AS Amount,
		   |	Transactions.Key AS Key
		   |INTO R5015B_OtherPartnersTransactions
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsOther";
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_DebitNote();
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Ref AS Basis,
		   |	Transactions.LegalName,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	SUM(Transactions.Amount) AS Amount
		   |INTO R2022B_CustomersPaymentPlanning
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsCustomer
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

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_DebitNote();
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_DebitNote();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_DebitNote();
EndFunction

Function T2015S_TransactionsInfo() 
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_DebitNote();
EndFunction

Function R2040B_TaxesIncoming()	
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	&Vat AS Tax,
		|	Transactions.VatRate AS TaxRate,
		|	SUM(Transactions.TaxAmount) AS Amount,
		|	VALUE(Enum.InvoiceType.Invoice) AS InvoiceType
		|INTO R2040B_TaxesIncoming
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|	AND Transactions.TaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.VatRate,
		|	VALUE(Enum.InvoiceType.Invoice)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	&Vat AS Tax,
		|	Transactions.VatRate AS TaxRate,
		|	SUM(Transactions.TaxAmount),
		|	VALUE(Enum.InvoiceType.Return) AS InvoiceType
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|	AND Transactions.TaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Currency,
		|	Transactions.VatRate,
		|	VALUE(Enum.InvoiceType.Return)";
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
		|	Transactions.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|
		|UNION ALL
		|
		|SELECT
		|	Transactions.Period,
		|	Transactions.Key AS RowKey,
		|	Transactions.Key AS Key,
		|	Transactions.Currency,
		|	Transactions.TaxAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R1021B_VendorsTransactions_CR_R2040B_TaxesIncoming) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor
		|	AND Transactions.TaxAmount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		|
		|SELECT
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Key,
		|	Transactions.Currency,
		|	Transactions.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues),
		|	UNDEFINED
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		|	
		|SELECT
		|	Transactions.Period,
		|	Transactions.Key,
		|	Transactions.Key,
		|	Transactions.Currency,
		|	Transactions.TaxAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming),
		|	UNDEFINED
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		| AND Transactions.TaxAmount <> 0

		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions),
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
		|	VALUE(Catalog.AccountingOperations.DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues),
		|	UNDEFINED
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsOther";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R5021_Revenues Then
		Return GetAnalytics_VendorTransactionRevenues(Parameters); // Vendors transactions - Revenues
	ElsIf Parameters.Operation = AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors Then
		Return GetAnalytics_OffsetOfAdvancesVendor(Parameters); // Vendors transactions - Advances to vendors 
	ElsIf Parameters.Operation = AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R5021_Revenues Then
		Return GetAnalytics_CustomerTransactionRevenues(Parameters); // Customer transactions - Revenues
	ElsIf Parameters.Operation = AO.DebitNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions Then
		Return GetAnalytics_OffsetOfAdvancesCustomer(Parameters); // Advances from customers - Customers transactions
	ElsIf Parameters.Operation = AO.DebitNote_DR_R5015B_OtherPartnersTransactions_CR_R5021_Revenues Then
		Return GetAnalytics_OtherPartnerRevenues(Parameters); // OtherPartner - Revenues
	ElsIf Parameters.Operation = AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R2040B_TaxesIncoming Then
		Return GetAnalytics_VendorTransactionTaxIncoming(Parameters); // Vendors transactions - Tax incoming
	ElsIf Parameters.Operation = AO.DebitNote_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming Then
		Return GetAnalytics_CustomerTransactionTaxesIncoming(Parameters); // Vendors transactions - Tax incoming
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Vendors transaction - Revenues
Function GetAnalytics_VendorTransactionRevenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.RevenueType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Vendors advances - Tax incoming
Function GetAnalytics_VendorTransactionTaxIncoming(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	If Parameters.RowData.Agreement.Type = Enums.AgreementTypes.Vendor Then
		AccountingAnalytics.Credit = Credit.IncomingAccountReturn;
	Else
		AccountingAnalytics.Credit = Credit.IncomingAccount;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
		
	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors
Function GetAnalytics_OffsetOfAdvancesVendor(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Customer transactions - Revenues
Function GetAnalytics_CustomerTransactionRevenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.RevenueType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Customer transactions - Taxes incoming
Function GetAnalytics_CustomerTransactionTaxesIncoming(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	If Parameters.RowData.Agreement.Type = Enums.AgreementTypes.Customer Then
		AccountingAnalytics.Credit = Credit.IncomingAccount;
	Else
		AccountingAnalytics.Credit = Credit.IncomingAccountReturn;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	Return AccountingAnalytics;
EndFunction

// Advances from customers - Customers transactions
Function GetAnalytics_OffsetOfAdvancesCustomer(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.RowData.Currency);	                                                      

	// Debit
	AccountingAnalytics.Debit = Accounts.AccountAdvancesCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	AccountingAnalytics.Credit = Accounts.AccountTransactionsCustomer;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// OtherPartner - Revenues
Function GetAnalytics_OtherPartnerRevenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsOther;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.RevenueType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
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