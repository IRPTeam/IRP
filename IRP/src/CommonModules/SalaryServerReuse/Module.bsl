
Function GetAccualAndDeductionValue(Date, Employee, Position, AccualOrDeductionType) Export
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
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9530S_WorkDays.CountDays
	|FROM
	|	InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|WHERE
	|	T9530S_WorkDays.BeginDate <= BEGINOFPERIOD(&BeginDate, DAY)
	|	AND T9530S_WorkDays.EndDate >= ENDOFPERIOD(&EndDate, DAY)
	|	AND T9530S_WorkDays.AccrualAndDeductionType = &AccrualAndDeductionType";
	Query.SetParameter("BeginDate"   , BeginDate);		
	Query.SetParameter("EndDateDate" , EndDate);		
	Query.SetParameter("AccrualAndDeductionType", AccrualAndDeductionType);	
		QueryResult = Query.Execute();
	
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		Return QuerySelection.CountDays;
	EndIf;
	Return 0;	
EndFunction