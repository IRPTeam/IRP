// @strict-types

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Parameters.IsReposting = False;
	Return Tables;
	
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();

	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	
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
	|	ExpenseAccrualsCostList.AmountTax AS AmountTax
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

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	PostingServer.GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

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

Function GetQueryTexts()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

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