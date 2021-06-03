#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
//	Query = New Query();
//	Query.Text =
//		"SELECT
//		|	CashTransferOrder.Company AS Company,
//		|	CashTransferOrder.Ref AS Ref,
//		|	CashTransferOrder.Sender AS Sender,
//		|	CashTransferOrder.Receiver AS Receiver,
//		|	CashTransferOrder.SendAmount AS SendAmount,
//		|	CashTransferOrder.ReceiveAmount AS ReceiveAmount,
//		|	CashTransferOrder.SendCurrency AS SendCurrency,
//		|	CashTransferOrder.SendUUID AS SendUUID,
//		|	CashTransferOrder.ReceiveCurrency AS ReceiveCurrency,
//		|	CashTransferOrder.ReceiveUUID AS ReceiveUUID,
//		|	CashTransferOrder.SendDate AS Senddate,
//		|	CashTransferOrder.ReceiveDate AS ReceiveDate,
//		|	CashTransferOrder.CashAdvanceHolder
//		|FROM
//		|	Document.CashTransferOrder AS CashTransferOrder
//		|WHERE
//		|	CashTransferOrder.Ref = &Ref";
//	
//	Query.SetParameter("Ref", Ref);
//	QueryResults = Query.Execute();
//	
//	QueryTable = QueryResults.Unload();
//	
//	Query = New Query();
//	Query.Text =
//		"SELECT
//		|	QueryTable.Company AS Company,
//		|	QueryTable.Sender AS Sender,
//		|	QueryTable.Receiver AS Receiver,
//		|	QueryTable.SendAmount AS SendAmount,
//		|	QueryTable.ReceiveAmount AS ReceiveAmount,
//		|	QueryTable.SendCurrency AS SendCurrency,
//		|	QueryTable.ReceiveCurrency AS ReceiveCurrency,
//		|	QueryTable.SendDate AS Senddate,
//		|	QueryTable.ReceiveDate AS ReceiveDate,
//		|	QueryTable.Ref AS BasisDocument,
//		|	QueryTable.SendUUID AS SendUUID,
//		|	QueryTable.ReceiveUUID AS ReceiveUUID,
//		|	QueryTable.CashAdvanceHolder AS CashAdvanceHolder
//		|INTO tmp
//		|FROM
//		|	&QueryTable AS QueryTable
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company AS Company,
//		|	tmp.Sender AS Account,
//		|	tmp.SendAmount AS Amount,
//		|	tmp.SendCurrency AS Currency,
//		|	tmp.SendDate AS Period,
//		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
//		|	tmp.BasisDocument AS BasisDocument,
//		|	tmp.SendUUID AS Key
//		|FROM
//		|	tmp AS tmp
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Receiver,
//		|	tmp.ReceiveAmount,
//		|	tmp.ReceiveCurrency,
//		|	tmp.ReceiveDate AS Period,
//		|	VALUE(Enum.CashFlowDirections.Incoming),
//		|	tmp.BasisDocument,
//		|	tmp.ReceiveUUID
//		|FROM
//		|	tmp AS tmp";
//	Query.SetParameter("QueryTable", QueryTable);
//	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
//	Tables.Insert("PaymentList_PlaningCashTransactions", QueryResults[1].Unload());
	
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
		|	CashTransferOrder.Ref AS Ref,
		|	CashTransferOrder.Sender AS Account,
		|	CashTransferOrder.SendAmount AS Amount,
		|	CashTransferOrder.SendCurrency AS Currency,
		|	CashTransferOrder.SendUUID AS Key,
		|	CashTransferOrder.SendDate AS Period,
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
		|	CashTransferOrder.Ref AS Ref,
		|	CashTransferOrder.Receiver AS Account,
		|	CashTransferOrder.ReceiveAmount AS Amount,
		|	CashTransferOrder.ReceiveCurrency AS Currency,
		|	CashTransferOrder.ReceiveUUID AS Key,
		|	CashTransferOrder.ReceiveDate AS Period,
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
		|	MoneySender.Company,
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
		|	MoneyReceiver.Company,
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
