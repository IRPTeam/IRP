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
	|// active
	|SELECT
	|	*,
	|	Reg.CurrencyMovementType.Source AS Source,
	|	Reg.AmountBalance AS Amount
	|INTO _R1040B_TaxesOutgoing
	|FROM
	|	AccumulationRegister.R1040B_TaxesOutgoing.Balance(&Period, Company = &Company
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
	|INTO _R2040B_TaxesIncoming
	|FROM
	|	AccumulationRegister.R2040B_TaxesIncoming.Balance(&Period, Company = &Company
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
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R1040B_TaxesOutgoing AS Reg
	|
	|UNION ALL
	|
	|SELECT
	|	Reg.TransactionCurrency AS CurrencyFrom,
	|	Reg.Currency AS CurrencyTo,
	|	Reg.Source AS Source
	|FROM
	|	_R2040B_TaxesIncoming AS Reg
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
//	ArrayOfActives.Add("R1040B_TaxesOutgoing");

	ArrayOfPassives = New Array();
	ArrayOfPassives.Add("R1021B_VendorsTransactions");
	ArrayOfPassives.Add("R2020B_AdvancesFromCustomers");
	ArrayOfPassives.Add("R9510B_SalaryPayment");
//	ArrayOfPassives.Add("R2040B_TaxesIncoming");

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
		// passive RecordType.Receipt - Expense   RecordType.Expense - Revenue
		"SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency AS RevaluatedCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers) AS Operation
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Revaluated_R2020B_AdvancesFromCustomers AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R2020B_AdvancesFromCustomers AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions) AS Operation
		|FROM
		|	Revaluated_R1021B_VendorsTransactions AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R1021B_VendorsTransactions AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R9510B_SalaryPayment) AS Operation
		|FROM
		|	Revaluated_R9510B_SalaryPayment AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R9510B_SalaryPayment_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R9510B_SalaryPayment AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
//		|UNION ALL
//		|
//		|SELECT
//		|	Table.Period,
//		|	Table.Key AS RowKey,
//		|	Table.Key AS Key,
//		|	Table.Currency,
//		|	Table.CurrencyMovementType,
//		|	Table.TransactionCurrency,
//		|	Table.AmountRevaluated AS Amount,
//		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2040B_TaxesIncoming) AS Operation
//		|FROM
//		|	Revaluated_R2040B_TaxesIncoming AS Table
//		|WHERE
//		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
//		|	AND Table.AmountRevaluated > 0
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	Table.Period,
//		|	Table.Key AS RowKey,
//		|	Table.Key AS Key,
//		|	Table.Currency,
//		|	Table.CurrencyMovementType,
//		|	Table.TransactionCurrency,
//		|	Table.AmountRevaluated AS Amount,
//		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R2040B_TaxesIncoming_CR_R5021T_Revenues) AS Operation
//		|FROM
//		|	Revaluated_R2040B_TaxesIncoming AS Table
//		|WHERE
//		|	Table.RecordType = Value(AccumulationRecordType.Expense)
//		|	AND Table.AmountRevaluated > 0
//		|
		|
		// active RecordType.Receipt - Revenue  RecordType.Expense - Expense
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3010B_CashOnHand) AS Operation
		|FROM
		|	Revaluated_R3010B_CashOnHand AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R3010B_CashOnHand_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R3010B_CashOnHand AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors) AS Operation
		|FROM
		|	Revaluated_R1020B_AdvancesToVendors AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R1020B_AdvancesToVendors AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions) AS Operation
		|FROM
		|	Revaluated_R2021B_CustomersTransactions AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R2021B_CustomersTransactions AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3015B_CashAdvance) AS Operation
		|FROM
		|	Revaluated_R3015B_CashAdvance AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R3015B_CashAdvance_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R3015B_CashAdvance AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance) AS Operation
		|FROM
		|	Revaluated_R3027B_EmployeeCashAdvance AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R3027B_EmployeeCashAdvance AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions) AS Operation
		|FROM
		|	Revaluated_R5015B_OtherPartnersTransactions AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R5015B_OtherPartnersTransactions AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset) AS Operation
		|FROM
		|	Revaluated_R8510B_BookValueOfFixedAsset AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Expense)
		|	AND Table.AmountRevaluated > 0
		|
		|UNION ALL
		|
		|SELECT
		|	Table.Period,
		|	Table.Key AS RowKey,
		|	Table.Key AS Key,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount,
		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues) AS Operation
		|FROM
		|	Revaluated_R8510B_BookValueOfFixedAsset AS Table
		|WHERE
		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
		|	AND Table.AmountRevaluated > 0";
//		|
//		|UNION ALL
//		|		
//		|SELECT
//		|	Table.Period,
//		|	Table.Key AS RowKey,
//		|	Table.Key AS Key,
//		|	Table.Currency,
//		|	Table.CurrencyMovementType,
//		|	Table.TransactionCurrency,
//		|	Table.AmountRevaluated AS Amount,
//		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1040B_TaxesOutgoing) AS Operation
//		|FROM
//		|	Revaluated_R1040B_TaxesOutgoing AS Table
//		|WHERE
//		|	Table.RecordType = Value(AccumulationRecordType.Expense)
//		|	AND Table.AmountRevaluated > 0
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	Table.Period,
//		|	Table.Key AS RowKey,
//		|	Table.Key AS Key,
//		|	Table.Currency,
//		|	Table.CurrencyMovementType,
//		|	Table.TransactionCurrency,
//		|	Table.AmountRevaluated AS Amount,
//		|	VALUE(Catalog.AccountingOperations.ForeignCurrencyRevaluation_DR_R1040B_TaxesOutgoing_CR_R5021T_Revenues) AS Operation
//		|FROM
//		|	Revaluated_R1040B_TaxesOutgoing AS Table
//		|WHERE
//		|	Table.RecordType = Value(AccumulationRecordType.Receipt)
//		|	AND Table.AmountRevaluated > 0";
EndFunction

Function GetAccountingDataTable(Operation, AddInfo) Export
	AO = Catalogs.AccountingOperations;
	Query = New Query();
	Query.TempTablesManager = AddInfo.Parameters.TempTablesManager;
	
	// passive
	If Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers Then
		Query.Text = 
		"SELECT * FROM Revaluated_R2020B_AdvancesFromCustomers AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R2020B_AdvancesFromCustomers AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
		
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions Then
		Query.Text = 
		"SELECT * FROM Revaluated_R1021B_VendorsTransactions AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R1021B_VendorsTransactions AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
		
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R9510B_SalaryPayment Then
		Query.Text = 
		"SELECT * FROM Revaluated_R9510B_SalaryPayment AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R9510B_SalaryPayment_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R9510B_SalaryPayment AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2040B_TaxesIncoming Then
		Query.Text = 
		"SELECT * FROM Revaluated_R2040B_TaxesIncoming AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R2040B_TaxesIncoming_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R2040B_TaxesIncoming AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
		
	// active
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3010B_CashOnHand Then
		Query.Text = 
		"SELECT * FROM Revaluated_R3010B_CashOnHand AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R3010B_CashOnHand_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R3010B_CashOnHand AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors Then
		Query.Text = 
		"SELECT * FROM Revaluated_R1020B_AdvancesToVendors AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R1020B_AdvancesToVendors AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions Then
		Query.Text = 
		"SELECT * FROM Revaluated_R2021B_CustomersTransactions AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R2021B_CustomersTransactions AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3015B_CashAdvance Then
		Query.Text = 
		"SELECT * FROM Revaluated_R3015B_CashAdvance AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R3015B_CashAdvance_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R3015B_CashAdvance AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance Then
		Query.Text = 
		"SELECT * FROM Revaluated_R3027B_EmployeeCashAdvance AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R3027B_EmployeeCashAdvance AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions Then
		Query.Text = 
		"SELECT * FROM Revaluated_R5015B_OtherPartnersTransactions AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R5015B_OtherPartnersTransactions AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset Then
		Query.Text = 
		"SELECT * FROM Revaluated_R8510B_BookValueOfFixedAsset AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R8510B_BookValueOfFixedAsset AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1040B_TaxesOutgoing Then
		Query.Text = 
		"SELECT * FROM Revaluated_R1040B_TaxesOutgoing AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Expense) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();
	ElsIf Operation = AO.ForeignCurrencyRevaluation_DR_R1040B_TaxesOutgoing_CR_R5021T_Revenues Then
		Query.Text = 
		"SELECT * FROM Revaluated_R1040B_TaxesOutgoing AS Table WHERE 
		|Table.RecordType = Value(AccumulationRecordType.Receipt) AND Table.AmountRevaluated > 0";
		Return Query.Execute().Unload();		 
	EndIf;
	Return New ValueTable();
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	// passive
	If Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers(Parameters); // Expenses - Advance from customers
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues(Parameters); // Advance from customers - Revenue	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions(Parameters); // Expenses - Vendor transactions
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues(Parameters); // Vendor transactions - Revenue	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R9510B_SalaryPayment Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R9510B_SalaryPayment(Parameters); // Expenses - Salary payments
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R9510B_SalaryPayment_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R9510B_SalaryPayment_CR_R5021T_Revenues(Parameters); // Salary payments - Revenue	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2040B_TaxesIncoming Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R2040B_TaxesIncoming(Parameters); // Expenses - Taxes incoming
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R2040B_TaxesIncoming_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R2040B_TaxesIncoming_CR_R5021T_Revenues(Parameters); // Taxes incoming - Revenue	
	
	// active
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3010B_CashOnHand Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R3010B_CashOnHand(Parameters); // Expenses - Cash on hand		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R3010B_CashOnHand_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R3010B_CashOnHand_CR_R5021T_Revenues(Parameters); // Cash on hand - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors(Parameters); // Expenses - Advance to vendors		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues(Parameters); // Advance to vendors - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions(Parameters); // Expenses - Customer transactions		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues(Parameters); // Customer transactions - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3015B_CashAdvance Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R3015B_CashAdvance(Parameters); // Expenses - Cash advance		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R3015B_CashAdvance_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R3015B_CashAdvance_CR_R5021T_Revenues(Parameters); // Cash advance - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance(Parameters); // Expenses - Employee cash advance		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues(Parameters); // Employee cash advance - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions(Parameters); // Expenses - Other partner transactions		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues(Parameters); // Other partner transactions - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset(Parameters); // Expenses - Fixed asset		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues(Parameters); // Fixed asset - Revenues	
	
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R5022T_Expenses_CR_R1040B_TaxesOutgoing Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R1040B_TaxesOutgoing(Parameters); // Expenses - Taxes outgoing		
	ElsIf Parameters.Operation = AO.ForeignCurrencyRevaluation_DR_R1040B_TaxesOutgoing_CR_R5021T_Revenues Then
		Return GetAnalytics_DR_R1040B_TaxesOutgoing_CR_R5021T_Revenues(Parameters); // Taxes outgoing - Revenues	
			
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// passive

// Expenses - Advance from customers
Function GetAnalytics_DR_R5022T_Expenses_CR_R2020B_AdvancesFromCustomers(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalytics.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Credit = Credit.AccountAdvancesCustomer;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Advance from customers - Revenue
Function GetAnalytics_DR_R2020B_AdvancesFromCustomers_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Debit = Debit.AccountAdvancesCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalytics.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Vendor transactions
Function GetAnalytics_DR_R5022T_Expenses_CR_R1021B_VendorsTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalytics.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Vendor transactions - Revenue
Function GetAnalytics_DR_R1021B_VendorsTransactions_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalytics.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Salary payments
Function GetAnalytics_DR_R5022T_Expenses_CR_R9510B_SalaryPayment(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalytics.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
	                                                    Parameters.RowData.Employee); 
	AccountingAnalytics.Credit = Credit.AccountSalaryPayment;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Salary payments - Revenue
Function GetAnalytics_DR_R9510B_SalaryPayment_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, 
	                                                    Parameters.RowData.Employee); 
	AccountingAnalytics.Debit = Debit.AccountSalaryPayment;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalytics.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Taxes incoming
Function GetAnalytics_DR_R5022T_Expenses_CR_R2040B_TaxesIncoming(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalytics.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, 
		New Structure("Tax, VatRate", Parameters.RowData.Tax, Parameters.RowData.TaxRate));
	AccountingAnalytics.Credit = Credit.IncomingAccount;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Taxes incoming - Revenue
Function GetAnalytics_DR_R2040B_TaxesIncoming_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, 
		New Structure("Tax, VatRate", Parameters.RowData.Tax, Parameters.RowData.TaxRate));
	AccountingAnalytics.Debit = Debit.IncomingAccount;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalytics.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// active

// Expenses - Cash on hand
Function GetAnalytics_DR_R5022T_Expenses_CR_R3010B_CashOnHand(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                    Parameters.RowData.Account,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Credit = Credit.Account;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("FinMovType", Catalogs.ExpenseAndRevenueTypes.EmptyRef());
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Cash on hand - Revenue
Function GetAnalytics_DR_R3010B_CashOnHand_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                    Parameters.RowData.Account, 
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Debit = Debit.Account;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("FinMovType", Catalogs.ExpenseAndRevenueTypes.EmptyRef());
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Expenses - Advance to vendors
Function GetAnalytics_DR_R5022T_Expenses_CR_R1020B_AdvancesToVendors(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner,
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Credit = Credit.AccountAdvancesVendor;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Advance to vendors - Revenue
Function GetAnalytics_DR_R1020B_AdvancesToVendors_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement, 
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Debit = Debit.AccountAdvancesVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Expenses - Customer transactions
Function GetAnalytics_DR_R5022T_Expenses_CR_R2021B_CustomersTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner,
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Credit = Credit.AccountTransactionsCustomer;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Customer transactions - Revenue
Function GetAnalytics_DR_R2021B_CustomersTransactions_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement, 
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Expenses - Taxes outgoing
Function GetAnalytics_DR_R5022T_Expenses_CR_R1040B_TaxesOutgoing(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, 
		New Structure("Tax, VatRate", Parameters.RowData.Tax, Parameters.RowData.TaxRate));
	AccountingAnalytics.Credit = Credit.OutgoingAccount;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Taxes outgoing - Revenue
Function GetAnalytics_DR_R1040B_TaxesOutgoing_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, 
		New Structure("Tax, VatRate", Parameters.RowData.Tax, Parameters.RowData.TaxRate));
	AccountingAnalytics.Debit = Debit.OutgoingAccount;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Expenses - Cash advance
Function GetAnalytics_DR_R5022T_Expenses_CR_R3015B_CashAdvance(Parameters)
	Raise "Not supported [DR_R5022T_Expenses_CR_R3015B_CashAdvance]";
EndFunction

// Cash advance - Revenue
Function GetAnalytics_DR_R3015B_CashAdvance_CR_R5021T_Revenues(Parameters)
	Raise "Not supported [DR_R5022T_Expenses_CR_R3015B_CashAdvance]";
EndFunction

// Expenses - Employee cash advance
Function GetAnalytics_DR_R5022T_Expenses_CR_R3027B_EmployeeCashAdvance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Partner);
	AccountingAnalytics.Credit = Credit.AccountCashAdvance;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Employee cash advance - Revenue
Function GetAnalytics_DR_R3027B_EmployeeCashAdvance_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Partner);
	AccountingAnalytics.Debit = Debit.AccountCashAdvance;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Expenses - Other partner transactions
Function GetAnalytics_DR_R5022T_Expenses_CR_R5015B_OtherPartnersTransactions(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner,
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Credit = Credit.AccountTransactionsOther;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Other partner transactions - Revenue
Function GetAnalytics_DR_R5015B_OtherPartnersTransactions_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement, 
	                                                    Parameters.RowData.TransactionCurrency);
	AccountingAnalytics.Debit = Debit.AccountTransactionsOther;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

	Return AccountingAnalytics;
EndFunction

// Expenses - Fixed assets
Function GetAnalytics_DR_R5022T_Expenses_CR_R8510B_BookValueOfFixedAsset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AdditionalAnalyticsDr = New Structure();
	AdditionalAnalyticsDr.Insert("ExpenseType", Parameters.ObjectData.ExpenseType);
	AdditionalAnalyticsDr.Insert("ExpenseCenter", Parameters.ObjectData.ExpenseProfitLossCenter);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsDr);

	// Credit
	Credit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.RowData.FixedAsset);
	AccountingAnalytics.Credit = Credit.Account;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Fixed assets - Revenue
Function GetAnalytics_DR_R8510B_BookValueOfFixedAsset_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.RowData.FixedAsset);
	AccountingAnalytics.Debit = Debit.Account;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	AdditionalAnalyticsCr = New Structure();
	AdditionalAnalyticsCr.Insert("RevenueType", Parameters.ObjectData.RevenueType);
	AdditionalAnalyticsCr.Insert("RevenueCenter", Parameters.ObjectData.RevenueProfitLossCenter);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalyticsCr);

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
//	QueryArray.Add(R1040B_TaxesOutgoing());
//	QueryArray.Add(R2040B_TaxesIncoming());
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

Function R1040B_TaxesOutgoing()
	Return
		"SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Tax,
		|	Table.TaxRate,
		|	Table.InvoiceType,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	Revaluated_R1040B_TaxesOutgoing AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0";
EndFunction

Function R2040B_TaxesIncoming()
	Return
		"SELECT
		|	Table.RecordType,
		|	Table.Period,
		|	Table.Company,
		|	Table.Branch,
		|	Table.Tax,
		|	Table.TaxRate,
		|	Table.Currency,
		|	Table.CurrencyMovementType,
		|	Table.TransactionCurrency,
		|	Table.AmountRevaluated AS Amount
		|INTO R2040B_TaxesIncoming
		|FROM
		|	Revaluated_R2040B_TaxesIncoming AS Table
		|WHERE
		|	Table.AmountRevaluated <> 0";
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
