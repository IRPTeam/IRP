#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("CashInTransit_POS"                     , PostingServer.CreateTable(AccReg.CashInTransit));
	Tables.Insert("ExpensesTurnovers"                     , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextBankReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
		
	Tables.PlaningCashTransactions    = QueryResults[1].Unload();
	Tables.CashInTransit              = QueryResults[2].Unload();
	Tables.CashInTransit_POS          = QueryResults[3].Unload();
	Tables.ExpensesTurnovers          = QueryResults[4].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function GetQueryTextBankReceiptPaymentList()
	Return
		"SELECT
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
		|	BankReceiptPaymentList.Amount AS Amount,
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
		|	BankReceiptPaymentList.BusinessUnit AS BusinessUnit,
		|	BankReceiptPaymentList.ExpenseType AS ExpenseType,
		|	BankReceiptPaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	BankReceiptPaymentList.Commission AS Commission
		|FROM
		|	Document.BankReceipt.PaymentList AS BankReceiptPaymentList
		|WHERE
		|	BankReceiptPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
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
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END AS Partner,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Payer
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END AS LegalName,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	- tmp.Amount AS Amount,
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
		|	tmp.TransferFromPOS
		|;
		|//[4]//////////////////////////////////////////////////////////////////////////////
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
	
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion	
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet", Parameters.DocumentDataTables.PlaningCashTransactions));
	
	// CashInIransit
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.CashInTransit.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.CashInTransit_POS.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.CashInTransit,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, FromAccount, ToAccount, Currency, Amount, Key"),
			Parameters.IsReposting));
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
	ArrayAll.Add("CurrencyExchange");
	ArrayAll.Add("Payer");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("TransitAccount");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payer");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	ArrayAll.Add("PaymentList.AmountExchange");
	ArrayAll.Add("PaymentList.POSAccount");
	
	ArrayByType = New Array();
	If TransactionType = Enums.IncomingPaymentTransactionType.CashTransferOrder Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.TransferFromPOS Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.POSAccount");
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("CurrencyExchange");
		ArrayByType.Add("TransitAccount");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.AmountExchange");
		
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.PaymentFromCustomer
	 	Or TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor  Then
		ArrayByType.Add("Account");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Payer");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Payer");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.Agreement");
	Else // empty
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		
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
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R3010B_CashOnHand());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return
		"SELECT
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.Currency AS Currency,
		|	PaymentList.Ref.CurrencyExchange AS CurrencyExchange,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.Ref.TransitAccount AS TransitAccount,
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
		|		WHEN PaymentList.Agreement = VALUE(Catalog.Agreements.EmptyRef)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|	AND NOT CASE
		|		WHEN (VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		OR VALUETYPE(PaymentList.PlaningTransactionBasis) = TYPE(Document.CashStatement))
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
		|	PaymentList.Payer AS Payer,
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.Amount AS Amount,
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
		|	PaymentList.Ref AS Basis,
		|	PaymentList.Key,
		|	PaymentList.BusinessUnit AS BusinessUnit,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.AdditionalAnalytic AS AdditionalAnalytic,
		|	PaymentList.Commission AS Commission,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS
		|		IsPaymentFromCustomer,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange) AS IsCurrencyExchange,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder) AS
		|		IsCashTransferOrder,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.TransferFromPOS) AS IsTransferFromPOS,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS IsReturnFromVendor,
		|	PaymentList.Ref.IgnoreAdvances AS IgnoreAdvances
		|INTO PaymentList
		|FROM
		|	Document.BankReceipt.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction	

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument AS Basis,
		|	PaymentList.Key,
		|	PaymentList.Amount AS Amount
		|INTO R2021B_CustomersTransactions
		|	FROM PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	AND NOT PaymentList.IsAdvance";
EndFunction	

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument AS Basis,
		|	PaymentList.Key,
		|	PaymentList.Amount AS Amount
		|INTO R1021B_VendorsTransactions
		|	FROM PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnFromVendor
		|	AND NOT PaymentList.IsAdvance";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Basis,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	AND PaymentList.IsAdvance";
EndFunction

Function R1020B_AdvancesToVendors()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Basis,
		|	PaymentList.Amount,
		|	PaymentList.Key
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsReturnFromVendor
		|	AND PaymentList.IsAdvance";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Company,
		|	PaymentList.Payer AS LegalName,
		|	PaymentList.Currency,
		|	SUM(PaymentList.Amount) AS Amount,
		|	PaymentList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	NOT PaymentList.IsMoneyTransfer
		|	AND
		|	NOT PaymentList.IsMoneyExchange
		|	AND
		|	NOT PaymentList.TransferFromPOS
		|GROUP BY
		|	PaymentList.Company,
		|	PaymentList.Payer,
		|	PaymentList.Currency,
		|	PaymentList.Period";	
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsCurrencyExchange
		|	OR PaymentList.IsCashTransferOrder
		|	OR PaymentList.IsTransferFromPOS";
EndFunction

#EndRegion
