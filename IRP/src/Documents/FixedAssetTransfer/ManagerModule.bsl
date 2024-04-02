#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	Parameters.IsReposting = False;
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
	StrParams.Insert("Company"                 , Ref.Company);
	StrParams.Insert("BranchSender"            , Ref.Branch);
	StrParams.Insert("BranchReceiver"          , Ref.BranchReceiver);
	StrParams.Insert("ProfitLossCenterSender"  , Ref.ProfitLossCenterSender);
	StrParams.Insert("ProfitLossCenterReceiver", Ref.ProfitLossCenterReceiver);
	StrParams.Insert("ResponsiblePersonSender" , Ref.ResponsiblePersonSender);
	StrParams.Insert("FixedAsset"    , Ref.FixedAsset);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod" , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod" , Undefined);
	EndIf;
	StrParams.Insert("Period", Ref.Date);
	
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T8515S_FixedAssetsLocation());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
//	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

Function T8515S_FixedAssetsLocation()
	Return
		"SELECT
		|	&Period AS Period,
		|	T8515S_FixedAssetsLocationSliceLast.Company,
		|	T8515S_FixedAssetsLocationSliceLast.Branch,
		|	T8515S_FixedAssetsLocationSliceLast.ProfitLossCenter,
		|	T8515S_FixedAssetsLocationSliceLast.FixedAsset,
		|	T8515S_FixedAssetsLocationSliceLast.ResponsiblePerson,
		|	FALSE AS IsActive
		|INTO T8515S_FixedAssetsLocation
		|FROM
		|	InformationRegister.T8515S_FixedAssetsLocation.SliceLast(&BalancePeriod, Company = &Company
		|	AND Branch = &BranchSender
		|	AND ProfitLossCenter = &ProfitLossCenterSender
		|	AND FixedAsset = &FixedAsset
		|	AND ResponsiblePerson = &ResponsiblePersonSender) AS T8515S_FixedAssetsLocationSliceLast
		|WHERE
		|	T8515S_FixedAssetsLocationSliceLast.IsActive
		|
		|UNION ALL
		|
		|SELECT
		|	FixedAssetTransfer.Date,
		|	FixedAssetTransfer.Company,
		|	FixedAssetTransfer.BranchReceiver,
		|	FixedAssetTransfer.ProfitLossCenterReceiver,
		|	FixedAssetTransfer.FixedAsset,
		|	FixedAssetTransfer.ResponsiblePersonReceiver,
		|	TRUE
		|FROM
		|	Document.FixedAssetTransfer AS FixedAssetTransfer
		|WHERE
		|	FixedAssetTransfer.Ref = &Ref";
EndFunction

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	&Period AS Period,
		|	R8510B_BookValueOfFixedAssetBalance.Company,
		|	R8510B_BookValueOfFixedAssetBalance.Branch,
		|	R8510B_BookValueOfFixedAssetBalance.ProfitLossCenter,
		|	R8510B_BookValueOfFixedAssetBalance.FixedAsset,
		|	R8510B_BookValueOfFixedAssetBalance.LedgerType,
		|	R8510B_BookValueOfFixedAssetBalance.Schedule,
		|	R8510B_BookValueOfFixedAssetBalance.Currency,
		|	R8510B_BookValueOfFixedAssetBalance.AmountBalance AS Amount
		|INTO _BookValueOfFixedAsset
		|FROM
		|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&BalancePeriod, 
		|	FixedAsset = &FixedAsset
		|	AND Company = &Company
		|	AND Branch = &BranchSender
		|	AND ProfitLossCenter = &ProfitLossCenterSender
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		R8510B_BookValueOfFixedAssetBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	_BookValueOfFixedAsset.Period,
		|	_BookValueOfFixedAsset.Company,
		|	_BookValueOfFixedAsset.Branch,
		|	_BookValueOfFixedAsset.ProfitLossCenter,
		|	_BookValueOfFixedAsset.FixedAsset,
		|	_BookValueOfFixedAsset.LedgerType,
		|	_BookValueOfFixedAsset.Schedule,
		|	_BookValueOfFixedAsset.Currency,
		|	_BookValueOfFixedAsset.Amount
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	_BookValueOfFixedAsset AS _BookValueOfFixedAsset
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	_BookValueOfFixedAsset.Period,
		|	_BookValueOfFixedAsset.Company,
		|	&BranchReceiver,
		|	&ProfitLossCenterReceiver,
		|	_BookValueOfFixedAsset.FixedAsset,
		|	_BookValueOfFixedAsset.LedgerType,
		|	_BookValueOfFixedAsset.Schedule,
		|	_BookValueOfFixedAsset.Currency,
		|	_BookValueOfFixedAsset.Amount
		|FROM
		|	_BookValueOfFixedAsset AS _BookValueOfFixedAsset
		|WHERE
		|	TRUE";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObject.FixedAssetTransfer -
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
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.NetAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions) AS
		|		Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsPurchase
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.TaxAmount,
		|	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions),
		|	UNDEFINED
		|FROM
		|	ItemList as ItemList
		|WHERE
		|	ItemList.IsPurchase
		|
		|UNION ALL
		|
		|SELECT
		|	T2010S_OffsetOfAdvances.Period,
		|	T2010S_OffsetOfAdvances.Key AS RowKey,
		|	T2010S_OffsetOfAdvances.Currency,
		|	T2010S_OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors),
		|	T2010S_OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
		|WHERE
		|	T2010S_OffsetOfAdvances.Document = &Ref";
EndFunction

Function T1050T_AccountingQuantities()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Key AS RowKey,
		   |	VALUE(Catalog.AccountingOperations.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions) AS Operation,
		   |	ItemList.Quantity
		   |INTO T1050T_AccountingQuantities
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsPurchase";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions 
		Or Parameters.Operation = Operations.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions_CurrencyRevaluation Then
		
		Return GetAnalytics_ReceiptInventory(Parameters); // Stock inventory - Vendors transactions
		
	ElsIf Parameters.Operation = Operations.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors 
		Or Parameters.Operation = Operations.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_CurrencyRevaluation Then
		
		Return GetAnalytics_OffsetOfAdvances(Parameters); // Vendors transactions - Advances to vendors
	
	ElsIf Parameters.Operation = Operations.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions Then
		Return GetAnalytics_VATIncoming(Parameters); // Taxes outgoing - Vendors transactions
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Stock inventory - Vendors transactions
Function GetAnalytics_ReceiptInventory(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Item", Parameters.RowData.ItemKey.Item);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.ObjectData.Partner,
	                                                    Parameters.ObjectData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	                                                    
	If ValueIsFilled(Credit.AccountTransactionsVendor) Then
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors
Function GetAnalytics_OffsetOfAdvances(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
														  Parameters.ObjectData.Partner,
														  Parameters.ObjectData.Agreement,
														  Parameters.ObjectData.Currency);
														  
	If ValueIsFilled(Accounts.AccountTransactionsVendor) Then
		AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	If ValueIsFilled(Accounts.AccountAdvancesVendor) Then
		AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Taxes outgoing - Vendors transactions
Function GetAnalytics_VATIncoming(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
		
	// Debit
	Debit = AccountingServer.GetT9013S_AccountsTax(AccountParameters, Parameters.RowData.TaxInfo);
	If ValueIsFilled(Debit.OutgoingAccount) Then
		AccountingAnalytics.Debit = Debit.OutgoingAccount;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Parameters.RowData.TaxInfo);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.ObjectData.Partner,
	                                                    Parameters.ObjectData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	                                                    
	If ValueIsFilled(Credit.AccountTransactionsVendor) Then
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Companies")) <> Undefined Then
		Return Parameters.ObjectData.LegalName;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	If (Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors
		Or Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R1040B_TaxesOutgoing_CR_R1021B_VendorsTransactions
		Or Parameters.Operation = Catalogs.AccountingOperations.PurchaseInvoice_DR_R4050B_StockInventory_R5022T_Expenses_CR_R1021B_VendorsTransactions)
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.Companies")) <> Undefined Then
		Return Parameters.ObjectData.LegalName;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion
