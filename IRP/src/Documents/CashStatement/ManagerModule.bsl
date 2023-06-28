#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export

	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure;
	Tables.Insert("CashInTransit", PostingServer.CreateTable(AccReg.CashInTransit));

	Query_CashInTransit = New Query;
	Query_CashInTransit.Text = GetQueryText_CashStatement_CashInTransit();
	Query_CashInTransit.SetParameter("Ref", Ref);
	QueryResult_CashInTransit = Query_CashInTransit.Execute();
	CashInTransit = QueryResult_CashInTransit.Unload();

	Tables.CashInTransit = CashInTransit;

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Return Tables;
EndFunction

Function GetQueryText_CashStatement_CashInTransit()
	Return "SELECT
		   |	Table.Ref.Company AS Company,
		   |	Table.Ref AS BasisDocument,
		   |	Table.Account AS FromAccount,
		   |	Table.ReceiptingAccount AS ToAccount,
		   |	Table.Currency AS Currency,
		   |	Table.Amount AS Amount,
		   |	Table.Ref.Date AS Period,
		   |	Table.Key
		   |FROM
		   |	Document.CashStatement.PaymentList AS Table
		   |WHERE
		   |	Table.Ref = &Ref
		   |	AND Table.Account.Type = VALUE(Enum.CashAccountTypes.POS)";
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

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
						
	// CashInTransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet", AccumulationRecordType.Receipt, Parameters.DocumentDataTables.CashInTransit));

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
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return "SELECT
		   |	PaymentList.Ref.Date AS Period,
		   |	PaymentList.Key,
		   |	PaymentList.Ref AS Ref,
		   |	PaymentList.Ref.Company AS Company,
		   |	PaymentList.Ref.CashAccount AS CashAccount,
		   |	PaymentList.Account,
		   |	PaymentList.Currency,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.Amount,
		   |	PaymentList.Commission,
		   |	PaymentList.Account.Type = VALUE(Enum.CashAccountTypes.POS) AS IsAccountPOS,
		   |	PaymentList.Ref.Branch AS Branch,
		   |	PaymentList.PaymentType,
		   |	PaymentList.PaymentTerminal,
		   |	PaymentList.ReceiptingAccount,
		   |	PaymentList.UseBasisDocument
		   |INTO PaymentList
		   |FROM
		   |	Document.CashStatement.PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Ref = &Ref"
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3035T_CashPlanning());
	Return QueryArray;
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Account,
		   |	PaymentList.Currency,
		   |	PaymentList.Key,
		   |	PaymentList.Amount
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsAccountPOS";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Account,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.Currency,
		   |	PaymentList.Key,
		   |	PaymentList.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsAccountPOS";
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Ref AS BasisDocument,
		   |	PaymentList.CashAccount AS Account,
		   |	PaymentList.Currency,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.Amount
		   |INTO R3035T_CashPlanning
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsAccountPOS";
EndFunction

Function R3021B_CashInTransitIncoming()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Account,
		   |	PaymentList.ReceiptingAccount,
		   |	CASE
		   |		WHEN PaymentList.UseBasisDocument
		   |			THEN PaymentList.Ref
		   |		ELSE UNDEFINED
		   |	END AS Basis,
		   |	PaymentList.Amount,
		   |	PaymentList.Commission
		   |INTO R3021B_CashInTransitIncoming
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsAccountPOS";
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
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion