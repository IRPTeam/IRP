#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PlaningCashTransactions"               , PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("CashInTransit"                         , PostingServer.CreateTable(AccReg.CashInTransit));
	
	QueryPaymentList = New Query();
	QueryPaymentList.Text = GetQueryTextCashPaymentPaymentList();
	QueryPaymentList.SetParameter("Ref", Ref);
	QueryResultsPaymentList = QueryPaymentList.Execute();	
	QueryTablePaymentList = QueryResultsPaymentList.Unload();
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTablePaymentList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PlaningCashTransactions  = QueryResults[1].Unload();
	Tables.CashInTransit            = QueryResults[2].Unload();

#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Function GetQueryTextCashPaymentPaymentList()
	Return
		"SELECT
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
		|	CashPaymentPaymentList.Amount AS Amount,
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
		|	CashPaymentPaymentList.Key AS Key
		|FROM
		|	Document.CashPayment.PaymentList AS CashPaymentPaymentList
		|WHERE
		|	CashPaymentPaymentList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
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
		|	VALUE(Enum.CashFlowDirections.Outgoing),
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Partner
		|		ELSE VALUE(Catalog.Partners.EmptyRef)
		|	END,
		|	CASE
		|		WHEN VALUETYPE(tmp.PlaningTransactionBasis) = TYPE(Document.OutgoingPaymentOrder)
		|			THEN tmp.Payee
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
	
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
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
			AccumulationRecordType.Receipt,
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
	ArrayAll.Add("Payee");
	ArrayAll.Add("TransactionType");
	ArrayAll.Add("Description");
	
	ArrayAll.Add("PaymentList.BasisDocument");
	ArrayAll.Add("PaymentList.Partner");
	ArrayAll.Add("PaymentList.Payee");
	ArrayAll.Add("PaymentList.Agreement");
	ArrayAll.Add("PaymentList.PlaningTransactionBasis");
	ArrayAll.Add("PaymentList.Amount");
	
	ArrayByType = New Array();
	If TransactionType = Enums.OutgoingPaymentTransactionTypes.CashTransferOrder Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.CurrencyExchange Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
	ElsIf TransactionType = Enums.OutgoingPaymentTransactionTypes.PaymentToVendor 
		Or TransactionType = Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer  Then
		ArrayByType.Add("CashAccount");
		ArrayByType.Add("Company");
		ArrayByType.Add("Currency");
		ArrayByType.Add("Payee");
		ArrayByType.Add("TransactionType");
		ArrayByType.Add("Description");
		
		ArrayByType.Add("PaymentList.BasisDocument");
		ArrayByType.Add("PaymentList.Partner");
		ArrayByType.Add("PaymentList.Agreement");
		ArrayByType.Add("PaymentList.Payee");
		ArrayByType.Add("PaymentList.PlaningTransactionBasis");
		ArrayByType.Add("PaymentList.Amount");
		
	Else 
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
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	Return QueryArray;
EndFunction

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
	|	PaymentList.Partner.Employee AS IsEmployee,
	|	PaymentList.Amount,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS IsPaymentToVendor,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CurrencyExchange) AS IsCurrencyExchange,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.CashTransferOrder) AS
	|		IsCashTransferOrder,
	|	PaymentList.Ref.TransactionType = VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS IsReturnToCustomer,
	|	PaymentList.Partner
	|INTO PaymentList
	|FROM
	|	Document.CashPayment.PaymentList AS PaymentList
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
		|	PaymentList.LegalName,
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
		|	PaymentList.LegalName,
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
		|	PaymentList.LegalName,
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
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Partner,
		|	PaymentList.LegalName,
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
	|	*
	|INTO R5010B_ReconciliationStatement
	|FROM
	|	PaymentList";	
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.CashAccount AS Account,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPaymentToVendor
		|	OR PaymentList.IsCashTransferOrder";
EndFunction

Function R3015B_CashAdvance()
	Return
		"SELECT
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

#EndRegion