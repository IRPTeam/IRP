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
	
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5020B_PartnersBalance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
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
	QueryArray.Add(SendAdvances());
	QueryArray.Add(ReceiveAdvances());
	QueryArray.Add(SendTransactions());
	QueryArray.Add(ReceiveTransactions());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5020B_PartnersBalance());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function SendAdvances()
	Return
		"SELECT
		|	(Doc.SendPartner = Doc.ReceivePartner And Doc.SendLegalName = Doc.ReceiveLegalName) AS PartnersIsEqual,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsSendAdvanceCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsSendAdvanceVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsReceiveAdvanceCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsReceiveAdvanceVendor,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsSendTransactionCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsSendTransactionVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsReceiveTransactionCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsReceiveTransactionVendor,
		|
		|	Doc.Date AS Period,
		|	Doc.Company,
		|	Doc.Branch AS SendBranch,
		|	Doc.SendPartner,
		|	Doc.SendLegalName,
		|	Doc.SendLegalNameContract,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAgreement,
		|	Doc.SendProject,
		|	Doc.SendOrder,
		|	CASE
		|		WHEN Doc.SendAgreement.UseOrdersForSettlements
		|			THEN Doc.SendOrder
		|		ELSE UNDEFINED
		|	END AS SendOrderSettlements,
		|	CASE
		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS SendIsVendorAdvance,
		|	CASE
		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS SendIsCustomerAdvance,
		|	(Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract OR Doc.SendLegalName <> Doc.ReceiveLegalName) AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key
		|INTO SendAdvances
		|FROM
		|	Document.DebitCreditNote AS Doc
		|WHERE
		|	Doc.Ref = &Ref
		|	AND (Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
		|	OR Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer))";
EndFunction

Function ReceiveAdvances()
	Return
		"SELECT
		|	(Doc.SendPartner = Doc.ReceivePartner And Doc.SendLegalName = Doc.ReceiveLegalName) AS PartnersIsEqual,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsSendAdvanceCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsSendAdvanceVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsReceiveAdvanceCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsReceiveAdvanceVendor,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsSendTransactionCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsSendTransactionVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsReceiveTransactionCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsReceiveTransactionVendor,
		|		
		|	Doc.Date AS Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveLegalNameContract,
		|	Doc.ReceiveCurrency AS Currency,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveOrder,
		|	CASE
		|		WHEN Doc.ReceiveAgreement.UseOrdersForSettlements
		|			THEN Doc.ReceiveOrder
		|		ELSE UNDEFINED
		|	END AS ReceiveOrderSettlements,
		|	CASE
		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS ReceiveIsVendorAdvance,
		|	CASE
		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS ReceiveIsCustomerAdvance,
		|	(Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract OR Doc.SendLegalName <> Doc.ReceiveLegalName) AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.ReceiveAmount AS Amount,
		|	Doc.ReceiveUUID AS Key
		|INTO ReceiveAdvances
		|FROM
		|	Document.DebitCreditNote AS Doc
		|WHERE
		|	Doc.Ref = &Ref
		|	AND (Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
		|	OR Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer))";
EndFunction

Function SendTransactions()
	Return
		"SELECT
		|	(Doc.SendPartner = Doc.ReceivePartner And Doc.SendLegalName = Doc.ReceiveLegalName) AS PartnersIsEqual,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsSendAdvanceCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsSendAdvanceVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsReceiveAdvanceCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsReceiveAdvanceVendor,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsSendTransactionCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsSendTransactionVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsReceiveTransactionCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsReceiveTransactionVendor,
		|
		|	Doc.Date AS Period,
		|	Doc.Company,
		|	Doc.Branch AS SendBranch,
		|	Doc.SendPartner,
		|	Doc.SendLegalName,
		|	Doc.SendLegalNameContract,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAgreement,
		|	Doc.SendProject,
		|	Doc.SendOrder,
		|	CASE
		|		WHEN Doc.SendAgreement.UseOrdersForSettlements
		|			THEN Doc.SendOrder
		|		ELSE UNDEFINED
		|	END AS SendOrderSettlements,
		|	Doc.SendBasisDocument,
		|	CASE
		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS SendIsVendorTransaction,
		|	CASE
		|		WHEN Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS SendIsCustomerTransaction,
		|	(Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract OR Doc.SendLegalName <> Doc.ReceiveLegalName) AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.SendAmount AS Amount,
		|	Doc.SendUUID AS Key
		|INTO SendTransactions
		|FROM
		|	Document.DebitCreditNote AS Doc
		|WHERE
		|	Doc.Ref = &Ref
		|	AND (Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
		|	OR Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer))";
EndFunction

Function ReceiveTransactions()
	Return
		"SELECT
		|	(Doc.SendPartner = Doc.ReceivePartner And Doc.SendLegalName = Doc.ReceiveLegalName) AS PartnersIsEqual,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsSendAdvanceCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsSendAdvanceVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer) AS IsReceiveAdvanceCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.AdvanceVendor) AS IsReceiveAdvanceVendor,
		|
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsSendTransactionCustomer,
		|	Doc.SendDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsSendTransactionVendor,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer) AS IsReceiveTransactionCustomer,
		|	Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor) AS IsReceiveTransactionVendor,
		|
		|	Doc.Date AS Period,
		|	Doc.Company,
		|	Doc.ReceiveBranch,
		|	Doc.ReceivePartner,
		|	Doc.ReceiveLegalName,
		|	Doc.ReceiveLegalNameContract,
		|	Doc.ReceiveCurrency AS Currency,
		|	Doc.ReceiveAgreement,
		|	Doc.ReceiveProject,
		|	Doc.ReceiveOrder,
		|	CASE
		|		WHEN Doc.ReceiveAgreement.UseOrdersForSettlements
		|			THEN Doc.ReceiveOrder
		|		ELSE UNDEFINED
		|	END AS ReceiveOrderSettlements,
		|	Doc.ReceiveBasisDocument,
		|	(Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceVendor)
		|	OR Doc.SendDebtType = VALUE(Enum.DebtTypes.AdvanceCustomer))
		|	AND (Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
		|	OR Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)) AS IsOffset,
		|	CASE
		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS SendIsVendorTransaction,
		|	CASE
		|		WHEN Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS SendIsCustomerTransaction,
		|	(Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract OR Doc.SendLegalName <> Doc.ReceiveLegalName) AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.ReceiveAmount AS Amount,
		|	Doc.ReceiveUUID AS Key
		|INTO ReceiveTransactions
		|FROM
		|	Document.DebitCreditNote AS Doc
		|WHERE
		|	Doc.Ref = &Ref
		|	AND (Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionVendor)
		|	OR Doc.ReceiveDebtType = VALUE(Enum.DebtTypes.TransactionCustomer))";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R5010B_ReconciliationStatement()
	Return
		// Vendor advance (send)
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	SendAdvances.Period,
		|	SendAdvances.Company,
		|	SendAdvances.SendBranch AS Branch,
		|	SendAdvances.Currency,
		|	SendAdvances.SendLegalName AS LegalName,
		|	SendAdvances.SendLegalNameContract AS LegalNameContract,
		|	SendAdvances.Amount
		|INTO R5010B_ReconciliationStatement
		|FROM 
		|	SendAdvances AS SendAdvances
		|WHERE
		|	SendAdvances.IsSendAdvanceVendor
		|	AND SendAdvances.IsDifferentContracts
		|
		|UNION ALL
		|
		// Vendor advance (receive)
		|SELECT                                   
		|	case when ReceiveAdvances.IsSendAdvanceCustomer and ReceiveAdvances.IsReceiveAdvanceVendor then
		|   	VALUE(AccumulationRecordType.Expense)
		|	else
		|		VALUE(AccumulationRecordType.Receipt)
		|	end,
		|	ReceiveAdvances.Period,
		|	ReceiveAdvances.Company,
		|	ReceiveAdvances.ReceiveBranch AS Branch,
		|	ReceiveAdvances.Currency,
		|	ReceiveAdvances.ReceiveLegalName AS LegalName,
		|	ReceiveAdvances.ReceiveLegalNameContract AS LegalNameContract,
		|	ReceiveAdvances.Amount
		|FROM
		|	ReceiveAdvances AS ReceiveAdvances
		|WHERE
		|	ReceiveAdvances.IsReceiveAdvanceVendor
		|	AND ReceiveAdvances.IsDifferentContracts
		|
		|UNION ALL
		|
		// Customer advance (send)
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	SendAdvances.Period,
		|	SendAdvances.Company,
		|	SendAdvances.SendBranch AS Branch,
		|	SendAdvances.Currency,
		|	SendAdvances.SendLegalName AS LegalName,
		|	SendAdvances.SendLegalNameContract AS LegalNameContract,
		|	SendAdvances.Amount
		|FROM
		|	SendAdvances AS SendAdvances
		|WHERE
		|	SendAdvances.IsSendAdvanceCustomer
		|	AND SendAdvances.IsDifferentContracts
		|
		|UNION ALL
		|
		// Customer advance (receipt)
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ReceiveAdvances.Period,
		|	ReceiveAdvances.Company,
		|	ReceiveAdvances.ReceiveBranch AS Branch,
		|	ReceiveAdvances.Currency,
		|	ReceiveAdvances.ReceiveLegalName AS LegalName,
		|	ReceiveAdvances.ReceiveLegalNameContract AS LegalNameContract,
		|	ReceiveAdvances.Amount
		|FROM
		|	ReceiveAdvances AS ReceiveAdvances
		|WHERE
		|	ReceiveAdvances.IsReceiveAdvanceCustomer
		|	AND ReceiveAdvances.IsDifferentContracts
		|
		|UNION ALL
		|
		// Vendor transaction (send)
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	SendTransactions.Period,
		|	SendTransactions.Company,
		|	SendTransactions.SendBranch AS Branch,
		|	SendTransactions.Currency,
		|	SendTransactions.SendLegalName AS LegalName,
		|	SendTransactions.SendLegalNameContract AS LegalNameContract,
		|	SendTransactions.Amount
		|FROM 
		|	SendTransactions AS SendTransactions
		|WHERE
		|	SendTransactions.IsSendTransactionVendor
		|	AND SendTransactions.IsDifferentContracts
		|
		|UNION ALL
		|
		// Vendor transaction (receive)
		|SELECT                       
		|	case when ReceiveTransactions.IsSendTransactionVendor and ReceiveTransactions.IsReceiveTransactionVendor then
		|   	value(AccumulationRecordType.Expense)
		|   else
		|   	VALUE(AccumulationRecordType.Receipt)
		|	end,
		|	ReceiveTransactions.Period,
		|	ReceiveTransactions.Company,
		|	ReceiveTransactions.ReceiveBranch AS Branch,
		|	ReceiveTransactions.Currency,
		|	ReceiveTransactions.ReceiveLegalName AS LegalName,
		|	ReceiveTransactions.ReceiveLegalNameContract AS LegalNameContract,
		|	ReceiveTransactions.Amount
		|FROM
		|	ReceiveTransactions AS ReceiveTransactions
		|WHERE
		|	ReceiveTransactions.IsReceiveTransactionVendor
		|	AND ReceiveTransactions.IsDifferentContracts
		|
		|UNION ALL
		|
		// Customer transaction (send)
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	SendTransactions.Period,
		|	SendTransactions.Company,
		|	SendTransactions.SendBranch AS Branch,
		|	SendTransactions.Currency,
		|	SendTransactions.SendLegalName AS LegalName,
		|	SendTransactions.SendLegalNameContract AS LegalNameContract,
		|	SendTransactions.Amount
		|FROM
		|	SendTransactions AS SendTransactions
		|WHERE
		|	SendTransactions.IsSendTransactionCustomer
		|	AND SendTransactions.IsDifferentContracts
		|
		|UNION ALL
		|
		// Customer transaction (receipt)
		|SELECT
		|	case when ReceiveTransactions.IsSendTransactionCustomer and ReceiveTransactions.IsReceiveTransactionCustomer then
		|   	value(AccumulationRecordType.Receipt)
		|   else
		|   	VALUE(AccumulationRecordType.Expense)
		|	end,
		|	ReceiveTransactions.Period,
		|	ReceiveTransactions.Company,
		|	ReceiveTransactions.ReceiveBranch AS Branch,
		|	ReceiveTransactions.Currency,
		|	ReceiveTransactions.ReceiveLegalName AS LegalName,
		|	ReceiveTransactions.ReceiveLegalNameContract AS LegalNameContract,
		|	ReceiveTransactions.Amount
		|FROM
		|	ReceiveTransactions AS ReceiveTransactions
		|WHERE
		|	ReceiveTransactions.IsReceiveTransactionCustomer
		|	AND ReceiveTransactions.IsDifferentContracts";
EndFunction

Function T2014S_AdvancesInfo()
	Return InformationRegisters.T2014S_AdvancesInfo.T2014S_AdvancesInfo_DebitCreditNote();
EndFunction

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_DebitCreditNote();
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_DebitCreditNote();
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_DebitCreditNote();
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_DebitCreditNote();
EndFunction

Function R2021B_CustomersTransactions()
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_DebitCreditNote();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_Offset();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_Offset();
EndFunction

Function R5020B_PartnersBalance()
	Return AccumulationRegisters.R5020B_PartnersBalance.R5020B_PartnersBalance_DebitCreditNote();
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

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
//		"SELECT
//		|	Doc.Date AS Period,
//		|	UNDEFINED AS RowKey,
//		|	Doc.SendUUID AS Key,
//		|	Doc.SendCurrency AS Currency,
//		|	Doc.SendAmount AS Amount,
//		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_R5020B_PartnersBalance) AS Operation,
//		|	UNDEFINED AS AdvancesClosing
//		|INTO T1040T_AccountingAmounts
//		|FROM
//		|	Document.DebitCreditNote AS Doc
//		|WHERE
//		|	Doc.Ref = &Ref
		"SELECT
		|	Doc.Date AS Period,
		|	UNDEFINED AS RowKey,
		|	Doc.SendUUID AS Key,
		|	Doc.SendCurrency AS Currency,
		|	Doc.SendAmount AS Amount,
		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_R5020B_PartnersBalance) AS Operation,
		// Dr currency
		|	case 
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionCustomer) 
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceVendor) Then
		|			
		|			Doc.ReceiveCurrency
		|		
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionVendor)
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceCustomer) Then
		|			
		|			Doc.SendCurrency
		|
		|		else undefined end as DrCurrency,
		// Dr currency amount
		|	case 
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionCustomer) 
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceVendor) Then
		|			
		|			Doc.ReceiveAmount
		|		
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionVendor)
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceCustomer) Then
		|			
		|			Doc.SendAmount
		|
		|		else 0 end as DrCurrencyAmount,
		// Cr currency
		|	case 
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionCustomer) 
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceVendor) Then
		|			
		|			Doc.SendCurrency
		|		
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionVendor)
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceCustomer) Then
		|			
		|			Doc.ReceiveCurrency
		|
		|		else undefined end as CrCurrency,
		// Cr currency amount
		|	case 
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionCustomer) 
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceVendor) Then
		|			
		|			Doc.SendAmount
		|		
		|		when Doc.SendDebtType = value(enum.DebtTypes.TransactionVendor)
		|			or Doc.SendDebtType = value(enum.DebtTypes.AdvanceCustomer) Then
		|			
		|			Doc.ReceiveAmount
		|
		|		else 0 end as CrCurrencyAmount,		
		|
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	Document.DebitCreditNote AS Doc
		|WHERE
		|	Doc.Ref = &Ref
		|
		|UNION ALL
		// Vendor advance (offset)*
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset),
		|	Undefined,
		|	0,
		|	Undefined,
		|	0,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.VendorsAdvancesClosing
		|
		|UNION ALL
		// Customer advance (offset)*
		|SELECT
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.Amount,
		|	VALUE(Catalog.AccountingOperations.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset),
		|	Undefined,
		|	0,
		|	Undefined,
		|	0,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref
		|	AND OffsetOfAdvances.Recorder REFS Document.CustomersAdvancesClosing";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	
	If Parameters.Operation = AO.DebitCreditNote_R5020B_PartnersBalance Then
		Return GetAnalytics_R5020B_PartnersBalance(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset Then 
		Return GetAnalytics_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset Then
		Return GetAnalytics_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R5020B_PartnersBalance_CR_R5021_Revenues Then
		Return GetAnalytics_DR_R5020B_PartnersBalance_CR_R5021_Revenues(Parameters);
	ElsIf Parameters.Operation = AO.DebitCreditNote_DR_R5022T_Expenses_CR_R5020B_PartnersBalance Then
		Return GetAnalytics_DR_R5022T_Expenses_CR_R5020B_PartnersBalance(Parameters);
	EndIf;
	
	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetAnalytics_R5020B_PartnersBalance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Sender
	AdditionalAnalytics_Sender = New Structure();
	AdditionalAnalytics_Sender.Insert("Partner"       , Parameters.ObjectData.SendPartner);
	AdditionalAnalytics_Sender.Insert("LegalName"     , Parameters.ObjectData.SendLegalName);
	AdditionalAnalytics_Sender.Insert("Agreement"     , Parameters.ObjectData.SendAgreement);
	AdditionalAnalytics_Sender.Insert("Contract"      , Parameters.ObjectData.SendLegalNameContract);
	AdditionalAnalytics_Sender.Insert("Order"         , Parameters.ObjectData.SendOrder);
	AdditionalAnalytics_Sender.Insert("BasisDocument" , Parameters.ObjectData.SendBasisDocument);
	
	Sender = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
		                                               Parameters.ObjectData.SendPartner, 
		                                               Parameters.ObjectData.SendAgreement,
		                                               Parameters.ObjectData.SendCurrency);
		                                               
	// Receiver
	AdditionalAnalytics_Receiver = New Structure();
	AdditionalAnalytics_Receiver.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics_Receiver.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics_Receiver.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics_Receiver.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics_Receiver.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics_Receiver.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Receiver = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
		                                                  Parameters.ObjectData.ReceivePartner, 
		                                                  Parameters.ObjectData.ReceiveAgreement,
		                                                  Parameters.ObjectData.ReceiveCurrency);
	
	// Customer - Customer
	From_CustomerAdvance_To_CustomerAdvance = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.AdvanceCustomer
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer);
	
	From_CustomerTransaction_To_CustomerTransaction = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.TransactionCustomer
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer);
	
	From_CustomerAdvance_To_CustomerTransaction = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.AdvanceCustomer
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer);
	
	// Vendor - Vendor
	From_VendorAdvance_To_VendorAdvance = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.AdvanceVendor
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor);
		
	From_VendorTransaction_To_VendorTransaction = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.TransactionVendor
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionVendor);
			
	From_VendorAdvance_To_VendorTransaction = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.AdvanceVendor
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionVendor);


//-----------------------------------	
	From_VendorTransaction_To_CustomerTransaction = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.TransactionVendor
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer);
	
	From_CustomerAdvance_To_VendorAdvance = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.AdvanceCustomer
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor);
	
	From_CustomerTransaction_To_VendorTransaction = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.TransactionCustomer
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionVendor);
	
	From_CustomerTransaction_To_VendorAdvance = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.TransactionCustomer
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor);
	
	From_VendorTransaction_To_CustomerAdvance = 
		(Parameters.ObjectData.SendDebtType = Enums.DebtTypes.TransactionVendor
		And Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer);
		
	// Advance customer (sender) -> Advance customer (receiver)*
	If From_CustomerAdvance_To_CustomerAdvance Then
		
		Debit_Account = Sender.AccountAdvancesCustomer;
		Debit_Analytics = AdditionalAnalytics_Sender;
	
		Credit_Account = Receiver.AccountAdvancesCustomer;
		Credit_Analytics = AdditionalAnalytics_Receiver;
	
	// Customer transaction (sender) -> Customer transaction (receiver)*
	ElsIf From_CustomerTransaction_To_CustomerTransaction Then
		
		Debit_Account = Receiver.AccountTransactionsCustomer;
		Debit_Analytics = AdditionalAnalytics_Receiver;
	
		Credit_Account = Sender.AccountTransactionsCustomer;
		Credit_Analytics = AdditionalAnalytics_Sender;
	
	// Advance customer (sender) -> Customer transaction (receiver)*
	ElsIf From_CustomerAdvance_To_CustomerTransaction Then
		
		Debit_Account = Sender.AccountAdvancesCustomer;
		Debit_Analytics = AdditionalAnalytics_Sender;
	
		Credit_Account = Receiver.AccountTransactionsCustomer;
		Credit_Analytics = AdditionalAnalytics_Receiver;
	
	// Advance vendor (sender) -> Advance vendor (receiver)*
	ElsIf From_VendorAdvance_To_VendorAdvance Then
		
		Debit_Account = Receiver.AccountAdvancesVendor;
		Debit_Analytics = AdditionalAnalytics_Receiver;
	
		Credit_Account = Sender.AccountAdvancesVendor;
		Credit_Analytics = AdditionalAnalytics_Sender;
	
	// Vendor transaction (sender) -> Vendor transaction (receiver)*
	ElsIf From_VendorTransaction_To_VendorTransaction Then
		Debit_Account = Sender.AccountTransactionsVendor;
		Debit_Analytics = AdditionalAnalytics_Sender;
	
		Credit_Account = Receiver.AccountTransactionsVendor;
		Credit_Analytics = AdditionalAnalytics_Receiver;
	
	// Advance vendor (sender) -> Vendor transaction (receiver)*
	ElsIf From_VendorAdvance_To_VendorTransaction Then
		
		Debit_Account = Sender.AccountTransactionsVendor;
		Debit_Analytics = AdditionalAnalytics_Receiver;
	
		Credit_Account = Receiver.AccountAdvancesVendor;
		Credit_Analytics = AdditionalAnalytics_Sender;
		
	// Vendor transaction (sender) -> Customer transaction
	ElsIf From_VendorTransaction_To_CustomerTransaction Then
				
		Debit_Account = Sender.AccountTransactionsVendor;
		Debit_Analytics = AdditionalAnalytics_Sender;
	
		Credit_Account = Receiver.AccountTransactionsCustomer;
		Credit_Analytics = AdditionalAnalytics_Receiver;
			
	// Advance customer (sender) -> Advance Vendor
	ElsIf From_CustomerAdvance_To_VendorAdvance Then
	
		Debit_Account = Receiver.AccountAdvancesCustomer;
		Debit_Analytics = AdditionalAnalytics_Sender;
					
		Credit_Account = Sender.AccountAdvancesVendor;
		Credit_Analytics = AdditionalAnalytics_Receiver;
			
	ElsIf From_CustomerTransaction_To_VendorTransaction Then
		
		Debit_Account = Receiver.AccountTransactionsVendor;
		Debit_Analytics = AdditionalAnalytics_Receiver;
					
		Credit_Account = Sender.AccountTransactionsCustomer;
		Credit_Analytics = AdditionalAnalytics_Sender;
					
	ElsIf From_CustomerTransaction_To_VendorAdvance Then
		
		Debit_Account = Receiver.AccountAdvancesVendor;
		Debit_Analytics = AdditionalAnalytics_Receiver;
					
		Credit_Account = Sender.AccountTransactionsCustomer;
		Credit_Analytics = AdditionalAnalytics_Sender;

	ElsIf From_VendorTransaction_To_CustomerAdvance Then
		
		Debit_Account = Receiver.AccountTransactionsVendor;
		Debit_Analytics = AdditionalAnalytics_Sender;
					
		Credit_Account = Sender.AccountAdvancesCustomer;
		Credit_Analytics = AdditionalAnalytics_Receiver;
					
	EndIf;
	
	// Debit	                                               
	AccountingAnalytics.Debit = Debit_Account;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, Debit_Analytics);
	
	// Credit
	AccountingAnalytics.Credit = Credit_Account;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, Credit_Analytics);
	
	Return AccountingAnalytics;
EndFunction

// Vendors transactions - Advances to vendors (offset)
Function GetAnalytics_DR_R1021B_VendorsTransactions_CR_R1020B_AdvancesToVendors_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.ReceivePartner, 
	                                                      Parameters.ObjectData.ReceiveAgreement,
	                                                      Parameters.ObjectData.ReceiveCurrency);
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts.AccountTransactionsVendor;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountAdvancesVendor;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

// Advance from customer - Customer transaction (offset)
Function GetAnalytics_DR_R2020B_AdvancesFromCustomers_CR_R2021B_CustomersTransactions_Offset(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	AdditionalAnalytics = New Structure();
	AdditionalAnalytics.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Accounts = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.ReceivePartner, 
	                                                      Parameters.ObjectData.ReceiveAgreement,
	                                                      Parameters.ObjectData.ReceiveCurrency);
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts.AccountAdvancesCustomer;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	// Credit
	AccountingAnalytics.Credit = Accounts.AccountTransactionsCustomer;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5020B_PartnersBalance_CR_R5021_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	AdditionalAnalytics_Partner = New Structure();
	AdditionalAnalytics_Partner.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics_Partner.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics_Partner.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics_Partner.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics_Partner.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics_Partner.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Accounts_Partner = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.ReceivePartner, 
	                                                      Parameters.ObjectData.ReceiveAgreement,
	                                                      Parameters.ObjectData.ReceiveCurrency);
		
	AdditionalAnalytics_Revenue = New Structure();
	AdditionalAnalytics_Revenue.Insert("RevenueType"  , Parameters.ObjectData.RevenueType);
	AdditionalAnalytics_Revenue.Insert("ProfitCenter" , Parameters.ObjectData.ProfitCenter);
	
	Accounts_Revenue = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.RevenueType,
	                                                          Parameters.ObjectData.ProfitCenter);
		
	// Debit
	If Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer Then                                                      
		AccountingAnalytics.Debit = Accounts_Partner.AccountTransactionsCustomer;
	ElsIf Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer Then
		AccountingAnalytics.Debit = Accounts_Partner.AccountAdvancesCustomer;
	ElsIf Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionVendor Then
		AccountingAnalytics.Debit = Accounts_Partner.AccountTransactionsVendor;
	ElsIf Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor Then
		AccountingAnalytics.Debit = Accounts_Partner.AccountAdvancesVendor;
	EndIf;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics_Partner);

	// Credit
	AccountingAnalytics.Credit = Accounts_Revenue.AccountRevenue;	
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics_Revenue);	
	
	Return AccountingAnalytics;
EndFunction

Function GetAnalytics_DR_R5022T_Expenses_CR_R5020B_PartnersBalance(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
	
	AdditionalAnalytics_Partner = New Structure();
	AdditionalAnalytics_Partner.Insert("Partner"       , Parameters.ObjectData.ReceivePartner);
	AdditionalAnalytics_Partner.Insert("LegalName"     , Parameters.ObjectData.ReceiveLegalName);
	AdditionalAnalytics_Partner.Insert("Agreement"     , Parameters.ObjectData.ReceiveAgreement);
	AdditionalAnalytics_Partner.Insert("Contract"      , Parameters.ObjectData.ReceiveLegalNameContract);
	AdditionalAnalytics_Partner.Insert("Order"         , Parameters.ObjectData.ReceiveOrder);
	AdditionalAnalytics_Partner.Insert("BasisDocument" , Parameters.ObjectData.ReceiveBasisDocument);
	
	Accounts_Partner = AccountingServer.GetT9012S_AccountsPartner(AccountParameters, 
	                                                      Parameters.ObjectData.ReceivePartner, 
	                                                      Parameters.ObjectData.ReceiveAgreement,
	                                                      Parameters.ObjectData.ReceiveCurrency);
	
	AdditionalAnalytics_Expense = New Structure();
	AdditionalAnalytics_Expense.Insert("ExpenseType" , Parameters.ObjectData.ExpenseType);
	AdditionalAnalytics_Expense.Insert("LossCenter"  , Parameters.ObjectData.LossCenter);
	
	Accounts_Expense = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.ObjectData.ExpenseType,
	                                                          Parameters.ObjectData.LossCenter);
	
	// Debit                                                      
	AccountingAnalytics.Debit = Accounts_Expense.AccountExpense;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics_Expense);

	// Credit
	If Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionCustomer Then                                                      
		AccountingAnalytics.Credit = Accounts_Partner.AccountTransactionsCustomer;
	ElsIf Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceCustomer Then
		AccountingAnalytics.Credit = Accounts_Partner.AccountAdvancesCustomer;
	ElsIf Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.TransactionVendor Then
		AccountingAnalytics.Credit = Accounts_Partner.AccountTransactionsVendor;
	ElsIf Parameters.ObjectData.ReceiveDebtType = Enums.DebtTypes.AdvanceVendor Then
		AccountingAnalytics.Credit = Accounts_Partner.AccountAdvancesVendor;
	EndIf;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics_Partner);	
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion