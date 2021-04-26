#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("ExpensesTurnovers"                     , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextBankPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.PlaningCashTransactions = QueryResults[1].Unload();
	Tables.CashInTransit           = QueryResults[2].Unload();
	Tables.ExpensesTurnovers       = QueryResults[3].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
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
		|	BankPaymentPaymentList.Key AS Key,
		|	BankPaymentPaymentList.BusinessUnit AS BusinessUnit,
		|	BankPaymentPaymentList.ExpenseType AS ExpenseType,
		|	BankPaymentPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	BankPaymentPaymentList.Commission AS Commission
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
		|	QueryTable.Key AS Key,
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
		|	-tmp.Amount AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.PlaningTransactionBasis.Date IS NULL
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
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
		|//[3]//////////////////////////////////////////////////////////////////////////////
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
		|	tmp.Commission <> 0";
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
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PlaningCashTransactions));
	
	// CashInIransit
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.CashInTransit));
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ExpensesTurnovers));
	
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

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
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
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return
		"SELECT
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
		|	PaymentList.Amount AS Amount,
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
		|	PaymentList.BusinessUnit AS BusinessUnit,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	PaymentList.Commission AS Commission,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS IsPaymentToVendor,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CurrencyExchange) AS IsCurrencyExchange,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CashTransferOrder) AS
		|		IsCashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS IsReturnToCustomer
		|INTO PaymentList
		|FROM
		|	Document.BankPayment.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction	

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument AS Basis,
		|	PaymentList.Key,
		|	PaymentList.Amount
		|INTO R1021B_VendorsTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|	AND NOT PaymentList.IsAdvance";
EndFunction	

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
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
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Basis,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|	AND PaymentList.IsAdvance";	
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
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

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Company,
		|	PaymentList.Payee AS LegalName,
		|	PaymentList.Currency,
		|	SUM(PaymentList.Amount) AS Amount,
		|	PaymentList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsMoneyTransfer
		|	AND NOT PaymentList.IsMoneyExchange
		|GROUP BY
		|	PaymentList.Company,
		|	PaymentList.Payee,
		|	PaymentList.Currency,
		|	PaymentList.Period,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|	OR PaymentList.IsCurrencyExchange
		|	OR PaymentList.IsCashTransferOrder";
EndFunction

#EndRegion


