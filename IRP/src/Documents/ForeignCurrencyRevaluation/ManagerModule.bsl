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
	
	Query = New Query();
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
	|	Reg.AmountBalance AS Amount
	|INTO _R2020B_AdvancesFromCustomers
	|FROM
	|	AccumulationRegister.R2020B_AdvancesFromCustomers.Balance(&Period, Company = &Company
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
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R1021B_VendorsTransactions AS Reg
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
	|	Reg.TransactionCurrency,
	|	Reg.Currency,
	|	Reg.Source
	|FROM
	|	_R2021B_CustomersTransactions AS Reg
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
	
	Query.SetParameter("Period"          , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("PeriodSliceLast" , DocumentDate);
	Query.SetParameter("Company"         , Ref.Company);
	Query.Execute();
	
	CurrencyRates = Parameters.TempTablesManager.Tables.Find("CurrencyRates").GetData().Unload();
	
	AccRegMetadata = Metadata.AccumulationRegisters.R5022T_Expenses;
	ExpensesTable = New ValueTable();
	ExpensesTable.Columns.Add("Period"              , AccRegMetadata.StandardAttributes.Period.Type);
	ExpensesTable.Columns.Add("Company"             , AccRegMetadata.Dimensions.Company.Type);
	ExpensesTable.Columns.Add("Branch"              , AccRegMetadata.Dimensions.Branch.Type);
	ExpensesTable.Columns.Add("ProfitLossCenter"    , AccRegMetadata.Dimensions.ProfitLossCenter.Type);
	ExpensesTable.Columns.Add("ExpenseType"         , AccRegMetadata.Dimensions.ExpenseType.Type);
	ExpensesTable.Columns.Add("Currency"            , AccRegMetadata.Dimensions.Currency.Type);
	ExpensesTable.Columns.Add("AdditionalAnalytic"  , AccRegMetadata.Dimensions.AdditionalAnalytic.Type);
	ExpensesTable.Columns.Add("CurrencyMovementType", AccRegMetadata.Dimensions.CurrencyMovementType.Type);
	ExpensesTable.Columns.Add("Amount"              , AccRegMetadata.Resources.Amount.Type);
	
	AccRegMetadata = Metadata.AccumulationRegisters.R5021T_Revenues;
	RevenuesTable = New ValueTable();
	RevenuesTable.Columns.Add("Period"              , AccRegMetadata.StandardAttributes.Period.Type);
	RevenuesTable.Columns.Add("Company"             , AccRegMetadata.Dimensions.Company.Type);
	RevenuesTable.Columns.Add("Branch"              , AccRegMetadata.Dimensions.Branch.Type);
	RevenuesTable.Columns.Add("ProfitLossCenter"    , AccRegMetadata.Dimensions.ProfitLossCenter.Type);
	RevenuesTable.Columns.Add("RevenueType"         , AccRegMetadata.Dimensions.RevenueType.Type);
	RevenuesTable.Columns.Add("Currency"            , AccRegMetadata.Dimensions.Currency.Type);
	RevenuesTable.Columns.Add("AdditionalAnalytic"  , AccRegMetadata.Dimensions.AdditionalAnalytic.Type);
	RevenuesTable.Columns.Add("CurrencyMovementType", AccRegMetadata.Dimensions.CurrencyMovementType.Type);
	RevenuesTable.Columns.Add("Amount"              , AccRegMetadata.Resources.Amount.Type);
	
	ExpenseRevenueInfo = New Structure();
	ExpenseRevenueInfo.Insert("DocumentDate", DocumentDate);
	
	ExpenseRevenueInfo.Insert("RevenuesTable", RevenuesTable);
	ExpenseRevenueInfo.Insert("Revenue_ProfitLossCenter"   , Ref.RevenueProfitLossCenter);
	ExpenseRevenueInfo.Insert("Revenue_AdditionalAnalytic" , Ref.RevenueAdditionalAnalytic);
	ExpenseRevenueInfo.Insert("RevenueType"                , Ref.RevenueType);
	
	ExpenseRevenueInfo.Insert("ExpensesTable", ExpensesTable);
	ExpenseRevenueInfo.Insert("Expense_ProfitLossCenter"   , Ref.ExpenseProfitLossCenter);
	ExpenseRevenueInfo.Insert("Expense_AdditionalAnalytic" , Ref.ExpenseAdditionalAnalytic);
	ExpenseRevenueInfo.Insert("ExpenseType"                , Ref.ExpenseType);
	
	ArrayOfActives = New Array();
	ArrayOfActives.Add("R1020B_AdvancesToVendors");
	ArrayOfActives.Add("R2021B_CustomersTransactions");
	ArrayOfActives.Add("R3010B_CashOnHand");
	ArrayOfActives.Add("R3015B_CashAdvance");
	ArrayOfActives.Add("R3021B_CashInTransitIncoming");
	ArrayOfActives.Add("R3022B_CashInTransitOutgoing");
	ArrayOfActives.Add("R3027B_EmployeeCashAdvance");
	
	ArrayOfPassives = New Array();
	ArrayOfPassives.Add("R1021B_VendorsTransactions");
	ArrayOfPassives.Add("R2020B_AdvancesFromCustomers");
	ArrayOfPassives.Add("R9510B_SalaryPayment");
	
	ArrayOfOthers = New Array();
	ArrayOfOthers.Add("R3016B_ChequeAndBonds");
	ArrayOfOthers.Add("R6070T_OtherPeriodsExpenses");
	ArrayOfOthers.Add("R6080T_OtherPeriodsRevenues");
	
	RevaluateCurrency(Parameters, ArrayOfActives  , CurrencyRates, "Active"  , ExpenseRevenueInfo);
	RevaluateCurrency(Parameters, ArrayOfPassives , CurrencyRates, "Passive" , ExpenseRevenueInfo);
	RevaluateCurrency(Parameters, ArrayOfOthers   , CurrencyRates, "Others"  , ExpenseRevenueInfo);
	
	CreateVirtualTables(Parameters, ArrayOfActives);
	CreateVirtualTables(Parameters, ArrayOfPassives);
	CreateVirtualTables(Parameters, ArrayOfOthers);
	
	Query.Text = 
	"SELECT * INTO _R5021T_Revenues FROM &RevenuesTable AS Table;
	|SELECT * INTO _R5022T_Expenses FROM &ExpensesTable AS Table;"; 
	Query.SetParameter("RevenuesTable", ExpenseRevenueInfo.RevenuesTable);
	Query.SetParameter("ExpensesTable", ExpenseRevenueInfo.ExpensesTable);
	Query.Execute();
	
	R5022T_Expenses_Metadata = Parameters.Object.RegisterRecords.R5022T_Expenses.Metadata();
	R5021T_Revenues_Metadata = Parameters.Object.RegisterRecords.R5021T_Revenues.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(R5022T_Expenses_Metadata);
		Parameters.MultiCurrencyExcludePostingDataTables.Add(R5021T_Revenues_Metadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array();
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(R5022T_Expenses_Metadata);
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(R5021T_Revenues_Metadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;
	
	Return New Structure();
EndFunction

Procedure RevaluateCurrency(Parameters, ArrayOfRegisterNames, CurrencyRates, RegisterType, ExpenseRevenueInfo)
	For Each RegisterName In ArrayOfRegisterNames Do
		QueryTable = Parameters.TempTablesManager.Tables.Find("_" + RegisterName).GetData().Unload();
				
		DimensionsInfo = CreateDimensionsTableAndFilter(RegisterName);
		
		For Each Row In QueryTable Do
			If Row.CurrencyMovementType <> ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency Then
				Continue;
			EndIf;
			FillPropertyValues(DimensionsInfo.DimensionsFilter, Row);
			
			OtherCurrenciesRows = QueryTable.FindRows(DimensionsInfo.DimensionsFilter);
			For Each OtherCurrencyRow In OtherCurrenciesRows Do
				If OtherCurrencyRow.CurrencyMovementType = ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency Then
					Continue;
				EndIf;
				
				CurrencyRatesFilter = New Structure();
				CurrencyRatesFilter.Insert("CurrencyFrom", OtherCurrencyRow.TransactionCurrency);
				CurrencyRatesFilter.Insert("CurrencyTo"  , OtherCurrencyRow.Currency);
				CurrencyRatesFilter.Insert("Source"      , OtherCurrencyRow.Source);
				
				CurrencyInfo = CurrencyRates.FindRows(CurrencyRatesFilter);
				If CurrencyInfo.Count() > 1 Then
					Raise "CurrencyInfo.Count() > 1"; // some thing is wrong
				EndIf;
				
				If Not CurrencyInfo.Count() Then
					Continue; // currency rate not set
				EndIf;
				
				If Not ValueIsFilled(CurrencyInfo[0].Rate) Or Not ValueIsFilled(CurrencyInfo[0].Multiplicity) Then
					Continue;		
				EndIf;
				
				_IsNegative = False;
				If OtherCurrencyRow.Amount < 0 Then
					_IsNegative = True;
					OtherCurrencyRow.Amount = - OtherCurrencyRow.Amount;
				EndIf;
				
				If Row.Amount < 0 Then
					Row.Amount = - Row.Amount;
				EndIf;
				
				//Row.Amount; -  amount in transaction currency
				AmountRevaluated = (Row.Amount * CurrencyInfo[0].Rate)/ CurrencyInfo[0].Multiplicity;
				
				If AmountRevaluated <> OtherCurrencyRow.Amount Then
					_RecordType = Undefined;
					AmountDifference = 0;
					If AmountRevaluated > OtherCurrencyRow.Amount Then
						_RecordType = AccumulationRecordType.Receipt;
						AmountDifference = AmountRevaluated - OtherCurrencyRow.Amount;
					Else
						_RecordType = AccumulationRecordType.Expense;
						AmountDifference = OtherCurrencyRow.Amount - AmountRevaluated;
					EndIf;
					
					NewRow = DimensionsInfo.DimensionsTable.Add();
					FillPropertyValues(NewRow, OtherCurrencyRow);
					NewRow.RecordType = _RecordType;
					NewRow.Period = ExpenseRevenueInfo.DocumentDate;
					If _IsNegative Then
						NewRow.AmountRevaluated = - AmountDifference;				
					Else
						NewRow.AmountRevaluated = AmountDifference;
					EndIf;
					
					_IsExpense = False;
					_IsRevenue = False;
					
					If RegisterType = "Active" Then
						If AmountRevaluated > OtherCurrencyRow.Amount Then // revenue
							_IsRevenue = True;
						Else // expense
							_IsExpense = True;
						EndIf;
					EndIf;
					
					If RegisterType = "Passive" Then
						If AmountRevaluated > OtherCurrencyRow.Amount Then // expense
							_IsExpense = True;
						Else // revenue
							_IsRevenue = True;
						EndIf;						
					EndIf;
					
					If _IsRevenue Then 
						NewRevenue = ExpenseRevenueInfo.RevenuesTable.Add();
						FillPropertyValues(NewRevenue, NewRow);
						NewRevenue.Period = ExpenseRevenueInfo.DocumentDate;
						NewRevenue.ProfitLossCenter    = ExpenseRevenueInfo.Revenue_ProfitLossCenter;
						NewRevenue.RevenueType         = ExpenseRevenueInfo.RevenueType;
						NewRevenue.AdditionalAnalytic  = ExpenseRevenueInfo.Revenue_AdditionalAnalytic;
						If _IsNegative Then
							NewRevenue.Amount = - AmountDifference;
						Else
							NewRevenue.Amount = AmountDifference;
						EndIf;
					EndIf;
					
					If _IsExpense Then 
						NewExpense = ExpenseRevenueInfo.ExpensesTable.Add();
						FillPropertyValues(NewExpense, NewRow);
						NewExpense.Period = ExpenseRevenueInfo.DocumentDate;
						NewExpense.ProfitLossCenter    = ExpenseRevenueInfo.Expense_ProfitLossCenter;
						NewExpense.ExpenseType         = ExpenseRevenueInfo.ExpenseType;
						NewExpense.AdditionalAnalytic  = ExpenseRevenueInfo.Expense_AdditionalAnalytic;
						If _IsNegative Then
							NewExpense.Amount = - AmountDifference;
						Else
							NewExpense.Amount = AmountDifference;
						EndIf;
					EndIf;
										
				EndIf;
				
			EndDo; // OtherCurrenciesRows
		EndDo; // QueryTable
		
		If DimensionsInfo.DimensionsTable.Count() Then
			Query = New Query();
			Query.TempTablesManager = Parameters.TempTablesManager;
			Query.Text = 
			StrTemplate("SELECT *, DimensionsTable.AmountRevaluated AS Amount INTO %1 FROM &DimensionsTable AS DimensionsTable", "Revaluated_" + RegisterName);
			Query.SetParameter("DimensionsTable", DimensionsInfo.DimensionsTable);
			Query.Execute();
		EndIf;
	EndDo; // ArrayOfRegisterNames
EndProcedure

Procedure CreateVirtualTables(Parameters, ArrayOfRegisterNames)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
	For Each RegisterName In ArrayOfRegisterNames Do
		DimensionsInfo = CreateDimensionsTableAndFilter(RegisterName);
		If Parameters.TempTablesManager.Tables.Find("Revaluated_" + RegisterName) = Undefined Then			
			Query.Text = Query.Text +
			StrTemplate("SELECT * INTO %1 FROM &DimensionsTable AS DimensionsTable; ", "Revaluated_" + RegisterName);
			Query.SetParameter("DimensionsTable", DimensionsInfo.DimensionsTable);
		EndIf;
	EndDo;
	If ValueIsFilled(Query.Text) Then
		Query.Execute();
	EndIf;
EndProcedure

Function CreateDimensionsTableAndFilter(RegisterName)
	DimensionsFilter = New Structure();
	DimensionsTable = New ValueTable();
	For Each Dimension In Metadata.AccumulationRegisters[RegisterName].Dimensions Do
		DimensionsTable.Columns.Add(Dimension.Name, Dimension.Type);
		If Upper(Dimension.Name) = Upper("CurrencyMovementType")
			Or Upper(Dimension.Name) = Upper("Currency") Then
				Continue;
		EndIf;
		DimensionsFilter.Insert(Dimension.Name);
	EndDo;
	DimensionsTable.Columns.Add("AmountRevaluated", Metadata.DefinedTypes.typeAmount.Type);
	DimensionsTable.Columns.Add("RecordType", Metadata.AccumulationRegisters[RegisterName].StandardAttributes.RecordType.Type);
	DimensionsTable.Columns.Add("Period"    , Metadata.AccumulationRegisters[RegisterName].StandardAttributes.Period.Type);
	Result = New Structure();
	Result.Insert("DimensionsTable"  , DimensionsTable);
	Result.Insert("DimensionsFilter" , DimensionsFilter);
	Return Result;
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
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
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

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables(Parameters = Undefined)
	QueryArray = New Array();
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3015B_CashAdvance());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3022B_CashInTransitOutgoing());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(R3016B_ChequeAndBonds());
	QueryArray.Add(R6070T_OtherPeriodsExpenses());
	QueryArray.Add(R6080T_OtherPeriodsRevenues());
	Return QueryArray;
EndFunction

Function R5021T_Revenues()
	Return 
		"SELECT *
		|INTO R5021T_Revenues
		|FROM 
		|	_R5021T_Revenues
		|WHERE
		|	TRUE";	
EndFunction

Function R5022T_Expenses()
	Return 
		"SELECT *
		|INTO R5022T_Expenses
		|FROM 
		|	_R5022T_Expenses
		|WHERE
		|	TRUE";	
EndFunction

Function R1020B_AdvancesToVendors()
	Return 
		"SELECT *
		|INTO R1020B_AdvancesToVendors
		|FROM 
		|	Revaluated_R1020B_AdvancesToVendors
		|WHERE
		|	TRUE";	
EndFunction

Function R1021B_VendorsTransactions()
	Return 
		"SELECT *
		|INTO R1021B_VendorsTransactions
		|FROM 
		|	Revaluated_R1021B_VendorsTransactions
		|WHERE
		|	TRUE";	
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return 
		"SELECT *
		|INTO R2020B_AdvancesFromCustomers
		|FROM 
		|	Revaluated_R2020B_AdvancesFromCustomers
		|WHERE
		|	TRUE";	
EndFunction

Function R2021B_CustomersTransactions()
	Return 
		"SELECT *
		|INTO R2021B_CustomersTransactions
		|FROM 
		|	Revaluated_R2021B_CustomersTransactions
		|WHERE
		|	TRUE";	
EndFunction

Function R3010B_CashOnHand()
	Return 
		"SELECT *
		|INTO R3010B_CashOnHand
		|FROM 
		|	Revaluated_R3010B_CashOnHand
		|WHERE
		|	TRUE";	
EndFunction

Function R3015B_CashAdvance()
	Return 
		"SELECT *
		|INTO R3015B_CashAdvance
		|FROM 
		|	Revaluated_R3015B_CashAdvance
		|WHERE
		|	TRUE";	
EndFunction

Function R3021B_CashInTransitIncoming()
	Return 
		"SELECT *
		|INTO R3021B_CashInTransitIncoming
		|FROM 
		|	Revaluated_R3021B_CashInTransitIncoming
		|WHERE
		|	TRUE";	
EndFunction

Function R3022B_CashInTransitOutgoing()
	Return 
		"SELECT *
		|INTO R3022B_CashInTransitOutgoing
		|FROM 
		|	Revaluated_R3022B_CashInTransitOutgoing
		|WHERE
		|	TRUE";	
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return 
		"SELECT *
		|INTO R3027B_EmployeeCashAdvance
		|FROM 
		|	Revaluated_R3027B_EmployeeCashAdvance
		|WHERE
		|	TRUE";	
EndFunction

Function R9510B_SalaryPayment()
	Return 
		"SELECT *
		|INTO R9510B_SalaryPayment
		|FROM 
		|	Revaluated_R9510B_SalaryPayment
		|WHERE
		|	TRUE";	
EndFunction

Function R3016B_ChequeAndBonds()
	Return 
		"SELECT *
		|INTO R3016B_ChequeAndBonds
		|FROM 
		|	Revaluated_R3016B_ChequeAndBonds
		|WHERE
		|	TRUE";	
EndFunction

Function R6070T_OtherPeriodsExpenses()
	Return 
		"SELECT *
		|INTO R6070T_OtherPeriodsExpenses
		|FROM 
		|	Revaluated_R6070T_OtherPeriodsExpenses
		|WHERE
		|	TRUE";	
EndFunction

Function R6080T_OtherPeriodsRevenues()
	Return 
		"SELECT *
		|INTO R6080T_OtherPeriodsRevenues
		|FROM 
		|	Revaluated_R6080T_OtherPeriodsRevenues
		|WHERE
		|	TRUE";	
EndFunction

