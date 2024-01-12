
Function GetEmployeeInfo(Ref, Date,  Company, Employee) Export
	Return ServerReuse.GetEmployeeInfo(Ref, Date, Company, Employee);
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

Function GetSalaryValue(Ref, Date, Position, AccrualType) Export
	Return ServerReuse.GetSalaryValue(Ref, Date, Position, AccrualType);
EndFunction

Function _GetSalaryValue(Ref, Date, Position, AccrualType) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9500S_AccrualAndDeductionValuesSliceLast.Value
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(&Period, EmployeeOrPosition = &Position
	|	AND AccualOrDeductionType = &AccrualType) AS T9500S_AccrualAndDeductionValuesSliceLast
	|WHERE
	|	NOT T9500S_AccrualAndDeductionValuesSliceLast.NotActual";
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period"   , Period);
	Query.SetParameter("Position"  , Position);
	Query.SetParameter("AccrualType"  , AccrualType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If QuerySelection.Next() Then
		Return QuerySelection.Value;
	EndIf;
	Return 0;
EndFunction	
	
Function GetSalaryByPositionOrEmployee(Ref, Date, Employee, Position, AccrualType) Export
	Return ServerReuse.GetSalaryByPositionOrEmployee(Ref, Date, Employee, Position, AccrualType);
EndFunction

Function _GetSalaryByPositionOrEmployee(Ref, Date, Employee, Position, AccrualType) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9500S_AccrualAndDeductionValuesSliceLast.Value
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(&Period, EmployeeOrPosition = &Employee
	|	AND AccualOrDeductionType = &AccrualType) AS T9500S_AccrualAndDeductionValuesSliceLast
	|WHERE
	|	NOT T9500S_AccrualAndDeductionValuesSliceLast.NotActual
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T9500S_AccrualAndDeductionValuesSliceLast.Value
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(&Period, EmployeeOrPosition = &Position
	|	AND AccualOrDeductionType = &AccrualType) AS T9500S_AccrualAndDeductionValuesSliceLast
	|WHERE
	|	NOT T9500S_AccrualAndDeductionValuesSliceLast.NotActual";
	
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period"    , Period);
	Query.SetParameter("Employee"  , Employee);
	Query.SetParameter("Position"  , Position);
	Query.SetParameter("AccrualType"  , AccrualType);
	QueryResults = Query.ExecuteBatch();
	QuerySelection_PersonalSalary = QueryResults[0].Select();
	QuerySelection_Salary = QueryResults[1].Select();
		
	Result = New Structure("Salary, PersonalSalary", 0, 0);
	
	If QuerySelection_PersonalSalary.Next() Then
		Result.PersonalSalary = QuerySelection_PersonalSalary.Value;
	EndIf;
	
	If QuerySelection_Salary.Next() Then
		Result.Salary = QuerySelection_Salary.Value;
	EndIf;
	Return Result;
EndFunction

Function GetAccrualTypeByPositionOrEmployee(Ref, Date, Employee, Position) Export
	Return ServerReuse.GetAccrualTypeByPositionOrEmployee(Ref, Date, Employee, Position);
EndFunction

Function _GetAccrualTypeByPositionOrEmployee(Ref, Date, Employee, Position) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	T9500S_AccrualAndDeductionValuesSliceLast.AccualOrDeductionType AS AccrualType
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(&Period, EmployeeOrPosition = &Employee) AS
	|		T9500S_AccrualAndDeductionValuesSliceLast
	|WHERE
	|	NOT T9500S_AccrualAndDeductionValuesSliceLast.NotActual
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T9500S_AccrualAndDeductionValuesSliceLast.AccualOrDeductionType AS AccrualType
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(&Period, EmployeeOrPosition = &Position) AS
	|		T9500S_AccrualAndDeductionValuesSliceLast
	|WHERE
	|	NOT T9500S_AccrualAndDeductionValuesSliceLast.NotActual";
	
	Period = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period"    , Period);
	Query.SetParameter("Employee"  , Employee);
	Query.SetParameter("Position"  , Position);
	QueryResults = Query.ExecuteBatch();
	
	QuerySelection_PersonalAccrual = QueryResults[0].Select();
	QuerySelection_Accrual = QueryResults[1].Select();
			
	If QuerySelection_PersonalAccrual.Next() Then
		Return QuerySelection_PersonalAccrual.AccrualType;
	EndIf;
	
	If QuerySelection_Accrual.Next() Then
		Return QuerySelection_Accrual.AccrualType;
	EndIf;
	
	Return Undefined;
EndFunction
