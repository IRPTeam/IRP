#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);

	Tables = New Structure;

	CashInTransit = Metadata.AccumulationRegisters.CashInTransit;
	Tables.Insert(CashInTransit.Name, CommonFunctionsServer.CreateTable(CashInTransit));
	
	Return Tables;
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
	Tables.R3015B_CashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2023B_AdvancesFromRetailCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	
	CashInTransit = Metadata.AccumulationRegisters.CashInTransit;
	PostingServer.SetPostingDataTable(PostingDataTables, Parameters, CashInTransit.Name, Parameters.DocumentDataTables[CashInTransit.Name]);
	
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
	QueryArray.Add(CashInTransit());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2023B_AdvancesFromRetailCustomers());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3015B_CashAdvance());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3024B_SalesOrdersToBePaid());
	QueryArray.Add(R3026B_SalesOrdersCustomerAdvance());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
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
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Ref.Currency AS Currency,
		|	PaymentList.Agreement AS Agreement,
		|	PaymentList.Ref.CashAccount AS CashAccount,
		|	PaymentList.Key AS Key,
		|	PaymentList.Ref AS Basis,
		|	CASE
		|		WHEN PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN (VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				OR VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement))
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
		|	PaymentList.Partner.Employee AS IsEmployee,
		|	PaymentList.TotalAmount AS Amount,
		|	PaymentList.FinancialMovementType AS FinancialMovementType,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS
		|		IsPaymentFromCustomer,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange) AS IsCurrencyExchange,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder) AS
		|		IsCashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS IsReturnFromVendor,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CashIn) AS IsCashIn,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CustomerAdvance) AS IsCustomerAdvance,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.EmployeeCashAdvance) AS
		|		IsEmployeeCashAdvance,
		|	PaymentList.RetailCustomer AS RetailCustomer,
		|	PaymentList.MoneyTransfer AS MoneyTransfer,
		|	PaymentList.MoneyTransfer.Sender AS AccountFrom,
		|	PaymentList.MoneyTransfer.Receiver AS AccountTo,
		|	PaymentList.Partner,
		|	PaymentList.Ref.Branch AS Branch,
		|	PaymentList.LegalNameContract AS LegalNameContract,
		|	PaymentList.Order,
		|	case
		|		when PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		|			then PaymentList.PlaningTransactionBasis.Ref
		|		else NULL
		|	end as CashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.OtherPartner) AS IsOtherPartner,
		|	PaymentList.CashFlowCenter
		|INTO PaymentList
		|FROM
		|	Document.CashReceipt.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables


Function CashInTransit()
	Return "SELECT
	|	CashReceiptPaymentList.Ref.Company AS Company,
	|	CashReceiptPaymentList.Ref.Currency AS Currency,
	|	CashReceiptPaymentList.Ref.CurrencyExchange AS CurrencyExchange,
	|	CashReceiptPaymentList.Ref.CashAccount AS CashAccount,
	|	CASE
	|		WHEN CashReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN CASE
	|				WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|				AND NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
	|				AND
	|					CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
	|					THEN CashReceiptPaymentList.PlaningTransactionBasis
	|				ELSE CashReceiptPaymentList.BasisDocument
	|			END
	|		ELSE UNDEFINED
	|	END AS BasisDocument,
	|	CASE
	|		WHEN CashReceiptPaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
	|			THEN TRUE
	|		ELSE FALSE
	|	END
	|	AND NOT CASE
	|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|		AND NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
	|		AND
	|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsAdvance,
	|	CashReceiptPaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
	|	CASE
	|		WHEN CashReceiptPaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
	|		AND CashReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
	|			THEN CashReceiptPaymentList.Agreement.StandardAgreement
	|		ELSE CashReceiptPaymentList.Agreement
	|	END AS Agreement,
	|	CashReceiptPaymentList.Partner AS Partner,
	|	CashReceiptPaymentList.Payer AS Payer,
	|	CashReceiptPaymentList.Ref.Date AS Period,
	|	CashReceiptPaymentList.TotalAmount AS Amount,
	|	CashReceiptPaymentList.AmountExchange AS AmountExchange,
	|	CASE
	|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|		AND NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
	|		AND
	|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency = CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsMoneyTransfer,
	|	CASE
	|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|		AND NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
	|		AND
	|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsMoneyExchange,
	|	CashReceiptPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
	|	CashReceiptPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
	|	CashReceiptPaymentList.Ref AS ReceiptDocument,
	|	CashReceiptPaymentList.Key AS Key,
	|	CashReceiptPaymentList.Ref.Branch AS Branch
	|INTO TablePaymentList
	|FROM
	|	Document.CashReceipt.PaymentList AS CashReceiptPaymentList
	|WHERE
	|	CashReceiptPaymentList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	tmp.Company AS Company,
	|	tmp.PlaningTransactionBasis AS BasisDocument,
	|	tmp.FromAccount AS FromAccount,
	|	tmp.ToAccount AS ToAccount,
	|	tmp.Currency AS Currency,
	|	SUM(tmp.Amount) AS Amount,
	|	tmp.Period,
	|	tmp.Key
	|INTO CashInTransit
	|FROM
	|	TablePaymentList AS tmp
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

