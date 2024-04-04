#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	
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
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

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
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
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
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(R5020B_PartnersBalance());
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
		|
		|	case when PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) Then
		|	PaymentList.Agreement else Undefined end AS AdvanceAgreement,
		|		
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
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.RetailCustomerAdvance) AS IsCustomerAdvance,
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
		|	PaymentList.CashFlowCenter,
		|	PaymentList.Project,
		|	FALSE AS IsPaymentFromCustomerByPOS
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
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_BR_CR();
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_BR_CR();
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
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_BR_CR();
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
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_BR_CR();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_Offset();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_Offset();
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
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period AS Period,
		|	PaymentList.Company AS Company,
		|	PaymentList.Branch AS Branch,
		|	PaymentList.Currency AS Currency,
		|	PaymentList.Partner AS Partner,
		|	PaymentList.LegalName AS LegalName,
		|	PaymentList.Order AS Order,
		|	PaymentList.Amount AS Amount
		|INTO _SalesOrdersToBePaid
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.Order.Ref IS NULL
		|	AND PaymentList.IsPaymentFromCustomer
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R3024B_SalesOrdersToBePaidBalance.AmountBalance AS AmountBalance,
		|	R3024B_SalesOrdersToBePaidBalance.Company AS Company,
		|	R3024B_SalesOrdersToBePaidBalance.Branch AS Branch,
		|	R3024B_SalesOrdersToBePaidBalance.Currency AS Currency,
		|	R3024B_SalesOrdersToBePaidBalance.Partner AS Partner,
		|	R3024B_SalesOrdersToBePaidBalance.Order AS Order,
		|	R3024B_SalesOrdersToBePaidBalance.LegalName AS LegalName
		|INTO _SalesOrdersToBePaidBalance
		|FROM
		|	AccumulationRegister.R3024B_SalesOrdersToBePaid.Balance(&BalancePeriod, (Company, Branch, Currency, Partner,
		|		LegalName, Order) IN
		|		(SELECT
		|			_SalesOrdersToBePaid.Company,
		|			_SalesOrdersToBePaid.Branch,
		|			_SalesOrdersToBePaid.Currency,
		|			_SalesOrdersToBePaid.Partner,
		|			_SalesOrdersToBePaid.LegalName,
		|			_SalesOrdersToBePaid.Order
		|		FROM
		|			_SalesOrdersToBePaid AS _SalesOrdersToBePaid)) AS R3024B_SalesOrdersToBePaidBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	_SalesOrdersToBePaid.RecordType AS RecordType,
		|	_SalesOrdersToBePaid.Period AS Period,
		|	_SalesOrdersToBePaid.Company AS Company,
		|	_SalesOrdersToBePaid.Branch AS Branch,
		|	_SalesOrdersToBePaid.Currency AS Currency,
		|	_SalesOrdersToBePaid.Partner AS Partner,
		|	_SalesOrdersToBePaid.LegalName AS LegalName,
		|	_SalesOrdersToBePaid.Order AS Order,
		|	CASE
		|		WHEN ISNULL(_SalesOrdersToBePaidBalance.AmountBalance, 0) > ISNULL(_SalesOrdersToBePaid.Amount, 0)
		|			THEN ISNULL(_SalesOrdersToBePaid.Amount, 0)
		|		ELSE ISNULL(_SalesOrdersToBePaidBalance.AmountBalance, 0)
		|	END AS Amount
		|INTO R3024B_SalesOrdersToBePaid
		|FROM
		|	_SalesOrdersToBePaid AS _SalesOrdersToBePaid
		|		INNER JOIN _SalesOrdersToBePaidBalance AS _SalesOrdersToBePaidBalance
		|		ON _SalesOrdersToBePaid.Company = _SalesOrdersToBePaidBalance.Company
		|		AND _SalesOrdersToBePaid.Branch = _SalesOrdersToBePaidBalance.Branch
		|		AND _SalesOrdersToBePaid.Currency = _SalesOrdersToBePaidBalance.Currency
		|		AND _SalesOrdersToBePaid.Partner = _SalesOrdersToBePaidBalance.Partner
		|		AND _SalesOrdersToBePaid.LegalName = _SalesOrdersToBePaidBalance.LegalName
		|		AND _SalesOrdersToBePaid.Order = _SalesOrdersToBePaidBalance.Order
		|WHERE
		|	CASE
		|		WHEN ISNULL(_SalesOrdersToBePaidBalance.AmountBalance, 0) > ISNULL(_SalesOrdersToBePaid.Amount, 0)
		|			THEN ISNULL(_SalesOrdersToBePaid.Amount, 0)
		|		ELSE ISNULL(_SalesOrdersToBePaidBalance.AmountBalance, 0)
		|	END > 0";
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
	Return InformationRegisters.T2014S_AdvancesInfo.T2014S_AdvancesInfo_BR_CR();
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_BR_CR();
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_BR_CR();
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
		// Payment from customer
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|
		|UNION ALL
		|
		// Payment from customer (offset)
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|
		|UNION ALL
		|
		// Return from vendor
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnFromVendor
		|
		|UNION ALL
		|
		// Return from vendor (offset)
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		|
		// Cash transfer order
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCashTransferOrder";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions Then
		Return GetAnalytics_PaymentFromCustomer(Parameters); // Cash on hand -  Customer transactions
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CashReceipt_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions Then
		Return GetAnalytics_PaymentFromCustomer_Offset(Parameters); // Advances from customer - Customer transactions
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions Then
		Return GetAnalytics_ReturnFromVendor(Parameters); // Cash on hand -  Vendor transactions
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.CashReceipt_DR_R1020B_AdvancesToVendors_CR_R1021B_VendorsTransactions Then
		Return GetAnalytics_ReturnFromVendor_Offset(Parameters); // Advance from vendor - Vendor transactions
	ElsIf Parameters.Operation = AO.CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming Then
		Return GetAnalytics_CashTransferOrder(Parameters); // Cash on hand - Cash in transit 
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Cash on hand - Customer transaction
Function GetAnalytics_PaymentFromCustomer(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                       Parameters.ObjectData.CashAccount,
	                                                       Parameters.ObjectData.Currency);
	AccountingAnalytics.Debit = Debit.Account;

	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.CashAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	                                                    
	IsAdvance = AccountingServer.IsAdvance(Parameters.RowData);
	If IsAdvance Then
		AccountingAnalytics.Credit = Credit.AccountAdvancesCustomer;
	Else
		AccountingAnalytics.Credit = Credit.AccountTransactionsCustomer;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Advances from customer - Customer transactions
Function GetAnalytics_PaymentFromCustomer_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.ObjectData.Currency);
	                                                      
	// Debit
	AccountingAnalytics.Debit = Accounts.AccountAdvancesCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountTransactionsCustomer;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Cash on hand - Vendor transaction
Function GetAnalytics_ReturnFromVendor(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	// Debit
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                       Parameters.ObjectData.CashAccount,
	                                                       Parameters.ObjectData.Currency);
	AccountingAnalytics.Debit = Debit.Account;

	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.CashAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	                                                    
	IsAdvance = AccountingServer.IsAdvance(Parameters.RowData);
	If IsAdvance Then
		AccountingAnalytics.Credit = Credit.AccountAdvancesVendor;
	Else
		AccountingAnalytics.Credit = Credit.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Advance from vendor - Vendor transactions
Function GetAnalytics_ReturnFromVendor_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.ObjectData.Currency);
	                                                      
	// Debit
	AccountingAnalytics.Debit = Accounts.AccountAdvancesVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountTransactionsVendor;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Cash on hand - Cash in transit
Function GetAnalytics_CashTransferOrder(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.CashAccount,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Debit = Debit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.RowData.SendingAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.CashAccount,
															Parameters.ObjectData.Currency);
		                                               
	AccountingAnalytics.Credit = Credit.AccountTransit;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.CashAccount);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	AO = Catalogs.AccountingOperations;
	
	If (Parameters.Operation = AO.CashReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions 
		Or Parameters.Operation = AO.CashReceipt_DR_R3010B_CashOnHand_CR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions
		Or Parameters.Operation = AO.CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming)
		
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
		Return Parameters.RowData.FinancialMovementType;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.CashReceipt_DR_R3010B_CashOnHand_CR_R3021B_CashInTransitIncoming
		
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
		Return Parameters.RowData.FinancialMovementType;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion

