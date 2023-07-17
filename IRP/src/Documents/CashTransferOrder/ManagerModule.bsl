#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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

	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

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

#Region Undoposting

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

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(MoneySender());
	QueryArray.Add(MoneyReceiver());
	Return QueryArray;
EndFunction

Function MoneySender()
	Return "SELECT
		   |	CashTransferOrder.Company AS Company,
		   |	CashTransferOrder.Ref.Branch AS Branch,
		   |	CashTransferOrder.Ref AS Ref,
		   |	CashTransferOrder.Sender AS Account,
		   |	CashTransferOrder.SendAmount AS Amount,
		   |	CashTransferOrder.SendCurrency AS Currency,
		   |	CashTransferOrder.SendUUID AS Key,
		   |	CashTransferOrder.Date AS Period,
		   |	CashTransferOrder.SendPeriod AS SendPeriod,
		   |	CashTransferOrder.SendFinancialMovementType AS FinancialMovementType,
		   |	CashTransferOrder.CashAdvanceHolder
		   |INTO MoneySender
		   |FROM
		   |	Document.CashTransferOrder AS CashTransferOrder
		   |WHERE
		   |	CashTransferOrder.Ref = &Ref";
EndFunction

Function MoneyReceiver()
	Return "SELECT
		   |	CashTransferOrder.Company AS Company,
		   |	CashTransferOrder.Ref.ReceiveBranch AS ReceiveBranch,
		   |	CashTransferOrder.Ref AS Ref,
		   |	CashTransferOrder.Receiver AS Account,
		   |	CashTransferOrder.ReceiveAmount AS Amount,
		   |	CashTransferOrder.ReceiveCurrency AS Currency,
		   |	CashTransferOrder.ReceiveUUID AS Key,
		   |	CashTransferOrder.Date AS Period,
		   |	CashTransferOrder.ReceivePeriod AS ReceivePeriod,
		   |	CashTransferOrder.ReceiveFinancialMovementType AS FinancialMovementType,
		   |	CashTransferOrder.CashAdvanceHolder
		   |INTO MoneyReceiver
		   |FROM
		   |	Document.CashTransferOrder AS CashTransferOrder
		   |WHERE
		   |	CashTransferOrder.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3035T_CashPlanning());
	Return QueryArray;
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	MoneySender.Period,
		   |	MoneySender.SendPeriod AS PlanningPeriod,
		   |	MoneySender.Company,
		   |	MoneySender.Branch,
		   |	MoneySender.Account,
		   |	MoneySender.Amount,
		   |	MoneySender.Currency,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		   |	MoneySender.Ref AS BasisDocument,
		   |	MoneySender.FinancialMovementType,
		   |	MoneySender.Key
		   |INTO R3035T_CashPlanning 
		   |FROM
		   |	MoneySender AS MoneySender
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	MoneyReceiver.Period,
		   |	MoneyReceiver.ReceivePeriod,
		   |	MoneyReceiver.Company,
		   |	MoneyReceiver.ReceiveBranch,
		   |	MoneyReceiver.Account,
		   |	MoneyReceiver.Amount,
		   |	MoneyReceiver.Currency,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		   |	MoneyReceiver.Ref AS BasisDocument,
		   |	MoneyReceiver.FinancialMovementType,
		   |	MoneyReceiver.Key
		   |FROM
		   |	MoneyReceiver AS MoneyReceiver";
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