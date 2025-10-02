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
	
	Tables.R1001T_Purchases.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1040B_TaxesOutgoing.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
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
	StrParams.Insert("WithholdingTax", TaxesServer.GetWithholdingTaxRef());
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1001T_Purchases());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1040B_TaxesOutgoing());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function ItemList()
	Return 
		"SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Ref AS Invoice,
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
		|	CASE
		|		WHEN ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN ItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	UNDEFINED AS PurchaseOrderSettlements,
		|	TRUE AS IsPurchase,
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
		|	ItemList.WithholdingTaxAmount AS WithholdingTaxAmount,
		|	ItemList.Key AS Key,
		|	ItemList.Key AS RowKey,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.Ref.Branch AS Branch,
		|	ItemList.Ref.LegalNameContract AS LegalNameContract,
		|	ItemList.VatRate AS VatRate,
		|	ItemList.WithholdingTaxRate AS WithholdingTaxRate,
		|	ItemList.Project AS Project,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Consignor) AS IsConsignor,
		|	ItemList.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Other) AS IsOther,
		|	ItemList.Ref.TaxPartner as TaxPartner,
		|	ItemList.Ref.TaxLegalName as TaxLegalName,
		|	ItemList.Ref.TaxAgreement as TaxAgreement,
		|	ItemList.Ref.TaxLegalNameContract as TaxLegalNameContract,
		|	ItemList.Ref.PartnerUUID AS PartnerUUID,
		|	ItemList.Ref.TaxUUID AS TaxUUID
		|INTO ItemList
		|FROM
		|	Document.WithholdingTaxInvoice.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R1001T_Purchases()
	Return "SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.PartnerUUID AS Key,
		|	ItemList.Invoice,
		|	ItemList.ItemKey,
		|	ItemList.RowKey,
		|	ItemList.Quantity,
		|	ItemList.Amount,
		|	ItemList.NetAmount,
		|	Undefined AS SerialLotNumber,
		|	0 AS OffersAmount
		|INTO R1001T_Purchases
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R1040B_TaxesOutgoing()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.PartnerUUID AS Key,
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
		|	ItemList.PartnerUUID,
		|	ItemList.VatRate,
		|	VALUE(Enum.InvoiceType.Invoice)";
EndFunction

Function R5010B_ReconciliationStatement()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Company AS Company,
		|	ItemList.Branch AS Branch,
		|	ItemList.LegalName AS LegalName,
		|	ItemList.LegalNameContract AS LegalNameContract,
		|	ItemList.Currency AS Currency,
		|	ItemList.PartnerUUID AS Key,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.LegalName,
		|	ItemList.LegalNameContract,
		|	ItemList.Currency,
		|	ItemList.PartnerUUID,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Expense)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.TaxLegalName,
		|	ItemList.TaxLegalNameContract,
		|	Currencies.MovementType.Currency,
		|	ItemList.TaxUUID,
		|	SUM(Currencies.Amount),
		|	ItemList.Period
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN Document.WithholdingTaxInvoice.Currencies AS Currencies
		|		ON ItemList.Ref = Currencies.Ref
		|		AND ItemList.Ref.TaxAgreement.CurrencyMovementType = Currencies.MovementType
		|WHERE
		|	ItemList.WithholdingTaxAmount <> 0
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.TaxLegalName,
		|	ItemList.TaxLegalNameContract,
		|	ItemList.TaxUUID,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Expense),
		|	Currencies.MovementType.Currency";
EndFunction

Function R5022T_Expenses()
	Return 
		"SELECT
		|	*,
		|	ItemList.NetAmount + ItemList.WithholdingTaxAmount AS Amount,
		|	ItemList.Amount AS AmountWithTaxes,
		|	ItemList.PartnerUUID AS Key
		|INTO R5022T_Expenses
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_PI_PR_POC_SRTC_WTI();
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_PI_SRTC_WTI();
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_PI_WTI();
EndFunction

Function T2015S_TransactionsInfo() 
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_WTI();
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Currency,
		|	ItemList.PartnerUUID AS Key,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument AS Basis,
		|	ItemList.Key,
		|	SUM(ItemList.Amount) AS Amount
		|INTO R5015B_OtherPartnersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsOther
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Currency,
		|	ItemList.PartnerUUID,
		|	ItemList.Agreement,
		|	ItemList.BasisDocument,
		|	ItemList.Key
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.TaxPartner,
		|	ItemList.TaxLegalName,
		|	ItemList.Currency,
		|	ItemList.TaxUUID,
		|	ItemList.TaxAgreement,
		|	ItemList.BasisDocument AS Basis,
		|	ItemList.Key,
		|	SUM(ItemList.WithholdingTaxAmount) AS Amount
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.WithholdingTaxAmount <> 0
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.TaxPartner,
		|	ItemList.TaxLegalName,
		|	ItemList.Currency,
		|	ItemList.TaxUUID,
		|	ItemList.TaxAgreement,
		|	ItemList.BasisDocument,
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
		|	ItemList.PartnerUUID AS Key,
		|	ItemList.Currency,
		|	undefined as DrCurrency,
		|	undefined as CrCurrency,
		|	ItemList.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.WithholdingTaxInvoice_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPurchase
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.PartnerUUID,
		|	ItemList.Currency,
		|	undefined,
		|	undefined,
		|	ItemList.TaxAmount,
		|	VALUE(Catalog.AccountingOperations.WithholdingTaxInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.TaxAmount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.PartnerUUID,
		|	ItemList.TaxAgreement.CurrencyMovementType.Currency,
		|	undefined,
		|	ItemList.TaxAgreement.CurrencyMovementType.Currency,
		|	ItemList.WithholdingTaxAmount,
		|	VALUE(Catalog.AccountingOperations.WithholdingTaxInvoice_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.WithholdingTaxAmount <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	T2010S_OffsetOfAdvances.Period,
		|	T2010S_OffsetOfAdvances.Key AS RowKey,
		|	T2010S_OffsetOfAdvances.Key,
		|	T2010S_OffsetOfAdvances.Currency,
		|	undefined,
		|	undefined,
		|	T2010S_OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.WithholdingTaxInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors),
		|	T2010S_OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
		|WHERE
		|	T2010S_OffsetOfAdvances.Document = &Ref";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.WithholdingTaxInvoice_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions Then
		
		Return GetAnalytics_Expenses(Parameters); // Expenses - Vendors transactions
		
	ElsIf Parameters.Operation = Operations.WithholdingTaxInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors Then
		
		Return GetAnalytics_OffsetOfAdvances(Parameters); // Vendors transactions - Advances to vendors
	
	ElsIf Parameters.Operation = Operations.WithholdingTaxInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions Then
		
		Return GetAnalytics_VATOutgoing(Parameters); // Taxes outgoing - Vendors transactions
		
	ElsIf Parameters.Operation = Operations.WithholdingTaxInvoice_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions Then
		
		Return GetAnalytics_WithholdingTax(Parameters); // Expenses - Other partners transaction
	
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Expenses - Vendors transactions
Function GetAnalytics_Expenses(Parameters)
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
	If Parameters.ObjectData.Agreement.Type = Enums.AgreementTypes.Other Then
		AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	Else
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Partner"          , Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement"        , Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName"        , Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors
Function GetAnalytics_OffsetOfAdvances(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Partner"          , Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement"        , Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName"        , Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	
	// Debit
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
														  Parameters.ObjectData.Partner,
														  Parameters.ObjectData.Agreement,
														  Parameters.ObjectData.Currency);
	If Parameters.ObjectData.Agreement.Type = Enums.AgreementTypes.Other Then
		AccountingAnalytics.Debit = Accounts.AccountTransactionsOther;
	Else
		AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Taxes outgoing - Vendors transactions
Function GetAnalytics_VATOutgoing(Parameters)
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
	If Parameters.ObjectData.Agreement.Type = Enums.AgreementTypes.Other Then
		AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	Else	                                                    
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Partner"          , Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement"        , Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName"        , Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Other partner (Withholding tax)
Function GetAnalytics_WithholdingTax(Parameters)
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
	                                                    Parameters.ObjectData.TaxPartner,
	                                                    Parameters.ObjectData.TaxAgreement,
	                                                    Parameters.ObjectData.TaxAgreement.CurrencyMovementType.Currency);
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("WithholdingTax", TaxesServer.GetWithholdingTaxRef());
	AdditionalAnalytics.Insert("Company"          , Parameters.ObjectData.Company);
	AdditionalAnalytics.Insert("Partner"          , Parameters.ObjectData.TaxPartner);
	AdditionalAnalytics.Insert("Agreement"        , Parameters.ObjectData.TaxAgreement);
	AdditionalAnalytics.Insert("LegalName"        , Parameters.ObjectData.TaxLegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.TaxLegalNameContract);
	
	AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.WithholdingTaxInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Companies")) <> Undefined Then
		Return Parameters.ObjectData.LegalName;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	AO = Catalogs.AccountingOperations;
	If (Parameters.Operation = AO.WithholdingTaxInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors
		Or Parameters.Operation = AO.WithholdingTaxInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions
		Or Parameters.Operation = AO.WithholdingTaxInvoice_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions
		Or Parameters.Operation = AO.WithholdingTaxInvoice_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions)
		
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Companies")) <> Undefined Then
			
		Return Parameters.ObjectData.LegalName;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion