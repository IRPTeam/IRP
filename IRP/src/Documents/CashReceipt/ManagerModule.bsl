#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextCashReceiptPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();
	QueryTablePaymentList = QueryResultsPaymentLIst.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PlaningCashTransactions = QueryResults[1].Unload();
	Tables.CashInTransit           = QueryResults[2].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Function GetQueryTextCashReceiptPaymentList()
	Return
		"SELECT
		|	CashReceiptPaymentList.Ref.Company AS Company,
		|	CashReceiptPaymentList.Ref.Currency AS Currency,
		|	CashReceiptPaymentList.Ref.CurrencyExchange AS CurrencyExchange,
		|	CashReceiptPaymentList.Ref.CashAccount AS CashAccount,
		|	CASE
		|		WHEN CashReceiptPaymentList.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|				AND
		|				NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
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
		|	AND
		|	NOT CASE
		|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
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
		|	CashReceiptPaymentList.Amount AS Amount,
		|	CashReceiptPaymentList.AmountExchange AS AmountExchange,
		|	CASE
		|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency = CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyTransfer,
		|	CASE
		|		WHEN VALUETYPE(CashReceiptPaymentList.PlaningTransactionBasis) = TYPE(Document.CashTransferOrder)
		|		AND
		|		NOT CashReceiptPaymentList.PlaningTransactionBasis.Date IS NULL
		|		AND
		|			CashReceiptPaymentList.PlaningTransactionBasis.SendCurrency <> CashReceiptPaymentList.PlaningTransactionBasis.ReceiveCurrency
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsMoneyExchange,
		|	CashReceiptPaymentList.PlaningTransactionBasis.Sender AS FromAccount,
		|	CashReceiptPaymentList.PlaningTransactionBasis.Receiver AS ToAccount,
		|	CashReceiptPaymentList.Ref AS ReceiptDocument,
		|	CashReceiptPaymentList.Key AS Key
		|FROM
		|	Document.CashReceipt.PaymentList AS CashReceiptPaymentList
		|WHERE
		|	CashReceiptPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.CurrencyExchange AS CurrencyExchange,
		|	QueryTable.CashAccount AS CashAccount,
		|	QueryTable.BasisDocument AS BasisDocument,
		|	QueryTable.IsAdvance AS IsAdvance,
		|	QueryTable.PlaningTransactionBasis AS PlaningTransactionBasis,
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
		|	QueryTable.ReceiptDocument,
		|	QueryTable.Key AS Key
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.CashAccount AS Account,
		|	tmp.Currency AS Currency,
		|	tmp.PlaningTransactionBasis AS BasisDocument,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
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
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period,
		|	tmp.Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.PlaningTransactionBasis.Date IS NULL
		|GROUP BY
		|	tmp.Company,
		|	tmp.CashAccount,
		|	tmp.Currency,
		|	tmp.PlaningTransactionBasis,
		|	tmp.Period,
		|	VALUE(Enum.CashFlowDirections.Incoming),
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.IncomingPaymentOrder)
		|			THEN tmp.Payer
		|		ELSE VALUE(Catalog.Companies.EmptyRef)
		|	END,
		|	tmp.Key
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
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
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3015B_CashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
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
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.CashInTransit));

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
	ArrayAll.Add("CashAccount");
	ArrayAll.Add("Company");
	ArrayAll.Add("Currency");
	ArrayAll.Add("TransactionType");
	ArrayAll.Add("CurrencyExchange");
	ArrayAll.Add("Payer");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payer");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("PaymentList.AmountExchange");
	
	ArrayByType = New Array();
	If TransactionType = Enums.IncomingPaymentTransactionType.CashTransferOrder Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("CurrencyExchange");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		ArrayByType.Add("PaymentList.AmountExchange");
		
	ElsIf TransactionType = Enums.IncomingPaymentTransactionType.PaymentFromCustomer
	 	Or TransactionType = Enums.IncomingPaymentTransactionType.ReturnFromVendor Then
		ArrayByType.Add("CashAccount");
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
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3015B_CashAdvance());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(T1002I_PartnerAdvances());
	QueryArray.Add(T1001I_PartnerTransactions());
	Return QueryArray;
EndFunction

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
	|	PaymentList.Partner.Employee AS IsEmployee,
	|	PaymentList.Amount,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS
	|		IsPaymentFromCustomer,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CurrencyExchange) AS IsCurrencyExchange,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.CashTransferOrder) AS
	|		IsCashTransferOrder,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.IncomingPaymentTransactionType.TransferFromPOS) AS IsTransferFromPOS,
	|	PaymentList.Ref.TransactionType
	|   = VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS IsReturnFromVendor,
	|	PaymentList.Ref.IgnoreAdvances AS IgnoreAdvances,
	|	PaymentList.Partner
	|INTO PaymentList
	|FROM
	|	Document.CashReceipt.PaymentList AS PaymentList
	|WHERE
	|	PaymentList.Ref = &Ref";	
EndFunction

Function R5010B_ReconciliationStatement()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	*
	|INTO R5010B_ReconciliationStatement
	|FROM
	|	PaymentList";	
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.CashAccount AS Account,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	OR PaymentList.IsCashTransferOrder";
EndFunction

Function R3015B_CashAdvance()
	Return
		"SELECT
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
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument AS Basis,
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
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
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
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Basis,
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
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.AdvancesDocument,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R1020B_AdvancesToVendors()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
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

Function T1002I_PartnerAdvances()
	Return
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Basis AS AdvancesDocument,
		|	PaymentList.Amount,
		|	PaymentList.Key,
		|	TRUE AS IsCustomerAdvance
		|INTO T1002I_PartnerAdvances
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	AND PaymentList.IsAdvance";	
EndFunction

Function T1001I_PartnerTransactions()
	Return
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
		|	PaymentList.Currency,
		|	PaymentList.Agreement,
		|	PaymentList.TransactionDocument,
		|	PaymentList.Key,
		|	PaymentList.Amount,
		|	TRUE AS IsPaymentFromCustomer
		|INTO T1001I_PartnerTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentFromCustomer
		|	AND NOT PaymentList.IsAdvance";
EndFunction

#EndRegion
