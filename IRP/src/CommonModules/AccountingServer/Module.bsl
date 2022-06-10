
#Region Service

Function GetAccountingAnalyticsResult(Parameters) Export
	AccountingAnalytics = New Structure();
	AccountingAnalytics.Insert("Identifier", Parameters.Identifier);
	AccountingAnalytics.Insert("LedgerType", Parameters.LedgerType);
	
	// Debit - PartnerTBAccounts
	AccountingAnalytics.Insert("Debit", Undefined);
	AccountingAnalytics.Insert("DebitExtDimensions", New Array());
	
	// Credit - CashAccountTBAccounts
	AccountingAnalytics.Insert("Credit", Undefined);
	AccountingAnalytics.Insert("CreditExtDimensions", New Array());
	Return AccountingAnalytics;
EndFunction

Function GetAccountingDataResult() Export
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

Function IsAdvance(RowData) Export
	If Not ValueIsFilled(RowData.Agreement) Then
		Return True;
	EndIf;
	If RowData.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments
		And Not ValueIsFilled(RowData.BasisDocument) Then
			Return True;
	EndIf;
	Return False; // IsTransaction
EndFunction

Function GetDocumentData(Object, TableRow, MainTableName) Export
	Result = New Structure("ObjectData, RowData", New Structure(), New Structure());
	If TableRow <> Undefined Then
		For Each Column In Object.Ref.Metadata().TabularSections[MainTableName].Attributes Do
			Result.RowData.Insert(Column.Name, TableRow[Column.Name]);
		EndDo;
	Else
		Result.RowData.Insert("Key", "");
	EndIf;
	For Each Attr In Object.Ref.Metadata().Attributes Do
		Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
	EndDo;
	For Each Attr In Object.Ref.Metadata().StandardAttributes Do
		Result.ObjectData.Insert(Attr.Name, Object[Attr.Name]);
	EndDo;
	Return Result;
EndFunction

Function GetAccountingAnalytics(Parameters, MetadataName) Export
	Result = Documents[MetadataName].GetAccountingAnalytics(Parameters);
	If Result = Undefined Then
		Raise StrTemplate("Document [%1] not supported accounting operation [%2]", MetadataName, Parameters.Identifier);
	EndIf;
	Return Result;
EndFunction

Procedure SetDebitExtDimensions(Parameters, AccountingAnalytics) Export
	If ValueIsFilled(AccountingAnalytics.Debit) Then
		For Each ExtDim In AccountingAnalytics.Debit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes);
			ExtDimValue = Documents[Parameters.MetadataName].GetDebitExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , Parameters.RowData.Key);
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Debit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.DebitExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Procedure SetCreditExtDimensions(Parameters, AccountingAnalytics) Export
	If ValueIsFilled(AccountingAnalytics.Credit) Then
		For Each ExtDim In AccountingAnalytics.Credit.ExtDimensionTypes Do
			ExtDimension = New Structure("ExtDimensionType, ExtDimension");
			ExtDimension.ExtDimensionType  = ExtDim.ExtDimensionType;
			ArrayOfTypes = ExtDim.ExtDimensionType.ValueType.Types();
			ExtDimValue = ExtractValueByType(Parameters.ObjectData, Parameters.RowData, ArrayOfTypes);
			ExtDimValue = Documents[Parameters.MetadataName].GetCreditExtDimension(Parameters, ExtDim.ExtDimensionType, ExtDimValue);
			ExtDimension.ExtDimension = ExtDimValue;
			ExtDimension.Insert("Key"          , Parameters.RowData.Key);
			ExtDimension.Insert("AnalyticType" , Enums.AccountingAnalyticTypes.Credit);
			ExtDimension.Insert("Identifier"   , Parameters.Identifier);
			ExtDimension.Insert("LedgerType"   , Parameters.LedgerType);
			AccountingAnalytics.CreditExtDimensions.Add(ExtDimension);
		EndDo;
	EndIf;
EndProcedure

Function ExtractValueByType(ObjectData, RowData, ArrayOfTypes)
	For Each KeyValue In RowData Do
		If ArrayOfTypes.Find(TypeOf(RowData[KeyValue.Key])) <> Undefined Then
			Return RowData[KeyValue.Key];
		EndIf;
	EndDo;
	For Each KeyValue In ObjectData Do
		If ArrayOfTypes.Find(TypeOf(ObjectData[KeyValue.Key])) <> Undefined Then
			Return ObjectData[KeyValue.Key];
		EndIf;
	EndDo;
	Return Undefined;
EndFunction

Function GetDataByAccountingAnalytics(BasisRef, RowData) Export
	If Not ValueIsFilled(RowData.AccountDebit) Or Not ValueIsFilled(RowData.AccountCredit) Then
		Return GetAccountingDataResult();
	EndIf;
	Parameters = New Structure();
	Parameters.Insert("Recorder" , BasisRef);
	Parameters.Insert("RowKey"   , RowData.Key);
	Parameters.Insert("Identifier"   , RowData.Identifier);
	Parameters.Insert("CurrencyMovementType", RowData.LedgerType.CurrencyMovementType);
	MetadataName = BasisRef.Metadata().Name;
	Data = Documents[MetadataName].GetAccountingData(Parameters);
	If Data = Undefined Then
		Raise StrTemplate("Document [%1] not supported accounting operation [%2]", MetadataName, Parameters.Identifier);
	EndIf;
	Return FillAccountingDataResult(Data);
EndFunction

Function GetLedgerTypesByCompany(Ref, Date, Company) Export
	If Not ValueIsFilled(Company) Then
		Return New Array();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CompanyLedgerTypesSliceLast.LedgerType
	|FROM
	|	InformationRegister.CompanyLedgerTypes.SliceLast(&Period, Company = &Company) AS CompanyLedgerTypesSliceLast
	|WHERE
	|	CompanyLedgerTypesSliceLast.Use";
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period" , Period);
	Query.SetParameter("Company", Company);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfLedgerTypes = QueryTable.UnloadColumn("LedgerType");
	Return ArrayOfLedgerTypes;
EndFunction

Function GetAccountingOperationsByLedgerType(Ref, Period, LedgerType) Export
	Map = New Map();
	AO = Catalogs.AccountingOperations;
	Map.Insert(AO.BankPayment_Dr_PartnerAccount_Cr_CashAccount              , True);
	Map.Insert(AO.PurchaseInvoice_Dr_ItemKeyAccount_Cr_PartnerAccount       , True);
	Map.Insert(AO.PurchaseInvoice_Dr_PartnerAccountTrn_Cr_PartnerAccountAdv , False);
	
	MetadataName = Ref.Metadata().Name;
	AccountingOperationGroup = Catalogs.AccountingOperations["Document_" + MetadataName];
	Query = New Query();
	Query.Text =
	"SELECT
	|	LedgerTypeOperationsSliceLast.AccountingOperation AS AccountingOperation
	|FROM
	|	InformationRegister.LedgerTypeOperations.SliceLast(&Period, LedgerType = &LedgerType
	|	AND AccountingOperation.Parent = &AccountingOperationGroup) AS LedgerTypeOperationsSliceLast
	|WHERE
	|	LedgerTypeOperationsSliceLast.Use";
	Query.SetParameter("Period", Period);
	Query.SetParameter("LedgerType", LedgerType);
	Query.SetParameter("AccountingOperationGroup", AccountingOperationGroup);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfAccountingOperations = New Array();
	While QuerySelection.Next() Do
		ByRow = Map.Get(QuerySelection.AccountingOperation);
		ByRow = ?(ByRow = Undefined, False, ByRow);
		ArrayOfAccountingOperations.Add(New Structure("Identifier, ByRow, MetadataName",
			QuerySelection.AccountingOperation, ByRow, MetadataName));
	EndDo;
	Return ArrayOfAccountingOperations;
EndFunction

#EndRegion

#Region TBAccounts

Function GetCashAccountTBAccounts(Period, Company, CashAccount) Export
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

Function GetPartnerTBAccounts(Period, Company, Partner, Agreement) Export
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

Function GetItemKeyTBAccounts(Period, Company, ItemKey) Export
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

Function GetTaxTBAccounts(Period, Company, Tax) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ByTax.Company,
	|	ByTax.Tax,
	|	ByTax.Account,
	|	1 AS Priority
	|INTO Accounts
	|FROM
	|	InformationRegister.TaxTBAccounts.SliceLast(&Period, Company = &Company
	|	AND Tax = &Tax) AS ByTax
	|
	|UNION ALL
	|
	|SELECT
	|	ByCompany.Company,
	|	ByCompany.Tax,
	|	ByCompany.Account,
	|	2
	|FROM
	|	InformationRegister.TaxTBAccounts.SliceLast(&Period, Company = &Company
	|	AND Tax.Ref IS NULL) AS ByCompany
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Accounts.Company,
	|	Accounts.Tax,
	|	Accounts.Account,
	|	Accounts.Priority AS Priority
	|FROM
	|	Accounts AS Accounts
	|ORDER BY
	|	Priority";
	Query.SetParameter("Period"      , Period);
	Query.SetParameter("Company"     , Company);
	Query.SetParameter("CashAccount" , Tax);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Account", Undefined);
	If QuerySelection.Next() Then
		Result.Account = QuerySelection.Account;
	EndIf;
	Return Result;
EndFunction

#EndRegion

