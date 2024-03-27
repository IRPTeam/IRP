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
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2023B_AdvancesFromRetailCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.CashInTransit.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
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
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3024B_SalesOrdersToBePaid());
	QueryArray.Add(R3026B_SalesOrdersCustomerAdvance());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R3050T_PosCashBalances());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5022T_Expenses());
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
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.Currency AS Currency,
		|	PaymentList.Ref.CurrencyExchange AS CurrencyExchange,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.Ref.TransitAccount AS TransitAccount,
		|	PaymentList.Ref.TransitAccount.Currency AS TransitCurrency,
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
		|	CASE
		|		WHEN PaymentList.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN PaymentList.Agreement.StandardAgreement
		|		ELSE PaymentList.Agreement
		|	END AS Agreement,
		|	PaymentList.Partner AS Partner,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.TotalAmount AS Amount,
		|	PaymentList.AmountExchange AS AmountExchange,
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
		|	CASE
		|		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement)
		|		AND NOT PaymentList.PlaningTransactionBasis.Date IS NULL
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
		|	PaymentList.TransitUUID AS TransitUUID,
		|	PaymentList.ProfitLossCenter AS ProfitLossCenter,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE WHEN PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.RetailCustomerAdvance) THEN
		|		0
		|	ELSE
		|		PaymentList.Commission 
		|	END AS Commission,
		|	PaymentList.Commission AS RetailCustomerAdvanceCommission,
		|	PaymentList.FinancialMovementType AS FinancialMovementType,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS
		|		IsPaymentFromCustomer,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomerByPOS) AS
		|		IsPaymentFromCustomerByPOS,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange) AS IsCurrencyExchange,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.OtherIncome) AS IsOtherIncome,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder) AS
		|		IsCashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.TransferFromPOS) AS IsTransferFromPOS,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS IsReturnFromVendor,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.RetailCustomerAdvance) AS IsCustomerAdvance,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.EmployeeCashAdvance) AS
		|		IsEmployeeCashAdvance,
		|	PaymentList.RetailCustomer AS RetailCustomer,
		|	PaymentList.BankTerm AS BankTerm,
		|	PaymentList.Ref.Branch AS Branch,
		|	PaymentList.LegalNameContract AS LegalNameContract,
		|	PaymentList.Order AS Order,
		|	PaymentList.PaymentType AS PaymentType,
		|	PaymentList.PaymentTerminal AS PaymentTerminal,
		|	CASE
		|		WHEN PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		|			THEN PaymentList.PlaningTransactionBasis.Ref
		|		ELSE NULL
		|	END AS CashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.OtherPartner) AS IsOtherPartner,
		|	PaymentList.RevenueType AS RevenueType,
		|	PaymentList.CashFlowCenter,
		|	PaymentList.Project,
		|	PaymentList.CommissionFinancialMovementType
		|INTO PaymentList
		|FROM
		|	Document.BankReceipt.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function CashInTransit()
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
	|INTO TablePaymentList
	|FROM
	|	Document.BankReceipt.PaymentList AS BankReceiptPaymentList
	|WHERE
	|	BankReceiptPaymentList.Ref = &Ref
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
	|	tmp.Amount AS Amount,
	|	tmp.Period,
	|	tmp.Key
	|INTO CashInTransit
	|FROM
	|	TablePaymentList AS tmp
	|WHERE
	|	tmp.IsMoneyTransfer
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense),
	|	tmp.Company AS Company,
	|	tmp.PlaningTransactionBasis AS BasisDocument,
	|	tmp.FromAccount_POS AS FromAccount,
	|	tmp.ToAccount_POS AS ToAccount,
	|	tmp.Currency AS Currency,
	|	tmp.Amount + tmp.Commission AS Amount,
	|	tmp.Period,
	|	tmp.Key
	|FROM
	|	TablePaymentList AS tmp
	|WHERE
	|	tmp.TransferFromPOS";
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
		   |	PaymentList.TransactionDocument AS Basis,
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

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.LegalName,
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
		   |	PaymentList.LegalName,
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
		|	PaymentList.Amount
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE";
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
		|	PaymentList.CashFlowCenter,
		|	PaymentList.PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.Amount + PaymentList.Commission AS Amount
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
		|	PaymentList.CommissionFinancialMovementType,
		|	PaymentList.CashFlowCenter,
		|	PaymentList.PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.Commission
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Commission <> 0";
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
		   |			THEN PaymentList.LegalName
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.ChequeBondTransactionItem)
		   |			THEN PaymentList.PlaningTransactionBasis.LegalName
		   |		ELSE VALUE(Catalog.Companies.EmptyRef)
		   |	END AS LegalName,
		   |	PaymentList.FinancialMovementType,
		   |	-(PaymentList.Amount + PaymentList.Commission) AS Amount,
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
		   |	PaymentList.Project,
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
		   |	PaymentList.Commission <> 0
		   |	AND NOT PaymentList.IsPaymentFromCustomerByPOS";
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
		   |	VALUE(Enum.PaymentTypes.Card) AS PaymentTypeEnum,
		   |	PaymentList.RetailCustomer,
		   |	PaymentList.Order,
		   |	PaymentList.Account,
		   |	PaymentList.PaymentType,
		   |	PaymentList.PaymentTerminal,
		   |	PaymentList.BankTerm,
		   |	PaymentList.RetailCustomerAdvanceCommission AS Commission,
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

Function R3050T_PosCashBalances()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.PaymentType,
		   |	PaymentList.Account,
		   |	PaymentList.PaymentTerminal,
		   |	PaymentList.Amount,
		   |	PaymentList.RetailCustomerAdvanceCommission AS Commission
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
		|	PaymentList.Account,
		|	PaymentList.PlaningTransactionBasis AS Basis,
		|	PaymentList.Amount + PaymentList.Commission AS Amount
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
		|	PaymentList.Account,
		|	PaymentList.CashTransferOrder,
		|	PaymentList.Amount + PaymentList.Commission AS Amount
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCashTransferOrder
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	PaymentList.Period,
		|	PaymentList.TransitUUID,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.TransitCurrency,
		|	PaymentList.TransitAccount,
		|	PaymentList.CashTransferOrder,
		|	Currencies.Amount
		|FROM
		|	PaymentList AS PaymentList
		|		INNER JOIN Document.BankReceipt.Currencies AS Currencies
		|		ON Currencies.Ref = &Ref
		|		AND Currencies.CurrencyFrom = PaymentList.Currency
		|		AND Currencies.MovementType.Currency = PaymentList.TransitCurrency
		|		AND PaymentList.Currency <> PaymentList.CurrencyExchange
		|		AND Currencies.Key <> PaymentList.TransitUUID
		|		AND PaymentList.IsCurrencyExchange
		|WHERE
		|	TRUE";
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
	AccountList = New Array;
	AccountList.Add(Obj.Account);
	AccountList.Add(Obj.TransitAccount);
	AccessKeyMap.Insert("Account", AccountList);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Key AS RowKey,
		   |	PaymentList.Key AS Key,
		   |	PaymentList.Currency,
		   |	PaymentList.Amount,
		   |	VALUE(Catalog.AccountingOperations.BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions) AS Operation,
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
		   |	VALUE(Catalog.AccountingOperations.BankReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers),
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	If Parameters.Operation = Catalogs.AccountingOperations.BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions Then
		Return GetAnalytics_DR_R3010B_CR_R2020B_R2021B(Parameters); // Cash on hand -  Customer transactions
	ElsIf Parameters.Operation = Catalogs.AccountingOperations.BankReceipt_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_DR_R2021B_CR_R2020B(Parameters); // Customer transactions - Advances from customer 
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Cash on hand - Customer transaction
Function GetAnalytics_DR_R3010B_CR_R2020B_R2021B(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                       Parameters.ObjectData.Account,
	                                                       Parameters.ObjectData.Currency);
	If ValueIsFilled(Debit.Account) Then
		AccountingAnalytics.Debit = Debit.Account;
	EndIf;
	// Debit - Analytics
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Credit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                    Parameters.RowData.Partner, 
	                                                    Parameters.RowData.Agreement,
	                                                    Parameters.ObjectData.Currency);
	                                                    
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

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.ObjectData.Currency);
	                                                      
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
	If Parameters.Operation = Catalogs.AccountingOperations.BankReceipt_DR_R3010B_CashOnHand_CR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions 
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

