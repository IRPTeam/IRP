#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("CashInTransit", PostingServer.CreateTable(AccReg.CashInTransit));

	Query_CashInTransit = New Query();
	Query_CashInTransit.Text = GetQueryText_CashStatement_CashInTransit();
	Query_CashInTransit.SetParameter("Ref", Ref);
	QueryResult_CashInTransit = Query_CashInTransit.Execute();
	CashInTransit = QueryResult_CashInTransit.Unload();

	Tables.CashInTransit = CashInTransit;
	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function GetQueryText_CashStatement_CashInTransit()
	Return "SELECT
	|	Table.Ref.Company AS Company,
	|	&Ref AS BasisDocument,
	|	Table.Account AS FromAccount,
	|	(&Ref).CashAccount AS ToAccount,
	|	(&Ref).CashAccount.Currency AS Currency,
	|	SUM(Table.Amount) AS Amount,
	|	Table.Ref.Date AS Period,
	|	Table.Key,
	|	Table.Ref.Branch AS Branch
	|FROM
	|	Document.CashStatement.PaymentList AS Table
	|WHERE
	|	Table.Ref = &Ref
	|	AND Table.Account.Type = VALUE(Enum.CashAccountTypes.POS)
	|GROUP BY
	|	Table.Ref.Company,
	|	Table.Account.Currency,
	|	Table.Account,
	|	Table.Ref.Date,
	|	Table.Key,
	|	(&Ref).CashAccount,
	|	(&Ref).CashAccount.Currency,
	|	Table.Ref.Branch";
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
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
						
	// CashInTransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.CashInTransit));
			
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
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3035T_CashPlanning());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return
	"SELECT
	|	PaymentList.Ref.Date AS Period,
	|	PaymentList.Ref AS Ref,
	|	PaymentList.Ref.Company AS Company,
	|	PaymentList.Ref.CashAccount AS CashAccount,
	|	PaymentList.Account,
	|	PaymentList.Currency,
	|	PaymentList.FinancialMovementType,
	|	PaymentList.Amount,
	|	PaymentList.Account.Type = VALUE(Enum.CashAccountTypes.POS) AS IsAccountPOS,
	|	PaymentList.Ref.Branch AS Branch
	|INTO PaymentList
	|FROM
	|	Document.CashStatement.PaymentList AS PaymentList
	|WHERE
	|	PaymentList.Ref = &Ref"
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsAccountPOS";
EndFunction

Function R3035T_CashPlanning()
	Return
		"SELECT
		|	PaymentList.Period,
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

#EndRegion