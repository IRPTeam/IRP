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
	
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2040B_TaxesIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
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
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R5021T_Revenues());
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
		|	ItemList.RevenueType AS RevenueType,
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
		|	Document.OutgoingExchRateAdjustmentInvoice.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R2040B_TaxesIncoming()	
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Key,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	&Vat AS Tax,
		|	ItemList.VatRate AS TaxRate,
		|	SUM(ItemList.TaxAmount) AS Amount,
		|	VALUE(Enum.InvoiceType.Invoice) AS InvoiceType
		|INTO R2040B_TaxesIncoming
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.TaxAmount <> 0
		|	AND ItemList.IsCustomer
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Key,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.VatRate,
		|	VALUE(Enum.InvoiceType.Invoice)";
EndFunction

Function R5021T_Revenues()
	Return
		"SELECT
		|	ItemList.Period AS Period,
		|	ItemList.Key AS Key,
		|	ItemList.Company AS Company,
		|	ItemList.Branch AS Branch,
		|	ItemList.ProfitLossCenter AS ProfitLossCenter,
		|	ItemList.RevenueType AS RevenueType,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Currency AS Currency,
		|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	ItemList.Project AS Project,
		|	ItemList.NetAmount AS Amount,
		|	ItemList.Amount AS AmountWithTaxes
		|INTO R5021T_Revenues
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R2021B_CustomersTransactions()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Key,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Project,
		|	ItemList.Invoice AS Basis,
		|	Undefined AS Order,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsCustomer
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Key,
		|	ItemList.Project,
		|	ItemList.Invoice,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R5020B_PartnersBalance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Key,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Invoice AS Document,
		|	ItemList.Currency,
		|	0 AS Amount,
		|	SUM(ItemList.Amount) AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing,
		|	UNDEFINED AS Key
		|INTO R5020B_PartnersBalance
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsCustomer
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	ItemList.Period,
		|	ItemList.Key,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Partner,
		|	ItemList.LegalName,
		|	ItemList.Agreement,
		|	ItemList.Invoice,
		|	ItemList.Currency";
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
		|	ItemList.Ref.Agreement.CurrencyMovementType.Currency AS DrCurrency,
		|	ItemList.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.OutgoingExchRateAdjustmentInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues) AS Operation,
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
		|	ItemList.Ref.Agreement.CurrencyMovementType.Currency AS DrCurrency,
		|	ItemList.TaxAmount,
		|	VALUE(Catalog.AccountingOperations.OutgoingExchRateAdjustmentInvoice_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.TaxAmount <> 0";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.OutgoingExchRateAdjustmentInvoice_DR_R2021B_CustomersTransactions_CR_R2040B_TaxesIncoming Then
		
		Return GetAnalytics_CustomerTransactions_TaxIncomng(Parameters); // Customer transactons - Tax incoming
		
	ElsIf Parameters.Operation = Operations.OutgoingExchRateAdjustmentInvoice_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues Then
		
		Return GetAnalytics_CustomerTransacton_Revenue(Parameters); // Customer transactons - Revenue
	
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Customer transactions - Revenues
Function GetAnalytics_CustomerTransacton_Revenue(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement", Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName", Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.RowData.RevenueType,
	                                                           Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	Return AccountingAnalytics;
EndFunction

// Customer transactions - Taxes incoming
Function GetAnalytics_CustomerTransactions_TaxIncomng(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.ObjectData.Partner, 
	                                                   Parameters.ObjectData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.ObjectData.Partner);
	AdditionalAnalytics.Insert("Agreement", Parameters.ObjectData.Agreement);
	AdditionalAnalytics.Insert("LegalName", Parameters.ObjectData.LegalName);
	AdditionalAnalytics.Insert("LegalNameContract", Parameters.ObjectData.LegalNameContract);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	AccountingAnalytics.Credit = Credit.IncomingAccount;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
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