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
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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
	// clear old records for Vendors
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T1001I_PartnerTransactions.Recorder
	|FROM
	|	InformationRegister.T1001I_PartnerTransactions AS T1001I_PartnerTransactions
	|WHERE
	|	T1001I_PartnerTransactions.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND T1001I_PartnerTransactions.IsVendorTransaction
	|GROUP BY
	|	T1001I_PartnerTransactions.Recorder";
	
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	QueryTable = Query.Execute().Unload();
	
	ClearRegister("R1020B_AdvancesToVendors"      , QueryTable);
	ClearRegister("R1021B_VendorsTransactions"    , QueryTable);
//	ClearRegister("R2021B_CustomersTransactions"  , QueryTable);
//	ClearRegister("R2020B_AdvancesFromCustomers"  , QueryTable);
	
	OffsetOfAdvanceFull = InformationRegisters.T1000I_OffsetOfAdvances.CreateRecordSet().UnloadColumns();
	
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
		Write_VendorsTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull);
		Drop_VendorsTransactions(Parameters);
		Drop_OffsetOfAdvanceToVendors(Parameters);
	EndDo;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT 
	|	OffsetOfAdvanceFull.Period,
	|	OffsetOfAdvanceFull.Document,
	|	OffsetOfAdvanceFull.Company,
	|	OffsetOfAdvanceFull.Currency,
	|	OffsetOfAdvanceFull.Partner,
	|	OffsetOfAdvanceFull.LegalName,
	|	OffsetOfAdvanceFull.TransactionDocument,
	|	OffsetOfAdvanceFull.AdvancesDocument,
	|	OffsetOfAdvanceFull.Agreement,
	|	OffsetOfAdvanceFull.Amount
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

Procedure ClearRegister(RegisterName, RecordersTable)
	For Each Row In RecordersTable Do
		If Not Row.Recorder.Metadata().RegisterRecords.Contains(Metadata.AccumulationRegisters[RegisterName]) Then
			Continue;
		EndIf;
		RecordSet = AccumulationRegisters[RegisterName].CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);		
		RecordSet.Clear();
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
	|	PartnerTransactions.Amount AS DocumentAmount,
	|	FALSE AS IgnoreAdvances,
	|	PartnerTransactions.Key
	|INTO VendorsTransactions
	|FROM
	|	InformationRegister.T1001I_PartnerTransactions AS PartnerTransactions
	|WHERE
	|	PartnerTransactions.Recorder = &Recorder";
	Query.SetParameter("Recorder", Recorder);
	Query.Execute(); 
EndProcedure

Procedure Drop_VendorsTransactions(Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "DROP VendorsTransactions";
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
Procedure Write_VendorsTransactions(Recorder, Parameters, OffsetOfAdvanceFull)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	VendorsTransactions.Period,
	|	VendorsTransactions.Company,
	|	VendorsTransactions.Currency,
	|	VendorsTransactions.Partner,
	|	VendorsTransactions.LegalName,
	|	VendorsTransactions.TransactionDocument,
	|	UNDEFINED AS AdvancesDocument,
	|	VendorsTransactions.Agreement,
	|	VendorsTransactions.DocumentAmount AS Amount,
	|	FALSE AS IsOffsetOfAdvance,
	|	VendorsTransactions.Key
	|FROM
	|	VendorsTransactions AS VendorsTransactions
	|
	|UNION ALL
	|
	|SELECT
	|	OffsetOfAdvance.Period,
	|	OffsetOfAdvance.Company,
	|	OffsetOfAdvance.Currency,
	|	OffsetOfAdvance.Partner,
	|	OffsetOfAdvance.LegalName,
	|	OffsetOfAdvance.TransactionDocument,
	|	OffsetOfAdvance.AdvancesDocument,
	|	OffsetOfAdvance.Agreement,
	|	OffsetOfAdvance.Amount,
	|	TRUE,
	|	OffsetOfAdvance.Key
	|FROM
	|	OffsetOfAdvanceToVendors AS OffsetOfAdvance";
	QueryTable = Query.Execute().Unload();
	
	RecordSet_AdvancesToVendors = AccumulationRegisters.R1020B_AdvancesToVendors.CreateRecordSet();
	RecordSet_AdvancesToVendors.Filter.Recorder.Set(Recorder);
	TableAdvances = RecordSet_AdvancesToVendors.UnloadColumns();
	//TableAdvances.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	//TableAdvances.Columns.Delete(TableAdvances.Columns.RecordType);
	
	
	RecordSet_VendorsTransactions = AccumulationRegisters.R1021B_VendorsTransactions.CreateRecordSet();
	RecordSet_VendorsTransactions.Filter.Recorder.Set(Recorder);
	TableTransactions = RecordSet_VendorsTransactions.UnloadColumns();
	//TableTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	TableTransactions.Columns.Delete(TableTransactions.Columns.PointInTime);
	//TableTransactions.Columns.Delete(TableTransactions.Columns.RecordType);

	For Each Row In QueryTable Do
		
		If Row.IsOffsetOfAdvance Then
			NewRow_OffsetOfAdvanceFull = OffsetOfAdvanceFull.Add();
			FillPropertyValues(NewRow_OffsetOfAdvanceFull, Row);
			NewRow_OffsetOfAdvanceFull.Document = Recorder;
		
		
			NewRow_Advances = TableAdvances.Add();
			NewRow_Advances.RecordType      = AccumulationRecordType.Expense;
			NewRow_Advances.Recorder        = Recorder;
			NewRow_Advances.Period          = Row.Period;
			NewRow_Advances.Company         = Row.Company;
			NewRow_Advances.Currency        = Row.Currency;
			NewRow_Advances.Partner         = Row.Partner;
			NewRow_Advances.LegalName       = Row.LegalName;
			NewRow_Advances.Basis           = Row.AdvancesDocument;
			NewRow_Advances.Amount          = Row.Amount;
			//NewRow_Advances.Key             = Row.Key;
			NewRow_Advances.OffsetOfAdvance = True;
		EndIf;
		
		NewRow_Transactions = TableTransactions.Add();
		
		If Row.IsOffsetOfAdvance Then
			NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
		Else
			NewRow_Transactions.RecordType = AccumulationRecordType.Receipt;
		EndIf;	
		
		NewRow_Transactions.Recorder        = Recorder;
		NewRow_Transactions.Period          = Row.Period;
		NewRow_Transactions.Company         = Row.Company;
		NewRow_Transactions.Currency        = Row.Currency;
		NewRow_Transactions.Agreement       = Row.Agreement;
		NewRow_Transactions.Partner         = Row.Partner;
		NewRow_Transactions.LegalName       = Row.LegalName;
		NewRow_Transactions.Basis           = Row.TransactionDocument;
		NewRow_Transactions.Amount          = Row.Amount;
		//NewRow_Transactions.Key             = Row.Key;
		NewRow_Transactions.OffsetOfAdvance = True;
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
			RecordSet_AdvancesToVendors.Load(ItemOfPostingInfo.Value.RecordSet);
			RecordSet_AdvancesToVendors.SetActive(True);
			RecordSet_AdvancesToVendors.Write();
		EndIf;
	
		If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions") Then
			RecordSet_VendorsTransactions.Load(ItemOfPostingInfo.Value.RecordSet);
			RecordSet_VendorsTransactions.SetActive(True);
			RecordSet_VendorsTransactions.Write();
		EndIf;
	EndDo;
EndProcedure

Procedure Drop_OffsetOfAdvanceToVendors(Parameters)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "DROP OffsetOfAdvanceToVendors";
	Query.Execute();
EndProcedure

