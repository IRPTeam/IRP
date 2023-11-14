
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