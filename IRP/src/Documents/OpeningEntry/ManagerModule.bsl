#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion

	Return New Structure();
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

	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "TableDataPath", "Object.Inventory");
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.OpeningEntry.Inventory", AddInfo);
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(AccauntBalance());
	QueryArray.Add(AdvancesToVendors());
	QueryArray.Add(VendorsTransactions());
	QueryArray.Add(AdvancesFromCustomers());
	QueryArray.Add(CustomersTransactions());
	QueryArray.Add(CustomersAging());
	QueryArray.Add(VendorsAging());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5010B_ReconciliationStatement());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	OpeningEntryInventory.Ref,
		   |	OpeningEntryInventory.Key,
		   |	OpeningEntryInventory.ItemKey,
		   |	OpeningEntryInventory.Store,
		   |	OpeningEntryInventory.Quantity,
		   |	NOT OpeningEntryInventory.SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef) AS isSerialLotNumberSet,
		   |	OpeningEntryInventory.SerialLotNumber,
		   |	OpeningEntryInventory.Ref.Date AS Period,
		   |	OpeningEntryInventory.Ref.Company AS Company,
		   |	OpeningEntryInventory.Ref.Branch AS Branch
		   |INTO ItemList
		   |FROM
		   |	Document.OpeningEntry.Inventory AS OpeningEntryInventory
		   |WHERE
		   |	OpeningEntryInventory.Ref = &Ref";
EndFunction

Function AccauntBalance()
	Return "SELECT
		   |	AccountBalance.Ref.Company AS Company,
		   |	AccountBalance.Ref.Branch AS Branch,
		   |	AccountBalance.Account,
		   |	AccountBalance.Currency,
		   |	AccountBalance.Amount AS Amount,
		   |	AccountBalance.Ref.Date AS Period,
		   |	AccountBalance.Key
		   |INTO AccauntBalance
		   |FROM
		   |	Document.OpeningEntry.AccountBalance AS AccountBalance
		   |WHERE
		   |	AccountBalance.Ref = &Ref";
EndFunction

Function AdvancesToVendors()
	Return "SELECT
		   |	OpeningEntryAdvanceToSuppliers.Ref.Company AS Company,
		   |	OpeningEntryAdvanceToSuppliers.Ref.Branch AS Branch,
		   |	OpeningEntryAdvanceToSuppliers.Currency,
		   |	OpeningEntryAdvanceToSuppliers.Partner,
		   |	OpeningEntryAdvanceToSuppliers.LegalName,
		   |	OpeningEntryAdvanceToSuppliers.LegalNameContract,
		   |	OpeningEntryAdvanceToSuppliers.Amount AS Amount,
		   |	OpeningEntryAdvanceToSuppliers.Ref AS Basis,
		   |	OpeningEntryAdvanceToSuppliers.Ref.Date AS Period,
		   |	OpeningEntryAdvanceToSuppliers.Key
		   |INTO AdvancesToVendors
		   |FROM
		   |	Document.OpeningEntry.AdvanceToSuppliers AS OpeningEntryAdvanceToSuppliers
		   |WHERE
		   |	OpeningEntryAdvanceToSuppliers.Ref = &Ref";
EndFunction

Function VendorsTransactions()
	Return "SELECT
		   |	OpeningEntryAccountPayableByDocuments.Ref.Date AS Period,
		   |	OpeningEntryAccountPayableByDocuments.Key,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Company,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Branch AS Branch,
		   |	OpeningEntryAccountPayableByDocuments.Ref AS Basis,
		   |	OpeningEntryAccountPayableByDocuments.Partner,
		   |	OpeningEntryAccountPayableByDocuments.LegalName,
		   |	OpeningEntryAccountPayableByDocuments.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountPayableByDocuments.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountPayableByDocuments.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountPayableByDocuments.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountPayableByDocuments.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountPayableByDocuments.Currency,
		   |	OpeningEntryAccountPayableByDocuments.Amount AS Amount
		   |INTO VendorsTransactions
		   |FROM
		   |	Document.OpeningEntry.AccountPayableByDocuments AS OpeningEntryAccountPayableByDocuments
		   |WHERE
		   |	OpeningEntryAccountPayableByDocuments.Ref = &Ref
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	OpeningEntryAccountPayableByAgreements.Ref.Date,
		   |	OpeningEntryAccountPayableByAgreements.Key,
		   |	OpeningEntryAccountPayableByAgreements.Ref.Company,
		   |	OpeningEntryAccountPayableByAgreements.Ref.Branch,
		   |	UNDEFINED,
		   |	OpeningEntryAccountPayableByAgreements.Partner,
		   |	OpeningEntryAccountPayableByAgreements.LegalName,
		   |	OpeningEntryAccountPayableByAgreements.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountPayableByAgreements.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountPayableByAgreements.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountPayableByAgreements.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountPayableByAgreements.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountPayableByAgreements.Currency,
		   |	OpeningEntryAccountPayableByAgreements.Amount AS Amount
		   |FROM
		   |	Document.OpeningEntry.AccountPayableByAgreements AS OpeningEntryAccountPayableByAgreements
		   |WHERE
		   |	OpeningEntryAccountPayableByAgreements.Ref = &Ref";
EndFunction

Function AdvancesFromCustomers()
	Return "SELECT
		   |	OpeningEntryAdvanceFromCustomers.Ref.Company AS Company,
		   |	OpeningEntryAdvanceFromCustomers.Ref.Branch AS Branch,
		   |	OpeningEntryAdvanceFromCustomers.Currency,
		   |	OpeningEntryAdvanceFromCustomers.Partner,
		   |	OpeningEntryAdvanceFromCustomers.LegalName,
		   |	OpeningEntryAdvanceFromCustomers.LegalNameContract,
		   |	OpeningEntryAdvanceFromCustomers.Amount AS Amount,
		   |	OpeningEntryAdvanceFromCustomers.Ref AS Basis,
		   |	OpeningEntryAdvanceFromCustomers.Ref.Date AS Period,
		   |	OpeningEntryAdvanceFromCustomers.Key
		   |INTO AdvancesFromCustomers
		   |FROM
		   |	Document.OpeningEntry.AdvanceFromCustomers AS OpeningEntryAdvanceFromCustomers
		   |WHERE
		   |	OpeningEntryAdvanceFromCustomers.Ref = &Ref";
EndFunction

Function CustomersTransactions()
	Return "SELECT
		   |	OpeningEntryAccountReceivableByDocuments.Key,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Date AS Period,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Company,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Branch,
		   |	OpeningEntryAccountReceivableByDocuments.Ref AS Basis,
		   |	OpeningEntryAccountReceivableByDocuments.Partner,
		   |	OpeningEntryAccountReceivableByDocuments.LegalName,
		   |	OpeningEntryAccountReceivableByDocuments.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountReceivableByDocuments.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountReceivableByDocuments.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountReceivableByDocuments.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountReceivableByDocuments.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountReceivableByDocuments.Currency,
		   |	OpeningEntryAccountReceivableByDocuments.Amount AS Amount
		   |INTO CustomersTransactions
		   |FROM
		   |	Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		   |WHERE
		   |	OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	OpeningEntryAccountReceivableByAgreements.Key,
		   |	OpeningEntryAccountReceivableByAgreements.Ref.Date,
		   |	OpeningEntryAccountReceivableByAgreements.Ref.Company,
		   |	OpeningEntryAccountReceivableByAgreements.Ref.Branch,
		   |	UNDEFINED,
		   |	OpeningEntryAccountReceivableByAgreements.Partner,
		   |	OpeningEntryAccountReceivableByAgreements.LegalName,
		   |	OpeningEntryAccountReceivableByAgreements.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountReceivableByAgreements.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountReceivableByAgreements.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountReceivableByAgreements.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountReceivableByAgreements.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountReceivableByAgreements.Currency,
		   |	OpeningEntryAccountReceivableByAgreements.Amount AS Amount
		   |FROM
		   |	Document.OpeningEntry.AccountReceivableByAgreements AS OpeningEntryAccountReceivableByAgreements
		   |WHERE
		   |	OpeningEntryAccountReceivableByAgreements.Ref = &Ref";
EndFunction

Function CustomersAging()
	Return "SELECT
		   |	OpeningEntryCustomersPaymentTerms.Ref.Date AS Period,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Company AS Company,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Branch AS Branch,
		   |	OpeningEntryAccountReceivableByDocuments.Partner AS Partner,
		   |	OpeningEntryAccountReceivableByDocuments.Agreement AS Agreement,
		   |	OpeningEntryAccountReceivableByDocuments.Ref AS Invoice,
		   |	OpeningEntryCustomersPaymentTerms.Date AS PaymentDate,
		   |	OpeningEntryAccountReceivableByDocuments.Currency AS Currency,
		   |	OpeningEntryCustomersPaymentTerms.Amount AS Amount
		   |INTO CustomersAging
		   |FROM
		   |	Document.OpeningEntry.CustomersPaymentTerms AS OpeningEntryCustomersPaymentTerms
		   |		LEFT JOIN Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		   |		ON OpeningEntryCustomersPaymentTerms.Key = OpeningEntryAccountReceivableByDocuments.Key
		   |		AND OpeningEntryCustomersPaymentTerms.Ref = OpeningEntryAccountReceivableByDocuments.Ref
		   |		AND OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		   |WHERE
		   |	OpeningEntryCustomersPaymentTerms.Ref = &Ref";
