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
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(T9510S_Staffing());
	QueryArray.Add(R9541T_VacationUsage());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

Function T9510S_Staffing()
	Return
		"SELECT
		|	EmployeeFiring.Date AS Period,
		|	EmployeeFiring.Company,
		|	EmployeeFiring.Employee,
		|	TRUE AS Fired
		|INTO T9510S_Staffing
		|FROM
		|	Document.EmployeeFiring AS EmployeeFiring
		|WHERE
		|	EmployeeFiring.Ref = &Ref";
EndFunction

Function R9541T_VacationUsage()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	EmployeeFiring.Date AS Period,
		|	EmployeeFiring.Company,
		|	EmployeeFiring.Employee,
		|	ISNULL(R9541T_VacationUsageBalance.DaysBalance, 0) + ISNULL(R9541T_VacationUsageTurnovers.DaysExpense, 0) AS Days
		|INTO R9541T_VacationUsage
		|FROM
		|	Document.EmployeeFiring AS EmployeeFiring
		|		LEFT JOIN AccumulationRegister.R9541T_VacationUsage.Balance AS R9541T_VacationUsageBalance
		|		ON EmployeeFiring.Company = R9541T_VacationUsageBalance.Company
		|		AND EmployeeFiring.Employee = R9541T_VacationUsageBalance.Employee
		|		LEFT JOIN AccumulationRegister.R9541T_VacationUsage.Turnovers(,, Recorder,) AS R9541T_VacationUsageTurnovers
		|		ON R9541T_VacationUsageTurnovers.Recorder = &Ref
		|		AND R9541T_VacationUsageTurnovers.Company = EmployeeFiring.Company
		|		AND R9541T_VacationUsageTurnovers.Employee = EmployeeFiring.Employee
		|WHERE
		|	EmployeeFiring.Ref = &Ref
		|	AND ISNULL(R9541T_VacationUsageBalance.DaysBalance, 0) + ISNULL(R9541T_VacationUsageTurnovers.DaysExpense, 0) <> 0";
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