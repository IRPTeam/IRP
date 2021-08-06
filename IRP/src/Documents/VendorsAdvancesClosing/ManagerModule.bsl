#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

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
		Return VendorsAdvancesClosingQueryText();
	EndIf;
	
	ClearSelfRecords(Parameters.Object.Ref);
	
	If Parameters.Property("Unposting") And Parameters.Unposting Then	
		Return VendorsAdvancesClosingQueryText();
	Endif;
	
	OffsetOfAdvanceFull = InformationRegisters.T2010S_OffsetOfAdvances.CreateRecordSet().UnloadColumns();
	OffsetOfAdvanceFull.Columns.Delete(OffsetOfAdvanceFull.Columns.PointInTime);
	
	OffsetOfAgingFull = InformationRegisters.T2013S_OffsetOfAging.CreateRecordSet().UnloadColumns();
	OffsetOfAgingFull.Columns.Delete(OffsetOfAgingFull.Columns.PointInTime);
	
	// VendorsTransactions
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PartnerAdvances.Recorder AS Recorder,
	|	PartnerAdvances.Recorder.Date AS RecorderDate,
	|	FALSE AS IsVendorTransaction,
	|	TRUE AS IsVendorAdvanceOrPayment
	|INTO tmpPartnerAdvancesOrPayments
	|FROM
	|	InformationRegister.T2012S_PartnerAdvances AS PartnerAdvances
	|WHERE
	|	PartnerAdvances.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerAdvances.IsVendorAdvance
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
	|	AND PartnerTransactions.IsPaymentToVendor
	|	AND PartnerTransactions.Company = &Company
	|	AND PartnerTransactions.Branch = &Branch
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PartnerTransactions.Recorder AS Recorder,
	|	PartnerTransactions.Recorder.Date AS RecorderDate,
	|	TRUE AS IsVendorTransaction,
	|	FALSE AS IsVendorAdvanceOrPayment
	|INTO tmp
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerTransactions.IsVendorTransaction
	|	AND PartnerTransactions.Company = &Company
	|	AND PartnerTransactions.Branch = &Branch
	|
	|UNION ALL
	|
	|SELECT
	|	tmpPartnerAdvancesOrPayments.Recorder,
	|	tmpPartnerAdvancesOrPayments.RecorderDate,
	|	tmpPartnerAdvancesOrPayments.IsVendorTransaction,
	|	tmpPartnerAdvancesOrPayments.IsVendorAdvanceOrPayment
	|FROM
	|	tmpPartnerAdvancesOrPayments AS tmpPartnerAdvancesOrPayments
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Recorder,
	|	tmp.IsVendorTransaction,
	|	tmp.IsVendorAdvanceOrPayment
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Recorder,
	|	tmp.IsVendorTransaction,
	|	tmp.IsVendorAdvanceOrPayment,
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
		If Row.IsVendorTransaction Then
			Create_VendorsTransactions(Row.Recorder, Parameters);
			Create_VendorsAging(Row.Recorder, Parameters);
			OffsetOfPartnersServer.Vendors_OnTransaction(Parameters);
			Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull);
			Write_PartnersAging(Row.Recorder, Parameters, OffsetOfAgingFull);
			Drop_Table(Parameters, "VendorsTransactions");
			Drop_Table(Parameters, "Aging");
			
			Drop_Table(Parameters, "OffsetOfAdvanceToVendors");
			Drop_Table(Parameters, "OffsetOfAging");
		EndIf;
		
		If Row.IsVendorAdvanceOrPayment Then
			Create_AdvancesToVendors(Row.Recorder, Parameters);
			Create_PaymentToVendors(Row.Recorder, Parameters);
			OffsetOfPartnersServer.Vendors_OnMoneyMovements(Parameters);
			Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull, True);
			Write_PartnersAging(Row.Recorder, Parameters, OffsetOfAgingFull);
			
			// Due as advance
			If CommonFunctionsClientServer.ObjectHasProperty(Row.Recorder, "DueAsAdvance") 
				And Row.Recorder.DueAsAdvance Then
				OffsetOfPartnersServer.Vendors_DueAsAdvance(Parameters);
				Write_AdvancesAndTransactions_DueAsAdvance(Row.Recorder, Parameters, OffsetOfAdvanceFull);
				Drop_Table(Parameters, "Transactions");
				Drop_Table(Parameters, "TransactionsBalance");
				Drop_Table(Parameters, "DueAsAdvanceToVendors");
			EndIf;
			
			Drop_Table(Parameters, "VendorsTransactions");
			Drop_Table(Parameters, "AdvancesToVendors");
			
			Drop_Table(Parameters, "OffsetOfAdvanceToVendors");
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
	
	Return VendorsAdvancesClosingQueryText();
EndFunction

Function VendorsAdvancesClosingQueryText()
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
	|	R1020B_AdvancesToVendors.Recorder
	|FROM
	|	AccumulationRegister.R1020B_AdvancesToVendors AS R1020B_AdvancesToVendors
	|WHERE
	|	R1020B_AdvancesToVendors.VendorsAdvancesClosing = &Ref
	|GROUP BY
	|	R1020B_AdvancesToVendors.Recorder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R1021B_VendorsTransactions.Recorder
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions AS R1021B_VendorsTransactions
	|WHERE
	|	R1021B_VendorsTransactions.VendorsAdvancesClosing = &Ref
	|GROUP BY
	|	R1021B_VendorsTransactions.Recorder
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R5012B_VendorsAging.Recorder
	|FROM
	|	AccumulationRegister.R5012B_VendorsAging AS R5012B_VendorsAging
	|WHERE
	|	R5012B_VendorsAging.AgingClosing = &Ref
	|GROUP BY
	|	R5012B_VendorsAging.Recorder";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	For Each Row In QueryResults[0].Unload() Do
		RecordSet = AccumulationRegisters.R1020B_AdvancesToVendors.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Record In RecordSet Do
			If Record.VendorsAdvancesClosing = Ref Then
				ArrayForDelete.Add(Record);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
	
	For Each Row In QueryResults[1].Unload() Do
		RecordSet = AccumulationRegisters.R1021B_VendorsTransactions.CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Record In RecordSet Do
			If Record.VendorsAdvancesClosing = Ref Then
				ArrayForDelete.Add(Record);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
	
	For Each Row In QueryResults[2].Unload() Do
		RecordSet = AccumulationRegisters.R5012B_VendorsAging.CreateRecordSet();
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

// VendorsTransactions
//	*Period
//	*Company
//	*Currency
//	*Partner
//	*LegalName
//	*TransactionDocument
//	*Agreement
//	*DocumentAmount
//	*Key
Procedure Create_VendorsTransactions(Recorder, Parameters)
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
	|INTO tmpVendorsTransactions
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder
	|	AND PartnerTransactions.IsVendorTransaction
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
	|	tmpVendorsTransactions.Period,
	|	tmpVendorsTransactions.Company,
	|	tmpVendorsTransactions.Branch,
	|	tmpVendorsTransactions.Currency,
	|	tmpVendorsTransactions.Partner,
	|	tmpVendorsTransactions.LegalName,
	|	tmpVendorsTransactions.Agreement,
	|	tmpVendorsTransactions.TransactionDocument,
	|	tmpVendorsTransactions.Key,
	|	R1021B_VendorsTransactionsBalance.AmountBalance AS DocumentAmount,
	|	FALSE AS IgnoreAdvances
	|	INTO VendorsTransactions
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Period, (Company, Branch, Currency, LegalName, Partner, Agreement,
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
	|			tmpVendorsTransactions AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1021B_VendorsTransactionsBalance
	|		LEFT JOIN tmpVendorsTransactions AS tmpVendorsTransactions
	|		ON R1021B_VendorsTransactionsBalance.Company = tmpVendorsTransactions.Company
	|		AND R1021B_VendorsTransactionsBalance.Branch = tmpVendorsTransactions.Branch
	|		AND R1021B_VendorsTransactionsBalance.Currency = tmpVendorsTransactions.Currency
	|		AND R1021B_VendorsTransactionsBalance.Partner = tmpVendorsTransactions.Partner
	|		AND R1021B_VendorsTransactionsBalance.LegalName = tmpVendorsTransactions.LegalName
	|		AND R1021B_VendorsTransactionsBalance.Agreement = tmpVendorsTransactions.Agreement
	|		AND R1021B_VendorsTransactionsBalance.Basis = tmpVendorsTransactions.TransactionDocument
	|;
	|DROP tmpVendorsTransactions";
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
Procedure Create_VendorsAging(Recorder, Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	R5012B_VendorsAging.Period,
	|	R5012B_VendorsAging.Company,
	|	R5012B_VendorsAging.Branch,
	|	R5012B_VendorsAging.Currency,
	|	R5012B_VendorsAging.Partner,
	|	R5012B_VendorsAging.Invoice,
	|	R5012B_VendorsAging.PaymentDate,
	|	R5012B_VendorsAging.Agreement,
	|	R5012B_VendorsAging.Amount
	|INTO Aging
	|FROM
	|	AccumulationRegister.R5012B_VendorsAging AS R5012B_VendorsAging
	|WHERE
	|	R5012B_VendorsAging.RecordType = VALUE(AccumulationRecordType.Receipt)
	|	AND R5012B_VendorsAging.Recorder = &Recorder";
	Query.SetParameter("Recorder", Recorder);
	Query.Execute();
EndProcedure

Procedure Create_PaymentToVendors(Recorder, Parameters)
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
	|INTO VendorsTransactions
	|FROM
	|	InformationRegister.T2011S_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder
	|	and PartnerTransactions.IsPaymentToVendor
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

// AdvancesToVendors
//  *Period
//  *Company
//  *Partner
//  *LegalName
//  *Currency
//  *DocumentAmount
//  *AdvancesDocument
//  *Key
Procedure Create_AdvancesToVendors(Recorder, Parameters)
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
	|INTO AdvancesToVendors
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

// DueAsAdvanceToVendors
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
	|	DueAsAdvanceToVendors.Period,
	|	DueAsAdvanceToVendors.Company,
	|	DueAsAdvanceToVendors.Branch,
	|	DueAsAdvanceToVendors.Partner,
	|	DueAsAdvanceToVendors.LegalName,
	|	DueAsAdvanceToVendors.Agreement,
	|	DueAsAdvanceToVendors.Currency,
	|	DueAsAdvanceToVendors.TransactionDocument,
	|	DueAsAdvanceToVendors.AdvancesDocument,
	|	DueAsAdvanceToVendors.Key,
	|	DueAsAdvanceToVendors.Amount,
	|	&VendorsAdvancesClosing AS VendorsAdvancesClosing,
	|	&Document AS Document,
	|	&Document AS Recorder,
	|	TRUE AS DueAsAdvance
	|FROM
	|	DueAsAdvanceToVendors AS DueAsAdvanceToVendors";
	Query.SetParameter("VendorsAdvancesClosing", Parameters.Object.Ref);
	Query.SetParameter("Document", Recorder);
	
	QueryTable = Query.Execute().Unload();
	
	RecordSet_AdvancesToVendors = AccumulationRegisters.R1020B_AdvancesToVendors.CreateRecordSet();
	RecordSet_AdvancesToVendors.Filter.Recorder.Set(Recorder);
	TableAdvances = RecordSet_AdvancesToVendors.UnloadColumns();
	TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	
	
	RecordSet_VendorsTransactions = AccumulationRegisters.R1021B_VendorsTransactions.CreateRecordSet();
	RecordSet_VendorsTransactions.Filter.Recorder.Set(Recorder);
	TableTransactions = RecordSet_VendorsTransactions.UnloadColumns();
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
	
	PostingDataTables.Insert(RecordSet_AdvancesToVendors,   New Structure("RecordSet", TableAdvances));
	PostingDataTables.Insert(RecordSet_VendorsTransactions, New Structure("RecordSet", TableTransactions));
	
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	
	CurrenciesParameters.Insert("Object", Recorder);
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1020B_AdvancesToVendors") Then
			RecordSet_AdvancesToVendors.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_AdvancesToVendors.Add(), Row);
			EndDo;
			RecordSet_AdvancesToVendors.SetActive(True);
			RecordSet_AdvancesToVendors.Write();
		EndIf;
	
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions") Then
			RecordSet_VendorsTransactions.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_VendorsTransactions.Add(), Row);
			EndDo;
			RecordSet_VendorsTransactions.SetActive(True);
			RecordSet_VendorsTransactions.Write();
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
	|	&VendorsAdvancesClosing AS VendorsAdvancesClosing,
	|	&Document AS Document,
	|	&Document AS Recorder
	|FROM
	|	OffsetOfAdvanceToVendors AS OffsetOfAdvance";
	Query.SetParameter("VendorsAdvancesClosing", Parameters.Object.Ref);
	Query.SetParameter("Document", Recorder);
	
	QueryTable = Query.Execute().Unload();
	
	RecordSet_AdvancesToVendors = AccumulationRegisters.R1020B_AdvancesToVendors.CreateRecordSet();
	RecordSet_AdvancesToVendors.Filter.Recorder.Set(Recorder);
	TableAdvances = RecordSet_AdvancesToVendors.UnloadColumns();
	TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	
		
	RecordSet_VendorsTransactions = AccumulationRegisters.R1021B_VendorsTransactions.CreateRecordSet();
	RecordSet_VendorsTransactions.Filter.Recorder.Set(Recorder);
	TableTransactions = RecordSet_VendorsTransactions.UnloadColumns();
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
	
	PostingDataTables.Insert(RecordSet_AdvancesToVendors,   New Structure("RecordSet", TableAdvances));
	PostingDataTables.Insert(RecordSet_VendorsTransactions, New Structure("RecordSet", TableTransactions));
	
	ArrayOfPostingInfo = New Array();
	For Each DataTable In PostingDataTables Do
		ArrayOfPostingInfo.Add(DataTable);
	EndDo;
	
	CurrenciesParameters.Insert("Object", Recorder);
	CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
	
	CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);
	
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1020B_AdvancesToVendors") Then
			RecordSet_AdvancesToVendors.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_AdvancesToVendors.Add(), Row);
			EndDo;
			RecordSet_AdvancesToVendors.SetActive(True);
			RecordSet_AdvancesToVendors.Write();
		EndIf;
	
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions") Then
			RecordSet_VendorsTransactions.Read();
			For Each Row In ItemOfPostingInfo.Value.RecordSet Do
				FillPropertyValues(RecordSet_VendorsTransactions.Add(), Row);
			EndDo;
			RecordSet_VendorsTransactions.SetActive(True);
			RecordSet_VendorsTransactions.Write();
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
	
	RecordSet_Aging = AccumulationRegisters.R5012B_VendorsAging.CreateRecordSet();
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
