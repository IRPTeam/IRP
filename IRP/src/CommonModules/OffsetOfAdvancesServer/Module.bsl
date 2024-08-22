
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
		
	// Clear register records
	Clear_SelfRecords(Parameters);
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey); // write empty table
	Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey); // write empty table
	
	// Create advances keys
	RegMetadata = Metadata.AccumulationRegisters[Parameters.RegisterName_Advances];
	Table_DocumentAndAdvancesKey = New ValueTable();
	Table_DocumentAndAdvancesKey.Columns.Add("Document"       , RegMetadata.StandardAttributes.Recorder.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("AdvanceKeyUUID" , New TypeDescription("UUID"));
	Table_DocumentAndAdvancesKey.Columns.Add("Company"        , RegMetadata.Dimensions.Company.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Branch"         , RegMetadata.Dimensions.Branch.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Currency"       , RegMetadata.Dimensions.Currency.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Partner"        , RegMetadata.Dimensions.Partner.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("LegalName"      , RegMetadata.Dimensions.LegalName.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Agreement"      , RegMetadata.Dimensions.Agreement.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Order"          , RegMetadata.Dimensions.Order.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Project"        , RegMetadata.Dimensions.Project.Type);
	Table_DocumentAndAdvancesKey.Columns.Add("Amount"         , Metadata.DefinedTypes.typeAmount.Type);
	// is vendor advance or is customer advance
	Table_DocumentAndAdvancesKey.Columns.Add(Parameters.AdvanceType , New TypeDescription("Boolean"));

	CreateAdvancesKeys(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Table_DocumentAndAdvancesKey);
	// Write advances keys to TM1020B_AdvancesKey, Receipt
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
		
	// Create transactions keys
	RegMetadata = Metadata.AccumulationRegisters[Parameters.RegisterName_Transactions];
	Table_DocumentAndTransactionsKey = New ValueTable();
	Table_DocumentAndTransactionsKey.Columns.Add("Document"           , RegMetadata.StandardAttributes.Recorder.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("TransactionKeyUUID" , New TypeDescription("UUID"));
	Table_DocumentAndTransactionsKey.Columns.Add("Company"            , RegMetadata.Dimensions.Company.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("Branch"             , RegMetadata.Dimensions.Branch.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("Currency"           , RegMetadata.Dimensions.Currency.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("Partner"            , RegMetadata.Dimensions.Partner.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("LegalName"          , RegMetadata.Dimensions.LegalName.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("Agreement"          , RegMetadata.Dimensions.Agreement.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("TransactionBasis"   , RegMetadata.Dimensions.Basis.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("Order"              , RegMetadata.Dimensions.Order.Type);
	Table_DocumentAndTransactionsKey.Columns.Add("Project"            , RegMetadata.Dimensions.Project.Type);
	// is vendor transaction or is customer transaction
	Table_DocumentAndTransactionsKey.Columns.Add(Parameters.TransactionType , New TypeDescription("Boolean"));
	
	CreateTransactionsKeys(Parameters, Records_TransactionsKey, Records_OffsetAging, Table_DocumentAndTransactionsKey);
	// Write transactions keys to TM1030B_TransactionsKey
	Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);

	Query = New Query;
	Query.Text =
	"SELECT
	|	DocAdv.Document,
	|	DocAdv.AdvanceKeyUUID
	|INTO tmp_DocAdv
	|FROM
	|	&DocAdv AS DocAdv
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocTrn.Document,
	|	DocTrn.TransactionKeyUUID
	|INTO tmp_DocTrn
	|FROM
	|	&DocTrn AS DocTrn
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_DocAdv.AdvanceKeyUUID AS AdvanceKeyUUID,
	|	NULL AS TransactionKeyUUID,
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
	|	tmp_DocTrn.TransactionKeyUUID,
	|	tmp_DocTrn.Document.PointInTime,
	|	tmp_DocTrn.Document
	|FROM
	|	tmp_DocTrn AS tmp_DocTrn
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpAllKeys.AdvanceKeyUUID,
	|	tmpAllKeys.TransactionKeyUUID,
	|	tmpAllKeys.PointInTime,
	|	tmpAllKeys.Document
	|FROM
	|	tmp_AllKeys AS tmpAllKeys
	|GROUP BY
	|	tmpAllKeys.AdvanceKeyUUID,
	|	tmpAllKeys.TransactionKeyUUID,
	|	tmpAllKeys.PointInTime,
	|	tmpAllKeys.Document
	|
	|ORDER BY
	|	PointInTime";
			
	Query.SetParameter("DocAdv", Table_DocumentAndAdvancesKey);
	Query.SetParameter("DocTrn", Table_DocumentAndTransactionsKey);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	While QuerySelection.Next() Do
		// Offset advances to transactions
		If ValueIsFilled(QuerySelection.AdvanceKeyUUID) Then
			
			AdvanceRows = Table_DocumentAndAdvancesKey.FindRows(New Structure("AdvanceKeyUUID", QuerySelection.AdvanceKeyUUID));
			If Not AdvanceRows.Count() Then
				Raise StrTemplate("Not found rows in Table_DocumentAndAdvancesKey by uuid [%1]", QuerySelection.AdvanceKeyUUID);
			ENdIf;
			AdvanceRecordData = CreateAdvanceRecordData(Parameters, AdvanceRows[0]);
			
			If TypeOf(QuerySelection.Document) = Parameters._OrderCloseType And ValueIsFilled(AdvanceRecordData.Order) Then
				
				AdvanceKeyWithoutOrder = ReleaseAdvanceByOrder(Parameters, 
															   Records_AdvancesKey, 
															   Records_OffsetOfAdvances,
															   QuerySelection.Document, 
															   QuerySelection.PointInTime.Date, 
															   AdvanceRecordData);
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
								             AdvanceRecordData,
								             QuerySelection.PointInTime, 
								             QuerySelection.Document);
			EndIf;
		EndIf;
		
		// Offset transactions to advances
		If ValueIsFilled(QuerySelection.TransactionKeyUUID) Then
			
			TransactionRows = Table_DocumentAndTransactionsKey.FindRows(New Structure("TransactionKeyUUID", QuerySelection.TransactionKeyUUID));
			If Not TransactionRows.Count() Then
				Raise StrTemplate("Not found rows in Table_DocumentAndTransactionsKey by uuid [%1]", QuerySelection.TransactionKeyUUID);
			ENdIf;
			TransactionRecordData = CreateTransactionRecordData(Parameters, TransactionRows[0]);
			
			OffsetTransactionsToAdvances(Parameters,
			                             Records_TransactionsKey, 
			                             Records_AdvancesKey,
			                             Records_OffsetOfAdvances, 
			                             Records_OffsetAging, 
			                             TransactionRecordData,
			                             QuerySelection.PointInTime, 
			                             QuerySelection.Document);
		EndIf;
	EndDo;

	Parameters.Object.RegisterRecords.TM1030B_TransactionsKey.Read();
	Parameters.Object.RegisterRecords.TM1020B_AdvancesKey.Read();
		
	// Write OffsetInfo
	Write_SelfRecords(Parameters, Records_OffsetOfAdvances);
	                  
	WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging);

	AdvancesRelevanceServer.Clear(Parameters.Object.Ref, Parameters.Object.Company, Parameters.Object.EndOfPeriod);
	AdvancesRelevanceServer.Restore(Parameters.Object.Ref, Parameters.Object.Company, Parameters.Object.EndOfPeriod);

	Return AdvancesClosingQueryText(Parameters);
EndFunction

Procedure OffsetAdvancesToTransactions(Parameters, 
	                                   Records_AdvancesKey, 
	                                   Records_TransactionsKey, 
	                                   Records_OffsetOfAdvances, 
	                                   Records_OffsetAging, 
	                                   AdvanceRecordData, 
	                                   PointInTime, 
	                                   Document)
	Query = New Query;
	Query.Text =
	"SELECT
	|	AdvancesBalance.Company,
	|	AdvancesBalance.Branch,
	|	AdvancesBalance.Currency,
	|	AdvancesBalance.Partner,
	|	AdvancesBalance.LegalName,
	|	AdvancesBalance.Agreement,
	|	AdvancesBalance.Order,
	|	AdvancesBalance.Project,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, 
	|	    Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Partner = &Partner
	|	AND LegalName = &LegalName
	|	AND Agreement = &Agreement
	|	AND case when Order.Ref is null then Undefined else Order end = &Order
	|	AND Project = &Project
	|	AND %1) AS AdvancesBalance";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary", Boundary);

	Query.SetParameter("Company"   , AdvanceRecordData.Company);
	Query.SetParameter("Branch"    , AdvanceRecordData.Branch);
	Query.SetParameter("Currency"  , AdvanceRecordData.Currency);
	Query.SetParameter("Partner"   , AdvanceRecordData.Partner);
	Query.SetParameter("LegalName" , AdvanceRecordData.LegalName);
	Query.SetParameter("Agreement" , AdvanceRecordData.Agreement);
	Query.SetParameter("Order"     , ?(ValueIsFilled(AdvanceRecordData.Order), AdvanceRecordData.Order, Undefined));
	Query.SetParameter("Project"   , AdvanceRecordData.Project);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteAdvances = False;

	While QuerySelection.Next() Do
		If QuerySelection.AdvanceAmount < 0 Then
			
			ReturnMoneyByTransaction(Parameters, 
		                             PointInTime, 
		                             Document, 
		                             AdvanceRecordData,
		                             QuerySelection.AdvanceAmount, 
		                             Records_TransactionsKey, 
		                             Records_AdvancesKey, 
		                             Records_OffsetOfAdvances,
		                             Records_OffsetAging, 
		                             NeedWriteAdvances);
		Else
		
			DistributeAdvanceToTransaction(Parameters, 
		                                   PointInTime, 
		                                   Document, 
		                                   AdvanceRecordData,
		                                   QuerySelection.AdvanceAmount, 
		                                   Records_TransactionsKey, 
		                                   Records_AdvancesKey, 
		                                   Records_OffsetOfAdvances,
		                                   Records_OffsetAging, 
		                                   NeedWriteAdvances);
		
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
								   AdvanceRecordData,
								   AdvanceAmount,
								   Records_TransactionsKey, 
	                               Records_AdvancesKey, 
	                               Records_OffsetOfAdvances, 
	                               Records_OffsetAging, 
	                               NeedWriteAdvances)
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Currency,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.TransactionBasis,
	|	Transactions.Order,
	|	Transactions.Project,
	|	Transactions.Amount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey AS Transactions
	|WHERE
	|	Transactions.Period <= &Period
	|	AND Transactions.Company = &Company
	|	AND Transactions.Branch = &Branch
	|	AND Transactions.Currency = &Currency
	|	AND Transactions.Partner = &Partner
	|	AND Transactions.LegalName = &LegalName
	|	AND (Transactions.RecordType = VALUE(AccumulationRecordType.Receipt)
	|	AND Transactions.Amount > 0
	|	OR Transactions.RecordType = VALUE(AccumulationRecordType.Expense)
	|	AND Transactions.Amount < 0)
	|
	|ORDER BY
	|	Transactions.Period DESC";
	
	Query.SetParameter("Period", PointInTime.Date);
	
	Query.SetParameter("Company"   , AdvanceRecordData.Company);
	Query.SetParameter("Branch"    , AdvanceRecordData.Branch);
	Query.SetParameter("Currency"  , AdvanceRecordData.Currency);
	Query.SetParameter("Partner"   , AdvanceRecordData.Partner);
	Query.SetParameter("LegalName" , AdvanceRecordData.LegalName);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteoff = -AdvanceAmount;
	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		If NeedWriteoff = 0 Then
			Break;
		EndIf;
		
		TransactionRecordData = CreateTransactionRecordData(Parameters, QuerySelection);
		
		If ValueIsFilled(AdvanceRecordData.Order) Then // advance by order
			If TransactionRecordData.Order <> AdvanceRecordData.Order Then
				Continue;
			EndIf;
		EndIf;
				
		If ValueIsFilled(AdvanceRecordData.Agreement) Then // advance by agreement
			If TransactionRecordData.Agreement <> AdvanceRecordData.Agreement Then
				Continue;
			EndIf;
		EndIf;
				
		// advance by Project
		If ProjectsNotMatch(Parameters, AdvanceRecordData.Project, TransactionRecordData.Project) Then
			Continue;
		EndIf;
		
		CanWriteoff = Min(QuerySelection.Amount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		// Transactions
		Add_TM1030B_TransactionsKey(AccumulationRecordType.Receipt, 
		                            Document.Date, 
		                            TransactionRecordData, 
		                            CanWriteOff, 
		                            Records_TransactionsKey);		
		NeedWriteTransactions = True;
		
		// Advances
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Receipt, 
		                        Document.Date, 
		                        AdvanceRecordData, 
		                        CanWriteoff, 
		                        Records_AdvancesKey);
		NeedWriteAdvances = True;
			
		// Aging
		ReturnMoneyByAging(Parameters, Document, TransactionRecordData, CanWriteoff, Records_OffsetAging);	
			
		Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, Enums.RecordType.Receipt,
		                                                      Document.Date, 
		                                                      CanWriteoff, 
		                                                      Document, 
		                                                      AdvanceRecordData, 
		                                                      TransactionRecordData, 
		                                                      Records_OffsetOfAdvances);		
	EndDo;
	
	If NeedWriteTransactions Then
		Write_TM1030B_TransactionsKey(Parameters, Records_TransactionsKey);
	EndIf;
EndProcedure

Procedure DistributeAdvanceToTransaction(Parameters, 
	                                     PointInTime, 
	                                     Document, 
	                                     AdvanceRecordData, 
	                                     AdvanceAmount, 
	                                     Records_TransactionsKey, 
	                                     Records_AdvancesKey, 
	                                     Records_OffsetOfAdvances, 
	                                     Records_OffsetAging, 
	                                     NeedWriteAdvances)

	Query = New Query;
	Query.Text =
	"SELECT
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Agreement,
	|	TransactionsBalance.TransactionBasis,
	|	TransactionsBalance.Order,
	|	TransactionsBalance.Project,
	|	TransactionsBalance.AmountBalance AS TransactionAmount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(&AdvanceBoundary, 
	|		Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Partner = &Partner
	|	AND Agreement = &Agreement
	|	AND LegalName = &LegalName) AS TransactionsBalance";

	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary", Boundary);

	Query.SetParameter("Company"   , AdvanceRecordData.Company);
	Query.SetParameter("Branch"    , AdvanceRecordData.Branch);
	Query.SetParameter("Currency"  , AdvanceRecordData.Currency);
	Query.SetParameter("Partner"   , AdvanceRecordData.Partner);
	Query.SetParameter("LegalName" , AdvanceRecordData.LegalName);
	Query.SetParameter("Agreement" , AdvanceRecordData.Agreement);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteoff = AdvanceAmount;
	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		
		TransactionRecordData = CreateTransactionRecordData(Parameters, QuerySelection);
		
		If NeedWriteoff = 0 Then
			Break;
		EndIf;
		
		If ValueIsFilled(AdvanceRecordData.Order) Then // advance by order
			If TransactionRecordData.Order <> AdvanceRecordData.Order Then
				Continue;
			EndIf;
		EndIf;
		
		If ValueIsFilled(AdvanceRecordData.Agreement) Then // advance by agreement
			If TransactionRecordData.Agreement <> AdvanceRecordData.Agreement Then
				Continue;
			EndIf;
		EndIf;
		
		If ProjectsNotMatch(Parameters, AdvanceRecordData.Project, TransactionRecordData.Project) Then
			Continue;
		EndIf;
				
		CanWriteoff = Min(QuerySelection.TransactionAmount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
		
		// Transactions
		Add_TM1030B_TransactionsKey(AccumulationRecordType.Expense, 
		                            Document.Date, 
		                            TransactionRecordData, 
		                            CanWriteoff, 
		                            Records_TransactionsKey);		
		NeedWriteTransactions = True;
		
		// Advances
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Expense, 
		                        Document.Date, 
		                        AdvanceRecordData, 
		                        CanWriteoff, 
		                        Records_AdvancesKey);
		NeedWriteAdvances = True;

		// OffsetOfAdvances
		Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, Enums.RecordType.Expense,
		                                                      Document.Date, 
		                                                      CanWriteoff, 
		                                                      Document, 
		                                                      AdvanceRecordData, 
		                                                      TransactionRecordData, 
		                                                      Records_OffsetOfAdvances);

		DistributeTransactionToAging(Parameters, 
		                             PointInTime, 
		                             Document, 
		                             TransactionRecordData, 
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
	                                   TransactionRecordData, 
	                                   PointInTime, 
	                                   Document)
	Query = New Query;
	Query.Text =
	"SELECT
	|	TransactionsBalance.AmountBalance AS TransactionAmount
	|FROM
	|	AccumulationRegister.TM1030B_TransactionsKey.Balance(&TransactionBoundary,
	|	    Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Partner = &Partner
	|	AND LegalName = &LegalName
	|	AND Agreement = &Agreement
	|	AND case when TransactionBasis.Ref is null then undefined else TransactionBasis end = &TransactionBasis
	|	AND case when Order.Ref is null then undefined else Order end = &Order
	|	AND Project = &Project
	|	AND %1) AS TransactionsBalance";

	Query.Text = StrTemplate(Query.Text, Parameters.TransactionType);

	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	
	Query.SetParameter("TransactionBoundary" , Boundary);
	
	Query.SetParameter("Company"          , TransactionRecordData.Company);
	Query.SetParameter("Branch"           , TransactionRecordData.Branch);
	Query.SetParameter("Currency"         , TransactionRecordData.Currency);
	Query.SetParameter("Partner"          , TransactionRecordData.Partner);
	Query.SetParameter("LegalName"        , TransactionRecordData.LegalName);
	Query.SetParameter("Agreement"        , TransactionRecordData.Agreement);
	Query.SetParameter("Project"          , TransactionRecordData.Project);
	Query.SetParameter("TransactionBasis" , ?(ValueIsFilled(TransactionRecordData.TransactionBasis), TransactionRecordData.TransactionBasis, Undefined));
	Query.SetParameter("Order"            , ?(ValueIsFilled(TransactionRecordData.Order), TransactionRecordData.Order, Undefined));

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	NeedWriteTransactions = False;
	While QuerySelection.Next() Do
		DistributeTransactionToAdvance(Parameters, 
		                               PointInTime, 
		                               Document, 
		                               //QuerySelection.TransactionKey,
		                               TransactionRecordData,
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

Function FindRowKeyByAdvanceKey(Parameters, AdvanceRecordData, Document)
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
	|	AND T2014S_AdvancesInfo.AdvanceAgreement = &Agreement
	|	and T2014S_AdvancesInfo.Project = &Project
	|	AND CASE
	|		WHEN T2014S_AdvancesInfo.Order.Ref IS NULL
	|			THEN &Order_EmptyRef
	|		ELSE T2014S_AdvancesInfo.Order
	|	END = &Order";
	
	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Query.SetParameter("Company"   , AdvanceRecordData.Company);
	Query.SetParameter("Branch"    , AdvanceRecordData.Branch);
	Query.SetParameter("Currency"  , AdvanceRecordData.Currency);
	Query.SetParameter("Date"      , Document.Date);
	Query.SetParameter("LegalName" , AdvanceRecordData.LegalName);
	Query.SetParameter("Partner"   , AdvanceRecordData.Partner);
	Query.SetParameter("Document"  , Document);
	Query.SetParameter("Order", ?(ValueIsFilled(AdvanceRecordData.Order), AdvanceRecordData.Order, Parameters.Order_EmptyRef));
	Query.SetParameter("Order_EmptyRef"   , Parameters.Order_EmptyRef);
	Query.SetParameter("Agreement"        , AdvanceRecordData.Agreement);
	Query.SetParameter("Project"          , AdvanceRecordData.Project);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Function FindRowKeyByTransactionKey(Parameters, TransactionRecordData, Document)
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
	
	Query.SetParameter("Company"          , TransactionRecordData.Company);
	Query.SetParameter("Branch"           , TransactionRecordData.Branch);
	Query.SetParameter("Currency"         , TransactionRecordData.Currency);
	Query.SetParameter("Date"             , Document.Date);
	Query.SetParameter("LegalName"        , TransactionRecordData.LegalName);
	Query.SetParameter("Partner"          , TransactionRecordData.Partner);
	Query.SetParameter("Agreement"        , TransactionRecordData.Agreement);
	Query.SetParameter("TransactionBasis" , TransactionRecordData.TransactionBasis);
	Query.SetParameter("Document", Document);
	Query.SetParameter("Order", ?(ValueIsFilled(TransactionRecordData.Order), TransactionRecordData.Order, Parameters.Order_EmptyRef));
	Query.SetParameter("Order_EmptyRef", Parameters.Order_EmptyRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Procedure DistributeTransactionToAdvance(Parameters, 
		                                 PointInTime, 
		                                 Document, 
		                                 TransactionRecordData, 
		                                 TransactionAmount, 
		                                 Records_AdvancesKey, 
		                                 Records_TransactionsKey, 
		                                 Records_OffsetOfAdvances, 
		                                 Records_OffsetAging, 
		                                 NeedWriteTransactions)

	Query = New Query;
	Query.Text =
	"SELECT
	|	AdvancesBalance.Company,
	|	AdvancesBalance.Branch,
	|	AdvancesBalance.Currency,
	|	AdvancesBalance.Partner,
	|	AdvancesBalance.LegalName,
	|	AdvancesBalance.Agreement,
	|	AdvancesBalance.Order,
	|	AdvancesBalance.Project,
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&TransactionBoundary, 
	|		Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Partner = &Partner
	|	AND LegalName = &LegalName) AS AdvancesBalance";

	Point = New PointInTime(PointInTime.Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	
	Query.SetParameter("TransactionBoundary", Boundary);
	
	Query.SetParameter("Company"   , TransactionRecordData.Company);
	Query.SetParameter("Branch"    , TransactionRecordData.Branch);
	Query.SetParameter("Currency"  , TransactionRecordData.Currency);
	Query.SetParameter("Partner"   , TransactionRecordData.Partner);
	Query.SetParameter("LegalName" , TransactionRecordData.LegalName);

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
		
		AdvanceRecordData = CreateAdvanceRecordData(Parameters, QuerySelection);
		
		If ValueIsFilled(AdvanceRecordData.Order) Then // transaction by order
			If AdvanceRecordData.Order <> TransactionRecordData.Order Then
				Continue;
			EndIf;
		EndIf;
		
		If ValueIsFilled(AdvanceRecordData.Agreement) Then // advance by agreement
			If TransactionRecordData.Agreement <> AdvanceRecordData.Agreement Then
				Continue;
			EndIf;
		EndIf;
		
		If ProjectsNotMatch(Parameters, AdvanceRecordData.Project, TransactionRecordData.Project) Then
			Continue;
		EndIf;
				
		CanWriteoff = Min(QuerySelection.AdvanceAmount, NeedWriteoff);
		NeedWriteoff = NeedWriteoff - CanWriteoff;
				
		// Transactions
		Add_TM1030B_TransactionsKey(AccumulationRecordType.Expense, 
		                            Document.Date, 
		                            TransactionRecordData, 
		                            CanWriteoff, 
		                            Records_TransactionsKey);			
		NeedWriteTransactions = True;
		
		// Advances
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Expense, 
		                        Document.Date, 
		                        AdvanceRecordData,
		                        CanWriteoff, 
		                        Records_AdvancesKey);		
		NeedWriteAdvances = True;
		
		// OffsetOfAdvances
		Add_T2010S_OffsetOfAdvances_FromAdvance_ToTransaction(Parameters, Enums.RecordType.Expense,
		                                                      Document.Date, 
		                                                      CanWriteoff,
		                                                      Document, 
		                                                      AdvanceRecordData,
		                                                      TransactionRecordData, 
		                                                      Records_OffsetOfAdvances);
		
		DistributeTransactionToAging(Parameters, 
		                             PointInTime, 
		                             Document,
		                             TransactionRecordData, 
		                             CanWriteoff,
		                             Records_OffsetAging);
	EndDo;
	
	// Write offseted advances to TM1020B_AdvancesKey
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
EndProcedure

Procedure Write_SelfRecords(Parameters, Records_OffsetOfAdvances)
	
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
			NewRow_Advances.Agreement = RowOffset.Agreement;
			
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
			NewRow_Transactions.Agreement = RowOffset.Agreement;
			
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
		AccumulationRegisters.R5020B_PartnersBalance.AdditionalDataFilling(ItemOfPostingInfo.Value.PrepareTable);
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
		
		If IsCustomerAdvanceClosing Then
			Return AO.DebitNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions;
		ElsIf IsVendorAdvanceClosing Then
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

Procedure WriteTablesToTempTables(Parameters, Records_OffsetOfAdvances, Records_OffsetAging)
	                              
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
	|	Records_OffsetOfAdvances.Agreement,
	|	Records_OffsetOfAdvances.AdvanceOrder,
	|	Records_OffsetOfAdvances.TransactionOrder,
	|	Records_OffsetOfAdvances.AdvanceProject,
	|	Records_OffsetOfAdvances.TransactionProject,
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
	|	tmpRecords_OffsetOfAdvances.Agreement,
	|	tmpRecords_OffsetOfAdvances.AdvanceOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.AdvanceProject,
	|	tmpRecords_OffsetOfAdvances.TransactionProject,
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
	|	tmpRecords_OffsetOfAdvances.Agreement,
	|	tmpRecords_OffsetOfAdvances.AdvanceOrder,
	|	tmpRecords_OffsetOfAdvances.TransactionOrder,
	|	tmpRecords_OffsetOfAdvances.AdvanceProject,
	|	tmpRecords_OffsetOfAdvances.TransactionProject,
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
	|	tmpRecords_OffsetAging.PaymentDate";

	Query.SetParameter("Records_OffsetOfAdvances" , Records_OffsetOfAdvances);
	Query.SetParameter("Records_OffsetAging"      , Records_OffsetAging);
	Query.Execute();
EndProcedure

Function ReleaseAdvanceByOrder(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Document, Date, AdvanceRecordData)
	Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	Query = New Query;
	Query.Text =
	"SELECT
	|	AdvancesBalance.AmountBalance AS AdvanceAmount
	|FROM
	|	AccumulationRegister.TM1020B_AdvancesKey.Balance(&AdvanceBoundary, 
	|	    Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND Partner = &Partner
	|	AND LegalName = &LegalName
	|	AND Agreement = &Agreement
	|	AND case when Order.Ref is null then undefined else Order end = &Order
	|	AND Project = &Project
	|	AND %1) AS AdvancesBalance";

	Query.Text = StrTemplate(Query.Text, Parameters.AdvanceType);
	
	Point = New PointInTime(Date, Parameters.Object.Ref);
	Boundary = New Boundary(Point, BoundaryType.Including);
	Query.SetParameter("AdvanceBoundary" , Boundary);
	Query.SetParameter("Company"   , AdvanceRecordData.Company);
	Query.SetParameter("Branch"    , AdvanceRecordData.Branch);
	Query.SetParameter("Currency"  , AdvanceRecordData.Currency);
	Query.SetParameter("Partner"   , AdvanceRecordData.Partner);
	Query.SetParameter("LegalName" , AdvanceRecordData.LegalName);
	Query.SetParameter("Agreement" , AdvanceRecordData.Agreement);
	Query.SetParameter("Order"     , ?(ValueIsFilled(AdvanceRecordData.Order), AdvanceRecordData.Order, Undefined));
	Query.SetParameter("Project"   , AdvanceRecordData.Project);


	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	AdvanceRecordDataWithoutOrder = CreateAdvanceRecordData(Parameters, AdvanceRecordData);
	AdvanceRecordDataWithoutOrder.Order = Parameters.Order_EmptyRef;
	
	NeedWriteAdvances = False;
	While QuerySelection.Next() Do
		If QuerySelection.AdvanceAmount < 0 Then
			Raise StrTemplate("Advance < 0 ADV_KEY[%1]", QuerySelection.AdvanceKey);
		EndIf;
		
		// Minus by advance with order
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Receipt, 
		                        Date, 
		                        AdvanceRecordData, // key with order
		                        -QuerySelection.AdvanceAmount, 
		                        Records_AdvancesKey);		
		NeedWriteAdvances = True;
		
		// Plus by advance without order
		Add_TM1020B_AdvancesKey(AccumulationRecordType.Receipt, 
		                        Date, 
		                        AdvanceRecordDataWithoutOrder, // key without order
		                        QuerySelection.AdvanceAmount, 
		                        Records_AdvancesKey);		
				
		// OffsetOfAdvances - minus with order (record type expense)
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.IsAdvanceRelease  = True;
		NewOffsetInfo.Period        = Date;
		NewOffsetInfo.Amount        = QuerySelection.AdvanceAmount;
		NewOffsetInfo.Document      = Document;
		
		NewOffsetInfo.Company       = AdvanceRecordData.Company;
		NewOffsetInfo.Branch        = AdvanceRecordData.Branch;
		NewOffsetInfo.Currency      = AdvanceRecordData.Currency;
		NewOffsetInfo.Partner       = AdvanceRecordData.Partner;
		NewOffsetInfo.LegalName     = AdvanceRecordData.LegalName;
		
		NewOffsetInfo.AdvanceOrder     = AdvanceRecordData.Order;
		NewOffsetInfo.Agreement        = AdvanceRecordData.Agreement;
		NewOffsetInfo.AdvanceProject   = AdvanceRecordData.Project;
		
		// OffsetOfAdvances - plus without order (record type expense)
		NewOffsetInfo = Records_OffsetOfAdvances.Add();
		NewOffsetInfo.IsAdvanceRelease = True;
		NewOffsetInfo.Period       = Date;
		NewOffsetInfo.Amount       = -QuerySelection.AdvanceAmount;
		NewOffsetInfo.Document     = Document;
		
		NewOffsetInfo.Company      = AdvanceRecordData.Company;
		NewOffsetInfo.Branch       = AdvanceRecordData.Branch;
		NewOffsetInfo.Currency     = AdvanceRecordData.Currency;
		NewOffsetInfo.Partner      = AdvanceRecordData.Partner;
		NewOffsetInfo.LegalName    = AdvanceRecordData.LegalName;
		
		NewOffsetInfo.Agreement        = AdvanceRecordData.Agreement;
		NewOffsetInfo.AdvanceProject   = AdvanceRecordData.Project;
	EndDo;
	If NeedWriteAdvances Then
		Write_TM1020B_AdvancesKey(Parameters, Records_AdvancesKey);
	EndIf;
	Return AdvanceRecordDataWithoutOrder;
EndFunction

Function CreateAdvanceRecordData(Parameters, RecordData)
	AdvanceRecordData = New Structure();
	AdvanceRecordData.Insert("Company"   , RecordData.Company);
	AdvanceRecordData.Insert("Branch"    , RecordData.Branch);
	AdvanceRecordData.Insert("Currency"  , RecordData.Currency);
	AdvanceRecordData.Insert("Partner"   , RecordData.Partner);
	AdvanceRecordData.Insert("LegalName" , RecordData.LegalName);
	AdvanceRecordData.Insert("Agreement" , RecordData.Agreement);
	AdvanceRecordData.Insert("Order"     , RecordData.Order);
	AdvanceRecordData.Insert("Project"   , RecordData.Project);
	AdvanceRecordData.Insert(Parameters.AdvanceType , True);
	Return AdvanceRecordData;
EndFunction

Procedure CreateAdvancesKeys(Parameters, Records_AdvancesKey, Records_OffsetOfAdvances, Table_DocumentAndAdvancesKey)
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
	|	AdvInfo.AdvanceAgreement AS Agreement,
	|	AdvInfo.Project,
	|	AdvInfo.RecordType,
	|	CASE
	|		WHEN AdvInfo.Order.Ref IS NULL
	|			THEN &Order_EmptyRef
	|		ELSE AdvInfo.Order
	|	END AS Order,
	|	AdvInfo.%1
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
	|			THEN &Order_EmptyRef
	|		ELSE AdvInfo.Order
	|	END,
	|	AdvInfo.Recorder,
	|	AdvInfo.%1";
 
    Query.Text = StrTemplate(Query.Text, Parameters.OrderCloseType, Parameters.AdvanceType);
	
	Query.SetParameter("BeginOfPeriod" , Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"   , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"       , Parameters.Object.Company);
	Query.SetParameter("Branch"        , Parameters.Object.Branch);
	Query.SetParameter("Order_EmptyRef", Parameters.Order_EmptyRef);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		
		RecordData = CreateAdvanceRecordData(Parameters, QuerySelection);
		
		Rows = Table_DocumentAndAdvancesKey.FindRows(RecordData); 
		If Rows.Count() Then
			AdvanceKeyUUID = Rows[0].AdvanceKeyUUID;
		Else
			AdvanceKeyUUID = New UUID();
		EndIf;
		
		If Not QuerySelection[Parameters.OrderCloseType] Then
			
			RecordType = AccumulationRecordType.Receipt;
			If QuerySelection.RecordType = Enums.RecordType.Expense Then
				RecordType = AccumulationRecordType.Expense;
			EndIf;
			
			Add_TM1020B_AdvancesKey(RecordType, 
		                            QuerySelection.Date,
		                            RecordData,
		                            QuerySelection.Amount, 
		                            Records_AdvancesKey);		
		EndIf;

		New_DocKeys = Table_DocumentAndAdvancesKey.Add();
		New_DocKeys.Document       = QuerySelection.Document;
		New_DocKeys.Amount         = QuerySelection.Amount;
		New_DocKeys.AdvanceKeyUUID = AdvanceKeyUUID;
		FillPropertyValues(New_DocKeys, RecordData);		
	EndDo;
EndProcedure

Function CreateTransactionRecordData(Parameters, RecordData)
	TransactionRecordData = New Structure();
	TransactionRecordData.Insert("Company"          , RecordData.Company);
	TransactionRecordData.Insert("Branch"           , RecordData.Branch);
	TransactionRecordData.Insert("Currency"         , RecordData.Currency);
	TransactionRecordData.Insert("Partner"          , RecordData.Partner);
	TransactionRecordData.Insert("LegalName"        , RecordData.LegalName);
	TransactionRecordData.Insert("Agreement"        , RecordData.Agreement);
	TransactionRecordData.Insert("TransactionBasis" , RecordData.TransactionBasis);
	TransactionRecordData.Insert("Order"            , RecordData.Order);
	TransactionRecordData.Insert("Project"          , RecordData.Project);
	TransactionRecordData.Insert(Parameters.TransactionType , True);
	Return TransactionRecordData;
EndFunction

Procedure CreateTransactionsKeys(Parameters, Records_TransactionsKey, Records_OffsetAging, Table_DocumentAndTransactionsKey)
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
	|			THEN &Order_EmptyRef
	|		ELSE TrnInfo.Order
	|	END AS Order,
	|	CASE
	|		WHEN TrnInfo.TransactionBasis.Ref IS NULL
	|			THEN UNDEFINED
	|		ELSE TrnInfo.TransactionBasis
	|	END AS TransactionBasis
	|FROM
	|	InformationRegister.T2015S_TransactionsInfo AS TrnInfo
	|WHERE
	|	TrnInfo.Date BETWEEN BEGINOFPERIOD(&BeginOfPeriod, DAY) AND ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND TrnInfo.Company = &Company
	|	AND TrnInfo.Branch = &Branch
	|	AND TrnInfo.%1";
	
	Query.Text = StrTemplate(Query.Text, Parameters.TransactionType);
	
	Query.SetParameter("BeginOfPeriod" , Parameters.Object.BeginOfPeriod);
	Query.SetParameter("EndOfPeriod"   , Parameters.Object.EndOfPeriod);
	Query.SetParameter("Company"       , Parameters.Object.Company);
	Query.SetParameter("Branch"        , Parameters.Object.Branch);
	Query.SetParameter("Order_EmptyRef", Parameters.Order_EmptyRef);

	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	While QuerySelection.Next() Do
		
		RecordData = CreateTransactionRecordData(Parameters, QuerySelection);
				
		Rows = Table_DocumentAndTransactionsKey.FindRows(RecordData); 
		If Rows.Count() Then
			TransactionKeyUUID = Rows[0].TransactionKeyUUID;
		Else
			TransactionKeyUUID = New UUID();
		EndIf;
				
		If QuerySelection.IsDue Then
			RecordType = AccumulationRecordType.Receipt;
		ElsIf QuerySelection.IsPaid Then
			RecordType = AccumulationRecordType.Expense;
		Else
			Continue;
		EndIf;
		
		Add_TM1030B_TransactionsKey(RecordType, 
		                            QuerySelection.Date, 
		                            RecordData, 
		                            QuerySelection.Amount, 
		                            Records_TransactionsKey);		
			
		New_DocKeys = Table_DocumentAndTransactionsKey.Add();
		New_DocKeys.Document = QuerySelection.Document;
		New_DocKeys.TransactionKeyUUID = TransactionKeyUUID;
		FillPropertyValues(New_DocKeys, RecordData);
		
		// Paid from customer or to vendor 
		If QuerySelection.IsPaid Then
			DistributeTransactionToAging(Parameters, 
										 QuerySelection.Document.PointInTime(), 
										 QuerySelection.Document,
										 RecordData, 
										 QuerySelection.Amount, 
										 Records_OffsetAging);
		EndIf;
	EndDo;
EndProcedure

Procedure ReturnMoneyByAging(Parameters, Document, TransactionData, TransactionAmount, Records_OffsetAging)
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
	Query.SetParameter("TransactionBasis", TransactionData.TransactionBasis);

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
		NewRow.Company     = TransactionData.Company;
		NewRow.Branch      = TransactionData.Branch;
		NewRow.Currency    = TransactionData.Currency;
		NewRow.Agreement   = TransactionData.Agreement;
		NewRow.Partner     = TransactionData.Partner;
		NewRow.Invoice     = TransactionData.TransactionBasis;
		NewRow.PaymentDate = QuerySelection.PaymentDate;
		NewRow.Amount      = CanWriteOff;
		NeedWriteAging = True;
	EndDo;
	If NeedWriteAging Then
		Write_Aging(Parameters, Document, Records_OffsetAging);
	EndIf;
EndProcedure

Procedure DistributeTransactionToAging(Parameters, PointInTime, Document, TransactionData, TransactionAmount, Records_OffsetAging)
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

	Query.SetParameter("Company"         , TransactionData.Company);
	Query.SetParameter("Branch"          , TransactionData.Branch);
	Query.SetParameter("Currency"        , TransactionData.Currency);
	Query.SetParameter("Agreement"       , TransactionData.Agreement);
	Query.SetParameter("Partner"         , TransactionData.Partner);
	Query.SetParameter("TransactionBasis", TransactionData.TransactionBasis);

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
		NewRow.Company     = TransactionData.Company;
		NewRow.Branch      = TransactionData.Branch;
		NewRow.Currency    = TransactionData.Currency;
		NewRow.Agreement   = TransactionData.Agreement;
		NewRow.Partner     = TransactionData.Partner;
		NewRow.Invoice     = TransactionData.TransactionBasis;
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
	                                                            AdvanceRecordData, 
	                                                            TransactionRecordData, 
	                                                            Records_OffsetOfAdvances)
	NewRecord = Records_OffsetOfAdvances.Add();
	NewRecord.RecordType  = RecordType;
	
	NewRecord.Period   = Period;
	NewRecord.Amount   = Amount;
	NewRecord.Document = Document;
		
	NewRecord.Company   = TransactionRecordData.Company;
	NewRecord.Branch    = TransactionRecordData.Branch;
	NewRecord.Currency  = TransactionRecordData.Currency;
	NewRecord.Partner   = TransactionRecordData.Partner;
	NewRecord.LegalName = TransactionRecordData.LegalName;
		
	NewRecord.TransactionDocument = TransactionRecordData.TransactionBasis;
		
	NewRecord.Agreement           = TransactionRecordData.Agreement;
	NewRecord.TransactionOrder    = TransactionRecordData.Order;
	NewRecord.TransactionProject  = TransactionRecordData.Project;
	NewRecord.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, TransactionRecordData, Document);
		
	NewRecord.Agreement           = AdvanceRecordData.Agreement;
	NewRecord.AdvanceProject      = AdvanceRecordData.Project;
	NewRecord.AdvanceOrder        = AdvanceRecordData.Order;
	NewRecord.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceRecordData, Document);
		
 	NewRecord.Key = NewRecord.TransactionsRowKey;
EndProcedure

Procedure Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(Parameters, 
	                                                            RecordType, 
	                                                            Period, 
	                                                            Amount, 
	                                                            Document, 
	                                                            AdvanceRecordData, 
	                                                            TransactionRecordData, 
	                                                            Records_OffsetOfAdvances,
	                                                            IsReturnToAdvance = False)
	NewRecord = Records_OffsetOfAdvances.Add();
	NewRecord.RecordType = RecordType;
	
	NewRecord.Period   = Period;
	NewRecord.Amount   = Amount;
	NewRecord.Document = Document;
		
	NewRecord.Company   = AdvanceRecordData.Company;
	NewRecord.Branch    = AdvanceRecordData.Branch;
	NewRecord.Currency  = AdvanceRecordData.Currency;
	NewRecord.Partner   = AdvanceRecordData.Partner;
	NewRecord.LegalName = AdvanceRecordData.LegalName;
		
	NewRecord.TransactionDocument = TransactionRecordData.TransactionBasis;
		
	NewRecord.Agreement           = TransactionRecordData.Agreement;
	NewRecord.TransactionOrder    = TransactionRecordData.Order;
	NewRecord.TransactionProject  = TransactionRecordData.Project;
	NewRecord.TransactionsRowKey  = FindRowKeyByTransactionKey(Parameters, TransactionRecordData, Document);
		
    NewRecord.Agreement           = AdvanceRecordData.Agreement;
    NewRecord.AdvanceOrder        = AdvanceRecordData.Order;
    NewRecord.AdvanceProject      = AdvanceRecordData.Project;
    NewRecord.AdvancesRowKey      = FindRowKeyByAdvanceKey(Parameters, AdvanceRecordData, Document);
		
	NewRecord.IsReturnToAdvance = IsReturnToAdvance; 
	
	If IsReturnToAdvance Then	
		NewRecord.Key = NewRecord.TransactionsRowKey;
	Else
		NewRecord.Key = NewRecord.AdvancesRowKey;
	EndIf;		
EndProcedure

Procedure Add_TM1020B_AdvancesKey(RecordType, Period, RecordData, Amount, Records_AdvancesKey)
	NewRecord = Records_AdvancesKey.Add();
	FillPropertyValues(NewRecord, RecordData);
	NewRecord.RecordType = RecordType;
	NewRecord.Period     = Period;
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

Procedure Add_TM1030B_TransactionsKey(RecordType, Period, RecordData, Amount, Records_TransactionsKey)
	NewRecord = Records_TransactionsKey.Add();
	FillPropertyValues(NewRecord, RecordData);
	NewRecord.RecordType     = RecordType;
	NewRecord.Period         = Period;
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