EndFunction

Function VendorsAging()
	Return "SELECT
		   |	OpeningEntryVendorsPaymentTerms.Ref.Date AS Period,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Company AS Company,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Branch AS Branch,
		   |	OpeningEntryAccountPayableByDocuments.Partner AS Partner,
		   |	OpeningEntryAccountPayableByDocuments.Agreement AS Agreement,
		   |	OpeningEntryAccountPayableByDocuments.Ref AS Invoice,
		   |	OpeningEntryVendorsPaymentTerms.Date AS PaymentDate,
		   |	OpeningEntryAccountPayableByDocuments.Currency AS Currency,
		   |	OpeningEntryVendorsPaymentTerms.Amount AS Amount
		   |INTO VendorsAging
		   |FROM
		   |	Document.OpeningEntry.VendorsPaymentTerms AS OpeningEntryVendorsPaymentTerms
		   |		LEFT JOIN Document.OpeningEntry.AccountPayableByDocuments AS OpeningEntryAccountPayableByDocuments
		   |		ON OpeningEntryVendorsPaymentTerms.Key = OpeningEntryAccountPayableByDocuments.Key
		   |		AND OpeningEntryVendorsPaymentTerms.Ref = OpeningEntryAccountPayableByDocuments.Ref
		   |		AND OpeningEntryAccountPayableByDocuments.Ref = &Ref
		   |WHERE
		   |	OpeningEntryVendorsPaymentTerms.Ref = &Ref";
EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	AdvancesToVendors AS QueryTable
		   |WHERE 
		   |	TRUE";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R1021B_VendorsTransactions
		   |FROM
		   |	VendorsTransactions AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R5012B_VendorsAging()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R5012B_VendorsAging
		   |FROM
		   |	VendorsAging AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	AdvancesFromCustomers AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	CustomersTransactions AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R5011B_CustomersAging()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	CustomersAging AS QueryTable
		   |WHERE 
		   |	TRUE";

EndFunction

Function R4010B_ActualStocks()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE 
		   |	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE
		   |	TRUE";

EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE 
		   |	QueryTable.isSerialLotNumberSet";

EndFunction

Function R3010B_CashOnHand()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	AccauntBalance AS AccauntBalance
		   |WHERE 
		   |	TRUE";
EndFunction
Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	VendorsTransactions.Period,
		   |	VendorsTransactions.Company,
		   |	VendorsTransactions.Branch,
		   |	VendorsTransactions.LegalName,
		   |	VendorsTransactions.LegalNameContract,
		   |	VendorsTransactions.Currency,
		   |	VendorsTransactions.Amount
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	VendorsTransactions AS VendorsTransactions
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	AdvancesToVendors.Period,
		   |	AdvancesToVendors.Company,
		   |	AdvancesToVendors.Branch,
		   |	AdvancesToVendors.LegalName,
		   |	AdvancesToVendors.LegalNameContract,
		   |	AdvancesToVendors.Currency,
		   |	AdvancesToVendors.Amount
		   |FROM
		   |	AdvancesToVendors AS AdvancesToVendors
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CustomersTransactions.Period,
		   |	CustomersTransactions.Company,
		   |	CustomersTransactions.Branch,
		   |	CustomersTransactions.LegalName,
		   |	CustomersTransactions.LegalNameContract,
		   |	CustomersTransactions.Currency,
		   |	CustomersTransactions.Amount
		   |FROM
		   |	CustomersTransactions AS CustomersTransactions
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	AdvancesFromCustomers.Period,
		   |	AdvancesFromCustomers.Company,
		   |	AdvancesFromCustomers.Branch,
		   |	AdvancesFromCustomers.LegalName,
		   |	AdvancesFromCustomers.LegalNameContract,
		   |	AdvancesFromCustomers.Currency,
		   |	AdvancesFromCustomers.Amount
		   |FROM
		   |	AdvancesFromCustomers AS AdvancesFromCustomers";
EndFunction

#EndRegion