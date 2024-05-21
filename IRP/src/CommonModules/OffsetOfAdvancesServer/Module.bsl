
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
	Records_OffsetOfAdvances.Columns.Add("IsReturnToAdvance" , New TypeDescription("Boolean"));
	
		
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
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocTrn.Document,
	|	DocTrn.TransactionKey
	|INTO tmp_DocTrn
	|FROM
	|	&DocTrn AS DocTrn
	|;
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
	|
	|ORDER BY
	|	PointInTime";
			
	Query.SetParameter("DocAdv", Table_DocumentAndAdvancesKey);
	Query.SetParameter("DocTrn", Table_DocumentAndTransactionsKey);
	Query.SetParameter("Records_AdvancesKey"     , Records_AdvancesKey);
	Query.SetParameter("Records_TransactionsKey" , Records_TransactionsKey);

	QueryResults = Query.ExecuteBatch();
		
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
		If QuerySelection.AdvanceAmount < 0 Then
			
			ReturnMoneyByTransaction(Parameters, 
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
		Else
		
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
		EndIf;
	EndDo;
	
	// Write ofsetted advances to TM1020B_AdvancesKey, Expense
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
    
EndProcedure

Procedure ReturnMoneyByTransaction(Parameters,
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
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Transactions.TransactionKey AS TransactionKey,
	|	Transactions.Amount AS Amount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey AS Transactions
	|WHERE
	|	Transactions.Period <= &Period
	|	AND Transactions.TransactionKey.Company = &Company
	|	AND Transactions.TransactionKey.Branch = &Branch
	|	AND Transactions.TransactionKey.Currency = &Currency
	|	AND Transactions.TransactionKey.Partner = &Partner
	|	AND Transactions.TransactionKey.LegalName = &LegalName
	|	AND (Transactions.RecordType = VALUE(AccumulationRecordType.Receipt)
	|	AND Transactions.Amount > 0
	|	OR Transactions.RecordType = VALUE(AccumulationRecordType.Expense)
	|	AND Transactions.Amount < 0)
	|
	|ORDER BY
	|	Transactions.Period DESC";
	
	Query.SetParameter("Period", PointInTime.Date);
	
	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteoff = -AdvanceAmount;
	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
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
		
		// advance by Project
		If ProjectsNotMatch(Parameters, AdvanceKey.Project, QuerySelection.TransactionKey.Project) Then
			Continue;
		EndIf;
		
		CanWriteoff = Min(QuerySelection.Amount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		// Transactions
		Add_TM1030B_TransactionsKey(AccumulationRecordType.Receipt, 
		                            Document.Date, 
		                            QuerySelection.TransactionKey, 
		                            CanWriteOff, 
		                            Records_TransactionsKey);		
		NeedWriteTransactions = True;
		
		// Advances
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Receipt, 
		                        Document.Date, 
		                        AdvanceKey, 
		                        CanWriteoff, 
		                        Records_AdvancesKey);
		NeedWriteAdvances = True;
			
		// Aging
		ReturnMoneyByAging(Parameters, Document, QuerySelection.TransactionKey, CanWriteoff, Records_OffsetAging);	
			
		Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, Enums.RecordType.Receipt,
		                                                      Document.Date, 
		                                                      CanWriteoff, 
		                                                      Document, 
		                                                      AdvanceKey, 
		                                                      QuerySelection.TransactionKey, 
		                                                      Records_OffsetOfAdvances);		
	EndDo;
	
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
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
			Add_TM1030B_TransactionsKey(AccumulationRecordType.Expense, 
		                                Document.Date, 
		                                QuerySelection.TransactionKey, 
		                                QuerySelection.TransactionAmount, 
		                                Records_TransactionsKey);	
		                                
		    Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);	
					
			// Advances
			Add_TM1020B_AdvancesKey(AccumulationRecordType.Expense, 
		                            Document.Date, 
		                            AdvanceKey, 
		                            QuerySelection.TransactionAmount, 
		                            Records_AdvancesKey);
				
			// OffsetOfAdvances
			Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, Enums.RecordType.Expense,
		                                                          Document.Date, 
		                                                          QuerySelection.TransactionAmount, 
		                                                          Document, 
		                                                          AdvanceKey, 
		                                                          QuerySelection.TransactionKey, 
		                                                          Records_OffsetOfAdvances);
			
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
		
		If ProjectsNotMatch(Parameters, AdvanceKey.Project, QuerySelection.TransactionKey.Project) Then
			Continue;
		EndIf;
				
		CanWriteoff = Min(QuerySelection.TransactionAmount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		// Transactions
		Add_TM1030B_TransactionsKey(AccumulationRecordType.Expense, 
		                            Document.Date, 
		                            QuerySelection.TransactionKey, 
		                            CanWriteoff, 
		                            Records_TransactionsKey);		
		NeedWriteTransactions = True;
		
		// Advances
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Expense, 
		                        Document.Date, 
		                        AdvanceKey, 
		                        CanWriteoff, 
		                        Records_AdvancesKey);
		NeedWriteAdvances = True;

		// OffsetOfAdvances
		Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, Enums.RecordType.Expense,
		                                                      Document.Date, 
		                                                      CanWriteoff, 
		                                                      Document, 
		                                                      AdvanceKey, 
		                                                      QuerySelection.TransactionKey, 
		                                                      Records_OffsetOfAdvances);

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
		If QuerySelection.TransactionAmount < 0 And Not Parameters.DontWriteNegativeDebtAsAdvance Then
			// Return due to advance, change advance balance
			
			AdvanceKey = GetAdvanceKeyByTransactionKey(Parameters, TransactionKey);
			
			// Transactions
			Add_TM1030B_TransactionsKey(AccumulationRecordType.Expense, 
		                                Document.Date, 
		                                TransactionKey, 
		                                QuerySelection.TransactionAmount, 
		                                Records_TransactionsKey);
		                                
		    Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);		
						
			// Advances
			Add_TM1020B_AdvancesKey(AccumulationRecordType.Expense, 
		                            Document.Date, 
		                            AdvanceKey, 
		                            QuerySelection.TransactionAmount, 
		                            Records_AdvancesKey);
		                            
		    Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
						
		   // OffsetOfAdvances
		   Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, Enums.RecordType.Expense,
		                                                         Document.Date, 
		                                                         QuerySelection.TransactionAmount, 
		                                                         Document, 
		                                                         AdvanceKey, 
		                                                         TransactionKey, 
		                                                         Records_OffsetOfAdvances, True);
			
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
	|	and T2014S_AdvancesInfo.Project = &Project
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
	Query.SetParameter("Order_EmptyRef", Parameters.Order_EmptyRef);
	Query.SetParameter("AdvanceAgreement", AdvanceKey.AdvanceAgreement);
	Query.SetParameter("Project", AdvanceKey.Project);

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

