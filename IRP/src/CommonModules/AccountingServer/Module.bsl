
Function GetLadgerTypesByCompany(ObjectData) Export
	If Not ValueIsFilled(ObjectData.Company) Then
		Return New Array();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CompanyLadgerTypesSliceLast.LadgerType
	|FROM
	|	InformationRegister.CompanyLadgerTypes.SliceLast(&Period, Company = &Company) AS CompanyLadgerTypesSliceLast
	|WHERE
	|	CompanyLadgerTypesSliceLast.Use";
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(ObjectData.Ref, ObjectData.Date);
	Query.SetParameter("Period" , Period);
	Query.SetParameter("Company", ObjectData.Company);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfLadgerTypes = QueryTable.UnloadColumn("LadgerType");
	Return ArrayOfLadgerTypes;
EndFunction

#Region BankPayment

Function GetAccountingAnalytics_BankPayment(ObjectData, RowData) Export
	Result = New Array();
	AccountingAnalytics = New Structure();
	Result.Add(AccountingAnalytics);
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(ObjectData.Ref, ObjectData.Date);

	// Dibit - PartnerTBAccounts
	Debit = GetPartnerTBAccounts(Period, ObjectData.Company, RowData.Partner, RowData.Agreement);
	IsAdvance = IsAdvance(RowData);
	If IsAdvance Then
		If ValueIsFilled(Debit.AccountAdvances) Then
			AccountingAnalytics.Insert("Debit", Debit.AccountAdvances);
			AccountingAnalytics.Insert("DebitExtDimensions", New Structure());
			Counter = 1;
			For Each ExtDim In Debit.AccountAdvances.ExtDimensionTypes Do
				ExtDimension = New Structure("ExtDimensionType, ExtDimensionValue");
				ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
				ExtDimension.ExtDimensionValue = GetDebitExtDimension_BankPayment(ObjectData, RowData, ExtDim.ExtDimensionType);
				AccountingAnalytics.DebitExtDimensions.Insert("ExtDimensionDr" + Counter, ExtDimension);
				Counter = Counter + 1;
			EndDo;
		EndIf;
	Else
		If ValueIsFilled(Debit.AccountTransactions) Then
			AccountingAnalytics.Insert("Debit", Debit.AccountAdvances);
			AccountingAnalytics.Insert("DebitExtDimensions", New Structure());
			Counter = 1;
			For Each ExtDim In Debit.AccountTransactions.ExtDimensionTypes Do
				ExtDimension = New Structure("ExtDimensionType, ExtDimensionValue");
				ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
				ExtDimension.ExtDimensionValue = GetDebitExtDimension_BankPayment(ObjectData, RowData, ExtDim.ExtDimensionType);
				AccountingAnalytics.DebitExtDimensions.Insert("ExtDimensionDr" + Counter, ExtDimension);
				Counter = Counter + 1;
			EndDo;
		EndIf;
	EndIf;
	
	// Credit - CashAccountTBAccounts
	Credit = GetCashAccountTBAccounts(Period, ObjectData.Company, ObjectData.Account);
	If ValueIsFilled(Credit.Account) Then
		AccountingAnalytics.Insert("Credit", Credit.Account);
		AccountingAnalytics.Insert("CreditExtDimensions", New Structure());
		Counter = 1;
		For Each ExtDim In Credit.Account.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimensionValue");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimensionValue = GetCreditExtDimension_BankPayment(ObjectData, RowData, ExtDim.ExtDimensionType);
			AccountingAnalytics.CreditExtDimensions.Insert("ExtDimensionCr" + Counter, ExtDimension);
			Counter = Counter + 1;
		EndDo;
	EndIf;
	
	Return Result;
EndFunction

Function GetCreditExtDimension_BankPayment(ObjectData, RowData, ExtDimensionType)
	ArrayOfTypes = ExtDimensionType.ValueType.Types();
	If ArrayOfTypes.Find(Type("CatalogRef.CashAccounts")) <> Undefined Then
		Return ObjectData.Account;
	EndIf;
	Return Undefined;
EndFunction

Function GetDebitExtDimension_BankPayment(ObjectData, RowData, ExtDimensionType)
	ArrayOfTypes = ExtDimensionType.ValueType.Types();
	If ArrayOfTypes.Find(Type("CatalogRef.Partners")) <> Undefined Then
		Return RowData.Partner;
	ElsIf ArrayOfTypes.Find(Type("CatalogRef.Agreements")) <> Undefined Then
		Return RowData.Agreement;
	EndIf;
	Return Undefined;
EndFunction

Function IsAdvance(RowData)
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	If RowData.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments
		And Not ValueIsFilled(RowData.BasisDocument) Then
			Return True;
	EndIf;
	Return False; // IsTransaction
EndFunction

#EndRegion

#Region TBAccounts

Function GetCashAccountTBAccounts(Period, Company, CashAccount)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByCashAccount.Company,
	|	ByCashAccount.CashAccount,
	|	ByCashAccount.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.CashAccountTBAccounts.SliceLast(&Period, Company = &Company
	|	AND CashAccount = &CashAccount) AS ByCashAccount
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.CashAccount,
	|	ByCompany.Account,
	|	2
	|FROM
	|	InformationRegister.CashAccountTBAccounts.SliceLast(&Period, Company = &Company
	|	AND CashAccount.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.CashAccount,
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"      , Period);
	Query.SetParameter("Company"     , Company);
	Query.SetParameter("CashAccount" , CashAccount);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

Function GetPartnerTBAccounts(Period, Company, Partner, Agreement)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByAgreement.Company,
	|	ByAgreement.Partner,
	|	ByAgreement.Agreement,
	|	ByAgreement.AccountAdvances,
	|	ByAgreement.AccountTransactions,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.PartnerTBAccounts.SliceLast(&Period, Company = &Company
	|	AND Agreement = &Agreement
	|	AND Partner.Ref IS NULL) AS ByAgreement
	|
	|UNION ALL
	|
	|SELECT
	|	ByPartner.Company,
	|	ByPartner.Partner,
	|	ByPartner.Agreement,
	|	ByPartner.AccountAdvances,
	|	ByPartner.AccountTransactions,
	|	2
	|FROM
	|	InformationRegister.PartnerTBAccounts.SliceLast(&Period, Company = &Company
	|	AND Partner = &Partner
	|	AND Agreement.Ref IS NULL) AS ByPartner
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.Partner,
	|	ByCompany.Agreement,
	|	ByCompany.AccountAdvances,
	|	ByCompany.AccountTransactions,
	|	3
	|FROM
	|	InformationRegister.PartnerTBAccounts.SliceLast(&Period, Company = &Company
	|	AND Partner.Ref IS NULL
	|	AND Agreement.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.Partner,
	|	Accounts.Agreement,
	|	Accounts.AccountAdvances,
	|	Accounts.AccountTransactions,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"    , Period);
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("Partner"   , Partner);
	Query.SetParameter("Agreement" , Agreement);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure();
	Result.Insert("AccountAdvances"     , Undefined);
	Result.Insert("AccountTransactions" , Undefined);
	If QuerySelection.Next() Then
		Result.AccountAdvances     = QuerySelection.AccountAdvances;
		Result.AccountTransactions = QuerySelection.AccountTransactions;
	EndIf;
	Return Result;
EndFunction

#EndRegion


















