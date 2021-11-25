#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables(Parameters);
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
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
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables(Parameters = Undefined)
	QueryArray = New Array();
	QueryArray.Add(OffsetOfAdvancesAndAging(Parameters));
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(T2010S_OffsetOfAdvances());
	QueryArray.Add(T2013S_OffsetOfAging());
	Return QueryArray;
EndFunction

#Region OffsetOfAdvances2

Function OffsetOfAdvancesAndAging(Parameters)
	If Parameters = Undefined Then
		Return VendorsAdvancesClosingQueryText();
	EndIf;
	If Parameters.Property("Unposting") And Parameters.Unposting Then
		Clear_SelfRecords(Parameters);
		Return VendorsAdvancesClosingQueryText();
	EndIf;
	
	Records_AdvancesKey = AccumulationRegisters.TM1020B_AdvancesKey.CreateRecordSet().UnloadColumns();
	Records_AdvancesKey.Columns.Delete(Records_AdvancesKey.Columns.PointInTime);
	
	Records_TransactionsKey = AccumulationRegisters.TM1030B_TransactionsKey.CreateRecordSet().UnloadColumns();
	Records_TransactionsKey.Columns.Delete(Records_TransactionsKey.Columns.PointInTime);
	
	// detail info by all offsets
	Records_OffsetOfAdvances = InformationRegisters.T2010S_OffsetOfAdvances.CreateRecordSet().UnloadColumns();
	Records_OffsetOfAdvances.Columns.Delete(Records_OffsetOfAdvances.Columns.PointInTime);
	Records_OffsetOfAdvances.Columns.Add("AdvancesRowKey"     , Metadata.DefinedTypes.typeRowID.Type);
	Records_OffsetOfAdvances.Columns.Add("TransactionsRowKey" , Metadata.DefinedTypes.typeRowID.Type);
	
	// detail info by all aging
	Records_OffsetAging = InformationRegisters.T2013S_OffsetOfAging.CreateRecordSet().UnloadColumns();
	Records_OffsetAging.Columns.Delete(Records_OffsetAging.Columns.PointInTime);
	
	// Clear register records
	Clear_SelfRecords(Parameters);
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	
	// Create advances keys
	Table_DocumentAndAdvancesKey = New ValueTable();
	Table_DocumentAndAdvancesKey.Columns.Add("Document", 
		Metadata.AccumulationRegisters.R1020B_AdvancesToVendors.StandardAttributes.Recorder.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("AdvanceKey", New TypeDescription("CatalogRef.AdvancesKeys"));
	
	CreateAdvancesKeys(Parameters, Records_AdvancesKey, Table_DocumentAndAdvancesKey);
	// Write advances keys to TM1020B_AdvancesKey, Receipt
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
		
	// Create transactions keys
	Table_DocumentAndTransactionsKey = New ValueTable();
	Table_DocumentAndTransactionsKey.Columns.Add("Document", 
		Metadata.AccumulationRegisters.R1021B_VendorsTransactions.StandardAttributes.Recorder.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("TransactionKey", New TypeDescription("CatalogRef.TransactionsKeys"));
	
	CreateTransactionsKeys(Parameters, Records_TransactionsKey, Records_OffsetAging, Table_DocumentAndTransactionsKey);
	// Write transactions keys to TM1030B_TransactionsKey
	Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	DocAdv.Document,
	|	DocAdv.AdvanceKey
	|INTO tmp_DocAdv
	|FROM
	|	&DocAdv AS DocAdv
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocTrn.Document,
	|	DocTrn.TransactionKey
	|INTO tmp_DocTrn
	|FROM
	|	&DocTrn AS DocTrn
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_DocAdv.AdvanceKey AS AdvanceKey,
	|	NULL AS TransactionKey,
	|	tmp_DocAdv.Document.PointInTime AS PointInTime,
	|	tmp_DocAdv.Document AS Document
	|INTO tmp_AllKeys
	|FROM
	|	tmp_DocAdv AS tmp_DocAdv
	|
	|UNION ALL
	|
	|SELECT
	|	NULL,
	|	tmp_DocTrn.TransactionKey,
	|	tmp_DocTrn.Document.PointInTime,
	|	tmp_DocTrn.Document
	|FROM
	|	tmp_DocTrn AS tmp_DocTrn
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpAllKeys.AdvanceKey,
	|	tmpAllKeys.TransactionKey,
	|	tmpAllKeys.PointInTime,
	|	tmpAllKeys.Document
	|FROM
	|	tmp_AllKeys AS tmpAllKeys
	|GROUP BY
	|	tmpAllKeys.AdvanceKey,
	|	tmpAllKeys.TransactionKey,
	|	tmpAllKeys.PointInTime,
	|	tmpAllKeys.Document
	|ORDER BY
	|	PointInTime";
	Query.SetParameter("DocAdv" , Table_DocumentAndAdvancesKey);
	Query.SetParameter("DocTrn" , Table_DocumentAndTransactionsKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		// Offset advances to transactions
		If ValueIsFilled(QuerySelection.AdvanceKey) Then
			OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances,
				Records_OffsetAging, //Records_AgingsKey, 
				QuerySelection.AdvanceKey, QuerySelection.PointInTime, QuerySelection.Document);
		EndIf;
		// Offset transactions to advances
		If ValueIsFilled(QuerySelection.TransactionKey) Then
			OffsetTransactionsToAdvances(Parameters, Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances, 
				Records_OffsetAging, //Records_AgingsKey, 
				QuerySelection.TransactionKey, QuerySelection.PointInTime, QuerySelection.Document);
		EndIf;
	EndDo;
	
	//================================================================================
//	WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging);
//	Parameters.Object.RegisterRecords.TM1030B_TransactionsKey.Read();
//	Parameters.Object.RegisterRecords.TM1020B_AdvancesKey.Read();
//	Parameters.Object.RegisterRecords.TM1040T_AgingsKey.Read();
//	return VendorsAdvancesClosingQueryText();
	//================================================================================
		
	// Aging calculation
	//==========================================================//
	//Write_TM1040T_AgingsKey(Parameters, Records_AgingsKey);
	//OffsetTransactionsToAging(Parameters, Records_OffsetAging);
	//==========================================================//
		
	// Write OffsetInfo to R1020B_AdvancesToVendors and R1021B_VendorsTransactions and R5012B_VendorsAging
	Write_SelfRecords(Parameters, Records_OffsetOfAdvances);//, Records_OffsetAging);
	
	
	WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging);
	Parameters.Object.RegisterRecords.TM1030B_TransactionsKey.Read();
	Parameters.Object.RegisterRecords.TM1020B_AdvancesKey.Read();
	//Parameters.Object.RegisterRecords.TM1040T_AgingsKey.Read();
	
	Return VendorsAdvancesClosingQueryText();
EndFunction

Procedure WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	Records_OffsetOfAdvances.Period,
	|	Records_OffsetOfAdvances.Document,
	|	Records_OffsetOfAdvances.Company,
	|	Records_OffsetOfAdvances.Branch,
	|	Records_OffsetOfAdvances.Currency,
	|	Records_OffsetOfAdvances.Partner,
	|	Records_OffsetOfAdvances.LegalName,
	|	Records_OffsetOfAdvances.TransactionDocument,
	|	Records_OffsetOfAdvances.AdvancesDocument,
	|	Records_OffsetOfAdvances.Agreement,
	|	Records_OffsetOfAdvances.AdvancesOrder,
	|	Records_OffsetOfAdvances.TransactionOrder,
	|	Records_OffsetOfAdvances.FromAdvanceKey,
	|	Records_OffsetOfAdvances.ToTransactionKey,
	|	Records_OffsetOfAdvances.FromTransactionKey,
	|	Records_OffsetOfAdvances.ToAdvanceKey,
	|	Records_OffsetOfAdvances.Key,
	|	Records_OffsetOfAdvances.Amount,
	|	Records_OffsetOfAdvances.DueAsAdvance
	|INTO tmpRecords_OffsetOfAdvances
	|FROM
	|	&Records_OffsetOfAdvances AS Records_OffsetOfAdvances
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records_OffsetAging.Period,
	|	Records_OffsetAging.Document,
	|	Records_OffsetAging.Company,
	|	Records_OffsetAging.Branch,
	|	Records_OffsetAging.Currency,
	|	Records_OffsetAging.Partner,
	|	Records_OffsetAging.Agreement,
	|	Records_OffsetAging.Invoice,
	|	Records_OffsetAging.PaymentDate,
	|	Records_OffsetAging.Amount
	|INTO tmpRecords_OffsetAging
	|FROM
	|	&Records_OffsetAging AS Records_OffsetAging
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRecords_OffsetOfAdvances.Period,
	|	tmpRecords_OffsetOfAdvances.Document,
	|	tmpRecords_OffsetOfAdvances.Company,
	|	tmpRecords_OffsetOfAdvances.Branch,
	|	tmpRecords_OffsetOfAdvances.Currency,
	|	tmpRecords_OffsetOfAdvances.Partner,
	|	tmpRecords_OffsetOfAdvances.LegalName,
	|	tmpRecords_OffsetOfAdvances.TransactionDocument,
	|	tmpRecords_OffsetOfAdvances.AdvancesDocument,
	|	tmpRecords_OffsetOfAdvances.Agreement,
	|	tmpRecords_OffsetOfAdvances.AdvancesOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.FromAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.ToTransactionKey,
	|	tmpRecords_OffsetOfAdvances.FromTransactionKey,
	|	tmpRecords_OffsetOfAdvances.ToAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.Key,
	|	tmpRecords_OffsetOfAdvances.DueAsAdvance,
	|	SUM(tmpRecords_OffsetOfAdvances.Amount) AS Amount
	|INTO Records_OffsetOfAdvances
	|FROM
	|	tmpRecords_OffsetOfAdvances AS tmpRecords_OffsetOfAdvances
	|GROUP BY
	|	tmpRecords_OffsetOfAdvances.Period,
	|	tmpRecords_OffsetOfAdvances.Document,
	|	tmpRecords_OffsetOfAdvances.Company,
	|	tmpRecords_OffsetOfAdvances.Branch,
	|	tmpRecords_OffsetOfAdvances.Currency,
	|	tmpRecords_OffsetOfAdvances.Partner,
	|	tmpRecords_OffsetOfAdvances.LegalName,
	|	tmpRecords_OffsetOfAdvances.TransactionDocument,
	|	tmpRecords_OffsetOfAdvances.AdvancesDocument,
	|	tmpRecords_OffsetOfAdvances.Agreement,
	|	tmpRecords_OffsetOfAdvances.AdvancesOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.FromAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.ToTransactionKey,
	|	tmpRecords_OffsetOfAdvances.FromTransactionKey,
	|	tmpRecords_OffsetOfAdvances.ToAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.Key,
	|	tmpRecords_OffsetOfAdvances.DueAsAdvance
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRecords_OffsetAging.Period,
	|	tmpRecords_OffsetAging.Document,
	|	tmpRecords_OffsetAging.Company,
	|	tmpRecords_OffsetAging.Branch,
	|	tmpRecords_OffsetAging.Currency,
	|	tmpRecords_OffsetAging.Partner,
	|	tmpRecords_OffsetAging.Agreement,
	|	tmpRecords_OffsetAging.Invoice,
	|	tmpRecords_OffsetAging.PaymentDate,
	|	SUM(tmpRecords_OffsetAging.Amount) AS Amount
	|INTO Records_OffsetAging
	|FROM
	|	tmpRecords_OffsetAging AS tmpRecords_OffsetAging
	|GROUP BY
	|	tmpRecords_OffsetAging.Period,
	|	tmpRecords_OffsetAging.Document,
	|	tmpRecords_OffsetAging.Company,
	|	tmpRecords_OffsetAging.Branch,
	|	tmpRecords_OffsetAging.Currency,
	|	tmpRecords_OffsetAging.Partner,
	|	tmpRecords_OffsetAging.Agreement,
	|	tmpRecords_OffsetAging.Invoice,
	|	tmpRecords_OffsetAging.PaymentDate";

	Query.SetParameter("Records_OffsetOfAdvances", Records_OffsetOfAdvances);
	Query.SetParameter("Records_OffsetAging"     , Records_OffsetAging);
	Query.Execute();
EndProcedure

Function T2010S_OffsetOfAdvances()
	Return 
	"SELECT
	|	*
	|INTO T2010S_OffsetOfAdvances
	|FROM
	|	Records_OffsetOfAdvances
	|WHERE
	|	TRUE";
EndFunction

Function T2013S_OffsetOfAging()
	Return 
	"SELECT
	|	*
	|INTO T2013S_OffsetOfAging
	|FROM
	|	Records_OffsetAging
	|WHERE
	|	TRUE";
EndFunction

Procedure WriteDueToAdvances(Parameters, Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances)
//	Query = New Query();
//	Query.Text = 
//	"SELECT
//	|	TransactionsBalance.TransactionKey,
//	|	TransactionsBalance.AmountBalance AS TransactionAmount
//	|FROM
//	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(ENDOFPERIOD(&EndOfPeriod, DAY),
//	|		TransactionKey.Company = &Company
//	|	AND TransactionKey.Branch = &Branch
//	|	AND TransactionKey.IsVendorTransaction) AS TransactionsBalance";
//	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
//	Query.SetParameter("Company"      , Parameters.Object.Company);
//	Query.SetParameter("Branch"       , Parameters.Object.Branch);
//	
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
//
//	NeedWriteTransactions = False;
//	While QuerySelection.Next() Do
//		DistributeTransactionToAdvance(Parameters, QuerySelection.TransactionKey, QuerySelection.TransactionAmount,
//			Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, NeedWriteTransactions);
//	EndDo;
//	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
//	If NeedWriteTransactions Then
//		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
//	EndIf;

EndProcedure

// transaction 01.01 => advance 02.01
Procedure OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
	Records_OffsetAging, //Records_AgingsKey, 
	AdvanceKey, PointInTime, Document)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvancesBalance.AdvanceKey,
	|	SUM(AdvancesBalance.AmountBalance) AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(ENDOFPERIOD(&EndOfPeriod, DAY), AdvanceKey = &AdvanceKey
	|	AND AdvanceKey.IsVendorAdvance) AS AdvancesBalance
	|GROUP BY
	|	AdvancesBalance.AdvanceKey
	|HAVING
	|	SUM(AdvancesBalance.AmountBalance) > 0";
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	Query.SetParameter("AdvanceKey"   , AdvanceKey);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteAdvances = False;
	While QuerySelection.Next() Do
		DistributeAdvanceToTransaction(Parameters, PointInTime, Document, QuerySelection.AdvanceKey, QuerySelection.AdvanceAmount,
			Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances, 
			Records_OffsetAging, //Records_AgingsKey, 
			NeedWriteAdvances);
	EndDo;
	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
EndProcedure

// transaction 01.01 => advance 02.01
// records in bank payment
Procedure DistributeAdvanceToTransaction(Parameters, PointInTime, Document, AdvanceKey, AdvanceAmount, 
	Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances, 
	Records_OffsetAging,//Records_AgingsKey, 
	NeedWriteAdvances)
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TransactionsBalance.TransactionKey,
	|	TransactionsBalance.AmountBalance AS TransactionAmount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(&AdvanceBoundary, 
	|		TransactionKey.Company = &Company
	|	AND TransactionKey.Branch = &Branch
	|	AND TransactionKey.Currency = &Currency
	|	AND TransactionKey.Partner = &Partner
	|	AND TransactionKey.LegalName = &LegalName) AS TransactionsBalance";
	
	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary", Boundary);
	
	Query.SetParameter("Company"    , AdvanceKey.Company);
	Query.SetParameter("Branch"     , AdvanceKey.Branch);
	Query.SetParameter("Currency"   , AdvanceKey.Currency);
	Query.SetParameter("Partner"    , AdvanceKey.Partner);
	Query.SetParameter("LegalName"  , AdvanceKey.LegalName);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	NeedWriteoff = AdvanceAmount;
	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		If QuerySelection.TransactionAmount <= 0 Then
			Continue;
		EndIf;
		
		If NeedWriteoff = 0 Then
			Break;
		EndIf;
		If ValueIsFilled(AdvanceKey.Order) Then // advance by order
			If QuerySelection.TransactionKey.Order <> AdvanceKey.Order Then
				Continue;
			EndIf;
		EndIf;
		CanWriteoff = Min(QuerySelection.TransactionAmount, AdvanceAmount);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		// Transactions
		NewRow_Transactions = Records_TransactionsKey.Add();
		NewRow_Transactions.RecordType     = AccumulationRecordType.Expense;
		NewRow_Transactions.Period         = Document.Date;
		NewRow_Transactions.TransactionKey = QuerySelection.TransactionKey;
		NewRow_Transactions.Amount         = CanWriteOff;
		NeedWriteTransactions = True;
		
		// Advances
		NewRow_Advances = Records_AdvancesKey.Add();
		NewRow_Advances.RecordType = AccumulationRecordType.Expense;
		NewRow_Advances.Period     = Document.Date;
		NewRow_Advances.AdvanceKey = AdvanceKey;
		NewRow_Advances.Amount     = CanWriteOff;
		
		NeedWriteAdvances     = True;
		
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.Period              = Document.Date;
		NewOffsetInfo.Amount              = CanWriteoff;
		NewOffsetInfo.Document            = Document;
		NewOffsetInfo.Company             = AdvanceKey.Company;
		NewOffsetInfo.Branch              = AdvanceKey.Branch;
		NewOffsetInfo.Currency            = AdvanceKey.Currency;
		NewOffsetInfo.Partner             = AdvanceKey.Partner;
		NewOffsetInfo.LegalName           = AdvanceKey.LegalName;
		NewOffsetInfo.TransactionDocument = QuerySelection.TransactionKey.TransactionBasis;
		NewOffsetInfo.Agreement           = QuerySelection.TransactionKey.Agreement;
		NewOffsetInfo.AdvancesOrder       = AdvanceKey.Order;
		NewOffsetInfo.TransactionOrder    = QuerySelection.TransactionKey.Order;
		NewOffsetInfo.FromTransactionKey  = QuerySelection.TransactionKey;
		NewOffsetInfo.ToAdvanceKey        = AdvanceKey;
		NewOffsetInfo.AdvancesRowKey      = FindRowKeyByAdvanceKey(AdvanceKey, Document);
		NewOffsetInfo.TransactionsRowKey  = FindRowKeyByTransactionKey(QuerySelection.TransactionKey, Document);
		NewOffsetInfo.Key = NewOffsetInfo.AdvancesRowKey;
		
		DistributeTransactionToAging(Parameters, PointInTime, Document, QuerySelection.TransactionKey, CanWriteoff, 
			Records_OffsetAging);
	EndDo;
	
	// Write offseted transactions to TM1030B_TransactionsKey
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	EndIf;
EndProcedure

// advance 01.01 => transaction 02.01
Procedure OffsetTransactionsToAdvances(Parameters, Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances,
	 Records_OffsetAging, //Records_AgingsKey, 
	 TransactionKey, PointInTime, Document)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TransactionsBalance.TransactionKey,
	|	SUM(TransactionsBalance.AmountBalance) AS TransactionAmount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(ENDOFPERIOD(&EndOfPeriod, DAY), TransactionKey = &TransactionKey
	|	AND TransactionKey.IsVendorTransaction) AS TransactionsBalance
	|GROUP BY
	|	TransactionsBalance.TransactionKey
	|HAVING
	|	SUM(TransactionsBalance.AmountBalance) > 0";
	Query.SetParameter("EndOfPeriod"    , Parameters.Object.EndOfPeriod);
	Query.SetParameter("TransactionKey" , TransactionKey);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		DistributeTransactionToAdvance(Parameters, PointInTime, Document, QuerySelection.TransactionKey, QuerySelection.TransactionAmount,
			Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
			Records_OffsetAging, //Records_AgingsKey, 
			NeedWriteTransactions);
	EndDo;
	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	EndIf;
EndProcedure

// advance 01.01 => transaction 02.01
// records in invoice
Procedure DistributeTransactionToAdvance(Parameters, PointInTime, Document, TransactionKey, TransactionAmount, 
	Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
	Records_OffsetAging,
	NeedWriteTransactions)
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvancesBalance.AdvanceKey,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&TransactionBoundary, 
	|		AdvanceKey.Company = &Company
	|	AND AdvanceKey.Branch = &Branch
	|	AND AdvanceKey.Currency = &Currency
	|	AND AdvanceKey.Partner = &Partner
	|	AND AdvanceKey.LegalName = &LegalName) AS AdvancesBalance";

	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("TransactionBoundary", Boundary);
	
	Query.SetParameter("Company"        , TransactionKey.Company);
	Query.SetParameter("Branch"         , TransactionKey.Branch);
	Query.SetParameter("Currency"       , TransactionKey.Currency);
	Query.SetParameter("Partner"        , TransactionKey.Partner);
	Query.SetParameter("LegalName"      , TransactionKey.LegalName);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	NeedWriteoff = TransactionAmount;
	NeedWriteAdvances = False;
	While QuerySelection.Next() Do
		If QuerySelection.AdvanceAmount <= 0 Then
			Continue;
		EndIf;
		
		If NeedWriteoff = 0 Then
			Break;
		EndIf;
		If ValueIsFilled(QuerySelection.AdvanceKey.Order) Then // transaction by order
			If QuerySelection.AdvanceKey.Order <> TransactionKey.Order Then
				Continue;
			EndIf;
		EndIf;
		CanWriteoff = Min(QuerySelection.AdvanceAmount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		// Advances
		NewRow_Advances = Records_AdvancesKey.Add();
		NewRow_Advances.RecordType     = AccumulationRecordType.Expense;
		NewRow_Advances.Period         = Document.Date;
		NewRow_Advances.AdvanceKey     = QuerySelection.AdvanceKey;
		NewRow_Advances.Amount         = CanWriteOff;
		NeedWriteAdvances     = True;
		
		// Transactions
		NewRow_Transactions = Records_TransactionsKey.Add();
		NewRow_Transactions.RecordType     = AccumulationRecordType.Expense;
		NewRow_Transactions.Period         = Document.Date;
		NewRow_Transactions.TransactionKey = TransactionKey;
		NewRow_Transactions.Amount         = CanWriteOff;
		NeedWriteTransactions = True;
		
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.Period              = Document.Date;
		NewOffsetInfo.Amount              = CanWriteoff;
		NewOffsetInfo.Document            = Document;
		NewOffsetInfo.Company             = TransactionKey.Company;
		NewOffsetInfo.Branch              = TransactionKey.Branch;
		NewOffsetInfo.Currency            = TransactionKey.Currency;
		NewOffsetInfo.Partner             = TransactionKey.Partner;
		NewOffsetInfo.LegalName           = TransactionKey.LegalName;
		NewOffsetInfo.TransactionDocument = TransactionKey.TransactionBasis;
		NewOffsetInfo.Agreement           = TransactionKey.Agreement;
		NewOffsetInfo.AdvancesOrder       = QuerySelection.AdvanceKey.Order;
		NewOffsetInfo.TransactionOrder    = TransactionKey.Order;
		NewOffsetInfo.FromAdvanceKey      = QuerySelection.AdvanceKey;
		NewOffsetInfo.ToTransactionKey    = TransactionKey;
		NewOffsetInfo.AdvancesRowKey      = FindRowKeyByAdvanceKey(QuerySelection.AdvanceKey, Document);
		NewOffsetInfo.TransactionsRowKey  = FindRowKeyByTransactionKey(TransactionKey, Document);
		NewOffsetInfo.Key = NewOffsetInfo.TransactionsRowKey;
		
		DistributeTransactionToAging(Parameters, PointInTime, Document, 
			TransactionKey, CanWriteoff, Records_OffsetAging);
	EndDo;
	
	// Write offseted advances to TM1020B_AdvancesKey
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
EndProcedure

Procedure DistributeTransactionToAging(Parameters, PointInTime, Document, TransactionKey, TransactionAmount, 
		Records_OffsetAging)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	VendorsAging.PaymentDate,
	|	VendorsAging.AmountBalance AS PaymentAmount
	|FROM
	|	AccumulationRegister.R5012B_VendorsAging.Balance(&TransactionBoundary, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Agreement = &Agreement
	|	AND Partner = &Partner
	|	AND Invoice = &TransactionBasis) AS VendorsAging";
	
	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("TransactionBoundary", Boundary);
	
	Query.SetParameter("Company"          , TransactionKey.Company);
	Query.SetParameter("Branch"           , TransactionKey.Branch);
	Query.SetParameter("Currency"         , TransactionKey.Currency);
	Query.SetParameter("Agreement"        , TransactionKey.Agreement);
	Query.SetParameter("Partner"          , TransactionKey.Partner);
	Query.SetParameter("TransactionBasis" , TransactionKey.TransactionBasis);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	NeedWriteAging = False;
	NeedWriteoff = TransactionAmount;
	While QuerySelection.Next() Do
		If QuerySelection.PaymentAmount <= 0 Then
			Continue;
		EndIf;
		
		If NeedWriteoff = 0 Then
			Break;
		EndIf;
		CanWriteoff = Min(QuerySelection.PaymentAmount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		NewRow = Records_OffsetAging.Add();
		NewRow.Period      = Document.Date;
		NewRow.Document    = Document;
		NewRow.Company     = TransactionKey.Company;
		NewRow.Branch      = TransactionKey.Branch;
		NewRow.Currency    = TransactionKey.Currency;
		NewRow.Agreement   = TransactionKey.Agreement;
		NewRow.Partner     = TransactionKey.Partner;
		NewRow.Invoice     = TransactionKey.TransactionBasis;
		NewRow.PaymentDate = QuerySelection.PaymentDate;
		NewRow.Amount      = CanWriteOff;
		NeedWriteAging = True;
	EndDo;
	If NeedWriteAging Then
		Write_R5012B_VendorsAging(Parameters, Document, Records_OffsetAging);
	EndIf;
EndProcedure

//Procedure Write_TM1040T_AgingsKey(Parameters, Records_AgingsKey)
//	RecordSet = AccumulationRegisters.TM1040T_AgingsKey.CreateRecordSet();
//	RecordSet.DataExchange.Load = True;
//	RecordSet.Filter.Recorder.Set(Parameters.Object.Ref);
//	RecordSet.Load(Records_AgingsKey);
//	RecordSet.SetActive(True);
//	RecordSet.Write();
//EndProcedure

Function FindRowKeyByAdvanceKey(AdvanceKey, Document)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	MAX(T2014S_AdvancesInfo.Key) AS Key
	|FROM
	|	InformationRegister.T2014S_AdvancesInfo AS T2014S_AdvancesInfo
	|WHERE
	|	T2014S_AdvancesInfo.Company = &Company
	|	AND T2014S_AdvancesInfo.Branch = &Branch
	|	AND T2014S_AdvancesInfo.Currency = &Currency
	|	AND T2014S_AdvancesInfo.Date = &Date
	|	AND T2014S_AdvancesInfo.IsVendorAdvance
	|	AND T2014S_AdvancesInfo.LegalName = &LegalName
	|	AND T2014S_AdvancesInfo.Partner = &Partner
	|	AND T2014S_AdvancesInfo.Recorder = &Document
	|	AND CASE
	|		WHEN T2014S_AdvancesInfo.Order.ref IS NULL
	|			THEN VALUE(Document.PurchaseOrder.EmptyRef)
	|		ELSE T2014S_AdvancesInfo.Order
	|	END = &Order";
	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Date"      , Document.Date);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("Document"  , Document);
	Query.SetParameter("Order"     , ?(ValueIsFilled(AdvanceKey.Order)
		,AdvanceKey.Order, Documents.PurchaseOrder.EmptyRef()));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Function FindRowKeyByTransactionKey(TransactionKey, Document)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	MAX(T2015S_TransactionsInfo.Key) AS Key
	|FROM
	|	InformationRegister.T2015S_TransactionsInfo AS T2015S_TransactionsInfo
	|WHERE
	|	T2015S_TransactionsInfo.Company = &Company
	|	AND T2015S_TransactionsInfo.Branch = &Branch
	|	AND T2015S_TransactionsInfo.Currency = &Currency
	|	AND T2015S_TransactionsInfo.Date = &Date
	|	AND T2015S_TransactionsInfo.IsVendorTransaction
	|	AND T2015S_TransactionsInfo.LegalName = &LegalName
	|	AND T2015S_TransactionsInfo.Partner = &Partner
	|	AND T2015S_TransactionsInfo.Agreement = &Agreement
	|	AND T2015S_TransactionsInfo.TransactionBasis = &TransactionBasis
	|	AND T2015S_TransactionsInfo.Recorder = &Document
	|	AND CASE
	|		WHEN T2015S_TransactionsInfo.Order.ref IS NULL
	|			THEN VALUE(Document.PurchaseOrder.EmptyRef)
	|		ELSE T2015S_TransactionsInfo.Order
	|	END = &Order";
	Query.SetParameter("Company"          , TransactionKey.Company);
	Query.SetParameter("Branch"           , TransactionKey.Branch);
	Query.SetParameter("Currency"         , TransactionKey.Currency);
	Query.SetParameter("Date"             , Document.Date);
	Query.SetParameter("LegalName"        , TransactionKey.LegalName);
	Query.SetParameter("Partner"          , TransactionKey.Partner);
	Query.SetParameter("Agreement"        , TransactionKey.Agreement);
	Query.SetParameter("TransactionBasis" , TransactionKey.TransactionBasis);
	Query.SetParameter("Document"         , Document);
	Query.SetParameter("Order"            , ?(ValueIsFilled(TransactionKey.Order)
		,TransactionKey.Order, Documents.PurchaseOrder.EmptyRef()));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
Endfunction

Procedure CreateAdvancesKeys(Parameters, Records_AdvancesKey, Table_DocumentAndAdvancesKey)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.Order
	|INTO tmp_AdvInfo
	|FROM
	|	InformationRegister.T2014S_AdvancesInfo AS AdvInfo
	|WHERE
	|	AdvInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND AdvInfo.Company = &Company
	|	AND AdvInfo.Branch = &Branch
	|	AND AdvInfo.IsVendorAdvance
	|GROUP BY
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(AdvKeys.Ref) AS AdvanceKey,
	|	tmp_AdvInfo.Company,
	|	tmp_AdvInfo.Branch,
	|	tmp_AdvInfo.Currency,
	|	tmp_AdvInfo.Partner,
	|	tmp_AdvInfo.LegalName,
	|	tmp_AdvInfo.Order,
	|	TRUE AS IsVendorAdvance
	|FROM
	|	tmp_AdvInfo AS tmp_AdvInfo
	|		LEFT JOIN Catalog.AdvancesKeys AS AdvKeys
	|		ON NOT AdvKeys.DeletionMark
	|		AND tmp_AdvInfo.Company = AdvKeys.Company
	|		AND tmp_AdvInfo.Branch = AdvKeys.Branch
	|		AND tmp_AdvInfo.Currency = AdvKeys.Currency
	|		AND tmp_AdvInfo.Partner = AdvKeys.Partner
	|		AND tmp_AdvInfo.LegalName = AdvKeys.LegalName
	|		AND tmp_AdvInfo.Order = AdvKeys.Order
	|		AND AdvKeys.IsVendorAdvance
	|GROUP BY
	|	tmp_AdvInfo.Branch,
	|	tmp_AdvInfo.Company,
	|	tmp_AdvInfo.Currency,
	|	tmp_AdvInfo.Partner,
	|	tmp_AdvInfo.LegalName,
	|	tmp_AdvInfo.Order";
	
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"      , Parameters.Object.Company);
	Query.SetParameter("Branch"       , Parameters.Object.Branch);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.AdvanceKey) Then // Create
			KeyObject = Catalogs.AdvancesKeys.CreateItem();
			FillPropertyValues(KeyObject, QuerySelection);
			KeyObject.Description = Left(String(New UUID()), 8);
			KeyObject.Write();
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvInfo.Recorder AS Document,
	|	AdvInfo.Date,
	|	AdvInfo.Amount,
	|	AdvInfo.Key,
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.Order
	|INTO tmp_AdvInfo
	|FROM
	|	InformationRegister.T2014S_AdvancesInfo AS AdvInfo
	|WHERE
	|	AdvInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND AdvInfo.Company = &Company
	|	AND AdvInfo.Branch = &Branch
	|	AND AdvInfo.IsVendorAdvance
	|GROUP BY
	|	AdvInfo.Date,
	|	AdvInfo.Amount,
	|	AdvInfo.Key,
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.Order,
	|	AdvInfo.Recorder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_AdvInfo.Document,
	|	tmp_AdvInfo.Date,
	|	tmp_AdvInfo.Amount,
	|	tmp_AdvInfo.Key,
	|	MAX(AdvKeys.Ref) AS AdvanceKey
	|FROM
	|	tmp_AdvInfo AS tmp_AdvInfo
	|		LEFT JOIN Catalog.AdvancesKeys AS AdvKeys
	|		ON NOT AdvKeys.DeletionMark
	|		AND tmp_AdvInfo.Company = AdvKeys.Company
	|		AND tmp_AdvInfo.Branch = AdvKeys.Branch
	|		AND tmp_AdvInfo.Currency = AdvKeys.Currency
	|		AND tmp_AdvInfo.Partner = AdvKeys.Partner
	|		AND tmp_AdvInfo.LegalName = AdvKeys.LegalName
	|		AND tmp_AdvInfo.Order = AdvKeys.Order
	|		AND AdvKeys.IsVendorAdvance
	|GROUP BY
	|	tmp_AdvInfo.Document,
	|	tmp_AdvInfo.Date,
	|	tmp_AdvInfo.Amount,
	|	tmp_AdvInfo.Key";
	
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"      , Parameters.Object.Company);
	Query.SetParameter("Branch"       , Parameters.Object.Branch);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		New_AdvKeys = Records_AdvancesKey.Add();
		New_AdvKeys.RecordType = AccumulationRecordType.Receipt;
		New_AdvKeys.Period     = QuerySelection.Date;
		New_AdvKeys.AdvanceKey = QuerySelection.AdvanceKey;
		New_AdvKeys.Amount     = QuerySelection.Amount;
		
		New_DocKeys = Table_DocumentAndAdvancesKey.Add();
		New_DocKeys.Document   = QuerySelection.Document;
		New_DocKeys.AdvanceKey = QuerySelection.AdvanceKey;
	EndDo;
EndProcedure

Procedure Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey)
	RecordSet = AccumulationRegisters.TM1020B_AdvancesKey.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(Parameters.Object.Ref);
	RecordSet.Load(Records_AdvancesKey);
	RecordSet.SetActive(True);
	RecordSet.Write();
EndProcedure

Procedure CreateTransactionsKeys(Parameters, Records_TransactionsKey, Records_OffsetAging,
	Table_DocumentAndTransactionsKey)
	Query = New Query();
	Query.Text =
	"SELECT
	|	TrnInfo.Company,
	|	TrnInfo.Branch,
	|	TrnInfo.Currency,
	|	TrnInfo.Partner,
	|	TrnInfo.LegalName,
	|	TrnInfo.Agreement,
	|	TrnInfo.Order,
	|	TrnInfo.TransactionBasis
	|INTO tmp_TrnInfo
	|FROM
	|	InformationRegister.T2015S_TransactionsInfo AS TrnInfo
	|WHERE
	|	TrnInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND TrnInfo.Company = &Company
	|	AND TrnInfo.Branch = &Branch
	|	AND TrnInfo.IsVendorTransaction
	|GROUP BY
	|	TrnInfo.Company,
	|	TrnInfo.Branch,
	|	TrnInfo.Currency,
	|	TrnInfo.Partner,
	|	TrnInfo.LegalName,
	|	TrnInfo.Agreement,
	|	TrnInfo.Order,
	|	TrnInfo.TransactionBasis
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(TrnKeys.Ref) AS TransactionKey,
	|	tmp_TrnInfo.Company,
	|	tmp_TrnInfo.Branch,
	|	tmp_TrnInfo.Currency,
	|	tmp_TrnInfo.Partner,
	|	tmp_TrnInfo.LegalName,
	|	tmp_TrnInfo.Agreement,
	|	tmp_TrnInfo.Order,
	|	tmp_TrnInfo.TransactionBasis,
	|	TRUE AS IsVendorTransaction
	|FROM
	|	tmp_TrnInfo AS tmp_TrnInfo
	|		LEFT JOIN Catalog.TransactionsKeys AS TrnKeys
	|		ON NOT TrnKeys.DeletionMark
	|		AND tmp_TrnInfo.Company = TrnKeys.Company
	|		AND tmp_TrnInfo.Branch = TrnKeys.Branch
	|		AND tmp_TrnInfo.Currency = TrnKeys.Currency
	|		AND tmp_TrnInfo.Partner = TrnKeys.Partner
	|		AND tmp_TrnInfo.LegalName = TrnKeys.LegalName
	|		AND tmp_TrnInfo.Agreement = TrnKeys.Agreement
	|		AND tmp_TrnInfo.Order = TrnKeys.Order
	|		AND tmp_TrnInfo.TransactionBasis = TrnKeys.TransactionBasis
	|		AND TrnKeys.IsVendorTransaction
	|GROUP BY
	|	tmp_TrnInfo.Company,
	|	tmp_TrnInfo.Branch,
	|	tmp_TrnInfo.Currency,
	|	tmp_TrnInfo.Partner,
	|	tmp_TrnInfo.LegalName,
	|	tmp_TrnInfo.Agreement,
	|	tmp_TrnInfo.Order,
	|	tmp_TrnInfo.TransactionBasis";
	
	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"      , Parameters.Object.Company);
	Query.SetParameter("Branch"       , Parameters.Object.Branch);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.TransactionKey) Then // Create
			KeyObject = Catalogs.TransactionsKeys.CreateItem();
			FillPropertyValues(KeyObject, QuerySelection);
			KeyObject.Description = Left(String(New UUID()), 8);
			KeyObject.Write();
		EndIf;
	EndDo;
	Query = New Query();
	Query.Text =
	"SELECT
	|	TrnInfo.Date,
	|	TrnInfo.Recorder AS Document,
	|	TrnInfo.Amount,
	|	TrnInfo.IsDue,
	|	TrnInfo.IsPaid,
	|	TrnInfo.Company,
	|	TrnInfo.Branch,
	|	TrnInfo.Currency,
	|	TrnInfo.Partner,
	|	TrnInfo.LegalName,
	|	TrnInfo.Agreement,
	|	TrnInfo.Order,
	|	TrnInfo.TransactionBasis
	|INTO tmp_TrnInfo
	|FROM
	|	InformationRegister.T2015S_TransactionsInfo AS TrnInfo
	|WHERE
	|	TrnInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND TrnInfo.Company = &Company
	|	AND TrnInfo.Branch = &Branch
	|	AND TrnInfo.IsVendorTransaction
	|GROUP BY
	|	TrnInfo.Date,
	|	TrnInfo.Recorder,
	|	TrnInfo.Amount,
	|	TrnInfo.IsDue,
	|	TrnInfo.IsPaid,
	|	TrnInfo.Company,
	|	TrnInfo.Branch,
	|	TrnInfo.Currency,
	|	TrnInfo.Partner,
	|	TrnInfo.LegalName,
	|	TrnInfo.Agreement,
	|	TrnInfo.Order,
	|	TrnInfo.TransactionBasis
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(TrnKeys.Ref) AS TransactionKey,
	|	tmp_TrnInfo.Document,
	|	tmp_TrnInfo.Date,
	|	tmp_TrnInfo.Company,
	|	tmp_TrnInfo.Amount,
	|	tmp_TrnInfo.IsDue,
	|	tmp_TrnInfo.IsPaid
	|FROM
	|	tmp_TrnInfo AS tmp_TrnInfo
	|		LEFT JOIN Catalog.TransactionsKeys AS TrnKeys
	|		ON NOT TrnKeys.DeletionMark
	|		AND tmp_TrnInfo.Company = TrnKeys.Company
	|		AND tmp_TrnInfo.Branch = TrnKeys.Branch
	|		AND tmp_TrnInfo.Currency = TrnKeys.Currency
	|		AND tmp_TrnInfo.Partner = TrnKeys.Partner
	|		AND tmp_TrnInfo.LegalName = TrnKeys.LegalName
	|		AND tmp_TrnInfo.Agreement = TrnKeys.Agreement
	|		AND tmp_TrnInfo.Order = TrnKeys.Order
	|		AND tmp_TrnInfo.TransactionBasis = TrnKeys.TransactionBasis
	|		AND TrnKeys.IsVendorTransaction
	|GROUP BY
	|	tmp_TrnInfo.Date,
	|	tmp_TrnInfo.Document,
	|	tmp_TrnInfo.Company,
	|	tmp_TrnInfo.Amount,
	|	tmp_TrnInfo.IsDue,
	|	tmp_TrnInfo.IsPaid";

	Query.SetParameter("BeginOfPeriod", Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"  , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"      , Parameters.Object.Company);
	Query.SetParameter("Branch"       , Parameters.Object.Branch);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		New_TrnKeys = Records_TransactionsKey.Add();
		If QuerySelection.IsDue Then
			New_TrnKeys.RecordType = AccumulationRecordType.Receipt;
		ElsIf QuerySelection.IsPaid Then
			New_TrnKeys.RecordType = AccumulationRecordType.Expense;
		EndIf;
		
		New_TrnKeys.Period         = QuerySelection.Date;
		New_TrnKeys.TransactionKey = QuerySelection.TransactionKey;
		New_TrnKeys.Amount         = QuerySelection.Amount;
		
		New_DocKeys = Table_DocumentAndTransactionsKey.Add();
		New_DocKeys.Document = QuerySelection.Document;
		New_DocKeys.TransactionKey = QuerySelection.TransactionKey;
		
		// Paid to vendor 
		If QuerySelection.IsPaid Then
			DistributeTransactionToAging(Parameters, QuerySelection.Document.PointInTime(),
				QuerySelection.Document, QuerySelection.TransactionKey, 
				QuerySelection.Amount, Records_OffsetAging);
		EndIf;
	EndDo;
EndProcedure

Procedure Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey)
	RecordSet = AccumulationRegisters.TM1030B_TransactionsKey.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(Parameters.Object.Ref);
	RecordSet.Load(Records_TransactionsKey);
	RecordSet.SetActive(True);
	RecordSet.Write();
EndProcedure

Procedure Write_R5012B_VendorsAging(Parameters, Document, Records_OffsetAging);
	RecordSet_Aging = AccumulationRegisters.R5012B_VendorsAging.CreateRecordSet();
	RecordSet_Aging.Filter.Recorder.Set(Document);
	RecordSet_Aging.Read();
	ArrayForDelete = New Array();
	For Each Record In RecordSet_Aging Do
		If Record.AgingClosing = Parameters.Object.Ref Then
			ArrayForDelete.Add(Record);
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		RecordSet_Aging.Delete(ItemForDelete);
	EndDo;
	
	OffsetInfoByDocument = Records_OffsetAging.Copy(New Structure("Document", Document));
		
	For Each RowOffset In OffsetInfoByDocument Do
		NewRow_Aging = RecordSet_Aging.Add();
		FillPropertyValues(NewRow_Aging, RowOffset);
		NewRow_Aging.RecordType = AccumulationRecordType.Expense;
		NewRow_Aging.AgingClosing = Parameters.Object.Ref;
	EndDo;
		
	RecordSet_Aging.SetActive(True);
	RecordSet_Aging.Write();
EndProcedure

Procedure Write_SelfRecords(Parameters, Records_OffsetOfAdvances)//, Records_OffsetAging)
	
	// R1020B_AdvancesToVendors, R1021B_VendorsTransactions
	Recorders = Records_OffsetOfAdvances.Copy();
	Recorders.GroupBy("Document");
	
	For Each Row In Recorders Do
		
		UseKeyForCurrency = TypeOf(Row.Document) = Type("DocumentRef.BankPayment");
		
		RecordSet_AdvancesToVendors = AccumulationRegisters.R1020B_AdvancesToVendors.CreateRecordSet();
		RecordSet_AdvancesToVendors.Filter.Recorder.Set(Row.Document);
		TableAdvances = RecordSet_AdvancesToVendors.UnloadColumns();
		TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	
		RecordSet_VendorsTransactions = AccumulationRegisters.R1021B_VendorsTransactions.CreateRecordSet();
		RecordSet_VendorsTransactions.Filter.Recorder.Set(Row.Document);
		TableTransactions = RecordSet_VendorsTransactions.UnloadColumns();
		TableTransactions.Columns.Delete(TableTransactions.Columns.PointInTime);
		
		OffsetInfoByDocument = Records_OffsetOfAdvances.Copy(New Structure("Document", Row.Document));
		
		AdvancesColumnKeyExists = False;
		If UseKeyForCurrency Then
			For Each RowOffset In OffsetInfoByDocument Do
				If ValueIsFilled(RowOffset.AdvancesRowKey) Then
					TableAdvances.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
					AdvancesColumnKeyExists = True;
					Break;
				EndIf;
			EndDo;
		EndIf;
		
		TransactionsColumnKeyExists = False;
		If UseKeyForCurrency Then
			For Each RowOffset In OffsetInfoByDocument Do
				If ValueIsFilled(RowOffset.TransactionsRowKey) Then
					TableTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
					TransactionsColumnKeyExists = True;
					Break;
				EndIf;
			EndDo;
		EndIf;
		OffsetInfoByDocument = Records_OffsetOfAdvances.Copy(New Structure("Document", Row.Document));
	
		For Each RowOffset In OffsetInfoByDocument Do
			// Advances
			NewRow_Advances = TableAdvances.Add();
			FillPropertyValues(NewRow_Advances, RowOffset);
			NewRow_Advances.RecordType = AccumulationRecordType.Expense;
			//NewRow_Advances.Basis = RowOffset.AdvancesDocument;
			NewRow_Advances.VendorsAdvancesClosing = Parameters.Object.Ref;
			NewRow_Advances.Order = RowOffset.AdvancesOrder;
			If AdvancesColumnKeyExists Then
				NewRow_Advances.Key = RowOffset.AdvancesRowKey;
			EndIf;
			
			// Transactions
			NewRow_Transactions = TableTransactions.Add();
			FillPropertyValues(NewRow_Transactions, RowOffset);
			NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
			NewRow_Transactions.Basis = RowOffset.TransactionDocument;
			NewRow_Transactions.VendorsAdvancesClosing = Parameters.Object.Ref;
			NewRow_Transactions.Order = RowOffset.TransactionOrder;
			If TransactionsColumnKeyExists Then
				NewRow_Transactions.Key = RowOffset.TransactionsRowKey;
			EndIf;
		EndDo;
	
		// Currency calculation
		CurrenciesParameters = New Structure();

		PostingDataTables = New Map();

		PostingDataTables.Insert(RecordSet_AdvancesToVendors, New Structure("RecordSet", TableAdvances));
		PostingDataTables.Insert(RecordSet_VendorsTransactions, New Structure("RecordSet", TableTransactions));
		ArrayOfPostingInfo = New Array();
		For Each DataTable In PostingDataTables Do
			ArrayOfPostingInfo.Add(DataTable);
		EndDo;
		CurrenciesParameters.Insert("Object", Row.Document);
		CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
		CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);

		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			// Advances
			If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1020B_AdvancesToVendors") Then
				RecordSet_AdvancesToVendors.Read();
				For Each RowPostingInfo In ItemOfPostingInfo.Value.RecordSet Do
					FillPropertyValues(RecordSet_AdvancesToVendors.Add(), RowPostingInfo);
				EndDo;
				RecordSet_AdvancesToVendors.SetActive(True);
				RecordSet_AdvancesToVendors.Write();
			EndIf;
			
			// Transactions
			If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R1021B_VendorsTransactions") Then
				RecordSet_VendorsTransactions.Read();
				For Each RowPostingInfo In ItemOfPostingInfo.Value.RecordSet Do
					FillPropertyValues(RecordSet_VendorsTransactions.Add(), RowPostingInfo);
				EndDo;
				RecordSet_VendorsTransactions.SetActive(True);
				RecordSet_VendorsTransactions.Write();
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure Clear_SelfRecords(Parameters)
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
	
	Ref = Parameters.Object.Ref;
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

#EndRegion


Function OffsetOfAdvances(Parameters)
	If Parameters = Undefined Then
		Return VendorsAdvancesClosingQueryText();
	EndIf;

	//ClearSelfRecords(Parameters.Object.Ref);

	If Parameters.Property("Unposting") And Parameters.Unposting Then
		Return VendorsAdvancesClosingQueryText();
	EndIf;

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
	Query.SetParameter("EndOfPeriod", Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company", Parameters.Object.Company);
	Query.SetParameter("Branch", Parameters.Object.Branch);

	QueryTable = Query.Execute().Unload();
	For Each Row In QueryTable Do
		Parameters.Insert("RecorderPointInTime", Row.Recorder.PointInTime());
		If Row.IsVendorTransaction Then
			Create_VendorsTransactions(Row.Recorder, Parameters);
			Create_VendorsAging(Row.Recorder, Parameters);
			OffsetOfPartnersServer.Vendors_OnTransaction(Parameters);

			UseKeyForAdvance = False;
			If OffsetOfPartnersServer.IsDebitCreditNote(Row.Recorder) Then
				UseKeyForAdvance = True;
			EndIf;

			Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull, UseKeyForAdvance);
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

			UseKeyForAdvance = True;
			If OffsetOfPartnersServer.IsReturn(Row.Recorder) Then
				UseKeyForAdvance = False;
			EndIf;

			Write_AdvancesAndTransactions(Row.Recorder, Parameters, OffsetOfAdvanceFull, UseKeyForAdvance);
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
	Return "SELECT *
		   |INTO OffsetOfAdvancesEmpty
		   |FROM
		   |	Document.VendorsAdvancesClosing AS OffsetOfAdvance
		   |WHERE
		   |	FALSE";
EndFunction


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

	PostingDataTables.Insert(RecordSet_AdvancesToVendors, New Structure("RecordSet", TableAdvances));
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

	If UseKeyForAdvance Then
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

	PostingDataTables.Insert(RecordSet_AdvancesToVendors, New Structure("RecordSet", TableAdvances));
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