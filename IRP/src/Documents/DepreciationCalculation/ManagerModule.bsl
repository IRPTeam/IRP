#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
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
	Tables.R8510B_BookValueOfFixedAsset.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
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
	StrParams.Insert("Date", Ref.Date);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(Calculations());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function Calculations()
	Return
		"SELECT
		|	Calculations.Ref.Date AS Period,
		|	Calculations.Ref.Company AS Company,
		|	Calculations.Ref.Branch AS Branch,
		|	Calculations.Key AS Key,
		|	Calculations.*
		|INTO Calculations
		|FROM
		|	Document.DepreciationCalculation.Calculations AS Calculations
		|WHERE
		|	Calculations.Ref = &Ref";
EndFunction	
	
#EndRegion

#Region Posting_MainTables

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	*,
		|	&Date AS Period,
		|	VALUE(AccumulationRecordType.Expense) AS RecordType
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	Calculations
		|WHERE
		|	TRUE";
EndFunction

Function R5022T_Expenses()
	Return
		"SELECT
		|	*,
		|	&Date AS Period
		|INTO R5022T_Expenses
		|FROM
		|	Calculations
		|WHERE
		|	TRUE";
EndFunction

#EndRegion

Function GetCalculations(Ref, Date, Company, Branch) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	T.Company AS Company,
	|	T.Branch AS Branch,
	|	T.ProfitLossCenter AS ProfitLossCenter,
	|	T.FixedAsset AS FixedAsset,
	|	T.LedgerType AS LedgerType,
	|	T.AmountBalance AS AmountBalance
	|INTO ActiveFixedAssets
	|FROM
	|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&Period, Company = &Company
	|	AND Branch = &Branch
	|	AND LedgerType.CalculateDepreciation
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS T
	|WHERE
	|	T.AmountBalance > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T8515S_FixedAssetsLocation.Company AS Company,
	|	T8515S_FixedAssetsLocation.FixedAsset AS FixedAsset,
	|	DATEADD(ENDOFPERIOD(MIN(T8515S_FixedAssetsLocation.Period), MONTH), SECOND, 1) AS StartDate
	|INTO StartingDates
	|FROM
	|	InformationRegister.T8515S_FixedAssetsLocation AS T8515S_FixedAssetsLocation
	|WHERE
	|	(T8515S_FixedAssetsLocation.Company, T8515S_FixedAssetsLocation.FixedAsset) IN
	|		(SELECT
	|			ActiveFixedAssets.Company,
	|			ActiveFixedAssets.FixedAsset
	|		FROM
	|			ActiveFixedAssets AS ActiveFixedAssets)
	|GROUP BY
	|	T8515S_FixedAssetsLocation.Company,
	|	T8515S_FixedAssetsLocation.FixedAsset
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T8515S_FixedAssetsLocationSliceLast.Company AS Company,
	|	T8515S_FixedAssetsLocationSliceLast.FixedAsset AS FixedAsset,
	|	T8515S_FixedAssetsLocationSliceLast.Branch AS Branch,
	|	T8515S_FixedAssetsLocationSliceLast.ProfitLossCenter AS ProfitLossCenter
	|INTO LocationFixedAssets
	|FROM
	|	InformationRegister.T8515S_FixedAssetsLocation.SliceLast(&StartDate, (Company, Branch, FixedAsset, ProfitLossCenter)
	|		IN
	|		(SELECT
	|			ActiveFixedAssets.Company,
	|			ActiveFixedAssets.Branch,
	|			ActiveFixedAssets.FixedAsset,
	|			ActiveFixedAssets.ProfitLossCenter
	|		FROM
	|			ActiveFixedAssets AS ActiveFixedAssets)) AS T8515S_FixedAssetsLocationSliceLast
	|WHERE
	|	T8515S_FixedAssetsLocationSliceLast.IsActive
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.Company AS Company,
	|	T.FixedAsset AS FixedAsset,
	|	T.LedgerType AS LedgerType,
	|	T.AmountTurnover AS AmountTurnover
	|INTO CostFixedAsset
	|FROM
	|	AccumulationRegister.R8515T_CostOfFixedAsset.Turnovers(UNDEFINED, &Period,, (Company, FixedAsset) IN
	|		(SELECT
	|			ActiveFixedAssets.Company,
	|			ActiveFixedAssets.FixedAsset
	|		FROM
	|			ActiveFixedAssets AS ActiveFixedAssets)) AS T
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.Company AS Company,
	|	T.Branch AS Branch,
	|	T.ProfitLossCenter AS ProfitLossCenter,
	|	T.FixedAsset AS FixedAsset,
	|	T.LedgerType AS LedgerType,
	|	T.Schedule AS Schedule,
	|	T.Schedule.CalculationMethod AS CalculationMethod,
	|	&Currency AS Currency,
	|	ActiveFixedAssets.AmountBalance AS AmountBalance,
	|	CostFixedAsset.AmountTurnover AS AmountTurnover,
	|	StartingDates.StartDate AS StartDate,
	|	DATEADD(StartingDates.StartDate, MONTH, T.Schedule.UsefulLife - 1) AS FinishDate,
	|	T.Schedule.UsefulLife AS UsefulLife,
	|	T.Schedule.Rate AS Rate,
	|	T.LedgerType.ExpenseType AS ExpenseType,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.R8510B_BookValueOfFixedAsset.BalanceAndTurnovers(UNDEFINED, &Period,,, Company = &Company
	|	AND Branch = &Branch
	|	AND LedgerType.CalculateDepreciation
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS T
	|		INNER JOIN StartingDates AS StartingDates
	|		ON (StartingDates.Company = T.Company)
	|		AND (StartingDates.FixedAsset = T.FixedAsset)
	|		AND (StartingDates.StartDate < &StartDate)
	|		INNER JOIN LocationFixedAssets AS LocationFixedAssets
	|		ON (LocationFixedAssets.Company = T.Company)
	|		AND (LocationFixedAssets.Branch = T.Branch)
	|		AND (LocationFixedAssets.ProfitLossCenter = T.ProfitLossCenter)
	|		AND (LocationFixedAssets.FixedAsset = T.FixedAsset)
	|		INNER JOIN CostFixedAsset AS CostFixedAsset
	|		ON (CostFixedAsset.Company = T.Company)
	|		AND (CostFixedAsset.FixedAsset = T.FixedAsset)
	|		AND (CostFixedAsset.LedgerType = T.LedgerType)
	|		INNER JOIN ActiveFixedAssets AS ActiveFixedAssets
	|		ON (ActiveFixedAssets.Company = T.Company)
	|		AND (ActiveFixedAssets.Branch = T.Branch)
	|		AND (ActiveFixedAssets.ProfitLossCenter = T.ProfitLossCenter)
	|		AND (ActiveFixedAssets.FixedAsset = T.FixedAsset)
	|		AND (ActiveFixedAssets.LedgerType = T.LedgerType)";
	
	If Not ValueIsFilled(Ref) Then
		Query.SetParameter("Period", EndOfDay(Date));
	Else
		Query.SetParameter("Period", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	EndIf;
	Query.SetParameter("StartDate" , Date);
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("Branch"    , Branch); 
	Query.SetParameter("Currency"  , CurrenciesServer.GetLandedCostCurrency(Company)); 
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	QueryTable.Columns.Add("Key");
	
	For Each Row In QueryTable Do
		Row.Key = New UUID();
		
		// last month
		If EndOfMonth(Row.FinishDate) = EndOfMonth(Date) Then
			Row.Amount = Row.AmountBalance;
			Continue;
		EndIf;
		
		Amount = 0;
		
		// Straight line
		If Row.CalculationMethod = Enums.DepreciationMethods.StraightLine Then
			Amount = Row.AmountTurnover / Row.UsefulLife;	
		EndIf;
		
		// Declining balance
		If Row.CalculationMethod = Enums.DepreciationMethods.DecliningBalance Then
			Amount = Row.AmountBalance / Row.UsefulLife * Row.Rate;
		EndIf;
		
		If Amount > Row.AmountBalance Then
			Row.Amount = Row.AmountBalance;
		Else
			Row.Amount = Amount;
		EndIf;
		
	EndDo;
		
	Return QueryTable;
EndFunction

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
		|	Calculations.Period,
		|	Calculations.Key AS RowKey,
		|	Calculations.Ref.Company.LandedCostCurrencyMovementType.Currency AS Currency,
		|	Calculations.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DepreciationCalculation_DR_DepreciationFixedAsset_CR_R8510B_BookValueOfFixedAsset) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Calculations AS Calculations
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	Calculations.Period,
		|	Calculations.Key AS RowKey,
		|	Calculations.Ref.Company.LandedCostCurrencyMovementType.Currency AS Currency,
		|	Calculations.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	Calculations AS Calculations
		|WHERE
		|	TRUE";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.DepreciationCalculation_DR_DepreciationFixedAsset_CR_R8510B_BookValueOfFixedAsset Then
		
		Return GetAnalytics_Depreciation_BookValue(Parameters); // Depreciation - Book value		
	
	ElsIf Parameters.Operation = Operations.DepreciationCalculation_DR_R5022T_Expenses_CR_DepreciationFixedAsset Then
		
		Return GetAnalytics_Expenses_Depreciation(Parameters); // Expenses - Depreciation
	
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Depreciation - Book value
Function GetAnalytics_Depreciation_BookValue(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.RowData.FixedAsset);
	AccountingAnalytics.Debit = Debit.AccountDepreciation;
	
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.RowData.FixedAsset);
	AccountingAnalytics.Credit = Credit.Account;
	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Expenses - Depreciation
Function GetAnalytics_Expenses_Depreciation(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.ExpenseType,
	                                                          Parameters.RowData.ProfitLossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.RowData.FixedAsset);
	AccountingAnalytics.Credit = Credit.AccountDepreciation;
	
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
