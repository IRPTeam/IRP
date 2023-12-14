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

	QueryPaymentList = New Query;
	QueryPaymentList.Text = GetQueryTextCashPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();

	Query = New Query;
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();

	Tables.CashInTransit = QueryResults[1].Unload();

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	
	Return Tables;
EndFunction

Function GetQueryTextCashPaymentPaymentList()
	Return "SELECT
		   |	CashPaymentPaymentList.Ref.Company AS Company,
		   |	CashPaymentPaymentList.Ref.Currency AS Currency,
		   |	CashPaymentPaymentList.Ref.CashAccount AS CashAccount,
		   |	CASE
		   |		WHEN CashPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN CASE
		   |				WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |				AND
		   |				NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		   |				AND
		   |					CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |					THEN CashPaymentPaymentList.PlaningTransactionBasis
		   |				ELSE CashPaymentPaymentList.BasisDocument
		   |			END
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	CASE
		   |		WHEN CashPaymentPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END
		   |	AND
		   |	NOT CASE
		   |		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |		AND
		   |		NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		   |		AND
		   |			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsAdvance,
		   |	CashPaymentPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		   |	CASE
		   |		WHEN CashPaymentPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND CashPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN CashPaymentPaymentList.Agreement.StandardAgreement
		   |		ELSE CashPaymentPaymentList.Agreement
		   |	END AS Agreement,
		   |	CashPaymentPaymentList.Partner AS Partner,
		   |	CashPaymentPaymentList.Payee AS Payee,
		   |	CashPaymentPaymentList.Ref.Date AS Period,
		   |	CashPaymentPaymentList.TotalAmount AS Amount,
		   |	CASE
		   |		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |		AND
		   |		NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		   |		AND
		   |			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency = CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsMoneyTransfer,
		   |	CASE
		   |		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		   |		AND
		   |		NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		   |		AND
		   |			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency <> CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		   |			THEN TRUE
		   |		ELSE FALSE
		   |	END AS IsMoneyExchange,
		   |	CashPaymentPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		   |	CashPaymentPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		   |	CashPaymentPaymentList.Ref AS PaymentDocument,
		   |	CashPaymentPaymentList.Key AS Key,
		   |	CashPaymentPaymentList.Ref.Branch AS Branch
		   |FROM
		   |	Document.CashPayment.PaymentList AS CashPaymentPaymentList
		   |WHERE
		   |	CashPaymentPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return "SELECT
		   |	QueryTable.Company AS Company,
		   |	QueryTable.Currency AS Currency,
		   |	QueryTable.CashAccount AS CashAccount,
		   |	QueryTable.BasisDocument AS BasisDocument,
		   |	QueryTable.IsAdvance AS IsAdvance,
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
		   |	SUM(tmp.Amount) AS Amount,
		   |	tmp.Period,
		   |	tmp.Key
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
		   |	tmp.Period,
		   |	tmp.Key";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3015B_CashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2023B_AdvancesFromRetailCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R9510B_SalaryPayment.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	
	// CashInIransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit, New Structure("RecordType, RecordSet", AccumulationRecordType.Receipt, Parameters.DocumentDataTables.CashInTransit));

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

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2023B_AdvancesFromRetailCustomers());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3015B_CashAdvance());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3025B_PurchaseOrdersToBePaid());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function PaymentList()
	Return 
		"SELECT
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Ref.Currency AS Currency,
		|	PaymentList.Agreement AS Agreement,
		|	PaymentList.Ref.CashAccount AS CashAccount,
		|	PaymentList.Key AS Key,
		|	PaymentList.Ref AS Basis,
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
		|		WHEN PaymentList.Agreement.Ref IS NULL
		|			THEN TRUE
		|		ELSE CASE
		|			WHEN PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			AND PaymentList.BasisDocument.Ref IS NULL
		|				THEN TRUE
		|			ELSE FALSE
		|		END
		|	END AS IsAdvance,
		|	PaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	PaymentList.PlaningTransactionBasis.PlanningPeriod AS PlanningPeriod,
		|	PaymentList.PaymentPeriod AS PaymentPeriod,
		|	PaymentList.Partner.Employee AS IsEmployee,
		|	PaymentList.TotalAmount AS Amount,
		|	PaymentList.FinancialMovementType AS FinancialMovementType,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS IsPaymentToVendor,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CurrencyExchange) AS IsCurrencyExchange,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CashTransferOrder) AS
		|		IsCashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS IsReturnToCustomer,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CustomerAdvance) AS IsCustomerAdvance,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance) AS
		|		IsEmployeeCashAdvance,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.SalaryPayment) AS IsSalaryPayment,
		|	PaymentList.RetailCustomer AS RetailCustomer,
		|	PaymentList.Employee AS Employee,
		|	PaymentList.Partner,
		|	PaymentList.Ref.Branch AS Branch,
		|	PaymentList.LegalNameContract AS LegalNameContract,
		|	PaymentList.Order,
		|	PaymentList.ReceiptingBranch,
		|	case
		|		when PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		|		and NOT PaymentList.PlaningTransactionBasis.Ref IS NULL
		|			then PaymentList.PlaningTransactionBasis.ReceiveCurrency
		|		else PaymentList.Ref.Currency
		|	end as ReceiptingCurrency,
		|	PaymentList.ReceiptingAccount,
		|	case
		|		when PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		|			then PaymentList.PlaningTransactionBasis.Ref
		|	end as CashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.OtherPartner) AS IsOtherPartner,
		|	PaymentList.CashFlowCenter
		|INTO PaymentList
		|FROM
		|	Document.CashPayment.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R3021B_CashInTransitIncoming()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.ReceiptingBranch AS Branch,
		|	PaymentList.ReceiptingCurrency AS Currency,
		|	PaymentList.ReceiptingAccount AS Account,
		|	PaymentList.CashTransferOrder AS Basis,
		|	PaymentList.Key,
		|	PaymentList.Amount
		|INTO R3021B_CashInTransitIncoming
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCashTransferOrder
		|	OR PaymentList.IsCurrencyExchange";
EndFunction

Function R9510B_SalaryPayment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Key,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Employee,
		   |	PaymentList.PaymentPeriod,
		   |	PaymentList.Currency,
		   |	PaymentList.Amount
		   |INTO R9510B_SalaryPayment
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsSalaryPayment";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Key,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.Currency,
		   |	PaymentList.Amount
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsEmployeeCashAdvance";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument AS Basis,
		   |	PaymentList.Order,
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
		   |	OffsetOfAdvances.TransactionOrder,
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
		   |	PaymentList.LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Agreement,
		   |	PaymentList.TransactionDocument AS Basis,
		   |	PaymentList.Key,
		   |	-PaymentList.Amount AS Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnToCustomer
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

Function R5015B_OtherPartnersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
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

Function R1020B_AdvancesToVendors()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.Currency,
		   |	PaymentList.Order,
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
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
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

Function R2020B_AdvancesFromCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.Currency,
		   |	-PaymentList.Amount AS Amount,
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

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
		   |	OR PaymentList.IsReturnToCustomer
		   |	OR PaymentList.IsOtherPartner";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.CashAccount AS Account,
		   |	*
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	TRUE";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.CashAccount AS Account,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.CashFlowCenter,
		   |	PaymentList.PlanningPeriod,
		   |	PaymentList.Currency,
		   |	PaymentList.Key AS Key,
		   |	PaymentList.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	TRUE";
EndFunction

Function R3015B_CashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentList.PlaningTransactionBasis AS Basis,
		   |	*
		   |INTO R3015B_CashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsCurrencyExchange
		   |	AND PaymentList.IsEmployee";
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.PlaningTransactionBasis AS BasisDocument,
		   |	PaymentList.PlaningTransactionBasis.PlanningPeriod AS PlanningPeriod,
		   |	PaymentList.CashAccount AS Account,
		   |	PaymentList.Currency,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		   |			THEN PaymentList.Partner
		   |		ELSE VALUE(Catalog.Partners.EmptyRef)
		   |	END AS Partner,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		   |			THEN PaymentList.LegalName
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

Function R3025B_PurchaseOrdersToBePaid()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.Order,
		   |	PaymentList.Amount
		   |INTO R3025B_PurchaseOrdersToBePaid
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	NOT PaymentList.Order.Ref IS NULL";
EndFunction

Function T2014S_AdvancesInfo()
	Return "SELECT
		   |	PaymentList.Period AS Date,
		   |	PaymentList.Key,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Currency,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.Order,
		   |	TRUE AS IsVendorAdvance,
		   |	FALSE AS IsCustomerAdvance,
		   |	PaymentList.Amount
		   |INTO T2014S_AdvancesInfo
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
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
		   |	PaymentList.LegalName,
		   |	UNDEFINED,
		   |	FALSE,
		   |	TRUE,
		   |	-PaymentList.Amount AS Amount
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnToCustomer
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
		   |	PaymentList.LegalName,
		   |	PaymentList.Agreement,
		   |	PaymentList.Order,
		   |	TRUE AS IsVendorTransaction,
		   |	FALSE AS IsCustomerTransaction,
		   |	PaymentList.TransactionDocument AS TransactionBasis,
		   |	PaymentList.Amount AS Amount,
		   |	TRUE AS IsPaid
		   |INTO T2015S_TransactionsInfo
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentToVendor
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
		   |	PaymentList.LegalName,
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
		   |	PaymentList.IsReturnToCustomer
		   |	AND NOT PaymentList.IsAdvance";
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
	AccessKeyMap.Insert("Account", Obj.CashAccount);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand) AS
		|		Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	If Parameters.Operation = Catalogs.AccountingOperations.CashPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand Then
		Return GetAnalytics_PaymentToVendor(Parameters); // Vendors transactions - Cash on hand
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CashPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors Then
		Return GetAnalytics_OffsetOfAdvances(Parameters); // Vendors transactions - Advances to vendors 
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Vendors transactions - Cash on hand
Function GetAnalytics_PaymentToVendor(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.RowData.Partner, Parameters.RowData.Agreement);
	IsAdvance = AccountingServer.IsAdvance(Parameters.RowData);
	If IsAdvance Then
		If ValueIsFilled(Debit.AccountAdvancesVendor) Then
			AccountingAnalytics.Debit = Debit.AccountAdvancesVendor;
		EndIf;
	Else
		If ValueIsFilled(Debit.AccountTransactionsVendor) Then
			AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
		EndIf;
	EndIf;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, Parameters.ObjectData.CashAccount);
	If ValueIsFilled(Credit.Account) Then
		AccountingAnalytics.Credit = Credit.Account;
	EndIf;
	// Credit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.CashAccount);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors
Function GetAnalytics_OffsetOfAdvances(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.RowData.Partner, Parameters.RowData.Agreement);
	If ValueIsFilled(Accounts.AccountTransactionsVendor) Then
		AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	EndIf;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	If ValueIsFilled(Accounts.AccountAdvancesVendor) Then
		AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;
	EndIf;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion