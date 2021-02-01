#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	InvoiceMatchTransactions.Ref.Company AS Company,
		|	InvoiceMatchTransactions.Ref.PartnerApTransactionsBasisDocument AS ApBasisDocument,
		|	InvoiceMatchTransactions.PartnerApTransactionsBasisDocument AS Revers_ApBasisDocument,
		|	InvoiceMatchTransactions.Ref.PartnerArTransactionsBasisDocument AS ArBasisDocument,
		|	InvoiceMatchTransactions.PartnerArTransactionsBasisDocument AS Revers_ArBasisDocument,
		|	InvoiceMatchTransactions.Ref.Partner AS Partner,
		|	InvoiceMatchTransactions.Partner AS Revers_Partner,
		|	InvoiceMatchTransactions.Ref.LegalName AS LegalName,
		|	InvoiceMatchTransactions.LegalName AS Revers_LegalName,
		|	InvoiceMatchTransactions.Ref.Agreement AS Agreement,
		|	InvoiceMatchTransactions.Agreement AS Revers_Agreement,
		|	InvoiceMatchTransactions.Ref.Currency AS Currency,
		|	InvoiceMatchTransactions.Currency AS Revers_Currency,
		|	InvoiceMatchTransactions.ClosingAmount AS Amount,
		|	InvoiceMatchTransactions.Amount AS Revers_Amount,
		|	InvoiceMatchTransactions.Ref.Date AS Period,
		|	InvoiceMatchTransactions.Ref.OperationType AS OperationType,
		|	InvoiceMatchTransactions.Key AS Key
		|FROM
		|	Document.InvoiceMatch.Transactions AS InvoiceMatchTransactions
		|WHERE
		|	InvoiceMatchTransactions.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_Transactions = QueryResults.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	InvoiceMatchAdvances.Ref.Company AS Company,
		|	InvoiceMatchAdvances.ReceiptDocument,
		|	InvoiceMatchAdvances.DocumentPartner AS DocumentPartner,
		|	InvoiceMatchAdvances.PaymentDocument,
		|	InvoiceMatchAdvances.Partner,
		|	InvoiceMatchAdvances.LegalName,
		|	InvoiceMatchAdvances.Currency,
		|	InvoiceMatchAdvances.Ref.Currency AS RefCurrency,
		|	InvoiceMatchAdvances.Amount,
		|	InvoiceMatchAdvances.ClosingAmount,
		|	InvoiceMatchAdvances.CurrencyRate,
		|	InvoiceMatchAdvances.CurrencyMultiplicity,
		|	InvoiceMatchAdvances.Ref.Date AS Period,
		|	InvoiceMatchAdvances.Ref.PartnerArTransactionsBasisDocument AS ArBasisDocument,
		|	InvoiceMatchAdvances.Ref.PartnerApTransactionsBasisDocument AS ApBasisDocument,
		|	InvoiceMatchAdvances.Ref.OperationType AS OperationType,
		|	InvoiceMatchAdvances.Ref.Agreement AS Agreement,
		|	InvoiceMatchAdvances.Key AS Key
		|FROM
		|	Document.InvoiceMatch.Advances AS InvoiceMatchAdvances
		|WHERE
		|	InvoiceMatchAdvances.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_Advances = QueryResults.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable_Transactions.Company AS Company,
		|	QueryTable_Transactions.ApBasisDocument AS ApBasisDocument,
		|	QueryTable_Transactions.Revers_ApBasisDocument AS Revers_ApBasisDocument,
		|	QueryTable_Transactions.ArBasisDocument AS ArBasisDocument,
		|	QueryTable_Transactions.Revers_ArBasisDocument AS Revers_ArBasisDocument,
		|	QueryTable_Transactions.Partner AS Partner,
		|	QueryTable_Transactions.Revers_Partner AS Revers_Partner,
		|	QueryTable_Transactions.LegalName AS LegalName,
		|	QueryTable_Transactions.Revers_LegalName AS Revers_LegalName,
		|	QueryTable_Transactions.Agreement AS Agreement,
		|	QueryTable_Transactions.Revers_Agreement AS Revers_Agreement,
		|	QueryTable_Transactions.Currency AS Currency,
		|	QueryTable_Transactions.Revers_Currency AS Revers_Currency,
		|	QueryTable_Transactions.Amount AS Amount,
		|	QueryTable_Transactions.Revers_Amount AS Revers_Amount,
		|	QueryTable_Transactions.Period AS Period,
		|	QueryTable_Transactions.OperationType AS OperationType,
		|	QueryTable_Transactions.Key AS Key
		|INTO tmp_transactions
		|FROM
		|	&QueryTable_Transactions AS QueryTable_Transactions
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	QueryTable_Advances.Company,
		|	QueryTable_Advances.ReceiptDocument,
		|	QueryTable_Advances.DocumentPartner AS DocumentPartner,
		|	QueryTable_Advances.PaymentDocument,
		|	QueryTable_Advances.Partner,
		|	QueryTable_Advances.LegalName,
		|	QueryTable_Advances.Currency,
		|	QueryTable_Advances.RefCurrency,
		|	QueryTable_Advances.Amount,
		|	QueryTable_Advances.ClosingAmount,
		|	QueryTable_Advances.CurrencyRate,
		|	QueryTable_Advances.CurrencyMultiplicity,
		|	QueryTable_Advances.Period,
		|	QueryTable_Advances.OperationType,
		|	QueryTable_Advances.ArBasisDocument,
		|	QueryTable_Advances.ApBasisDocument,
		|	QueryTable_Advances.Agreement,
		|	QueryTable_Advances.Key
		|INTO tmp_advances
		|FROM
		|	&QueryTable_Advances AS QueryTable_Advances
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_transactions.Company AS Company,
		|	tmp_transactions.Revers_ApBasisDocument AS BasisDocument,
		|	tmp_transactions.Revers_Partner AS Partner,
		|	tmp_transactions.Revers_LegalName AS LegalName,
		|	tmp_transactions.Revers_Agreement AS Agreement,
		|	tmp_transactions.Revers_Currency AS Currency,
		|	-SUM(tmp_transactions.Revers_Amount) AS Amount,
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|FROM
		|	tmp_transactions AS tmp_transactions
		|WHERE
		|	tmp_transactions.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithVendor)
		|GROUP BY
		|	tmp_transactions.Company,
		|	tmp_transactions.Revers_ApBasisDocument,
		|	tmp_transactions.Revers_Partner,
		|	tmp_transactions.Revers_LegalName,
		|	tmp_transactions.Revers_Agreement,
		|	tmp_transactions.Revers_Currency,
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|
		|UNION ALL
		|
		|SELECT
		|	tmp_transactions.Company,
		|	tmp_transactions.ApBasisDocument,
		|	tmp_transactions.Partner,
		|	tmp_transactions.LegalName,
		|	tmp_transactions.Agreement,
		|	tmp_transactions.Currency,
		|	SUM(tmp_transactions.Amount),
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|FROM
		|	tmp_transactions AS tmp_transactions
		|WHERE
		|	tmp_transactions.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithVendor)
		|GROUP BY
		|	tmp_transactions.Company,
		|	tmp_transactions.ApBasisDocument,
		|	tmp_transactions.Partner,
		|	tmp_transactions.LegalName,
		|	tmp_transactions.Agreement,
		|	tmp_transactions.Currency,
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|
		|UNION ALL
		|
		|SELECT
		|	tmp_advances.Company,
		|	tmp_advances.ApBasisDocument,
		|	tmp_advances.Partner,
		|	tmp_advances.LegalName,
		|	tmp_advances.Agreement,
		|	tmp_advances.RefCurrency,
		|	SUM(tmp_advances.ClosingAmount),
		|	tmp_advances.Period,
		|	tmp_advances.Key
		|FROM
		|	tmp_advances AS tmp_advances
		|WHERE
		|	tmp_advances.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithVendor)
		|GROUP BY
		|	tmp_advances.Company,
		|	tmp_advances.ApBasisDocument,
		|	tmp_advances.Partner,
		|	tmp_advances.LegalName,
		|	tmp_advances.Agreement,
		|	tmp_advances.RefCurrency,
		|	tmp_advances.Period,
		|	tmp_advances.Key
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_transactions.Company AS Company,
		|	tmp_transactions.Revers_ArBasisDocument AS BasisDocument,
		|	tmp_transactions.Revers_Partner AS Partner,
		|	tmp_transactions.Revers_LegalName AS LegalName,
		|	tmp_transactions.Revers_Agreement AS Agreement,
		|	tmp_transactions.Revers_Currency AS Currency,
		|	-SUM(tmp_transactions.Revers_Amount) AS Amount,
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|FROM
		|	tmp_transactions AS tmp_transactions
		|WHERE
		|	tmp_transactions.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithCustomer)
		|GROUP BY
		|	tmp_transactions.Company,
		|	tmp_transactions.Revers_ArBasisDocument,
		|	tmp_transactions.Revers_Partner,
		|	tmp_transactions.Revers_LegalName,
		|	tmp_transactions.Revers_Agreement,
		|	tmp_transactions.Revers_Currency,
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|
		|UNION ALL
		|
		|SELECT
		|	tmp_transactions.Company,
		|	tmp_transactions.ArBasisDocument,
		|	tmp_transactions.Partner,
		|	tmp_transactions.LegalName,
		|	tmp_transactions.Agreement,
		|	tmp_transactions.Currency,
		|	SUM(tmp_transactions.Amount),
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|FROM
		|	tmp_transactions AS tmp_transactions
		|WHERE
		|	tmp_transactions.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithCustomer)
		|GROUP BY
		|	tmp_transactions.Company,
		|	tmp_transactions.ArBasisDocument,
		|	tmp_transactions.Partner,
		|	tmp_transactions.LegalName,
		|	tmp_transactions.Agreement,
		|	tmp_transactions.Currency,
		|	tmp_transactions.Period,
		|	tmp_transactions.Key
		|
		|UNION ALL
		|
		|SELECT
		|	tmp_advances.Company,
		|	tmp_advances.ArBasisDocument,
		|	tmp_advances.Partner,
		|	tmp_advances.LegalName,
		|	tmp_advances.Agreement,
		|	tmp_advances.RefCurrency,
		|	SUM(tmp_advances.ClosingAmount),
		|	tmp_advances.Period,
		|	tmp_advances.Key
		|FROM
		|	tmp_advances AS tmp_advances
		|WHERE
		|	tmp_advances.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithCustomer)
		|GROUP BY
		|	tmp_advances.Company,
		|	tmp_advances.ArBasisDocument,
		|	tmp_advances.Partner,
		|	tmp_advances.LegalName,
		|	tmp_advances.Agreement,
		|	tmp_advances.RefCurrency,
		|	tmp_advances.Period,
		|	tmp_advances.Key
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_advances.Company,
		|	tmp_advances.LegalName,
		|	tmp_advances.Partner,
		|	tmp_advances.Currency,
		|	tmp_advances.ReceiptDocument,
		|	tmp_advances.Period,
		|	SUM(tmp_advances.ClosingAmount) AS Amount,
		|	tmp_advances.Key
		|FROM
		|	tmp_advances AS tmp_advances
		|WHERE
		|	tmp_advances.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithCustomer)
		|GROUP BY
		|	tmp_advances.Company,
		|	tmp_advances.LegalName,
		|	tmp_advances.Partner,
		|	tmp_advances.Currency,
		|	tmp_advances.ReceiptDocument,
		|	tmp_advances.Period,
		|	tmp_advances.Key
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp_advances.Company,
		|	tmp_advances.Partner,
		|	tmp_advances.LegalName,
		|	tmp_advances.Currency,
		|	tmp_advances.PaymentDocument,
		|	tmp_advances.Period,
		|	SUM(tmp_advances.ClosingAmount) AS Amount,
		|	tmp_advances.Key
		|FROM
		|	tmp_advances AS tmp_advances
		|WHERE
		|	tmp_advances.OperationType = VALUE(enum.InvoiceMatchOperationsTypes.WithVendor)
		|GROUP BY
		|	tmp_advances.Company,
		|	tmp_advances.Partner,
		|	tmp_advances.LegalName,
		|	tmp_advances.Currency,
		|	tmp_advances.PaymentDocument,
		|	tmp_advances.Period,
		|	tmp_advances.Key";
	
	Query.SetParameter("QueryTable_Transactions", QueryTable_Transactions);
	Query.SetParameter("QueryTable_Advances", QueryTable_Advances);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables = New Structure();
	
	Tables.Insert("PartnerApTransactions", QueryResults[2].Unload());
	Tables.Insert("PartnerArTransactions", QueryResults[3].Unload());
	
	Tables.Insert("AdvanceFromCustomers", QueryResults[4].Unload());
	Tables.Insert("AdvanceToSuppliers", QueryResults[5].Unload());
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("LegalName", "LegalName");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerApTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerApTransactions));
	
	// PartnerArTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("LegalName", "LegalName");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerApTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerArTransactions));
	
	// AdvanceFromCustomers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceFromCustomers",
		New Structure("Fields, Data", Fields, DocumentDataTables.AdvanceFromCustomers));
	
	// AdvanceToSuppliers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceToSuppliers",
		New Structure("Fields, Data", Fields, DocumentDataTables.AdvanceToSuppliers));
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// PartnerApTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerApTransactions));
	
	// PartnerApTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.PartnerArTransactions));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.AdvanceFromCustomers));
	
	// AdvanceToSuppliers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.AdvanceToSuppliers));
	
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

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

#EndRegion
