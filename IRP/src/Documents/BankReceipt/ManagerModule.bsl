#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure;
	Tables.Insert("CashInTransit", PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("CashInTransit_POS", PostingServer.CreateTable(AccReg.CashInTransit));

	QueryPaymentList = New Query;
	QueryPaymentList.Text = GetQueryTextBankReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();

	Query = New Query;
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();

	Tables.CashInTransit              = QueryResults[1].Unload();
	Tables.CashInTransit_POS          = QueryResults[2].Unload();

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Return Tables;
EndFunction

Function GetQueryTextBankReceiptPaymentList()
	Return "SELECT
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
		   |	BankReceiptPaymentList.TotalAmount AS Amount,
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
		   |	BankReceiptPaymentList.ProfitLossCenter AS ProfitLossCenter,
		   |	BankReceiptPaymentList.ExpenseType AS ExpenseType,
		   |	BankReceiptPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	BankReceiptPaymentList.Commission AS Commission,
		   |	BankReceiptPaymentList.Ref.Branch AS Branch
		   |FROM
		   |	Document.BankReceipt.PaymentList AS BankReceiptPaymentList
		   |WHERE
		   |	BankReceiptPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return "SELECT
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
		   |	QueryTable.ProfitLossCenter AS ProfitLossCenter,
		   |	QueryTable.ExpenseType AS ExpenseType,
		   |	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		   |	QueryTable.Commission AS Commission,
		   |	QueryTable.Branch AS Branch
		   |INTO tmp
		   |FROM
		   |	&QueryTable AS QueryTable
		   |;
		   |
		   |//[1]//////////////////////////////////////////////////////////////////////////////
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
		   |//[2]//////////////////////////////////////////////////////////////////////////////
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
		   |	tmp.TransferFromPOS";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2023B_AdvancesFromRetailCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	
	// CashInIransit
	ArrayOfTables = New Array;
	Table1 = Parameters.DocumentDataTables.CashInTransit.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);

	Table2 = Parameters.DocumentDataTables.CashInTransit_POS.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);

	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit, New Structure("RecordSet, WriteInTransaction", PostingServer.JoinTables(ArrayOfTables,
		"RecordType, Period, Company, BasisDocument, FromAccount, ToAccount, Currency, Amount, Key"), Parameters.IsReposting));

	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);

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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return "SELECT
		   |	PaymentList.Ref.Company AS Company,
		   |	PaymentList.Ref.Currency AS Currency,
		   |	PaymentList.Ref.CurrencyExchange AS CurrencyExchange,
		   |	PaymentList.Ref.Account AS Account,
		   |	PaymentList.Ref.TransitAccount AS TransitAccount,
		   |	CASE
		   |		WHEN PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN CASE
		   |					WHEN (VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |							OR VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement))
		   |							AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |							AND PaymentList.PlaningTransactionBasis.SendCurrency <> PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |						THEN PaymentList.PlaningTransactionBasis
		   |					ELSE PaymentList.BasisDocument
		   |				END
		   |		ELSE UNDEFINED
		   |	END AS TransactionDocument,
		   |	CASE
		   |		WHEN PaymentList.Agreement.Ref IS NULL
		   |			THEN TRUE
		   |		ELSE CASE
		   |				WHEN PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |						AND PaymentList.BasisDocument.Ref IS NULL
		   |					THEN TRUE
		   |				ELSE FALSE
		   |			END
		   |	END AS IsAdvance,
		   |	PaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		   |	CASE
		   |		WHEN PaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |				AND PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN PaymentList.Agreement.StandardAgreement
		   |		ELSE PaymentList.Agreement
		   |	END AS Agreement,
		   |	PaymentList.Partner AS Partner,
		   |	PaymentList.Payer AS Payer,
		   |	PaymentList.Ref.Date AS Period,
		   |	PaymentList.TotalAmount AS Amount,
		   |	PaymentList.AmountExchange AS AmountExchange,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |				AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |				AND PaymentList.PlaningTransactionBasis.SendCurrency = PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsMoneyTransfer,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |				AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |				AND PaymentList.PlaningTransactionBasis.SendCurrency <> PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsMoneyExchange,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement)
		   |				AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS TransferFromPOS,
		   |	PaymentList.Ref.Account AS ToAccount_POS,
		   |	PaymentList.POSAccount AS FromAccount_POS,
		   |	PaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		   |	PaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		   |	PaymentList.PlaningTransactionBasis.PlanningPeriod AS PlanningPeriod,
		   |	PaymentList.Ref AS Basis,
		   |	PaymentList.Key AS Key,
		   |	PaymentList.ProfitLossCenter AS ProfitLossCenter,
		   |	PaymentList.ExpenseType AS ExpenseType,
		   |	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	PaymentList.Commission AS Commission,
		   |	PaymentList.FinancialMovementType AS FinancialMovementType,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS IsPaymentFromCustomer,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS) AS IsPaymentFromCustomerByPOS,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange) AS IsCurrencyExchange,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.OtherIncome) AS IsOtherIncome,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder) AS IsCashTransferOrder,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.TransferFromPOS) AS IsTransferFromPOS,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS IsReturnFromVendor,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CustomerAdvance) AS IsCustomerAdvance,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.EmployeeCashAdvance) AS IsEmployeeCashAdvance,
		   |	PaymentList.RetailCustomer AS RetailCustomer,
		   |	PaymentList.BankTerm AS BankTerm,
		   |	PaymentList.Ref.Branch AS Branch,
		   |	PaymentList.LegalNameContract AS LegalNameContract,
		   |	PaymentList.Order AS Order,
		   |	PaymentList.PaymentType AS PaymentType,
		   |	PaymentList.PaymentTerminal AS PaymentTerminal,
		   |	PaymentList.CommissionIsSeparate AS CommissionIsSeparate,
		   |	CASE
		   |		WHEN PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		   |			THEN PaymentList.PlaningTransactionBasis.Sender
		   |	END AS AccountSender,
		   |	CASE
		   |		WHEN PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		   |			THEN PaymentList.PlaningTransactionBasis.Ref
		   |		ELSE NULL
		   |	END AS CashTransferOrder,
		   |	PaymentList.Agreement.Type = VALUE(Enum.AgreementTypes.Other) AS IsOtherPartner,
		   |	PaymentList.RevenueType AS RevenueType
		   |INTO PaymentList
		   |FROM
		   |	Document.BankReceipt.PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2023B_AdvancesFromRetailCustomers());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3024B_SalesOrdersToBePaid());
	QueryArray.Add(R3026B_SalesOrdersCustomerAdvance());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R3050T_PosCashBalances());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	Return QueryArray;
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Key,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Currency,
		   |	PaymentList.Amount - PaymentList.Commission AS Amount
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsEmployeeCashAdvance";
EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument AS Basis,
		   |	PaymentList.Order,
		   |	PaymentList.Key,
		   |	PaymentList.Amount AS Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2021B_CustomersTransactions
		   |	FROM PaymentList AS PaymentList
		   |WHERE
		   |	(PaymentList.IsPaymentFromCustomer OR PaymentList.IsPaymentFromCustomerByPOS)
		   |	AND NOT PaymentList.IsAdvance
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument,
		   |	OffsetOfAdvances.TransactionOrder,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument AS Basis,
		   |	PaymentList.Key,
		   |	-PaymentList.Amount AS Amount,
		   |	UNDEFINED AS VendorsAdvancesClosing
		   |INTO R1021B_VendorsTransactions
		   |	FROM PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnFromVendor
		   |	AND NOT PaymentList.IsAdvance
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.Key,
		   |	PaymentList.Amount AS Amount
		   |INTO R5015B_OtherPartnersTransactions
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsOtherPartner";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Order,
		   |	PaymentList.Amount,
		   |	PaymentList.Key,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	(PaymentList.IsPaymentFromCustomer OR PaymentList.IsPaymentFromCustomerByPOS)
		   |	AND PaymentList.IsAdvance
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.AdvancesOrder,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2023B_AdvancesFromRetailCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.RetailCustomer,
		   |	PaymentList.Amount,
		   |	PaymentList.Key
		   |INTO R2023B_AdvancesFromRetailCustomers
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsCustomerAdvance";
EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Currency,
		   |	-PaymentList.Amount AS Amount,
		   |	PaymentList.Key
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnFromVendor
		   |	AND PaymentList.IsAdvance";
