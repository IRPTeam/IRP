#Region PRINT_FORM

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
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

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(MoneySender());
	QueryArray.Add(MoneyReceiver());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3035T_CashPlanning());
	Return QueryArray;
EndFunction

Function MoneySender()
	Return 
	"SELECT
	|	MoneyTransfer.Company AS Company,
	|	MoneyTransfer.Ref.Branch AS Branch,
	|	MoneyTransfer.Ref AS Ref,
	|	MoneyTransfer.Sender AS Account,
	|	MoneyTransfer.SendAmount AS Amount,
	|	MoneyTransfer.SendCurrency AS Currency,
	|	MoneyTransfer.SendUUID AS Key,
	|	MoneyTransfer.Date AS Period,
	|	MoneyTransfer.CashTransferOrder AS BasisDocument,
	|	MoneyTransfer.CashTransferOrder.SendPeriod AS PlanningPeriod,
	|	MoneyTransfer.SendFinancialMovementType AS FinancialMovementType
	|INTO MoneySender
	|FROM
	|	Document.MoneyTransfer AS MoneyTransfer
	|WHERE
	|	MoneyTransfer.Ref = &Ref";
EndFunction

Function MoneyReceiver()
	Return 
	"SELECT
	|	MoneyTransfer.Company AS Company,
	|	MoneyTransfer.Ref.Branch AS Branch,
	|	MoneyTransfer.Ref AS Ref,
	|	MoneyTransfer.Receiver AS Account,
	|	MoneyTransfer.ReceiveAmount AS Amount,
	|	MoneyTransfer.ReceiveCurrency AS Currency,
	|	MoneyTransfer.ReceiveUUID AS Key,
	|	MoneyTransfer.Date AS Period,
	|	MoneyTransfer.CashTransferOrder AS BasisDocument,
	|	MoneyTransfer.CashTransferOrder.SendPeriod AS PlanningPeriod,
	|	MoneyTransfer.ReceiveFinancialMovementType AS FinancialMovementType
	|INTO MoneyReceiver
	|FROM
	|	Document.MoneyTransfer AS MoneyTransfer
	|WHERE
	|	MoneyTransfer.Ref = &Ref";
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
	|	MoneyReceiver AS MoneyReceiver";
EndFunction

Function R3035T_CashPlanning()
	Return 
	"SELECT
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
