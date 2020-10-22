#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerArTransactions"                 , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("AccountBalance_Receipt"                , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("AdvanceFromCustomers"                  , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("ReconciliationStatement"               , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("AccountBalance_Expense"                , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("CashInTransit_POS"                     , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("ExpensesTurnovers"                     , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("AccountBalance_Commission"             , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PartnerArTransactions_OffsetOfAdvance" , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("Aging_Expense"                         , PostingServer.CreateTable(AccReg.Aging));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextBankReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.PartnerArTransactions      = QueryResults[1].Unload();
	Tables.AccountBalance_Receipt     = QueryResults[2].Unload();
	Tables.PlaningCashTransactions    = QueryResults[3].Unload();
	Tables.CashInTransit              = QueryResults[4].Unload();
	Tables.AdvanceFromCustomers       = QueryResults[5].Unload();
	Tables.ReconciliationStatement    = QueryResults[6].Unload();
	Tables.AccountBalance_Expense     = QueryResults[7].Unload();
	Tables.CashInTransit_POS          = QueryResults[8].Unload();
	Tables.ExpensesTurnovers          = QueryResults[9].Unload();
	Tables.AccountBalance_Commission  = QueryResults[10].Unload();
	
	Return Tables;
EndFunction

Function GetQueryTextBankReceiptPaymentList()
	Return
		"SELECT
		|	BankReceiptPaymentList.Ref.Company AS Company,
		|	BankReceiptPaymentList.Ref.Currency AS Currency,
		|	BankReceiptPaymentList.Ref.CurrencyExchange AS CurrencyExchange,
		|	BankReceiptPaymentList.Ref.Account AS Account,
		|	BankReceiptPaymentList.Ref.TransitAccount AS TransitAccount,
		|	CASE
		|		WHEN BankReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN (VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				OR VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement))
		|				AND NOT BankReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|				AND
		|					BankReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> BankReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|					THEN BankReceiptPaymentList.PlaningTransactionBasis
		|				ELSE BankReceiptPaymentList.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	CASE
		|		WHEN BankReceiptPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND NOT CASE
		|		WHEN (VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		OR VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement))
		|		AND NOT BankReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> BankReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsAdvance,
		|	BankReceiptPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	CASE
		|		WHEN BankReceiptPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND BankReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN BankReceiptPaymentList.Agreement.StandardAgreement
		|		ELSE BankReceiptPaymentList.Agreement
		|	END AS Agreement,
		|	BankReceiptPaymentList.Partner AS Partner,
		|	BankReceiptPaymentList.Payer AS Payer,
		|	BankReceiptPaymentList.Ref.Date AS Period,
		|	BankReceiptPaymentList.Amount AS Amount,
		|	BankReceiptPaymentList.AmountExchange AS AmountExchange,
		|	CASE
		|		WHEN VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND NOT BankReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankReceiptPaymentList.PlaningTransactionBasis.SendCurrency = BankReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND NOT BankReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> BankReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	CASE
		|		WHEN VALUETYPE(BankReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement)
		|		AND NOT BankReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS TransferFromPOS,
		|	BankReceiptPaymentList.Ref.Account AS ToAccount_POS,
		|	BankReceiptPaymentList.POSAccount AS FromAccount_POS,
		|	BankReceiptPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	BankReceiptPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	BankReceiptPaymentList.Ref AS ReceiptDocument,
		|	BankReceiptPaymentList.Key,
		|	BankReceiptPaymentList.BusinessUnit AS BusinessUnit,
		|	BankReceiptPaymentList.ExpenseType AS ExpenseType,
		|	BankReceiptPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	BankReceiptPaymentList.Commission AS Commission
		|FROM
		|	Document.BankReceipt.PaymentList AS BankReceiptPaymentList
		|WHERE
		|	BankReceiptPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.CurrencyExchange AS CurrencyExchange,
		|	QueryTable.Account AS Account,
		|	QueryTable.TransitAccount AS TransitAccount,
		|	QueryTable.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.IsAdvance AS IsAdvance,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.Payer AS Payer,
		|	QueryTable.Period AS Period,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.AmountExchange AS AmountExchange,
		|	QueryTable.IsMoneyTransfer AS IsMoneyTransfer,
		|	QueryTable.IsMoneyExchange AS IsMoneyExchange,
		|	QueryTable.FromAccount AS FromAccount,
		|	QueryTable.ToAccount AS ToAccount,
		|	QueryTable.ReceiptDocument AS ReceiptDocument,
		|	QueryTable.Key AS Key,
		|	QueryTable.TransferFromPOS AS TransferFromPOS,
		|	QueryTable.ToAccount_POS AS ToAccount_POS,
		|	QueryTable.FromAccount_POS AS FromAccount_POS,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType AS ExpenseType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.Commission AS Commission
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.Payer AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsAdvance
		|	AND
		|	NOT tmp.IsMoneyExchange
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END AS Partner,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Payer
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END AS LegalName,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	- tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.PlaningTransactionBasis.Date IS NULL
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	tmp.FromAccount AS FromAccount,
		|	tmp.ToAccount AS ToAccount,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyTransfer
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.Payer AS LegalName,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.ReceiptDocument,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsMoneyExchange
		|	AND
		|	NOT tmp.TransferFromPOS
		|	AND tmp.IsAdvance
		|;
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Payer AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsMoneyExchange
		|	AND
		|	NOT tmp.TransferFromPOS
		|GROUP BY
		|	tmp.Company,
		|	tmp.Payer,
		|	tmp.Currency,
		|	tmp.Period	
		|;
		|
		|//[7]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.TransitAccount AS Account,
		|	CASE
		|		WHEN tmp.IsMoneyExchange
		|			THEN tmp.CurrencyExchange
		|		ELSE tmp.Currency
		|	END AS Currency,
		|	CASE
		|		WHEN tmp.IsMoneyExchange
		|			THEN tmp.AmountExchange
		|		ELSE tmp.Amount
		|	END AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyExchange
		|;
		|//[8]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	tmp.FromAccount_POS AS FromAccount,
		|	tmp.ToAccount_POS AS ToAccount,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.TransferFromPOS
		|;
		|//[9]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Commission AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Commission <> 0
		|;
		|//[10]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.Commission AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Commission <> 0
		|";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerArTransactions
	PartnerArTransactions = 
	AccumulationRegisters.PartnerArTransactions.GetLockFields(DocumentDataTables.PartnerArTransactions);
	DataMapWithLockFields.Insert(PartnerArTransactions.RegisterName, PartnerArTransactions.LockInfo);
	
	// AccountBalance
	AccountBalance = AccumulationRegisters.AccountBalance.GetLockFields(DocumentDataTables.AccountBalance_Expense);
	DataMapWithLockFields.Insert(AccountBalance.RegisterName, AccountBalance.LockInfo);
	
	// PlaningCashTransactions
	PlaningCashTransactions = 
	AccumulationRegisters.PlaningCashTransactions.GetLockFields(DocumentDataTables.PlaningCashTransactions);
	DataMapWithLockFields.Insert(PlaningCashTransactions.RegisterName, PlaningCashTransactions.LockInfo);
	
	// CashInTransit
	CashInTransit = AccumulationRegisters.CashInTransit.GetLockFields(DocumentDataTables.CashInTransit);
	DataMapWithLockFields.Insert(CashInTransit.RegisterName, CashInTransit.LockInfo);
	
	// AdvanceFromCustomers
	AdvanceFromCustomers = 
	AccumulationRegisters.AdvanceFromCustomers.GetLockFields(DocumentDataTables.AdvanceFromCustomers);
	DataMapWithLockFields.Insert(AdvanceFromCustomers.RegisterName, AdvanceFromCustomers.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement = 
	AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance from customers
	Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance =
	AccumulationRegisters.PartnerArTransactions.GetTablePartnerArTransactions_OffsetOfAdvance(
		Parameters.Object.RegisterRecords,
		Parameters.PointInTime,
		Parameters.DocumentDataTables.AdvanceFromCustomers,
		Parameters.DocumentDataTables.PartnerArTransactions);
			
	// Aging expense
	Parameters.DocumentDataTables.Aging_Expense = 
		AccumulationRegisters.Aging.GetTableAging_Expense_OnMoneyReceipt(
		Parameters.PointInTime,
		Parameters.DocumentDataTables.PartnerArTransactions,
		Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PartnerArTransactions
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Company, BasisDocument, Partner, LegalName, Agreement, Currency, Amount"),
			Parameters.IsReposting));
		
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Vendor
			Or (Row.Agreement.Kind = Enums.AgreementKinds.Standard And Row.Partner.Vendor) Then
			NewRow = Table1.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAP = - Row.Amount;
		EndIf;
	EndDo;
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");	
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
	Table2.Columns.Amount.Name = "AdvanceToSuppliers";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
		If Row.Partner.Vendor Then
			NewRow = Table2.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceToSuppliers = - Row.Amount;
		EndIf;
	EndDo;
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
	Table3.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
		If Row.Partner.Customer Then
			NewRow = Table3.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceFromCustomers = Row.Amount;
		EndIf;
	EndDo;
	Table3.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table4.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table4);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer 
			Or (Row.Agreement.Kind = Enums.AgreementKinds.Standard And Row.Partner.Customer) Then
			NewRow = Table4.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = Row.Amount;
		EndIf;
	EndDo;
	Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table4);
	
	Table5 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.CopyColumns();
	Table5.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table5);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance Do
		If Row.Partner.Customer Then
			NewRow = Table5.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.AdvanceFromCustomers = Row.Amount;
		EndIf;
	EndDo;
	Table5.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table5);
	
	Table6 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.CopyColumns();
	Table6.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table6);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer 
			Or (Row.Agreement.Kind = Enums.AgreementKinds.Standard And Row.Partner.Customer) Then
			NewRow = Table6.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = Row.Amount;
		EndIf;
	EndDo;
	Table6.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table6);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSuppliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
		
	// AccountBalance
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.AccountBalance_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AccountBalance_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AccountBalance_Commission.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Account, Currency, Amount, Key"),
			Parameters.IsReposting));
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PlaningCashTransactions));
	
	// CashInIransit
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.CashInTransit.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.CashInTransit_POS.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, FromAccount, ToAccount, Currency, Amount, Key"),
			Parameters.IsReposting));
	
	// AdvanceFromCustomers
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.AdvanceFromCustomers.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions_OffsetOfAdvance.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Company, Partner, LegalName, Currency, ReceiptDocument, Amount"),
			Parameters.IsReposting));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ExpensesTurnovers));
	
	// Aging
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.Aging,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.Aging_Expense));
	
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

Procedure FillAttributesByType(TransactionType, ArrayAll, ArrayByType) Export
	
	ArrayAll = New Array();
	ArrayAll.Add("Account");
	ArrayAll.Add("Company");
	ArrayAll.Add("Currency");
	ArrayAll.Add("TransactionType");
	ArrayAll.Add("CurrencyExchange");
	ArrayAll.Add("Payer");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("TransitAccount");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payer");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	ArrayAll.Add("PaymentList.AmountExchange");
	
	ArrayByType = New Array();
	If TransactionType = Enums.IncomingPaymentTransactionType.CashTransferOrder
		OR TransactionType = Enums.IncomingPaymentTransactionType.TransferFromPOS Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("CurrencyExchange");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.AmountExchange");
		
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.PaymentFromCustomer Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payer");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payer");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.Agreement");
	Else // empty
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("CurrencyExchange");
		ArrayByType.Add("Payer");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payer");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.AmountExchange");
		
	EndIf;
	
EndProcedure