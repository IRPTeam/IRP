#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("TaxesTurnovers", PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("ExpensesTurnovers", PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text =
		"SELECT
		|	CashExpensePaymentList.Ref.Company AS Company,
		|	CashExpensePaymentList.Ref.Account AS Account,
		|	CashExpensePaymentList.BusinessUnit AS BusinessUnit,
		|	CashExpensePaymentList.ExpenseType AS ExpenseType,
		|	CashExpensePaymentList.Currency AS Currency,
		|	CashExpensePaymentList.TotalAmount AS TotalAmount,
		|	CashExpensePaymentList.NetAmount AS NetAmount,
		|	CashExpensePaymentList.Ref.Date AS Period,
		|	CashExpensePaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CashExpensePaymentList.Key AS Key
		|FROM
		|	Document.CashExpense.PaymentList AS CashExpensePaymentList
		|WHERE
		|	CashExpensePaymentList.Ref = &Ref";
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultPaymentList.Unload();
	
	QueryTaxList = New Query();
	QueryTaxList.Text =
		"SELECT
		|	CashExpenseTaxList.Ref AS Document,
		|	CashExpenseTaxList.Ref.Date AS Period,
		|	CashExpenseTaxList.Key AS RowKeyUUID,
		|	CashExpenseTaxList.Tax AS Tax,
		|	CashExpenseTaxList.Analytics AS Analytics,
		|	CashExpenseTaxList.TaxRate AS TaxRate,
		|	CashExpenseTaxList.Amount AS Amount,
		|	CashExpenseTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
		|	CashExpenseTaxList.ManualAmount AS ManualAmount,
		|	CashExpensePaymentList.NetAmount AS NetAmount,
		|	CashExpensePaymentList.Currency AS Currency,
		|	CashExpensePaymentList.Key AS Key
		|FROM
		|	Document.CashExpense.TaxList AS CashExpenseTaxList
		|		INNER JOIN Document.CashExpense.PaymentList AS CashExpensePaymentList
		|		ON CashExpenseTaxList.Ref = CashExpensePaymentList.Ref
		|			AND (CashExpensePaymentList.Ref = &Ref)
		|			AND (CashExpenseTaxList.Ref = &Ref)
		|			AND (CashExpensePaymentList.Key = CashExpenseTaxList.Key)
		|WHERE
		|	CashExpenseTaxList.Ref = &Ref";
	
	QueryTaxList.SetParameter("Ref", Ref);
	QueryResultTaxList = QueryTaxList.Execute();
	QueryTableTaxList = QueryResultTaxList.Unload();
	// UUID to String
	QueryTableTaxList.Columns.Add("RowKey", Metadata.AccumulationRegisters.TaxesTurnovers.Dimensions.RowKey.Type);
	For Each Row In QueryTableTaxList Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	PaymentList.Company AS Company,
		|	PaymentList.Account AS Account,
		|	PaymentList.BusinessUnit AS BusinessUnit,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.Currency AS Currency,
		|	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	PaymentList.TotalAmount AS TotalAmount,
		|	PaymentList.NetAmount AS NetAmount,
		|	PaymentList.Period AS Period,
		|	PaymentList.Key AS Key
		|INTO tmp_paymentlist
		|FROM
		|	&PaymentList AS PaymentList
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	TaxList.Document AS Document,
		|	TaxList.Period AS Period,
		|	TaxList.RowKey AS RowKey,
		|	TaxList.Tax AS Tax,
		|	TaxList.Analytics AS Analytics,
		|	TaxList.TaxRate AS TaxRate,
		|	TaxList.Amount AS Amount,
		|	TaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
		|	TaxList.ManualAmount AS ManualAmount,
		|	TaxList.NetAmount AS NetAmount,
		|	TaxList.Currency AS Currency,
		|	TaxList.Key AS Key
		|INTO tmp_taxlist
		|FROM
		|	&TaxList AS TaxList
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_paymentlist.Company AS Company,
		|	tmp_paymentlist.BusinessUnit AS BusinessUnit,
		|	tmp_paymentlist.ExpenseType AS ExpenseType,
		|	tmp_paymentlist.Currency AS Currency,
		|	tmp_paymentlist.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp_paymentlist.NetAmount AS Amount,
		|	tmp_paymentlist.Period AS Period,
		|	tmp_paymentlist.Key AS Key
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_taxlist.Document AS Document,
		|	tmp_taxlist.Period AS Period,
		|	tmp_taxlist.RowKey AS RowKey,
		|	tmp_taxlist.Tax AS Tax,
		|	tmp_taxlist.Analytics AS Analytics,
		|	tmp_taxlist.TaxRate AS TaxRate,
		|	tmp_taxlist.Amount AS Amount,
		|	tmp_taxlist.IncludeToTotalAmount AS IncludeToTotalAmount,
		|	tmp_taxlist.ManualAmount AS ManualAmount,
		|	tmp_taxlist.NetAmount AS NetAmount,
		|	tmp_taxlist.Currency AS Currency,
		|	tmp_taxlist.Key AS Key
		|FROM
		|	tmp_taxlist AS tmp_taxlist";
	Query.SetParameter("PaymentList", QueryTablePaymentList);
	Query.SetParameter("TaxList", QueryTableTaxList);
	QueryResult = Query.ExecuteBatch();
	
	Tables.ExpensesTurnovers = QueryResult[2].Unload();
	Tables.TaxesTurnovers = QueryResult[3].Unload();
	
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
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ExpensesTurnovers));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
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
	Return QueryArray;
EndFunction

Function PaymentList()
	Return
		"SELECT
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.Currency AS Currency,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.NetAmount AS Amount,
		|	PaymentList.Key
		|INTO PaymentList
		|FROM
		|	Document.CashExpense.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
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
		|	TRUE";
EndFunction

#EndRegion