Function GetAdvanceKeyByTransactionKey(Parameters, TransactionKey)
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
	|	AND &Project = AdvKeys.Project
	|	AND &Order = CASE
	|		WHEN AdvKeys.Order.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE AdvKeys.Order
	|	END
	|	AND AdvKeys.%1";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);

	Query.SetParameter("Company"   , TransactionKey.Company);
	Query.SetParameter("Branch"    , TransactionKey.Branch);
	Query.SetParameter("Currency"  , TransactionKey.Currency);
	Query.SetParameter("Partner"   , TransactionKey.Partner);
	Query.SetParameter("LegalName" , TransactionKey.LegalName);
	Query.SetParameter("AdvanceAgreement" , TransactionKey.Agreement);
	Query.SetParameter("Project" , TransactionKey.Project);
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
		KeyObject.Project = TransactionKey.Project;
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
		
		If ProjectsNotMatch(Parameters, QuerySelection.AdvanceKey.Project, TransactionKey.Project) Then
			Continue;
		EndIf;
				
		CanWriteoff = Min(QuerySelection.AdvanceAmount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
				
		// Transactions
		Add_TM1030B_TransactionsKey(AccumulationRecordType.Expense, 
		                            Document.Date, 
		                            TransactionKey, 
		                            CanWriteoff, 
		                            Records_TransactionsKey);			
		NeedWriteTransactions = True;
		
		// Advances
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Expense, 
		                        Document.Date, 
		                        QuerySelection.AdvanceKey, 
		                        CanWriteoff, 
		                        Records_AdvancesKey);		
		NeedWriteAdvances = True;
		
		// OffsetOfAdvances
		Add_T2010S_OffsetOfAdvances_FromAdvance_ToTransaction(Parameters, Enums.RecordType.Expense,
		                                                      Document.Date, 
		                                                      CanWriteoff,
		                                                      Document, 
		                                                      QuerySelection.AdvanceKey, 
		                                                      TransactionKey, 
		                                                      Records_OffsetOfAdvances);
		
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

	ArrayOfDocuments_UseKeyForCurrency = New Array();
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.BankPayment);
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.BankReceipt);
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.CashPayment);
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.CashReceipt);
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.CreditNote);
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.DebitCreditNote);
	ArrayOfDocuments_UseKeyForCurrency.Add(Metadata.Documents.OpeningEntry);

	IsCustomerAdvanceClosing = Parameters.Object.Ref.Metadata() = Metadata.Documents.CustomersAdvancesClosing;
	IsVendorAdvanceClosing = Parameters.Object.Ref.Metadata() = Metadata.Documents.VendorsAdvancesClosing;
	
	For Each Row In Recorders Do
		
		DocMetadata = Row.Document.Metadata();
		
		UseKeyForCurrency = ArrayOfDocuments_UseKeyForCurrency.Find(DocMetadata) <> Undefined;

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

		// Partners balance
		RecordSet_PartnersBalance = AccumulationRegisters.R5020B_PartnersBalance.CreateRecordSet();
		RecordSet_PartnersBalance.Filter.Recorder.Set(Row.Document);
		TablePartnersBalance = RecordSet_PartnersBalance.UnloadColumns();
		TablePartnersBalance.Columns.Delete(TablePartnersBalance.Columns.PointInTime);
		
		If UseKeyForCurrency Then
			TableAdvances.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
			TableTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
			TableAccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
			TablePartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
		EndIf;

		OffsetInfoByDocument = Records_OffsetOfAdvances.Copy(New Structure("Document", Row.Document));

		For Each RowOffset In OffsetInfoByDocument Do
								
			// Advances
			NewRow_Advances = TableAdvances.Add();
			FillPropertyValues(NewRow_Advances, RowOffset);
			
			If RowOffset.RecordType = Enums.RecordType.Receipt Then
				NewRow_Advances.RecordType = AccumulationRecordType.Receipt;
			Else
				NewRow_Advances.RecordType = AccumulationRecordType.Expense;
			EndIf;
			
			NewRow_Advances[Parameters.DocumentName] = Parameters.Object.Ref;
			NewRow_Advances.Order     = RowOffset.AdvanceOrder;
			NewRow_Advances.Project   = RowOffset.AdvanceProject;
			NewRow_Advances.Agreement = RowOffset.AdvanceAgreement;
			
			// Partner balance - advances
			NewRow_PartnerBalance_Advances = TablePartnersBalance.Add();
			
			If DocMetadata = Metadata.Documents.BankReceipt
				Or (DocMetadata = Metadata.Documents.DebitCreditNote And Row.Document.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer) 
				Or DocMetadata = Metadata.Documents.CashReceipt
				Or DocMetadata = Metadata.Documents.SalesReportFromTradeAgent
				Or DocMetadata = Metadata.Documents.SalesInvoice
				Or (DocMetadata = Metadata.Documents.DebitCreditNote And Row.Document.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer)
				Or (DocMetadata = Metadata.Documents.DebitNote And IsCustomerAdvanceClosing)
				Or (DocMetadata = Metadata.Documents.SalesReturn And Not RowOffset.IsReturnToAdvance)
				Or (DocMetadata = Metadata.Documents.CreditNote And Not RowOffset.IsReturnToAdvance And IsCustomerAdvanceClosing)
				Or (DocMetadata = Metadata.Documents.PurchaseReturn And RowOffset.IsReturnToAdvance)
				Or (DocMetadata = Metadata.Documents.DebitNote And RowOffset.IsReturnToAdvance And IsVendorAdvanceClosing)
				Or (DocMetadata = Metadata.Documents.OpeningEntry  And IsCustomerAdvanceClosing)
				Or (DocMetadata = Metadata.Documents.BankPayment And 
					Row.Document.TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer)
				Or (DocMetadata = Metadata.Documents.CashPayment And 
					Row.Document.TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer) Then
									
				NewRow_PartnerBalance_Advances.RecordType = ReverseRecordType(NewRow_Advances.RecordType);
			
			Else
				NewRow_PartnerBalance_Advances.RecordType = NewRow_Advances.RecordType;
			EndIf;
			
			If (DocMetadata = Metadata.Documents.BankReceipt And 
					Row.Document.TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor)
					
				Or (DocMetadata = Metadata.Documents.CashReceipt And 
					Row.Document.TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor) Then
					
				NewRow_PartnerBalance_Advances.RecordType = NewRow_Advances.RecordType;
			EndIf;	
						
			NewRow_PartnerBalance_Advances.Period     = NewRow_Advances.Period;
			NewRow_PartnerBalance_Advances.Company    = NewRow_Advances.Company;
			NewRow_PartnerBalance_Advances.Branch     = NewRow_Advances.Branch;
			NewRow_PartnerBalance_Advances.Partner    = NewRow_Advances.Partner;
			NewRow_PartnerBalance_Advances.LegalName  = NewRow_Advances.LegalName;
			NewRow_PartnerBalance_Advances.Agreement  = NewRow_Advances.Agreement;
			NewRow_PartnerBalance_Advances.Currency   = NewRow_Advances.Currency;
			NewRow_PartnerBalance_Advances.AdvancesClosing = Parameters.Object.Ref;
			
			// Partner balance Advance Amounts
			If Parameters.RegisterName_Advances = Metadata.AccumulationRegisters.R2020B_AdvancesFromCustomers.Name Then
				NewRow_PartnerBalance_Advances.CustomerAdvance = NewRow_Advances.Amount;
				
				If (DocMetadata = Metadata.Documents.SalesReturn And RowOffset.IsReturnToAdvance) 
					Or (DocMetadata = Metadata.Documents.CreditNote And RowOffset.IsReturnToAdvance And IsCustomerAdvanceClosing) Then
					NewRow_PartnerBalance_Advances.CustomerAdvance = - NewRow_Advances.Amount; // Sales return	
				EndIf;	
				
			ElsIf Parameters.RegisterName_Advances = Metadata.AccumulationRegisters.R1020B_AdvancesToVendors.Name Then
				NewRow_PartnerBalance_Advances.VendorAdvance = NewRow_Advances.Amount;
				
				If (DocMetadata = Metadata.Documents.PurchaseReturn And RowOffset.IsReturnToAdvance) 
					Or (DocMetadata = Metadata.Documents.DebitNote And RowOffset.IsReturnToAdvance And IsVendorAdvanceClosing) Then
					NewRow_PartnerBalance_Advances.VendorAdvance = - NewRow_Advances.Amount; // Purchase return	
				EndIf;	
				
			Else
				Raise StrTemplate("Unknown advance register [%1]", Parameters.RegisterName_Advances);
			EndIf;
			
			If UseKeyForCurrency Then
				NewRow_Advances.Key = RowOffset.Key;
				NewRow_PartnerBalance_Advances.Key = RowOffset.Key;
			EndIf;
			
			If RowOffset.IsAdvanceRelease = True Then
				Continue;
			EndIf;
			
			// Transactions
			NewRow_Transactions = TableTransactions.Add();
			FillPropertyValues(NewRow_Transactions, RowOffset);
			
			If RowOffset.RecordType = Enums.RecordType.Receipt Then
				NewRow_Transactions.RecordType = AccumulationRecordType.Receipt;
			Else
				NewRow_Transactions.RecordType = AccumulationRecordType.Expense;
			EndIf;
			
			NewRow_Transactions.Basis = RowOffset.TransactionDocument;
			NewRow_Transactions[Parameters.DocumentName] = Parameters.Object.Ref;
			NewRow_Transactions.Order     = RowOffset.TransactionOrder;
			NewRow_Transactions.Project   = RowOffset.TransactionProject;
			NewRow_Transactions.Agreement = RowOffset.TransactionAgreement;
			
			// Partners balance - transactions
			NewRow_PartnersBalance_Transactions = TablePartnersBalance.Add();
			
			If DocMetadata = Metadata.Documents.BankPayment
				Or (DocMetadata = Metadata.Documents.DebitCreditNote And Row.Document.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor)
				Or DocMetadata = Metadata.Documents.CashPayment
				Or DocMetadata = Metadata.Documents.SalesReportToConsignor
				Or DocMetadata = Metadata.Documents.PurchaseInvoice
				Or (DocMetadata = Metadata.Documents.DebitCreditNote And Row.Document.ReceiveDebtType = Enums.DebtTypes.TransactionVendor)
				Or (DocMetadata = Metadata.Documents.CreditNote And IsVendorAdvanceClosing)
				Or DocMetadata = Metadata.Documents.PurchaseReturn
				Or (DocMetadata = Metadata.Documents.DebitNote And IsVendorAdvanceClosing)
				Or (DocMetadata = Metadata.Documents.OpeningEntry And IsVendorAdvanceClosing) Then
				
				NewRow_PartnersBalance_Transactions.RecordType = ReverseRecordType(NewRow_Transactions.RecordType);
			
			Else
				NewRow_PartnersBalance_Transactions.RecordType = NewRow_Transactions.RecordType;
			EndIf;
			
			If (DocMetadata = Metadata.Documents.BankPayment And 
					Row.Document.TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer)
					
				Or (DocMetadata = Metadata.Documents.CashPayment And 
					Row.Document.TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer) Then
					
				NewRow_PartnersBalance_Transactions.RecordType = NewRow_Transactions.RecordType;
			EndIf;	
				
			If (DocMetadata = Metadata.Documents.BankReceipt And 
					Row.Document.TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor)
					
				Or (DocMetadata = Metadata.Documents.CashReceipt And 
					Row.Document.TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor) Then
					
				NewRow_PartnersBalance_Transactions.RecordType = ReverseRecordType(NewRow_Transactions.RecordType);
			EndIf;	
						
			NewRow_PartnersBalance_Transactions.Period     = NewRow_Transactions.Period;
			NewRow_PartnersBalance_Transactions.Company    = NewRow_Transactions.Company;
			NewRow_PartnersBalance_Transactions.Branch     = NewRow_Transactions.Branch;
			NewRow_PartnersBalance_Transactions.Partner    = NewRow_Transactions.Partner;
			NewRow_PartnersBalance_Transactions.LegalName  = NewRow_Transactions.LegalName;
			NewRow_PartnersBalance_Transactions.Agreement  = NewRow_Transactions.Agreement;
			NewRow_PartnersBalance_Transactions.Document   = NewRow_Transactions.Basis;
			NewRow_PartnersBalance_Transactions.Currency   = NewRow_Transactions.Currency;
			NewRow_PartnersBalance_Transactions.AdvancesClosing = Parameters.Object.Ref;
			
			If Parameters.RegisterName_Transactions = Metadata.AccumulationRegisters.R2021B_CustomersTransactions.Name Then
				NewRow_PartnersBalance_Transactions.CustomerTransaction = NewRow_Transactions.Amount;
			ElsIf Parameters.RegisterName_Transactions = Metadata.AccumulationRegisters.R1021B_VendorsTransactions.Name Then
				NewRow_PartnersBalance_Transactions.VendorTransaction = NewRow_Transactions.Amount;
			Else
				Raise StrTemplate("Unknown transaction register [%1]", Parameters.RegisterName_Advances);
			EndIf;
															
			If UseKeyForCurrency Then
				NewRow_Transactions.Key = RowOffset.Key;
				NewRow_PartnersBalance_Transactions.Key = RowOffset.Key;
			EndIf;
						
			// Accounting amounts
			NewRow_AccountingAmounts = TableAccountingAmounts.Add();
			FillPropertyValues(NewRow_AccountingAmounts, RowOffset);
			NewRow_AccountingAmounts.AdvancesClosing = Parameters.Object.Ref;
			NewRow_AccountingAmounts.RowKey = RowOffset.Key;
			
			Operation = GetAccountingOperation(DocMetadata, Row.Document, IsCustomerAdvanceClosing, IsVendorAdvanceClosing);
			If Operation <> Undefined Then
				NewRow_AccountingAmounts.Operation = Operation;
			EndIf;
						
			If UseKeyForCurrency Then
				NewRow_AccountingAmounts.Key = RowOffset.Key;
			EndIf;
						
		EndDo; // OffsetInfoByDocument
	
		// Currency calculation
		
		CurrencyTable = Undefined;
		If DocMetadata = Metadata.Documents.PurchaseOrderClosing Then
			CurrencyTable = Row.Document.PurchaseOrder.Currencies.Unload();
		ElsIf DocMetadata = Metadata.Documents.SalesOrderClosing Then
			CurrencyTable = Row.Document.SalesOrder.Currencies.Unload();
		EndIf;
		
		PostingDataTables = New Map();
		
		// Advances
		RecordSet_AdvancesSettings = PostingServer.PostingTableSettings(TableAdvances, RecordSet_Advances);
		PostingDataTables.Insert(RecordSet_Advances.Metadata(), RecordSet_AdvancesSettings);
		
		// Transactions
		RecordSet_TransactionsSettings = PostingServer.PostingTableSettings(TableTransactions, RecordSet_Transactions);
		PostingDataTables.Insert(RecordSet_Transactions.Metadata(), RecordSet_TransactionsSettings);
		
		// Partner balance
		RecordSet_PartnerBalanceSettings = PostingServer.PostingTableSettings(TablePartnersBalance, RecordSet_PartnersBalance);
		PostingDataTables.Insert(RecordSet_PartnersBalance.Metadata(), RecordSet_PartnerBalanceSettings);
		
		// Acounting amounts
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
														
		// Transactions					
		ItemOfPostingInfo = GetFromPostingInfo(ArrayOfPostingInfo, Metadata.AccumulationRegisters[Parameters.RegisterName_Transactions]);
			
		RecordSet_Transactions.Read();
		For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
			FillPropertyValues(RecordSet_Transactions.Add(), RowPostingInfo);
		EndDo;
		RecordSet_Transactions.SetActive(True);
		RecordSet_Transactions.Write();
				
		// Partners balance
		ItemOfPostingInfo = GetFromPostingInfo(ArrayOfPostingInfo, Metadata.AccumulationRegisters.R5020B_PartnersBalance);
			
		RecordSet_PartnersBalance.Read();
		For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
			FillPropertyValues(RecordSet_PartnersBalance.Add(), RowPostingInfo);
		EndDo;
		RecordSet_PartnersBalance.SetActive(True);
		RecordSet_PartnersBalance.Write();
				
		// Accounting amounts (advances)
		ItemOfPostingInfo = GetFromPostingInfo(ArrayOfPostingInfo, Metadata.AccumulationRegisters.T1040T_AccountingAmounts);
		
		RecordSet_AccountingAmounts.Read();
		For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
			FillPropertyValues(RecordSet_AccountingAmounts.Add(), RowPostingInfo);
		EndDo;
		RecordSet_AccountingAmounts.SetActive(True);
		RecordSet_AccountingAmounts.Write();
				
	EndDo;
EndProcedure

Function GetAccountingOperation(DocMetadata, Doc, IsCustomerAdvanceClosing, IsVendorAdvanceClosing)
	AO = Catalogs.AccountingOperations;
	
	// Bank payment
	If DocMetadata = Metadata.Documents.BankPayment Then
		
		If Doc.TransactionType = Enums.OutgoingPaymentTransactionTypes.PaymentToVendor Then
			Return AO.BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors;
		ElsIf Doc.TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer Then
			Return AO.BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers;
		EndIf;
	
	// Cash payment
	ElsIf DocMetadata = Metadata.Documents.CashPayment Then
	
		If Doc.TransactionType = Enums.OutgoingPaymentTransactionTypes.PaymentToVendor Then
			Return AO.CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors;
		ElsIf Doc.TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer Then
			Return AO.CashPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers;
		EndIf;
	
	// Bank receipt
	ElsIf DocMetadata = Metadata.Documents.BankReceipt Then
	
		If Doc.TransactionType = Enums.IncomingPaymentTransactionType.PaymentFromCustomer Then
			Return AO.BankReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions;
		ElsIf Doc.TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor Then
			Return AO.BankReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions;
		EndIf;
	
	// Cash receipt
	ElsIf DocMetadata = Metadata.Documents.CashReceipt Then
	
		If Doc.TransactionType = Enums.IncomingPaymentTransactionType.PaymentFromCustomer Then
			Return AO.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions;
		ElsIf Doc.TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor Then
			Return AO.CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions;
		EndIf;
	
	// Sales invoice
	ElsIf DocMetadata = Metadata.Documents.SalesInvoice Then
		
		Return AO.SalesInvoice_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions;
		
	// Sales return
	ElsIf DocMetadata = Metadata.Documents.SalesReturn Then
		
		Return AO.SalesReturn_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers;
	
	// Purchase invoice
	ElsIf DocMetadata = Metadata.Documents.PurchaseInvoice Then
		
		Return AO.PurchaseInvoice_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors;
	
	// Purchase return
	ElsIf DocMetadata = Metadata.Documents.PurchaseReturn Then
		
		Return AO.PurchaseReturn_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions;
	
	// Debit\Credit note
	ElsIf DocMetadata = Metadata.Documents.DebitCreditNote Then
		
		If IsCustomerAdvanceClosing Then
			Return AO.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset;
		ElsIf IsVendorAdvanceClosing Then
			Return AO.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset;
		EndIf;
		
	// Credit note
	ElsIf DocMetadata = Metadata.Documents.CreditNote Then
			
		If IsCustomerAdvanceClosing Then
			Return AO.CreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions;
		ElsIf IsVendorAdvanceClosing Then
			Return AO.CreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors;
		EndIf;	
		
	// Debit note
	ElsIf DocMetadata = Metadata.Documents.DebitNote Then
		
		If IsVendorAdvanceClosing Then
			Return AO.DebitNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors;
		EndIf;
	
	EndIf;
	
	Return Undefined;
EndFunction	

Function ReverseRecordType(RecordType)
	Return ?(RecordType = AccumulationRecordType.Receipt, 
		AccumulationRecordType.Expense, 
		AccumulationRecordType.Receipt);
EndFunction

Function GetFromPostingInfo(ArrayOfPostingInfo, RecordSetType)
	For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
		If ItemOfPostingInfo.Key = RecordSetType Then
			Return ItemOfPostingInfo;
		EndIf;
	EndDo;
	Raise StrTemplate("Not found [%1] in array of posting info", RecordSetType);
EndFunction

Function ProjectsNotMatch(Parameters, AdvanceProject, TransactionProject)
	If Parameters.DontOffsetEmptyProjects Then
		If Not ValueIsFilled(TransactionProject) Or Not ValueIsFilled(AdvanceProject) Then
			Return True;
		EndIf;
		If TransactionProject <> AdvanceProject Then
			Return True;
		EndIf;
	Else
		If TransactionProject <> AdvanceProject Then
			Return True;
		EndIf;
	EndIf;
	
	Return False;
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
	|	Records_OffsetOfAdvances.RecordType,
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
	|	Records_OffsetOfAdvances.AdvanceOrder,
	|	Records_OffsetOfAdvances.TransactionOrder,
	|	Records_OffsetOfAdvances.AdvanceProject,
	|	Records_OffsetOfAdvances.TransactionProject,
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
	|	Records_OffsetAging.RecordType,
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
	|	Records_AdvancesCurrencyRevaluation.AdvanceOrder,
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
	|	tmpRecords_OffsetOfAdvances.RecordType,
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
	|	tmpRecords_OffsetOfAdvances.AdvanceOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.AdvanceProject,
	|	tmpRecords_OffsetOfAdvances.TransactionProject,
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
	|	tmpRecords_OffsetOfAdvances.RecordType,
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
	|	tmpRecords_OffsetOfAdvances.AdvanceOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.AdvanceProject,
	|	tmpRecords_OffsetOfAdvances.TransactionProject,
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
	|	tmpRecords_OffsetAging.RecordType,
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
	|	tmpRecords_OffsetAging.RecordType,
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
	|	tmpRecords_AdvancesCurrencyRevaluation.AdvanceOrder,
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
	|	tmpRecords_AdvancesCurrencyRevaluation.AdvanceOrder
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
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, AdvanceKey = &AdvanceKey AND AdvanceKey.%1) AS AdvancesBalance";

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
		
		// Minus by advance with order
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Receipt, 
		                        Date, 
		                        AdvanceKey, // key with order
		                        -QuerySelection.AdvanceAmount, 
		                        Records_AdvancesKey);		
		NeedWriteAdvances = True;
		
		// Plus by advance without order
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Receipt, 
		                        Date, 
		                        AdvanceKeyWithoutOrder, // key without order
		                        QuerySelection.AdvanceAmount, 
		                        Records_AdvancesKey);		
				
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
		
		NewOffsetInfo.AdvanceOrder     = AdvanceKey.Order;
		NewOffsetInfo.AdvanceAgreement = AdvanceKey.AdvanceAgreement;
		NewOffsetInfo.AdvanceProject   = AdvanceKey.Project;
		
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
		NewOffsetInfo.AdvanceProject   = AdvanceKey.Project;
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
	|	AND &Project = AdvKeys.Project
	|	AND AdvKeys.Order.Ref IS NULL
	|	AND AdvKeys.%1";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Query.SetParameter("Company"   , AdvanceKey.Company);
	Query.SetParameter("Branch"    , AdvanceKey.Branch);
	Query.SetParameter("Currency"  , AdvanceKey.Currency);
	Query.SetParameter("Partner"   , AdvanceKey.Partner);
	Query.SetParameter("LegalName" , AdvanceKey.LegalName);
	Query.SetParameter("AdvanceAgreement", AdvanceKey.AdvanceAgreement);
	Query.SetParameter("Project", AdvanceKey.Project);

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
		KeyObject.Project = AdvanceKey.Project;
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
	|	AdvInfo.Project,
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
	|	AdvInfo.Project,
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
	|	tmp_AdvInfo.Project,
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
	|		AND tmp_AdvInfo.Project = AdvKeys.Project
	|		AND AdvKeys.%1
	|GROUP BY
	|	tmp_AdvInfo.Branch,
	|	tmp_AdvInfo.Company,
	|	tmp_AdvInfo.Currency,
	|	tmp_AdvInfo.Partner,
	|	tmp_AdvInfo.LegalName,
	|	tmp_AdvInfo.AdvanceAgreement,
	|	tmp_AdvInfo.Project,
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
	|	AdvInfo.Project,
	|	AdvInfo.RecordType,
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
	|	AdvInfo.Project,
	|	AdvInfo.RecordType,
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
	|	tmp_AdvInfo.RecordType,
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
	|		AND tmp_AdvInfo.Project = AdvKeys.Project
	|		AND CASE
	|			WHEN tmp_AdvInfo.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE tmp_AdvInfo.Order
	|		END = CASE
	|			WHEN AdvKeys.Order.Ref IS NULL
	|				THEN UNDEFINED
	|			ELSE AdvKeys.Order
	|		END
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
			
			RecordType = AccumulationRecordType.Receipt;
			If QuerySelection.RecordType = Enums.RecordType.Expense Then
				RecordType = AccumulationRecordType.Expense;
			EndIf;
			
			Add_TM1020B_AdvancesKey(RecordType, 
		                            QuerySelection.Date, 
		                            QuerySelection.AdvanceKey,
		                            QuerySelection.Amount, 
		                            Records_AdvancesKey);		
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
	|	TrnInfo.Project,
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
	|	TrnInfo.Project,
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
	|	tmp_TrnInfo.Project,
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
	|		AND tmp_TrnInfo.Project = TrnKeys.Project
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
	|	tmp_TrnInfo.Project,
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
	|	TrnInfo.Project,
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
	|		AND tmp_TrnInfo.Project = TrnKeys.Project
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
		
		Add_TM1030B_TransactionsKey(RecordType, 
		                            QuerySelection.Date, 
		                            QuerySelection.TransactionKey, 
		                            QuerySelection.Amount, 
		                            Records_TransactionsKey);		
			
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

Procedure ReturnMoneyByAging(Parameters, Document, TransactionKey, TransactionAmount, Records_OffsetAging)
	Query = New Query;
	Query.Text =
	"SELECT
	|	RegAging.PaymentDate,
	|	RegAging.Amount
	|FROM
	|	AccumulationRegister.%1 AS RegAging
	|WHERE
	|	RegAging.Invoice = &TransactionBasis
	|	AND RegAging.RecordType = VALUE(AccumulationRecordType.Expense)
	|ORDER BY
	|	RegAging.PaymentDate DESC";
	
	Query.Text = StrTemplate(Query.Text, Parameters.RegisterName_Aging);	
	Query.SetParameter("TransactionBasis", TransactionKey.TransactionBasis);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	NeedWriteAging = False;
	NeedWriteoff = TransactionAmount;
	While QuerySelection.Next() Do
		If NeedWriteoff = 0 Then
			Break;
		EndIf;
		
		CanWriteoff = Min(QuerySelection.Amount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;

		NewRow = Records_OffsetAging.Add();
		NewRow.Period      = Document.Date;
		NewRow.Document    = Document;
		NewRow.RecordType  = Enums.RecordType.Receipt;
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
		NewRow.RecordType  = Enums.RecordType.Expense;
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
		
		If RowOffset.RecordType = Enums.RecordType.Receipt Then
			NewRow_Aging.RecordType = AccumulationRecordType.Receipt;
		Else
			NewRow_Aging.RecordType = AccumulationRecordType.Expense;
		EndIf;
			
		NewRow_Aging.AgingClosing = Parameters.Object.Ref;
	EndDo;

	RecordSet_Aging.SetActive(True);
	RecordSet_Aging.Write();
EndProcedure

Procedure Add_T2010S_OffsetOfAdvances_FromAdvance_ToTransaction(Parameters, 
	                                                            RecordType, 
	                                                            Period, 
	                                                            Amount, 
	                                                            Document, 
	                                                            AdvanceKey, 
	                                                            TransactionKey, 
	                                                            Records_OffsetOfAdvances)
	NewRecord = Records_OffsetOfAdvances.Add();
	NewRecord.RecordType  = RecordType;
	
	NewRecord.Period   = Period;
	NewRecord.Amount   = Amount;
	NewRecord.Document = Document;
		
	NewRecord.Company   = TransactionKey.Company;
	NewRecord.Branch    = TransactionKey.Branch;
	NewRecord.Currency  = TransactionKey.Currency;
	NewRecord.Partner   = TransactionKey.Partner;
	NewRecord.LegalName = TransactionKey.LegalName;
		
	NewRecord.TransactionDocument = TransactionKey.TransactionBasis;
		
	NewRecord.TransactionAgreement= TransactionKey.Agreement;
	NewRecord.TransactionOrder    = TransactionKey.Order;
	NewRecord.TransactionProject  = TransactionKey.Project;
	NewRecord.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, TransactionKey, Document);
		
	NewRecord.AdvanceAgreement    = AdvanceKey.AdvanceAgreement;
	NewRecord.AdvanceProject      = AdvanceKey.Project;
	NewRecord.AdvanceOrder        = AdvanceKey.Order;
	NewRecord.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceKey, Document);
		
    NewRecord.FromAdvanceKey      = AdvanceKey;
	NewRecord.ToTransactionKey    = TransactionKey;
		
	NewRecord.Key = NewRecord.TransactionsRowKey;
EndProcedure

Procedure Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, 
	                                                            RecordType, 
	                                                            Period, 
	                                                            Amount, 
	                                                            Document, 
	                                                            AdvanceKey, 
	                                                            TransactionKey, 
	                                                            Records_OffsetOfAdvances,
	                                                            IsReturnToAdvance = False)
	NewRecord = Records_OffsetOfAdvances.Add();
	NewRecord.RecordType = RecordType;
	
	NewRecord.Period   = Period;
	NewRecord.Amount   = Amount;
	NewRecord.Document = Document;
		
	NewRecord.Company   = AdvanceKey.Company;
	NewRecord.Branch    = AdvanceKey.Branch;
	NewRecord.Currency  = AdvanceKey.Currency;
	NewRecord.Partner   = AdvanceKey.Partner;
	NewRecord.LegalName = AdvanceKey.LegalName;
		
	NewRecord.TransactionDocument = TransactionKey.TransactionBasis;
		
	NewRecord.TransactionAgreement= TransactionKey.Agreement;
	NewRecord.TransactionOrder    = TransactionKey.Order;
	NewRecord.TransactionProject  = TransactionKey.Project;
	NewRecord.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, TransactionKey, Document);
		
    NewRecord.AdvanceAgreement    = AdvanceKey.AdvanceAgreement;
    NewRecord.AdvanceOrder        = AdvanceKey.Order;
    NewRecord.AdvanceProject      = AdvanceKey.Project;
    NewRecord.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceKey, Document);
		
	NewRecord.FromTransactionKey  = TransactionKey;
	NewRecord.ToAdvanceKey        = AdvanceKey;
	
	NewRecord.IsReturnToAdvance = IsReturnToAdvance; 
	
	If IsReturnToAdvance Then	
		NewRecord.Key = NewRecord.TransactionsRowKey;
	Else
		NewRecord.Key = NewRecord.AdvancesRowKey;
	EndIf;		
EndProcedure

Procedure Add_TM1020B_AdvancesKey(RecordType, Period, AdvanceKey, Amount, Records_AdvancesKey)
	NewRecord = Records_AdvancesKey.Add();
	NewRecord.RecordType = RecordType;
	NewRecord.Period     = Period;
	NewRecord.AdvanceKey = AdvanceKey;
	NewRecord.Amount     = Amount;
EndProcedure

Procedure Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey)
	RecordSet = AccumulationRegisters.TM1020B_AdvancesKey.CreateRecordSet();
	RecordSet.DataExchange.Load = True;
	RecordSet.Filter.Recorder.Set(Parameters.Object.Ref);
	RecordSet.Load(Records_AdvancesKey);
	RecordSet.SetActive(True);
	RecordSet.Write();
EndProcedure

Procedure Add_TM1030B_TransactionsKey(RecordType, Period, TransactionKey, Amount, Records_TransactionsKey)
	NewRecord = Records_TransactionsKey.Add();
	NewRecord.RecordType     = RecordType;
	NewRecord.Period         = Period;
	NewRecord.TransactionKey = TransactionKey;
	NewRecord.Amount         = Amount;
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
	|	T1040T_AccountingAmounts.Recorder
	|;
	|//////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R5020B_PartnersBalance.Recorder
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance AS R5020B_PartnersBalance
	|WHERE
	|	R5020B_PartnersBalance.AdvancesClosing = &Ref
	|GROUP BY
	|	R5020B_PartnersBalance.Recorder";
	
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
	ClearRegisterRecords(Ref, QueryResults[4].Unload(), "R5020B_PartnersBalance"             , "AdvancesClosing");
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
