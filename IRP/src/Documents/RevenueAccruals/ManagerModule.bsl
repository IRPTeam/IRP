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
	|	RevenueAccrualsCostList.Key AS Key,
	|	RevenueAccrualsCostList.Ref.Date AS Period,
	|	RevenueAccrualsCostList.Ref.Company AS Company,
	|	RevenueAccrualsCostList.Ref.Branch AS Branch,
	|	RevenueAccrualsCostList.Ref.Currency AS Currency,
	|	RevenueAccrualsCostList.ProfitLossCenter AS ProfitLossCenter,
	|	RevenueAccrualsCostList.ExpenseType AS ExpenseType,
	|	RevenueAccrualsCostList.AdditionalAnalytic AS AdditionalAnalytic,
	|	RevenueAccrualsCostList.Project AS Project,
	|	CASE
	|		WHEN RevenueAccrualsCostList.Ref.Basis = UNDEFINED
	|			THEN &Ref
	|		ELSE RevenueAccrualsCostList.Ref.Basis
	|	END AS Basis,
	|	RevenueAccrualsCostList.Amount AS Amount,
	|	RevenueAccrualsCostList.AmountTax AS AmountTax,
	|	RevenueAccrualsCostList.Amount + RevenueAccrualsCostList.AmountTax AS AmountWithTaxes,
	|	CASE
	|		WHEN RevenueAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual)
	|			THEN VALUE(AccumulationRecordType.Expense)
	|		WHEN RevenueAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse)
	|			THEN VALUE(AccumulationRecordType.Receipt)
	|		WHEN RevenueAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.VOID)
	|			THEN VALUE(AccumulationRecordType.Expense)
	|		ELSE VALUE(AccumulationRecordType.Expense)
	|	END AS RecordType,
	|	CASE
	|		WHEN RevenueAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Accrual)
	|			THEN 1
	|		WHEN RevenueAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.Reverse)
	|			THEN 1
	|		WHEN RevenueAccrualsCostList.Ref.TransactionType = VALUE(Enum.AccrualsTransactionType.VOID)
	|			THEN -1
	|		ELSE 1
	|	END AS Factor
	|INTO CostListTemp
	|FROM
	|	Document.RevenueAccruals.CostList AS RevenueAccrualsCostList
	|WHERE
	|	RevenueAccrualsCostList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CostListTemp.Key AS Key,
	|	CostListTemp.Period AS Period,
	|	CostListTemp.Company AS Company,
	|	CostListTemp.Branch AS Branch,
	|	CostListTemp.Currency AS Currency,
	|	CostListTemp.ProfitLossCenter AS ProfitLossCenter,
	|	CostListTemp.ExpenseType AS ExpenseType,
	|	CostListTemp.AdditionalAnalytic AS AdditionalAnalytic,
	|	CostListTemp.Project AS Project,
	|	CostListTemp.Basis AS Basis,
	|	CostListTemp.Amount * CostListTemp.Factor AS Amount,
	|	CostListTemp.AmountTax * CostListTemp.Factor AS AmountTax,
	|	CostListTemp.AmountWithTaxes * CostListTemp.Factor AS AmountWithTaxes,
	|	CostListTemp.RecordType AS RecordType
	|INTO CostList
	|FROM
	|	CostListTemp AS CostListTemp";
EndFunction

#EndRegion

#Region PrintForm

// Get print form.
// 
// Parameters:
//  Ref - DocumentRef
//  PrintFormName - String
//  AddInfo - Arbitrary
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
	QueryArray.Add(R6080T_OtherPeriodsRevenues());
	QueryArray.Add(R5021T_Revenues());	
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

Function R5021T_Revenues()
	Return
	"SELECT
	|	*,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	VALUE(Enum.OtherPeriodRevenueType.RevenueAccruals) AS OtherPeriodRevenueType,
	|	VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency) AS CurrencyMovementType
	|INTO R5021T_Revenues
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
EndFunction

Function R6080T_OtherPeriodsRevenues()
	Return
	"SELECT
	|	*,
	|	VALUE(Enum.OtherPeriodRevenueType.RevenueAccruals) AS OtherPeriodRevenueType,
	|	VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency) AS CurrencyMovementType
	|INTO R6080T_OtherPeriodsRevenues
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