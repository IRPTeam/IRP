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
	RefData = CommonFunctionsServer.GetAttributesFromRef(Ref, "Company, EndDate");
	
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	StrParams.Insert("Company", RefData.Company);
	StrParams.Insert("Period", EndOfDay(RefData.EndDate));
	StrParams.Insert("BeforEnd", New Boundary(EndOfDay(RefData.EndDate), BoundaryType.Excluding));
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R9541T_VacationUsage());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

#EndRegion

#Region Posting_MainTables

Function R9541T_VacationUsage()
	
	Return
		"SELECT
		|	T9510S_StaffingSliceLast.Company,
		|	T9510S_StaffingSliceLast.Employee
		|INTO tmpStaff
		|FROM
		|	InformationRegister.T9510S_Staffing.SliceLast(&Period, Company = &Company) AS T9510S_StaffingSliceLast
		|WHERE
		|	NOT T9510S_StaffingSliceLast.Fired
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmpStaff.Company,
		|	tmpStaff.Employee,
		|	CASE
		|		WHEN NOT EmployeeCompanyLimits.DayLimit IS NULL
		|			THEN EmployeeCompanyLimits.DayLimit
		|		WHEN NOT EmployeeLimits.DayLimit IS NULL
		|			THEN EmployeeLimits.DayLimit
		|		WHEN NOT CompanyLimits.DayLimit IS NULL
		|			THEN CompanyLimits.DayLimit
		|		WHEN NOT AllLimits.DayLimit IS NULL
		|			THEN AllLimits.DayLimit
		|		ELSE 0
		|	END AS DayLimit
		|INTO tmpDayLimits
		|FROM
		|	tmpStaff AS tmpStaff
		|		LEFT JOIN InformationRegister.T9545S_VacationDaysLimits.SliceLast(&BeforEnd,) AS AllLimits
		|		ON AllLimits.Company = VALUE(Catalog.Companies.EmptyRef)
		|		AND AllLimits.Employee = VALUE(Catalog.Partners.EmptyRef)
		|		LEFT JOIN InformationRegister.T9545S_VacationDaysLimits.SliceLast(&BeforEnd,) AS CompanyLimits
		|		ON tmpStaff.Company = CompanyLimits.Company
		|		AND CompanyLimits.Employee = VALUE(Catalog.Partners.EmptyRef)
		|		LEFT JOIN InformationRegister.T9545S_VacationDaysLimits.SliceLast(&BeforEnd,) AS EmployeeLimits
		|		ON tmpStaff.Employee = EmployeeLimits.Employee
		|		AND EmployeeLimits.Company = VALUE(Catalog.Companies.EmptyRef)
		|		LEFT JOIN InformationRegister.T9545S_VacationDaysLimits.SliceLast(&BeforEnd,) AS EmployeeCompanyLimits
		|		ON tmpStaff.Company = EmployeeCompanyLimits.Company
		|		AND tmpStaff.Employee = EmployeeCompanyLimits.Employee
		|WHERE
		|	CASE
		|		WHEN NOT EmployeeCompanyLimits.DayLimit IS NULL
		|			THEN EmployeeCompanyLimits.DayLimit
		|		WHEN NOT EmployeeLimits.DayLimit IS NULL
		|			THEN EmployeeLimits.DayLimit
		|		WHEN NOT CompanyLimits.DayLimit IS NULL
		|			THEN CompanyLimits.DayLimit
		|		WHEN NOT AllLimits.DayLimit IS NULL
		|			THEN AllLimits.DayLimit
		|		ELSE 0
		|	END > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmpDayLimits.Company,
		|	tmpDayLimits.Employee,
		|	tmpDayLimits.DayLimit,
		|	INT((DATEDIFF(BEGINOFPERIOD(&Period, Year), &Period, DAY) + 1) / (DATEDIFF(BEGINOFPERIOD(&Period, Year),
		|		ENDOFPERIOD(&Period, Year), DAY) + 1) * tmpDayLimits.DayLimit) - ISNULL(R9541T_VacationUsageTurnovers.DaysReceipt,
		|		0) AS Days
		|INTO tmpDeservedDays
		|FROM
		|	tmpDayLimits AS tmpDayLimits
		|		LEFT JOIN AccumulationRegister.R9541T_VacationUsage.Turnovers(BEGINOFPERIOD(&Period, Year), &BeforEnd,,) AS
		|			R9541T_VacationUsageTurnovers
		|		ON tmpDayLimits.Company = R9541T_VacationUsageTurnovers.Company
		|		AND tmpDayLimits.Employee = R9541T_VacationUsageTurnovers.Employee
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	&Period AS Period,
		|	tmpDeservedDays.Company,
		|	tmpDeservedDays.Employee,
		|	tmpDeservedDays.Days
		|INTO R9541T_VacationUsage
		|FROM
		|	tmpDeservedDays AS tmpDeservedDays
		|WHERE
		|	tmpDeservedDays.Days > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP tmpStaff
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP tmpDayLimits
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP tmpDeservedDays";
	
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
	Return AccessKeyMap;
EndFunction

#EndRegion