#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
		
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	
	Tables.R3035T_CashPlanning.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
#Region NewRegistersPosting	
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion
	
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

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
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
	QueryArray.Add(R3035T_CashPlanning());
	Return QueryArray;
EndFunction

Function MoneySender()
	Return
		"SELECT
		|	CashTransferOrder.Company AS Company,
		|	CashTransferOrder.Ref.Branch AS Branch,
		|	CashTransferOrder.Ref AS Ref,
		|	CashTransferOrder.Sender AS Account,
		|	CashTransferOrder.SendAmount AS Amount,
		|	CashTransferOrder.SendCurrency AS Currency,
		|	CashTransferOrder.SendUUID AS Key,
		|	CashTransferOrder.Date AS Period,
		|	CashTransferOrder.SendPeriod AS SendPeriod,
		|	CashTransferOrder.SendMovementType AS MovementType,
		|	CashTransferOrder.CashAdvanceHolder
		|INTO MoneySender
		|FROM
		|	Document.CashTransferOrder AS CashTransferOrder
		|WHERE
		|	CashTransferOrder.Ref = &Ref";	
EndFunction

Function MoneyReceiver()
	Return
		"SELECT
		|	CashTransferOrder.Company AS Company,
		|	CashTransferOrder.Ref.Branch AS Branch,
		|	CashTransferOrder.Ref AS Ref,
		|	CashTransferOrder.Receiver AS Account,
		|	CashTransferOrder.ReceiveAmount AS Amount,
		|	CashTransferOrder.ReceiveCurrency AS Currency,
		|	CashTransferOrder.ReceiveUUID AS Key,
		|	CashTransferOrder.Date AS Period,
		|	CashTransferOrder.ReceivePeriod AS ReceivePeriod,
		|	CashTransferOrder.ReceiveMovementType AS MovementType,
		|	CashTransferOrder.CashAdvanceHolder
		|INTO MoneyReceiver
		|FROM
		|	Document.CashTransferOrder AS CashTransferOrder
		|WHERE
		|	CashTransferOrder.Ref = &Ref";	
EndFunction

Function R3035T_CashPlanning()
	Return
		"SELECT
		|	MoneySender.Period,
		|	MoneySender.SendPeriod AS PlanningPeriod,
		|	MoneySender.Company,
		|	MoneySender.Branch,
		|	MoneySender.Account,
		|	MoneySender.Amount,
		|	MoneySender.Currency,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		|	MoneySender.Ref AS BasisDocument,
		|	MoneySender.MovementType,
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
		|	MoneyReceiver.Branch,
		|	MoneyReceiver.Account,
		|	MoneyReceiver.Amount,
		|	MoneyReceiver.Currency,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	MoneyReceiver.Ref AS BasisDocument,
		|	MoneyReceiver.MovementType,
		|	MoneyReceiver.Key
		|FROM
		|	MoneyReceiver AS MoneyReceiver";
EndFunction

#EndRegion
