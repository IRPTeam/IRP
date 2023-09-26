#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	T.Company,
	|	T.Branch,
	|	T.Branch AS ProfitLossCenter,
	|	T.FixedAsset,
	|	T.LedgerType,
	|	T.Schedule,
	|	&Currency AS Currency,
	|	"""" AS Key,
	|	CASE
	|		WHEN T.Schedule.CalculationMethod = VALUE(Enum.DepreciationMethods.DecliningBalance)
	|			THEN T.AmountBalance / 100 * T.Schedule.Rate
	|		WHEN T.Schedule.CalculationMethod = VALUE(Enum.DepreciationMethods.StraightLine)
	|			THEN T.AmountBalance / T.Schedule.UsefulLife
	|	END AS Amount
	|INTO DepreciationInfo
	|FROM
	|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&Period, Company = &Company
	|	AND Branch = &Branch
	|	AND LedgerType.CalculateDepreciation
	|	AND LedgerType.StartDate <= &StartDate) AS T";
	
	Query.SetParameter("Period"    , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("StartDate" , Ref.Date);
	Query.SetParameter("Company"   , Ref.Company);
	Query.SetParameter("Branch"    , Ref.Branch); 
	Query.SetParameter("Currency"  , CurrenciesServer.GetLandedCostCurrency(Ref.Company)); 
		
	Query.Execute();
		
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
	
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R8510B_BookValueOfFixedAsset.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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
	StrParams.Insert("Date", Ref.Date);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	QueryArray.Add(R5022T_Expenses());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_MainTables

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	*,
		|	&Date AS Period,
		|	VALUE(AccumulationRecordType.Expense) AS RecordType
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	DepreciationInfo
		|WHERE
		|	TRUE";
EndFunction

Function R5022T_Expenses()
	Return
		"SELECT
		|	*,
		|	&Date AS Period
		|INTO R5022T_Expenses
		|FROM
		|	DepreciationInfo
		|WHERE
		|	TRUE";
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
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion