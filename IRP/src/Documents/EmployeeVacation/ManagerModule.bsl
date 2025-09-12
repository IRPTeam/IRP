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
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	MIN(EmployeeList.BeginDate) AS BeginDate,
	|	MAX(EmployeeList.EndDate) AS EndDate,
	|	DATETIME(1, 1, 1) AS Date
	|FROM
	|	Document.EmployeeVacation.EmployeeList AS EmployeeList
	|WHERE
	|	EmployeeList.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DateTable = QueryTable.CopyColumns("Date");
	If QueryTable.Count() Then
		_CurrentDate = BegOfDay(QueryTable[0].BeginDate);
		While _CurrentDate <= BegOfDay(QueryTable[0].EndDate) Do
			DateTable.Add().Date = _CurrentDate;
			_CurrentDate = BegOfDay(EndOfDay(_CurrentDate) + 1);
		EndDo;
	EndIf;
	Query.SetParameter("DateTable", DateTable);
	
	Query.Text = 
	"SELECT
	|	DateTable.Date
	|INTO DateTable
	|FROM
	|	&DateTable AS DateTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	EmployeeList.Ref.Date AS Period,
	|	DateTable.Date AS Date,
	|	EmployeeList.BeginDate AS BeginDate,
	|	EmployeeList.EndDate AS EndDate,
	|	EmployeeList.PaidDays AS PaidDays,
	|	EmployeeList.Employee AS Employee,
	|	EmployeeList.Ref.Company AS Company,
	|	EmployeeList.Ref.Branch AS Branch
	|INTO EmployeeVacations
	|FROM
	|	Document.EmployeeVacation.EmployeeList AS EmployeeList
	|		INNER JOIN DateTable AS DateTable
	|		ON DateTable.Date >= EmployeeList.BeginDate
	|		AND DateTable.Date <= EmployeeList.EndDate
	|		AND EmployeeList.Ref = &Ref
	|WHERE
	|	EmployeeList.Ref = &Ref";
	Query.Execute();
	
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
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
	StrParams.Insert("DateBefore", New Boundary(CommonFunctionsServer.GetRefAttribute(Ref, "Date"), BoundaryType.Excluding));
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T9540S_EmployeeVacations());
	QueryArray.Add(R9541T_VacationUsage());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

Function T9540S_EmployeeVacations()
	Return
		"SELECT
		|	EmployeeVacations.Period,
		|	EmployeeVacations.Date,
		|	EmployeeVacations.Company,
		|	EmployeeVacations.Branch,
		|	EmployeeVacations.Employee
		|INTO T9540S_EmployeeVacations
		|FROM
		|	EmployeeVacations AS EmployeeVacations
		|WHERE
		|	TRUE";
EndFUnction

Function R9541T_VacationUsage()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	EmployeeVacations.Date AS Period,
		|	EmployeeVacations.Company,
		|	EmployeeVacations.Employee,
		|	1 AS Days
		|INTO R9541T_VacationUsage
		|FROM
		|	EmployeeVacations AS EmployeeVacations
		|WHERE
		|	EmployeeVacations.Date < DATEADD(EmployeeVacations.BeginDate, Day, EmployeeVacations.PaidDays)";
EndFUnction

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