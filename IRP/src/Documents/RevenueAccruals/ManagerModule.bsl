// @strict-types

#Region PrintForm

// Get print form.
// 
// Parameters:
//  Ref - DocumentRef.ExpenseAccruals
//  PrintFormName - String
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Undefined - Get print form
Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

// Posting get document data tables.
// 
// Parameters:
// Parameters - See PostingServer.GetPostingParametersEmptyStructure
// 
// Returns:
//  Structure - Posting get document data tables
Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Parameters.IsReposting = False;
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	
	Return Tables;
EndFunction

// Posting get lock data source.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Map - Posting get lock data source
Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();

	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	
	Return DataMapWithLockFields;
EndFunction

// Posting check before write.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

// Posting get posting data tables.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Map - Posting get posting data tables
Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

// Posting check after write.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Posting_Info

// Get information about movements.
// 
// Parameters:
//  Ref - DocumentRef
// 
// Returns:
//  Structure - Get information about movements:
// * QueryParameters - Structure - :
// ** Ref - DocumentRef - 
// * QueryTextsMasterTables - Array of String
// * QueryTextsSecondaryTables - Array of String 
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", New Array);
	Str.Insert("QueryTextsSecondaryTables", New Array);
	Return Str;
EndFunction

// Get additional query parameters.
// 
// Parameters:
//  Ref - DocumentRef
// 
// Returns:
//  Structure - Structure:
// * Ref - DocumentRef 
Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array; // Array of String
	QueryArray.Add(CostList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array; // Array of String
	QueryArray.Add(R5021T_Revenues());	
	QueryArray.Add(R6080T_OtherPeriodsRevenues());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function CostList()
	Return
	"SELECT
	|	CostList.Key AS Key,
	|	CostList.Ref.Date AS Period,
	|	CostList.Ref.Company AS Company,
	|	CostList.Ref.Branch AS Branch,
	|	CostList.Ref.Currency AS Currency,
	|	CostList.ProfitLossCenter AS ProfitLossCenter,
	|	CostList.RevenueType AS RevenueType,
	|	CostList.AdditionalAnalytic AS AdditionalAnalytic,
	|	CostList.Project AS Project,
	|	CASE
	|		WHEN CostList.Ref.Basis.Ref IS NULL
	|			THEN &Ref
	|		ELSE CostList.Ref.Basis
	|	END AS Basis,
	|	CASE
	|		WHEN CostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse)
	|			THEN -1
	|		ELSE 1
	|	END AS Factor,
	|	CostList.Amount AS Amount,
	|	CostList.Ref.TransactionType AS TransactionType,
	|	CostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse) AS IsReverse,
	|	CostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual) AS IsAccrual,
	|	CostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Void) AS IsVoid
	|INTO CostList
	|FROM
	|	Document.RevenueAccruals.CostList AS CostList
	|WHERE
	|	CostList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R5021T_Revenues()
	Return
	"SELECT
	|	CostList.Period AS Period,
	|	CostList.Company AS Company,
	|	CostList.Branch AS Branch,
	|	CostList.Currency AS Currency,
	|	CostList.ProfitLossCenter AS ProfitLossCenter,
	|	CostList.RevenueType AS RevenueType,
	|	CostList.AdditionalAnalytic AS AdditionalAnalytic,
	|	CostList.Project AS Project,
	|	CostList.Basis AS Basis,
	|	CostList.Amount AS Amount
	|INTO R5021T_Revenues
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
EndFunction

Function R6080T_OtherPeriodsRevenues()
	Return
	"SELECT
	|	CostList.Period AS Period, 
	|	CASE
	|		WHEN CostList.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse)
	|			THEN VALUE(AccumulationRecordType.Receipt)
	|		ELSE
	|			VALUE(AccumulationRecordType.Expense)
	|	END AS RecordType,
	|	VALUE(Enum.OtherPeriodRevenueType.RevenueAccruals) AS OtherPeriodRevenueType,
	|	CostList.Company AS Company,
	|	CostList.Branch AS Branch,
	|	CostList.Basis AS Basis,
	|	CostList.Currency AS Currency,
	|	CostList.ProfitLossCenter,
	|	CostList.RevenueType,
	|	CostList.Amount * CostList.Factor AS Amount
	|INTO R6080T_OtherPeriodsRevenues
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";


EndFunction

#EndRegion

#Region Undoposting

// Undoposting get document data tables.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Undoposting get document data tables
Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

// Undoposting get lock data source.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Map - Undoposting get lock data source
Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	Return DataMapWithLockFields;
EndFunction

// Undoposting check before write.
// 
//	Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - Structure:
//  * DocumentDataTables - Structure
//  AddInfo - Undefined - Add info
Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

// Undoposting check after write.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
//  AddInfo - Undefined - Add info
Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

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

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	CostList.Period,
		|	CostList.Key AS RowKey,
		|	CostList.Currency,
		|	CostList.Amount * CostList.Factor AS Amount,
		|	VALUE(Catalog.AccountingOperations.RevenueAccruals_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	CostList AS CostList
		|WHERE
		|	CostList.IsAccrual
		|	OR CostList.IsVoid
		|
		|UNION ALL
		|
		|SELECT
		|	CostList.Period,
		|	CostList.Key AS RowKey,
		|	CostList.Currency,
		|	CostList.Amount * CostList.Factor AS Amount,
		|	VALUE(Catalog.AccountingOperations.RevenueAccruals_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|FROM
		|	CostList AS CostList
		|WHERE
		|	CostList.IsReverse";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.RevenueAccruals_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues Then
		
		Return GetAnalytics_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues(Parameters); // Other period revenues - Revenues
		
	ElsIf Parameters.Operation = AO.RevenueAccruals_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues Then
		
		Return GetAnalytics_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues(Parameters); // Revenues - Other period revenues (reverse)
		
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Other period revenues - Revenues
Function GetAnalytics_DR_R6080T_OtherPeriodsRevenues_CR_R5021T_Revenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.RevenueType,
	                                                          Parameters.RowData.ProfitLossCenter);
	
	AccountingAnalytics.Debit = Debit.AccountOtherPeriodsRevenue;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                    	   Parameters.RowData.RevenueType,
	                                                    	   Parameters.RowData.ProfitLossCenter);
	                                                    
	AccountingAnalytics.Credit = Credit.AccountRevenue;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Revenues - Other period revenues (reverse)
Function GetAnalytics_DR_R5021T_Revenues_CR_R6080T_OtherPeriodsRevenues(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.RevenueType,
	                                                          Parameters.RowData.ProfitLossCenter);
	
	AccountingAnalytics.Debit = Debit.AccountRevenue;
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                    	   Parameters.RowData.RevenueType,
	                                                    	   Parameters.RowData.ProfitLossCenter);
	                                                    
	AccountingAnalytics.Credit = Credit.AccountOtherPeriodsRevenue;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion
