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
		|	IncomingPaymentOrderPaymentList.Amount AS Amount
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
		|	QueryTable.PlaningDate AS PlaningDate
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
		|	tmp.BasisDocument AS BasisDocument
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
		|	tmp.BasisDocument";
	
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
