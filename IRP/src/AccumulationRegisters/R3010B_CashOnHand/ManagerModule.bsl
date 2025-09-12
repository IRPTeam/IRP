
Function GetLockFieldNames() Export
	Return "Company, Branch, Account, Currency";
EndFunction

Function CheckBalance(Ref, CurrentRecords, ExistsRecords, Unposting, AddInfo = Undefined) Export
	
	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R3010B_CashOnHand", True) Then
		Return True;
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text = 
	"SELECT
	|	CurrentRecords.Company,
	|	CurrentRecords.Branch,
	|	CurrentRecords.Account,
	|	CurrentRecords.Currency,
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
	|	ExistsRecords.Account,
	|	ExistsRecords.Currency,
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
	|	CurrentRecords.Account,
	|	CurrentRecords.Currency,
	|	CurrentRecords.CurrencyMovementType
	|INTO AllRecords
	|FROM
	|	CurrentRecords AS CurrentRecords
	|WHERE
	|	NOT &Unposting
	|UNION ALL
	|
	|SELECT
	|	ExistsRecords.Company,
	|	ExistsRecords.Branch,
	|	ExistsRecords.Account,
	|	ExistsRecords.Currency,
	|	ExistsRecords.CurrencyMovementType
	|FROM
	|	ExistsRecords AS ExistsRecords
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllRecords.Company,
	|	AllRecords.Branch,
	|	AllRecords.Account,
	|	AllRecords.Currency,
	|	AllRecords.CurrencyMovementType
	|INTO GroupedRecords
	|FROM
	|	AllRecords AS AllRecords
	|WHERE
	|	AllRecords.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND AllRecords.Account.NegativeBalanceControl
	|GROUP BY
	|	AllRecords.Company,
	|	AllRecords.Branch,
	|	AllRecords.Account,
	|	AllRecords.Currency,
	|	AllRecords.CurrencyMovementType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R3010B_CashOnHandBalance.Company,
	|	R3010B_CashOnHandBalance.Branch,
	|	R3010B_CashOnHandBalance.Account,
	|	R3010B_CashOnHandBalance.Currency,
	|	R3010B_CashOnHandBalance.CurrencyMovementType,
	|	-R3010B_CashOnHandBalance.AmountBalance AS LackOfBalance
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.Balance(, (Company, Branch, Account, Currency, CurrencyMovementType) IN
	|		(SELECT
	|			GroupedRecords.Company,
	|			GroupedRecords.Branch,
	|			GroupedRecords.Account,
	|			GroupedRecords.Currency,
	|			GroupedRecords.CurrencyMovementType
	|		FROM
	|			GroupedRecords AS GroupedRecords)) AS R3010B_CashOnHandBalance
	|		INNER JOIN GroupedRecords AS GroupedRecords
	|		ON R3010B_CashOnHandBalance.Company = GroupedRecords.Company
	|		AND R3010B_CashOnHandBalance.Branch = GroupedRecords.Branch
	|		AND R3010B_CashOnHandBalance.Account = GroupedRecords.Account
	|		AND R3010B_CashOnHandBalance.Currency = GroupedRecords.Currency
	|		AND R3010B_CashOnHandBalance.CurrencyMovementType = GroupedRecords.CurrencyMovementType
	|WHERE
	|	R3010B_CashOnHandBalance.AmountBalance < 0";
	
	Query.SetParameter("CurrentRecords", CurrentRecords);
	Query.SetParameter("ExistsRecords", ExistsRecords);
	Query.SetParameter("Unposting", Unposting);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	Error = False;
	While QuerySelection.Next() Do
		Error = True;
		Message = StrTemplate(R().Error_182, QuerySelection.Account, QuerySelection.Currency, QuerySelection.LackOfBalance);
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
// * Account - CatalogRef.CashAccounts -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	AccessKeyStructure.Insert("Account", Catalogs.CashAccounts.EmptyRef());
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