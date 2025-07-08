
Function CheckBalance(Ref, CurrentRecords, ExistsRecords, Unposting, AddInfo = Undefined) Export
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
	|	CurrentRecords.OtherPeriodRevenueType,
	|	CurrentRecords.RevenueType,
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
	|	ExistsRecords.OtherPeriodRevenueType,
	|	ExistsRecords.RevenueType,
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
	|	CurrentRecords.OtherPeriodRevenueType,
	|	CurrentRecords.RevenueType,
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
	|	ExistsRecords.OtherPeriodRevenueType,
	|	ExistsRecords.RevenueType,
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
	|	AllRecords.OtherPeriodRevenueType,
	|	AllRecords.RevenueType,
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
	|	AllRecords.OtherPeriodRevenueType,
	|	AllRecords.RevenueType,
	|	AllRecords.ProfitLossCenter,
	|	AllRecords.CurrencyMovementType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6080T_OtherPeriodsRevenuesBalance.Company,
	|	R6080T_OtherPeriodsRevenuesBalance.Branch,
	|	R6080T_OtherPeriodsRevenuesBalance.RowID,
	|	R6080T_OtherPeriodsRevenuesBalance.Basis,
	|	R6080T_OtherPeriodsRevenuesBalance.ItemKey,
	|	R6080T_OtherPeriodsRevenuesBalance.Currency,
	|	R6080T_OtherPeriodsRevenuesBalance.OtherPeriodRevenueType,
	|	R6080T_OtherPeriodsRevenuesBalance.RevenueType,
	|	R6080T_OtherPeriodsRevenuesBalance.ProfitLossCenter,
	|	R6080T_OtherPeriodsRevenuesBalance.CurrencyMovementType,
	|	-R6080T_OtherPeriodsRevenuesBalance.AmountBalance AS LackOfBalance
	|FROM
	|	AccumulationRegister.R6080T_OtherPeriodsRevenues.Balance(, (Company, Branch, RowID, Basis, ItemKey, Currency,
	|		OtherPeriodRevenueType, RevenueType, ProfitLossCenter, CurrencyMovementType) IN
	|		(SELECT
	|			GroupedRecords.Company,
	|			GroupedRecords.Branch,
	|			GroupedRecords.RowID,
	|			GroupedRecords.Basis,
	|			GroupedRecords.ItemKey,
	|			GroupedRecords.Currency,
	|			GroupedRecords.OtherPeriodRevenueType,
	|			GroupedRecords.RevenueType,
	|			GroupedRecords.ProfitLossCenter,
	|			GroupedRecords.CurrencyMovementType
	|		FROM
	|			GroupedRecords AS GroupedRecords)) AS R6080T_OtherPeriodsRevenuesBalance
	|		INNER JOIN GroupedRecords AS GroupedRecords
	|		ON R6080T_OtherPeriodsRevenuesBalance.Company = GroupedRecords.Company
	|		AND R6080T_OtherPeriodsRevenuesBalance.Branch = GroupedRecords.Branch
	|		AND R6080T_OtherPeriodsRevenuesBalance.RowID = GroupedRecords.RowID
	|		AND R6080T_OtherPeriodsRevenuesBalance.Basis = GroupedRecords.Basis
	|		AND R6080T_OtherPeriodsRevenuesBalance.ItemKey = GroupedRecords.ItemKey
	|		AND R6080T_OtherPeriodsRevenuesBalance.Currency = GroupedRecords.Currency
	|		AND R6080T_OtherPeriodsRevenuesBalance.OtherPeriodRevenueType = GroupedRecords.OtherPeriodRevenueType
	|		AND R6080T_OtherPeriodsRevenuesBalance.RevenueType = GroupedRecords.RevenueType
	|		AND R6080T_OtherPeriodsRevenuesBalance.ProfitLossCenter = GroupedRecords.ProfitLossCenter
	|		AND R6080T_OtherPeriodsRevenuesBalance.CurrencyMovementType = GroupedRecords.CurrencyMovementType
	|WHERE
	|	R6080T_OtherPeriodsRevenuesBalance.AmountBalance < 0";
	
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