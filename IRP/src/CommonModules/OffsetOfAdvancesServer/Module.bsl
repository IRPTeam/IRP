
Function OffsetOfAdvancesAndAging(Parameters) Export
	
	Parameters.Insert("IsCustomer" , False);
	Parameters.Insert("IsVendor"   , False);
	Parameters.Insert("DocumentName", Undefined);
	
	Parameters.Insert("RegisterName_Advances"     , Undefined);
	Parameters.Insert("RegisterName_Transactions" , Undefined);
	Parameters.Insert("RegisterName_Aging"        , Undefined);
	
	Parameters.Insert("AdvanceType"    , Undefined);  
 	Parameters.Insert("TransactionType", Undefined);
 	Parameters.Insert("OrderCloseType" , Undefined); 
 	Parameters.Insert("_OrderCloseType", Undefined); 
 	Parameters.Insert("Order_EmptyRef" , Undefined);
 
 	Parameters.Insert("IsOffsetOfAdvances", True);
 
	If TypeOf(Parameters.Object.Ref) = Type("DocumentRef.CustomersAdvancesClosing") Then
		
		Parameters.IsCustomer = True;
		Parameters.DocumentName = "CustomersAdvancesClosing";
		
		Parameters.RegisterName_Advances     = "R2020B_AdvancesFromCustomers";
		Parameters.RegisterName_Transactions = "R2021B_CustomersTransactions";
		Parameters.RegisterName_Aging        = "R5011B_CustomersAging";
		
		Parameters.AdvanceType     = "IsCustomerAdvance";
		Parameters.TransactionType = "IsCustomerTransaction";
		Parameters.OrderCloseType  = "IsSalesOrderClose";
		Parameters._OrderCloseType = Type("DocumentRef.SalesOrderClosing");
		Parameters.Order_EmptyRef  = Documents.SalesOrder.EmptyRef();
		
	ElsIf TypeOf(Parameters.Object.Ref) = Type("DocumentRef.VendorsAdvancesClosing") Then
		
		Parameters.IsVendor = True;
		Parameters.DocumentName = "VendorsAdvancesClosing";
		
		Parameters.RegisterName_Advances     = "R1020B_AdvancesToVendors";
		Parameters.RegisterName_Transactions = "R1021B_VendorsTransactions";
		Parameters.RegisterName_Aging        = "R5012B_VendorsAging";
		
		Parameters.AdvanceType     = "IsVendorAdvance";
		Parameters.TransactionType = "IsVendorTransaction";
		Parameters.OrderCloseType  = "IsPurchaseOrderClose";
		Parameters._OrderCloseType = Type("DocumentRef.PurchaseOrderClosing");
		Parameters.Order_EmptyRef  = Documents.PurchaseOrder.EmptyRef();
		
	Else
		Raise StrTemplate("Unsupported document type [%1]", Parameters.Object.Ref);
	EndIf;
	
	If Parameters = Undefined Then
		Return AdvancesClosingQueryText(Parameters);
	EndIf;
	If Parameters.Property("Unposting") And Parameters.Unposting Then
		Clear_SelfRecords(Parameters);
		Return AdvancesClosingQueryText(Parameters);
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
	
	Records_AdvancesCurrencyRevaluation = InformationRegisters.T2012S_AdvancesCurrencyRevaluation.CreateRecordSet().UnloadColumns();
	Records_AdvancesCurrencyRevaluation.Columns.Delete(Records_AdvancesCurrencyRevaluation.Columns.PointInTime);
	
	Records_TransactionsCurrencyRevaluation = InformationRegisters.T2011S_TransactionsCurrencyRevaluation.CreateRecordSet().UnloadColumns();
	Records_TransactionsCurrencyRevaluation.Columns.Delete(Records_TransactionsCurrencyRevaluation.Columns.PointInTime);
	
	// Clear register records
	Clear_SelfRecords(Parameters);
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey); // write empty table
	Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey); // write empty table
	
	// Create advances keys
	Table_DocumentAndAdvancesKey = New ValueTable();;
	Table_DocumentAndAdvancesKey.Columns.Add("Document"   , Metadata.AccumulationRegisters[Parameters.RegisterName_Advances].StandardAttributes.Recorder.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("AdvanceKey" , New TypeDescription("CatalogRef.AdvancesKeys"));
	Table_DocumentAndAdvancesKey.Columns.Add("Amount"     , Metadata.DefinedTypes.typeAmount.Type);

	CreateAdvancesKeys(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Table_DocumentAndAdvancesKey);
	// Write advances keys to TM1020B_AdvancesKey, Receipt
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
		
	// Create transactions keys
	Table_DocumentAndTransactionsKey = New ValueTable();;
	Table_DocumentAndTransactionsKey.Columns.Add("Document"       , Metadata.AccumulationRegisters[Parameters.RegisterName_Transactions].StandardAttributes.Recorder.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("TransactionKey" , New TypeDescription("CatalogRef.TransactionsKeys"));

	CreateTransactionsKeys(Parameters, Records_TransactionsKey, Records_OffsetAging, Table_DocumentAndTransactionsKey);
	// Write transactions keys to TM1030B_TransactionsKey
	Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);

	Query = New Query;
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
	|	left join InformationRegister.T2018S_UserDefinedOffsetOfAdvances AS UserDefined on
	|	tmp_DocAdv.AdvanceKey.Company = UserDefined.Company
	|   and tmp_DocAdv.AdvanceKey.Branch = UserDefined.Branch
	|	and tmp_DocAdv.AdvanceKey.Currency = UserDefined.Currency
	|   and tmp_DocAdv.AdvanceKey.Partner = UserDefined.Partner
	|   and tmp_DocAdv.AdvanceKey.AdvanceAgreement = UserDefined.Agreement
	|   and tmp_DocAdv.AdvanceKey.LegalName = UserDefined.LegalName
	|	and tmp_DocAdv.AdvanceKey.IsVendorAdvance = UserDefined.IsVendorAdvance
	|	and tmp_DocAdv.AdvanceKey.IsCustomerAdvance = UserDefined.IsCustomerAdvance
	|
	|	and case when tmp_DocAdv.AdvanceKey.Order.Ref is null then Undefined else tmp_DocAdv.AdvanceKey.Order end
	|	     = case when UserDefined.Order.Ref is null then Undefined else UserDefined.Order end
	|
	|	and case when tmp_DocAdv.AdvanceKey.AdvanceDocument.Ref is null then Undefined else tmp_DocAdv.AdvanceKey.AdvanceDocument end
	|	     = case when UserDefined.AdvanceDocument.Ref is null then Undefined else UserDefined.AdvanceDocument end
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
	|	left join InformationRegister.T2018S_UserDefinedOffsetOfAdvances AS UserDefined on
	|	tmp_DocTrn.TransactionKey.Company = UserDefined.Company
	|   and tmp_DocTrn.TransactionKey.Branch = UserDefined.Branch
	|	and tmp_DocTrn.TransactionKey.Currency = UserDefined.Currency
	|   and tmp_DocTrn.TransactionKey.Partner = UserDefined.Partner
	|   and tmp_DocTrn.TransactionKey.Agreement = UserDefined.Agreement
	|   and tmp_DocTrn.TransactionKey.LegalName = UserDefined.LegalName
	|	and tmp_DocTrn.TransactionKey.IsVendorTransaction = UserDefined.IsVendorTransaction
	|	and tmp_DocTrn.TransactionKey.IsCustomerTransaction = UserDefined.IsCustomerTransaction
	|
	|	and case when tmp_DocTrn.TransactionKey.Order.Ref is null then Undefined else tmp_DocTrn.TransactionKey.Order end
	|	     = case when UserDefined.Order.Ref is null then Undefined else UserDefined.Order end
	|
	|	and case when tmp_DocTrn.TransactionKey.TransactionBasis.Ref is null then Undefined else tmp_DocTrn.TransactionKey.TransactionBasis end
	|	     = case when UserDefined.TransactionDocument.Ref is null then Undefined else UserDefined.TransactionDocument end
	|	
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
	|	
	|GROUP BY
	|	tmpAllKeys.AdvanceKey,
	|	tmpAllKeys.TransactionKey,
	|	tmpAllKeys.PointInTime,
	|	tmpAllKeys.Document
	|ORDER BY
	|	PointInTime";
	
	
//	Company
//	Branch
//	Currency
//	Partner
//	LegalName
//	Order - empty
//  AdvanceAgreement - Agreement
//	AdvanceDocument
//	++TransactionBasis - empty
//	IsVendorAdvance
//	IsCustomerAdvance
// ++IsCustomerTransaction
// ++IsVendorTransaction
	
	
	Query.SetParameter("DocAdv", Table_DocumentAndAdvancesKey);
	Query.SetParameter("DocTrn", Table_DocumentAndTransactionsKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		// Offset advances to transactions
		If ValueIsFilled(QuerySelection.AdvanceKey) Then

			If TypeOf(QuerySelection.Document) = Parameters._OrderCloseType And ValueIsFilled(QuerySelection.AdvanceKey.Order) Then
				
				AdvanceKeyWithoutOrder = ReleaseAdvanceByOrder(Parameters, 
															   Records_AdvancesKey, 
															   Records_OffsetOfAdvances,
															   QuerySelection.Document, 
															   QuerySelection.PointInTime.Date, 
															   QuerySelection.AdvanceKey);
				OffsetAdvancesToTransactions(Parameters, 
				                             Records_AdvancesKey, 
				                             Records_TransactionsKey,
				                             Records_OffsetOfAdvances, 
				                             Records_OffsetAging, 
				                             AdvanceKeyWithoutOrder, 
				                             QuerySelection.PointInTime,
				                             QuerySelection.Document);
			Else
				OffsetAdvancesToTransactions(Parameters, 
								             Records_AdvancesKey, 
								             Records_TransactionsKey,
								             Records_OffsetOfAdvances, 
								             Records_OffsetAging, 
								             QuerySelection.AdvanceKey,
								             QuerySelection.PointInTime, 
								             QuerySelection.Document);
			EndIf;
		EndIf;
		// Offset transactions to advances
		If ValueIsFilled(QuerySelection.TransactionKey) Then
			OffsetTransactionsToAdvances(Parameters,
			                             Records_TransactionsKey, 
			                             Records_AdvancesKey,
			                             Records_OffsetOfAdvances, 
			                             Records_OffsetAging, 
			                             QuerySelection.TransactionKey,
			                             QuerySelection.PointInTime, 
			                             QuerySelection.Document);
		EndIf;
	EndDo;

	Parameters.Object.RegisterRecords.TM1030B_TransactionsKey.Read();
	Parameters.Object.RegisterRecords.TM1020B_AdvancesKey.Read();
		
	// Write OffsetInfo
	Write_SelfRecords(Parameters, 
	                  Records_OffsetOfAdvances, 
	                  Records_AdvancesCurrencyRevaluation,
	                  Records_TransactionsCurrencyRevaluation);
	                  
	WriteTablesToTempTables(Parameters, 
	                        Records_OffsetOfAdvances, 
	                        Records_OffsetAging, 
	                        Records_AdvancesCurrencyRevaluation,
	                        Records_TransactionsCurrencyRevaluation);

	AdvancesRelevanceServer.Clear(Parameters.Object.Ref, Parameters.Object.Company, Parameters.Object.EndOfPeriod);
	AdvancesRelevanceServer.Restore(Parameters.Object.Ref, Parameters.Object.Company, Parameters.Object.EndOfPeriod);

	Return AdvancesClosingQueryText(Parameters);
EndFunction

Procedure OffsetAdvancesToTransactions(Parameters, 
	                                   Records_AdvancesKey, 
	                                   Records_TransactionsKey, 
	                                   Records_OffsetOfAdvances, 
	                                   Records_OffsetAging, 
	                                   AdvanceKey, 
	                                   PointInTime, 
	                                   Document)
	Query = New Query;
	Query.Text =
	"SELECT
	|	AdvancesBalance.AdvanceKey,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, AdvanceKey = &AdvanceKey
	|	AND AdvanceKey.%1) AS AdvancesBalance";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary", Boundary);

	Query.SetParameter("AdvanceKey", AdvanceKey);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteAdvances = False;
	RepeatThisAdvance = False;
	While QuerySelection.Next() Do
		DistributeAdvanceToTransaction(Parameters, 
		                               PointInTime, 
		                               Document, 
		                               QuerySelection.AdvanceKey,
		                               QuerySelection.AdvanceAmount, 
		                               Records_TransactionsKey, 
		                               Records_AdvancesKey, 
		                               Records_OffsetOfAdvances,
		                               Records_OffsetAging, 
		                               NeedWriteAdvances, 
		                               RepeatThisAdvance);
		
		// Advance balance is change
		If RepeatThisAdvance Then
			Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
			OffsetAdvancesToTransactions(Parameters, 
			                             Records_AdvancesKey, 
			                             Records_TransactionsKey,
			                             Records_OffsetOfAdvances, 
			                             Records_OffsetAging, 
			                             AdvanceKey, 
			                             PointInTime, 
			                             Document);
		EndIf;
	EndDo;
	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;

EndProcedure

Procedure DistributeAdvanceToTransaction(Parameters, 
	                                     PointInTime, 
	                                     Document, 
	                                     AdvanceKey, 
	                                     AdvanceAmount, 
	                                     Records_TransactionsKey, 
	                                     Records_AdvancesKey, 
	                                     Records_OffsetOfAdvances, 
	                                     Records_OffsetAging, 
	                                     NeedWriteAdvances, 
	                                     RepeatThisAdvance)

	Query = New Query;
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

	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);

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
			NewOffsetInfo.TransactionAgreement= QuerySelection.TransactionKey.Agreement;
			NewOffsetInfo.AdvanceAgreement    = AdvanceKey.AdvanceAgreement;
			NewOffsetInfo.AdvanceDocument     = AdvanceKey.AdvanceDocument;
			NewOffsetInfo.AdvancesOrder       = AdvanceKey.Order;
			NewOffsetInfo.TransactionOrder    = QuerySelection.TransactionKey.Order;
			NewOffsetInfo.FromTransactionKey  = QuerySelection.TransactionKey;
			NewOffsetInfo.ToAdvanceKey        = AdvanceKey;
			NewOffsetInfo.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceKey, Document);
			NewOffsetInfo.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, QuerySelection.TransactionKey, Document);
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
		
		If ValueIsFilled(AdvanceKey.AdvanceAgreement) Then // advance by agreement
			If QuerySelection.TransactionKey.Agreement <> AdvanceKey.AdvanceAgreement Then
				Continue;
			EndIf;
		EndIf;
		
		CanWriteoff = Min(QuerySelection.TransactionAmount, NeedWriteoff);
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
		NewOffsetInfo.TransactionAgreement= QuerySelection.TransactionKey.Agreement;
		NewOffsetInfo.AdvanceAgreement    = AdvanceKey.AdvanceAgreement;
		NewOffsetInfo.AdvanceDocument     = AdvanceKey.AdvanceDocument;
		NewOffsetInfo.AdvancesOrder       = AdvanceKey.Order;
		NewOffsetInfo.TransactionOrder    = QuerySelection.TransactionKey.Order;
		NewOffsetInfo.FromTransactionKey  = QuerySelection.TransactionKey;
		NewOffsetInfo.ToAdvanceKey        = AdvanceKey;
		NewOffsetInfo.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceKey, Document);
		NewOffsetInfo.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, QuerySelection.TransactionKey, Document);
		NewOffsetInfo.Key = NewOffsetInfo.AdvancesRowKey;

		DistributeTransactionToAging(Parameters, 
		                             PointInTime, 
		                             Document, 
		                             QuerySelection.TransactionKey, 
		                             CanWriteoff,
		                             Records_OffsetAging);
	EndDo;
	
	// Write offseted transactions to TM1030B_TransactionsKey
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	EndIf;
EndProcedure

Procedure OffsetTransactionsToAdvances(Parameters, 
	                                   Records_TransactionsKey, 
	                                   Records_AdvancesKey, 
	                                   Records_OffsetOfAdvances, 
	                                   Records_OffsetAging, 
	                                   TransactionKey, 
	                                   PointInTime, 
	                                   Document)
	Query = New Query;
	Query.Text =
	"SELECT
	|	TransactionsBalance.TransactionKey,
	|	TransactionsBalance.AmountBalance AS TransactionAmount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(
	|  &TransactionBoundary
	|, TransactionKey = &TransactionKey
	|	AND TransactionKey.%1) AS TransactionsBalance";

	Query.Text = StrTemplate(Query.Text, Parameters.TransactionType);

	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	
	Query.SetParameter("TransactionBoundary" , Boundary);
	Query.SetParameter("TransactionKey"      , TransactionKey);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		If QuerySelection.TransactionAmount < 0 Then
			// Return due to advance, change advance balance
			AdvanceKey = GetAdvanceKeyByTransactionKey(Parameters, TransactionKey, Document);
			
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
			NewOffsetInfo.TransactionAgreement= TransactionKey.Agreement;
			NewOffsetInfo.AdvanceAgreement    = AdvanceKey.AdvanceAgreement;
			NewOffsetInfo.AdvanceDocument     = AdvanceKey.AdvanceDocument;
			NewOffsetInfo.AdvancesOrder       = AdvanceKey.Order;
			NewOffsetInfo.TransactionOrder    = TransactionKey.Order;
			NewOffsetInfo.FromTransactionKey  = TransactionKey;
			NewOffsetInfo.ToAdvanceKey        = AdvanceKey;
			NewOffsetInfo.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceKey, Document);
			NewOffsetInfo.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, TransactionKey, Document);
			NewOffsetInfo.Key = NewOffsetInfo.TransactionsRowKey;

			Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
			Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);

			OffsetAdvancesToTransactions(Parameters, 
			                             Records_AdvancesKey, 
			                             Records_TransactionsKey,
			                             Records_OffsetOfAdvances, 
			                             Records_OffsetAging, 
			                             AdvanceKey, 
			                             PointInTime, 
			                             Document);
			Continue;
		EndIf;

		DistributeTransactionToAdvance(Parameters, 
		                               PointInTime, 
		                               Document, 
		                               QuerySelection.TransactionKey,
		                               QuerySelection.TransactionAmount, 
		                               Records_AdvancesKey, 
		                               Records_TransactionsKey, 
		                               Records_OffsetOfAdvances,
		                               Records_OffsetAging, 
		                               NeedWriteTransactions);
	EndDo;
	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	EndIf;
EndProcedure

Function FindRowKeyByAdvanceKey(Parameters, AdvanceKey, Document)
	Query = New Query;
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
	|	AND T2014S_AdvancesInfo.%1
	|	AND T2014S_AdvancesInfo.LegalName = &LegalName
	|	AND T2014S_AdvancesInfo.Partner = &Partner
	|	AND T2014S_AdvancesInfo.Recorder = &Document
	|	AND T2014S_AdvancesInfo.AdvanceAgreement = &AdvanceAgreement
	|	AND T2014S_AdvancesInfo.AdvanceDocument = &AdvanceDocument
	|	AND CASE
	|		WHEN T2014S_AdvancesInfo.Order.Ref IS NULL
	|			THEN &Order_EmptyRef
	|		ELSE T2014S_AdvancesInfo.Order
	|	END = &Order";
	
	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Date"      , Document.Date);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("Document"  , Document);
	Query.SetParameter("Order", ?(ValueIsFilled(AdvanceKey.Order), AdvanceKey.Order, Parameters.Order_EmptyRef));
	query.SetParameter("Order_EmptyRef", Parameters.Order_EmptyRef);
	query.SetParameter("AdvanceAgreement", AdvanceKey.AdvanceAgreement);
	query.SetParameter("AdvanceDocument", AdvanceKey.AdvanceDocument);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Function FindRowKeyByTransactionKey(Parameters, TransactionKey, Document)
	Query = New Query;
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
	|	AND T2015S_TransactionsInfo.%1
	|	AND T2015S_TransactionsInfo.LegalName = &LegalName
	|	AND T2015S_TransactionsInfo.Partner = &Partner
	|	AND T2015S_TransactionsInfo.Agreement = &Agreement
	|	AND T2015S_TransactionsInfo.TransactionBasis = &TransactionBasis
	|	AND T2015S_TransactionsInfo.Recorder = &Document
	|	AND CASE
	|		WHEN T2015S_TransactionsInfo.Order.Ref IS NULL
	|			THEN &Order_EmptyRef
	|		ELSE T2015S_TransactionsInfo.Order
	|	END = &Order";
	
	Query.Text = StrTemplate(Query.Text, Parameters.TransactionType);
	
	Query.SetParameter("Company"          , TransactionKey.Company);
	Query.SetParameter("Branch"           , TransactionKey.Branch);
	Query.SetParameter("Currency"         , TransactionKey.Currency);
	Query.SetParameter("Date"             , Document.Date);
	Query.SetParameter("LegalName"        , TransactionKey.LegalName);
	Query.SetParameter("Partner"          , TransactionKey.Partner);
	Query.SetParameter("Agreement"        , TransactionKey.Agreement);
	Query.SetParameter("TransactionBasis" , TransactionKey.TransactionBasis);
	Query.SetParameter("Document", Document);
	Query.SetParameter("Order", ?(ValueIsFilled(TransactionKey.Order), TransactionKey.Order, Parameters.Order_EmptyRef));
	Query.SetParameter("Order_EmptyRef", Parameters.Order_EmptyRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Function GetAdvanceKeyByTransactionKey(Parameters, TransactionKey, AdvanceDocument)
	Query = New Query;
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
	|	AND &AdvanceAgreement = AdvKeys.AdvanceAgreement
	|	AND &AdvanceDocument = AdvKeys.AdvanceDocument
	|	AND &Order = CASE
	|		WHEN AdvKeys.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvKeys.Order
	|	END
	|	AND AdvKeys.%1
	|
	|ORDER BY
	|	AdvKeys.AdvanceDocument.Date";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);

	Query.SetParameter("Company"   , TransactionKey.Company);
	Query.SetParameter("Branch"    , TransactionKey.Branch);
	Query.SetParameter("Currency"  , TransactionKey.Currency);
	Query.SetParameter("Partner"   , TransactionKey.Partner);
	Query.SetParameter("LegalName" , TransactionKey.LegalName);
	Query.SetParameter("AdvanceAgreement" , TransactionKey.Agreement);
	Query.SetParameter("AdvanceDocument"  , AdvanceDocument);
	Query.SetParameter("Order"     , ?(ValueIsFilled(TransactionKey.Order), TransactionKey.Order, Undefined));

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	// From transaction to advance when transaction amount < 0
	If QuerySelection.Next() Then
		KeyRef = QuerySelection.AdvanceKey;
	Else // Create
		KeyObject = Catalogs.AdvancesKeys.CreateItem();
		KeyObject.Company   = TransactionKey.Company;
		KeyObject.Branch    = TransactionKey.Branch;
		KeyObject.Currency  = TransactionKey.Currency;
		KeyObject.Partner   = TransactionKey.Partner;
		KeyObject.LegalName = TransactionKey.LegalName;
		KeyObject.AdvanceAgreement = TransactionKey.Agreement;
		KeyObject.AdvanceDocument  = AdvanceDocument;
		KeyObject.Order     = TransactionKey.Order;
		KeyObject[Parameters.AdvanceType] = True;
		KeyObject.Description = Left(String(New UUID), 8);
		KeyObject.Write();
		KeyRef = KeyObject.Ref;
	EndIf;
	Return KeyRef;
EndFunction

Procedure DistributeTransactionToAdvance(Parameters, 
		                                 PointInTime, 
		                                 Document, 
		                                 TransactionKey, 
		                                 TransactionAmount, 
		                                 Records_AdvancesKey, 
		                                 Records_TransactionsKey, 
		                                 Records_OffsetOfAdvances, 
		                                 Records_OffsetAging, 
		                                 NeedWriteTransactions)

	Query = New Query;
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
	Query.SetParameter("Company"   , TransactionKey.Company);
	Query.SetParameter("Branch"    , TransactionKey.Branch);
	Query.SetParameter("Currency"  , TransactionKey.Currency);
	Query.SetParameter("Partner"   , TransactionKey.Partner);
	Query.SetParameter("LegalName" , TransactionKey.LegalName);

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
		
		If ValueIsFilled(QuerySelection.AdvanceKey.AdvanceAgreement) Then // transaction by agreement
			If QuerySelection.AdvanceKey.AdvanceAgreement <> TransactionKey.Agreement Then
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
		NewOffsetInfo.TransactionAgreement= TransactionKey.Agreement;
		NewOffsetInfo.AdvanceAgreement    = QuerySelection.AdvanceKey.AdvanceAgreement;
		NewOffsetInfo.AdvanceDocument    = QuerySelection.AdvanceKey.AdvanceDocument;
		NewOffsetInfo.AdvancesOrder       = QuerySelection.AdvanceKey.Order;
		NewOffsetInfo.TransactionOrder    = TransactionKey.Order;
		NewOffsetInfo.FromAdvanceKey      = QuerySelection.AdvanceKey;
		NewOffsetInfo.ToTransactionKey    = TransactionKey;
		NewOffsetInfo.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, QuerySelection.AdvanceKey, Document);
		NewOffsetInfo.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, TransactionKey, Document);
		NewOffsetInfo.Key = NewOffsetInfo.TransactionsRowKey;

		DistributeTransactionToAging(Parameters, 
		                             PointInTime, 
		                             Document, 
		                             TransactionKey, 
		                             CanWriteoff,
		                             Records_OffsetAging);
	EndDo;
	
	// Write offseted advances to TM1020B_AdvancesKey
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
EndProcedure

Procedure Write_SelfRecords(Parameters, 
	                        Records_OffsetOfAdvances, 
	                        Records_AdvancesCurrencyRevaluation,
	                        Records_TransactionsCurrencyRevaluation)
	
	Recorders = Records_OffsetOfAdvances.Copy();
	Recorders.GroupBy("Document");

	ArrayOfDocumentTypes = New Array();
	ArrayOfDocumentTypes.Add(Type("DocumentRef.BankPayment"));
	ArrayOfDocumentTypes.Add(Type("DocumentRef.BankReceipt"));
	ArrayOfDocumentTypes.Add(Type("DocumentRef.CashPayment"));
	ArrayOfDocumentTypes.Add(Type("DocumentRef.CashReceipt"));
	ArrayOfDocumentTypes.Add(Type("DocumentRef.CreditNote"));
	ArrayOfDocumentTypes.Add(Type("DocumentRef.DebitNote"));
	ArrayOfDocumentTypes.Add(Type("DocumentRef.OpeningEntry"));

	Op = Catalogs.AccountingOperations;
	AccountingOperations = New Map();
	AccountingOperations.Insert(Type("DocumentRef.BankPayment")     , Op.BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors);
	AccountingOperations.Insert(Type("DocumentRef.BankReceipt")     , Op.BankReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers);
	AccountingOperations.Insert(Type("DocumentRef.SalesInvoice")    , Op.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions);
	AccountingOperations.Insert(Type("DocumentRef.PurchaseInvoice") , Op.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors);
	
	For Each Row In Recorders Do

		UseKeyForCurrency = ArrayOfDocumentTypes.Find(TypeOf(Row.Document)) <> Undefined;

		// Accounting amounts
		RecordSet_AccountingAmounts = AccumulationRegisters.T1040T_AccountingAmounts.CreateRecordSet();
		RecordSet_AccountingAmounts.Filter.Recorder.Set(Row.Document);
		TableAccountingAmounts = RecordSet_AccountingAmounts.UnloadColumns();
		TableAccountingAmounts.Columns.Delete(TableAccountingAmounts.Columns.PointInTime);

		// Accounting amounts (currency revaluation)
		TableAccountingAmounts_CurrencyRevaluation = TableAccountingAmounts.CopyColumns();

		// Advances
		RecordSet_Advances = AccumulationRegisters[Parameters.RegisterName_Advances].CreateRecordSet();
		RecordSet_Advances.Filter.Recorder.Set(Row.Document);
		TableAdvances = RecordSet_Advances.UnloadColumns();
		TableAdvances.Columns.Delete(TableAdvances.Columns.PointInTime);

		// Transactions
		RecordSet_Transactions = AccumulationRegisters[Parameters.RegisterName_Transactions].CreateRecordSet();
		RecordSet_Transactions.Filter.Recorder.Set(Row.Document);
		TableTransactions = RecordSet_Transactions.UnloadColumns();
		TableTransactions.Columns.Delete(TableTransactions.Columns.PointInTime);

		// Transactions (currency revaluation)
		TableTransactions_CurrencyRevaluation = TableTransactions.CopyColumns();

		If UseKeyForCurrency Then
			TableAdvances.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
			TableTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
			TableAccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
		EndIf;

		OffsetInfoByDocument = Records_OffsetOfAdvances.Copy(New Structure("Document", Row.Document));

		For Each RowOffset In OffsetInfoByDocument Do
			// Advances
			NewRow_Advances = TableAdvances.Add();
			FillPropertyValues(NewRow_Advances, RowOffset);
			NewRow_Advances.RecordType = AccumulationRecordType.Expense;
			NewRow_Advances[Parameters.DocumentName] = Parameters.Object.Ref;
			NewRow_Advances.Order = RowOffset.AdvancesOrder;
			NewRow_Advances.Agreement = RowOffset.AdvanceAgreement;
			NewRow_Advances.Basis = RowOffset.AdvanceDocument;
			If UseKeyForCurrency Then
				NewRow_Advances.Key = RowOffset.Key;
			EndIf;

			If RowOffset.IsAdvanceRelease = True Then
				Continue;
			EndIf;
			
			// Transactions
			NewRow_Transactions = TableTransactions.Add();
			FillPropertyValues(NewRow_Transactions, RowOffset);
			NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
			NewRow_Transactions.Basis = RowOffset.TransactionDocument;
			NewRow_Transactions[Parameters.DocumentName] = Parameters.Object.Ref;
			NewRow_Transactions.Order = RowOffset.TransactionOrder;
			NewRow_Transactions.Agreement = RowOffset.TransactionAgreement;
			If UseKeyForCurrency Then
				NewRow_Transactions.Key = RowOffset.Key;
			EndIf;
			
			// Accounting amounts
			NewRow_AccountingAmounts = TableAccountingAmounts.Add();
			FillPropertyValues(NewRow_AccountingAmounts, RowOffset);
			NewRow_AccountingAmounts.AdvancesClosing = Parameters.Object.Ref;
			NewRow_AccountingAmounts.RowKey = RowOffset.Key;
			
			Operation = AccountingOperations.Get(TypeOf(Row.Document));
			If Operation <> Undefined Then
				NewRow_AccountingAmounts.Operation = Operation;
			EndIf;
						
			If UseKeyForCurrency Then
				NewRow_AccountingAmounts.Key = RowOffset.Key;
			EndIf;
			
		EndDo;
	
		// Currency calculation
		
		CurrencyTable = Undefined;
		If TypeOf(Row.Document) = Type("DocumentRef.PurchaseOrderClosing") Then
			CurrencyTable = Row.Document.PurchaseOrder.Currencies.Unload();
		ElsIf TypeOf(Row.Document) = Type("DocumentRef.SalesOrderClosing") Then
			CurrencyTable = Row.Document.SalesOrder.Currencies.Unload();
		EndIf;
		
		PostingDataTables = New Map();
		
		RecordSet_AdvancesSettings = PostingServer.PostingTableSettings(TableAdvances, RecordSet_Advances);
		PostingDataTables.Insert(RecordSet_Advances.Metadata(), RecordSet_AdvancesSettings);
		
		RecordSet_TransactionsSettings = PostingServer.PostingTableSettings(TableTransactions, RecordSet_Transactions);
		PostingDataTables.Insert(RecordSet_Transactions.Metadata(), RecordSet_TransactionsSettings);
		
		RecordSet_AccountingAmountsSettings = PostingServer.PostingTableSettings(TableAccountingAmounts, RecordSet_AccountingAmounts);
		PostingDataTables.Insert(RecordSet_AccountingAmounts.Metadata(), RecordSet_AccountingAmountsSettings);
		
		ArrayOfPostingInfo = New Array();
		For Each DataTable In PostingDataTables Do
			ArrayOfPostingInfo.Add(DataTable);
		EndDo;
		
		CurrenciesParameters = New Structure();
		CurrenciesParameters.Insert("Object", Row.Document);
		CurrenciesParameters.Insert("Metadata", Row.Document.Metadata());
		CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
		CurrenciesParameters.Insert("IsOffsetOfAdvances", CommonFunctionsClientServer.GetFromAddInfo(Parameters, "IsOffsetOfAdvances", False));
		CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, CurrencyTable);

		// Advances
		ItemOfPostingInfo = GetFromPostingInfo(ArrayOfPostingInfo, Metadata.AccumulationRegisters[Parameters.RegisterName_Advances]);

		RecordSet_Advances.Read();
		For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
			FillPropertyValues(RecordSet_Advances.Add(), RowPostingInfo);
		EndDo;
		RecordSet_Advances.SetActive(True);
		RecordSet_Advances.Write();
				
		CurrenciesServer.RevaluateCurrency_Advances(Parameters, 
					                                RecordSet_Advances, 
					                                TableTransactions_CurrencyRevaluation,
					                                TableAccountingAmounts_CurrencyRevaluation,
					                                Records_AdvancesCurrencyRevaluation);				
					                                            
		RecordSet_Advances.SetActive(True);
		RecordSet_Advances.Write();
					
		// Transactions					
		ItemOfPostingInfo = GetFromPostingInfo(ArrayOfPostingInfo, Metadata.AccumulationRegisters[Parameters.RegisterName_Transactions]);
			
		RecordSet_Transactions.Read();
		For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
			FillPropertyValues(RecordSet_Transactions.Add(), RowPostingInfo);
		EndDo;
		RecordSet_Transactions.SetActive(True);
		RecordSet_Transactions.Write();
						
		CurrenciesServer.RevaluateCurrency_Transactions(Parameters, 
						                                RecordSet_Transactions,
						                                TableTransactions_CurrencyRevaluation, 
						                                TableAccountingAmounts_CurrencyRevaluation,
						                                Records_TransactionsCurrencyRevaluation);
						                                                 
		RecordSet_Transactions.SetActive(True);
		RecordSet_Transactions.Write();
					
		ItemOfPostingInfo = GetFromPostingInfo(ArrayOfPostingInfo, Metadata.AccumulationRegisters.T1040T_AccountingAmounts);
			
		// Accounting amounts (advances)
		RecordSet_AccountingAmounts.Read();
		For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
			FillPropertyValues(RecordSet_AccountingAmounts.Add(), RowPostingInfo);
		EndDo;
		RecordSet_AccountingAmounts.SetActive(True);
		RecordSet_AccountingAmounts.Write();
		
		// Accounting amounts (currency revaluation)
		If TableAccountingAmounts_CurrencyRevaluation.Count() Then
			RecordSet_AccountingAmounts.Read();
			For Each RowTableAccountingAmounts_CurrencyRevaluation In TableAccountingAmounts_CurrencyRevaluation Do
				FillPropertyValues(RecordSet_AccountingAmounts.Add(), RowTableAccountingAmounts_CurrencyRevaluation);
			EndDo;
			RecordSet_AccountingAmounts.SetActive(True);
			RecordSet_AccountingAmounts.Write();
		EndIf;
		
	EndDo;
EndProcedure

Function GetFromPostingInfo(ArrayOfPostingInfo, RecordSetType)
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If ItemOfPostingInfo.Key = RecordSetType Then
			Return ItemOfPostingInfo;
		EndIf;
	EndDo;
	Raise StrTemplate("Not found [%1] in array of posting info", RecordSetType);
EndFunction

Procedure WriteTablesToTempTables(Parameters, 
	                              Records_OffsetOfAdvances, 
	                              Records_OffsetAging,
	                              Records_AdvancesCurrencyRevaluation,
	                              Records_TransactionsCurrencyRevaluation)
	                              
	Query = New Query;
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
	|	Records_OffsetOfAdvances.TransactionAgreement,
	|	Records_OffsetOfAdvances.AdvanceAgreement,
	|	Records_OffsetOfAdvances.AdvanceDocument,
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
	|///////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records_AdvancesCurrencyRevaluation.Period,
	|	Records_AdvancesCurrencyRevaluation.Document,
	|	Records_AdvancesCurrencyRevaluation.Company,
	|	Records_AdvancesCurrencyRevaluation.Branch,
	|	Records_AdvancesCurrencyRevaluation.CurrencyMovementType,
	|	Records_AdvancesCurrencyRevaluation.Currency,
	|	Records_AdvancesCurrencyRevaluation.TransactionCurrency,
	|	Records_AdvancesCurrencyRevaluation.Partner,
	|	Records_AdvancesCurrencyRevaluation.LegalName,
	|	Records_AdvancesCurrencyRevaluation.AdvancesOrder,
	|	Records_AdvancesCurrencyRevaluation.Amount
	|INTO tmpRecords_AdvancesCurrencyRevaluation
	|FROM
	|	&Records_AdvancesCurrencyRevaluation AS Records_AdvancesCurrencyRevaluation
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records_TransactionsCurrencyRevaluation.Period,
	|	Records_TransactionsCurrencyRevaluation.Document,
	|	Records_TransactionsCurrencyRevaluation.Company,
	|	Records_TransactionsCurrencyRevaluation.Branch,
	|	Records_TransactionsCurrencyRevaluation.CurrencyMovementType,
	|	Records_TransactionsCurrencyRevaluation.Currency,
	|	Records_TransactionsCurrencyRevaluation.TransactionCurrency,
	|	Records_TransactionsCurrencyRevaluation.Partner,
	|	Records_TransactionsCurrencyRevaluation.LegalName,
	|	Records_TransactionsCurrencyRevaluation.Agreement,
	|	Records_TransactionsCurrencyRevaluation.TransactionOrder,
	|	Records_TransactionsCurrencyRevaluation.TransactionDocument,
	|	Records_TransactionsCurrencyRevaluation.Amount
	|INTO tmpRecords_TransactionsCurrencyRevaluation
	|FROM
	|	&Records_TransactionsCurrencyRevaluation AS Records_TransactionsCurrencyRevaluation
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
	|	tmpRecords_OffsetOfAdvances.TransactionAgreement,
	|	tmpRecords_OffsetOfAdvances.AdvanceAgreement,
	|	tmpRecords_OffsetOfAdvances.AdvanceDocument,
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
	|	tmpRecords_OffsetOfAdvances.TransactionAgreement,
	|	tmpRecords_OffsetOfAdvances.AdvanceAgreement,
	|	tmpRecords_OffsetOfAdvances.AdvanceDocument,
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
	|	tmpRecords_OffsetAging.PaymentDate
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRecords_AdvancesCurrencyRevaluation.Period,
	|	tmpRecords_AdvancesCurrencyRevaluation.Document,
	|	tmpRecords_AdvancesCurrencyRevaluation.Company,
	|	tmpRecords_AdvancesCurrencyRevaluation.Branch,
	|	tmpRecords_AdvancesCurrencyRevaluation.CurrencyMovementType,
	|	tmpRecords_AdvancesCurrencyRevaluation.Currency,
	|	tmpRecords_AdvancesCurrencyRevaluation.TransactionCurrency,
	|	tmpRecords_AdvancesCurrencyRevaluation.Partner,
	|	tmpRecords_AdvancesCurrencyRevaluation.LegalName,
	|	tmpRecords_AdvancesCurrencyRevaluation.AdvancesOrder,
	|	SUM(tmpRecords_AdvancesCurrencyRevaluation.Amount) AS Amount
	|INTO Records_AdvancesCurrencyRevaluation
	|FROM
	|	tmpRecords_AdvancesCurrencyRevaluation AS tmpRecords_AdvancesCurrencyRevaluation
	|GROUP BY
	|	tmpRecords_AdvancesCurrencyRevaluation.Period,
	|	tmpRecords_AdvancesCurrencyRevaluation.Document,
	|	tmpRecords_AdvancesCurrencyRevaluation.Company,
	|	tmpRecords_AdvancesCurrencyRevaluation.Branch,
	|	tmpRecords_AdvancesCurrencyRevaluation.CurrencyMovementType,
	|	tmpRecords_AdvancesCurrencyRevaluation.Currency,
	|	tmpRecords_AdvancesCurrencyRevaluation.TransactionCurrency,
	|	tmpRecords_AdvancesCurrencyRevaluation.Partner,
	|	tmpRecords_AdvancesCurrencyRevaluation.LegalName,
	|	tmpRecords_AdvancesCurrencyRevaluation.AdvancesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRecords_TransactionsCurrencyRevaluation.Period,
	|	tmpRecords_TransactionsCurrencyRevaluation.Document,
	|	tmpRecords_TransactionsCurrencyRevaluation.Company,
	|	tmpRecords_TransactionsCurrencyRevaluation.Branch,
	|	tmpRecords_TransactionsCurrencyRevaluation.CurrencyMovementType,
	|	tmpRecords_TransactionsCurrencyRevaluation.Currency,
	|	tmpRecords_TransactionsCurrencyRevaluation.TransactionCurrency,
	|	tmpRecords_TransactionsCurrencyRevaluation.Partner,
	|	tmpRecords_TransactionsCurrencyRevaluation.LegalName,
	|	tmpRecords_TransactionsCurrencyRevaluation.Agreement,
	|	tmpRecords_TransactionsCurrencyRevaluation.TransactionOrder,
	|	tmpRecords_TransactionsCurrencyRevaluation.TransactionDocument,
	|	SUM(tmpRecords_TransactionsCurrencyRevaluation.Amount) AS Amount
	|INTO Records_TransactionsCurrencyRevaluation
	|FROM
	|	tmpRecords_TransactionsCurrencyRevaluation AS tmpRecords_TransactionsCurrencyRevaluation
	|GROUP BY
	|	tmpRecords_TransactionsCurrencyRevaluation.Period,
	|	tmpRecords_TransactionsCurrencyRevaluation.Document,
	|	tmpRecords_TransactionsCurrencyRevaluation.Company,
	|	tmpRecords_TransactionsCurrencyRevaluation.Branch,
	|	tmpRecords_TransactionsCurrencyRevaluation.CurrencyMovementType,
	|	tmpRecords_TransactionsCurrencyRevaluation.Currency,
	|	tmpRecords_TransactionsCurrencyRevaluation.TransactionCurrency,
	|	tmpRecords_TransactionsCurrencyRevaluation.Partner,
	|	tmpRecords_TransactionsCurrencyRevaluation.LegalName,
	|	tmpRecords_TransactionsCurrencyRevaluation.Agreement,
	|	tmpRecords_TransactionsCurrencyRevaluation.TransactionOrder,
	|	tmpRecords_TransactionsCurrencyRevaluation.TransactionDocument";

	Query.SetParameter("Records_OffsetOfAdvances" , Records_OffsetOfAdvances);
	Query.SetParameter("Records_OffsetAging"      , Records_OffsetAging);
	Query.SetParameter("Records_AdvancesCurrencyRevaluation"     , Records_AdvancesCurrencyRevaluation);
	Query.SetParameter("Records_TransactionsCurrencyRevaluation" , Records_TransactionsCurrencyRevaluation);
	Query.Execute();
EndProcedure

Function ReleaseAdvanceByOrder(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Document, Date, AdvanceKey)
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	Query = New Query;
	Query.Text =
	"SELECT
	|	AdvancesBalance.AdvanceKey,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, AdvanceKey = &AdvanceKey AND AdvanceKey.%1) AS AdvancesBalance
	|
	|ORDER BY
	|	AdvancesBalance.AdvanceKey.AdvanceDocument.Date";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Point = New PointInTime(Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary" , Boundary);
	Query.SetParameter("AdvanceKey"      , AdvanceKey);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	AdvanceKeyWithoutOrder = GetAdvanceKeyByAdvanceKeyWithoutOrder(Parameters, AdvanceKey);
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
		New_AdvKeys_Minus.AdvanceKey = AdvanceKey; //key with order
		New_AdvKeys_Minus.Amount     = -QuerySelection.AdvanceAmount;
		
		// Plus by advance without order
		New_AdvKeys_Minus = Records_AdvancesKey.Add();
		New_AdvKeys_Minus.RecordType = AccumulationRecordType.Receipt;
		New_AdvKeys_Minus.Period     = Date;
		AdvanceKey_WithoutOrder      = AdvanceKeyWithoutOrder;
		New_AdvKeys_Minus.AdvanceKey = AdvanceKey_WithoutOrder; //key without order
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
		NewOffsetInfo.AdvanceAgreement = AdvanceKey.AdvanceAgreement;
		NewOffsetInfo.AdvanceDocument  = AdvanceKey.AdvanceDocument;
		
		// OffsetOfAdvances - plus without order (record type expense)
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.IsAdvanceRelease = True;
		NewOffsetInfo.Period       = Date;
		NewOffsetInfo.Amount       = -QuerySelection.AdvanceAmount;
		NewOffsetInfo.Document     = Document;
		NewOffsetInfo.Company      = AdvanceKey.Company;
		NewOffsetInfo.Branch       = AdvanceKey.Branch;
		NewOffsetInfo.Currency     = AdvanceKey.Currency;
		NewOffsetInfo.Partner      = AdvanceKey.Partner;
		NewOffsetInfo.LegalName    = AdvanceKey.LegalName;
		NewOffsetInfo.AdvanceAgreement = AdvanceKey.AdvanceAgreement;
		NewOffsetInfo.AdvanceDocument  = AdvanceKey.AdvanceDocument;
	EndDo;
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
	Return AdvanceKeyWithoutOrder;
EndFunction

Function GetAdvanceKeyByAdvanceKeyWithoutOrder(Parameters, AdvanceKey)
	Query = New Query;
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
	|	AND &AdvanceAgreement = AdvKeys.AdvanceAgreement
	|	AND &AdvanceDocument = AdvKeys.AdvanceDocument
	|	AND AdvKeys.Order.Ref IS NULL
	|	AND AdvKeys.%1";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);
	Query.SetParameter("AdvanceAgreement", AdvanceKey.AdvanceAgreement);
	Query.SetParameter("AdvanceDocument" , AdvanceKey.AdvanceDocument);

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
		KeyObject.AdvanceAgreement = AdvanceKey.AdvanceAgreement;
		KeyObject.AdvanceDocument  = AdvanceKey.AdvanceDocument;
		KeyObject.IsCustomerAdvance = AdvanceKey.IsCustomerAdvance;
		KeyObject.IsVendorAdvance   = AdvanceKey.IsVendorAdvance;
		KeyObject.Order = Undefined; // without Order
		KeyObject.Description = Left(String(New UUID), 8);
		KeyObject.Write();
		KeyRef = KeyObject.Ref;
	EndIf;
	Return KeyRef;
EndFunction

Procedure CreateAdvancesKeys(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Table_DocumentAndAdvancesKey)
	Query = New Query;
	Query.Text =
	"SELECT
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.AdvanceAgreement,
	|	case when AdvInfo.AdvanceDocument.Ref IS NULL then UNDEFINED else AdvInfo.AdvanceDocument end AS AdvanceDocument,
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
	|	AND AdvInfo.%1
	|GROUP BY
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.AdvanceAgreement,
	|	case when AdvInfo.AdvanceDocument.Ref IS NULL then UNDEFINED else AdvInfo.AdvanceDocument end,
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
	|	tmp_AdvInfo.AdvanceAgreement,
	|	tmp_AdvInfo.AdvanceDocument,
	|	TRUE AS %1
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
	|		AND tmp_AdvInfo.AdvanceAgreement = AdvKeys.AdvanceAgreement
	|
	|		AND case when tmp_AdvInfo.AdvanceDocument.Ref IS NULL then true else
	|       CASE
	|			WHEN tmp_AdvInfo.AdvanceDocument.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_AdvInfo.AdvanceDocument
	|		END = CASE
	|			WHEN AdvKeys.AdvanceDocument.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE AdvKeys.AdvanceDocument
	|		END end
	|
	|		AND AdvKeys.%1
	|GROUP BY
	|	tmp_AdvInfo.Branch,
	|	tmp_AdvInfo.Company,
	|	tmp_AdvInfo.Currency,
	|	tmp_AdvInfo.Partner,
	|	tmp_AdvInfo.LegalName,
	|	tmp_AdvInfo.AdvanceAgreement,
	|	tmp_AdvInfo.AdvanceDocument,
	|	tmp_AdvInfo.Order";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Query.SetParameter("BeginOfPeriod" , Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"   , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"       , Parameters.Object.Company);
	Query.SetParameter("Branch"        , Parameters.Object.Branch);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.AdvanceKey) Then // Create
			KeyObject = Catalogs.AdvancesKeys.CreateItem();
			FillPropertyValues(KeyObject, QuerySelection);
			KeyObject.Description = Left(String(New UUID), 8);
			KeyObject.Write();
		EndIf;
	EndDo;

	Query = New Query;
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
	|	AdvInfo.AdvanceAgreement,
	|	case when AdvInfo.AdvanceDocument.Ref IS NULL then UNDEFINED else AdvInfo.AdvanceDocument end AS AdvanceDocument,
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvInfo.Order
	|	END AS Order,
	|	AdvInfo.%1
	|INTO tmp_AdvInfo
	|FROM
	|	InformationRegister.T2014S_AdvancesInfo AS AdvInfo
	|WHERE
	|	AdvInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND AdvInfo.Company = &Company
	|	AND AdvInfo.Branch = &Branch
	|	AND AdvInfo.%2
	|GROUP BY
	|	AdvInfo.Date,
	|	AdvInfo.Amount,
	|	AdvInfo.Key,
	|	AdvInfo.Company,
	|	AdvInfo.Branch,
	|	AdvInfo.Currency,
	|	AdvInfo.Partner,
	|	AdvInfo.LegalName,
	|	AdvInfo.AdvanceAgreement,
	|	case when AdvInfo.AdvanceDocument.Ref IS NULL then UNDEFINED else AdvInfo.AdvanceDocument end,
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvInfo.Order
	|	END,
	|	AdvInfo.Recorder,
	|	AdvInfo.%1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_AdvInfo.Document,
	|	tmp_AdvInfo.Date,
	|	tmp_AdvInfo.Amount,
	|	tmp_AdvInfo.Key,
	|	tmp_AdvInfo.%1,
	|	AdvKeys.Ref AS AdvanceKey
	|FROM
	|	tmp_AdvInfo AS tmp_AdvInfo
	|		LEFT JOIN Catalog.AdvancesKeys AS AdvKeys
	|		ON NOT AdvKeys.DeletionMark
	|		AND tmp_AdvInfo.Company = AdvKeys.Company
	|		AND tmp_AdvInfo.Branch = AdvKeys.Branch
	|		AND tmp_AdvInfo.Currency = AdvKeys.Currency
	|		AND tmp_AdvInfo.Partner = AdvKeys.Partner
	|		AND tmp_AdvInfo.LegalName = AdvKeys.LegalName
	|		AND tmp_AdvInfo.AdvanceAgreement = AdvKeys.AdvanceAgreement
	|		AND CASE
	|			WHEN tmp_AdvInfo.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_AdvInfo.Order
	|		END = CASE
	|			WHEN AdvKeys.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE AdvKeys.Order
	|		END
	|
	|	    AND case when tmp_AdvInfo.AdvanceDocument.Ref IS NULL then true else
	|		CASE
	|			WHEN tmp_AdvInfo.AdvanceDocument.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_AdvInfo.AdvanceDocument
	|		END = CASE
	|			WHEN AdvKeys.AdvanceDocument.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE AdvKeys.AdvanceDocument
	|		END end
	|
	|		AND AdvKeys.%2";
 
    Query.Text = StrTemplate(Query.Text, Parameters.OrderCloseType, Parameters.AdvanceType);
	
	Query.SetParameter("BeginOfPeriod" , Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"   , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"       , Parameters.Object.Company);
	Query.SetParameter("Branch"        , Parameters.Object.Branch);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		If Not QuerySelection[Parameters.OrderCloseType] Then
			New_AdvKeys = Records_AdvancesKey.Add();
			New_AdvKeys.RecordType = AccumulationRecordType.Receipt;
			New_AdvKeys.Period     = QuerySelection.Date;
			New_AdvKeys.AdvanceKey = QuerySelection.AdvanceKey;
			New_AdvKeys.Amount     = QuerySelection.Amount;
		EndIf;

		New_DocKeys = Table_DocumentAndAdvancesKey.Add();
		New_DocKeys.Document   = QuerySelection.Document;
		New_DocKeys.AdvanceKey = QuerySelection.AdvanceKey;
		New_DocKeys.Amount     = QuerySelection.Amount;
	EndDo;
EndProcedure

Procedure CreateTransactionsKeys(Parameters, Records_TransactionsKey, Records_OffsetAging, Table_DocumentAndTransactionsKey)
	Query = New Query;
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
	|	AND TrnInfo.%1
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
	|	TRUE AS %1
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
	|		AND TrnKeys.%1
	|GROUP BY
	|	tmp_TrnInfo.Company,
	|	tmp_TrnInfo.Branch,
	|	tmp_TrnInfo.Currency,
	|	tmp_TrnInfo.Partner,
	|	tmp_TrnInfo.LegalName,
	|	tmp_TrnInfo.Agreement,
	|	tmp_TrnInfo.Order,
	|	tmp_TrnInfo.TransactionBasis";

	Query.Text = StrTemplate(Query.Text, Parameters.TransactionType);
	
	Query.SetParameter("BeginOfPeriod" , Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"   , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"       , Parameters.Object.Company);
	Query.SetParameter("Branch"        , Parameters.Object.Branch);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		If Not ValueIsFilled(QuerySelection.TransactionKey) Then // Create
			KeyObject = Catalogs.TransactionsKeys.CreateItem();
			FillPropertyValues(KeyObject, QuerySelection);
			KeyObject.Description = Left(String(New UUID), 8);
			KeyObject.Write();
		EndIf;
	EndDo;
	Query = New Query;
	Query.Text =
	"SELECT
	|	TrnInfo.Date,
	|	TrnInfo.Recorder AS Document,
	|	TrnInfo.Amount AS Amount,
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
	|	AND TrnInfo.%1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TrnKeys.Ref AS TransactionKey,
	|	tmp_TrnInfo.Document,
	|	tmp_TrnInfo.Date,
	|	tmp_TrnInfo.Company,
	|	tmp_TrnInfo.Amount AS Amount,
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
	|		AND TrnKeys.%1";

	Query.Text = StrTemplate(Query.Text, Parameters.TransactionType);
	
	Query.SetParameter("BeginOfPeriod" , Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"   , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"       , Parameters.Object.Company);
	Query.SetParameter("Branch"        , Parameters.Object.Branch);

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
		
		// Paid from customer or to vendor 
		If QuerySelection.IsPaid Then
			DistributeTransactionToAging(Parameters, 
										 QuerySelection.Document.PointInTime(), 
										 QuerySelection.Document,
										 QuerySelection.TransactionKey, 
										 QuerySelection.Amount, 
										 Records_OffsetAging);
		EndIf;
	EndDo;
EndProcedure

Procedure DistributeTransactionToAging(Parameters, PointInTime, Document, TransactionKey, TransactionAmount, Records_OffsetAging)
	Query = New Query;
	Query.Text =
	"SELECT
	|	RegAging.PaymentDate,
	|	RegAging.AmountBalance AS PaymentAmount
	|FROM
	|	AccumulationRegister.%1.Balance(&TransactionBoundary, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Agreement = &Agreement
	|	AND Partner = &Partner
	|	AND Invoice = &TransactionBasis) AS RegAging";

	Query.Text = StrTemplate(Query.Text, Parameters.RegisterName_Aging);
	
	Boundary = New Boundary(PointInTime, BoundaryType.Including);
	Query.SetParameter("TransactionBoundary", Boundary);

	Query.SetParameter("Company"         , TransactionKey.Company);
	Query.SetParameter("Branch"          , TransactionKey.Branch);
	Query.SetParameter("Currency"        , TransactionKey.Currency);
	Query.SetParameter("Agreement"       , TransactionKey.Agreement);
	Query.SetParameter("Partner"         , TransactionKey.Partner);
	Query.SetParameter("TransactionBasis", TransactionKey.TransactionBasis);

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
		Write_Aging(Parameters, Document, Records_OffsetAging);
	EndIf;
EndProcedure

Procedure Write_Aging(Parameters, Document, Records_OffsetAging)
	RecordSet_Aging = AccumulationRegisters[Parameters.RegisterName_Aging].CreateRecordSet();
	RecordSet_Aging.Filter.Recorder.Set(Document);
	RecordSet_Aging.Read();
	ArrayForDelete = New Array;
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

Procedure Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey)
	RecordSet = AccumulationRegisters.TM1020B_AdvancesKey.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(Parameters.Object.Ref);
	RecordSet.Load(Records_AdvancesKey);
	RecordSet.SetActive(True);
	RecordSet.Write();
EndProcedure

Procedure Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey)
	RecordSet = AccumulationRegisters.TM1030B_TransactionsKey.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(Parameters.Object.Ref);
	RecordSet.Load(Records_TransactionsKey);
	RecordSet.SetActive(True);
	RecordSet.Write();
EndProcedure

Procedure Clear_SelfRecords(Parameters)
	Query = New Query;
	Query.Text =
	"SELECT
	|	%1.Recorder
	|FROM
	|	AccumulationRegister.%1 AS %1
	|WHERE
	|	%1.%4 = &Ref
	|GROUP BY
	|	%1.Recorder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	%2.Recorder
	|FROM
	|	AccumulationRegister.%2 AS %2
	|WHERE
	|	%2.%4 = &Ref
	|GROUP BY
	|	%2.Recorder
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	%3.Recorder
	|FROM
	|	AccumulationRegister.%3 AS %3
	|WHERE
	|	%3.AgingClosing = &Ref
	|GROUP BY
	|	%3.Recorder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T1040T_AccountingAmounts.Recorder
	|FROM
	|	AccumulationRegister.T1040T_AccountingAmounts AS T1040T_AccountingAmounts
	|WHERE
	|	T1040T_AccountingAmounts.AdvancesClosing = &Ref
	|GROUP BY
	|	T1040T_AccountingAmounts.Recorder";
	
	Query.Text = StrTemplate(Query.Text, 
	                         Parameters.RegisterName_Advances,
	                         Parameters.RegisterName_Transactions,
	                         Parameters.RegisterName_Aging,
	                         Parameters.DocumentName);
		
	Ref = Parameters.Object.Ref;
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();

	ClearRegisterRecords(Ref, QueryResults[0].Unload(), Parameters.RegisterName_Advances     , Parameters.DocumentName);
	ClearRegisterRecords(Ref, QueryResults[1].Unload(), Parameters.RegisterName_Transactions , Parameters.DocumentName);
	ClearRegisterRecords(Ref, QueryResults[2].Unload(), Parameters.RegisterName_Aging        , "AgingClosing");
	ClearRegisterRecords(Ref, QueryResults[3].Unload(), "T1040T_AccountingAmounts"           , "AdvancesClosing");
EndProcedure

Procedure ClearRegisterRecords(DocRef, TableOfRecorders, RegisterName, AttrName)
	For Each Row In TableOfRecorders Do
		RecordSet = AccumulationRegisters[RegisterName].CreateRecordSet();
		RecordSet.Filter.Recorder.Set(Row.Recorder);
		RecordSet.Read();
		ArrayForDelete = New Array;
		For Each Record In RecordSet Do
			If Record[AttrName] = DocRef Then
				ArrayForDelete.Add(Record);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure

Function AdvancesClosingQueryText(Parameters)
	Return 
		StrTemplate("SELECT *
		   |INTO OffsetOfAdvancesEmpty
		   |FROM
		   |	Document.%1 AS OffsetOfAdvance
		   |WHERE
		   |	FALSE", Parameters.DocumentName);
EndFunction
