#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("TaxesTurnovers", PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("RevenuesTurnovers", PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	Tables.Insert("AccountBalance", PostingServer.CreateTable(AccReg.AccountBalance));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text =
		"SELECT
		|	CashRevenuePaymentList.Ref.Company AS Company,
		|	CashRevenuePaymentList.Ref.Account AS Account,
		|	CashRevenuePaymentList.BusinessUnit,
		|	CashRevenuePaymentList.RevenueType,
		|	CashRevenuePaymentList.Currency,
		|	CashRevenuePaymentList.AdditionalAnalytic,
		|	CashRevenuePaymentList.TotalAmount AS TotalAmount,
		|	CashRevenuePaymentList.NetAmount AS NetAmount,
		|	CashRevenuePaymentList.Ref.Date AS Period,
		|	CashRevenuePaymentList.Key AS Key
		|FROM
		|	Document.CashRevenue.PaymentList AS CashRevenuePaymentList
		|WHERE
		|	CashRevenuePaymentList.Ref = &Ref";
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultPaymentList.Unload();
	
	QueryTaxList = New Query();
	QueryTaxList.Text =
		"SELECT
		|	CashRevenueTaxList.Ref AS Document,
		|	CashRevenueTaxList.Ref.Date AS Period,
		|	CashRevenueTaxList.Key AS RowKeyUUID,
		|	CashRevenueTaxList.Tax AS Tax,
		|	CashRevenueTaxList.Analytics AS Analytics,
		|	CashRevenueTaxList.TaxRate AS TaxRate,
		|	CashRevenueTaxList.Amount AS Amount,
		|	CashRevenueTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
		|	CashRevenueTaxList.ManualAmount AS ManualAmount,
		|	CashRevenuePaymentList.NetAmount AS NetAmount,
		|	CashRevenuePaymentList.Currency AS Currency,
		|	CashRevenuePaymentList.Key AS Key
		|FROM
		|	Document.CashRevenue.TaxList AS CashRevenueTaxList
		|		INNER JOIN Document.CashRevenue.PaymentList AS CashRevenuePaymentList
		|		ON CashRevenueTaxList.Ref = CashRevenuePaymentList.Ref
		|		AND CashRevenuePaymentList.Ref = &Ref
		|		AND CashRevenueTaxList.Ref = &Ref
		|		AND CashRevenuePaymentList.Key = CashRevenueTaxList.Key
		|WHERE
		|	CashRevenueTaxList.Ref = &Ref";
	
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
		|	PaymentList.Company,
		|	PaymentList.Account,
		|	PaymentList.BusinessUnit,
		|	PaymentList.RevenueType,
		|	PaymentList.Currency,
		|	PaymentList.AdditionalAnalytic,
		|	PaymentList.TotalAmount,
		|	PaymentList.NetAmount,
		|	PaymentList.Period,
		|	PaymentList.Key
		|INTO tmp_paymentlist
		|FROM
		|	&PaymentList AS PaymentList
		|;
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	TaxList.Document,
		|	TaxList.Period,
		|	TaxList.RowKey,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount,
		|	TaxList.NetAmount,
		|	TaxList.Currency,
		|	TaxList.Key
		|INTO tmp_taxlist
		|FROM
		|	&TaxList AS TaxList
		|;
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_paymentlist.Company,
		|	tmp_paymentlist.BusinessUnit,
		|	tmp_paymentlist.RevenueType,
		|	tmp_paymentlist.Currency,
		|	tmp_paymentlist.AdditionalAnalytic,
		|	tmp_paymentlist.NetAmount AS Amount,
		|	tmp_paymentlist.Period,
		|	tmp_paymentlist.Key
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist
		|;
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_taxlist.Document,
		|	tmp_taxlist.Period,
		|	tmp_taxlist.RowKey,
		|	tmp_taxlist.Tax,
		|	tmp_taxlist.Analytics,
		|	tmp_taxlist.TaxRate,
		|	tmp_taxlist.Amount,
		|	tmp_taxlist.IncludeToTotalAmount,
		|	tmp_taxlist.ManualAmount,
		|	tmp_taxlist.NetAmount,
		|	tmp_taxlist.Currency,
		|	tmp_taxlist.Key
		|FROM
		|	tmp_taxlist AS tmp_taxlist
		|;
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_paymentlist.Company,
		|	tmp_paymentlist.Period,
		|	tmp_paymentlist.Account,
		|	tmp_paymentlist.Currency,
		|	SUM(tmp_paymentlist.TotalAmount) AS Amount,
		|	tmp_paymentlist.Key
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist
		|GROUP BY
		|	tmp_paymentlist.Company,
		|	tmp_paymentlist.Period,
		|	tmp_paymentlist.Account,
		|	tmp_paymentlist.Currency,
		|	tmp_paymentlist.Key";
	Query.SetParameter("PaymentList", QueryTablePaymentList);
	Query.SetParameter("TaxList", QueryTableTaxList);
	QueryResult = Query.ExecuteBatch();
	
	Tables.RevenuesTurnovers = QueryResult[2].Unload();
	Tables.TaxesTurnovers = QueryResult[3].Unload();
	Tables.AccountBalance = QueryResult[4].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// RevenuesTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BusinessUnit", "BusinessUnit");
	Fields.Insert("RevenueType", "RevenueType");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("AdditionalAnalytic", "AdditionalAnalytic");
	DataMapWithLockFields.Insert("AccumulationRegister.RevenuesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.RevenuesTurnovers));
	
	// TaxesTurnovers
	Fields = New Map();
	Fields.Insert("Document", "Document");
	Fields.Insert("Tax", "Tax");
	Fields.Insert("Analytics", "Analytics");
	Fields.Insert("TaxRate", "TaxRate");
	Fields.Insert("IncludeToTotalAmount", "IncludeToTotalAmount");
	Fields.Insert("RowKey", "RowKey");
	DataMapWithLockFields.Insert("AccumulationRegister.TaxesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.TaxesTurnovers));
	
	// AccountBalance
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Account", "Account");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AccountBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.AccountBalance));
	
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
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RevenuesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.RevenuesTurnovers));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AccountBalance));

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
		|	PaymentList.RevenueType AS RevenueType,
		|	SUM(PaymentList.NetAmount) AS Amount
		|INTO PaymentList
		|FROM
		|	Document.CashRevenue.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref
		|GROUP BY
		|	PaymentList.Ref.Company,
		|	PaymentList.Ref.Account,
		|	PaymentList.Ref.Date,
		|	PaymentList.Currency,
		|	PaymentList.RevenueType";
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Account,
		|	PaymentList.Currency,
		|	PaymentList.RevenueType AS MovementType,
		|	SUM(PaymentList.Amount) AS Amount
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Receipt),
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Account,
		|	PaymentList.Currency,
		|	PaymentList.RevenueType";	
EndFunction

#EndRegion
