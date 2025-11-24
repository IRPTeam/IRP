#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	Parameters.IsReposting = False;
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
	
	Tables.R1040B_TaxesOutgoing.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
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
	IncomingStocksServer.ClosureIncomingStocks_Unposting(Parameters);
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
	StrParams.Insert("Vat", TaxesServer.GetVatRef());
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	StrParams.Insert("AmountDigitCapacity", Metadata.DefinedTypes.typeAmount.Type.NumberQualifiers.FractionDigits);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(R5020B_PartnersBalance());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function ItemList()
	Return 
		"SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Ref AS Ref,
		|	ItemList.Quantity AS UnitQuantity,
		|	ItemList.Price AS Price,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.TotalAmount AS Amount,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN ItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN ItemList.Ref.Agreement.StandardAgreement
		|		ELSE ItemList.Ref.Agreement
		|	END AS Agreement,
		|	ISNULL(ItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	ItemList.Unit AS Unit,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.Ref.Date AS Period,
		|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	ItemList.ProfitLossCenter AS ProfitLossCenter,
		|	ItemList.ExpenseType AS ExpenseType,
		|	ItemList.IsService AS IsService,
		|	ItemList.NetAmount AS NetAmount,
		|	ItemList.TaxAmount AS TaxAmount,
		|	ItemList.Key AS Key,
		|	ItemList.Key AS RowKey,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.Ref.Branch AS Branch,
		|	ItemList.Ref.LegalNameContract AS LegalNameContract,
		|	ItemList.VatRate AS VatRate,
		|	ItemList.Project AS Project,
		|	ItemList.Invoice AS Invoice,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Consignor) AS IsConsignor,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Other) AS IsOther
		|INTO ItemList
		|FROM
		|	Document.IncomingExchRateAdjustmentInvoice.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R1040B_TaxesOutgoing()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Key AS Key,
		|	&Vat AS Tax,
		|	ItemList.VatRate AS TaxRate,
		|	VALUE(Enum.InvoiceType.Invoice) AS InvoiceType,
		|	SUM(ItemList.TaxAmount) AS Amount
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	ItemList AS ItemLIst
		|WHERE
		|	ItemList.TaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.Key,
		|	ItemList.VatRate,
		|	VALUE(Enum.InvoiceType.Invoice)";
EndFunction

Function R5022T_Expenses()
	Return 
		"SELECT
		|	*,
		|	ItemList.NetAmount AS Amount,
		|	ItemList.Amount AS AmountWithTaxes,
		|	ItemList.Key AS Key
		|INTO R5022T_Expenses
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R1021B_VendorsTransactions()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.Invoice AS Basis,
		|	undefined AS Order,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS VendorsAdvancesClosing,
		|	ItemList.Key AS Key
		|INTO R1021B_VendorsTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsVendor
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Invoice,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Project,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Key";
EndFunction

Function R5020B_PartnersBalance()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Invoice AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	SUM(ItemList.Amount) AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	ItemList.Key AS Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsVendor
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Invoice,
		|	ItemList.Currency,
		|	ItemList.Key";
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
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Key AS Key,
		|	ItemList.Currency,
		|	ItemList.Ref.Agreement.CurrencyMovementType.Currency AS CrCurrency,
		|	ItemList.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.IncomingExchRateAdjustmentInvoice_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions) AS
		|		Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Key AS Key,
		|	ItemList.Currency,
		|	ItemList.Ref.Agreement.CurrencyMovementType.Currency AS CrCurrency,
		|	ItemList.TaxAmount,
		|	VALUE(Catalog.AccountingOperations.IncomingExchRateAdjustmentInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.TaxAmount <> 0";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.IncomingExchRateAdjustmentInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions Then
		
		Return GetAnalytics_TaxOutgoing_VendorTrnsactions(Parameters); // Tax outgoing - Vendors transactions
		
	ElsIf Parameters.Operation = Operations.IncomingExchRateAdjustmentInvoice_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions Then
		
		Return GetAnalytics_Expeenses_VendorTransactions(Parameters); // Expenses - Vendors transactions
	
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Expenses - Vendors transactions
Function GetAnalytics_Expeenses_VendorTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.ExpenseType,
	                                                          Parameters.RowData.ProfitLossCenter);
	
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Item", Parameters.RowData.ItemKey.Item);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.ObjectData.Partner,
	                                                    Parameters.ObjectData.Agreement,
	                                                    Parameters.ObjectData.Currency);                                          
	AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Partner"          , Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement"        , Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName"        , Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Taxes outgoing - Vendors transactions
Function GetAnalytics_TaxOutgoing_VendorTrnsactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
		
	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	AccountingAnalytics.Debit = Debit.OutgoingAccount;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.ObjectData.Partner,
	                                                    Parameters.ObjectData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Partner"          , Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement"        , Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName"        , Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

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