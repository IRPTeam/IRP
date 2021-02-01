#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	CashTransferOrder.Company AS Company,
		|	CashTransferOrder.Ref AS Ref,
		|	CashTransferOrder.Sender AS Sender,
		|	CashTransferOrder.Receiver AS Receiver,
		|	CashTransferOrder.SendAmount AS SendAmount,
		|	CashTransferOrder.ReceiveAmount AS ReceiveAmount,
		|	CashTransferOrder.SendCurrency AS SendCurrency,
		|	CashTransferOrder.SendUUID AS SendUUID,
		|	CashTransferOrder.ReceiveCurrency AS ReceiveCurrency,
		|	CashTransferOrder.ReceiveUUID AS ReceiveUUID,
		|	CashTransferOrder.SendDate AS Senddate,
		|	CashTransferOrder.ReceiveDate AS ReceiveDate,
		|	CashTransferOrder.CashAdvanceHolder
		|FROM
		|	Document.CashTransferOrder AS CashTransferOrder
		|WHERE
		|	CashTransferOrder.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Sender AS Sender,
		|	QueryTable.Receiver AS Receiver,
		|	QueryTable.SendAmount AS SendAmount,
		|	QueryTable.ReceiveAmount AS ReceiveAmount,
		|	QueryTable.SendCurrency AS SendCurrency,
		|	QueryTable.ReceiveCurrency AS ReceiveCurrency,
		|	QueryTable.SendDate AS Senddate,
		|	QueryTable.ReceiveDate AS ReceiveDate,
		|	QueryTable.Ref AS BasisDocument,
		|	QueryTable.SendUUID AS SendUUID,
		|	QueryTable.ReceiveUUID AS ReceiveUUID,
		|	QueryTable.CashAdvanceHolder AS CashAdvanceHolder
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Sender AS Account,
		|	tmp.SendAmount AS Amount,
		|	tmp.SendCurrency AS Currency,
		|	tmp.SendDate AS Period,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.SendUUID AS Key
		|FROM
		|	tmp AS tmp
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.Receiver,
		|	tmp.ReceiveAmount,
		|	tmp.ReceiveCurrency,
		|	tmp.ReceiveDate AS Period,
		|	VALUE(Enum.CashFlowDirections.Incoming),
		|	tmp.BasisDocument,
		|	tmp.ReceiveUUID
		|FROM
		|	tmp AS tmp";
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("PaymentList_PlaningCashTransactions", QueryResults[1].Unload());
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PlaningCashTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Account", "Account");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("CashFlowDirection", "CashFlowDirection");
	DataMapWithLockFields.Insert("AccumulationRegister.PlaningCashTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PaymentList_PlaningCashTransactions));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PaymentList_PlaningCashTransactions));
	
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

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

#EndRegion
