#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
	Return Tables;
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
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

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
// Test
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
	QueryArray.Add(Transactions());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R1022B_VendorsPaymentPlanning());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	Return QueryArray;
EndFunction

Function Transactions()
	Return "SELECT
		   |	Transactions.Ref.Date AS Period,
		   |	Transactions.Ref.Company AS Company,
		   |	Transactions.Partner,
		   |	Transactions.LegalName,
		   |	Transactions.Agreement,
		   |	CASE
		   |		WHEN Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			THEN Transactions.Ref
		   |		ELSE UNDEFINED
		   |	END AS BasisDocument,
		   |	Transactions.Ref AS AdvancesOrTransactionDocument,
		   |	Transactions.Ref AS Ref,
		   |	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		   |	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		   |	Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) AS IsPostingDetail_ByDocuments,
		   |	Transactions.Currency,
		   |	Transactions.Key,
		   |	Transactions.Amount,
		   |	Transactions.Ref.Branch AS Branch,
		   |	Transactions.LegalNameContract AS LegalNameContract
		   |INTO Transactions
		   |FROM
		   |	Document.CreditNote.Transactions AS Transactions
		   |WHERE
		   |	Transactions.Ref = &Ref";
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	Transactions";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period AS Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Currency,
		   |	Transactions.LegalName,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	Transactions.BasisDocument AS Basis,
		   |	Transactions.Key,
		   |	Transactions.Amount,
		   |	UNDEFINED AS VendorsAdvancesClosing
		   |INTO R1021B_VendorsTransactions
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsVendor
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.Agreement,
		   |	OffsetOfAdvances.TransactionDocument AS Basis,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R5022T1_Expenses()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Transactions.Amount AS AmountWithTaxes,
		   |	*
		   |INTO R5022T_Expenses
		   |FROM
		   |	Transactions";
EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		   |	*
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Partner,
		   |	Transactions.LegalName,
		   |	Transactions.Currency,
		   |	Transactions.Amount,
		   |	Transactions.Key,
		   |	UNDEFINED AS CustomersAdvancesClosing
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsCustomer
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAdvances.Period,
		   |	OffsetOfAdvances.Company,
		   |	OffsetOfAdvances.Branch,
		   |	OffsetOfAdvances.Partner,
		   |	OffsetOfAdvances.LegalName,
		   |	OffsetOfAdvances.Currency,
		   |	OffsetOfAdvances.Amount,
		   |	OffsetOfAdvances.Key,
		   |	OffsetOfAdvances.Recorder
		   |FROM
		   |	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		   |WHERE
		   |	OffsetOfAdvances.Document = &Ref
		   |	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R5012B_VendorsAging()
	Return "SELECT
	|
	|
	|
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period AS PaymentDate,
		   |	Transactions.Period AS Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Currency,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	Transactions.BasisDocument AS Invoice,
		   |	SUM(Transactions.Amount) AS Amount,
		   |	UNDEFINED AS AgingClosing
		   |INTO R5012B_VendorsAging
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsVendor
		   |	AND Transactions.IsPostingDetail_ByDocuments
		   |GROUP BY
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Currency,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	Transactions.BasisDocument,
		   |	VALUE(AccumulationRecordType.Receipt)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	OffsetOfAging.PaymentDate,
		   |	OffsetOfAging.Period,
		   |	OffsetOfAging.Company,
		   |	OffsetOfAging.Branch,
		   |	OffsetOfAging.Currency,
		   |	OffsetOfAging.Partner,
		   |	OffsetOfAging.Agreement,
		   |	OffsetOfAging.Invoice,
		   |	OffsetOfAging.Amount,
		   |	OffsetOfAging.Recorder
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref
		   |	AND OffsetOfAging.Recorder REFS Document.VendorsAdvancesClosing";
EndFunction

Function R5011B_CustomersAging()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	OffsetOfAging.Period,
		   |	OffsetOfAging.Company,
		   |	OffsetOfAging.Branch,
		   |	OffsetOfAging.Partner,
		   |	OffsetOfAging.Agreement,
		   |	OffsetOfAging.Currency,
		   |	OffsetOfAging.Invoice,
		   |	OffsetOfAging.PaymentDate,
		   |	OffsetOfAging.Amount,
		   |	OffsetOfAging.Recorder AS AgingClosing
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		   |WHERE
		   |	OffsetOfAging.Document = &Ref
		   |	AND OffsetOfAging.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function R1022B_VendorsPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Ref AS Basis,
		   |	Transactions.LegalName AS LegalName,
		   |	Transactions.Partner AS Partner,
		   |	Transactions.Agreement AS Agreement,
		   |	SUM(Transactions.Amount) AS Amount
		   |INTO R1022B_VendorsPaymentPlanning
		   |FROM
		   |	Transactions AS Transactions
		   |WHERE
		   |	Transactions.IsVendor
		   |	AND Transactions.IsPostingDetail_ByDocuments
		   |GROUP BY
		   |	Transactions.Period,
		   |	Transactions.Company,
		   |	Transactions.Branch,
		   |	Transactions.Ref,
		   |	Transactions.LegalName,
		   |	Transactions.Partner,
		   |	Transactions.Agreement,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function T2014S_AdvancesInfo()
	Return 
	"SELECT
	|	Transactions.Period AS Date,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Currency,
	|	TRUE AS IsCustomerAdvance,
	|	Transactions.Key,
	|	Transactions.Amount
	|INTO T2014S_AdvancesInfo
	|FROM
	|	Transactions AS Transactions
	|WHERE
	|	Transactions.IsCustomer";
EndFunction

Function T2015S_TransactionsInfo()
	Return 
	"SELECT
	|	Transactions.Period AS Date,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Currency,
	|	Transactions.LegalName,
	|	Transactions.Partner,
	|	Transactions.Agreement,
	|	Transactions.BasisDocument AS TransactionBasis,
	|	Transactions.Key,
	|	TRUE AS IsVendorTransaction,
	|	TRUE AS IsDue,
	|	SUM(Transactions.Amount) AS Amount
	|INTO T2015S_TransactionsInfo
	|FROM
	|	Transactions AS Transactions
	|WHERE
	|	Transactions.IsVendor
	|GROUP BY
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Currency,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.BasisDocument,
	|	Transactions.Key";
EndFunction

#EndRegion