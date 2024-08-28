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

	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2023B_AdvancesFromRetailCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R9510B_SalaryPayment.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
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
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(R3025B_PurchaseOrdersToBePaid());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R3050T_PosCashBalances());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(R5020B_PartnersBalance());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function PaymentList()
	Return 
		"SELECT
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.Currency AS Currency,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.Ref.TransitAccount AS TransitAccount,
		|	PaymentList.Ref.TransitAccount.Currency AS TransitCurrency,
		|	CASE
		|		WHEN PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND NOT PaymentList.PlaningTransactionBasis.Ref IS NULL
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
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.TotalAmount AS Amount,
		|	PaymentList.TotalAmount AS TotalAmount,
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
		|	PaymentList.PlaningTransactionBasis.PlanningPeriod AS PlanningPeriod,
		|	PaymentList.PaymentPeriod AS PaymentPeriod,
		|	PaymentList.CalculationType AS CalculationType,
		|	PaymentList.Ref AS Basis,
		|	PaymentList.Key AS Key,
		|	PaymentList.ProfitLossCenter AS ProfitLossCenter,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	PaymentList.FinancialMovementType AS FinancialMovementType,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS IsPaymentToVendor,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CurrencyExchange) AS IsCurrencyExchange,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CashTransferOrder) AS
		|		IsCashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS IsReturnToCustomer,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS) AS
		|		IsReturnToCustomerByPOS,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance) AS IsCustomerAdvance,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.EmployeeCashAdvance) AS
		|		IsEmployeeCashAdvance,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.SalaryPayment) AS IsSalaryPayment,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.OtherExpense) AS IsOtherExpense,
		|	PaymentList.RetailCustomer AS RetailCustomer,
		|	PaymentList.Ref.Branch AS Branch,
		|	PaymentList.LegalNameContract AS LegalNameContract,
		|	PaymentList.Order AS Order,
		|	CASE
		|		WHEN PaymentList.Agreement.UseOrdersForSettlements
		|			THEN PaymentList.Order
		|		ELSE UNDEFINED
		|	END AS OrderSettlements,
		|	PaymentList.PaymentType AS PaymentType,
		|	PaymentList.PaymentTerminal AS PaymentTerminal,
		|	PaymentList.Employee AS Employee,
		|	PaymentList.ReceiptingBranch,
		|	case
		|		when PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		|		and NOT PaymentList.PlaningTransactionBasis.Ref IS NULL
		|			THEN PaymentList.PlaningTransactionBasis.ReceiveCurrency
		|		else PaymentList.Ref.Currency
		|	end as ReceiptingCurrency,
		|	PaymentList.ReceiptingAccount,
		|	CASE
		|		WHEN PaymentList.PlaningTransactionBasis REFS Document.CashTransferOrder
		|			THEN PaymentList.PlaningTransactionBasis.Ref
		|		ELSE NULL
		|	END AS CashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.OtherPartner) AS IsOtherPartner,
		|	PaymentList.CashFlowCenter,
		|	PaymentList.Project
		|INTO PaymentList
		|FROM
		|	Document.BankPayment.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function CashInTransit()
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
		|				AND NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
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
		|	AND NOT CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
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
		|		AND NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			BankPaymentPaymentList.PlaningTransactionBasis.SendCurrency = BankPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(BankPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND NOT BankPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
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
		|	BankPaymentPaymentList.Ref.Branch AS Branch
		|INTO TablePaymentList
		|FROM
		|	Document.BankPayment.PaymentList AS BankPaymentPaymentList
		|WHERE
		|	BankPaymentPaymentList.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		|	tmp.IsMoneyTransfer";
EndFunction

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_BP_CP();
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_BP_CP();
EndFunction

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
		|	PaymentList.TotalAmount AS Amount
		|INTO R3021B_CashInTransitIncoming
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCashTransferOrder
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.TransitCurrency,
		|	PaymentList.TransitAccount,
		|	PaymentList.CashTransferOrder,
		|	PaymentList.Key,
		|	PaymentList.TotalAmount AS Amount
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCurrencyExchange";
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
		   |	PaymentList.CalculationType,
		   |	PaymentList.Currency,
		   |	PaymentList.TotalAmount AS Amount
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
		   |	PaymentList.Agreement,
		   |	PaymentList.Currency,
		   |	PaymentList.TotalAmount AS Amount
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsEmployeeCashAdvance";
EndFunction

Function R2021B_CustomersTransactions()
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_BP_CP();
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
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_BP_CP();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_Offset();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_Offset();
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		   |	PaymentList.IsPaymentToVendor
		   |	OR PaymentList.IsReturnToCustomer
		   |	OR PaymentList.IsReturnToCustomerByPOS
		   |	OR PaymentList.IsOtherPartner
		   |GROUP BY
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.LegalName,
		   |	PaymentList.LegalNameContract,
		   |	PaymentList.Currency,
		   |	PaymentList.Period,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Account,
		   |	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
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
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.ChequeBondTransactionItem)
		   |			THEN PaymentList.PlaningTransactionBasis.Partner
		   |		ELSE VALUE(Catalog.Partners.EmptyRef)
		   |	END AS Partner,
		   |	CASE
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		   |			THEN PaymentList.LegalName
		   |		WHEN VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.ChequeBondTransactionItem)
		   |			THEN PaymentList.PlaningTransactionBasis.Partner
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
	Return 
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Key,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Project,
		|	PaymentList.ProfitLossCenter,
		|	PaymentList.ExpenseType,
		|	PaymentList.Currency,
		|	PaymentList.AdditionalAnalytic,
		|	PaymentList.Amount AS Amount,
		|	PaymentList.Amount AS AmountWithTaxes
		|INTO R5022T_Expenses
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherExpense";
EndFunction

Function R3025B_PurchaseOrdersToBePaid()
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
		|INTO _PurchaseOrdersToBePaid
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.Order.Ref IS NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R3025B_PurchaseOrdersToBePaidBalance.Company AS Company,
		|	R3025B_PurchaseOrdersToBePaidBalance.Branch AS Branch,
		|	R3025B_PurchaseOrdersToBePaidBalance.Currency AS Currency,
		|	R3025B_PurchaseOrdersToBePaidBalance.Partner AS Partner,
		|	R3025B_PurchaseOrdersToBePaidBalance.LegalName AS LegalName,
		|	R3025B_PurchaseOrdersToBePaidBalance.Order AS Order,
		|	R3025B_PurchaseOrdersToBePaidBalance.AmountBalance AS AmountBalance
		|INTO _PurchaseOrdersToBePaidBalance
		|FROM
		|	AccumulationRegister.R3025B_PurchaseOrdersToBePaid.Balance(&BalancePeriod, (Company, Branch, Currency, Partner,
		|		LegalName, Order) IN
		|		(SELECT
		|			_PurchaseOrdersToBePaid.Company,
		|			_PurchaseOrdersToBePaid.Branch,
		|			_PurchaseOrdersToBePaid.Currency,
		|			_PurchaseOrdersToBePaid.Partner,
		|			_PurchaseOrdersToBePaid.LegalName,
		|			_PurchaseOrdersToBePaid.Order
		|		FROM
		|			_PurchaseOrdersToBePaid AS _PurchaseOrdersToBePaid)) AS R3025B_PurchaseOrdersToBePaidBalance
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	_PurchaseOrdersToBePaid.RecordType AS RecordType,
		|	_PurchaseOrdersToBePaid.Period AS Period,
		|	_PurchaseOrdersToBePaid.Company AS Company,
		|	_PurchaseOrdersToBePaid.Branch AS Branch,
		|	_PurchaseOrdersToBePaid.Currency AS Currency,
		|	_PurchaseOrdersToBePaid.Partner AS Partner,
		|	_PurchaseOrdersToBePaid.LegalName AS LegalName,
		|	_PurchaseOrdersToBePaid.Order AS Order,
		|	CASE
		|		WHEN ISNULL(_PurchaseOrdersToBePaidBalance.AmountBalance, 0) > ISNULL(_PurchaseOrdersToBePaid.Amount, 0)
		|			THEN ISNULL(_PurchaseOrdersToBePaid.Amount, 0)
		|		ELSE ISNULL(_PurchaseOrdersToBePaidBalance.AmountBalance, 0)
		|	END AS Amount
		|INTO R3025B_PurchaseOrdersToBePaid
		|FROM
		|	_PurchaseOrdersToBePaid AS _PurchaseOrdersToBePaid
		|		INNER JOIN _PurchaseOrdersToBePaidBalance AS _PurchaseOrdersToBePaidBalance
		|		ON _PurchaseOrdersToBePaid.Company = _PurchaseOrdersToBePaidBalance.Company
		|		AND _PurchaseOrdersToBePaid.Branch = _PurchaseOrdersToBePaidBalance.Branch
		|		AND _PurchaseOrdersToBePaid.Currency = _PurchaseOrdersToBePaidBalance.Currency
		|		AND _PurchaseOrdersToBePaid.Partner = _PurchaseOrdersToBePaidBalance.Partner
		|		AND _PurchaseOrdersToBePaid.LegalName = _PurchaseOrdersToBePaidBalance.LegalName
		|		AND _PurchaseOrdersToBePaid.Order = _PurchaseOrdersToBePaidBalance.Order
		|WHERE
		|	CASE
		|		WHEN ISNULL(_PurchaseOrdersToBePaidBalance.AmountBalance, 0) > ISNULL(_PurchaseOrdersToBePaid.Amount, 0)
		|			THEN ISNULL(_PurchaseOrdersToBePaid.Amount, 0)
		|		ELSE ISNULL(_PurchaseOrdersToBePaidBalance.AmountBalance, 0)
		|	END > 0";
EndFunction

Function T2014S_AdvancesInfo()
	Return InformationRegisters.T2014S_AdvancesInfo.T2014S_AdvancesInfo_BP_CP();
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_BP_CP();
EndFunction

Function R3050T_PosCashBalances()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.PaymentType,
		   |	PaymentList.Account,
		   |	PaymentList.PaymentTerminal,
		   |	- PaymentList.Amount AS Amount
		   |INTO R3050T_PosCashBalances
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsReturnToCustomerByPOS";
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_BP_CP();
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
	Return 
		// Payment to vendor
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|
		|UNION ALL
		|
		// Payment to vendor (offset)
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		|
		// Return to customer
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnToCustomer
		|
		|UNION ALL
		|
		// Return to customer (offset)
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers),
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing
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
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCashTransferOrder
		|
		|UNION ALL
		|
		// Currency exchange
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCurrencyExchange
		|
		|UNION ALL
		|
		// Other partner
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherPartner
		|
		|UNION ALL
		|
		// Other expense
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherExpense
		|
		|UNION ALL
		|
		// Salary payment
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsSalaryPayment
		|
		|UNION ALL
		|
		// Employee cash advance
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.Key AS RowKey,
		|	PaymentList.Key AS Key,
		|	PaymentList.Currency,
		|	PaymentList.Amount,
		|	VALUE(Catalog.AccountingOperations.BankPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsEmployeeCashAdvance";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand Then
		Return GetAnalytics_PaymentToVendor(Parameters); // Vendors transactions - Cash on hand
	ElsIf Parameters.Operation = AO.BankPayment_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors Then
		Return GetAnalytics_PaymentToVendor_Offset(Parameters); // Vendors transactions - Advances to vendors
	ElsIf Parameters.Operation = AO.BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand Then
		Return GetAnalytics_ReturnToCustomer(Parameters); // Customer transactions - Cash on hand
	ElsIf Parameters.Operation = AO.BankPayment_DR_R2021B_CustomersTransactions_CR_R2020B_AdvancesFromCustomers Then
		Return GetAnalytics_ReturnToCustomer_Offset(Parameters); // Customer transactions - Advances from customer
	ElsIf Parameters.Operation = AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder Then
		Return GetAnalytics_CashTransferOrder(Parameters); // Cash in transit - Cash on hand
	ElsIf Parameters.Operation = AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange Then
		Return GetAnalytics_CurrencyExchange(Parameters); // Cash in transit - Cash on hand		
	ElsIf Parameters.Operation = AO.BankPayment_DR_R5015B_OtherPartnersTransactions_CR_R3010B_CashOnHand Then
		Return GetAnalytics_OtherPartner(Parameters); // Other partner - Cash on hand		
	ElsIf Parameters.Operation = AO.BankPayment_DR_R5022T_Expenses_CR_R3010B_CashOnHand Then
		Return GetAnalytics_OtherExpense(Parameters); // Expense - Cash on hand		
	ElsIf Parameters.Operation = AO.BankPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand Then
		Return GetAnalytics_SalaryPayment(Parameters); // SalaryPayment - Cash on hand		
	ElsIf Parameters.Operation = AO.BankPayment_DR_R3027B_EmployeeCashAdvance_CR_R3010B_CashOnHand Then
		Return GetAnalytics_EmployeeCashAdvance(Parameters); // Employee cash advance - Cash on hand		
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Vendors transactions - Cash on hand
Function GetAnalytics_PaymentToVendor(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
		                                               Parameters.RowData.Partner, 
		                                               Parameters.RowData.Agreement,
		                                               Parameters.ObjectData.Currency);
		                                               
	IsAdvance = AccountingServer.IsAdvance(Parameters.RowData);
	If IsAdvance Then
		AccountingAnalytics.Debit = Debit.AccountAdvancesVendor;
	Else
		AccountingAnalytics.Debit = Debit.AccountTransactionsVendor;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors
Function GetAnalytics_PaymentToVendor_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.ObjectData.Currency);
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Customers transactions - Cash on hand
Function GetAnalytics_ReturnToCustomer(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
		                                               Parameters.RowData.Partner, 
		                                               Parameters.RowData.Agreement,
		                                               Parameters.ObjectData.Currency);
		                                               
	IsAdvance = AccountingServer.IsAdvance(Parameters.RowData);
	If IsAdvance Then
		AccountingAnalytics.Debit = Debit.AccountAdvancesCustomer;
	Else
		AccountingAnalytics.Debit = Debit.AccountTransactionsCustomer;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Customers transactions - Advances from customers
Function GetAnalytics_ReturnToCustomer_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.ObjectData.Currency);
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts.AccountTransactionsCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountAdvancesCustomer;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Cash in transit - Cash on hand
Function GetAnalytics_CashTransferOrder(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit	
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.RowData.ReceiptingAccount,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Debit = Debit.AccountTransit;
	AdditionalAnalytics = New Structure();	
	AdditionalAnalytics.Insert("Account", Parameters.RowData.ReceiptingAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Cash in transit - Cash on hand
Function GetAnalytics_CurrencyExchange(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit	
	Debit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.TransitAccount,
															Parameters.ObjectData.TransitAccount.Currency);
	AccountingAnalytics.Debit = Debit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.TransitAccount);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Other partner - Cash on hand
Function GetAnalytics_OtherPartner(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
		                                               Parameters.RowData.Partner, 
		                                               Parameters.RowData.Agreement,
		                                               Parameters.ObjectData.Currency);
		                                               
	AccountingAnalytics.Debit = Debit.AccountTransactionsOther;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Expense - Cash on hand
Function GetAnalytics_OtherExpense(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
		                                                      Parameters.RowData.ExpenseType, 
		                                                      Parameters.RowData.ProfitLossCenter);
		                                               
	AccountingAnalytics.Debit = Debit.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// SalaryPayment - Cash on hand
Function GetAnalytics_SalaryPayment(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Employee); 
	AccountingAnalytics.Debit = Debit.AccountSalaryPayment;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Employee", Parameters.RowData.Employee);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

// Employee cash advance - Cash on hand
Function GetAnalytics_EmployeeCashAdvance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9016S_AccountsEmployee(AccountParameters, Parameters.RowData.Partner); 
	AccountingAnalytics.Debit = Debit.AccountCashAdvance;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner", Parameters.RowData.Partner);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
															Parameters.ObjectData.Account,
															Parameters.ObjectData.Currency);
	AccountingAnalytics.Credit = Credit.Account;
	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Account", Parameters.ObjectData.Account);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	AO = Catalogs.AccountingOperations;
	
	If (Parameters.Operation = AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder
		Or Parameters.Operation = AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange)
		
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
		Return Parameters.RowData.FinancialMovementType;
	EndIf;
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	AO = Catalogs.AccountingOperations;
	
	If (Parameters.Operation = AO.BankPayment_DR_R1020B_AdvancesToVendors_R1021B_VendorsTransactions_CR_R3010B_CashOnHand
		Or Parameters.Operation = AO.BankPayment_DR_R2020B_AdvancesFromCustomers_R2021B_CustomersTransactions_CR_R3010B_CashOnHand
		Or Parameters.Operation = AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CashTransferOrder
		Or Parameters.Operation = AO.BankPayment_DR_R3021B_CashInTransitIncoming_CR_R3010B_CashOnHand_CurrencyExchange
		Or Parameters.Operation = AO.BankPayment_DR_R9510B_SalaryPayment_CR_R3010B_CashOnHand)
		
		And ExtDimensionType.ValueType.Types().Find(Type("CatalogRef.ExpenseAndRevenueTypes")) <> Undefined Then
		Return Parameters.RowData.FinancialMovementType;
	EndIf;
	Return Value;
EndFunction

#EndRegion

#EndRegion