EndFunction

Function R5011B_CustomersAging()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAging.Period,
		   |	OffsetOfAging.Company,
		   |	OffsetOfAging.Branch,
		   |	OffsetOfAging.Partner,
		   |	OffsetOfAging.Agreement,
		   |	OffsetOfAging.Currency,
		   |	OffsetOfAging.Invoice,
		   |	OffsetOfAging.PaymentDate,
		   |	OffsetOfAging.Amount,
		   |	OffsetOfAging.Recorder AS AgingClosing
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.LegalNameContract AS LegalNameContract,
		   |	PaymentList.Currency,
		   |	SUM(PaymentList.Amount) AS Amount,
		   |	PaymentList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	(PaymentList.IsPaymentFromCustomer OR PaymentList.IsPaymentFromCustomerByPOS)
		   |	OR PaymentList.IsReturnFromVendor OR PaymentList.IsOtherPartner
		   |GROUP BY
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Payer,
		   |	PaymentList.LegalNameContract,
		   |	PaymentList.Currency,
		   |	PaymentList.Period";
EndFunction

Function R3010B_CashOnHand()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Key,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	PaymentList.Currency,
		|	case
		|		when NOT PaymentList.CommissionIsSeparate
		|			then PaymentList.Amount + PaymentList.Commission
		|		else PaymentList.Amount
		|	end AS Amount
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Key,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	PaymentList.Currency,
		|	PaymentList.Commission AS Amount
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	((PaymentList.IsTransferFromPOS
		|	AND NOT PaymentList.CommissionIsSeparate)
		|	OR (PaymentList.IsPaymentFromCustomerByPOS))
		|	AND PaymentList.Commission <> 0";
EndFunction

Function R3011T_CashFlow()
	Return 
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS Direction,
		|	PaymentList.FinancialMovementType,
		|	PaymentList.PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	case
		|		when NOT PaymentList.CommissionIsSeparate
		|			then PaymentList.Amount + PaymentList.Commission
		|		else PaymentList.Amount
		|	end AS Amount
		|INTO R3011T_CashFlow
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		|	PaymentList.FinancialMovementType,
		|	PaymentList.PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.Commission
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	((PaymentList.IsTransferFromPOS
		|	AND NOT PaymentList.CommissionIsSeparate)
		|	OR (PaymentList.IsPaymentFromCustomerByPOS))
		|	AND PaymentList.Commission <> 0";
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.PlaningTransactionBasis AS BasisDocument,
		   |	PaymentList.PlaningTransactionBasis.PlanningPeriod AS PlanningPeriod,
		   |	PaymentList.Account,
		   |	PaymentList.Currency,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		   |			THEN PaymentList.Partner
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.ChequeBondTransactionItem)
		   |			THEN PaymentList.PlaningTransactionBasis.Partner
		   |		ELSE VALUE(Catalog.Partners.EmptyRef)
		   |	END AS Partner,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		   |			THEN PaymentList.Payer
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.ChequeBondTransactionItem)
		   |			THEN PaymentList.PlaningTransactionBasis.LegalName
		   |		ELSE VALUE(Catalog.Companies.EmptyRef)
		   |	END AS LegalName,
		   |	PaymentList.FinancialMovementType,
		   |	-PaymentList.Amount AS Amount,
		   |	PaymentList.Key
		   |INTO R3035T_CashPlanning
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	NOT PaymentList.PlaningTransactionBasis.Ref IS NULL";
EndFunction

Function R5021T_Revenues()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.ProfitLossCenter,
		   |	PaymentList.RevenueType,
		   |	PaymentList.Currency,
		   |	PaymentList.Amount,
		   |	PaymentList.Amount AS AmountWithTaxes
		   |INTO R5021T_Revenues
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsOtherIncome";
EndFunction

Function R5022T_Expenses()
	Return "SELECT
		   |	PaymentList.Commission AS Amount,
		   |	PaymentList.Commission AS AmountWithTaxes,
		   |	*
		   |INTO R5022T_Expenses
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Commission <> 0";
EndFunction

Function R3024B_SalesOrdersToBePaid()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Order,
		   |	PaymentList.Amount
		   |INTO R3024B_SalesOrdersToBePaid
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	NOT PaymentList.Order.Ref IS NULL
		   |	AND PaymentList.IsPaymentFromCustomer";
EndFunction

Function R3026B_SalesOrdersCustomerAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	VALUE(Enum.PaymentTypes.Card) AS PaymentTypeEnum,
		   |	PaymentList.RetailCustomer,
		   |	PaymentList.Order,
		   |	PaymentList.Account,
		   |	PaymentList.PaymentType,
		   |	PaymentList.PaymentTerminal,
		   |	PaymentList.BankTerm,
		   |	PaymentList.Commission,
		   |	PaymentList.Amount
		   |INTO R3026B_SalesOrdersCustomerAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	NOT PaymentList.Order.Ref IS NULL
		   |	AND PaymentList.IsCustomerAdvance";
EndFunction

Function T2014S_AdvancesInfo()
	Return "SELECT
		   |	PaymentList.Period AS Date,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Order,
		   |	TRUE AS IsCustomerAdvance,
		   |	FALSE AS IsVendorAdvance,
		   |	PaymentList.Amount
		   |INTO T2014S_AdvancesInfo
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	(PaymentList.IsPaymentFromCustomer OR PaymentList.IsPaymentFromCustomerByPOS)
		   |	AND PaymentList.IsAdvance
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer,
		   |	UNDEFINED,
		   |	FALSE,
		   |	TRUE,
		   |	-PaymentList.Amount AS Amount
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnFromVendor
		   |	AND PaymentList.IsAdvance";
EndFunction

Function T2015S_TransactionsInfo()
	Return "SELECT
		   |	PaymentList.Period AS Date,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Agreement,
		   |	PaymentList.Order,
		   |	TRUE AS IsCustomerTransaction,
		   |	FALSE AS IsVendorTransaction,
		   |	PaymentList.TransactionDocument AS TransactionBasis,
		   |	PaymentList.Amount AS Amount,
		   |	TRUE AS IsPaid
		   |INTO T2015S_TransactionsInfo
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	(PaymentList.IsPaymentFromCustomer OR PaymentList.IsPaymentFromCustomerByPOS)
		   |	AND NOT PaymentList.IsAdvance
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.Payer,
		   |	PaymentList.Agreement,
		   |	UNDEFINED,
		   |	FALSE,
		   |	TRUE,
		   |	PaymentList.TransactionDocument,
		   |	-PaymentList.Amount,
		   |	TRUE AS IsPaid
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnFromVendor
		   |	AND NOT PaymentList.IsAdvance";
EndFunction

Function R3050T_PosCashBalances()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.PaymentType,
		   |	PaymentList.Account,
		   |	PaymentList.PaymentTerminal,
		   |	PaymentList.Amount,
		   |	PaymentList.Commission
		   |INTO R3050T_PosCashBalances
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentFromCustomerByPOS
		   |	OR PaymentList.IsCustomerAdvance";
EndFunction

Function R3021B_CashInTransitIncoming()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.FromAccount_POS AS Account,
		|	PaymentList.Account AS ReceiptingAccount,
		|	PaymentList.PlaningTransactionBasis AS Basis,
		|	PaymentList.Commission + PaymentList.Amount AS Amount,
		|	PaymentList.Commission
		|INTO R3021B_CashInTransitIncoming
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsTransferFromPOS
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.AccountSender,
		|	PaymentList.Account,
		|	PaymentList.CashTransferOrder,
		|	PaymentList.Commission + PaymentList.Amount,
		|	PaymentList.Commission
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	(PaymentList.IsCashTransferOrder
		|	OR PaymentList.IsCurrencyExchange)
		|	AND NOT PaymentList.CashTransferOrder IS NULL";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	AccessKeyMap.Insert("Account", Obj.Account);
	Return AccessKeyMap;
EndFunction

#EndRegion