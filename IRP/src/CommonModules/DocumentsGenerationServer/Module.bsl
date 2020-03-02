
#Region ExtractDataFormBasisesDocuments

Function GetQueryFilters(AccReg, ArrayOfBasisDocuments)
	Filter_ByDocuments = New ValueTable();
	Filter_ByDocuments.Columns.Add("BasisDocument" , New TypeDescription(AccReg.Dimensions.BasisDocument.Type));
	
	Filter_ByAgreements = New ValueTable();
	Filter_ByAgreements.Columns.Add("Company", New TypeDescription(AccReg.Dimensions.Company.Type));
	Filter_ByAgreements.Columns.Add("Currency", New TypeDescription(AccReg.Dimensions.Currency.Type));
	Filter_ByAgreements.Columns.Add("Agreement", New TypeDescription(AccReg.Dimensions.Agreement.Type));
	Filter_ByAgreements.Columns.Add("Partner", New TypeDescription(AccReg.Dimensions.Partner.Type));
	Filter_ByAgreements.Columns.Add("LegalName", New TypeDescription(AccReg.Dimensions.LegalName.Type));
	
	Filter_ByStandardAgreement = New ValueTable();
	Filter_ByStandardAgreement.Columns.Add("Company", New TypeDescription(AccReg.Dimensions.Company.Type));
	Filter_ByStandardAgreement.Columns.Add("Currency", New TypeDescription(AccReg.Dimensions.Currency.Type));
	Filter_ByStandardAgreement.Columns.Add("Agreement", New TypeDescription(AccReg.Dimensions.Agreement.Type));
	Filter_ByStandardAgreement.Columns.Add("Partner", New TypeDescription(AccReg.Dimensions.Partner.Type));
	Filter_ByStandardAgreement.Columns.Add("LegalName", New TypeDescription(AccReg.Dimensions.LegalName.Type));
	
	For Each BasisDocument In ArrayOfBasisDocuments Do
		InvoiceData = New Structure();
		
		InvoiceData.Insert("Company", BasisDocument.Company);
		InvoiceData.Insert("Currency", BasisDocument.Currency);
		InvoiceData.Insert("Partner", BasisDocument.Partner);
		InvoiceData.Insert("LegalName", BasisDocument.LegalName);
		
		NewRow = Undefined;
		If ValueIsFilled(BasisDocument.Agreement) Then
			If BasisDocument.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByDocuments Then
				InvoiceData.Insert("BasisDocument", BasisDocument);
				NewRow = Filter_ByDocuments.Add();
			ElsIf BasisDocument.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByAgreements Then
				InvoiceData.Insert("Agreement", BasisDocument.Agreement);
				NewRow = Filter_ByAgreements.Add();
			ElsIf BasisDocument.Agreement.ApArPostingDetail = Enums.ApArPostingDetail.ByStandardAgreement Then
				InvoiceData.Insert("Agreement", BasisDocument.Agreement.StandardAgreement);
				NewRow = Filter_ByStandardAgreement.Add();
			EndIf;
			FillPropertyValues(NewRow, InvoiceData);
		EndIf;
	EndDo;
	
	Result = New Structure();
	Result.Insert("Filter_ByDocuments", Filter_ByDocuments);
	Result.Insert("Filter_ByAgreements", Filter_ByAgreements);
	Result.Insert("Filter_ByStandardAgreement", Filter_ByStandardAgreement);
	Return Result;
EndFunction

Procedure PutQueryFiltersToTempTables(TempTableManager, Filters)
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text =
		"SELECT
		|	tmp.BasisDocument AS BasisDocument
		|INTO Filter_ByDocuments
		|FROM
		|	&Filter_ByDocuments AS tmp
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Currency AS Currency,
		|	tmp.Agreement AS Agreement,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName
		|INTO Filter_ByAgreements
		|FROM
		|	&Filter_ByAgreements AS tmp
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Currency AS Currency,
		|	tmp.Agreement AS Agreement,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName
		|INTO Filter_ByStandardAgreement
		|FROM
		|	&Filter_ByStandardAgreement AS tmp";
	// put value tables to temp tables
	Query.SetParameter("Filter_ByDocuments", Filters.Filter_ByDocuments);
	Query.SetParameter("Filter_ByAgreements", Filters.Filter_ByAgreements);
	Query.SetParameter("Filter_ByStandardAgreement", Filters.Filter_ByStandardAgreement);
	Query.Execute();
EndProcedure	

