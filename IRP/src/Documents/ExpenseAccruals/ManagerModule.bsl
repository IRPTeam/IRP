// @strict-types

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
	DocumentDataTables = Parameters.DocumentDataTables; // Structure
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

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array; // Array of String
	QueryArray.Add(CostList());
	Return QueryArray;
EndFunction

Function CostList()
	Return
	"SELECT
	|	ExpenseAccrualsCostList.Key AS Key,
	|	ExpenseAccrualsCostList.Ref.Date AS Period,
	|	ExpenseAccrualsCostList.Ref.Company AS Company,
	|	ExpenseAccrualsCostList.Ref.Branch AS Branch,
	|	ExpenseAccrualsCostList.Ref.Currency AS Currency,
	|	ExpenseAccrualsCostList.ProfitLossCenter AS ProfitLossCenter,
	|	ExpenseAccrualsCostList.ExpenseType AS ExpenseType,
	|	ExpenseAccrualsCostList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ExpenseAccrualsCostList.Project AS Project,
	|	CASE
	|		WHEN ExpenseAccrualsCostList.Ref.Basis = UNDEFINED
	|			THEN &Ref
	|		ELSE ExpenseAccrualsCostList.Ref.Basis
	|	END AS Basis,
	|	CASE
	|		WHEN ExpenseAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual)
	|			THEN 1
	|		WHEN ExpenseAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse)
	|			THEN -1
	|		WHEN ExpenseAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.VOID)
	|			THEN 1
	|		ELSE 1
	|	END AS Factor,
	|	ExpenseAccrualsCostList.Amount AS Amount,
	|	ExpenseAccrualsCostList.AmountTax AS AmountTax,
	|	ExpenseAccrualsCostList.Amount + ExpenseAccrualsCostList.AmountTax AS AmountWithTaxes,
	|	ExpenseAccrualsCostList.Ref.TransactionType As TransactionType
	|INTO CostList
	|FROM
	|	Document.ExpenseAccruals.CostList AS ExpenseAccrualsCostList
	|WHERE
	|	ExpenseAccrualsCostList.Ref = &Ref";
EndFunction

#EndRegion

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

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array; // Array of String
	QueryArray.Add(R5022T_Expenses());	
	QueryArray.Add(R6070T_OtherPeriodsExpenses());	
	Return QueryArray;
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
//  Parameters - See PostingServer.GetPostingParametersEmptyStructure
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

#Region PostingInfo

Function R5022T_Expenses()
	Return
	"SELECT
	|	CostList.Period AS Period,
	|	CostList.Company AS Company,
	|	CostList.Branch AS Branch,
	|	CostList.Currency AS Currency,
	|	CostList.ProfitLossCenter AS ProfitLossCenter,
	|	CostList.ExpenseType AS ExpenseType,
	|	CostList.AdditionalAnalytic AS AdditionalAnalytic,
	|	CostList.Project AS Project,
	|	CostList.Basis AS Basis,
	|	CostList.Amount AS Amount,
	|	CostList.AmountTax AS AmountTax,
	|	CostList.AmountWithTaxes AS AmountWithTaxes
	|INTO R5022T_Expenses
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
EndFunction

Function R6070T_OtherPeriodsExpenses()
	Return
	"SELECT
	|	CostList.Period AS Period, 
	|	CASE
	|		WHEN CostList.TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual)
	|			THEN VALUE(AccumulationRecordType.Expense)
	|		WHEN CostList.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse)
	|			THEN VALUE(AccumulationRecordType.Receipt)
	|		WHEN CostList.TransactionType = VALUE(Enum.AccrualsTransactionType.VOID)
	|			THEN VALUE(AccumulationRecordType.Expense)
	|	END AS RecordType,
	|	VALUE(Enum.OtherPeriodExpenseType.ExpenseAccruals) AS OtherPeriodExpenseType,
	|	CostList.Company AS Company,
	|	CostList.Branch AS Branch,
	|	CostList.Basis AS Basis,
	|	CostList.Currency AS Currency,
	|	CostList.Amount * CostList.Factor AS Amount,
	|	CostList.AmountTax * CostList.Factor AS AmountTax
	|INTO R6070T_OtherPeriodsExpenses
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
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