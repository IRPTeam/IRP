#Region PRINT_FORM

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
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

	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region UNDOPOSTING

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
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
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(MoneySender());
	QueryArray.Add(MoneyReceiver());
	QueryArray.Add(MoneyTransit());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function MoneySender()
	Return 
		"SELECT
		|	MoneySender.Ref,
		|	MoneySender.Company AS Company,
		|	MoneySender.Branch AS Branch,
		|	MoneySender.Ref AS Ref,
		|	MoneySender.Sender AS Account,
		|	MoneySender.Sender AS AccountFrom,
		|	MoneySender.Receiver AS AccountTo,
		|	MoneySender.SendAmount AS Amount,
		|	MoneySender.SendCurrency AS Currency,
		|	MoneySender.SendUUID AS Key,
		|	MoneySender.Date AS Period,
		|	MoneySender.CashTransferOrder AS BasisDocument,
		|	MoneySender.CashTransferOrder.SendPeriod AS PlanningPeriod,
		|	MoneySender.SendFinancialMovementType AS FinancialMovementType,
		|	MoneySender.SendCashFlowCenter AS CashFlowCenter,
		|	MoneySender.TransitAccount,
		|	MoneySender.TransitAccount.Currency AS TransitCurrency,
		|	MoneySender.Sender.Type = VALUE(Enum.CashAccountTypes.POSCashAccount) AS IsPOSCashAccount,
		|	MoneySender.SendCurrency <> MoneySender.ReceiveCurrency AS IsCurrencyExchange,
		|	MoneySender.SendCurrency = MoneySender.ReceiveCurrency AS IsMoneyTransfer
		|INTO MoneySender
		|FROM
		|	Document.MoneyTransfer AS MoneySender
		|WHERE
		|	MoneySender.Ref = &Ref";
EndFunction

Function MoneyReceiver()
	Return 
		"SELECT
		|	MoneyReceiver.Ref,
		|	MoneyReceiver.Company AS Company,
		|	MoneyReceiver.ReceiveBranch AS Branch,
		|	MoneyReceiver.ReceiveBranch AS ReceiveBranch,
		|	MoneyReceiver.Branch AS BranchSender,
		|	MoneyReceiver.Ref AS Ref,
		|	MoneyReceiver.Receiver AS Account,
		|	MoneyReceiver.Sender AS AccountFrom,
		|	MoneyReceiver.Receiver AS AccountTo,
		|	MoneyReceiver.ReceiveAmount AS Amount,
		|	MoneyReceiver.ReceiveCurrency AS Currency,
		|	MoneyReceiver.ReceiveUUID AS Key,
		|	MoneyReceiver.Date AS Period,
		|	MoneyReceiver.CashTransferOrder AS BasisDocument,
		|	MoneyReceiver.CashTransferOrder.SendPeriod AS PlanningPeriod,
		|	MoneyReceiver.ReceiveFinancialMovementType AS FinancialMovementType,
		|	MoneyReceiver.ReceiveCashFlowCenter AS CashFlowCenter,
		|	MoneyReceiver.Receiver.Type = VALUE(Enum.CashAccountTypes.POSCashAccount) AS IsPOSCashAccount,
		|	MoneyReceiver.Receiver.Type = VALUE(Enum.CashAccountTypes.POSCashAccount)
		|	OR MoneyReceiver.Sender.Type = VALUE(Enum.CashAccountTypes.POSCashAccount) AS UseCashInTransit,
		|	MoneyReceiver.SendCurrency <> MoneyReceiver.ReceiveCurrency AS IsCurrencyExchange,
		|	MoneyReceiver.SendCurrency = MoneyReceiver.ReceiveCurrency AS IsMoneyTransfer
		|INTO MoneyReceiver
		|FROM
		|	Document.MoneyTransfer AS MoneyReceiver
		|WHERE
		|	MoneyReceiver.Ref = &Ref";
EndFunction

Function MoneyTransit()
	Return
		"SELECT
		|	Currencies.Ref AS Ref,
		|	Currencies.Ref.Date AS Period,
		|	Currencies.Ref.Company AS Company,
		|	Currencies.Ref.Branch AS Branch,
		|	Currencies.Ref.TransitAccount AS TransitAccount,
		|	Currencies.Amount AS Amount,
		|	Currencies.Ref.TransitAccount.Currency AS TransitCurrency,
		|	Currencies.Ref.TransitUUID AS TransitUUID
		|INTO MoneyTransit
		|FROM
		|	Document.MoneyTransfer.Currencies AS Currencies
		|WHERE
		|	Currencies.Ref = &Ref
		|	AND Currencies.CurrencyFrom = Currencies.Ref.ReceiveCurrency
		|	AND Currencies.MovementType.Currency = Currencies.Ref.TransitAccount.Currency
		|	AND Currencies.Ref.SendCurrency <> Currencies.Ref.ReceiveCurrency
		|	AND Currencies.Key <> Currencies.Ref.TransitUUID";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R3021B_CashInTransitIncoming()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	MoneyReceiver.Period,
		   |	MoneyReceiver.Company,
		   |	MoneyReceiver.ReceiveBranch AS Branch,
		   |	MoneyReceiver.Ref AS Basis,
		   |	MoneyReceiver.AccountTo AS Account,
		   |	MoneyReceiver.Amount,
		   |	MoneyReceiver.Currency,
		   |	MoneyReceiver.Key
		   |INTO R3021B_CashInTransitIncoming
		   |FROM
		   |	MoneyReceiver AS MoneyReceiver
		   |WHERE
		   |	MoneyReceiver.IsPOSCashAccount 
		   |	AND NOT MoneyReceiver.IsCurrencyExchange
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	MoneySender.Period,
		   |	MoneySender.Company,
		   |	MoneySender.Branch,
		   |	MoneySender.Ref AS Basis,
		   |	MoneySender.AccountTo AS Account,
		   |	MoneySender.Amount,
		   |	MoneySender.Currency,
		   |	MoneySender.Key
		   |FROM
		   |	MoneySender AS MoneySender
		   |WHERE
		   |	MoneySender.IsPOSCashAccount
		   |	AND NOT MoneySender.IsCurrencyExchange
		   |
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	MoneySender.Period,
		   |	MoneySender.Company,
		   |	MoneySender.Branch,
		   |	MoneySender.Ref,
		   |	MoneySender.TransitAccount,
		   |	MoneySender.Amount,
		   |	MoneySender.TransitCurrency,
		   |	MoneySender.Key
		   |FROM
		   |	MoneySender AS MoneySender
		   |WHERE
		   |	MoneySender.IsCurrencyExchange
		   |	AND NOT MoneySender.IsPOSCashAccount
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	MoneyTransit.Period,
		   |	MoneyTransit.Company,
		   |	MoneyTransit.Branch,
		   |	MoneyTransit.Ref,
		   |	MoneyTransit.TransitAccount,
		   |	MoneyTransit.Amount,
		   |	MoneyTransit.TransitCurrency,
		   |	MoneyTransit.TransitUUID
		   |FROM
		   |	MoneyTransit AS MoneyTransit
		   |WHERE
		   |	TRUE";
EndFunction

Function R3010B_CashOnHand()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	MoneySender.Period,
		|	MoneySender.Company,
		|	MoneySender.Branch,
		|	MoneySender.Account,
		|	MoneySender.Amount,
		|	MoneySender.Currency,
		|	MoneySender.Key
		|INTO R3010B_CashOnHand
		|FROM
		|	MoneySender AS MoneySender
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	MoneyReceiver.Period,
		|	MoneyReceiver.Company,
		|	MoneyReceiver.Branch,
		|	MoneyReceiver.Account,
		|	MoneyReceiver.Amount,
		|	MoneyReceiver.Currency,
		|	MoneyReceiver.Key
		|FROM
		|	MoneyReceiver AS MoneyReceiver
		|WHERE
		|	(MoneyReceiver.IsMoneyTransfer OR MoneyReceiver.IsCurrencyExchange) 
		|	AND NOT MoneyReceiver.UseCashInTransit";
EndFunction

Function R3011T_CashFlow()
	Return 
		"SELECT
		|	MoneySender.Period,
		|	MoneySender.Company,
		|	MoneySender.Branch,
		|	MoneySender.Account,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		|	MoneySender.FinancialMovementType,
		|	MoneySender.CashFlowCenter,
		|	MoneySender.Amount,
		|	MoneySender.Currency,
		|	MoneySender.Key
		|INTO R3011T_CashFlow
		|FROM
		|	MoneySender AS MoneySender
		|
		|UNION ALL
		|
		|SELECT
		|	MoneyReceiver.Period,
		|	MoneyReceiver.Company,
		|	MoneyReceiver.Branch,
		|	MoneyReceiver.Account,
		|	VALUE(Enum.CashFlowDirections.Incoming),
		|	MoneyReceiver.FinancialMovementType,
		|	MoneyReceiver.CashFlowCenter,
		|	MoneyReceiver.Amount,
		|	MoneyReceiver.Currency,
		|	MoneyReceiver.Key
		|FROM
		|	MoneyReceiver AS MoneyReceiver
		|WHERE
		|	(MoneyReceiver.IsMoneyTransfer OR MoneyReceiver.IsCurrencyExchange)
		|	AND NOT MoneyReceiver.UseCashInTransit";
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	MoneySender.Period,
		   |	MoneySender.Company,
		   |	MoneySender.Branch,
		   |	MoneySender.BasisDocument,
		   |	MoneySender.PlanningPeriod,
		   |	MoneySender.Account,
		   |	MoneySender.Currency,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		   |	MoneySender.FinancialMovementType,
		   |	-MoneySender.Amount AS Amount,
		   |	MoneySender.Key
		   |INTO R3035T_CashPlanning
		   |FROM
		   |	MoneySender AS MoneySender
		   |WHERE
		   |	NOT MoneySender.BasisDocument.Ref IS NULL
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	MoneyReceiver.Period,
		   |	MoneyReceiver.Company,
		   |	MoneyReceiver.Branch,
		   |	MoneyReceiver.BasisDocument,
		   |	MoneyReceiver.PlanningPeriod,
		   |	MoneyReceiver.Account,
		   |	MoneyReceiver.Currency,
		   |	VALUE(Enum.CashFlowDirections.Incoming),
		   |	MoneyReceiver.FinancialMovementType,
		   |	-MoneyReceiver.Amount,
		   |	MoneyReceiver.Key
		   |FROM
		   |	MoneyReceiver AS MoneyReceiver
		   |WHERE
		   |	NOT MoneyReceiver.BasisDocument.Ref IS NULL";
EndFunction

#EndRegion

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
	BranchArray = New Array;
	BranchArray.Add(Obj.Branch);
	BranchArray.Add(Obj.ReceiveBranch);
	AccessKeyMap.Insert("Branch", BranchArray);
	
	AccountArray = New Array;
	AccountArray.Add(Obj.Receiver);
	AccountArray.Add(Obj.Sender);
	AccessKeyMap.Insert("Account", AccountArray);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	MoneySender.Period,
		|	MoneySender.Currency,
		|	MoneySender.Key,
		|	MoneySender.Amount,
		|	VALUE(Catalog.AccountingOperations.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand) AS Operation
		|INTO T1040T_AccountingAmounts
		|FROM
		|	MoneySender AS MoneySender
		|WHERE
		|	MoneySender.IsMoneyTransfer
		|
		|UNION ALL
		|
		|SELECT
		|	MoneySender.Period,
		|	MoneySender.Currency,
		|	MoneySender.Key,
		|	MoneySender.Amount,
		|	VALUE(Catalog.AccountingOperations.MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand)
		|FROM
		|	MoneySender AS MoneySender
		|WHERE
		|	MoneySender.IsCurrencyExchange
		|
		|UNION ALL
		|
		|SELECT
		|	MoneyReceiver.Period,
		|	MoneyReceiver.Currency,
		|	MoneyReceiver.Key,
		|	MoneyReceiver.Amount,
		|	VALUE(Catalog.AccountingOperations.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit)
		|FROM
		|	MoneyReceiver AS MoneyReceiver
		|WHERE
		|	MoneyReceiver.IsCurrencyExchange";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand Then
		Return GetAnalytics_MoneyTransfer(Parameters); // Cash on hand - Cash on hand
	ElsIf Parameters.Operation = AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit Then
		Return GetAnalytics_ReceiptFromTransit(Parameters); // Cash on hand - Cash in transit
	ElsIf Parameters.Operation = AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand Then
		Return GetAnalytics_SendToTransit(Parameters); // Cash in transit - Cash on hand
	ElsIf Parameters.Operation = AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues Then
		Return GetAnalytics_CurrencyExchangeRevenues(Parameters); // Cash in transit - Revenues
	ElsIf Parameters.Operation = AO.MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit Then
		Return GetAnalytics_CurrencyExchangeExpenses(Parameters); // Expenses - Cash in transit
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Cash on hand - Cash on hand
Function GetAnalytics_MoneyTransfer(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AccountingAnalytics.Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                           Parameters.ObjectData.Receiver,
	                                                                           Parameters.ObjectData.ReceiveCurrency).Account;	
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Receiver", Parameters.ObjectData.Receiver);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	AccountingAnalytics.Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                            Parameters.ObjectData.Sender,
	                                                                            Parameters.ObjectData.SendCurrency).Account;
	// Credit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Sender", Parameters.ObjectData.Sender);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	Return AccountingAnalytics;
EndFunction

// Cash in transit - Cash on hand
Function GetAnalytics_SendToTransit(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AccountingAnalytics.Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                           Parameters.ObjectData.TransitAccount,
	                                                                           Parameters.ObjectData.TransitAccount.Currency).Account;	
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("TransitAccount", Parameters.ObjectData.TransitAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	AccountingAnalytics.Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                            Parameters.ObjectData.Sender,
	                                                                            Parameters.ObjectData.SendCurrency).Account;
	// Credit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Sender", Parameters.ObjectData.Sender);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	Return AccountingAnalytics;
EndFunction

// Cash on hand - Cash in transit
Function GetAnalytics_ReceiptFromTransit(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AccountingAnalytics.Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                           Parameters.ObjectData.Receiver,
	                                                                           Parameters.ObjectData.ReceiveCurrency).Account;	
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Receiver", Parameters.ObjectData.Receiver);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	AccountingAnalytics.Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                            Parameters.ObjectData.TransitAccount,
	                                                                            Parameters.ObjectData.TransitAccount.Currency).Account;
	// Credit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("TransitAccount", Parameters.ObjectData.TransitAccount);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	Return AccountingAnalytics;
EndFunction

// Cash in transit - Revenues
Function GetAnalytics_CurrencyExchangeRevenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AccountingAnalytics.Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                           Parameters.ObjectData.TransitAccount,
	                                                                           Parameters.ObjectData.TransitAccount.Currency).Account;	
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("TransitAccount", Parameters.ObjectData.TransitAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                           Parameters.ObjectData.RevenueType,
	                                                           Parameters.ObjectData.ProfitCenter);
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	
	// Debit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	Return AccountingAnalytics;
EndFunction

// Expenses - Cash in transit
Function GetAnalytics_CurrencyExchangeExpenses(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.LossCenter);
	AccountingAnalytics.Debit = Debit.AccountExpense;
	
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	AccountingAnalytics.Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                                            Parameters.ObjectData.TransitAccount,
	                                                                            Parameters.ObjectData.TransitAccount.Currency).Account;
	// Credit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("TransitAccount", Parameters.ObjectData.TransitAccount);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand
	   Or Parameters.Operation = AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit
	   Or Parameters.Operation = AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand Then
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.ReceiveFinancialMovementType;
		EndIf;
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
			Return Parameters.ObjectData.ReceiveCashFlowCenter;
		EndIf;
	
	ElsIf Parameters.Operation = AO.MoneyTransfer_DR_R5022T_Expenses_CR_R3021B_CashInTransit Then
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.ExpenseType;
		EndIf;
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
			Return Parameters.ObjectData.LossCenter;
		EndIf;
		
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand
	   Or Parameters.Operation = AO.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3021B_CashInTransit
	   Or Parameters.Operation = AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R3010B_CashOnHand Then
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.SendFinancialMovementType;
		EndIf;
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
			Return Parameters.ObjectData.SendCashFlowCenter;
		EndIf;
	
	ElsIf Parameters.Operation = AO.MoneyTransfer_DR_R3021B_CashInTransit_CR_R5021T_Revenues Then
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.RevenueType;
		EndIf;
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
			Return Parameters.ObjectData.ProfitCenter;
		EndIf;
		
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion