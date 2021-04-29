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
	QueryArray.Add(T1000I_OffsetOfAdvances());
	Return QueryArray;
EndFunction

Function T1000I_OffsetOfAdvances()
	Return
		"SELECT
		|	*
		|INTO T1000I_OffsetOfAdvances
		|FROM
		|	OffsetOfAdvances
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
	
	OffsetOfAdvanceFull = InformationRegisters.T1000I_OffsetOfAdvances.CreateRecordSet().UnloadColumns();
	OffsetOfAdvanceFull.Columns.Delete(OffsetOfAdvanceFull.Columns.PointInTime);
	
	// VendorsTransactions
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PartnerTransactions.Recorder
	|FROM
	|	InformationRegister.T1001I_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerTransactions.IsVendorTransaction
	|GROUP BY
	|	PartnerTransactions.Recorder
	|ORDER BY
	|	PartnerTransactions.Recorder.Date";
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	
	QueryTable = Query.Execute().Unload();
	For Each Row In QueryTable Do
		Parameters.Insert("RecorderPointInTime", Row.Recorder.PointInTime());
		Create_VendorsTransactions(Row.Recorder, Parameters);
		OffsetOfPartnersServer.Vendors_OnTransaction(Parameters);
		Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull);
		Drop_VendorsTransactions(Parameters);
		Drop_OffsetOfAdvanceToVendors(Parameters);
	EndDo;
	
//	// VendorAdvances
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PartnerAdvances.Recorder
	|FROM
	|	InformationRegister.T1002I_PartnerAdvances AS PartnerAdvances
	|WHERE
	|	PartnerAdvances.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND PartnerAdvances.IsVendorAdvance
	|GROUP BY
	|	PartnerAdvances.Recorder
	|ORDER BY
	|	PartnerAdvances.Recorder.Date";
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	
	QueryTable = Query.Execute().Unload();
	For Each Row In QueryTable Do
		Parameters.Insert("RecorderPointInTime", Row.Recorder.PointInTime());
		Create_AdvancesToVendors(Row.Recorder, Parameters);
		Create_PaymentToVendors(Row.Recorder, Parameters);
		OffsetOfPartnersServer.Vendors_OnMoneyMovements(Parameters);
		Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull, True);
		Drop_VendorsTransactions(Parameters);
		Drop_AdvancesToVendors(Parameters);
		Drop_OffsetOfAdvanceToVendors(Parameters);
	EndDo;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT *
//	|	OffsetOfAdvanceFull.Period,
//	|	OffsetOfAdvanceFull.Document,
//	|	OffsetOfAdvanceFull.Company,
//	|	OffsetOfAdvanceFull.Currency,
//	|	OffsetOfAdvanceFull.Partner,
//	|	OffsetOfAdvanceFull.LegalName,
//	|	OffsetOfAdvanceFull.TransactionDocument,
//	|	OffsetOfAdvanceFull.AdvancesDocument,
//	|	OffsetOfAdvanceFull.Agreement,
//	|	OffsetOfAdvanceFull.Amount,
//	|	OffsetOfAdvanceFull.Key
	|INTO OffsetOfAdvances 
	|	FROM &OffsetOfAdvanceFull AS OffsetOfAdvanceFull";
	Query.SetParameter("OffsetOfAdvanceFull", OffsetOfAdvanceFull);
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
	|	R1020B_AdvancesToVendors.VendorsAdvancesClosing = &VendorsAdvancesClosing
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
	|	R1021B_VendorsTransactions.VendorsAdvancesClosing = &VendorsAdvancesClosing
	|GROUP BY
	|	R1021B_VendorsTransactions.Recorder";
	Query.SetParameter("VendorsAdvancesClosing", Ref);
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
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.TransactionDocument,
	|	PartnerTransactions.Agreement,
	|	SUM(PartnerTransactions.Amount) AS DocumentAmount
	|INTO tmpVendorsTransactions
	|FROM
	|	InformationRegister.T1001I_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder
	|	AND PartnerTransactions.IsVendorTransaction
	|GROUP BY
	|	PartnerTransactions.Agreement,
	|	PartnerTransactions.Company,
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.Period,
	|	PartnerTransactions.TransactionDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpVendorsTransactions.Period,
	|	tmpVendorsTransactions.Company,
	|	tmpVendorsTransactions.Currency,
	|	tmpVendorsTransactions.Partner,
	|	tmpVendorsTransactions.LegalName,
	|	tmpVendorsTransactions.Agreement,
	|	tmpVendorsTransactions.TransactionDocument,
	|	R1021B_VendorsTransactionsBalance.AmountBalance AS DocumentAmount,
	|	FALSE AS IgnoreAdvances
	|	INTO VendorsTransactions
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Period, (Company, Currency, LegalName, Partner, Agreement,
	|		Basis) IN
	|		(SELECT
	|			tmp.Company,
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
	|		AND R1021B_VendorsTransactionsBalance.Currency = tmpVendorsTransactions.Currency
	|		AND R1021B_VendorsTransactionsBalance.Partner = tmpVendorsTransactions.Partner
	|		AND R1021B_VendorsTransactionsBalance.LegalName = tmpVendorsTransactions.LegalName
	|		AND R1021B_VendorsTransactionsBalance.Agreement = tmpVendorsTransactions.Agreement
	|		AND R1021B_VendorsTransactionsBalance.Basis = tmpVendorsTransactions.TransactionDocument
	|;
	|DROP tmpVendorsTransactions";
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Including));	
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
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.TransactionDocument,
	|	PartnerTransactions.Agreement,
	|	SUM(PartnerTransactions.Amount) AS Amount,
	|	FALSE AS IgnoreAdvances
	|INTO VendorsTransactions
	|FROM
	|	InformationRegister.T1001I_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder
	|	and PartnerTransactions.IsPaymentToVendor
	|GROUP BY
	|	PartnerTransactions.Agreement,
	|	PartnerTransactions.Company,
	|	PartnerTransactions.Currency,
	|	PartnerTransactions.LegalName,
	|	PartnerTransactions.Partner,
	|	PartnerTransactions.Period,
	|	PartnerTransactions.TransactionDocument";
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
	|	PartnerAdvances.Currency,
	|	PartnerAdvances.Partner,
	|	PartnerAdvances.LegalName,
	|	PartnerAdvances.AdvancesDocument,
	|	PartnerAdvances.Amount AS DocumentAmount,
	|	PartnerAdvances.Key
	|INTO AdvancesToVendors
	|FROM
	|	InformationRegister.T1002I_PartnerAdvances AS PartnerAdvances
	|WHERE
	|	PartnerAdvances.Recorder = &Recorder";
	Query.SetParameter("Recorder", Recorder);
	Query.Execute();
EndProcedure

Procedure Drop_VendorsTransactions(Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "DROP VendorsTransactions";
	Query.Execute();
EndProcedure

Procedure Drop_AdvancesToVendors(Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "DROP AdvancesToVendors";
	Query.Execute();	
EndProcedure

Procedure Drop_OffsetOfAdvanceToVendors(Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "DROP OffsetOfAdvanceToVendors";
	Query.Execute();
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
Procedure Write_AdvancesAndTransactions(Recorder, Parameters, OffsetOfAdvanceFull, UseKeyInAdvance = False)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	OffsetOfAdvance.Period,
	|	OffsetOfAdvance.Company,
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
	
	If UseKeyInAdvance Then
		TableAdvances.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	EndIf;
	
	RecordSet_VendorsTransactions = AccumulationRegisters.R1021B_VendorsTransactions.CreateRecordSet();
	RecordSet_VendorsTransactions.Filter.Recorder.Set(Recorder);
	TableTransactions = RecordSet_VendorsTransactions.UnloadColumns();
	TableTransactions.Columns.Delete(TableTransactions.Columns.PointInTime);
	
//	//TableTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

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


