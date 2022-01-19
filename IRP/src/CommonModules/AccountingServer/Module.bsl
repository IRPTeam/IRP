

#Region PurchaseInvoice

#Region Analytics

Function GetAccountingAnalytics_PurchaseInvoice(ObjectData, RowData, Identifier, LadgerType) Export
	Parameters = New Structure();
	Parameters.Insert("ObjectData" , ObjectData);
	Parameters.Insert("RowData"    , RowData);
	Parameters.Insert("Identifier" , Identifier);
	Parameters.Insert("LadgerType" , LadgerType);
	If Upper(Identifier) = Upper("Dr_ItemKeyTBAccounts_Cr_PartnerTBAccounts") Then
		Return GetAccountingAnalytics_PurchaseInvoice_Dr_ItemKeyTBAccounts_Cr_PartnerTBAccounts(Parameters);
	ElsIf Upper(Identifier) = Upper("Dr_PartnerTBAccountsTrn_Cr_PartnerTBAccountsAdv") Then
		Return GetAccountingAnalytics_PurchaseInvoice_Dr_PartnerTBAccountsTrn_Cr_PartnerTBAccountsAdv(Parameters);
	EndIf;
EndFunction

Function GetAccountingAnalytics_PurchaseInvoice_Dr_ItemKeyTBAccounts_Cr_PartnerTBAccounts(Parameters)
	AccountingAnalytics = GetAccountingAnalyticsResult(Parameters);
	
	Period = 
	CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Parameters.ObjectData.Ref, Parameters.ObjectData.Date);

	Debit = GetItemKeyTBAccounts(Period, Parameters.ObjectData.Company, Parameters.RowData.ItemKey);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	
	// Debit - Analytics
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimension = 
			GetDebitExtDimension_PurchaseInvoice(Parameters.ObjectData, Parameters.RowData, ExtDim.ExtDimensionType);
			
			ExtDimension.Insert("Key"          , Parameters.RowData.Key);
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LadgerType"   , Parameters.LadgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
	
	Credit = GetPartnerTBAccounts(Period, Parameters.ObjectData.Company, Parameters.ObjectData.Partner, Parameters.ObjectData.Agreement);
	If ValueIsFilled(Credit.AccountTransactions) Then
		AccountingAnalytics.Credit = Credit.AccountTransactions;
	EndIf;
	// Credit - Analytics
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimension = 
			GetCreditExtDimension_PurchaseInvoice(Parameters.ObjectData, Parameters.RowData, ExtDim.ExtDimensionType);
			
			ExtDimension.Insert("Key"          , Parameters.RowData.Key);
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LadgerType"   , Parameters.LadgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
	
	Return AccountingAnalytics;
EndFunction

// by header
Function GetAccountingAnalytics_PurchaseInvoice_Dr_PartnerTBAccountsTrn_Cr_PartnerTBAccountsAdv(Parameters)
	AccountingAnalytics = GetAccountingAnalyticsResult(Parameters);
	
	Period = 
	CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Parameters.ObjectData.Ref, Parameters.ObjectData.Date);

	Accounts = GetPartnerTBAccounts(Period, Parameters.ObjectData.Company, Parameters.ObjectData.Partner, Parameters.ObjectData.Agreement);
	If ValueIsFilled(Accounts.AccountTransactions) Then
		AccountingAnalytics.Debit = Accounts.AccountTransactions;
	EndIf;
	
	// Debit - Analytics
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimension = 
			GetDebitExtDimension_PurchaseInvoice(Parameters.ObjectData, Undefined, ExtDim.ExtDimensionType);
			
			ExtDimension.Insert("Key"          , "");
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LadgerType"   , Parameters.LadgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
	
	If ValueIsFilled(Accounts.AccountAdvances) Then
		AccountingAnalytics.Credit = Accounts.AccountAdvances;
	EndIf;
	// Credit - Analytics
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimension = 
			GetCreditExtDimension_PurchaseInvoice(Parameters.ObjectData, Undefined, ExtDim.ExtDimensionType);
			
			ExtDimension.Insert("Key"          , "");
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LadgerType"   , Parameters.LadgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
	
	Return AccountingAnalytics;
EndFunction

Function GetDebitExtDimension_PurchaseInvoice(ObjectData, RowData, ExtDimensionType)
	ArrayOfTypes = ExtDimensionType.ValueType.Types();
	If RowData <> Undefined And ArrayOfTypes.Find(Type("CatalogRef.ItemKeys")) <> Undefined Then
		Return RowData.ItemKey;
	ElsIf RowData <> Undefined And ArrayOfTypes.Find(Type("CatalogRef.Stores")) <> Undefined Then
		Return RowData.Store;
	ElsIf ArrayOfTypes.Find(Type("CatalogRef.Partners")) <> Undefined Then
		Return ObjectData.Partner;
	ElsIf ArrayOfTypes.Find(Type("CatalogRef.Agreements")) <> Undefined Then
		Return ObjectData.Agreement;
	EndIf;
	Return Undefined;
EndFunction

Function GetCreditExtDimension_PurchaseInvoice(ObjectData, RowData, ExtDimensionType)
	ArrayOfTypes = ExtDimensionType.ValueType.Types();
	If ArrayOfTypes.Find(Type("CatalogRef.Partners")) <> Undefined Then
		Return ObjectData.Partner;
	ElsIf ArrayOfTypes.Find(Type("CatalogRef.Agreements")) <> Undefined Then
		Return ObjectData.Agreement;
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region Data

Function GetDataByAccountingAnalytics_PurchaseInvoice(DocRef, RowData) Export
	If Not ValueIsFilled(RowData.AccountDebit) Or Not ValueIsFilled(RowData.AccountCredit) Then
		Return GetAccountingDataResult();
	EndIf;

	Data = Undefined;
	If Upper(RowData.Identifier) = Upper("Dr_ItemKeyTBAccounts_Cr_PartnerTBAccounts") Then
		Parameters = New Structure();
		Parameters.Insert("Recorder" , DocRef);
		Parameters.Insert("RowKey"   , RowData.Key);
		Parameters.Insert("CurrencyMovementType", RowData.LadgerType.CurrencyMovementType);
		
		Data = GetDataByAccountingAnalytics_PurchaseInvoice_Dr_ItemKeyTBAccounts_Cr_PartnerTBAccounts(Parameters);
	ElsIf Upper(RowData.Identifier) = Upper("Dr_PartnerTBAccountsTrn_Cr_PartnerTBAccountsAdv") Then
		Parameters = New Structure();
		Parameters.Insert("Recorder" , DocRef);
		Parameters.Insert("CurrencyMovementType", RowData.LadgerType.CurrencyMovementType);
		
		Data = GetDataByAccountingAnalytics_PurchaseInvoice_Dr_PartnerTBAccountsTrn_Cr_PartnerTBAccountsAdv(Parameters);
	EndIf;
	
	Return FillAccountingDataResult(Data);
EndFunction

Function GetDataByAccountingAnalytics_PurchaseInvoice_Dr_ItemKeyTBAccounts_Cr_PartnerTBAccounts(Parameters)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T1040T_AccountingAmounts.Currency,
	|	SUM(T1040T_AccountingAmounts.NetAmount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.Recorder = &Recorder
	|	AND T1040T_AccountingAmounts.RowKey = &RowKey
	|	AND
	|		T1040T_AccountingAmounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	T1040T_AccountingAmounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(T1040T_AccountingAmounts.NetAmount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.Recorder = &Recorder
	|	AND T1040T_AccountingAmounts.RowKey = &RowKey
	|	AND T1040T_AccountingAmounts.CurrencyMovementType = &CurrencyMovementType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(T1050T_AccountingQuantities.Quantity) AS Quantity
	|FROM
	|	AccumulationRegister.T1050T_AccountingQuantities AS T1050T_AccountingQuantities
	|WHERE
	|	T1050T_AccountingQuantities.Recorder = &Recorder
	|	AND T1050T_AccountingQuantities.RowKey = &RowKey";
	
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("RowKey"               , Parameters.RowKey);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	Endif;
	
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	Endif;
	
	QuerySelection = QueryResults[2].Select();
	If QuerySelection.Next() Then
		Result.QuantityCr = QuerySelection.Quantity;
		Result.QuantityDr = QuerySelection.Quantity;
	Endif;
	
	Return Result;
EndFunction

Function GetDataByAccountingAnalytics_PurchaseInvoice_Dr_PartnerTBAccountsTrn_Cr_PartnerTBAccountsAdv(Parameters)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T1040T_AccountingAmounts.Currency,
	|	SUM(T1040T_AccountingAmounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.Recorder = &Recorder
	|	AND T1040T_AccountingAmounts.IsAdvanceClosing
	|	AND
	|		T1040T_AccountingAmounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	T1040T_AccountingAmounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(T1040T_AccountingAmounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.Recorder = &Recorder
	|	AND T1040T_AccountingAmounts.IsAdvanceClosing
	|	AND T1040T_AccountingAmounts.CurrencyMovementType = &CurrencyMovementType";
	
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	Endif;
	
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	Endif;
	
	Return Result;
EndFunction

#EndRegion

#EndRegion

#Region BankPayment

#Region Analytics

Function GetAccountingAnalytics_BankPayment(ObjectData, RowData, Identifier, LadgerType) Export
	Parameters = New Structure();
	Parameters.Insert("ObjectData" , ObjectData);
	Parameters.Insert("RowData"    , RowData);
	Parameters.Insert("Identifier" , Identifier);
	Parameters.Insert("LadgerType" , LadgerType);
	If Upper(Identifier) = Upper("Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts") Then
		Return GetAccountingAnalytics_BankPayment_Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts(Parameters);
	EndIf;
EndFunction

Function GetAccountingAnalytics_BankPayment_Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts(Parameters)
	AccountingAnalytics = GetAccountingAnalyticsResult(Parameters);
	
	Period = 
	CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Parameters.ObjectData.Ref, Parameters.ObjectData.Date);

	Debit = GetPartnerTBAccounts(Period, Parameters.ObjectData.Company, Parameters.RowData.Partner, Parameters.RowData.Agreement);
	IsAdvance = IsAdvance(Parameters.RowData);
	If IsAdvance Then
		If ValueIsFilled(Debit.AccountAdvances) Then
			AccountingAnalytics.Debit = Debit.AccountAdvances;
		EndIf;
	Else
		If ValueIsFilled(Debit.AccountTransactions) Then
			AccountingAnalytics.Debit = Debit.AccountTransactions;
		EndIf;
	EndIf;
	// Debit - Analytics
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimension = 
			GetDebitExtDimension_BankPayment(Parameters.ObjectData, Parameters.RowData, ExtDim.ExtDimensionType);
			
			ExtDimension.Insert("Key"          , Parameters.RowData.Key);
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LadgerType"   , Parameters.LadgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
	
	
	Credit = GetCashAccountTBAccounts(Period, Parameters.ObjectData.Company, Parameters.ObjectData.Account);
	If ValueIsFilled(Credit.Account) Then
		AccountingAnalytics.Credit = Credit.Account;
	EndIf;
	// Credit - Analytics
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ExtDimension.ExtDimension = 
			GetCreditExtDimension_BankPayment(Parameters.ObjectData, Parameters.RowData, ExtDim.ExtDimensionType);
			
			ExtDimension.Insert("Key"          , Parameters.RowData.Key);
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LadgerType"   , Parameters.LadgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
	
	Return AccountingAnalytics;
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

Function GetCreditExtDimension_BankPayment(ObjectData, RowData, ExtDimensionType)
	ArrayOfTypes = ExtDimensionType.ValueType.Types();
	If ArrayOfTypes.Find(Type("CatalogRef.CashAccounts")) <> Undefined Then
		Return ObjectData.Account;
	EndIf;
	Return Undefined;
EndFunction

#EndRegion

#Region Data

Function GetDataByAccountingAnalytics_BankPayment(DocRef, RowData) Export
	If Not ValueIsFilled(RowData.AccountDebit) Or Not ValueIsFilled(RowData.AccountCredit) Then
		Return GetAccountingDataResult();
	EndIf;

	Data = Undefined;
	If Upper(RowData.Identifier) = Upper("Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts") Then
		Parameters = New Structure();
		Parameters.Insert("Recorder" , DocRef);
		Parameters.Insert("RowKey"   , RowData.Key);
		Parameters.Insert("CurrencyMovementType", RowData.LadgerType.CurrencyMovementType);
		
		Data = GetDataByAccountingAnalytics_BankPayment_Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts(Parameters);
	EndIf;
	Return FillAccountingDataResult(Data);
EndFunction

Function GetDataByAccountingAnalytics_BankPayment_Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts(Parameters)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T1040T_AccountingAmounts.Currency,
	|	SUM(T1040T_AccountingAmounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.Recorder = &Recorder
	|	AND T1040T_AccountingAmounts.RowKey = &RowKey
	|	AND
	|		T1040T_AccountingAmounts.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	T1040T_AccountingAmounts.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(T1040T_AccountingAmounts.Amount) AS Amount
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.Recorder = &Recorder
	|	AND T1040T_AccountingAmounts.RowKey = &RowKey
	|	AND T1040T_AccountingAmounts.CurrencyMovementType = &CurrencyMovementType";
	
	Query.SetParameter("Recorder"             , Parameters.Recorder);
	Query.SetParameter("RowKey"               , Parameters.RowKey);
	Query.SetParameter("CurrencyMovementType" , Parameters.CurrencyMovementType);
	
	QueryResults = Query.ExecuteBatch();
	
	Result = GetAccountingDataResult();
	
	QuerySelection = QueryResults[0].Select();
	If QuerySelection.Next() Then
		Result.CurrencyDr       = QuerySelection.Currency;
		Result.CurrencyAmountDr = QuerySelection.Amount;
		Result.CurrencyCr       = QuerySelection.Currency;
		Result.CurrencyAmountCr = QuerySelection.Amount;
	Endif;
	
	QuerySelection = QueryResults[1].Select();
	If QuerySelection.Next() Then
		Result.Amount = QuerySelection.Amount;
	Endif;
	
	Return Result;
EndFunction

#EndRegion

#EndRegion

#Region Service

Function GetAccountingAnalyticsResult(Parameters)
	AccountingAnalytics = New Structure();
	AccountingAnalytics.Insert("Identifier", Parameters.Identifier);
	AccountingAnalytics.Insert("LadgerType", Parameters.LadgerType);
	
	// Debit - PartnerTBAccounts
	AccountingAnalytics.Insert("Debit", Undefined);
	AccountingAnalytics.Insert("DebitExtDimensions", New Array());
	
	// Credit - CashAccountTBAccounts
	AccountingAnalytics.Insert("Credit", Undefined);
	AccountingAnalytics.Insert("CreditExtDimensions", New Array());
	Return AccountingAnalytics;
EndFunction

Function GetAccountingDataResult()
	Result = New Structure();
	Result.Insert("CurrencyDr", Undefined);
	Result.Insert("CurrencyAmountDr", 0);
	Result.Insert("CurrencyCr", Undefined);
	Result.Insert("CurrencyAmountCr", 0);
	
	Result.Insert("QuantityDr", 0);
	Result.Insert("QuantityCr", 0);
	
	Result.Insert("Amount", 0);
	Return Result;
EndFunction

Function FillAccountingDataResult(Data)
	Result = GetAccountingDataResult();
	If Data <> Undefined Then
		If Data.Property("CurrencyDr") Then
			Result.CurrencyDr = Data.CurrencyDr;
		EndIf;
		
		If Data.Property("CurrencyAmountDr") Then
			Result.CurrencyAmountDr = Data.CurrencyAmountDr;
		EndIf;
		
		If Data.Property("CurrencyCr") Then
			Result.CurrencyCr = Data.CurrencyCr;
		EndIf;
		
		If Data.Property("CurrencyAmountCr") Then
			Result.CurrencyAmountCr = Data.CurrencyAmountCr;
		EndIf;
		
		If Data.Property("QuantityDr") Then
			Result.QuantityDr = Data.QuantityDr;
		EndIf;
		
		If Data.Property("QuantityCr") Then
			Result.QuantityCr = Data.QuantityCr;
		EndIf;
		
		If Data.Property("Amount") Then
			Result.Amount = Data.Amount;
		EndIf;
	EndIf;
	Return Result;
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

Function GetItemKeyTBAccounts(Period, Company, ItemKey)
	Query = New Query();
	Query.Text =
	"SELECT
	|	ByItemKey.Account,
	|	ByItemKey.Company,
	|	ByItemKey.ItemKey,
	|	ByItemKey.Item,
	|	ByItemKey.ItemType,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.ItemKeyTBAccounts.SliceLast(&Period, Company = &Company
	|	AND ItemKey = &ItemKey
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL) AS ByItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	ByItem.Account,
	|	ByItem.Company,
	|	ByItem.ItemKey,
	|	ByItem.Item,
	|	ByItem.ItemType,
	|	2
	|FROM
	|	InformationRegister.ItemKeyTBAccounts.SliceLast(&Period, Company = &Company
	|	AND ItemKey.Ref IS NULL
	|	AND Item = &Item
	|	AND ItemType.Ref IS NULL) AS ByItem
	|
	|UNION ALL
	|
	|SELECT
	|	ByItemType.Account,
	|	ByItemType.Company,
	|	ByItemType.ItemKey,
	|	ByItemType.Item,
	|	ByItemType.ItemType,
	|	3
	|FROM
	|	InformationRegister.ItemKeyTBAccounts.SliceLast(&Period, Company = &Company
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType = &ItemType) AS ByItemType
	|
	|UNION ALL
	|
	|SELECT
	|	ByItemType.Account,
	|	ByItemType.Company,
	|	ByItemType.ItemKey,
	|	ByItemType.Item,
	|	ByItemType.ItemType,
	|	4
	|FROM
	|	InformationRegister.ItemKeyTBAccounts.SliceLast(&Period, Company = &Company
	|	AND ItemKey.Ref IS NULL
	|	AND Item.Ref IS NULL
	|	AND ItemType.Ref IS NULL) AS ByItemType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("ItemKey"  , ItemKey);
	Query.SetParameter("Item"     , ItemKey.Item);
	Query.SetParameter("ItemType" , ItemKey.Item.ItemType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region LadgerTypeOperations

Function GetAccountingOperationsByLadgerType(Period, LadgerType) Export
	Query = New Query();
	Query.Text = "";
	
EndFunction

#EndRegion




