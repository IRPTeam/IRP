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
	Parameters.IsReposting = False;
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
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
	Str.Insert("QueryTextsMasterTables", New Array);
	Str.Insert("QueryTextsSecondaryTables", New Array);
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	StrParams.Insert("Vat", TaxesServer.GetVatRef());
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(TaxesDifference());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(R5020B_PartnersBalance());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function TaxesDifference()
	Return
		"SELECT
		|	TaxesDifference.Ref.Date AS Period,
		|	TaxesDifference.Key AS Key,
		|	TaxesDifference.Ref.Company AS Company,
		|	TaxesDifference.Ref.Branch AS Branch,
		|	&Vat AS Tax,
		|	TaxesDifference.Ref.Currency AS Currency,
		|	TaxesDifference.IncomingVatRate,
		|	TaxesDifference.IncomingInvoiceType,
		|	TaxesDifference.OutgoingVatRate,
		|	TaxesDifference.OutgoingInvoiceType,
		|	TaxesDifference.Ref.Partner AS Partner,
		|	TaxesDifference.Ref.LegalName AS LegalName,
		|	TaxesDifference.Ref.LegalNameContract AS LegalNameContract,
		|	TaxesDifference.Ref.Agreement AS Agreement,
		|	CASE
		|		WHEN TaxesDifference.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN TaxesDifference.Ref
		|		ELSE UNDEFINED
		|	END AS Basis,
		|	TaxesDifference.Amount AS Amount,
		|	TaxesDifference.Ref.TransactionType = VALUE(Enum.TaxesOperationTransactionType.TaxOffset) AS IsTaxOffset,
		|	TaxesDifference.Ref.TransactionType = VALUE(Enum.TaxesOperationTransactionType.TaxOffsetAndPayment) AS IsTaxOffsetAndPayment,
		|	TaxesDifference.Ref.TransactionType = VALUE(Enum.TaxesOperationTransactionType.TaxPayment) AS IsTaxPayment
		|INTO TaxesDifference
		|FROM
		|	Document.TaxesOperation.TaxesDifference AS TaxesDifference
		|WHERE
		|	TaxesDifference.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R1040B_TaxesOutgoing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Tax,
		|	TaxesDifference.Currency,
		|	TaxesDifference.OutgoingVatRate AS TaxRate,
		|	TaxesDifference.OutgoingInvoiceType AS InvoiceType,
		|	SUM(TaxesDifference.Amount) AS Amount
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	TaxesDifference as TaxesDifference
		|WHERE
		|	NOT TaxesDifference.OutgoingVatRate.Ref IS NULL
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Tax,
		|	TaxesDifference.Currency,
		|	TaxesDifference.OutgoingVatRate,
		|	TaxesDifference.OutgoingInvoiceType";
EndFunction 

Function R2040B_TaxesIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Tax,
		|	TaxesDifference.Currency,
		|	TaxesDifference.IncomingVatRate AS TaxRate,
		|	TaxesDifference.IncomingInvoiceType AS InvoiceType,
		|	SUM(TaxesDifference.Amount) AS Amount
		|INTO R2040B_TaxesIncoming
		|FROM
		|	TaxesDifference as TaxesDifference
		|WHERE
		|	NOT TaxesDifference.IncomingVatRate.Ref IS NULL
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Tax,
		|	TaxesDifference.Currency,
		|	TaxesDifference.IncomingVatRate,
		|	TaxesDifference.IncomingInvoiceType";
EndFunction 

Function R5015B_OtherPartnersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Currency,
		|	TaxesDifference.LegalName,
		|	TaxesDifference.Partner,
		|	TaxesDifference.Agreement,
		|	TaxesDifference.Basis,
		|	TaxesDifference.Amount AS Amount
		|INTO R5015B_OtherPartnersTransactions
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	NOT TaxesDifference.IncomingVatRate.Ref IS NULL
		|	AND TaxesDifference.OutgoingVatRate.Ref IS NULL
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Currency,
		|	TaxesDifference.LegalName,
		|	TaxesDifference.Partner,
		|	TaxesDifference.Agreement,
		|	TaxesDifference.Basis,
		|	TaxesDifference.Amount AS Amount
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	NOT TaxesDifference.OutgoingVatRate.Ref IS NULL
		|	AND TaxesDifference.IncomingVatRate.Ref IS NULL";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Currency,
		|	TaxesDifference.LegalName,
		|	TaxesDifference.LegalNameContract,
		|	TaxesDifference.Amount AS Amount
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	NOT TaxesDifference.IncomingVatRate.Ref IS NULL
		|	AND TaxesDifference.OutgoingVatRate.Ref IS NULL
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Currency,
		|	TaxesDifference.LegalName,
		|	TaxesDifference.LegalNameContract,
		|	TaxesDifference.Amount AS Amount
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	NOT TaxesDifference.OutgoingVatRate.Ref IS NULL
		|	AND TaxesDifference.IncomingVatRate.Ref IS NULL";
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_TaxesOperation();
EndFunction

#EndRegion

#Region AccessObject


// Get access key.
// 
// Parameters:
//  Obj - DocumentRef.ExpenseAccruals
// 
// Returns:
//  Map - Map:
//  *Company - CatalogRef.Companies
//	*Branch - CatalogRef.BusinessUnits
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	//@skip-check property-return-type
	//@skip-check invocation-parameter-type-intersect
	//@skip-check unknown-method-property
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	TaxesDifference.Period,
		|	TaxesDifference.Key AS RowKey,
		|	TaxesDifference.Currency,
		|	TaxesDifference.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R1040B_TaxesOutgoing) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	NOT TaxesDifference.IncomingVatRate.Ref IS NULL
		|	AND NOT TaxesDifference.OutgoingVatRate.Ref IS NULL
		|	AND TaxesDifference.Amount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	TaxesDifference.Period,
		|	TaxesDifference.Key AS RowKey,
		|	TaxesDifference.Currency,
		|	TaxesDifference.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R5015B_OtherPartnersTransactions) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	NOT TaxesDifference.IncomingVatRate.Ref IS NULL
		|	AND TaxesDifference.OutgoingVatRate.Ref IS NULL
		|	AND TaxesDifference.Amount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	TaxesDifference.Period,
		|	TaxesDifference.Key AS RowKey,
		|	TaxesDifference.Currency,
		|	TaxesDifference.Amount Amount,
		|	VALUE(Catalog.AccountingOperations.TaxesOperation_DR_R5015B_OtherPartnersTransactions_CR_R1040B_TaxesOutgoing) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	TaxesDifference.IncomingVatRate.Ref IS NULL
		|	AND NOT TaxesDifference.OutgoingVatRate.Ref IS NULL
		|	AND TaxesDifference.Amount <> 0";

EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R1040B_TaxesOutgoing Then
		Return GetAnalytics_DR_R2040B_TaxesIncoming_CR_R1040B_TaxesOutgoing(Parameters);
	ElsIf Parameters.Operation = AO.TaxesOperation_DR_R2040B_TaxesIncoming_CR_R5015B_OtherPartnersTransactions Then
		Return GetAnalytics_DR_R2040B_TaxesIncoming_CR_R5015B_OtherPartnersTransactions(Parameters);
	ElsIf Parameters.Operation = AO.TaxesOperation_DR_R5015B_OtherPartnersTransactions_CR_R1040B_TaxesOutgoing Then
		Return GetAnalytics_DR_R5015B_OtherPartnersTransactions_CR_R1040B_TaxesOutgoing(Parameters);
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetAnalytics_DR_R2040B_TaxesIncoming_CR_R1040B_TaxesOutgoing(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	TaxVat = TaxesServer.GetVatRef();
	
	IncomingTaxInfo = New Structure();
	IncomingTaxInfo.Insert("Tax", TaxVat);
	IncomingTaxInfo.Insert("VatRate", Parameters.RowData.IncomingVatRate);
	
	OutgoingTaxInfo = New Structure();
	OutgoingTaxInfo.Insert("Tax", TaxVat);
	OutgoingTaxInfo.Insert("VatRate", Parameters.RowData.OutgoingVatRate);

	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, IncomingTaxInfo);
	If Parameters.RowData.IncomingInvoiceType = Enums.InvoiceType.Invoice Then
		AccountingAnalytics.Debit = Debit.IncomingAccount;
	Else
		AccountingAnalytics.Debit = Debit.IncomingAccountReturn;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, IncomingTaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, OutgoingTaxInfo);
	If Parameters.RowData.OutgoingInvoiceType = Enums.InvoiceType.Invoice Then
		AccountingAnalytics.Credit = Credit.OutgoingAccount;
	Else
		AccountingAnalytics.Credit = Credit.OutgoingAccountReturn;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, OutgoingTaxInfo);
	
	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R2040B_TaxesIncoming_CR_R5015B_OtherPartnersTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	TaxVat = TaxesServer.GetVatRef();
	
	IncomingTaxInfo = New Structure();
	IncomingTaxInfo.Insert("Tax", TaxVat);
	IncomingTaxInfo.Insert("VatRate", Parameters.RowData.IncomingVatRate);
	
	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, IncomingTaxInfo);
	If Parameters.RowData.IncomingInvoiceType = Enums.InvoiceType.Invoice Then
		AccountingAnalytics.Debit = Debit.IncomingAccount;
	Else
		AccountingAnalytics.Debit = Debit.IncomingAccountReturn;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, IncomingTaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
	AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5015B_OtherPartnersTransactions_CR_R1040B_TaxesOutgoing(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	TaxVat = TaxesServer.GetVatRef();
	
	OutgoingTaxInfo = New Structure();
	OutgoingTaxInfo.Insert("Tax", TaxVat);
	OutgoingTaxInfo.Insert("VatRate", Parameters.RowData.OutgoingVatRate);
	
	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
	AccountingAnalytics.Debit = Debit.AccountTransactionsOther;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, OutgoingTaxInfo);
	If Parameters.RowData.OutgoingInvoiceType = Enums.InvoiceType.Invoice Then
		AccountingAnalytics.Credit = Credit.OutgoingAccount;
	Else
		AccountingAnalytics.Credit = Credit.OutgoingAccountReturn;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, OutgoingTaxInfo);
	
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
