#Region PRINT_FORM

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region UNDOPOSTING

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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(Invoices());
	QueryArray.Add(Payments());
	QueryArray.Add(OffsetOfAdvances());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T2018S_UserDefinedOffsetOfAdvances());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function Invoices()
	Return
		"SELECT
		|	Invoices.Ref.Date AS Period,
		|	Invoices.Ref.Company AS Company,
		|	Invoices.Ref.Branch AS Branch,
		|	Invoices.Ref.Currency AS Currency,
		|	Invoices.Ref.Partner AS Partner,
		|	Invoices.Ref.Agreement AS Agreement,
		|	Invoices.Ref.LegalName AS LegalName,
		|	Invoices.Order AS Order,
		|	Invoices.Invoice AS TransactionDocument,
		|	Invoices.Amount,
		|	Invoices.Key,
		|	Invoices.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Customer)
		|	OR Invoices.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.TradeAgent) AS IsCustomerTransaction,
		|	Invoices.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor)
		|	OR Invoices.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Consignor) AS IsVendorTransaction
		|INTO Invoices
		|FROM
		|	Document.DebitCreditNote.OffsetOfAdvancesInvoices AS Invoices
		|WHERE
		|	Invoices.Ref = &Ref";
EndFunction
		
Function Payments()
	Return
		"SELECT
		|	Payments.Ref.Date AS Period,
		|	Payments.Ref.Company AS Company,
		|	Payments.Ref.Branch AS Branch,
		|	Payments.Ref.Currency AS Currency,
		|	Payments.Ref.Partner AS Partner,
		|	Payments.Ref.Agreement AS Agreement,
		|	Payments.Ref.LegalName AS LegalName,
		|	Payments.Order AS Order,
		|	Payments.Document AS AdvanceDocument,
		|	Payments.Amount,
		|	Payments.KeyOwner,
		|	Payments.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Customer)
		|	OR Payments.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.TradeAgent) AS IsCustomerAdvance,
		|	Payments.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor)
		|	OR Payments.Ref.Agreement.Type = VALUE(Enum.AgreementTypes.Consignor) AS IsVendorAdvance
		|INTO Payments
		|FROM
		|	Document.DebitCreditNote.OffsetOfAdvancesPayments AS Payments
		|WHERE
		|	Payments.Ref = &Ref";
EndFunction

Function OffsetOfAdvances()
	Return
		"SELECT
		|	Invoices.Period,
		|	Invoices.Company,
		|	Invoices.Branch,
		|	Invoices.Currency,
		|	Invoices.Partner,
		|	Invoices.Agreement,
		|	Invoices.LegalName,
		|	Invoices.Order,
		|	Payments.AdvanceDocument,
		|	Invoices.TransactionDocument,
		|	Invoices.IsCustomerTransaction,
		|	Invoices.IsVendorTransaction,
		|	Payments.IsCustomerAdvance,
		|	Payments.IsVendorAdvance
		|INTO OffsetOfAdvances
		|FROM
		|	Invoices AS Invoices
		|		INNER JOIN Payments AS Payments
		|		ON Invoices.Key = Payments.KeyOwner
		|		AND (Invoices.IsCustomerTransaction
		|		OR Invoices.IsVendorTransaction
		|		OR Payments.IsCustomerAdvance
		|		OR Payments.IsVendorAdvance)";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R1020B_AdvancesToVendors()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Payments.Period,
		|	Payments.Company,
		|	Payments.Branch,
		|	Payments.Currency,
		|	Payments.LegalName,
		|	Payments.Partner,
		|	Payments.Order,
		|	Payments.Agreement,
		|	Payments.AdvanceDocument AS Basis,
		|	Payments.Amount
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	Payments AS Payments
		|WHERE
		|	Payments.IsVendorAdvance";
EndFunction

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Invoices.Period,
		|	Invoices.Company,
		|	Invoices.Branch,
		|	Invoices.Currency,
		|	Invoices.LegalName,
		|	Invoices.Partner,
		|	Invoices.Agreement,
		|	Invoices.TransactionDocument AS Basis,
		|	Invoices.Order,
		|	Invoices.Amount
		|INTO R1021B_VendorsTransactions
		|FROM
		|	Invoices AS Invoices
		|WHERE
		|	Invoices.IsVendorTransaction";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Payments.Period,
		|	Payments.Company,
		|	Payments.Branch,
		|	Payments.Currency,
		|	Payments.LegalName,
		|	Payments.Partner,
		|	Payments.Order,
		|	Payments.Agreement,
		|	Payments.AdvanceDocument AS Basis,
		|	Payments.Amount
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	Payments AS Payments
		|WHERE
		|	Payments.IsCustomerAdvance";
EndFunction

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Invoices.Period,
		|	Invoices.Company,
		|	Invoices.Branch,
		|	Invoices.Currency,
		|	Invoices.LegalName,
		|	Invoices.Partner,
		|	Invoices.Agreement,
		|	Invoices.TransactionDocument AS Basis,
		|	Invoices.Order,
		|	Invoices.Amount
		|INTO R2021B_CustomersTransactions
		|FROM
		|	Invoices AS Invoices
		|WHERE
		|	Invoices.IsCustomerTransaction";
EndFunction

Function T2018S_UserDefinedOffsetOfAdvances()
	Return
		"SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Branch,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Order,
		|	OffsetOfAdvances.AdvanceDocument,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.IsVendorAdvance,
		|	OffsetOfAdvances.IsCustomerAdvance,
		|	OffsetOfAdvances.IsVendorTransaction,
		|	OffsetOfAdvances.IsCustomerTransaction
		|INTO T2018S_UserDefinedOffsetOfAdvances
		|FROM
		|	OffsetOfAdvances AS OffsetOfAdvances";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	BranchArray = New Array;
	BranchArray.Add(Obj.Branch);
	BranchArray.Add(Obj.ReceiveBranch);
	AccessKeyMap.Insert("Branch", BranchArray);
	Return AccessKeyMap;
EndFunction

#EndRegion
