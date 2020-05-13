#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerApTransactions", PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("AccountBalance_Expense", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PlaningCashTransactions", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit", PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("AdvanceToSuppliers", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReconciliationStatement", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("AccountBalance_Receipt", PostingServer.CreateTable(AccReg.AccountBalance));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextBankPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.PartnerApTransactions = QueryResults[1].Unload();
	Tables.AccountBalance_Expense = QueryResults[2].Unload();
	Tables.PlaningCashTransactions = QueryResults[3].Unload();
	Tables.CashInTransit = QueryResults[4].Unload();
	Tables.AdvanceToSuppliers = QueryResults[5].Unload();
	Tables.ReconciliationStatement = QueryResults[6].Unload();
	Tables.AccountBalance_Receipt = QueryResults[7].Unload();
	
	Return Tables;
EndFunction

Function GetQueryTextBankPaymentPaymentList()
	Return
		"SELECT
		|	BankPaymentPaymentList.Ref.Company AS Company,
		|	BankPaymentPaymentList.Ref.Currency AS Currency,
		|	BankPaymentPaymentList.Ref.Account AS Account,
		|	BankPaymentPaymentList.Ref.TransitAccount AS TransitAccount,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND
		|				NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|				AND
		|					BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|					THEN BankPaymentPaymentList.PlaningTransactionBasis
		|				ELSE BankPaymentPaymentList.BasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND
		|	NOT CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsAdvance,
		|	BankPaymentPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	CASE
		|		WHEN BankPaymentPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND BankPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN BankPaymentPaymentList.Agreement.StandardAgreement
		|		ELSE BankPaymentPaymentList.Agreement
		|	END AS Agreement,
		|	BankPaymentPaymentList.Partner AS Partner,
		|	BankPaymentPaymentList.Payee AS Payee,
		|	BankPaymentPaymentList.Ref.Date AS Period,
		|	BankPaymentPaymentList.Amount AS Amount,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency = BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	BankPaymentPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	BankPaymentPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	BankPaymentPaymentList.Ref AS PaymentDocument,
		|	BankPaymentPaymentList.Key AS Key
		|FROM
		|	Document.BankPayment.PaymentList AS BankPaymentPaymentList
		|WHERE
		|	BankPaymentPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Account AS Account,
		|	QueryTable.TransitAccount AS TransitAccount,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.IsAdvance,
		|	QueryTable.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.Payee AS Payee,
		|	QueryTable.Period AS Period,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.IsMoneyTransfer AS IsMoneyTransfer,
		|	QueryTable.IsMoneyExchange AS IsMoneyExchange,
		|	QueryTable.FromAccount AS FromAccount,
		|	QueryTable.ToAccount AS ToAccount,
		|	QueryTable.PaymentDocument AS PaymentDocument,
		|	QueryTable.Key AS Key
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
		|	tmp.Payee AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
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
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.Payee,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
		|	tmp.Key
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.Key
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Account AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END AS Partner,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Payee
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END AS LegalName,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.PlaningTransactionBasis.Date IS NULL
		|GROUP BY
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period,
		|	VALUE(Enum.CashFlowDirections.Outgoing),
		|	tmp.PlaningTransactionBasis,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Payee
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END,
		|	tmp.Key
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	tmp.FromAccount AS FromAccount,
		|	tmp.ToAccount AS ToAccount,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyTransfer
		|GROUP BY
		|	tmp.Company,
		|	tmp.PlaningTransactionBasis,
		|	tmp.FromAccount,
		|	tmp.ToAccount,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Partner AS Partner,
		|	tmp.Payee AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.PaymentDocument,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsMoneyExchange
		|	AND tmp.IsAdvance
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.Payee,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
		|	tmp.PaymentDocument,
		|	tmp.Key
		|;
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Payee AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsMoneyTransfer
		|	AND
		|	NOT tmp.IsMoneyExchange
		|GROUP BY
		|	tmp.Company,
		|	tmp.Payee,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[7]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.TransitAccount AS Account,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsMoneyExchange
		|GROUP BY
		|	tmp.Company,
		|	tmp.TransitAccount,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.Key";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	PartnerApTransactions = 
	AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
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
	
	// AdvanceToSuppliers
	AdvanceToSuppliers = AccumulationRegisters.AdvanceToSuppliers.GetLockFields(DocumentDataTables.AdvanceToSuppliers);
	DataMapWithLockFields.Insert(AdvanceToSuppliers.RegisterName, AdvanceToSuppliers.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement = 
	AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;	
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PartnerApTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerApTransactions));
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	Table1.Columns.Add("AdvanceToSupliers", Metadata.DefinedTypes.typeAmount.Type);
	Table1.Columns.Amount.Name = "TransactionAP";
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	Table2.Columns.Add("BasisDocument", Metadata.DefinedTypes.typeAccountStatementBasises.Type);
	Table2.Columns.Add("TransactionAP", Metadata.DefinedTypes.typeAmount.Type);
	Table2.Columns.Amount.Name = "AdvanceToSupliers";
	ArrayOfTables.Add(Table2);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, 
				|BasisDocument, Currency, TransactionAP, AdvanceToSupliers"),
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
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Account, Currency, Amount, Key"),
			Parameters.IsReposting));
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PlaningCashTransactions));
	
	// CashInIransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.CashInTransit));
	
	// AdvanceToSuppliers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AdvanceToSuppliers));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
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
	ArrayAll.Add("Payee");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("TransitAccount");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payee");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	
	ArrayByType = New Array();
	If TransactionType = Enums.OutgoingPaymentTransactionTypes.CashTransferOrder Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.CurrencyExchange Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.PaymentToVendor Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payee");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payee");
		ArrayByType.Add("PaymentList.Agreement");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	Else // empty
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payee");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payee");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	EndIf;
	
EndProcedure