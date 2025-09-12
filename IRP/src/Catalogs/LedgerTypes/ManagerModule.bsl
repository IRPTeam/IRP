
#Region RegularAccountingOperations

Function ProfitLostOffset(Company, LedgerType, Ref, Date, DeletionMark, RegisterRecords) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypesPLOffset.FromAccount,
	|	LedgerTypesPLOffset.BalanceType,
	|	LedgerTypesPLOffset.ToAccount,
	|	LedgerTypesPLOffset.BySubAccounts
	|FROM
	|	Catalog.LedgerTypes.PLOffset AS LedgerTypesPLOffset
	|WHERE
	|	LedgerTypesPLOffset.Ref = &LedgerType
	|
	|ORDER BY
	|	LedgerTypesPLOffset.LineNumber";
	
	Query.SetParameter("LedgerType", LedgerType);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	DataTable = AccountingServer.CreateAccountingDataTable();
	
	While QuerySelection.Next() Do
		BalanceTable = GetAccountBalance(Company, LedgerType, Ref, Date, 
			QuerySelection.FromAccount, 
			QuerySelection.BalanceType,
			QuerySelection.BySubAccounts);
		
		ToAccountsTable = GetToAccountsTable(QuerySelection.ToAccount);
		
		AccountIndex = -1;
		For Each BalanceRow In BalanceTable Do
			AccountIndex = AccountIndex + 1;
			If Not ValueIsFilled(BalanceRow.AmountBalance) Then
				Continue;
			EndIf;
			
			Record = DataTable.Add();
			Record.Period  = Date;
			Record.Company = Company;
			Record.LedgerType  = LedgerType;
			
			Record.Amount = BalanceRow.AmountBalance;
			
			If ToAccountsTable.Count()-1 >= AccountIndex Then
				ToAccount = ToAccountsTable[AccountIndex].Ref;
			Else
				ToAccount = ToAccountsTable[ToAccountsTable.Count()-1].Ref;
			EndIf;
			
			FromAccount = BalanceRow.Account;
			
			// Dr ToAccount Cr FromAccount
			If QuerySelection.BalanceType = Enums.AccountingAnalyticTypes.Debit Then
				FillDebit(ToAccount, Record, BalanceRow, FromAccount);
				FillCredit(FromAccount, Record, BalanceRow);
			// Dr FromAccount Cr ToAccount
			Else
				FillDebit(FromAccount, Record, BalanceRow);
				FillCredit(ToAccount, Record, BalanceRow, FromAccount);				
			EndIf;
			
		EndDo;
		
		RegisterRecords.Clear();
		AccountingServer.SetDataRegisterRecords(DataTable, LedgerType, RegisterRecords);
		For Each Record In RegisterRecords Do
			Record.Active = Not DeletionMark;
		EndDo;
		RegisterRecords.Write();
	EndDo;
	
	Return DataTable;
EndFunction
	
Function GetAccountBalance(Company, LedgerType, Ref, Date, Account, BalanceType, BySubAccounts)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BasicBalance.Account AS Account,
	|	BasicBalance.Company AS Company,
	|	BasicBalance.LedgerType AS LedgerType,
	|	BasicBalance.ExtDimension1 AS ExtDimension1,
	|	BasicBalance.ExtDimension2 AS ExtDimension2,
	|	BasicBalance.ExtDimension3 AS ExtDimension3,
	|	BasicBalance.Currency AS Currency,
	|	CASE
	|		WHEN &BalanceType = VALUE(enum.AccountingAnalyticTypes.Debit)
	|			THEN BasicBalance.AmountBalanceDr
	|		WHEN &BalanceType = VALUE(enum.AccountingAnalyticTypes.Credit)
	|			THEN BasicBalance.AmountBalanceCr
	|	END AS AmountBalance,
	|	CASE
	|		WHEN &BalanceType = VALUE(enum.AccountingAnalyticTypes.Debit)
	|			THEN BasicBalance.CurrencyAmountBalanceDr
	|		WHEN &BalanceType = VALUE(enum.AccountingAnalyticTypes.Credit)
	|			THEN BasicBalance.CurrencyAmountBalanceCr
	|	END AS CurrencyAmountBalance,
	|	CASE
	|		WHEN &BalanceType = VALUE(enum.AccountingAnalyticTypes.Debit)
	|			THEN BasicBalance.QuantityBalanceDr
	|		WHEN &BalanceType = VALUE(enum.AccountingAnalyticTypes.Credit)
	|			THEN BasicBalance.QuantityBalanceCr
	|	END AS QuantityBalance
	|FROM
	|	AccountingRegister.Basic.Balance(&BalancePeriod, CASE
	|		WHEN &BySubAccounts
	|			THEN Account IN HIERARCHY (&Account)
	|		ELSE Account = &Account
	|	END,, Company = &Company
	|	AND LedgerType = &LedgerType) AS BasicBalance
	|
	|ORDER BY
	|	BasicBalance.Account.Order";
	
	Query.SetParameter("BalanceType"  , BalanceType);
	Query.SetParameter("Account"      , Account);
	Query.SetParameter("BySubAccounts", BySubAccounts);
	Query.SetParameter("Company"      , Company);
	Query.SetParameter("LedgerType"   , LedgerType);
	Query.SetParameter("Account"      , Account);
	
	Query.SetParameter("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Including));
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

Function GetToAccountsTable(Account)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Basic.Ref AS Ref
	|FROM
	|	ChartOfAccounts.Basic AS Basic
	|WHERE
	|	Basic.Ref IN HIERARCHY (&Account)
	|	AND NOT Basic.NotUsedForRecords
	|
	|ORDER BY
	|	Basic.Order";
	
	Query.SetParameter("Account", Account);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
EndFunction

Procedure FillDebit(Account, Record, Source, MatchAccount = Undefined)
	FillAnalytics("Dr", Account, Record, Source, MatchAccount);
EndProcedure

Procedure FillCredit(Account, Record, Source, MatchAccount = Undefined)
	FillAnalytics("Cr", Account, Record, Source, MatchAccount);
EndProcedure

Procedure FillAnalytics(AccountType, Account, Record, Source, MatchAccount)
	Record["Account" + AccountType] = Account;
	
	If MatchAccount <> Undefined Then
		MatchExtDimType1 = AccountingServer.GetExtDimType_ByNumber(1, MatchAccount);
		MatchExtDimType2 = AccountingServer.GetExtDimType_ByNumber(2, MatchAccount);
		MatchExtDimType3 = AccountingServer.GetExtDimType_ByNumber(3, MatchAccount);
		
		NumberExtDim1 = String(AccountingServer.GetExtDimNumber_ByType(MatchExtDimType1, Account));
		NumberExtDim2 = String(AccountingServer.GetExtDimNumber_ByType(MatchExtDimType2, Account));
		NumberExtDim3 = String(AccountingServer.GetExtDimNumber_ByType(MatchExtDimType3, Account));
		
		If ValueIsFilled(NumberExtDim1) Then
			Record["ExtDim" + AccountType+ "Type"  + String(NumberExtDim1)] = MatchExtDimType1;
			Record["ExtDim" + AccountType+ "Value" + String(NumberExtDim1)] = Source.ExtDimension1;
		EndIf;
		
		If ValueIsFilled(NumberExtDim2) Then
			Record["ExtDim" + AccountType+ "Type"  + String(NumberExtDim2)] = MatchExtDimType2;
			Record["ExtDim" + AccountType+ "Value" + String(NumberExtDim2)] = Source.ExtDimension2;
		EndIf;
		
		If ValueIsFilled(NumberExtDim3) Then
			Record["ExtDim" + AccountType+ "Type"  + String(NumberExtDim3)] = MatchExtDimType3;
			Record["ExtDim" + AccountType+ "Value" + String(NumberExtDim3)] = Source.ExtDimension3;
		EndIf;
	
	Else
		Record["ExtDim" + AccountType + "Type1"] = AccountingServer.GetExtDimType_ByNumber(1, Account);
		Record["ExtDim" + AccountType + "Type2"] = AccountingServer.GetExtDimType_ByNumber(2, Account);
		Record["ExtDim" + AccountType + "Type3"] = AccountingServer.GetExtDimType_ByNumber(3, Account);
				
		Record["ExtDim" + AccountType + "Value1"] = Source.ExtDimension1;
		Record["ExtDim" + AccountType + "Value2"] = Source.ExtDimension2;
		Record["ExtDim" + AccountType + "Value3"] = Source.ExtDimension3;
	EndIf;
				
	Record["Currency" + AccountType] = Source.Currency;
	Record["CurrencyAmount" + AccountType] = Source.CurrencyAmountBalance;
	Record["Quantity" + AccountType] = Source.QuantityBalance;
EndProcedure

#EndRegion