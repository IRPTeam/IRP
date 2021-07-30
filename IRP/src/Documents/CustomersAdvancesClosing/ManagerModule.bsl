#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables(Parameters);
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return New Structure();
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

#EndRegion

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

Function GetQueryTextsSecondaryTables(Parameters = Undefined)
	QueryArray = New Array;
	QueryArray.Add(OffsetOfAdvances(Parameters));
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T2010S_OffsetOfAdvances());
	QueryArray.Add(T2013S_OffsetOfAging());
	Return QueryArray;
EndFunction

Function T2010S_OffsetOfAdvances()
	Return
		"SELECT
		|	*
		|INTO T2010S_OffsetOfAdvances
		|FROM
		|	OffsetOfAdvances
		|WHERE
		|	TRUE";
EndFunction

Function T2013S_OffsetOfAging()
	Return
		"SELECT
		|	*
		|INTO T2013S_OffsetOfAging
		|FROM
		|	OffsetOfAging
		|WHERE
		|	TRUE";
EndFunction

Function OffsetOfAdvances(Parameters)
	If Parameters = Undefined Then
		Return CustomersAdvancesClosingQueryText();
	EndIf;
	
	ClearSelfRecords(Parameters.Object.Ref);
	
	If Parameters.Property("Unposting") And Parameters.Unposting Then	
		Return CustomersAdvancesClosingQueryText();
	Endif;
	
	OffsetOfAdvanceFull = InformationRegisters.T2010S_OffsetOfAdvances.CreateRecordSet().UnloadColumns();
	OffsetOfAdvanceFull.Columns.Delete(OffsetOfAdvanceFull.Columns.PointInTime);
	
	OffsetOfAgingFull = InformationRegisters.T2013S_OffsetOfAging.CreateRecordSet().UnloadColumns();
	OffsetOfAgingFull.Columns.Delete(OffsetOfAgingFull.Columns.PointInTime);
	
	// CustomersTransactions
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PartnerAdvances.Recorder AS Recorder,
	|	PartnerAdvances.Recorder.Date AS RecorderDate,
	|	FALSE AS IsCustomerTransaction,
	|	TRUE AS IsCustomerAdvanceOrPayment
	|INTO tmpPartnerAdvancesOrPayments
	|FROM
	|	InformationRegister.T2012S_PartnerAdvances AS PartnerAdvances
	|WHERE
	|	PartnerAdvances.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerAdvances.IsCustomerAdvance
	|	AND PartnerAdvances.Company = &Company
	|	AND PartnerAdvances.Branch = &Branch
	|GROUP BY
	|	PartnerAdvances.Recorder,
	|	PartnerAdvances.Recorder.Date
	|
	|UNION ALL
	|
	|SELECT
	|	PartnerTransactions.Recorder,
	|	PartnerTransactions.Recorder.Date,
	|	FALSE,
	|	TRUE
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerTransactions.IsPaymentFromCustomer
	|	AND PartnerTransactions.Company = &Company
	|	AND PartnerTransactions.Branch = &Branch
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PartnerTransactions.Recorder AS Recorder,
	|	PartnerTransactions.Recorder.Date AS RecorderDate,
	|	TRUE AS IsCustomerTransaction,
	|	FALSE AS IsCustomerAdvanceOrPayment
	|INTO tmp
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerTransactions.IsCustomerTransaction
	|	AND PartnerTransactions.Company = &Company
	|	AND PartnerTransactions.Branch = &Branch
	|
	|UNION ALL
	|
	|SELECT
	|	tmpPartnerAdvancesOrPayments.Recorder,
	|	tmpPartnerAdvancesOrPayments.RecorderDate,
	|	tmpPartnerAdvancesOrPayments.IsCustomerTransaction,
	|	tmpPartnerAdvancesOrPayments.IsCustomerAdvanceOrPayment
	|FROM
	|	tmpPartnerAdvancesOrPayments AS tmpPartnerAdvancesOrPayments
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Recorder,
	|	tmp.IsCustomerTransaction,
	|	tmp.IsCustomerAdvanceOrPayment
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Recorder,
	|	tmp.IsCustomerTransaction,
	|	tmp.IsCustomerAdvanceOrPayment,
	|	tmp.RecorderDate
	|ORDER BY
	|	tmp.RecorderDate";
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"      , Parameters.Object.Company);
	Query.SetParameter("Branch"       , Parameters.Object.Branch);
	
	
	QueryTable = Query.Execute().Unload();
	For Each Row In QueryTable Do
		Parameters.Insert("RecorderPointInTime", Row.Recorder.PointInTime());
		If Row.IsCustomerTransaction Then
			Create_CustomersTransactions(Row.Recorder, Parameters);
			Create_CustomersAging(Row.Recorder, Parameters);
			OffsetOfPartnersServer.Customers_OnTransaction(Parameters);
			Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull);
			Write_PartnersAging(Row.Recorder, Parameters, OffsetOfAgingFull);
			Drop_Table(Parameters, "CustomersTransactions");
			Drop_Table(Parameters, "Aging");
			
			Drop_Table(Parameters, "OffsetOfAdvanceFromCustomers");
			Drop_Table(Parameters, "OffsetOfAging");
		EndIf;
		
		If Row.IsCustomerAdvanceOrPayment Then
			Create_AdvancesFromCustomers(Row.Recorder, Parameters);
			Create_PaymentFromCustomers(Row.Recorder, Parameters);
			OffsetOfPartnersServer.Customers_OnMoneyMovements(Parameters);
			Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull, True);
			Write_PartnersAging(Row.Recorder, Parameters, OffsetOfAgingFull);
			
			// Due as advance
			If CommonFunctionsClientServer.ObjectHasProperty(Row.Recorder, "DueAsAdvance") 
				And Row.Recorder.DueAsAdvance Then
				OffsetOfPartnersServer.Customers_DueAsAdvance(Parameters);
				Write_AdvancesAndTransactions_DueAsAdvance(Row.Recorder, Parameters, OffsetOfAdvanceFull);
				Drop_Table(Parameters, "Transactions");
				Drop_Table(Parameters, "TransactionsBalance");
				Drop_Table(Parameters, "DueAsAdvanceFromCustomers");
			EndIf;
			
			Drop_Table(Parameters, "CustomersTransactions");
			Drop_Table(Parameters, "AdvancesFromCustomers");
			
			Drop_Table(Parameters, "OffsetOfAdvanceFromCustomers");
			Drop_Table(Parameters, "OffsetOfAging");
		EndIf;
		
	EndDo;
		
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	OffsetOfAdvanceFull.Period,
	|	OffsetOfAdvanceFull.Document,
	|	OffsetOfAdvanceFull.Company,
	|	OffsetOfAdvanceFull.Branch,
	|	OffsetOfAdvanceFull.Currency,
	|	OffsetOfAdvanceFull.Partner,
	|	OffsetOfAdvanceFull.LegalName,
	|	OffsetOfAdvanceFull.TransactionDocument,
	|	OffsetOfAdvanceFull.AdvancesDocument,
	|	OffsetOfAdvanceFull.Agreement,
	|	OffsetOfAdvanceFull.Key,
	|	OffsetOfAdvanceFull.Amount,
	|	OffsetOfAdvanceFull.DueAsAdvance
	|INTO tmpOffsetOfAdvances
	|FROM
	|	&OffsetOfAdvanceFull AS OffsetOfAdvanceFull
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	OffsetOfAgingFull.Period,
	|	OffsetOfAgingFull.Document,
	|	OffsetOfAgingFull.Company,
	|	OffsetOfAgingFull.Branch,
	|	OffsetOfAgingFull.Currency,
	|	OffsetOfAgingFull.Partner,
	|	OffsetOfAgingFull.Agreement,
	|	OffsetOfAgingFull.Invoice,
	|	OffsetOfAgingFull.PaymentDate,
	|	OffsetOfAgingFull.Amount
	|INTO tmpOffsetOfAging
	|FROM
	|	&OffsetOfAgingFull AS OffsetOfAgingFull
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpOffsetOfAdvances.Period,
	|	tmpOffsetOfAdvances.Document,
	|	tmpOffsetOfAdvances.Company,
	|	tmpOffsetOfAdvances.Branch,
	|	tmpOffsetOfAdvances.Currency,
	|	tmpOffsetOfAdvances.Partner,
	|	tmpOffsetOfAdvances.LegalName,
	|	tmpOffsetOfAdvances.TransactionDocument,
	|	tmpOffsetOfAdvances.AdvancesDocument,
	|	tmpOffsetOfAdvances.Agreement,
	|	tmpOffsetOfAdvances.Key,
	|	tmpOffsetOfAdvances.DueAsAdvance,
	|	SUM(tmpOffsetOfAdvances.Amount) AS Amount
	|INTO OffsetOfAdvances
	|FROM
	|	tmpOffsetOfAdvances AS tmpOffsetOfAdvances
	|GROUP BY
	|	tmpOffsetOfAdvances.Period,
	|	tmpOffsetOfAdvances.Document,
	|	tmpOffsetOfAdvances.Company,
	|	tmpOffsetOfAdvances.Branch,
	|	tmpOffsetOfAdvances.Currency,
	|	tmpOffsetOfAdvances.Partner,
	|	tmpOffsetOfAdvances.LegalName,
	|	tmpOffsetOfAdvances.TransactionDocument,
	|	tmpOffsetOfAdvances.AdvancesDocument,
	|	tmpOffsetOfAdvances.Agreement,
	|	tmpOffsetOfAdvances.Key,
	|	tmpOffsetOfAdvances.DueAsAdvance
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpOffsetOfAging.Period,
	|	tmpOffsetOfAging.Document,
	|	tmpOffsetOfAging.Company,
	|	tmpOffsetOfAging.Branch,
	|	tmpOffsetOfAging.Currency,
	|	tmpOffsetOfAging.Partner,
	|	tmpOffsetOfAging.Agreement,
	|	tmpOffsetOfAging.Invoice,
	|	tmpOffsetOfAging.PaymentDate,
	|	SUM(tmpOffsetOfAging.Amount) AS Amount
	|INTO OffsetOfAging
	|FROM
	|	tmpOffsetOfAging AS tmpOffsetOfAging
	|GROUP BY
	|	tmpOffsetOfAging.Period,
	|	tmpOffsetOfAging.Document,
	|	tmpOffsetOfAging.Company,
	|	tmpOffsetOfAging.Branch,
	|	tmpOffsetOfAging.Currency,
	|	tmpOffsetOfAging.Partner,
	|	tmpOffsetOfAging.Agreement,
	|	tmpOffsetOfAging.Invoice,
	|	tmpOffsetOfAging.PaymentDate";
	
	Query.SetParameter("OffsetOfAdvanceFull", OffsetOfAdvanceFull);
	Query.SetParameter("OffsetOfAgingFull", OffsetOfAgingFull);
	
	Query.Execute(); 
	
	Return CustomersAdvancesClosingQueryText();
EndFunction

Function CustomersAdvancesClosingQueryText()
	Return 
		"SELECT *
		|INTO OffsetOfAdvancesEmpty
		|FROM
		|	Document.VendorsAdvancesClosing AS OffsetOfAdvance
		|WHERE
		|	FALSE";
EndFunction	

Procedure ClearSelfRecords(Ref)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R2020B_AdvancesFromCustomers.Recorder
	|FROM
	|	AccumulationRegister.R2020B_AdvancesFromCustomers AS R2020B_AdvancesFromCustomers
	|WHERE
	|	R2020B_AdvancesFromCustomers.CustomersAdvancesClosing = &Ref
	|GROUP BY
	|	R2020B_AdvancesFromCustomers.Recorder
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R2021B_CustomersTransactions.Recorder
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions AS R2021B_CustomersTransactions
	|WHERE
	|	R2021B_CustomersTransactions.CustomersAdvancesClosing = &Ref
	|GROUP BY
	|	R2021B_CustomersTransactions.Recorder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R5011B_CustomersAging.Recorder
	|FROM
	|	AccumulationRegister.R5011B_CustomersAging AS R5011B_CustomersAging
	|WHERE
	|	R5011B_CustomersAging.AgingClosing = &Ref
	|GROUP BY
	|	R5011B_CustomersAging.Recorder";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	For Each Row In QueryResults[0].Unload() Do
		RecordSet = AccumulationRegisters.R2020B_AdvancesFromCustomers.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Record In RecordSet Do
			If Record.CustomersAdvancesClosing = Ref Then
				ArrayForDelete.Add(Record);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
	
	For Each Row In QueryResults[1].Unload() Do
		RecordSet = AccumulationRegisters.R2021B_CustomersTransactions.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Record In RecordSet Do
			If Record.CustomersAdvancesClosing = Ref Then
				ArrayForDelete.Add(Record);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
	
	For Each Row In QueryResults[2].Unload() Do
		RecordSet = AccumulationRegisters.R5011B_CustomersAging.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Record In RecordSet Do
			If Record.AgingClosing = Ref Then
				ArrayForDelete.Add(Record);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure

// CustomersTransactions
//	*Period
//	*Company
//	*Currency
//	*Partner
//	*LegalName
//	*TransactionDocument
//	*Agreement
//	*DocumentAmount
//	*Key
Procedure Create_CustomersTransactions(Recorder, Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	PartnerTransactions.Period,
	|	PartnerTransactions.Company,
	|	PartnerTransactions.Branch,
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.TransactionDocument,
	|	PartnerTransactions.Agreement,
	|	SUM(PartnerTransactions.Amount) AS DocumentAmount,
	|	CASE
	|		WHEN &IsDebitCreditNote
	|			THEN PartnerTransactions.Key
	|		ELSE """"
	|	END AS Key
	|INTO tmpCustomersTransactions
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder
	|	AND PartnerTransactions.IsCustomerTransaction
	|GROUP BY
	|	PartnerTransactions.Agreement,
	|	PartnerTransactions.Company,
	|	PartnerTransactions.Branch,
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.Period,
	|	PartnerTransactions.TransactionDocument,
	|	CASE
	|		WHEN &IsDebitCreditNote
	|			THEN PartnerTransactions.Key
	|		ELSE """"
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpCustomersTransactions.Period,
	|	tmpCustomersTransactions.Company,
	|	tmpCustomersTransactions.Branch,
	|	tmpCustomersTransactions.Currency,
	|	tmpCustomersTransactions.Partner,
	|	tmpCustomersTransactions.LegalName,
	|	tmpCustomersTransactions.Agreement,
	|	tmpCustomersTransactions.TransactionDocument,
	|	tmpCustomersTransactions.Key,
	|	R2021B_CustomersTransactionsBalance.AmountBalance AS DocumentAmount,
	|	FALSE AS IgnoreAdvances
	|INTO CustomersTransactions
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period, (Company, Branch, Currency, LegalName, Partner, Agreement,
	|		Basis) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.LegalName,
	|			tmp.Partner,
	|			tmp.Agreement,
	|			tmp.TransactionDocument
	|		FROM
	|			tmpCustomersTransactions AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|		LEFT JOIN tmpCustomersTransactions AS tmpCustomersTransactions
	|		ON R2021B_CustomersTransactionsBalance.Company = tmpCustomersTransactions.Company
	|		AND R2021B_CustomersTransactionsBalance.Branch = tmpCustomersTransactions.Branch
	|		AND R2021B_CustomersTransactionsBalance.Currency = tmpCustomersTransactions.Currency
	|		AND R2021B_CustomersTransactionsBalance.Partner = tmpCustomersTransactions.Partner
	|		AND R2021B_CustomersTransactionsBalance.LegalName = tmpCustomersTransactions.LegalName
	|		AND R2021B_CustomersTransactionsBalance.Agreement = tmpCustomersTransactions.Agreement
	|		AND R2021B_CustomersTransactionsBalance.Basis = tmpCustomersTransactions.TransactionDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|DROP tmpCustomersTransactions";
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Including));	
	Query.SetParameter("Recorder", Recorder);
	Query.SetParameter("IsDebitCreditNote", OffsetOfPartnersServer.IsDebitCreditNote(Recorder));
	Query.Execute(); 
EndProcedure

// Aging
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *Invoice
//  *PaymentDate
//  *Agreement
//  *Amount
Procedure Create_CustomersAging(Recorder, Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	R5011B_CustomersAging.Period,
	|	R5011B_CustomersAging.Company,
	|	R5011B_CustomersAging.Branch,
	|	R5011B_CustomersAging.Currency,
	|	R5011B_CustomersAging.Partner,
	|	R5011B_CustomersAging.Invoice,
	|	R5011B_CustomersAging.PaymentDate,
	|	R5011B_CustomersAging.Agreement,
	|	R5011B_CustomersAging.Amount
	|INTO Aging
	|FROM
	|	AccumulationRegister.R5011B_CustomersAging AS R5011B_CustomersAging
	|WHERE
	|	R5011B_CustomersAging.RecordType = VALUE(AccumulationRecordType.Receipt)
	|	AND R5011B_CustomersAging.Recorder = &Recorder";
	Query.SetParameter("Recorder", Recorder);
	Query.Execute();
EndProcedure

Procedure Create_PaymentFromCustomers(Recorder, Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	PartnerTransactions.Period,
	|	PartnerTransactions.Company,
	|	PartnerTransactions.Branch,
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.TransactionDocument,
	|	PartnerTransactions.Agreement,
	|	SUM(PartnerTransactions.Amount) AS Amount,
	|	FALSE AS IgnoreAdvances,
	|	PartnerTransactions.Key
	|INTO CustomersTransactions
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder
	|	and PartnerTransactions.IsPaymentFromCustomer
	|GROUP BY
	|	PartnerTransactions.Agreement,
	|	PartnerTransactions.Company,
	|	PartnerTransactions.Branch,
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.Period,
	|	PartnerTransactions.TransactionDocument,
	|	PartnerTransactions.Key";
	Query.SetParameter("Recorder", Recorder);
	Query.Execute(); 
EndProcedure

// AdvancesFromCustomers
//  *Period
//  *Company
//  *Partner
//  *LegalName
//  *Currency
//  *DocumentAmount
//  *AdvancesDocument
//  *Key
Procedure Create_AdvancesFromCustomers(Recorder, Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	PartnerAdvances.Period,
	|	PartnerAdvances.Company,
	|	PartnerAdvances.Branch,
	|	PartnerAdvances.Currency,
	|	PartnerAdvances.Partner,
	|	PartnerAdvances.LegalName,
	|	PartnerAdvances.AdvancesDocument,
	|	PartnerAdvances.Amount AS DocumentAmount,
	|	PartnerAdvances.Key
	|INTO AdvancesFromCustomers
	|FROM
	|	InformationRegister.T2012S_PartnerAdvances AS PartnerAdvances
	|WHERE
	|	PartnerAdvances.Recorder = &Recorder";
	Query.SetParameter("Recorder", Recorder);
	Query.Execute();
EndProcedure

Procedure Drop_Table(Parameters, TableName)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "DROP " + TableName;
	Query.Execute();
EndProcedure

// DueAsAdvanceFromCustomers
//  *Period
//  *Company
//  *Partner
//  *LegalName
//  *Agreement
//  *Currency
//  *TransactionDocument
//  *AdvancesDocument
//  *Key
//  *Amount
Procedure Write_AdvancesAndTransactions_DueAsAdvance(Recorder, Parameters, OffsetOfAdvanceFull)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	DueAsAdvanceFromCustomers.Period,
	|	DueAsAdvanceFromCustomers.Company,
	|	DueAsAdvanceFromCustomers.Branch,
	|	DueAsAdvanceFromCustomers.Partner,
	|	DueAsAdvanceFromCustomers.LegalName,
	|	DueAsAdvanceFromCustomers.Agreement,
	|	DueAsAdvanceFromCustomers.Currency,
	|	DueAsAdvanceFromCustomers.TransactionDocument,
	|	DueAsAdvanceFromCustomers.AdvancesDocument,
	|	DueAsAdvanceFromCustomers.Key,
	|	DueAsAdvanceFromCustomers.Amount,
	|	&CustomersAdvancesClosing AS CustomersAdvancesClosing,
	|	&Document AS Document,
	|	&Document AS Recorder,
	|	TRUE AS DueAsAdvance
	|FROM
	|	DueAsAdvanceFromCustomers AS DueAsAdvanceFromCustomers";
	Query.SetParameter("CustomersAdvancesClosing", Parameters.Object.Ref);
	Query.SetParameter("Document", Recorder);
	
	QueryTable = Query.Execute().Unload();
	
	RecordSet_AdvancesFromCustomers = AccumulationRegisters.R2020B_AdvancesFromCustomers.CreateRecordSet();
	RecordSet_AdvancesFromCustomers.Filter.Recorder.Set(Recorder);
	TableAdvances = RecordSet_AdvancesFromCustomers.UnloadColumns();
	TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	
	
	RecordSet_CustomersTransactions = AccumulationRegisters.R2021B_CustomersTransactions.CreateRecordSet();
	RecordSet_CustomersTransactions.Filter.Recorder.Set(Recorder);
	TableTransactions = RecordSet_CustomersTransactions.UnloadColumns();
	TableTransactions.Columns.Delete(TableTransactions.Columns.PointInTime);
	
	For Each Row In QueryTable Do
				
		FillPropertyValues(OffsetOfAdvanceFull.Add(), Row);
		
		NewRow_Advances = TableAdvances.Add();
		FillPropertyValues(NewRow_Advances, Row);
		NewRow_Advances.RecordType = AccumulationRecordType.Expense;
		NewRow_Advances.Basis = Row.AdvancesDocument;
			
		NewRow_Transactions = TableTransactions.Add();
		FillPropertyValues(NewRow_Transactions, Row);
		NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
		NewRow_Transactions.Basis = Row.TransactionDocument;
	
	EndDo;
	
	// Currency calculation
	CurrenciesParameters = New Structure();
	
	PostingDataTables = New Map();
	
	PostingDataTables.Insert(RecordSet_AdvancesFromCustomers,   New Structure("RecordSet", TableAdvances));
	PostingDataTables.Insert(RecordSet_CustomersTransactions, New Structure("RecordSet", TableTransactions));
	
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	
	CurrenciesParameters.Insert("Object", Recorder);
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2020B_AdvancesFromCustomers") Then
			RecordSet_AdvancesFromCustomers.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_AdvancesFromCustomers.Add(), Row);
			EndDo;
			RecordSet_AdvancesFromCustomers.SetActive(True);
			RecordSet_AdvancesFromCustomers.Write();
		EndIf;
	
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2021B_CustomersTransactions") Then
			RecordSet_CustomersTransactions.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_CustomersTransactions.Add(), Row);
			EndDo;
			RecordSet_CustomersTransactions.SetActive(True);
			RecordSet_CustomersTransactions.Write();
		EndIf;
	EndDo;
EndProcedure

// OffsetOfAdvance
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *AdvancesDocument
//  *Agreement
//  *Amount
Procedure Write_AdvancesAndTransactions(Recorder, Parameters, OffsetOfAdvanceFull, UseKeyForAdvance = False)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	OffsetOfAdvance.Period,
	|	OffsetOfAdvance.Company,
	|	OffsetOfAdvance.Branch,
	|	OffsetOfAdvance.Currency,
	|	OffsetOfAdvance.Partner,
	|	OffsetOfAdvance.LegalName,
	|	OffsetOfAdvance.TransactionDocument,
	|	OffsetOfAdvance.AdvancesDocument,
	|	OffsetOfAdvance.Agreement,
	|	OffsetOfAdvance.Amount,
	|	OffsetOfAdvance.Key,
	|	&CustomersAdvancesClosing AS CustomersAdvancesClosing,
	|	&Document AS Document,
	|	&Document AS Recorder
	|FROM
	|	OffsetOfAdvanceFromCustomers AS OffsetOfAdvance";
	Query.SetParameter("CustomersAdvancesClosing", Parameters.Object.Ref);
	Query.SetParameter("Document", Recorder);
	
	QueryTable = Query.Execute().Unload();
	
	RecordSet_AdvancesFromCustomers = AccumulationRegisters.R2020B_AdvancesFromCustomers.CreateRecordSet();
	RecordSet_AdvancesFromCustomers.Filter.Recorder.Set(Recorder);
	TableAdvances = RecordSet_AdvancesFromCustomers.UnloadColumns();
	TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	
	
	RecordSet_CustomersTransactions = AccumulationRegisters.R2021B_CustomersTransactions.CreateRecordSet();
	RecordSet_CustomersTransactions.Filter.Recorder.Set(Recorder);
	TableTransactions = RecordSet_CustomersTransactions.UnloadColumns();
	TableTransactions.Columns.Delete(TableTransactions.Columns.PointInTime);
	
	IsDebitCreditNote = OffsetOfPartnersServer.IsDebitCreditNote(Recorder); 
	If IsDebitCreditNote Then
		TableTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	EndIf;
	
	If IsDebitCreditNote Or UseKeyForAdvance Then
		TableAdvances.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	EndIf;
	
	For Each Row In QueryTable Do
				
		FillPropertyValues(OffsetOfAdvanceFull.Add(), Row);
		
		NewRow_Advances = TableAdvances.Add();
		FillPropertyValues(NewRow_Advances, Row);
		NewRow_Advances.RecordType = AccumulationRecordType.Expense;
		NewRow_Advances.Basis = Row.AdvancesDocument;
			
		NewRow_Transactions = TableTransactions.Add();
		FillPropertyValues(NewRow_Transactions, Row);
		NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
		NewRow_Transactions.Basis = Row.TransactionDocument;
	
	EndDo;
	
	// Currency calculation
	CurrenciesParameters = New Structure();
	
	PostingDataTables = New Map();
	
	PostingDataTables.Insert(RecordSet_AdvancesFromCustomers,   New Structure("RecordSet", TableAdvances));
	PostingDataTables.Insert(RecordSet_CustomersTransactions, New Structure("RecordSet", TableTransactions));
	
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	
	CurrenciesParameters.Insert("Object", Recorder);
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2020B_AdvancesFromCustomers") Then
			RecordSet_AdvancesFromCustomers.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_AdvancesFromCustomers.Add(), Row);
			EndDo;
			RecordSet_AdvancesFromCustomers.SetActive(True);
			RecordSet_AdvancesFromCustomers.Write();
		EndIf;
	
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2021B_CustomersTransactions") Then
			RecordSet_CustomersTransactions.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_CustomersTransactions.Add(), Row);
			EndDo;
			RecordSet_CustomersTransactions.SetActive(True);
			RecordSet_CustomersTransactions.Write();
		EndIf;
	EndDo;
EndProcedure

// OffsetOfAging
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *Invoice
//  *PaymentDate
//  *Agreement
//  *Amount
Procedure Write_PartnersAging(Recorder, Parameters, OffsetOfAgingFull)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	OffsetOfAging.Period,
	|	OffsetOfAging.Company,
	|	OffsetOfAging.Branch,
	|	OffsetOfAging.Currency,
	|	OffsetOfAging.Partner,
	|	OffsetOfAging.Invoice,
	|	OffsetOfAging.PaymentDate,
	|	OffsetOfAging.Agreement,
	|	OffsetOfAging.Amount,
	|	&AgingClosing AS AgingClosing,
	|	&Document AS Document,
	|	&Document AS Recorder
	|FROM
	|	OffsetOfAging AS OffsetOfAging";
	Query.SetParameter("AgingClosing", Parameters.Object.Ref);
	Query.SetParameter("Document", Recorder);
	
	QueryTable = Query.Execute().Unload();
	
	RecordSet_Aging = AccumulationRegisters.R5011B_CustomersAging.CreateRecordSet();
	RecordSet_Aging.Filter.Recorder.Set(Recorder);
	TableAging = RecordSet_Aging.UnloadColumns();
	TableAging.Columns.Delete(TableAging.Columns.PointInTime);
		
	For Each Row In QueryTable Do
				
		FillPropertyValues(OffsetOfAgingFull.Add(), Row);
		
		NewRow_Advances = TableAging.Add();
		FillPropertyValues(NewRow_Advances, Row);
		NewRow_Advances.RecordType = AccumulationRecordType.Expense;
	
	EndDo;
	
	RecordSet_Aging.Read();
	For Each Row In TableAging Do
		FillPropertyValues(RecordSet_Aging.Add(), Row);
	EndDo;
	RecordSet_Aging.SetActive(True);
	RecordSet_Aging.Write();
EndProcedure
