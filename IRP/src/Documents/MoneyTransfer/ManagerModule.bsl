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
	Return "SELECT
		   |	MoneyTransfer.Ref,
		   |	MoneyTransfer.Company AS Company,
		   |	MoneyTransfer.Ref.Branch AS Branch,
		   |	MoneyTransfer.Ref AS Ref,
		   |	MoneyTransfer.Sender AS Account,
		   |	MoneyTransfer.Sender AS AccountFrom,
		   |	MoneyTransfer.Receiver AS AccountTo,
		   |	MoneyTransfer.SendAmount AS Amount,
		   |	MoneyTransfer.SendCurrency AS Currency,
		   |	MoneyTransfer.SendUUID AS Key,
		   |	MoneyTransfer.Date AS Period,
		   |	MoneyTransfer.CashTransferOrder AS BasisDocument,
		   |	MoneyTransfer.CashTransferOrder.SendPeriod AS PlanningPeriod,
		   |	MoneyTransfer.SendFinancialMovementType AS FinancialMovementType,
		   |	MoneyTransfer.SendCashFlowCenter AS CashFlowCenter,
		   |	MoneyTransfer.Sender.Type = VALUE(Enum.CashAccountTypes.POSCashAccount) AS IsPOSCashAccount
		   |INTO MoneySender
		   |FROM
		   |	Document.MoneyTransfer AS MoneyTransfer
		   |WHERE
		   |	MoneyTransfer.Ref = &Ref";
EndFunction

Function MoneyReceiver()
	Return "SELECT
		   |	MoneyTransfer.Ref,
		   |	MoneyTransfer.Company AS Company,
		   |	MoneyTransfer.Ref.ReceiveBranch AS Branch,
		   |	MoneyTransfer.Ref.ReceiveBranch AS ReceiveBranch,
		   |	MoneyTransfer.Ref AS Ref,
		   |	MoneyTransfer.Receiver AS Account,
		   |	MoneyTransfer.Sender AS AccountFrom,
		   |	MoneyTransfer.Receiver AS AccountTo,
		   |	MoneyTransfer.ReceiveAmount AS Amount,
		   |	MoneyTransfer.ReceiveCurrency AS Currency,
		   |	MoneyTransfer.ReceiveUUID AS Key,
		   |	MoneyTransfer.Date AS Period,
		   |	MoneyTransfer.CashTransferOrder AS BasisDocument,
		   |	MoneyTransfer.CashTransferOrder.SendPeriod AS PlanningPeriod,
		   |	MoneyTransfer.ReceiveFinancialMovementType AS FinancialMovementType,
		   |	MoneyTransfer.ReceiveCashFlowCenter AS CashFlowCenter,
		   |	MoneyTransfer.Receiver.Type = VALUE(Enum.CashAccountTypes.POSCashAccount) AS IsPOSCashAccount,
		   |
		   |	MoneyTransfer.Receiver.Type = VALUE(Enum.CashAccountTypes.POSCashAccount)
		   |	OR MoneyTransfer.Sender.Type = VALUE(Enum.CashAccountTypes.POSCashAccount) AS UseCashInTransit
		   |INTO MoneyReceiver
		   |FROM
		   |	Document.MoneyTransfer AS MoneyTransfer
		   |WHERE
		   |	MoneyTransfer.Ref = &Ref";
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
		   |	MoneySender.IsPOSCashAccount";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
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
		   |	NOT MoneyReceiver.UseCashInTransit";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
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
		   |	NOT MoneyReceiver.UseCashInTransit";
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
		|	TRUE";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	If Parameters.Operation = Catalogs.AccountingOperations.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand Then
		Return GetAnalytics_MoneyTransfer(Parameters); // Cash on hand - Cash on hand
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Cash on hand - Cash on hand
Function GetAnalytics_MoneyTransfer(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AccountingAnalytics.Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, Parameters.ObjectData.Receiver).Account;	
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Receiver", Parameters.ObjectData.Receiver);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	AccountingAnalytics.Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, Parameters.ObjectData.Sender).Account;
	// Credit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Sender", Parameters.ObjectData.Sender);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand Then
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.ReceiveFinancialMovementType;
		EndIf;
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
			Return Parameters.ObjectData.ReceiveCashFlowCenter;
		EndIf;
		
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.MoneyTransfer_DR_R3010B_CashOnHand_CR_R3010B_CashOnHand Then
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
			Return Parameters.ObjectData.SendFinancialMovementType;
		EndIf;
		
		If ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.BusinessUnits")) <> Undefined Then
			Return Parameters.ObjectData.SendCashFlowCenter;
		EndIf;
		
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion