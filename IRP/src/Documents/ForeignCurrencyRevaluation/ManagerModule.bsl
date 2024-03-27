#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables(Parameters);
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R1020B_AdvancesToVendors
	|FROM
	|	AccumulationRegister.R1020B_AdvancesToVendors.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.VendorAdvanceBalance AS Amount
	|INTO _R5020B_PartnersBalance_VendorAdvance
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// passive
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R1021B_VendorsTransactions
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// passive
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.VendorTransactionBalance AS Amount
	|INTO _R5020B_PartnersBalance_VendorTransaction
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// passive			
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R2020B_AdvancesFromCustomers
	|FROM
	|	AccumulationRegister.R2020B_AdvancesFromCustomers.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// passive
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.CustomerAdvanceBalance AS Amount
	|INTO _R5020B_PartnersBalance_CustomerAdvance
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R2021B_CustomersTransactions
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.CustomerTransactionBalance AS Amount
	|INTO _R5020B_PartnersBalance_CustomerTransaction
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R3010B_CashOnHand
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R3015B_CashAdvance
	|FROM
	|	AccumulationRegister.R3015B_CashAdvance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active 
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R3021B_CashInTransitIncoming
	|FROM
	|	AccumulationRegister.R3021B_CashInTransitIncoming.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R3022B_CashInTransitOutgoing
	|FROM
	|	AccumulationRegister.R3022B_CashInTransitOutgoing.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// none
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R3016B_ChequeAndBonds
	|FROM
	|	AccumulationRegister.R3016B_ChequeAndBonds.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R3027B_EmployeeCashAdvance
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R8510B_BookValueOfFixedAsset
	|FROM
	|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// passive
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R9510B_SalaryPayment
	|FROM
	|	AccumulationRegister.R9510B_SalaryPayment.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// none
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R6070T_OtherPeriodsExpenses
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// none
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R6080T_OtherPeriodsRevenues
	|FROM
	|	AccumulationRegister.R6080T_OtherPeriodsRevenues.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R5015B_OtherPartnersTransactions
	|FROM
	|	AccumulationRegister.R5015B_OtherPartnersTransactions.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.OtherTransactionBalance AS Amount
	|INTO _R5020B_PartnersBalance_OtherTransaction
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.Balance(&Period, Company = &Company
	|	and (CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	or Currency <> TransactionCurrency)) AS Reg
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|INTO CurrencyPairs
	|FROM
	|	_R1020B_AdvancesToVendors AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R5020B_PartnersBalance_VendorAdvance AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R1021B_VendorsTransactions AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R5020B_PartnersBalance_VendorTransaction AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R2020B_AdvancesFromCustomers AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R5020B_PartnersBalance_CustomerAdvance AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R2021B_CustomersTransactions AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R5020B_PartnersBalance_CustomerTransaction AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R3010B_CashOnHand AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R3015B_CashAdvance AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R3021B_CashInTransitIncoming AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R3022B_CashInTransitOutgoing AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R3027B_EmployeeCashAdvance AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R8510B_BookValueOfFixedAsset AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R9510B_SalaryPayment AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R3016B_ChequeAndBonds AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R6070T_OtherPeriodsExpenses AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R6080T_OtherPeriodsRevenues AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R5015B_OtherPartnersTransactions AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R5020B_PartnersBalance_OtherTransaction AS Reg
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CurrencyPairs.CurrencyFrom,
	|	CurrencyPairs.CurrencyTo,
	|	CurrencyPairs.Source
	|INTO UniqueCurrencyPairs
	|FROM
	|	CurrencyPairs
	|GROUP BY
	|	CurrencyPairs.CurrencyFrom,
	|	CurrencyPairs.CurrencyTo,
	|	CurrencyPairs.Source
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(CurrencyRatesSliceLast.Multiplicity, 0) AS Multiplicity,
	|	ISNULL(CurrencyRatesSliceLast.Rate, 0) AS Rate,
	|	CurrencyRatesSliceLast.CurrencyFrom AS CurrencyFrom,
	|	CurrencyRatesSliceLast.CurrencyTo AS CurrencyTo,
	|	CurrencyRatesSliceLast.Source AS Source
	|INTO CurrencyRates
	|FROM
	|	InformationRegister.CurrencyRates.SliceLast(&PeriodSliceLast, (CurrencyFrom, CurrencyTo, Source) IN
	|		(SELECT
	|			UniqueCurrencyPairs.CurrencyFrom,
	|			UniqueCurrencyPairs.CurrencyTo,
	|			UniqueCurrencyPairs.Source
	|		FROM
	|			UniqueCurrencyPairs AS UniqueCurrencyPairs)) AS CurrencyRatesSliceLast";

	DocumentDate = Ref.Date;

	Query.SetParameter("Period", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("PeriodSliceLast", DocumentDate);
	Query.SetParameter("Company", Ref.Company);
	Query.Execute();

	CurrencyRates = Parameters.TempTablesManager.Tables.Find("CurrencyRates").GetData().Unload();

	ArrayOfActives = New Array();
	ArrayOfActives.Add("R1020B_AdvancesToVendors");
	ArrayOfActives.Add("R2021B_CustomersTransactions");
	ArrayOfActives.Add("R3010B_CashOnHand");
	ArrayOfActives.Add("R3015B_CashAdvance");
	ArrayOfActives.Add("R3021B_CashInTransitIncoming");
	ArrayOfActives.Add("R3022B_CashInTransitOutgoing");
	ArrayOfActives.Add("R3027B_EmployeeCashAdvance");
	ArrayOfActives.Add("R5015B_OtherPartnersTransactions");
	ArrayOfActives.Add("R8510B_BookValueOfFixedAsset");

	ArrayOfPassives = New Array();
	ArrayOfPassives.Add("R1021B_VendorsTransactions");
	ArrayOfPassives.Add("R2020B_AdvancesFromCustomers");
	ArrayOfPassives.Add("R9510B_SalaryPayment");

	ArrayOfOthers = New Array();
	ArrayOfOthers.Add("R3016B_ChequeAndBonds");
	ArrayOfOthers.Add("R6070T_OtherPeriodsExpenses");
	ArrayOfOthers.Add("R6080T_OtherPeriodsRevenues");
	ArrayOfOthers.Add("R5020B_PartnersBalance_CustomerTransaction");
	ArrayOfOthers.Add("R5020B_PartnersBalance_CustomerAdvance");
	ArrayOfOthers.Add("R5020B_PartnersBalance_VendorTransaction");
	ArrayOfOthers.Add("R5020B_PartnersBalance_VendorAdvance");
	ArrayOfOthers.Add("R5020B_PartnersBalance_OtherTransaction");

	ExpenseRevenueParams = New Structure();
	ExpenseRevenueParams.Insert("DocumentDate", DocumentDate);
	
	ExpenseRevenueParams.Insert("Revenue_ProfitLossCenter"   , Ref.RevenueProfitLossCenter);
	ExpenseRevenueParams.Insert("Revenue_AdditionalAnalytic" , Ref.RevenueAdditionalAnalytic);
	ExpenseRevenueParams.Insert("RevenueType"                , Ref.RevenueType);

	ExpenseRevenueParams.Insert("Expense_ProfitLossCenter"   , Ref.ExpenseProfitLossCenter);
	ExpenseRevenueParams.Insert("Expense_AdditionalAnalytic" , Ref.ExpenseAdditionalAnalytic);
	ExpenseRevenueParams.Insert("ExpenseType"                , Ref.ExpenseType);
	
	ExpenseRevenueInfo = CurrenciesServer.CreateExpenseRevenueInfo(ExpenseRevenueParams);
	
	CurrenciesServer.RevaluateCurrency(Parameters.TempTablesManager, ArrayOfActives,  CurrencyRates, "Active",  ExpenseRevenueInfo);
	CurrenciesServer.RevaluateCurrency(Parameters.TempTablesManager, ArrayOfPassives, CurrencyRates, "Passive", ExpenseRevenueInfo);
	CurrenciesServer.RevaluateCurrency(Parameters.TempTablesManager, ArrayOfOthers,   CurrencyRates, "Others",  ExpenseRevenueInfo);

	CurrenciesServer.DeleteEmptyAmounts(ExpenseRevenueInfo.RevenuesTable, "Amount");
	CurrenciesServer.DeleteEmptyAmounts(ExpenseRevenueInfo.ExpensesTable, "Amount");
	
	CurrenciesServer.CreateVirtualTables(Parameters, ArrayOfActives);
	CurrenciesServer.CreateVirtualTables(Parameters, ArrayOfPassives);
	CurrenciesServer.CreateVirtualTables(Parameters, ArrayOfOthers);

	Query.Text =
	"SELECT * INTO _R5021T_Revenues FROM &RevenuesTable AS Table;
	|SELECT * INTO _R5022T_Expenses FROM &ExpensesTable AS Table;";
	Query.SetParameter("RevenuesTable", ExpenseRevenueInfo.RevenuesTable);
	Query.SetParameter("ExpensesTable", ExpenseRevenueInfo.ExpensesTable);
	Query.Execute();

	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.AccumulationRegisters.R5022T_Expenses);
	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.AccumulationRegisters.R5021T_Revenues);
	
	// Accounting
	
	RecordSet = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Read();
	_AccountingRowAnalytics = RecordSet.Unload();
			
	RecordSet = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
	RecordSet.Filter.Document.Set(Ref);
	RecordSet.Read();
	_AccountingExtDimensions = RecordSet.Unload();
	
	AccountingClientServer.UpdateAccountingTables(Ref, _AccountingRowAnalytics, _AccountingExtDimensions, Undefined,,, 
		New Structure("Parameters", Parameters));
		
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, 
		New Structure("AccountingRowAnalytics, AccountingExtDimensions", _AccountingRowAnalytics, _AccountingExtDimensions));
	Return New Structure;
EndFunction

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers) AS Operation
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Revaluated_R2020B_AdvancesFromCustomers AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0";
EndFunction

Function GetAccountingDataTable(Operation, AddInfo) Export
	If Operation = Catalogs.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers Then
		Query = New Query();
		Query.TempTablesManager = AddInfo.Parameters.TempTablesManager;
		Query.Text = 
		"SELECT * FROM Revaluated_R2020B_AdvancesFromCustomers AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	EndIf;
	Return New ValueTable();
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	If Parameters.Operation = Catalogs.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers(Parameters); // Expenses - Advance from customers
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Expenses - Advance from customers
Function GetAnalytics_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, Parameters.ObjectData.ExpenseType);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("ProfitCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Undefined,
	                                                    Parameters.RowData.Currency);
	                                                    
	If ValueIsFilled(Credit.AccountAdvancesCustomer) Then
		AccountingAnalytics.Credit = Credit.AccountAdvancesCustomer;
	EndIf;
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

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
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
	Parameters.Insert("Unposting", True);
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
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

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables(Parameters = Undefined)
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3015B_CashAdvance());
	QueryArray.Add(R3016B_ChequeAndBonds());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3022B_CashInTransitOutgoing());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R6070T_OtherPeriodsExpenses());
	QueryArray.Add(R6080T_OtherPeriodsRevenues());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(R5020B_PartnersBalance());
	Return QueryArray;
EndFunction

Function R5021T_Revenues()
	Return "SELECT *
		   |INTO R5021T_Revenues
		   |FROM 
		   |	_R5021T_Revenues
		   |WHERE
		   |	TRUE";
EndFunction

Function R5022T_Expenses()
	Return "SELECT *
		   |INTO R5022T_Expenses
		   |FROM 
		   |	_R5022T_Expenses
		   |WHERE
		   |	TRUE";
EndFunction

Function R5020B_PartnersBalance()
	Return
		"SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Document,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	0 AS Amount,
		|	Table.AmountRevaluated AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED AS AdvancesClosing
		|INTO R5020B_PartnersBalance
		|FROM
		|	Revaluated_R5020B_PartnersBalance_CustomerTransaction AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Document,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	Table.AmountRevaluated AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED
		|FROM
		|	Revaluated_R5020B_PartnersBalance_CustomerAdvance AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Document,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	Table.AmountRevaluated AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED
		|FROM
		|	Revaluated_R5020B_PartnersBalance_VendorTransaction AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Document,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	Table.AmountRevaluated AS VendorAdvance,
		|	0 AS OtherTransaction,
		|	UNDEFINED
		|FROM
		|	Revaluated_R5020B_PartnersBalance_VendorAdvance AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Document,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	0 AS Amount,
		|	0 AS CustomerTransaction,
		|	0 AS CustomerAdvance,
		|	0 AS VendorTransaction,
		|	0 AS VendorAdvance,
		|	Table.AmountRevaluated AS OtherTransaction,
		|	UNDEFINED
		|FROM
		|	Revaluated_R5020B_PartnersBalance_OtherTransaction AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0";
EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT *
		   |INTO R1020B_AdvancesToVendors
		   |FROM 
		   |	Revaluated_R1020B_AdvancesToVendors
		   |WHERE
		   |	TRUE";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT *
		   |INTO R1021B_VendorsTransactions
		   |FROM 
		   |	Revaluated_R1021B_VendorsTransactions
		   |WHERE
		   |	TRUE";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT *
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM 
		   |	Revaluated_R2020B_AdvancesFromCustomers
		   |WHERE
		   |	TRUE";
EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT *
		   |INTO R2021B_CustomersTransactions
		   |FROM 
		   |	Revaluated_R2021B_CustomersTransactions
		   |WHERE
		   |	TRUE";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT *
		   |INTO R3010B_CashOnHand
		   |FROM 
		   |	Revaluated_R3010B_CashOnHand
		   |WHERE
		   |	TRUE";
EndFunction

Function R3015B_CashAdvance()
	Return "SELECT *
		   |INTO R3015B_CashAdvance
		   |FROM 
		   |	Revaluated_R3015B_CashAdvance
		   |WHERE
		   |	TRUE";
EndFunction

Function R3021B_CashInTransitIncoming()
	Return "SELECT *
		   |INTO R3021B_CashInTransitIncoming
		   |FROM 
		   |	Revaluated_R3021B_CashInTransitIncoming
		   |WHERE
		   |	TRUE";
EndFunction

Function R3022B_CashInTransitOutgoing()
	Return "SELECT *
		   |INTO R3022B_CashInTransitOutgoing
		   |FROM 
		   |	Revaluated_R3022B_CashInTransitOutgoing
		   |WHERE
		   |	TRUE";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return "SELECT *
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM 
		   |	Revaluated_R3027B_EmployeeCashAdvance
		   |WHERE
		   |	TRUE";
EndFunction

Function R9510B_SalaryPayment()
	Return "SELECT *
		   |INTO R9510B_SalaryPayment
		   |FROM 
		   |	Revaluated_R9510B_SalaryPayment
		   |WHERE
		   |	TRUE";
EndFunction

Function R3016B_ChequeAndBonds()
	Return "SELECT *
		   |INTO R3016B_ChequeAndBonds
		   |FROM 
		   |	Revaluated_R3016B_ChequeAndBonds
		   |WHERE
		   |	TRUE";
EndFunction

Function R6070T_OtherPeriodsExpenses()
	Return "SELECT *
		   |INTO R6070T_OtherPeriodsExpenses
		   |FROM 
		   |	Revaluated_R6070T_OtherPeriodsExpenses
		   |WHERE
		   |	TRUE";
EndFunction

Function R6080T_OtherPeriodsRevenues()
	Return "SELECT *
		   |INTO R6080T_OtherPeriodsRevenues
		   |FROM 
		   |	Revaluated_R6080T_OtherPeriodsRevenues
		   |WHERE
		   |	TRUE";
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return "SELECT *
		   |INTO R5015B_OtherPartnersTransactions
		   |FROM 
		   |	Revaluated_R5015B_OtherPartnersTransactions
		   |WHERE
		   |	TRUE";
EndFunction

Function R8510B_BookValueOfFixedAsset()
	Return "SELECT *
		   |INTO R8510B_BookValueOfFixedAsset
		   |FROM 
		   |	Revaluated_R8510B_BookValueOfFixedAsset
		   |WHERE
		   |	TRUE";
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
	Return AccessKeyMap;
EndFunction

#EndRegion
