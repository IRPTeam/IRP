#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	
	Tables.Insert("PaymentList_PlaningCashTransactions", New ValueTable());
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
	#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	#EndRegion
		Return Tables;
	EndIf;
	
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	OutgoingPaymentOrderPaymentList.Ref.Company AS Company,
		|	OutgoingPaymentOrderPaymentList.Ref AS Ref,
		|	OutgoingPaymentOrderPaymentList.Ref.Account AS Account,
		|	OutgoingPaymentOrderPaymentList.Ref.Currency AS Currency,
		|	OutgoingPaymentOrderPaymentList.Ref.PlaningDate AS PlaningDate,
		|	OutgoingPaymentOrderPaymentList.Partner AS Partner,
		|	OutgoingPaymentOrderPaymentList.Payee AS LegalName,
		|	OutgoingPaymentOrderPaymentList.Amount AS Amount,
		|	OutgoingPaymentOrderPaymentList.Key
		|FROM
		|	Document.OutgoingPaymentOrder.PaymentList AS OutgoingPaymentOrderPaymentList
		|WHERE
		|	OutgoingPaymentOrderPaymentList.Ref = &Ref";
	
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
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
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
		|	VALUE(Enum.CashFlowDirections.Outgoing),
		|	tmp.BasisDocument,
		|	tmp.Key";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PaymentList_PlaningCashTransactions = QueryResults[1].Unload();
	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
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
	
	Tables.R3034B_CashPlanningOutgoing.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	
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
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
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
	QueryArray.Add(R1022B_VendorsPaymentPlanning());
	QueryArray.Add(R3034B_CashPlanningOutgoing());
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
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Partner AS Partner,
		|	PaymentList.Basis.Agreement AS Agreement,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.MovementType,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO PaymentList
		|FROM
		|	Document.OutgoingPaymentOrder.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref
		|	AND &StatusInfoPosting";
EndFunction

Function R1022B_VendorsPaymentPlanning()
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
		|INTO R1022B_VendorsPaymentPlanning
		|FROM 
		|	PaymentList AS PaymentList";
EndFunction

Function R3034B_CashPlanningOutgoing()
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
		|INTO R3034B_CashPlanningOutgoing
		|FROM 
		|	PaymentList AS PaymentList";
EndFunction		

#EndRegion
