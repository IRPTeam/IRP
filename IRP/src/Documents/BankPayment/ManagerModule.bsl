#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export

	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("CashInTransit", PostingServer.CreateTable(AccReg.CashInTransit));

	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextBankPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();

	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();

	Tables.CashInTransit           = QueryResults[1].Unload();

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion

	Return Tables;
EndFunction

Function GetQueryTextBankPaymentPaymentList()
	Return "SELECT
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
		   |	BankPaymentPaymentList.TotalAmount AS Amount,
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
		   |	BankPaymentPaymentList.Key AS Key,
		   |	BankPaymentPaymentList.ProfitLossCenter AS ProfitLossCenter,
		   |	BankPaymentPaymentList.ExpenseType AS ExpenseType,
		   |	BankPaymentPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	BankPaymentPaymentList.Commission AS Commission,
		   |	BankPaymentPaymentList.Ref.Branch AS Branch
		   |FROM
		   |	Document.BankPayment.PaymentList AS BankPaymentPaymentList
		   |WHERE
		   |	BankPaymentPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return "SELECT
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
		   |	QueryTable.Key AS Key,
		   |	QueryTable.ProfitLossCenter AS ProfitLossCenter,
		   |	QueryTable.ExpenseType AS ExpenseType,
		   |	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		   |	QueryTable.Commission AS Commission,
		   |	QueryTable.Branch
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
		   |	tmp.Key,
		   |	tmp.Branch
		   |FROM
		   |	tmp AS tmp
		   |WHERE
		   |	tmp.IsMoneyTransfer";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// CashInIransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit, New Structure("RecordType, RecordSet",
		AccumulationRecordType.Receipt, Parameters.DocumentDataTables.CashInTransit));

#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion

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

#Region NewRegistersPosting

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
Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(T2012S_PartnerAdvances());
	QueryArray.Add(T2011S_PartnerTransactions());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R5022T_Expenses());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return "SELECT
		   |	PaymentList.Ref.Company AS Company,
		   |	PaymentList.Ref.Currency AS Currency,
		   |	PaymentList.Ref.Account AS Account,
		   |	PaymentList.Ref.TransitAccount AS TransitAccount,
		   |	CASE
		   |		WHEN PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN CASE
		   |				WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |				AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |				AND PaymentList.PlaningTransactionBasis.SendCurrency <> PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |					THEN PaymentList.PlaningTransactionBasis
		   |				ELSE PaymentList.BasisDocument
		   |			END
		   |		ELSE UNDEFINED
		   |	END AS TransactionDocument,
		   |	CASE
		   |		WHEN PaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END
		   |	AND NOT CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |		AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |		AND PaymentList.PlaningTransactionBasis.SendCurrency <> PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsAdvance,
		   |	PaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		   |	CASE
		   |		WHEN PaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN PaymentList.Agreement.StandardAgreement
		   |		ELSE PaymentList.Agreement
		   |	END AS Agreement,
		   |	PaymentList.Partner AS Partner,
		   |	PaymentList.Payee AS Payee,
		   |	PaymentList.Ref.Date AS Period,
		   |	PaymentList.TotalAmount AS Amount,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |		AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |		AND PaymentList.PlaningTransactionBasis.SendCurrency = PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsMoneyTransfer,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |		AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
		   |		AND PaymentList.PlaningTransactionBasis.SendCurrency <> PaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsMoneyExchange,
		   |	PaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		   |	PaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		   |	PaymentList.Ref AS Basis,
		   |	PaymentList.Key AS Key,
		   |	PaymentList.ProfitLossCenter AS ProfitLossCenter,
		   |	PaymentList.ExpenseType AS ExpenseType,
		   |	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		   |	PaymentList.Commission AS Commission,
		   |	PaymentList.FinancialMovementType AS FinancialMovementType,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS IsPaymentToVendor,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CurrencyExchange) AS IsCurrencyExchange,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CashTransferOrder) AS
		   |		IsCashTransferOrder,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS IsReturnToCustomer,
		   |	PaymentList.Ref.Branch AS Branch,
		   |	PaymentList.LegalNameContract AS LegalNameContract
		   |INTO PaymentList
		   |FROM
		   |	Document.BankPayment.PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Ref = &Ref";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument AS Basis,
		   |	PaymentList.Key,
		   |	PaymentList.Amount,
		   |	UNDEFINED AS VendorsAdvancesClosing
		   |INTO R1021B_VendorsTransactions
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
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
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument AS Basis,
		   |	PaymentList.Key,
		   |	PaymentList.Amount
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnToCustomer
		   |	AND NOT PaymentList.IsAdvance";
EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Basis,
		   |	PaymentList.Amount,
		   |	PaymentList.Key,
		   |	UNDEFINED AS VendorsAdvancesClosing
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
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
		   |	OffsetOfAdvances.AdvancesDocument,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Basis,
		   |	PaymentList.Amount,
		   |	PaymentList.Key
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnToCustomer
		   |	AND PaymentList.IsAdvance";
EndFunction

Function R5012B_VendorsAging()
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
		   |INTO R5012B_VendorsAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref";
EndFunction

Function T2012S_PartnerAdvances()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Basis AS AdvancesDocument,
		   |	PaymentList.Amount,
		   |	PaymentList.Key,
		   |	TRUE AS IsVendorAdvance
		   |INTO T2012S_PartnerAdvances
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
		   |	AND PaymentList.IsAdvance";
EndFunction

Function T2011S_PartnerTransactions()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument,
		   |	PaymentList.Key,
		   |	PaymentList.Amount,
		   |	TRUE AS IsPaymentToVendor
		   |INTO T2011S_PartnerTransactions
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
		   |	AND NOT PaymentList.IsAdvance";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Payee AS LegalName,
		   |	PaymentList.LegalNameContract AS LegalNameContract,
		   |	PaymentList.Currency,
		   |	SUM(PaymentList.Amount) AS Amount,
		   |	PaymentList.Period
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
		   |	OR PaymentList.IsReturnToCustomer
		   |GROUP BY
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Payee,
		   |	PaymentList.LegalNameContract,
		   |	PaymentList.Currency,
		   |	PaymentList.Period,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	TRUE";
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
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		   |			THEN PaymentList.Partner
		   |		ELSE VALUE(Catalog.Partners.EmptyRef)
		   |	END AS Partner,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		   |			THEN PaymentList.Payee
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

#EndRegion