#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerApTransactions"                 , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PartnerArTransactions"                 , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("RevenuesTurnovers"                     , PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	Tables.Insert("ReconciliationStatement"               , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("PartnerArTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceFromCustomers_Lock"             , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Transactions.Ref.Company AS Company,
		|	Transactions.Ref.Date AS Period,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		|	Transactions.AdditionalAnalytic AS AdditionalAnalytic,
		|	Transactions.Currency AS Currency,
		|	Transactions.BasisDocument AS BasisDocument,
		|	Transactions.BusinessUnit AS BusinessUnit,
		|	Transactions.RevenueType AS RevenueType,
		|	CASE
		|		WHEN Transactions.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN Transactions.Agreement.StandardAgreement
		|		ELSE Transactions.Agreement
		|	END AS Agreement,
		|	Transactions.Partner AS Partner,
		|	Transactions.LegalName AS LegalName,
		|	Transactions.Amount AS Amount,
		|	Transactions.Key AS Key
		|INTO tmp
		|FROM
		|	Document.DebitNote.Transactions AS Transactions
		|WHERE
		|	Transactions.Ref = &Ref
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	-tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key,
		|	tmp.IsVendor,
		|	tmp.IsCustomer
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsVendor
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key,
		|	tmp.IsVendor,
		|	tmp.IsCustomer
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsCustomer
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.RevenueType AS RevenueType,
		|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|//[5]////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS DocumentAmount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key,
		|	tmp.IsVendor,
		|	tmp.IsCustomer
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsCustomer";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PartnerApTransactions     = QueryResults[1].Unload();
	Tables.PartnerArTransactions     = QueryResults[2].Unload();
	Tables.RevenuesTurnovers         = QueryResults[3].Unload();
	Tables.ReconciliationStatement   = QueryResults[4].Unload();
	Tables.AdvanceFromCustomers_Lock = QueryResults[5].Unload();
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	PartnerApTransactions = AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
	// PartnerArTransactions
	PartnerArTransactions = AccumulationRegisters.PartnerArTransactions.GetLockFields(DocumentDataTables.PartnerArTransactions);
	DataMapWithLockFields.Insert(PartnerArTransactions.RegisterName, PartnerArTransactions.LockInfo);
	
	// RevenuesTurnovers
	RevenuesTurnovers = AccumulationRegisters.RevenuesTurnovers.GetLockFields(DocumentDataTables.RevenuesTurnovers);
	DataMapWithLockFields.Insert(RevenuesTurnovers.RegisterName, RevenuesTurnovers.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement = AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance from customers
	Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance =
		AccumulationRegisters.AdvanceFromCustomers.GetTableAdvanceFromCustomers_OffsetOfAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceFromCustomers_Lock);
			
	If Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Count() Then
    	Query = New Query();
    	Query.Text = 
    	"SELECT
    	|	tmp.Company,
    	|	tmp.Partner,
    	|	tmp.LegalName,
    	|	tmp.BasisDocument,
    	|	tmp.Currency,
    	|	tmp.Amount
    	|INTO tmp
    	|FROM
    	|	&QueryTable AS tmp
    	|;
    	|////////////////////////////////////////////////////////////////////////////////
    	|SELECT
    	|	AccountsStatementBalance.Company,
    	|	AccountsStatementBalance.Partner,
    	|	AccountsStatementBalance.LegalName,
    	|	AccountsStatementBalance.Currency,
    	|	&Period AS Period,
    	|	AccountsStatementBalance.AdvanceToSuppliersBalance AS AdvanceToSuppliersBalance,
    	|	-tmp.Amount AS AdvanceToSuppliers
    	|FROM
    	|	AccumulationRegister.AccountsStatement.Balance(&PointInTime, (Company, Partner, LegalName, Currency) IN
    	|		(SELECT
    	|			tmp.Company,
    	|			tmp.Partner,
    	|			tmp.LegalName,
    	|			tmp.Currency
    	|		FROM
    	|			tmp AS tmp)) AS AccountsStatementBalance
    	|		INNER JOIN tmp AS tmp
    	|		ON AccountsStatementBalance.Company = tmp.Company
    	|		AND AccountsStatementBalance.Partner = tmp.Partner
    	|		AND AccountsStatementBalance.LegalName = tmp.LegalName
    	|		AND AccountsStatementBalance.Currency = tmp.Currency";
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("PartnerArTransactions_OffsetOfAdvance_AccountStatement",
    	Query.Execute().Unload());
    EndIf;	
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.CopyColumns();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	For Each Row In Parameters.DocumentDataTables.PartnerApTransactions Do
		If Row.IsVendor Then
			NewRow = Table1.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAP = Row.Amount;
		EndIf;
	EndDo;
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");	
	ArrayOfTables.Add(Table1);
		
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.IsCustomer Then
			NewRow = Table2.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = Row.Amount;
		EndIf;
	EndDo;
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table3.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table4.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table4);
	Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table4);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSuppliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
			
	// PartnerApTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.PartnerApTransactions));

	// PartnerArTransactions
	// PartnerArTransactions [Receipt]  
	// PartnerArTransactions_OffsetOfAdvance [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
				True));
		
	// RevenuesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RevenuesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.RevenuesTurnovers));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
	New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance));
	
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
