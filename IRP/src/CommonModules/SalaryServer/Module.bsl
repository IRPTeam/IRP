
Function GetEmployeeInfo(Ref, Date,  Company, Employee) Export
//	Return ServerReuse.GetEmployeeInfo(Ref, Date, Company, Employee);
	Return _GetEmployeeInfo(Ref, Date, Company, Employee);	
EndFunction

Function _GetEmployeeInfo(Ref, Date,  Company, Employee) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9510S_StaffingSliceLast.Branch,
	|	T9510S_StaffingSliceLast.Position,
	|	T9510S_StaffingSliceLast.EmployeeSchedule,
	|	T9510S_StaffingSliceLast.ProfitLossCenter
	|FROM
	|	InformationRegister.T9510S_Staffing.SliceLast(&Period, Company = &Company
	|	AND Employee = &Employee) AS T9510S_StaffingSliceLast
	|WHERE
	|	NOT T9510S_StaffingSliceLast.Fired";
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Company"  , Company);
	Query.SetParameter("Employee" , Employee);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Branch, Position, EmployeeSchedule, ProfitLossCenter");
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
	EndIf;
	Return Result;
EndFunction

Function GetAccualAndDeductionValue(Date, Employee, Position, AccualOrDeductionType) Export
//	Return ServerReuse.GetAccualAndDeductionValue(Date, Employee, Position, AccualOrDeductionType);
	Return _GetAccualAndDeductionValue(Date, Employee, Position, AccualOrDeductionType);
EndFunction

Function _GetAccualAndDeductionValue(Date, Employee, Position, AccualOrDeductionType) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	1 AS Prority,
		|	T9500S_ByEmployee.Value
		|INTO tmp
		|FROM
		|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(ENDOFPERIOD(&Date, DAY),
		|		EmployeeOrPosition = &Employee
		|	AND AccualOrDeductionType = &AccualOrDeductionType) AS T9500S_ByEmployee
		|
		|UNION ALL
		|
		|SELECT
		|	2,
		|	T9500S_ByPosition.Value
		|FROM
		|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(ENDOFPERIOD(&Date, DAY),
		|		EmployeeOrPosition = &Position
		|	AND AccualOrDeductionType = &AccualOrDeductionType) AS T9500S_ByPosition
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT TOP 1
		|	tmp.Prority AS Prority,
		|	tmp.Value
		|FROM
		|	tmp AS tmp
		|
		|ORDER BY
		|	Prority";
	
	Query.SetParameter("Date", Date);
	Query.SetParameter("Position", Position);
	Query.SetParameter("Employee", Employee);
	Query.SetParameter("AccualOrDeductionType", AccualOrDeductionType);
	
	QueryResult = Query.Execute();
	
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		Return QuerySelection.Value;
	EndIf;
	Return 0;
EndFunction

Function GetWorkDays(BeginDate, EndDate, AccrualAndDeductionType) Export
//	Return ServerReuse.GetWorkDays(BeginDate, EndDate, AccrualAndDeductionType);
	Return _GetWorkDays(BeginDate, EndDate, AccrualAndDeductionType);
EndFunction

Function _GetWorkDays(BeginDate, EndDate, AccrualAndDeductionType) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9530S_WorkDays.CountDays
	|FROM
	|	InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|WHERE
	|	BEGINOFPERIOD(T9530S_WorkDays.BeginDate, DAY) <= BEGINOFPERIOD(&BeginDate, DAY)
	|	AND ENDOFPERIOD(T9530S_WorkDays.EndDate, DAY) >= ENDOFPERIOD(&EndDate, DAY)
	|	AND T9530S_WorkDays.AccrualAndDeductionType = &AccrualAndDeductionType";
	Query.SetParameter("BeginDate"   , BeginDate);		
	Query.SetParameter("EndDate" , EndDate);		
	Query.SetParameter("AccrualAndDeductionType", AccrualAndDeductionType);	
	QueryResult = Query.Execute();
	
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		Return QuerySelection.CountDays;
	EndIf;
	Return 0;	
EndFunction

Function GetCountDays(Date, Company, Branch, Employee, Position, AccrualAndDeductionType) Export
//	Return ServerReuse.GetCountDays(Date, Company, Branch, Employee, Position, AccrualAndDeductionType);
	Return _GetCountDays(Date, Company, Branch, Employee, Position, AccrualAndDeductionType);
EndFunction

Function _GetCountDays(Date, Company, Branch, Employee, Position, AccrualAndDeductionType) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	COUNT(T9520S_TimeSheetInfo.AccrualAndDeductionType) AS CountDays
	|FROM
	|	InformationRegister.T9520S_TimeSheetInfo AS T9520S_TimeSheetInfo
	|WHERE
	|	T9520S_TimeSheetInfo.Company = &Company
	|	AND T9520S_TimeSheetInfo.Branch = &Branch
	|	AND BEGINOFPERIOD(T9520S_TimeSheetInfo.Date, DAY) = &Date
	|	AND T9520S_TimeSheetInfo.Employee = &Employee
	|	AND T9520S_TimeSheetInfo.Position = &Position
	|	AND T9520S_TimeSheetInfo.AccrualAndDeductionType = &AccrualAndDeductionType";
	
	Query.SetParameter("Date"     , BegOfDay(Date));		
	Query.SetParameter("Company"  , Company);		
	Query.SetParameter("Branch"   , Branch);		
	Query.SetParameter("Employee" , Employee);		
	Query.SetParameter("Position" , Position);		
	Query.SetParameter("AccrualAndDeductionType", AccrualAndDeductionType);	
	QueryResult = Query.Execute();
	
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() And ValueIsFilled(QuerySelection.CountDays) Then
		Return QuerySelection.CountDays;
	EndIf;
	Return 0;
EndFunction
