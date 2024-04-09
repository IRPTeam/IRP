#Region ExtractDataFormBasisesDocuments

Function GetQueryFilters(AccReg, ArrayOfBasisDocuments)
	Filter_ByDocuments = New ValueTable();
	Filter_ByDocuments.Columns.Add("BasisDocument", New TypeDescription(AccReg.Dimensions.Basis.Type));

	Filter_ByAgreements = New ValueTable();
	Filter_ByAgreements.Columns.Add("Company"   , New TypeDescription(AccReg.Dimensions.Company.Type));
	Filter_ByAgreements.Columns.Add("Branch"    , New TypeDescription(AccReg.Dimensions.Branch.Type));
	Filter_ByAgreements.Columns.Add("Currency"  , New TypeDescription(AccReg.Dimensions.Currency.Type));
	Filter_ByAgreements.Columns.Add("Agreement" , New TypeDescription(AccReg.Dimensions.Agreement.Type));
	Filter_ByAgreements.Columns.Add("Partner"   , New TypeDescription(AccReg.Dimensions.Partner.Type));
	Filter_ByAgreements.Columns.Add("LegalName" , New TypeDescription(AccReg.Dimensions.LegalName.Type));

	Filter_ByStandardAgreement = New ValueTable();
	Filter_ByStandardAgreement.Columns.Add("Company"   , New TypeDescription(AccReg.Dimensions.Company.Type));
	Filter_ByStandardAgreement.Columns.Add("Branch"    , New TypeDescription(AccReg.Dimensions.Branch.Type));
	Filter_ByStandardAgreement.Columns.Add("Currency"  , New TypeDescription(AccReg.Dimensions.Currency.Type));
	Filter_ByStandardAgreement.Columns.Add("Agreement" , New TypeDescription(AccReg.Dimensions.Agreement.Type));
	Filter_ByStandardAgreement.Columns.Add("Partner"   , New TypeDescription(AccReg.Dimensions.Partner.Type));
	Filter_ByStandardAgreement.Columns.Add("LegalName" , New TypeDescription(AccReg.Dimensions.LegalName.Type));

	For Each BasisDocument In ArrayOfBasisDocuments Do
		InvoiceData = New Structure();

		InvoiceData.Insert("Company"   , BasisDocument.Company);
		InvoiceData.Insert("Branch"    , BasisDocument.Branch);
		InvoiceData.Insert("Currency"  , BasisDocument.Currency);
		InvoiceData.Insert("Partner"   , BasisDocument.Partner);
		InvoiceData.Insert("LegalName" , BasisDocument.LegalName);

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
	Result.Insert("Filter_ByDocuments"         , Filter_ByDocuments);
	Result.Insert("Filter_ByAgreements"        , Filter_ByAgreements);
	Result.Insert("Filter_ByStandardAgreement" , Filter_ByStandardAgreement);
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
	|	tmp.Branch AS Branch,
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
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Agreement AS Agreement,
	|	tmp.Partner AS Partner,
	|	tmp.LegalName
	|INTO Filter_ByStandardAgreement
	|FROM
	|	&Filter_ByStandardAgreement AS tmp";
	// put value tables to temp tables
	Query.SetParameter("Filter_ByDocuments"         , Filters.Filter_ByDocuments);
	Query.SetParameter("Filter_ByAgreements"        , Filters.Filter_ByAgreements);
	Query.SetParameter("Filter_ByStandardAgreement" , Filters.Filter_ByStandardAgreement);
	Query.Execute();
EndProcedure

Function GetDocumentTable_PurchaseDocument_ForPayment(ArrayOfBasisDocuments, DocumentName) Export

	Filters = GetQueryFilters(Metadata.AccumulationRegisters.R1021B_VendorsTransactions, ArrayOfBasisDocuments);

	TempTableManager = New TempTablesManager();
	PutQueryFiltersToTempTables(TempTableManager, Filters);

	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text =
	"SELECT
	|	&DocumentName AS BasedOn,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS TransactionType,
	|	R1021B_VendorsTransactions.Company AS Company,
	|	R1021B_VendorsTransactions.Branch AS Branch,
	|	R1021B_VendorsTransactions.Currency AS Currency,
	|	R1021B_VendorsTransactions.Partner AS Partner,
	|	R1021B_VendorsTransactions.Agreement AS StandardAgreement,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R1021B_VendorsTransactions.LegalName AS LegalName,
	|	R1021B_VendorsTransactions.Order AS Order,
	|	R1021B_VendorsTransactions.Project AS Project,
	|	R1021B_VendorsTransactions.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByStandardAgreement AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1021B_VendorsTransactions
	|WHERE
	|	R1021B_VendorsTransactions.AmountBalance > 0";
	
	Query.SetParameter("DocumentName", DocumentName);
	
	// get default agreement by partner for standard agreement
	QueryResult = Query.Execute();
	QueryTable_StandardAgreements = QueryResult.Unload();
	For Each Row In QueryTable_StandardAgreements Do
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner", Row.Partner);
		AgreementParameters.Insert("Agreement", Catalogs.Agreements.EmptyRef());
		AgreementParameters.Insert("ArrayOfFilters", New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			ComparisonType.NotEqual));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("StandardAgreement",
			Row.StandardAgreement, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind",
			Enums.AgreementKinds.Regular, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type",
			Enums.AgreementTypes.Vendor, ComparisonType.Equal));
		Row.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	EndDo;

	Query.Text =
	"SELECT
	|	tmp.BasedOn,
	|	tmp.TransactionType AS TransactionType,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement,
	|	tmp.LegalName AS LegalName,
	|	tmp.Order AS Order,
	|	tmp.Project AS Project,
	|	tmp.Amount AS Amount
	|INTO QueryTable_StandardAgreements
	|FROM
	|	&QueryTable_StandardAgreements AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	&DocumentName AS BasedOn,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS TransactionType,
	|	R1021B_VendorsTransactions.Company,
	|	R1021B_VendorsTransactions.Branch,
	|	R1021B_VendorsTransactions.Currency,
	|	R1021B_VendorsTransactions.Basis AS BasisDocument,
	|	R1021B_VendorsTransactions.Partner,
	|	R1021B_VendorsTransactions.Agreement,
	|	R1021B_VendorsTransactions.LegalName AS Payee,
	|	R1021B_VendorsTransactions.Order AS Order,
	|	R1021B_VendorsTransactions.Project AS Project,
	|	R1021B_VendorsTransactions.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(, Basis IN
	|		(SELECT
	|			tmp.BasisDocument
	|		FROM
	|			Filter_ByDocuments AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1021B_VendorsTransactions
	|WHERE
	|	R1021B_VendorsTransactions.AmountBalance > 0
	|
	|UNION ALL
	|
	|SELECT
	|	&DocumentName,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor),
	|	PartnerTransactionsBalance.Company,
	|	PartnerTransactionsBalance.Branch,
	|	PartnerTransactionsBalance.Currency,
	|	UNDEFINED,
	|	PartnerTransactionsBalance.Partner,
	|	PartnerTransactionsBalance.Agreement,
	|	PartnerTransactionsBalance.LegalName,
	|	PartnerTransactionsBalance.Order,
	|	PartnerTransactionsBalance.Project,
	|	PartnerTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
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
	|	QueryTable_StandardAgreements.Branch,
	|	QueryTable_StandardAgreements.Currency,
	|	UNDEFINED,
	|	QueryTable_StandardAgreements.Partner,
	|	QueryTable_StandardAgreements.Agreement,
	|	QueryTable_StandardAgreements.LegalName,
	|	QueryTable_StandardAgreements.Order,
	|	QueryTable_StandardAgreements.Project,
	|	QueryTable_StandardAgreements.Amount
	|FROM
	|	QueryTable_StandardAgreements AS QueryTable_StandardAgreements";

	Query.SetParameter("QueryTable_StandardAgreements", QueryTable_StandardAgreements);
	Query.SetParameter("DocumentName", DocumentName);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_SalesDocument_ForReceipt(ArrayOfBasisDocuments, DocumentName) Export

	Filters = GetQueryFilters(Metadata.AccumulationRegisters.R2021B_CustomersTransactions, ArrayOfBasisDocuments);

	TempTableManager = New TempTablesManager();
	PutQueryFiltersToTempTables(TempTableManager, Filters);

	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text =
	"SELECT
	|	&DocumentName AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
	|	R2021B_CustomersTransactionsBalance.Company AS Company,
	|	R2021B_CustomersTransactionsBalance.Branch AS Branch,
	|	R2021B_CustomersTransactionsBalance.Currency AS Currency,
	|	R2021B_CustomersTransactionsBalance.Partner AS Partner,
	|	R2021B_CustomersTransactionsBalance.Agreement AS StandardAgreement,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R2021B_CustomersTransactionsBalance.LegalName AS LegalName,
	|	R2021B_CustomersTransactionsBalance.Order AS Order,
	|	R2021B_CustomersTransactionsBalance.Project AS Project,
	|	R2021B_CustomersTransactionsBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByStandardAgreement AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|WHERE
	|	R2021B_CustomersTransactionsBalance.AmountBalance > 0";
	
	// get default agreement by partner for standard agreement
	Query.SetParameter("DocumentName", DocumentName);
	QueryResult = Query.Execute();
	QueryTable_StandardAgreements = QueryResult.Unload();
	For Each Row In QueryTable_StandardAgreements Do
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner", Row.Partner);
		AgreementParameters.Insert("Agreement", Catalogs.Agreements.EmptyRef());
		AgreementParameters.Insert("ArrayOfFilters", New Array());
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
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement,
	|	tmp.LegalName AS LegalName,
	|	tmp.Order AS Order,
	|	tmp.Project AS Project,
	|	tmp.Amount AS Amount
	|INTO QueryTable_StandardAgreements
	|FROM
	|	&QueryTable_StandardAgreements AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	&DocumentName AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
	|	R2021B_CustomersTransactionsBalance.Company,
	|	R2021B_CustomersTransactionsBalance.Branch,
	|	R2021B_CustomersTransactionsBalance.Currency,
	|	R2021B_CustomersTransactionsBalance.Basis AS BasisDocument,
	|	R2021B_CustomersTransactionsBalance.Partner,
	|	R2021B_CustomersTransactionsBalance.Agreement,
	|	R2021B_CustomersTransactionsBalance.LegalName AS Payer,
	|	R2021B_CustomersTransactionsBalance.Order AS Order,
	|	R2021B_CustomersTransactionsBalance.Project AS Project,
	|	R2021B_CustomersTransactionsBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(, Basis IN
	|		(SELECT
	|			tmp.BasisDocument
	|		FROM
	|			Filter_ByDocuments AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|WHERE
	|	R2021B_CustomersTransactionsBalance.AmountBalance > 0
	|
	|UNION ALL
	|
	|SELECT
	|	&DocumentName,
	|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer),
	|	R2021B_CustomersTransactionsBalance.Company,
	|	R2021B_CustomersTransactionsBalance.Branch,
	|	R2021B_CustomersTransactionsBalance.Currency,
	|	UNDEFINED,
	|	R2021B_CustomersTransactionsBalance.Partner,
	|	R2021B_CustomersTransactionsBalance.Agreement,
	|	R2021B_CustomersTransactionsBalance.LegalName,
	|	R2021B_CustomersTransactionsBalance.Order,
	|	R2021B_CustomersTransactionsBalance.Project,
	|	R2021B_CustomersTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByAgreements AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|WHERE
	|	R2021B_CustomersTransactionsBalance.AmountBalance > 0
	|
	|UNION ALL
	|
	|SELECT
	|	QueryTable_StandardAgreements.BasedOn,
	|	QueryTable_StandardAgreements.TransactionType,
	|	QueryTable_StandardAgreements.Company,
	|	QueryTable_StandardAgreements.Branch,
	|	QueryTable_StandardAgreements.Currency,
	|	UNDEFINED,
	|	QueryTable_StandardAgreements.Partner,
	|	QueryTable_StandardAgreements.Agreement,
	|	QueryTable_StandardAgreements.LegalName,
	|	QueryTable_StandardAgreements.Order,
	|	QueryTable_StandardAgreements.Project,
	|	QueryTable_StandardAgreements.Amount
	|FROM
	|	QueryTable_StandardAgreements AS QueryTable_StandardAgreements";

	Query.SetParameter("QueryTable_StandardAgreements", QueryTable_StandardAgreements);
	Query.SetParameter("DocumentName", DocumentName);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_PurchaseOrder_ForPayment(ArrayOfBasisDocuments, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""PurchaseOrder"" AS BasedOn,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.PaymentToVendor) AS TransactionType,
	|	R3025B_PurchaseOrdersToBePaid.Company,
	|	R3025B_PurchaseOrdersToBePaid.Branch,
	|	R3025B_PurchaseOrdersToBePaid.Currency,
	|	R3025B_PurchaseOrdersToBePaid.Partner,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R3025B_PurchaseOrdersToBePaid.LegalName AS Payee,
	|	R3025B_PurchaseOrdersToBePaid.Order,
	|	R3025B_PurchaseOrdersToBePaid.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3025B_PurchaseOrdersToBePaid.Balance(, Order IN (&ArrayOfBasisDocuments)) AS R3025B_PurchaseOrdersToBePaid
	|WHERE
	|	R3025B_PurchaseOrdersToBePaid.AmountBalance > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_SalesOrder_ToBePaid(ArrayOfBasisDocuments) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""SalesOrder"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.PaymentFromCustomer) AS TransactionType,
	|	R3024B_SalesOrdersToBePaid.Company,
	|	R3024B_SalesOrdersToBePaid.Branch,
	|	R3024B_SalesOrdersToBePaid.Currency,
	|	R3024B_SalesOrdersToBePaid.Partner,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R3024B_SalesOrdersToBePaid.LegalName AS Payer,
	|	R3024B_SalesOrdersToBePaid.Order,
	|	R3024B_SalesOrdersToBePaid.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3024B_SalesOrdersToBePaid.Balance(, Order IN (&ArrayOfBasisDocuments)) AS
	|		R3024B_SalesOrdersToBePaid
	|WHERE
	|	R3024B_SalesOrdersToBePaid.AmountBalance > 0";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_SalesOrder_CustomerAdvance(ArrayOfBasisDocuments, PaymentTypeEnum) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	""SalesOrder"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.RetailCustomerAdvance) AS TransactionType,
	|	R3026B_SalesOrdersCustomerAdvance.Company,
	|	R3026B_SalesOrdersCustomerAdvance.Branch,
	|	R3026B_SalesOrdersCustomerAdvance.Currency,
	|	R3026B_SalesOrdersCustomerAdvance.RetailCustomer,
	|	R3026B_SalesOrdersCustomerAdvance.Order,
	|	R3026B_SalesOrdersCustomerAdvance.Account AS Account,
	|	R3026B_SalesOrdersCustomerAdvance.Account AS CashAccount,
	|	R3026B_SalesOrdersCustomerAdvance.PaymentType AS PaymentType,
	|	R3026B_SalesOrdersCustomerAdvance.PaymentTerminal AS PaymentTerminal,
	|	R3026B_SalesOrdersCustomerAdvance.BankTerm AS BankTerm,
	|	R3026B_SalesOrdersCustomerAdvance.CommissionBalance AS Commission,
	|	R3026B_SalesOrdersCustomerAdvance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3026B_SalesOrdersCustomerAdvance.Balance(, Order IN (&ArrayOfBasisDocuments)
	|	AND PaymentTypeEnum = &PaymentTypeEnum) AS R3026B_SalesOrdersCustomerAdvance";
	Query.SetParameter("ArrayOfBasisDocuments", ArrayOfBasisDocuments);
	Query.SetParameter("PaymentTypeEnum", PaymentTypeEnum);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_SalesReturn_ForPayment(ArrayOfBasisDocuments, AddInfo = Undefined) Export

	Filters = GetQueryFilters(Metadata.AccumulationRegisters.R2021B_CustomersTransactions, ArrayOfBasisDocuments);

	TempTableManager = New TempTablesManager();
	PutQueryFiltersToTempTables(TempTableManager, Filters);

	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text =
	"SELECT
	|	""SalesReturn"" AS BasedOn,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS TransactionType,
	|	R2021B_CustomersTransactionsBalance.Company AS Company,
	|	R2021B_CustomersTransactionsBalance.Branch AS Branch,
	|	R2021B_CustomersTransactionsBalance.Currency AS Currency,
	|	R2021B_CustomersTransactionsBalance.Partner AS Partner,
	|	R2021B_CustomersTransactionsBalance.Agreement AS StandardAgreement,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R2021B_CustomersTransactionsBalance.LegalName AS LegalName,
	|	R2021B_CustomersTransactionsBalance.Order AS Order,
	|	R2021B_CustomersTransactionsBalance.Project AS Project,
	|	R2021B_CustomersTransactionsBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByStandardAgreement AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|WHERE
	|	R2021B_CustomersTransactionsBalance.AmountBalance < 0";
	
	// get default agreement by partner for standard agreement
	QueryResult = Query.Execute();
	QueryTable_StandardAgreements = QueryResult.Unload();
	For Each Row In QueryTable_StandardAgreements Do
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner", Row.Partner);
		AgreementParameters.Insert("Agreement", Catalogs.Agreements.EmptyRef());
		AgreementParameters.Insert("ArrayOfFilters", New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			ComparisonType.NotEqual));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("StandardAgreement",
			Row.StandardAgreement, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind",
			Enums.AgreementKinds.Regular, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type",
			Enums.AgreementTypes.Customer, ComparisonType.Equal));

		Row.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	EndDo;

	Query.Text =
	"SELECT
	|	tmp.BasedOn,
	|	tmp.TransactionType AS TransactionType,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement,
	|	tmp.LegalName AS LegalName,
	|	tmp.Order AS Order,
	|	tmp.Project AS Project,
	|	tmp.Amount AS Amount
	|INTO QueryTable_StandardAgreements
	|FROM
	|	&QueryTable_StandardAgreements AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	""SalesReturn"" AS BasedOn,
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer) AS TransactionType,
	|	R2021B_CustomersTransactionsBalance.Company,
	|	R2021B_CustomersTransactionsBalance.Branch,
	|	R2021B_CustomersTransactionsBalance.Currency,
	|	R2021B_CustomersTransactionsBalance.Basis AS BasisDocument,
	|	R2021B_CustomersTransactionsBalance.Partner,
	|	R2021B_CustomersTransactionsBalance.Agreement,
	|	R2021B_CustomersTransactionsBalance.LegalName AS Payee,
	|	R2021B_CustomersTransactionsBalance.Order AS Order,
	|	R2021B_CustomersTransactionsBalance.Project AS Project,
	|	-R2021B_CustomersTransactionsBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(, Basis IN
	|		(SELECT
	|			tmp.BasisDocument
	|		FROM
	|			Filter_ByDocuments AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|WHERE
	|	R2021B_CustomersTransactionsBalance.AmountBalance < 0
	|
	|UNION ALL
	|
	|SELECT
	|	""SalesReturn"",
	|	VALUE(Enum.OutgoingPaymentTransactionTypes.ReturnToCustomer),
	|	R2021B_CustomersTransactionsBalance.Company,
	|	R2021B_CustomersTransactionsBalance.Branch,
	|	R2021B_CustomersTransactionsBalance.Currency,
	|	UNDEFINED,
	|	R2021B_CustomersTransactionsBalance.Partner,
	|	R2021B_CustomersTransactionsBalance.Agreement,
	|	R2021B_CustomersTransactionsBalance.LegalName,
	|	R2021B_CustomersTransactionsBalance.Order,
	|	R2021B_CustomersTransactionsBalance.Project,
	|	-R2021B_CustomersTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByAgreements AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R2021B_CustomersTransactionsBalance
	|WHERE
	|	R2021B_CustomersTransactionsBalance.AmountBalance < 0
	|
	|UNION ALL
	|
	|SELECT
	|	QueryTable_StandardAgreements.BasedOn,
	|	QueryTable_StandardAgreements.TransactionType,
	|	QueryTable_StandardAgreements.Company,
	|	QueryTable_StandardAgreements.Branch,
	|	QueryTable_StandardAgreements.Currency,
	|	UNDEFINED,
	|	QueryTable_StandardAgreements.Partner,
	|	QueryTable_StandardAgreements.Agreement,
	|	QueryTable_StandardAgreements.LegalName,
	|	QueryTable_StandardAgreements.Order,
	|	QueryTable_StandardAgreements.Project,
	|	-QueryTable_StandardAgreements.Amount
	|FROM
	|	QueryTable_StandardAgreements AS QueryTable_StandardAgreements";

	Query.SetParameter("QueryTable_StandardAgreements", QueryTable_StandardAgreements);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function GetDocumentTable_PurchaseReturn_ForReceipt(ArrayOfBasisDocuments, AddInfo = Undefined) Export

	Filters = GetQueryFilters(Metadata.AccumulationRegisters.R1021B_VendorsTransactions, ArrayOfBasisDocuments);

	TempTableManager = New TempTablesManager();
	PutQueryFiltersToTempTables(TempTableManager, Filters);

	Query = New Query();
	Query.TempTablesManager = TempTableManager;
	Query.Text =
	"SELECT
	|	""PurchaseReturn"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS TransactionType,
	|	R1021B_VendorsTransactions.Company AS Company,
	|	R1021B_VendorsTransactions.Branch AS Branch,
	|	R1021B_VendorsTransactions.Currency AS Currency,
	|	R1021B_VendorsTransactions.Partner AS Partner,
	|	R1021B_VendorsTransactions.Agreement AS StandardAgreement,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R1021B_VendorsTransactions.LegalName AS LegalName,
	|	R1021B_VendorsTransactions.Order AS Order,
	|	R1021B_VendorsTransactions.Project AS Project,
	|	R1021B_VendorsTransactions.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByStandardAgreement AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1021B_VendorsTransactions
	|WHERE
	|	R1021B_VendorsTransactions.AmountBalance < 0";
	
	// get default agreement by partner for standard agreement
	QueryResult = Query.Execute();
	QueryTable_StandardAgreements = QueryResult.Unload();
	For Each Row In QueryTable_StandardAgreements Do
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner", Row.Partner);
		AgreementParameters.Insert("Agreement", Catalogs.Agreements.EmptyRef());
		AgreementParameters.Insert("ArrayOfFilters", New Array());
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			ComparisonType.NotEqual));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("StandardAgreement",
			Row.StandardAgreement, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind",
			Enums.AgreementKinds.Regular, ComparisonType.Equal));
		AgreementParameters.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type",
			Enums.AgreementTypes.Vendor, ComparisonType.Equal));
		Row.Agreement = DocumentsServer.GetAgreementByPartner(AgreementParameters);
	EndDo;

	Query.Text =
	"SELECT
	|	tmp.BasedOn,
	|	tmp.TransactionType AS TransactionType,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement,
	|	tmp.LegalName AS LegalName,
	|	tmp.Order AS Order,
	|	tmp.Project AS Project,
	|	tmp.Amount AS Amount
	|INTO QueryTable_StandardAgreements
	|FROM
	|	&QueryTable_StandardAgreements AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	""PurchaseReturn"" AS BasedOn,
	|	VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor) AS TransactionType,
	|	R1021B_VendorsTransactions.Company,
	|	R1021B_VendorsTransactions.Branch,
	|	R1021B_VendorsTransactions.Currency,
	|	R1021B_VendorsTransactions.Basis AS BasisDocument,
	|	R1021B_VendorsTransactions.Partner,
	|	R1021B_VendorsTransactions.Agreement,
	|	R1021B_VendorsTransactions.LegalName AS Payer,
	|	R1021B_VendorsTransactions.Order AS Order,
	|	R1021B_VendorsTransactions.Project AS Project,
	|	-R1021B_VendorsTransactions.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(, Basis IN
	|		(SELECT
	|			tmp.BasisDocument
	|		FROM
	|			Filter_ByDocuments AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1021B_VendorsTransactions
	|WHERE
	|	R1021B_VendorsTransactions.AmountBalance < 0
	|
	|UNION ALL
	|
	|SELECT
	|	""PurchaseReturn"",
	|	VALUE(Enum.IncomingPaymentTransactionType.ReturnFromVendor),
	|	PartnerTransactionsBalance.Company,
	|	PartnerTransactionsBalance.Branch,
	|	PartnerTransactionsBalance.Currency,
	|	UNDEFINED,
	|	PartnerTransactionsBalance.Partner,
	|	PartnerTransactionsBalance.Agreement,
	|	PartnerTransactionsBalance.LegalName,
	|	PartnerTransactionsBalance.Order,
	|	PartnerTransactionsBalance.Project,
	|	-PartnerTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(, (Company, Branch, Currency, Agreement, Partner, LegalName) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Branch,
	|			tmp.Currency,
	|			tmp.Agreement,
	|			tmp.Partner,
	|			tmp.LegalName
	|		FROM
	|			Filter_ByAgreements AS tmp)
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		PartnerTransactionsBalance
	|WHERE
	|	PartnerTransactionsBalance.AmountBalance < 0
	|
	|UNION ALL
	|
	|SELECT
	|	QueryTable_StandardAgreements.BasedOn,
	|	QueryTable_StandardAgreements.TransactionType,
	|	QueryTable_StandardAgreements.Company,
	|	QueryTable_StandardAgreements.Branch,
	|	QueryTable_StandardAgreements.Currency,
	|	UNDEFINED,
	|	QueryTable_StandardAgreements.Partner,
	|	QueryTable_StandardAgreements.Agreement,
	|	QueryTable_StandardAgreements.LegalName,
	|	QueryTable_StandardAgreements.Order,
	|	QueryTable_StandardAgreements.Project,
	|	-QueryTable_StandardAgreements.Amount
	|FROM
	|	QueryTable_StandardAgreements AS QueryTable_StandardAgreements";

	Query.SetParameter("QueryTable_StandardAgreements", QueryTable_StandardAgreements);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

Function CreateDocumentAmountTable() Export
	AmountsTable = New ValueTable();
	AmountsTable.Columns.Add("Company");
	AmountsTable.Columns.Add("Branch");
	AmountsTable.Columns.Add("Currency");
	AmountsTable.Columns.Add("Partner");
	AmountsTable.Columns.Add("LegalName");
	AmountsTable.Columns.Add("Agreement");
	AmountsTable.Columns.Add("Order");
	AmountsTable.Columns.Add("Project");
	AmountsTable.Columns.Add("Amount");
	
	Return AmountsTable;
EndFunction

Procedure FillDocumentAmountTable(DocumentAmountTable, ArrayOfocuments, Order_ColumnName = "") Export
	For Each DocRef In ArrayOfocuments Do
		DocHeader = New Structure();
		DocHeader.Insert("Company"   , DocRef.Company);
		DocHeader.Insert("Branch"    , DocRef.Branch);
		DocHeader.Insert("Currency"  , DocRef.Currency);
		DocHeader.Insert("Partner"   , DocRef.Partner);
		DocHeader.Insert("LegalName" , DocRef.LegalName);
		DocHeader.Insert("Agreement" , DocRef.Agreement);
		
		For Each Row In DocRef.ItemList Do
			NewRow = DocumentAmountTable.Add();
			FillPropertyValues(NewRow, DocHeader);
			If ValueIsFilled(Order_ColumnName) Then
				_Order = Row[Order_ColumnName];
				If ValueIsFilled(_Order) Then
					NewRow.Order = _Order;
				EndIf;
			EndIf;
			NewRow.Project = Row.Project;
			NewRow.Amount = Row.TotalAmount;
		EndDo;
	EndDo;
EndProcedure

Function CalculateDocumentAmount(DocumentAmountTable, Filter, NetAmount, TotalAmount) Export
	
	Result = New Structure("NetAmount, TotalAmount, Skip", NetAmount, TotalAmount, False);
		
	DocumentAmount = Undefined;
			
	DocumentAmountRows = DocumentAmountTable.Copy(Filter);
	If DocumentAmountRows.Count() Then
		DocumentAmount = DocumentAmountRows.Total("Amount");
		Result.TotalAmount = Min(DocumentAmount, Result.TotalAmount);
		Result.NetAmount = Min(DocumentAmount, Result.NetAmount);		
		Return Result;
	Else
		If DocumentAmountTable.Count() Then
			Result.Skip = True;
			Return Result;
		EndIf;
	EndIf;
	
	Return Result;
EndFunction		

#EndRegion
