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
	//QueryArray.Add(T1040T_AccountingAmounts());
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
		|	Doc.Currency,
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
		|	Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.Amount
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
		|	Doc.Currency,
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
		|	Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.Amount
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
		|	Doc.Currency,
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
		|	Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.Amount
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
		|	Doc.Currency,
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
		|	Doc.SendLegalNameContract <> Doc.ReceiveLegalNameContract AS IsDifferentContracts,
		|	(Doc.Branch <> Doc.ReceiveBranch 
		|		Or Doc.SendPartner <> Doc.ReceivePartner
		|		Or Doc.SendLegalName <> Doc.ReceiveLegalName
		|		Or Doc.SendAgreement <> Doc.ReceiveAgreement
		|		Or case when Doc.SendBasisDocument.Ref IS NULL Then Undefined else Doc.SendBasisDocument end
		|			<> case when Doc.ReceiveBasisDocument.Ref IS NULL Then Undefined else Doc.ReceiveBasisDocument end) AS IsDifferentPartners,
		|	Doc.Amount
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
		|	VALUE(AccumulationRecordType.Receipt),
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
		|	VALUE(AccumulationRecordType.Expense),
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
		|	VALUE(AccumulationRecordType.Receipt),
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
