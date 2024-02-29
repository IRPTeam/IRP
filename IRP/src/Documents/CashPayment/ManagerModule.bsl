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
	QueryArray.Add(R3025B_PurchaseOrdersToBePaid());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5011B_CustomersAging());
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
		|
		|	case when PaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) Then
		|	PaymentList.Agreement else Undefined end AS AdvanceAgreement,
		|
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
		|	PaymentList.CashFlowCenter,
		|	PaymentList.Project,
		|	FALSE AS IsReturnToCustomerByPOS
		|INTO PaymentList
		|FROM
		|	Document.CashPayment.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function CashInTransit()
	Return "SELECT
	|	CashPaymentPaymentList.Ref.Company AS Company,
	|	CashPaymentPaymentList.Ref.Currency AS Currency,
	|	CashPaymentPaymentList.Ref.CashAccount AS CashAccount,
	|	CASE
	|		WHEN CashPaymentPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN CASE
	|				WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|				AND NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
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
	|	AND NOT CASE
	|		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|		AND NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
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
	|		AND NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
	|		AND
	|			CashPaymentPaymentList.PlaningTransactionBasis.SendCurrency = CashPaymentPaymentList.PlaningTransactionBasis.ReceiveCurrency
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsMoneyTransfer,
	|	CASE
	|		WHEN VALUETYPE(CashPaymentPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
	|		AND NOT CashPaymentPaymentList.PlaningTransactionBasis.Date IS NULL
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
	|INTO TablePaymentList
	|FROM
	|	Document.CashPayment.PaymentList AS CashPaymentPaymentList
	|WHERE
	|	CashPaymentPaymentList.Ref = &Ref
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
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_BP_CP();
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

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_BP_CP();
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

	Debit = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                   Parameters.RowData.Partner, 
	                                                   Parameters.RowData.Agreement,
	                                                   Parameters.ObjectData.Currency);
	                                                   
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

	Credit = AccountingServer.GetT9011S_AccountsCashAccount(AccountParameters, 
	                                                        Parameters.ObjectData.CashAccount,
	                                                        Parameters.ObjectData.Currency);
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

	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.RowData.Partner, 
	                                                      Parameters.RowData.Agreement,
	                                                      Parameters.ObjectData.Currency);
	                                                      
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