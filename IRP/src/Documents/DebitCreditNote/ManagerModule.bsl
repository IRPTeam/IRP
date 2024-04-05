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
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

//IsSendAdvanceCustomer
//IsSendAdvanceVendor
//IsReceiveAdvanceCustomer
//IsReceiveAdvanceVendor
//
//IsSendTransactionCustomer
//IsSendTransactionVendor
//IsReceiveTransactionCustomer
//IsReceiveTransactionVendor

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
