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

	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1040B_TaxesOutgoing.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
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
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function PaymentList()
	Return "SELECT
		   |	PaymentList.Ref.Date AS Period,
		   |	PaymentList.Ref.Company AS Company,
		   |	PaymentList.Ref.Partner AS Partner,
		   |	PaymentList.Currency AS Currency,
		   |	PaymentList.ExpenseType AS ExpenseType,
		   |	PaymentList.NetAmount AS NetAmount,
		   |	PaymentList.TaxAmount AS TaxAmount,
		   |	PaymentList.TotalAmount AS TotalAmount,
		   |	PaymentList.VatRate AS VatRate,
		   |	PaymentList.Key,
		   |	PaymentList.ProfitLossCenter,
		   |	PaymentList.AdditionalAnalytic,
		   |	PaymentList.Ref.Branch AS Branch,
		   |	NOT PaymentList.Invoice.Ref IS NULL AS IsPurchase,
		   |	PaymentList.Invoice.Ref IS NULL AS IsExpense,
		   |	PaymentList.Invoice.Partner AS VendorPartner,
		   |	PaymentList.Invoice.Agreement AS VendorAgreement,
		   |	PaymentList.Invoice.LegalName AS VendorLegalName,
		   |	PaymentList.Invoice.LegalNameContract AS VendorLegalNameContract,
		   |	CASE
		   |		WHEN PaymentList.Invoice.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN PaymentList.Invoice
		   |		ELSE UNDEFINED
		   |	END AS TransactionDocument,
		   |	PaymentList.Project
		   |INTO PaymentList
		   |FROM
		   |	Document.EmployeeCashAdvance.PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R3027B_EmployeeCashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Key,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Currency,
		   |	PaymentList.TotalAmount AS Amount
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	TRUE";
EndFunction

Function R5022T_Expenses()
	Return "SELECT
		   |	PaymentList.NetAmount AS Amount,
		   |	PaymentList.TotalAmount AS AmountWithTaxes,
		   |	*
		   |INTO R5022T_Expenses
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsExpense";
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_ECA();
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.VendorLegalName AS LegalName,
		   |	PaymentList.VendorLegalNameContract AS LegalNameContract,
		   |	PaymentList.TotalAmount AS Amount
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPurchase";
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_ECA();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_Offset();
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_ECA();
EndFunction

Function R1040B_TaxesOutgoing()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	&Vat AS Tax,
		|	PaymentList.VatRate AS TaxRate,
		|	VALUE(Enum.InvoiceType.Invoice) AS InvoiceType,
		|	SUM(PaymentList.TaxAmount) AS Amount
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsExpense
		|	AND PaymentList.TaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.VatRate,
		|	VALUE(Enum.InvoiceType.Invoice)";
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
	|	PaymentList.Period,
	|	PaymentList.Key AS RowKey,
	|	PaymentList.Key AS Key,
	|	PaymentList.Currency,
	|	PaymentList.TotalAmount AS Amount,
	|	VALUE(Catalog.AccountingOperations.EmployeeCashAdvance_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance) AS
	|		Operation,
	|	UNDEFINED AS AdvancesClosing
	|INTO T1040T_AccountingAmounts
	|FROM
	|	PaymentList AS PaymentList
	|WHERE
	|	PaymentList.IsPurchase
	|
	|UNION ALL
	|
	|SELECT
	|	PaymentList.Period,
	|	PaymentList.Key AS RowKey,
	|	PaymentList.Key AS Key,
	|	PaymentList.Currency,
	|	PaymentList.NetAmount,
	|	VALUE(Catalog.AccountingOperations.EmployeeCashAdvance_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance) AS
	|		Operation,
	|	UNDEFINED AS AdvancesClosing
	|FROM
	|	PaymentList AS PaymentList
	|WHERE
	|	PaymentList.IsExpense
	|
	|UNION ALL
	|
	|SELECT
	|	PaymentList.Period,
	|	PaymentList.Key AS RowKey,
	|	PaymentList.Key AS Key,
	|	PaymentList.Currency,
	|	PaymentList.TaxAmount,
	|	VALUE(Catalog.AccountingOperations.EmployeeCashAdvance_DR_R1040B_TaxesOutgoing_CR_R3027B_EmployeeCashAdvance) AS
	|		Operation,
	|	UNDEFINED AS AdvancesClosing
	|FROM
	|	PaymentList AS PaymentList
	|WHERE
	|	PaymentList.IsExpense And PaymentList.TaxAmount <> 0";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.EmployeeCashAdvance_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance Then
		Return GetAnalytics_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance(Parameters); // Vendor transactions - Employee cash advance
	ElsIf Parameters.Operation = AO.EmployeeCashAdvance_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance(Parameters); // Expenses - Employee cash advance
	ElsIf Parameters.Operation = AO.EmployeeCashAdvance_DR_R1040B_TaxesOutgoing_CR_R3027B_EmployeeCashAdvance Then
		Return GetAnalytics_DR_R1040B_TaxesOutgoing_CR_R3027B_EmployeeCashAdvance(Parameters); // Taxes outgoing - Employee cash advance
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Vendor transactions - Employee cash advance
Function GetAnalytics_DR_R1021B_VendorsTransactions_CR_R3027B_EmployeeCashAdvance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
										      		   Parameters.RowData.Invoice.Partner, 
										      		   Parameters.RowData.Invoice.Agreement, 
										      		   Parameters.RowData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.RowData.Invoice.Partner);
	AdditionalAnalytics.Insert("Agreement", Parameters.RowData.Invoice.Agreement);
	AdditionalAnalytics.Insert("LegalName", Parameters.RowData.Invoice.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.RowData.Invoice.LegalNameContract);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
		
	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.ObjectData.Partner);                                                  
	AccountingAnalytics.Credit = Credit.AccountCashAdvance;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Employee cash advance
Function GetAnalytics_DR_R1040B_TaxesOutgoing_CR_R3027B_EmployeeCashAdvance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	AccountingAnalytics.Debit = Debit.OutgoingAccount;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.ObjectData.Partner);                                                  
	AccountingAnalytics.Credit = Credit.AccountCashAdvance;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Tax outgoing - Employee cash advance
Function GetAnalytics_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
														  Parameters.RowData.ExpenseType,
														  Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.ObjectData.Partner);                                                  
	AccountingAnalytics.Credit = Credit.AccountCashAdvance;
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
