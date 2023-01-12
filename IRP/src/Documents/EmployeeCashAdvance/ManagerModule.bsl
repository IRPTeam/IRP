#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	//Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
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
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(R5012B_VendorsAging());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return 
		"SELECT
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.Partner AS Partner,
		|	PaymentList.Currency AS Currency,
		|	PaymentList.Account AS Account,
		|	PaymentList.PlaningTransactionBasis AS PlaningTransactionBasis,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.NetAmount AS NetAmount,
		|	PaymentList.TaxAmount AS TaxAmount,
		|	PaymentList.TotalAmount AS TotalAmount,
		|	PaymentList.Key,
		|	PaymentList.ProfitLossCenter,
		|	PaymentList.FinancialMovementType,
		|	PaymentList.AdditionalAnalytic,
		|	PaymentList.Ref.Branch AS Branch,
		|	NOT PaymentList.Invoice.Ref IS NULL AS IsPurchase,
		|	PaymentList.Invoice.Ref IS NULL AS IsExpense,
		|	PaymentList.Invoice.Partner AS VendorPartner,
		|	PaymentList.Invoice.Agreement AS VendorAgreement,
		|	PaymentList.Invoice.LegalName AS VendorLegalName,
		|	PaymentList.Invoice.LegalNameContract AS VendorLegalNameContract,
		|	CASE
		|		WHEN PaymentList.Invoice.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN PaymentList.Invoice
		|		ELSE UNDEFINED
		|	END AS TransactionDocument
		|INTO PaymentList
		|FROM
		|	Document.EmployeeCashAdvance.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Key,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Partner,
		|	PaymentList.Currency,
		|	PaymentList.Account,
		|	PaymentList.PlaningTransactionBasis,
		|	PaymentList.FinancialMovementType,
		|	PaymentList.TotalAmount AS Amount
		|INTO R3027B_EmployeeCashAdvance
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE";
EndFunction

Function R5022T_Expenses()
	Return 
		"SELECT
		|	PaymentList.NetAmount AS Amount,
		|	PaymentList.TotalAmount AS AmountWithTaxes,
		|	*
		|INTO R5022T_Expenses
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsExpense";
EndFunction

Function R1021B_VendorsTransactions()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.VendorPartner AS Partner,
		|	PaymentList.VendorLegalName AS LegalName,
		|	PaymentList.Currency,
		|	PaymentList.VendorAgreement AS Agreement,
		|	PaymentList.TransactionDocument AS Basis,
		|	Undefined AS Order,
		|	PaymentList.Key,
		|	PaymentList.TotalAmount AS Amount,
		|	UNDEFINED AS VendorsAdvancesClosing
		|INTO R1021B_VendorsTransactions
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPurchase
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.TransactionOrder,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5010B_ReconciliationStatement()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Currency,
		|	PaymentList.VendorLegalName AS LegalName,
		|	PaymentList.VendorLegalNameContract AS LegalNameContract,
		|	PaymentList.TotalAmount AS Amount
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsPurchase";
EndFunction

Function T2015S_TransactionsInfo()
	Return 
	"SELECT
	|	PaymentList.Period AS Date,
	|	PaymentList.Key,
	|	PaymentList.Company,
	|	PaymentList.Branch,
	|	PaymentList.Currency,
	|	PaymentList.VendorPartner AS Partner,
	|	PaymentList.VendorLegalName AS LegalName,
	|	PaymentList.VendorAgreement AS Agreement,
	|	Undefined AS Order,
	|	TRUE AS IsVendorTransaction,
	|	FALSE AS IsCustomerTransaction,
	|	PaymentList.TransactionDocument AS TransactionBasis,
	|	PaymentList.TotalAmount AS Amount,
	|	TRUE AS IsPaid
	|INTO T2015S_TransactionsInfo
	|FROM
	|	PaymentList AS PaymentList
	|WHERE
	|	PaymentList.IsPurchase";
EndFunction

Function R5012B_VendorsAging()
	Return 
		"SELECT
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
		|INTO R5012B_VendorsAging
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction
