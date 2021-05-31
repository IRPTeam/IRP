#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	IncomingPaymentOrderPaymentList.Ref.Company AS Company,
		|	IncomingPaymentOrderPaymentList.Ref AS Ref,
		|	IncomingPaymentOrderPaymentList.Ref.Account AS Account,
		|	IncomingPaymentOrderPaymentList.Ref.Currency AS Currency,
		|	IncomingPaymentOrderPaymentList.Ref.PlaningDate AS PlaningDate,
		|	IncomingPaymentOrderPaymentList.Partner AS Partner,
		|	IncomingPaymentOrderPaymentList.Payer AS LegalName,
		|	IncomingPaymentOrderPaymentList.Amount AS Amount,
		|	IncomingPaymentOrderPaymentList.Key
		|FROM
		|	Document.IncomingPaymentOrder.PaymentList AS IncomingPaymentOrderPaymentList
		|WHERE
		|	IncomingPaymentOrderPaymentList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Ref AS BasisDocument,
		|	QueryTable.Account AS Account,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.PlaningDate AS PlaningDate,
		|	QueryTable.Key
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Account AS Account,
		|	tmp.Amount AS Amount,
		|	tmp.Currency AS Currency,
		|	tmp.PlaningDate AS Period,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Amount,
		|	tmp.Currency,
		|	tmp.PlaningDate,
		|	VALUE(Enum.CashFlowDirections.Incoming),
		|	tmp.BasisDocument,
		|	tmp.Key";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("PaymentList_PlaningCashTransactions", QueryResults[1].Unload());
	
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
	
	Tables.R3033B_CashPlanningIncoming.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PaymentList_PlaningCashTransactions));

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
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R3033B_CashPlanningIncoming());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return 
		"SELECT
		|	PaymentList.Ref.Date AS Date,
		|	PaymentList.Ref.PlaningDate AS PalningDate,
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.Currency AS Currency,
		|	PaymentList.Basis,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Partner AS Partner,
		|	PaymentList.Basis.Agreement AS Agreement,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.MovementType,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO PaymentList
		|FROM
		|	Document.IncomingPaymentOrder.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Date AS Period,
		|	PaymentList.Company,
		|	PaymentList.Basis,
		|	PaymentList.LegalName,
		|	PaymentList.Partner,
		|	PaymentList.Agreement,
		|	PaymentList.Amount
		|INTO R2022B_CustomersPaymentPlanning
		|FROM 
		|	PaymentList AS PaymentList";
EndFunction

Function R3033B_CashPlanningIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Date AS Period,
		|	PaymentList.Company,
		|	PaymentList.Currency,
		|	PaymentList.Account,
		|	PaymentList.Basis,
		|	PaymentList.MovementType,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO R3033B_CashPlanningIncoming
		|FROM 
		|	PaymentList AS PaymentList";
EndFunction		

#EndRegion
