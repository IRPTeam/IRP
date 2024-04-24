// @strict-types

#Region Posting

// Posting get document data tables.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - Undefined - Posting mode
//  Parameters - Structure:
//  * Cancel - Boolean
//  * Object - DocumentObject
//  * PostingByRef - Boolean
//  * IsReposting - Boolean
//  * PointInTime - PointInTime
//  * TempTablesManager - TempTablesManager
//  * Metadata - MetadataObject
//  * DocumentDataTables - Structure
//  * LockDataSources - Map
//  * PostingDataTables - Map
//  * AddInfo - Arbitrary
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
// Parameters: see PostingGetDocumentDataTables
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
// * QueryTextsMasterTables - Array - 
// * QueryTextsSecondaryTables - Array - 
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
	|	ExpenseAccrualsCostList.Ref.Date AS Period,
	|	ExpenseAccrualsCostList.Ref.Company AS Company,
	|	ExpenseAccrualsCostList.Ref.Branch AS Branch,
	|	ExpenseAccrualsCostList.Ref.Currency AS Currency,
	|	ExpenseAccrualsCostList.Basis AS Basis,
	|	ExpenseAccrualsCostList.Amount AS Amount,
	|	ExpenseAccrualsCostList.AmountTax AS AmountTax,
	|	ExpenseAccrualsCostList.Amount + ExpenseAccrualsCostList.AmountTax AS AmountWithTaxes
	|INTO CostList
	|FROM
	|	Document.ExpenseAccruals.CostList AS ExpenseAccrualsCostList
	|WHERE
	|	ExpenseAccrualsCostList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array; // Array of String
	QueryArray.Add(R6070T_OtherPeriodsExpenses());
	QueryArray.Add(R5022T_Expenses());	
	Return QueryArray;
EndFunction

#EndRegion

#Region Undoposting

// Undoposting get document data tables.
// 
// Parameters:
//  Ref - DocumentRef
//  Cancel - Boolean
//  PostingMode - DocumentPostingMode
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
//  PostingMode - DocumentPostingMode
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
//  PostingMode - DocumentPostingMode
//  Parameters - Structure:
//  * DocumentDataTables - Structure
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
	|	*,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	VALUE(Enum.OtherPeriodExpenseType.ExpenseAccruals) AS OtherPeriodExpenseType,
	|	VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency) AS CurrencyMovementType
	|INTO R5022T_Expenses
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
EndFunction

Function R6070T_OtherPeriodsExpenses()
	Return
	"SELECT
	|	*,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	VALUE(Enum.OtherPeriodExpenseType.ExpenseAccruals) AS OtherPeriodExpenseType,
	|	VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency) AS CurrencyMovementType
	|INTO R6070T_OtherPeriodsExpenses
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";

EndFunction

#EndRegion