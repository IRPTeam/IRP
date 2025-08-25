
Function CheckBalance(Ref, CurrentRecords, ExistsRecords, Unposting, AddInfo = Undefined) Export
	
	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R6070T_OtherPeriodsExpenses", True) Then
		Return True;
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text = 
	"SELECT
	|	CurrentRecords.Company,
	|	CurrentRecords.Branch,
	|	CurrentRecords.RowID,
	|	CurrentRecords.Basis,
	|	CurrentRecords.ItemKey,
	|	CurrentRecords.Currency,
	|	CurrentRecords.OtherPeriodExpenseType,
	|	CurrentRecords.ExpenseType,
	|	CurrentRecords.ProfitLossCenter,
	|	VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency) AS CurrencyMovementType
	|INTO CurrentRecords
	|FROM
	|	&CurrentRecords AS CurrentRecords
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ExistsRecords.Company,
	|	ExistsRecords.Branch,
	|	ExistsRecords.RowID,
	|	ExistsRecords.Basis,
	|	ExistsRecords.ItemKey,
	|	ExistsRecords.Currency,
	|	ExistsRecords.OtherPeriodExpenseType,
	|	ExistsRecords.ExpenseType,
	|	ExistsRecords.ProfitLossCenter,
	|	ExistsRecords.CurrencyMovementType
	|INTO ExistsRecords
	|FROM
	|	&ExistsRecords AS ExistsRecords
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CurrentRecords.Company,
	|	CurrentRecords.Branch,
	|	CurrentRecords.RowID,
	|	CurrentRecords.Basis,
	|	CurrentRecords.ItemKey,
	|	CurrentRecords.Currency,
	|	CurrentRecords.OtherPeriodExpenseType,
	|	CurrentRecords.ExpenseType,
	|	CurrentRecords.ProfitLossCenter,
	|	CurrentRecords.CurrencyMovementType
	|INTO AllRecords
	|FROM
	|	CurrentRecords AS CurrentRecords
	|WHERE
	|	NOT &Unposting
	|
	|UNION ALL
	|
	|SELECT
	|	ExistsRecords.Company,
	|	ExistsRecords.Branch,
	|	ExistsRecords.RowID,
	|	ExistsRecords.Basis,
	|	ExistsRecords.ItemKey,
	|	ExistsRecords.Currency,
	|	ExistsRecords.OtherPeriodExpenseType,
	|	ExistsRecords.ExpenseType,
	|	ExistsRecords.ProfitLossCenter,
	|	ExistsRecords.CurrencyMovementType
	|FROM
	|	ExistsRecords AS ExistsRecords
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllRecords.Company,
	|	AllRecords.Branch,
	|	AllRecords.RowID,
	|	AllRecords.Basis,
	|	AllRecords.ItemKey,
	|	AllRecords.Currency,
	|	AllRecords.OtherPeriodExpenseType,
	|	AllRecords.ExpenseType,
	|	AllRecords.ProfitLossCenter,
	|	AllRecords.CurrencyMovementType
	|INTO GroupedRecords
	|FROM
	|	AllRecords AS AllRecords
	|WHERE
	|	AllRecords.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	AllRecords.Company,
	|	AllRecords.Branch,
	|	AllRecords.RowID,
	|	AllRecords.Basis,
	|	AllRecords.ItemKey,
	|	AllRecords.Currency,
	|	AllRecords.OtherPeriodExpenseType,
	|	AllRecords.ExpenseType,
	|	AllRecords.ProfitLossCenter,
	|	AllRecords.CurrencyMovementType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6070T_OtherPeriodsExpensesBalance.Company,
	|	R6070T_OtherPeriodsExpensesBalance.Branch,
	|	R6070T_OtherPeriodsExpensesBalance.RowID,
	|	R6070T_OtherPeriodsExpensesBalance.Basis,
	|	R6070T_OtherPeriodsExpensesBalance.ItemKey,
	|	R6070T_OtherPeriodsExpensesBalance.Currency,
	|	R6070T_OtherPeriodsExpensesBalance.OtherPeriodExpenseType,
	|	R6070T_OtherPeriodsExpensesBalance.ExpenseType,
	|	R6070T_OtherPeriodsExpensesBalance.ProfitLossCenter,
	|	R6070T_OtherPeriodsExpensesBalance.CurrencyMovementType,
	|	-R6070T_OtherPeriodsExpensesBalance.AmountBalance AS LackOfBalance
	|FROM
	|	AccumulationRegister.R6070T_OtherPeriodsExpenses.Balance(, (Company, Branch, RowID, Basis, ItemKey, Currency,
	|		OtherPeriodExpenseType, ExpenseType, ProfitLossCenter, CurrencyMovementType) IN
	|		(SELECT
	|			GroupedRecords.Company,
	|			GroupedRecords.Branch,
	|			GroupedRecords.RowID,
	|			GroupedRecords.Basis,
	|			GroupedRecords.ItemKey,
	|			GroupedRecords.Currency,
	|			GroupedRecords.OtherPeriodExpenseType,
	|			GroupedRecords.ExpenseType,
	|			GroupedRecords.ProfitLossCenter,
	|			GroupedRecords.CurrencyMovementType
	|		FROM
	|			GroupedRecords AS GroupedRecords)) AS R6070T_OtherPeriodsExpensesBalance
	|		INNER JOIN GroupedRecords AS GroupedRecords
	|		ON R6070T_OtherPeriodsExpensesBalance.Company = GroupedRecords.Company
	|		AND R6070T_OtherPeriodsExpensesBalance.Branch = GroupedRecords.Branch
	|		AND R6070T_OtherPeriodsExpensesBalance.RowID = GroupedRecords.RowID
	|		AND R6070T_OtherPeriodsExpensesBalance.Basis = GroupedRecords.Basis
	|		AND R6070T_OtherPeriodsExpensesBalance.ItemKey = GroupedRecords.ItemKey
	|		AND R6070T_OtherPeriodsExpensesBalance.Currency = GroupedRecords.Currency
	|		AND R6070T_OtherPeriodsExpensesBalance.OtherPeriodExpenseType = GroupedRecords.OtherPeriodExpenseType
	|		AND R6070T_OtherPeriodsExpensesBalance.ExpenseType = GroupedRecords.ExpenseType
	|		AND R6070T_OtherPeriodsExpensesBalance.ProfitLossCenter = GroupedRecords.ProfitLossCenter
	|		AND R6070T_OtherPeriodsExpensesBalance.CurrencyMovementType = GroupedRecords.CurrencyMovementType
	|WHERE
	|	R6070T_OtherPeriodsExpensesBalance.AmountBalance < 0";
	
	Query.SetParameter("CurrentRecords", CurrentRecords);
	Query.SetParameter("ExistsRecords", ExistsRecords);
	Query.SetParameter("Unposting", Unposting);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	Error = False;
	While QuerySelection.Next() Do
		Error = True;
		Message = StrTemplate(R().Error_183, QuerySelection.Basis, QuerySelection.Currency, QuerySelection.LackOfBalance);
		CommonFunctionsClientServer.ShowUsersMessage(Message);
	EndDo;
	Return Not Error;
EndFunction

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure