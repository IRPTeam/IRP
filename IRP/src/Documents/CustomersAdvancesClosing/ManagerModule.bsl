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
	AdvancesRelevanceServer.Reset(Ref, Ref.Company, Ref.BeginOfPeriod);
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

#Region OffsetOfAdvancesAndAging

Function OffsetOfAdvancesAndAging(Parameters)
	If Parameters = Undefined Then
		Return CustomersAdvancesClosingQueryText();
	EndIf;
	If Parameters.Property("Unposting") And Parameters.Unposting Then
		Clear_SelfRecords(Parameters);
		Return CustomersAdvancesClosingQueryText();
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
		Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers.StandardAttributes.Recorder.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("AdvanceKey", New TypeDescription("CatalogRef.AdvancesKeys"));
	
	CreateAdvancesKeys(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Table_DocumentAndAdvancesKey);
	// Write advances keys to TM1020B_AdvancesKey, Receipt
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
		
	// Create transactions keys
	Table_DocumentAndTransactionsKey = New ValueTable();
	Table_DocumentAndTransactionsKey.Columns.Add("Document", 
		Metadata.AccumulationRegisters.R2021B_CustomersTransactions.StandardAttributes.Recorder.Type);
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
			
			If TypeOf(QuerySelection.Document) = Type("DocumentRef.SalesOrderClosing") 
				And ValueIsFilled(QuerySelection.AdvanceKey.Order) Then
				AdvanceKeyWithoutOrder = ReleaseAdvanceByOrder(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, 
					QuerySelection.Document, QuerySelection.PointInTime.Date, QuerySelection.AdvanceKey);
				OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances,
				Records_OffsetAging, AdvanceKeyWithoutOrder, QuerySelection.PointInTime, QuerySelection.Document);
			Else
				OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances,
					Records_OffsetAging, QuerySelection.AdvanceKey, QuerySelection.PointInTime, QuerySelection.Document);
			EndIf;
		EndIf;
		// Offset transactions to advances
		If ValueIsFilled(QuerySelection.TransactionKey) Then
			OffsetTransactionsToAdvances(Parameters, Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances, 
				Records_OffsetAging, QuerySelection.TransactionKey, QuerySelection.PointInTime, QuerySelection.Document);
		EndIf;
	EndDo;
	
	// Write OffsetInfo to R2020B_AdvancesFromCustomers and R2021B_CustomersTransactions
	Write_SelfRecords(Parameters, Records_OffsetOfAdvances);
	
	
	WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging);
	Parameters.Object.RegisterRecords.TM1030B_TransactionsKey.Read();
	Parameters.Object.RegisterRecords.TM1020B_AdvancesKey.Read();
	
	AdvancesRelevanceServer.Clear(Parameters.Object.Ref, Parameters.Object.Company, Parameters.Object.EndOfPeriod);
	AdvancesRelevanceServer.Restore(Parameters.Object.Ref, Parameters.Object.Company, Parameters.Object.EndOfPeriod);
	
	Return CustomersAdvancesClosingQueryText();
EndFunction

Procedure WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	Records_OffsetOfAdvances.Period,
	|	Records_OffsetOfAdvances.Document,
	|	Records_OffsetOfAdvances.IsAdvanceRelease,
	|	Records_OffsetOfAdvances.Company,
	|	Records_OffsetOfAdvances.Branch,
	|	Records_OffsetOfAdvances.Currency,
	|	Records_OffsetOfAdvances.Partner,
	|	Records_OffsetOfAdvances.LegalName,
	|	Records_OffsetOfAdvances.TransactionDocument,
	|	Records_OffsetOfAdvances.Agreement,
	|	Records_OffsetOfAdvances.AdvancesOrder,
	|	Records_OffsetOfAdvances.TransactionOrder,
	|	Records_OffsetOfAdvances.FromAdvanceKey,
	|	Records_OffsetOfAdvances.ToTransactionKey,
	|	Records_OffsetOfAdvances.FromTransactionKey,
	|	Records_OffsetOfAdvances.ToAdvanceKey,
	|	Records_OffsetOfAdvances.Key,
	|	Records_OffsetOfAdvances.Amount
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
	|	tmpRecords_OffsetOfAdvances.IsAdvanceRelease,
	|	tmpRecords_OffsetOfAdvances.Company,
	|	tmpRecords_OffsetOfAdvances.Branch,
	|	tmpRecords_OffsetOfAdvances.Currency,
	|	tmpRecords_OffsetOfAdvances.Partner,
	|	tmpRecords_OffsetOfAdvances.LegalName,
	|	tmpRecords_OffsetOfAdvances.TransactionDocument,
	|	tmpRecords_OffsetOfAdvances.Agreement,
	|	tmpRecords_OffsetOfAdvances.AdvancesOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.FromAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.ToTransactionKey,
	|	tmpRecords_OffsetOfAdvances.FromTransactionKey,
	|	tmpRecords_OffsetOfAdvances.ToAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.Key,
	|	SUM(tmpRecords_OffsetOfAdvances.Amount) AS Amount
	|INTO Records_OffsetOfAdvances
	|FROM
	|	tmpRecords_OffsetOfAdvances AS tmpRecords_OffsetOfAdvances
	|GROUP BY
	|	tmpRecords_OffsetOfAdvances.Period,
	|	tmpRecords_OffsetOfAdvances.Document,
	|	tmpRecords_OffsetOfAdvances.IsAdvanceRelease,
	|	tmpRecords_OffsetOfAdvances.Company,
	|	tmpRecords_OffsetOfAdvances.Branch,
	|	tmpRecords_OffsetOfAdvances.Currency,
	|	tmpRecords_OffsetOfAdvances.Partner,
	|	tmpRecords_OffsetOfAdvances.LegalName,
	|	tmpRecords_OffsetOfAdvances.TransactionDocument,
	|	tmpRecords_OffsetOfAdvances.Agreement,
	|	tmpRecords_OffsetOfAdvances.AdvancesOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.FromAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.ToTransactionKey,
	|	tmpRecords_OffsetOfAdvances.FromTransactionKey,
	|	tmpRecords_OffsetOfAdvances.ToAdvanceKey,
	|	tmpRecords_OffsetOfAdvances.Key
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

// transaction 01.01 => advance 02.01
Procedure OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
	Records_OffsetAging, AdvanceKey, PointInTime, Document)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvancesBalance.AdvanceKey,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, AdvanceKey = &AdvanceKey
	|	AND AdvanceKey.IsCustomerAdvance) AS AdvancesBalance";
	
	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary", Boundary);

	Query.SetParameter("AdvanceKey"   , AdvanceKey);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteAdvances = False;
	RepeatThisAdvance = False;
	While QuerySelection.Next() Do
//		If QuerySelection.AdvanceAmount < 0 Then
//			Raise StrTemplate("Advance < 0 ADV_KEY[%1]", QuerySelection.AdvanceKey);
//		EndIf;
		
		DistributeAdvanceToTransaction(Parameters, PointInTime, Document, QuerySelection.AdvanceKey, QuerySelection.AdvanceAmount,
			Records_TransactionsKey, Records_AdvancesKey, Records_OffsetOfAdvances, 
			Records_OffsetAging, NeedWriteAdvances, RepeatThisAdvance);
		
		// Advance balance is change
		If RepeatThisAdvance Then
			Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
			OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
				Records_OffsetAging, AdvanceKey, PointInTime, Document);
		EndIf;	
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
	Records_OffsetAging, NeedWriteAdvances, RepeatThisAdvance)
	
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
			// Return due to advance, change advance balance
			// Transactions
			NewRow_Transactions = Records_TransactionsKey.Add();
			NewRow_Transactions.RecordType     = AccumulationRecordType.Expense;
			NewRow_Transactions.Period         = Document.Date;
			NewRow_Transactions.TransactionKey = QuerySelection.TransactionKey;
			NewRow_Transactions.Amount         = QuerySelection.TransactionAmount;
			
			// Advances
			NewRow_Advances = Records_AdvancesKey.Add();
			NewRow_Advances.RecordType = AccumulationRecordType.Expense;
			NewRow_Advances.Period     = Document.Date;
			NewRow_Advances.AdvanceKey = AdvanceKey;
			NewRow_Advances.Amount     = QuerySelection.TransactionAmount;
			
			// OffsetOfAdvances
			NewOffsetInfo = Records_OffsetOfAdvances.Add();
			NewOffsetInfo.Period              = Document.Date;
			NewOffsetInfo.Amount              = QuerySelection.TransactionAmount;
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
			
			Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
			
			RepeatThisAdvance = True;
			Break;
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
	 Records_OffsetAging, TransactionKey, PointInTime, Document)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TransactionsBalance.TransactionKey,
	|	TransactionsBalance.AmountBalance AS TransactionAmount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(
	|  &TransactionBoundary
	|, TransactionKey = &TransactionKey
	|	AND TransactionKey.IsCustomerTransaction) AS TransactionsBalance";

	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("TransactionBoundary", Boundary);

	Query.SetParameter("TransactionKey" , TransactionKey);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		If QuerySelection.TransactionAmount < 0 Then
			// Return due to advance, change advance balance
			AdvanceKey = GetAdvanceKeyByTransactionKey(TransactionKey);
			
			// Transactions
			NewRow_Transactions = Records_TransactionsKey.Add();
			NewRow_Transactions.RecordType     = AccumulationRecordType.Expense;
			NewRow_Transactions.Period         = Document.Date;
			NewRow_Transactions.TransactionKey = TransactionKey;
			NewRow_Transactions.Amount         = QuerySelection.TransactionAmount;
			
			// Advances
			NewRow_Advances = Records_AdvancesKey.Add();
			NewRow_Advances.RecordType = AccumulationRecordType.Expense;
			NewRow_Advances.Period     = Document.Date;
			NewRow_Advances.AdvanceKey = AdvanceKey;
			NewRow_Advances.Amount     = QuerySelection.TransactionAmount;
			
			// OffsetOfAdvances
			NewOffsetInfo = Records_OffsetOfAdvances.Add();
			NewOffsetInfo.Period              = Document.Date;
			NewOffsetInfo.Amount              = QuerySelection.TransactionAmount;
			NewOffsetInfo.Document            = Document;
			NewOffsetInfo.Company             = AdvanceKey.Company;
			NewOffsetInfo.Branch              = AdvanceKey.Branch;
			NewOffsetInfo.Currency            = AdvanceKey.Currency;
			NewOffsetInfo.Partner             = AdvanceKey.Partner;
			NewOffsetInfo.LegalName           = AdvanceKey.LegalName;
			NewOffsetInfo.TransactionDocument = TransactionKey.TransactionBasis;
			NewOffsetInfo.Agreement           = TransactionKey.Agreement;
			NewOffsetInfo.AdvancesOrder       = AdvanceKey.Order;
			NewOffsetInfo.TransactionOrder    = TransactionKey.Order;
			NewOffsetInfo.FromTransactionKey  = TransactionKey;
			NewOffsetInfo.ToAdvanceKey        = AdvanceKey;
			NewOffsetInfo.Key = NewOffsetInfo.AdvancesRowKey; 
			
			Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
			Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
			
			OffsetAdvancesToTransactions(Parameters, Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances,
			 Records_OffsetAging, AdvanceKey, PointInTime, Document);
			 Continue;
		EndIf;
		
		DistributeTransactionToAdvance(Parameters, PointInTime, Document, QuerySelection.TransactionKey, QuerySelection.TransactionAmount,
			Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
			Records_OffsetAging, NeedWriteTransactions);
	EndDo;
	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	EndIf;
EndProcedure

Function GetAdvanceKeyByAdvanceKeyWithOrder(AdvanceKey)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	AdvKeys.Ref AS AdvanceKey
	|FROM
	|	Catalog.AdvancesKeys AS AdvKeys
	|WHERE
	|	NOT AdvKeys.DeletionMark
	|	AND &Company = AdvKeys.Company
	|	AND &Branch = AdvKeys.Branch
	|	AND &Currency = AdvKeys.Currency
	|	AND &Partner = AdvKeys.Partner
	|	AND &LegalName = AdvKeys.LegalName
	|	AND AdvKeys.IsCustomerAdvance";
	
	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		KeyRef = QuerySelection.AdvanceKey;
	Else // Create
		KeyObject = Catalogs.AdvancesKeys.CreateItem();
		KeyObject.Company   = AdvanceKey.Company;
		KeyObject.Branch    = AdvanceKey.Branch;
		KeyObject.Currency  = AdvanceKey.Currency;
		KeyObject.Partner   = AdvanceKey.Partner;
		KeyObject.LegalName = AdvanceKey.LegalName;
		KeyObject.IsCustomerAdvance = True;
		KeyObject.Description = Left(String(New UUID()), 8);
		KeyObject.Write();
		KeyRef = KeyObject.Ref;
	EndIf;
	Return KeyRef;
EndFunction

Function GetAdvanceKeyByTransactionKey(TransactionKey)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	AdvKeys.Ref AS AdvanceKey
	|FROM
	|	Catalog.AdvancesKeys AS AdvKeys
	|WHERE
	|	NOT AdvKeys.DeletionMark
	|	AND &Company = AdvKeys.Company
	|	AND &Branch = AdvKeys.Branch
	|	AND &Currency = AdvKeys.Currency
	|	AND &Partner = AdvKeys.Partner
	|	AND &LegalName = AdvKeys.LegalName
	|	AND &Order = CASE
	|		WHEN AdvKeys.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvKeys.Order
	|	END
	|	AND AdvKeys.IsCustomerAdvance";
	
	Query.SetParameter("Company"   , TransactionKey.Company);
	Query.SetParameter("Branch"    , TransactionKey.Branch);
	Query.SetParameter("Currency"  , TransactionKey.Currency);
	Query.SetParameter("Partner"   , TransactionKey.Partner);
	Query.SetParameter("LegalName" , TransactionKey.LegalName);
	Query.SetParameter("Order", ?(ValueIsFilled(TransactionKey.Order), TransactionKey.Order, Undefined));
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		KeyRef = QuerySelection.AdvanceKey;
	Else // Create
		KeyObject = Catalogs.AdvancesKeys.CreateItem();
		KeyObject.Company   = TransactionKey.Company;
		KeyObject.Branch    = TransactionKey.Branch;
		KeyObject.Currency  = TransactionKey.Currency;
		KeyObject.Partner   = TransactionKey.Partner;
		KeyObject.LegalName = TransactionKey.LegalName;
		KeyObject.Order     = TransactionKey.Order;
		KeyObject.IsCustomerAdvance = True;
		KeyObject.Description = Left(String(New UUID()), 8);
		KeyObject.Write();
		KeyRef = KeyObject.Ref;
	EndIf;
	Return KeyRef;
EndFunction

// advance 01.01 => transaction 02.01
// records in invoice
Procedure DistributeTransactionToAdvance(Parameters, PointInTime, Document, TransactionKey, TransactionAmount, 
	Records_AdvancesKey, Records_TransactionsKey, Records_OffsetOfAdvances, 
	Records_OffsetAging, NeedWriteTransactions)
	
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
	|	CustomersAging.PaymentDate,
	|	CustomersAging.AmountBalance AS PaymentAmount
	|FROM
	|	AccumulationRegister.R5011B_CustomersAging.Balance(&TransactionBoundary, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Agreement = &Agreement
	|	AND Partner = &Partner
	|	AND Invoice = &TransactionBasis) AS CustomersAging";
	
	Boundary = New Boundary(PointInTime, BoundaryType.Including);
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
		Write_R5011B_CustomersAging(Parameters, Document, Records_OffsetAging);
	EndIf;
EndProcedure

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
	|	AND T2014S_AdvancesInfo.IsCustomerAdvance
	|	AND T2014S_AdvancesInfo.LegalName = &LegalName
	|	AND T2014S_AdvancesInfo.Partner = &Partner
	|	AND T2014S_AdvancesInfo.Recorder = &Document
	|	AND CASE
	|		WHEN T2014S_AdvancesInfo.Order.Ref IS NULL
	|			THEN VALUE(Document.SalesOrder.EmptyRef)
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
		,AdvanceKey.Order, Documents.SalesOrder.EmptyRef()));
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
	|	AND T2015S_TransactionsInfo.IsCustomerTransaction
	|	AND T2015S_TransactionsInfo.LegalName = &LegalName
	|	AND T2015S_TransactionsInfo.Partner = &Partner
	|	AND T2015S_TransactionsInfo.Agreement = &Agreement
	|	AND T2015S_TransactionsInfo.TransactionBasis = &TransactionBasis
	|	AND T2015S_TransactionsInfo.Recorder = &Document
	|	AND CASE
	|		WHEN T2015S_TransactionsInfo.Order.Ref IS NULL
	|			THEN VALUE(Document.SalesOrder.EmptyRef)
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
		,TransactionKey.Order, Documents.SalesOrder.EmptyRef()));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
Endfunction

Procedure CreateAdvancesKeys(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Table_DocumentAndAdvancesKey)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvInfo.Order
	|	END AS Order
	|INTO tmp_AdvInfo
	|FROM
	|	InformationRegister.T2014S_AdvancesInfo AS AdvInfo
	|WHERE
	|	AdvInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND AdvInfo.Company = &Company
	|	AND AdvInfo.Branch = &Branch
	|	AND AdvInfo.IsCustomerAdvance
	|GROUP BY
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvInfo.Order
	|	END
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
	|	TRUE AS IsCustomerAdvance
	|FROM
	|	tmp_AdvInfo AS tmp_AdvInfo
	|		LEFT JOIN Catalog.AdvancesKeys AS AdvKeys
	|		ON NOT AdvKeys.DeletionMark
	|		AND tmp_AdvInfo.Company = AdvKeys.Company
	|		AND tmp_AdvInfo.Branch = AdvKeys.Branch
	|		AND tmp_AdvInfo.Currency = AdvKeys.Currency
	|		AND tmp_AdvInfo.Partner = AdvKeys.Partner
	|		AND tmp_AdvInfo.LegalName = AdvKeys.LegalName
	|		AND CASE
	|			WHEN tmp_AdvInfo.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_AdvInfo.Order
	|		END = CASE
	|			WHEN AdvKeys.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE AdvKeys.Order
	|		END
	|		AND AdvKeys.IsCustomerAdvance
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
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvInfo.Order
	|	END AS Order,
	|	AdvInfo.IsSalesOrderClose
	|INTO tmp_AdvInfo
	|FROM
	|	InformationRegister.T2014S_AdvancesInfo AS AdvInfo
	|WHERE
	|	AdvInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND AdvInfo.Company = &Company
	|	AND AdvInfo.Branch = &Branch
	|	AND AdvInfo.IsCustomerAdvance
	|GROUP BY
	|	AdvInfo.Date,
	|	AdvInfo.Amount,
	|	AdvInfo.Key,
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvInfo.Order
	|	END,
	|	AdvInfo.Recorder,
	|	AdvInfo.IsSalesOrderClose
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_AdvInfo.Document,
	|	tmp_AdvInfo.Date,
	|	tmp_AdvInfo.Amount,
	|	tmp_AdvInfo.Key,
	|	tmp_AdvInfo.IsSalesOrderClose,
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
	|		AND CASE
	|			WHEN tmp_AdvInfo.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_AdvInfo.Order
	|		END = CASE
	|			WHEN AdvKeys.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE AdvKeys.Order
	|		END
	|		AND AdvKeys.IsCustomerAdvance
	|GROUP BY
	|	tmp_AdvInfo.Document,
	|	tmp_AdvInfo.IsSalesOrderClose,
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
		If Not QuerySelection.IsSalesOrderClose Then
			New_AdvKeys = Records_AdvancesKey.Add();
			New_AdvKeys.RecordType = AccumulationRecordType.Receipt;
			New_AdvKeys.Period     = QuerySelection.Date;
			New_AdvKeys.AdvanceKey = QuerySelection.AdvanceKey;
			New_AdvKeys.Amount     = QuerySelection.Amount;
		EndIf;
		
		New_DocKeys = Table_DocumentAndAdvancesKey.Add();
		New_DocKeys.Document   = QuerySelection.Document;
		New_DocKeys.AdvanceKey = QuerySelection.AdvanceKey;
	EndDo;
EndProcedure

Function ReleaseAdvanceByOrder(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, 
	Document, Date, AdvanceKey)
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvancesBalance.AdvanceKey,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, AdvanceKey = &AdvanceKey
	|	AND AdvanceKey.IsCustomerAdvance) AS AdvancesBalance";
	
	Point = New PointInTime(Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary", Boundary);
	Query.SetParameter("AdvanceKey"   , AdvanceKey);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	AdvanceKeyWithoutOrder = GetAdvanceKeyByAdvanceKeyWithOrder(AdvanceKey);
	NeedWriteAdvances = False;
	While QuerySelection.Next() Do
		If QuerySelection.AdvanceAmount < 0 Then
			Raise StrTemplate("Advance < 0 ADV_KEY[%1]", QuerySelection.AdvanceKey);
		EndIf;
		NeedWriteAdvances = True;
		// Minus by advance with order
		New_AdvKeys_Minus = Records_AdvancesKey.Add();
		New_AdvKeys_Minus.RecordType = AccumulationRecordType.Receipt;
		New_AdvKeys_Minus.Period     = Date;
		New_AdvKeys_Minus.AdvanceKey = AdvanceKey;//key with order
		New_AdvKeys_Minus.Amount     = - QuerySelection.AdvanceAmount;
		
		// Plus by advance without order
		New_AdvKeys_Minus = Records_AdvancesKey.Add();
		New_AdvKeys_Minus.RecordType = AccumulationRecordType.Receipt;
		New_AdvKeys_Minus.Period     = Date;
		AdvanceKey_WithoutOrder      = AdvanceKeyWithoutOrder;
		New_AdvKeys_Minus.AdvanceKey = AdvanceKey_WithoutOrder;//key without order
		New_AdvKeys_Minus.Amount     = QuerySelection.AdvanceAmount;
		
		// OffsetOfAdvances - minus with order (record type expense)
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.IsAdvanceRelease  = True;
		NewOffsetInfo.Period        = Date;
		NewOffsetInfo.Amount        = QuerySelection.AdvanceAmount;
		NewOffsetInfo.Document      = Document;
		NewOffsetInfo.Company       = AdvanceKey.Company;
		NewOffsetInfo.Branch        = AdvanceKey.Branch;
		NewOffsetInfo.Currency      = AdvanceKey.Currency;
		NewOffsetInfo.Partner       = AdvanceKey.Partner;
		NewOffsetInfo.LegalName     = AdvanceKey.LegalName;
		NewOffsetInfo.AdvancesOrder = AdvanceKey.Order;
		
		// OffsetOfAdvances - plus without order (record type expense)
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.IsAdvanceRelease = True;
		NewOffsetInfo.Period       = Date;
		NewOffsetInfo.Amount       = - QuerySelection.AdvanceAmount;
		NewOffsetInfo.Document     = Document;
		NewOffsetInfo.Company      = AdvanceKey.Company;
		NewOffsetInfo.Branch       = AdvanceKey.Branch;
		NewOffsetInfo.Currency     = AdvanceKey.Currency;
		NewOffsetInfo.Partner      = AdvanceKey.Partner;
		NewOffsetInfo.LegalName    = AdvanceKey.LegalName;
	EndDo;
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
	Return AdvanceKeyWithoutOrder;
EndFunction

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
	|	CASE
	|		WHEN TrnInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.Order
	|	END AS Order,
	|	CASE
	|		WHEN TrnInfo.TransactionBasis.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.TransactionBasis
	|	END AS TransactionBasis
	|INTO tmp_TrnInfo
	|FROM
	|	InformationRegister.T2015S_TransactionsInfo AS TrnInfo
	|WHERE
	|	TrnInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND TrnInfo.Company = &Company
	|	AND TrnInfo.Branch = &Branch
	|	AND TrnInfo.IsCustomerTransaction
	|GROUP BY
	|	TrnInfo.Company,
	|	TrnInfo.Branch,
	|	TrnInfo.Currency,
	|	TrnInfo.Partner,
	|	TrnInfo.LegalName,
	|	TrnInfo.Agreement,
	|	CASE
	|		WHEN TrnInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.Order
	|	END,
	|	CASE
	|		WHEN TrnInfo.TransactionBasis.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.TransactionBasis
	|	END
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
	|	TRUE AS IsCustomerTransaction
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
	|		AND CASE
	|			WHEN tmp_TrnInfo.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_TrnInfo.Order
	|		END = CASE
	|			WHEN TrnKeys.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE TrnKeys.Order
	|		END
	|		AND CASE
	|			WHEN tmp_TrnInfo.TransactionBasis.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_TrnInfo.TransactionBasis
	|		END = CASE
	|			WHEN TrnKeys.TransactionBasis.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE TrnKeys.TransactionBasis
	|		END
	|		AND TrnKeys.IsCustomerTransaction
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
	|	CASE
	|		WHEN TrnInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.Order
	|	END AS Order,
	|	CASE
	|		WHEN TrnInfo.TransactionBasis.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.TransactionBasis
	|	END AS TransactionBasis
	|INTO tmp_TrnInfo
	|FROM
	|	InformationRegister.T2015S_TransactionsInfo AS TrnInfo
	|WHERE
	|	TrnInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND TrnInfo.Company = &Company
	|	AND TrnInfo.Branch = &Branch
	|	AND TrnInfo.IsCustomerTransaction
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
	|	CASE
	|		WHEN TrnInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.Order
	|	END,
	|	CASE
	|		WHEN TrnInfo.TransactionBasis.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.TransactionBasis
	|	END
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
	|		AND CASE
	|			WHEN tmp_TrnInfo.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_TrnInfo.Order
	|		END = CASE
	|			WHEN TrnKeys.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE TrnKeys.Order
	|		END
	|		AND CASE
	|			WHEN tmp_TrnInfo.TransactionBasis.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_TrnInfo.TransactionBasis
	|		END = CASE
	|			WHEN TrnKeys.TransactionBasis.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE TrnKeys.TransactionBasis
	|		END
	|		AND TrnKeys.IsCustomerTransaction
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
		If QuerySelection.IsDue Then
			RecordType = AccumulationRecordType.Receipt;
		ElsIf QuerySelection.IsPaid Then
			RecordType = AccumulationRecordType.Expense;
		Else
			Continue;
		EndIf;
		New_TrnKeys = Records_TransactionsKey.Add();
		New_TrnKeys.RecordType = RecordType;
		
		New_TrnKeys.Period         = QuerySelection.Date;
		New_TrnKeys.TransactionKey = QuerySelection.TransactionKey;
		New_TrnKeys.Amount         = QuerySelection.Amount;
		
		New_DocKeys = Table_DocumentAndTransactionsKey.Add();
		New_DocKeys.Document = QuerySelection.Document;
		New_DocKeys.TransactionKey = QuerySelection.TransactionKey;
		
		// Paid from customer 
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

Procedure Write_R5011B_CustomersAging(Parameters, Document, Records_OffsetAging);
	RecordSet_Aging = AccumulationRegisters.R5011B_CustomersAging.CreateRecordSet();
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

Procedure Write_SelfRecords(Parameters, Records_OffsetOfAdvances)
	
	// R2020B_AdvancesFromCustomers, R2021B_CustomersTransactions
	Recorders = Records_OffsetOfAdvances.Copy();
	Recorders.GroupBy("Document");
	
	For Each Row In Recorders Do
		
		UseKeyForCurrency = 
		TypeOf(Row.Document) = Type("DocumentRef.BankPayment")
		Or TypeOf(Row.Document) = Type("DocumentRef.BankReceipt")
		Or TypeOf(Row.Document) = Type("DocumentRef.CashPayment")
		Or TypeOf(Row.Document) = Type("DocumentRef.CashReceipt")
		Or TypeOf(Row.Document) = Type("DocumentRef.CreditNote")
		Or TypeOf(Row.Document) = Type("DocumentRef.DebitNote")
		Or TypeOf(Row.Document) = Type("DocumentRef.OpeningEntry");
		
		RecordSet_AdvancesFromCustomers = AccumulationRegisters.R2020B_AdvancesFromCustomers.CreateRecordSet();
		RecordSet_AdvancesFromCustomers.Filter.Recorder.Set(Row.Document);
		TableAdvances = RecordSet_AdvancesFromCustomers.UnloadColumns();
		TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);
	
		RecordSet_CustomersTransactions = AccumulationRegisters.R2021B_CustomersTransactions.CreateRecordSet();
		RecordSet_CustomersTransactions.Filter.Recorder.Set(Row.Document);
		TableTransactions = RecordSet_CustomersTransactions.UnloadColumns();
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
			NewRow_Advances.CustomersAdvancesClosing = Parameters.Object.Ref;
			NewRow_Advances.Order = RowOffset.AdvancesOrder;
			If AdvancesColumnKeyExists Then
				NewRow_Advances.Key = RowOffset.AdvancesRowKey;
			EndIf;
			
			If RowOffset.IsAdvanceRelease = True Then
				Continue;
			EndIf;
			
			// Transactions
			NewRow_Transactions = TableTransactions.Add();
			FillPropertyValues(NewRow_Transactions, RowOffset);
			NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
			NewRow_Transactions.Basis = RowOffset.TransactionDocument;
			NewRow_Transactions.CustomersAdvancesClosing = Parameters.Object.Ref;
			NewRow_Transactions.Order = RowOffset.TransactionOrder;
			If TransactionsColumnKeyExists Then
				NewRow_Transactions.Key = RowOffset.TransactionsRowKey;
			EndIf;
		EndDo;
	
		// Currency calculation
		CurrenciesParameters = New Structure();

		PostingDataTables = New Map();

		PostingDataTables.Insert(RecordSet_AdvancesFromCustomers, New Structure("RecordSet", TableAdvances));
		PostingDataTables.Insert(RecordSet_CustomersTransactions, New Structure("RecordSet", TableTransactions));
		ArrayOfPostingInfo = New Array();
		For Each DataTable In PostingDataTables Do
			ArrayOfPostingInfo.Add(DataTable);
		EndDo;
		CurrenciesParameters.Insert("Object", Row.Document);
		CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
		CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);

		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			// Advances
			If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2020B_AdvancesFromCustomers") Then
				RecordSet_AdvancesFromCustomers.Read();
				For Each RowPostingInfo In ItemOfPostingInfo.Value.RecordSet Do
					FillPropertyValues(RecordSet_AdvancesFromCustomers.Add(), RowPostingInfo);
				EndDo;
				RecordSet_AdvancesFromCustomers.SetActive(True);
				RecordSet_AdvancesFromCustomers.Write();
			EndIf;
			
			// Transactions
			If TypeOf(ItemOfPostingInfo.Key) = Type("AccumulationRegisterRecordSet.R2021B_CustomersTransactions") Then
				RecordSet_CustomersTransactions.Read();
				For Each RowPostingInfo In ItemOfPostingInfo.Value.RecordSet Do
					FillPropertyValues(RecordSet_CustomersTransactions.Add(), RowPostingInfo);
				EndDo;
				RecordSet_CustomersTransactions.SetActive(True);
				RecordSet_CustomersTransactions.Write();
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure Clear_SelfRecords(Parameters)
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
	|///////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R5011B_CustomersAging.Recorder
	|FROM
	|	AccumulationRegister.R5011B_CustomersAging AS R5011B_CustomersAging
	|WHERE
	|	R5011B_CustomersAging.AgingClosing = &Ref
	|GROUP BY
	|	R5011B_CustomersAging.Recorder";
	
	Ref = Parameters.Object.Ref;
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

Function CustomersAdvancesClosingQueryText()
	Return "SELECT *
		   |INTO OffsetOfAdvancesEmpty
		   |FROM
		   |	Document.CustomersAdvancesClosing AS OffsetOfAdvance
		   |WHERE
		   |	FALSE";
EndFunction

#EndRegion
