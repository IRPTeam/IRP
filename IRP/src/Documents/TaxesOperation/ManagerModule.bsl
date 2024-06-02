#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Parameters.IsReposting = False;
	
	//AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	
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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", New Array);
	Str.Insert("QueryTextsSecondaryTables", New Array);
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	StrParams.Insert("Vat", TaxesServer.GetVatRef());
	
//	TotalTaxAmount_Incoming = Ref.TaxesIncoming.Total("TaxAmount");
//	TotalTaxAmount_Outgoing = Ref.TaxesOutgoing.Total("TaxAmount");
//	
//	If TotalTaxAmount_Incoming < TotalTaxAmount_Outgoing Then
//		StrParams.Insert("IncomingIsLess", True);	
//		StrParams.Insert("OutgoingIsLess", False);
//	Else
//		StrParams.Insert("IncomingIsLess", False);	
//		StrParams.Insert("OutgoingIsLess", True);
//	EndIf;		
	
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	//QueryArray.Add(TaxesDifference());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
//	QueryArray.Add(R1040B_TaxesOutgoing());
//	QueryArray.Add(R2040B_TaxesIncoming());
//	QueryArray.Add(R5010B_ReconciliationStatement());
//	QueryArray.Add(R5015B_OtherPartnersTransactions());
//	QueryArray.Add(T1040T_AccountingAmounts());
//	QueryArray.Add(R5020B_PartnersBalance());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function TaxesDifference()
	Return
		"SELECT
		|	TaxesDifference.Ref.Date AS Period,
		|	TaxesDifference.Ref.Company AS Company,
		|	TaxesDifference.Ref.Branch AS Branch,
		|	&Vat AS Tax,
//		|	&IncomingIsLess AS IncomingIsLess,
//		|	&OutgoingIsLess AS OutgoingIsLess,
		|	TaxesDifference.Ref.Currency AS Currency,
		|	TaxesDifference.IncomingVatRate,
		|	TaxesDifference.OutgoingVatRate,
		|	TaxesDifference.Ref.Partner AS Partner,
		|	TaxesDifference.Ref.LegalName AS LegalName,
		|	TaxesDifference.Ref.LegalNameContract AS LegalNameContract,
		|	TaxesDifference.Ref.Agreement AS Agreement,
		|	CASE
		|		WHEN TaxesDifference.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN TaxesDifference.Ref
		|		ELSE UNDEFINED
		|	END AS Basis,
		|	TaxesDifference.NetAmount AS TaxableAmount,
		|	TaxesDifference.TaxAmount AS TaxAmount,
		|	TaxesDifference.Ref.TransactionType = VALUE(Enum.TaxesOperationTransactionType.TaxOffset) AS IsTaxOffset,
		|	TaxesDifference.Ref.TransactionType = VALUE(Enum.TaxesOperationTransactionType.TaxOffsetAndPayment) AS IsTaxOffsetAndPayment,
		|	TaxesDifference.Ref.TransactionType = VALUE(Enum.TaxesOperationTransactionType.TaxPayment) AS IsTaxPayment
		|INTO TaxesDifference
		|FROM
		|	Document.TaxesOperation.TaxesDifference AS TaxesDifference
		|WHERE
		|	TaxesDifference.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R1040B_TaxesOutgoing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Tax,
		|	TaxesDifference.Currency,
		|	TaxesDifference.OutgoingVatRate AS TaxRate,
		|	TaxesDifference.TaxableAmount,
		|	TaxesDifference.TaxAmount
		|INTO R1040B_TaxesOutgoing
		|FROM
		|	TaxesDifference as TaxesDifference
		|WHERE
		|	(TaxesDifference.IsTaxOffset OR TaxesDifference.IsTaxOffsetAndPayment)
		|	AND NOT TaxesDifference.OutgoingVatRate.Ref IS NULL ";
EndFunction 

Function R2040B_TaxesIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Tax,
		|	TaxesDifference.Currency,
		|	TaxesDifference.IncomingVatRate AS TaxRate,
		|	TaxesDifference.TaxableAmount,
		|	TaxesDifference.TaxAmount
		|INTO R2040B_TaxesIncoming
		|FROM
		|	TaxesDifference as TaxesDifference
		|WHERE
		|	(TaxesDifference.IsTaxOffset OR TaxesDifference.IsTaxOffsetAndPayment)
		|	AND NOT TaxesDifference.IncomingVatRate.Ref IS NULL";
EndFunction 

Function R5015B_OtherPartnersTransactions()
	Return
		"SELECT
		|	CASE
		|		WHEN TaxesDifference.IncomingIsLess
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Currency,
		|	TaxesDifference.LegalName,
		|	TaxesDifference.Partner,
		|	TaxesDifference.Areement,
		|	TaxesDifference.Basis,
		|	TaxesDifference.TaxAmount AS Amount
		|INTO R5015B_OtherPartnersTransactions
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	TaxesDifference.IsTaxOffsetAndPaymant
		|	OR TaxesDifference.IsTaxPayment";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	CASE
		|		WHEN TaxesDifference.IncomingIsLess
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	TaxesDifference.Period,
		|	TaxesDifference.Company,
		|	TaxesDifference.Branch,
		|	TaxesDifference.Currency,
		|	TaxesDifference.LegalName,
		|	TaxesDifference.LegalNameContract,
		|	TaxesDifference.TaxAmount AS Amount
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	TaxesDifference AS TaxesDifference
		|WHERE
		|	TaxesDifference.IsTaxOffsetAndPaymant
		|	OR TaxesDifference.IsTaxPayment";
EndFunction

#EndRegion

#Region AccessObject


// Get access key.
// 
// Parameters:
//  Obj - DocumentRef.ExpenseAccruals
// 
// Returns:
//  Map - Map:
//  *Company - CatalogRef.Companies
//	*Branch - CatalogRef.BusinessUnits
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	//@skip-check property-return-type
	//@skip-check invocation-parameter-type-intersect
	//@skip-check unknown-method-property
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

//Function T1040T_AccountingAmounts()
//	Return 
//		"SELECT
//		|	CostList.Period,
//		|	CostList.Key AS RowKey,
//		|	CostList.Currency,
//		|	CostList.Amount * CostList.Factor AS Amount,
//		|	VALUE(Catalog.AccountingOperations.ExpenseAccruals_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses) AS Operation,
//		|	UNDEFINED AS AdvancesClosing
//		|INTO T1040T_AccountingAmounts
//		|FROM
//		|	CostList AS CostList
//		|WHERE
//		|	CostList.IsAccrual
//		|	OR CostList.IsVoid
//		|
//		|UNION ALL
//		|
//		|SELECT
//		|	CostList.Period,
//		|	CostList.Key AS RowKey,
//		|	CostList.Currency,
//		|	CostList.Amount * CostList.Factor AS Amount,
//		|	VALUE(Catalog.AccountingOperations.ExpenseAccruals_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses) AS Operation,
//		|	UNDEFINED AS AdvancesClosing
//		|FROM
//		|	CostList AS CostList
//		|WHERE
//		|	CostList.IsReverse";
//EndFunction
//
//Function GetAccountingAnalytics(Parameters) Export
//	AO = Catalogs.AccountingOperations;
//	If Parameters.Operation = AO.ExpenseAccruals_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses Then
//		
//		Return GetAnalytics_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses(Parameters); // Expense - Other period expense
//		
//	ElsIf Parameters.Operation = AO.ExpenseAccruals_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses Then
//		
//		Return GetAnalytics_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses(Parameters); // Other period expense - Expense (reverse) 
//		
//	EndIf;
//	Return Undefined;
//EndFunction

#Region Accounting_Analytics

//// Expense - Other period expense
//Function GetAnalytics_DR_R5022T_Expenses_CR_R6070T_OtherPeriodsExpenses(Parameters)
//	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
//	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
//
//	// Debit
//	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
//	                                                          Parameters.RowData.ExpenseType,
//	                                                          Parameters.RowData.ProfitLossCenter);
//	
//	AccountingAnalytics.Debit = Debit.AccountExpense;
//	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
//	
//	// Credit
//	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
//	                                                    	   Parameters.RowData.ExpenseType,
//	                                                    	   Parameters.RowData.ProfitLossCenter);
//	                                                    
//	AccountingAnalytics.Credit = Credit.AccountOtherPeriodsExpense;
//	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
//
//	Return AccountingAnalytics;
//EndFunction
//
//// Other period expense - Expense (reverse)
//Function GetAnalytics_DR_R6070T_OtherPeriodsExpenses_CR_R5022T_Expenses(Parameters)
//	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
//	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);
//
//	// Debit
//	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
//	                                                          Parameters.RowData.ExpenseType,
//	                                                          Parameters.RowData.ProfitLossCenter);
//	
//	AccountingAnalytics.Debit = Debit.AccountOtherPeriodsExpense;
//	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
//	
//	// Credit
//	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
//	                                                    	   Parameters.RowData.ExpenseType,
//	                                                    	   Parameters.RowData.ProfitLossCenter);
//	                                                    
//	AccountingAnalytics.Credit = Credit.AccountExpense;
//	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
//
//	Return AccountingAnalytics;
//EndFunction
//
//Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
//	Return Value;
//EndFunction
//
//Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
//	Return Value;
//EndFunction

#EndRegion

#EndRegion