Function GetDocumentTable_PurchaseInvoice_ForPayment(ArrayOfBasisDocuments, AddInfo = Undefined) Export

	Filters = GetQueryFilters(Metadata.AccumulationRegisters.PartnerApTransactions, ArrayOfBasisDocuments);
	
	TempTableManager = New TempTablesManager();
	PutQueryFiltersToTempTables(TempTableManager, Filters);
	
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text = 
		"SELECT
		|	""PurchaseInvoice"" AS BasedOn,
		|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS TransactionType,
		|	PartnerTransactionsBalance.Company AS Company,
		|	PartnerTransactionsBalance.Currency AS Currency,
		|	PartnerTransactionsBalance.Partner AS Partner,
		|	PartnerTransactionsBalance.Agreement AS StandardAgreement,
		|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
		|	PartnerTransactionsBalance.LegalName AS LegalName,
		|	PartnerTransactionsBalance.AmountBalance AS Amount
		|FROM
		|	AccumulationRegister.PartnerApTransactions.Balance(, (Company, Currency, Agreement, Partner, LegalName) IN
		|		(SELECT
		|			tmp.Company,
		|			tmp.Currency,
		|			tmp.Agreement,
		|			tmp.Partner,
		|			tmp.LegalName
		|		FROM
		|			Filter_ByStandardAgreement AS tmp)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerTransactionsBalance
		|WHERE
		|	PartnerTransactionsBalance.AmountBalance > 0";
	
	// get default agreement by partner for standard agreement
	QueryResult = Query.Execute();
	QueryTable_StandardAgreements = QueryResult.Unload();
	For Each Row In QueryTable_StandardAgreements Do
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, Row.Partner);
		AgreementParameters.Insert("Agreement"		, Catalogs.Agreements.EmptyRef());
		AgreementParameters.Insert("ArrayOfFilters"	, New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("StandardAgreement", Row.StandardAgreement, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", Enums.AgreementKinds.Regular, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", Enums.AgreementTypes.Vendor, ComparisonType.Equal));
		Row.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	EndDo;
	
	Query.Text = 
		"SELECT
		|	tmp.BasedOn,
		|	tmp.TransactionType AS TransactionType,
		|	tmp.Company AS Company,
		|	tmp.Currency AS Currency,
		|	tmp.Partner AS Partner,
		|	tmp.Agreement AS Agreement,
		|	tmp.LegalName AS LegalName,
		|	tmp.Amount AS Amount
		|INTO QueryTable_StandardAgreements
		|FROM
		|	&QueryTable_StandardAgreements AS tmp
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	""PurchaseInvoice"" AS BasedOn,
		|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS TransactionType,
		|	PartnerTransactionsBalance.Company,
		|	PartnerTransactionsBalance.Currency,
		|	PartnerTransactionsBalance.BasisDocument,
		|	PartnerTransactionsBalance.Partner,
		|	PartnerTransactionsBalance.Agreement,
		|	PartnerTransactionsBalance.LegalName AS Payee,
		|	PartnerTransactionsBalance.AmountBalance AS Amount
		|FROM
		|	AccumulationRegister.PartnerApTransactions.Balance(, BasisDocument IN
		|		(SELECT
		|			tmp.BasisDocument
		|		FROM
		|			Filter_ByDocuments AS tmp)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerTransactionsBalance
		|WHERE
		|	PartnerTransactionsBalance.AmountBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	""PurchaseInvoice"",
		|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor),
		|	PartnerTransactionsBalance.Company,
		|	PartnerTransactionsBalance.Currency,
		|	UNDEFINED,
		|	PartnerTransactionsBalance.Partner,
		|	PartnerTransactionsBalance.Agreement,
		|	PartnerTransactionsBalance.LegalName,
		|	PartnerTransactionsBalance.AmountBalance
		|FROM
		|	AccumulationRegister.PartnerApTransactions.Balance(, (Company, Currency, Agreement, Partner, LegalName) IN
		|		(SELECT
		|			tmp.Company,
		|			tmp.Currency,
		|			tmp.Agreement,
		|			tmp.Partner,
		|			tmp.LegalName
		|		FROM
		|			Filter_ByAgreements AS tmp)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerTransactionsBalance
		|WHERE
		|	PartnerTransactionsBalance.AmountBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	QueryTable_StandardAgreements.BasedOn,
		|	QueryTable_StandardAgreements.TransactionType,
		|	QueryTable_StandardAgreements.Company,
		|	QueryTable_StandardAgreements.Currency,
		|	UNDEFINED,
		|	QueryTable_StandardAgreements.Partner,
		|	QueryTable_StandardAgreements.Agreement,
		|	QueryTable_StandardAgreements.LegalName,
		|	QueryTable_StandardAgreements.Amount
		|FROM
		|	QueryTable_StandardAgreements AS QueryTable_StandardAgreements";
		
	Query.SetParameter("QueryTable_StandardAgreements", QueryTable_StandardAgreements);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_SalesInvoice_ForReceipt(ArrayOfBasisDocuments, AddInfo = Undefined) Export
	
	Filters = GetQueryFilters(Metadata.AccumulationRegisters.PartnerArTransactions, ArrayOfBasisDocuments);
	
	TempTableManager = New TempTablesManager();
	PutQueryFiltersToTempTables(TempTableManager, Filters);
	
	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text = 
		"SELECT
		|	""SalesInvoice"" AS BasedOn,
		|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
		|	PartnerTransactionsBalance.Company AS Company,
		|	PartnerTransactionsBalance.Currency AS Currency,
		|	PartnerTransactionsBalance.Partner AS Partner,
		|	PartnerTransactionsBalance.Agreement AS StandardAgreement,
		|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
		|	PartnerTransactionsBalance.LegalName AS LegalName,
		|	PartnerTransactionsBalance.AmountBalance AS Amount
		|FROM
		|	AccumulationRegister.PartnerArTransactions.Balance(, (Company, Currency, Agreement, Partner, LegalName) IN
		|		(SELECT
		|			tmp.Company,
		|			tmp.Currency,
		|			tmp.Agreement,
		|			tmp.Partner,
		|			tmp.LegalName
		|		FROM
		|			Filter_ByStandardAgreement AS tmp)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerTransactionsBalance
		|WHERE
		|	PartnerTransactionsBalance.AmountBalance > 0";
	
	// get default agreement by partner for standard agreement
	QueryResult = Query.Execute();
	QueryTable_StandardAgreements = QueryResult.Unload();
	For Each Row In QueryTable_StandardAgreements Do
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, Row.Partner);
		AgreementParameters.Insert("Agreement"		, Catalogs.Agreements.EmptyRef());
		AgreementParameters.Insert("ArrayOfFilters"	, New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("StandardAgreement", Row.StandardAgreement, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", Enums.AgreementKinds.Regular, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", Enums.AgreementTypes.Customer, ComparisonType.Equal));
		
		Row.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	EndDo;
	
	Query.Text = 
		"SELECT
		|	tmp.BasedOn,
		|	tmp.TransactionType AS TransactionType,
		|	tmp.Company AS Company,
		|	tmp.Currency AS Currency,
		|	tmp.Partner AS Partner,
		|	tmp.Agreement AS Agreement,
		|	tmp.LegalName AS LegalName,
		|	tmp.Amount AS Amount
		|INTO QueryTable_StandardAgreements
		|FROM
		|	&QueryTable_StandardAgreements AS tmp
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	""SalesInvoice"" AS BasedOn,
		|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
		|	PartnerTransactionsBalance.Company,
		|	PartnerTransactionsBalance.Currency,
		|	PartnerTransactionsBalance.BasisDocument,
		|	PartnerTransactionsBalance.Partner,
		|	PartnerTransactionsBalance.Agreement,
		|	PartnerTransactionsBalance.LegalName AS Payer,
		|	PartnerTransactionsBalance.AmountBalance AS Amount
		|FROM
		|	AccumulationRegister.PartnerArTransactions.Balance(, BasisDocument IN
		|		(SELECT
		|			tmp.BasisDocument
		|		FROM
		|			Filter_ByDocuments AS tmp)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerTransactionsBalance
		|WHERE
		|	PartnerTransactionsBalance.AmountBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	""SalesInvoice"",
		|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer),
		|	PartnerTransactionsBalance.Company,
		|	PartnerTransactionsBalance.Currency,
		|	UNDEFINED,
		|	PartnerTransactionsBalance.Partner,
		|	PartnerTransactionsBalance.Agreement,
		|	PartnerTransactionsBalance.LegalName,
		|	PartnerTransactionsBalance.AmountBalance
		|FROM
		|	AccumulationRegister.PartnerArTransactions.Balance(, (Company, Currency, Agreement, Partner, LegalName) IN
		|		(SELECT
		|			tmp.Company,
		|			tmp.Currency,
		|			tmp.Agreement,
		|			tmp.Partner,
		|			tmp.LegalName
		|		FROM
		|			Filter_ByAgreements AS tmp)
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		PartnerTransactionsBalance
		|WHERE
		|	PartnerTransactionsBalance.AmountBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	QueryTable_StandardAgreements.BasedOn,
		|	QueryTable_StandardAgreements.TransactionType,
		|	QueryTable_StandardAgreements.Company,
		|	QueryTable_StandardAgreements.Currency,
		|	UNDEFINED,
		|	QueryTable_StandardAgreements.Partner,
		|	QueryTable_StandardAgreements.Agreement,
		|	QueryTable_StandardAgreements.LegalName,
		|	QueryTable_StandardAgreements.Amount
		|FROM
		|	QueryTable_StandardAgreements AS QueryTable_StandardAgreements";
		
	Query.SetParameter("QueryTable_StandardAgreements", QueryTable_StandardAgreements);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

#EndRegion