Function R3027B_EmployeeCashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
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

Function R3021B_CashInTransitIncoming()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.MoneyTransfer AS Basis,
		   |	PaymentList.CashAccount AS Account,
		   |	PaymentList.Amount,
		   |	PaymentList.Currency,
		   |	PaymentList.Key
		   |INTO R3021B_CashInTransitIncoming
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsCashIn
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.CashTransferOrder,
		   |	PaymentList.CashAccount,
		   |	PaymentList.Amount,
		   |	PaymentList.Currency,
		   |	PaymentList.Key
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsCashTransferOrder
		   |	OR PaymentList.IsCurrencyExchange";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentFromCustomer
		   |	OR PaymentList.IsReturnFromVendor
		   |	OR PaymentList.IsOtherPartner";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS Direction,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.CashFlowCenter,
		   |	PaymentList.PlanningPeriod,
		   |	PaymentList.Currency,
		   |	PaymentList.Key,
		   |	PaymentList.Amount
		   |INTO R3011T_CashFlow
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	TRUE";
EndFunction

Function R3015B_CashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.PlaningTransactionBasis AS Basis,
		   |	*
		   |INTO R3015B_CashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsCurrencyExchange
		   |	AND PaymentList.IsEmployee";
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
		   |	PaymentList.Order,
		   |	PaymentList.Key,
		   |	PaymentList.Amount AS Amount,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2021B_CustomersTransactions
		   |	FROM PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentFromCustomer
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
		   |	PaymentList.LegalName,
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

Function R2020B_AdvancesFromCustomers()
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
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentFromCustomer
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
		   |	PaymentList.LegalName,
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

Function R3035T_CashPlanning()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.PlaningTransactionBasis AS BasisDocument,
		   |	PaymentList.PlaningTransactionBasis.PlanningPeriod AS PlanningPeriod,
		   |	PaymentList.CashAccount AS Account,
		   |	PaymentList.Currency,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		   |			THEN PaymentList.Partner
		   |		ELSE VALUE(Catalog.Partners.EmptyRef)
		   |	END AS Partner,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
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

Function R3024B_SalesOrdersToBePaid()
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
		   |	VALUE(Enum.PaymentTypes.Cash) AS PaymentTypeEnum,
		   |	PaymentList.RetailCustomer,
		   |	PaymentList.CashAccount AS Account,
		   |	PaymentList.Order,
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
		   |	PaymentList.LegalName,
		   |	PaymentList.Order,
		   |	TRUE AS IsCustomerAdvance,
		   |	FALSE AS IsVendorAdvance,
		   |	PaymentList.Amount
		   |INTO T2014S_AdvancesInfo
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsPaymentFromCustomer
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
		   |	PaymentList.LegalName,
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
		   |	PaymentList.IsPaymentFromCustomer
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
		   |	PaymentList.IsReturnFromVendor
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
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) AS
		|		Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	If Parameters.Operation = Catalogs.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions Then
		Return GetAnalytics_DR_R3010B_CR_R2020B_R2021B(Parameters); // Cash on hand -  Customer transactions
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CashReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_DR_R2021B_CR_R2020B(Parameters); // Customer transactions - Advances from customer 
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Cash on hand - Customer transaction
Function GetAnalytics_DR_R3010B_CR_R2020B_R2021B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, Parameters.ObjectData.CashAccount);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.CashAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.RowData.Partner, Parameters.RowData.Agreement);
	IsAdvance = AccountingServer.IsAdvance(Parameters.RowData);
	If IsAdvance Then
		If ValueIsFilled(Credit.AccountAdvancesCustomer) Then
			AccountingAnalytics.Credit = Credit.AccountAdvancesCustomer;
		EndIf;
	Else
		If ValueIsFilled(Credit.AccountTransactionsCustomer) Then
			AccountingAnalytics.Credit = Credit.AccountTransactionsCustomer;
		EndIf;
	EndIf;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Customer transactions - Advances from customer
Function GetAnalytics_DR_R2021B_CR_R2020B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, Parameters.RowData.Partner, Parameters.RowData.Agreement);
	If ValueIsFilled(Accounts.AccountTransactionsCustomer) Then
		AccountingAnalytics.Debit = Accounts.AccountTransactionsCustomer;
	EndIf;
	// Debit - Analytics
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	If ValueIsFilled(Accounts.AccountAdvancesCustomer) Then
		AccountingAnalytics.Credit = Accounts.AccountAdvancesCustomer;
	EndIf;
	// Credit - Analytics
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	If Parameters.Operation = Catalogs.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions 
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
		Return Parameters.RowData.FinancialMovementType;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion

