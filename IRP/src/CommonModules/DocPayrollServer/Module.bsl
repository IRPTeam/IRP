#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	AccountingServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	AccountingServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("PaymentPeriod");
	AttributesArray.Add("BeginDate");
	AttributesArray.Add("EndDate");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

Function GetCashAdvanceDeduction(Parameters) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R3027B.Partner AS Employee,
	|	R3027B.Agreement AS Agreement,
	|	R3027B.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3027B_EmployeeCashAdvance.Balance(&Boundary, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS R3027B";
	
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Branch", Parameters.Branch);
	Query.SetParameter("Currency", Parameters.Currency);
	If ValueIsFilled(Parameters.Ref) Then
		Query.SetParameter("Boundary", New Boundary(New PointInTime(Parameters.EndDate, Parameters.Ref), BoundaryType.Excluding));
	Else
		Query.SetParameter("Boundary", Parameters.EndDate);
	EndIf;
	
	ResultTable = Query.Execute().Unload();
	
	GroupColumn = "Employee, Agreement";
	SumColumn = "Amount";
	
	ResultTable.GroupBy(GroupColumn, SumColumn);
	ResultTable.Sort("Employee");
	
	Return New Structure("Table, GroupColumn, SumColumn", ResultTable, GroupColumn, SumColumn);
EndFunction

Function GetPayrolls_Deduction(Parameters) Export
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Employee");
	ResultTable.Columns.Add("Position");
	ResultTable.Columns.Add("ProfitLossCenter");
	ResultTable.Columns.Add(Parameters.TypeColumnName);
	ResultTable.Columns.Add("Amount");
	ResultTable.Columns.Add("TotalVacationDays");
	ResultTable.Columns.Add("PaidVacationDays");
	ResultTable.Columns.Add("TotalSickLeaveDays");
	ResultTable.Columns.Add("PaidSickLeaveDays");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R9570T_AdditionalDeductionTurnovers.Employee,
	|	R9570T_AdditionalDeductionTurnovers.Position,
	|	R9570T_AdditionalDeductionTurnovers.DeductionType,
	|	R9570T_AdditionalDeductionTurnovers.ExpenseType,
	|	R9570T_AdditionalDeductionTurnovers.ProfitLossCenter,
	|	R9570T_AdditionalDeductionTurnovers.AmountTurnover AS Amount
	|FROM
	|	AccumulationRegister.R9570T_AdditionalDeduction.Turnovers(BEGINOFPERIOD(&BeginDate, DAY), ENDOFPERIOD(&EndDate,
	|		DAY),, Company = &Company
	|	AND Branch = &Branch
	|	AND DeductionType.CalculationType = &CalculationType) AS R9570T_AdditionalDeductionTurnovers";
	Query.SetParameter("BeginDate", Parameters.BeginDate);
	Query.SetParameter("EndDate", Parameters.EndDate);
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Branch", Parameters.Branch);
	Query.SetParameter("CalculationType", Parameters.CalculationType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		FillPropertyValues(ResultTable.Add(), QuerySelection);
	EndDo;
	
	GroupColumn = "Employee, Position, ProfitLossCenter, " + Parameters.TypeColumnName;
	SumColumn = "Amount, TotalVacationDays, PaidVacationDays, TotalSickLeaveDays, PaidSickLeaveDays";
	
	ResultTable.GroupBy(GroupColumn, SumColumn);
	ResultTable.Sort("Employee, Position, " + Parameters.TypeColumnName);
	
	Return New Structure("Table, GroupColumn, SumColumn", ResultTable, GroupColumn, SumColumn);
EndFunction

Function GetPayrolls_Accrual(Parameters) Export
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Employee");
	ResultTable.Columns.Add("Position");
	ResultTable.Columns.Add("ProfitLossCenter");
	ResultTable.Columns.Add(Parameters.TypeColumnName);
	ResultTable.Columns.Add("Amount");
	ResultTable.Columns.Add("TotalVacationDays");
	ResultTable.Columns.Add("PaidVacationDays");
	ResultTable.Columns.Add("TotalSickLeaveDays");
	ResultTable.Columns.Add("PaidSickLeaveDays");
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9520S_TimeSheetInfo.Date,
	|	T9520S_TimeSheetInfo.Company,
	|	T9520S_TimeSheetInfo.Employee,
	|	T9520S_TimeSheetInfo.Position,
	|	T9520S_TimeSheetInfo.ProfitLossCenter,
	|	T9520S_TimeSheetInfo.EmployeeSchedule,
	|	T9520S_TimeSheetInfo.CountDaysHours,
	|	T9520S_TimeSheetInfo.ActuallyDaysHours,
	|	T9520S_TimeSheetInfo.IsVacation,
	|	T9520S_TimeSheetInfo.IsSickLeave,
	|	FALSE AS IsPaidVacation,
	|	FALSE AS IsPaidSickLeave,
	|	0 AS TotalVacationDays,
	|	0 AS PaidVacationDays,
	|	0 AS TotalSickLeaveDays,
	|	0 AS PaidSickLeaveDays,
	|	VALUE(Catalog.AccrualAndDeductionTypes.EmptyRef) AS Accrual
	|FROM
	|	InformationRegister.T9520S_TimeSheetInfo AS T9520S_TimeSheetInfo
	|WHERE
	|	T9520S_TimeSheetInfo.Date BETWEEN BEGINOFPERIOD(&BeginDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND T9520S_TimeSheetInfo.Company = &Company
	|	AND T9520S_TimeSheetInfo.Branch = &Branch";
	
	Query.SetParameter("BeginDate", Parameters.BeginDate);
	Query.SetParameter("EndDate"  , Parameters.EndDate);
	Query.SetParameter("Company"  , Parameters.Company);
	Query.SetParameter("Branch"   , Parameters.Branch);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Settings = GetAccrualSettings(Parameters.Company);
	
	// Vacation
	VacationEmployeeTable = QueryTable.Copy(New Structure("IsVacation", True));
	VacationEmployeeTable.GroupBy("Company, Date, Employee, IsPaidVacation");
	PaidVacationTable = CalculateDaysForPaid_Vacation(VacationEmployeeTable, Parameters, Settings);
	
	For Each VacationRow In PaidVacationTable Do
		Filter = New Structure();
		Filter.Insert("Company"  , VacationRow.Company);
		Filter.Insert("Date"     , VacationRow.Date);
		Filter.Insert("Employee" , VacationRow.Employee);
		Rows = QueryTable.FindRows(Filter);
		For Each Row In Rows Do
			Row.TotalVacationDays = 1;
			Row.PaidVacationDays = 1;
			
			If Not VacationRow.IsPaidVacation Then
				Row.ActuallyDaysHours = 0;
				Row.PaidVacationDays  = 0;
			EndIf;
			
		EndDo;
	EndDo;
	
	// Sick leave
	SickLeaveEmployeeTable = QueryTable.Copy(New Structure("IsSickLeave", True));
	
	ArrayForDelete = New Array();
	For Each SickLeaveRow In SickLeaveEmployeeTable Do
		If Not ValueIsFilled(SickLeaveRow.CountDaysHours) Then
			ArrayForDelete.Add(SickLeaveRow);
		EndIf;
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		SickLeaveEmployeeTable.Delete(ItemForDelete);
	EndDo;
	
	SickLeaveEmployeeTable.GroupBy("Company, Date, Employee, IsPaidSickLeave");
	PaidSickLeaveTable = CalculateDaysForPaid_SickLeave(SickLeaveEmployeeTable, Parameters, Settings);
	
	For Each SickLeaveRow In PaidSickLeaveTable Do
		Filter = New Structure();
		Filter.Insert("Company"  , SickLeaveRow.Company);
		Filter.Insert("Date"     , SickLeaveRow.Date);
		Filter.Insert("Employee" , SickLeaveRow.Employee);
		Rows = QueryTable.FindRows(Filter);
		For Each Row In Rows Do
			Row.TotalSickLeaveDays = 1;
			Row.PaidSickLeaveDays = 1;
			
			If Not SickLeaveRow.IsPaidSickLeave Then
				Row.ActuallyDaysHours = 0;
				Row.PaidSickLeaveDays  = 0;
			EndIf;
			
		EndDo;
	EndDo;
	
	AccrualValues = QueryTable.CopyColumns("Date, Employee, EmployeeSchedule, Position, ProfitLossCenter, ActuallyDaysHours, Accrual");
	AccrualValues.Columns.Add("Value", New TypeDescription("Number"));
	AccrualValues.Columns.Add("Period", New TypeDescription("Date"));
	
	ArrayForDelete = New Array();
	
	For Each Row In QueryTable Do
		NewAccrualValue = AccrualValues.Add();
		FillPropertyValues(NewAccrualValue, Row);
		AccrualValue = GetAccrualByEmployeeOrPosition(Parameters, Row);
		If AccrualValue <> Undefined And ValueIsFilled(AccrualValue.Accrual) Then
			NewAccrualValue.Accrual = AccrualValue.Accrual; 	
			NewAccrualValue.Value   = AccrualValue.Value;
			NewAccrualValue.Period  = AccrualValue.Period;
			
			Row.Accrual = AccrualValue.Accrual;
		Else
			ArrayForDelete.Add(Row);
		EndIf; 	
	EndDo;
	
	For Each ItemForDelete In ArrayForDelete Do
		QueryTable.Delete(ItemForDelete);
	EndDo;
	
	CalculatedSalary = _MonthlySalary(AccrualValues, Parameters.BeginDate, Parameters.EndDate);
		
	For Each Row In QueryTable Do
		NewRow = ResultTable.Add();
		FillPropertyValues(NewRow, Row);
		NewRow[Parameters.TypeColumnName] = Row.Accrual;
				
		If Not ValueIsFilled(NewRow.Amount) Then
			NewRow.Amount = 0;
		EndIf;
	EndDo;
		
	GroupColumn = "Employee, Position, ProfitLossCenter, " + Parameters.TypeColumnName;
	SumColumn = "Amount, TotalVacationDays, PaidVacationDays, TotalSickLeaveDays, PaidSickLeaveDays";
	
	ResultTable.GroupBy(GroupColumn, SumColumn);
	
	For Each Row In ResultTable Do
		Filter = New Structure();
		Filter.Insert("Employee"         , Row.Employee);
		Filter.Insert("Position"         , Row.Position);
		Filter.Insert("ProfitLossCenter" , Row.ProfitLossCenter);
		Filter.Insert("Accrual"          , Row[Parameters.TypeColumnName]);
		
		SalaryValue = CalculatedSalary.Copy(Filter);
		SalaryValue.GroupBy(,"MoneyForPaid");
		If SalaryValue.Count() Then
			Row.Amount = Row.Amount + SalaryValue[0].MoneyForPaid;
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R9560T_AdditionalAccrualTurnovers.Employee,
	|	R9560T_AdditionalAccrualTurnovers.Position,
	|	R9560T_AdditionalAccrualTurnovers.AccrualType,
	|	R9560T_AdditionalAccrualTurnovers.ExpenseType,
	|	R9560T_AdditionalAccrualTurnovers.ProfitLossCenter,
	|	R9560T_AdditionalAccrualTurnovers.AmountTurnover AS Amount
	|FROM
	|	AccumulationRegister.R9560T_AdditionalAccrual.Turnovers(BEGINOFPERIOD(&BeginDate, DAY), ENDOFPERIOD(&EndDate, DAY),,
	|		Company = &Company
	|	AND Branch = &Branch
	|	AND AccrualType.CalculationType = &CalculationType) AS R9560T_AdditionalAccrualTurnovers";
	Query.SetParameter("BeginDate", Parameters.BeginDate);
	Query.SetParameter("EndDate", Parameters.EndDate);
	Query.SetParameter("Company", Parameters.Company);
	Query.SetParameter("Branch", Parameters.Branch);
	Query.SetParameter("CalculationType", Parameters.CalculationType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		FillPropertyValues(ResultTable.Add(), QuerySelection);
	EndDo;
	
	ResultTable.GroupBy(GroupColumn, SumColumn);
	ResultTable.Sort("Employee, Position, " + Parameters.TypeColumnName);
	
	Return New Structure("Table, GroupColumn, SumColumn", ResultTable, GroupColumn, SumColumn);
EndFunction

Function CalculateDaysForPaid_Vacation(VacationEmployeeTable, Parameters, Settings)
	Return SalaryPrivileged.CalculateDaysForPaid_Vacation(VacationEmployeeTable, Parameters, Settings);
EndFunction
	
Function _CalculateDaysForPaid_Vacation(VacationEmployeeTable, Parameters, Settings) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	tmp.Company,
	|	tmp.Date,
	|	tmp.Employee
	|INTO tmp
	|FROM
	|	&tmp AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Employee,
	|	COUNT(tmp.Date) AS TotalDays,
	|	SUM(ISNULL(R9541T_VacationUsage.Days, 0)) AS PaidDays
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN AccumulationRegister.R9541T_VacationUsage AS R9541T_VacationUsage
	|		ON tmp.Company = R9541T_VacationUsage.Company
	|		AND tmp.Employee = R9541T_VacationUsage.Employee
	|		AND tmp.Date = R9541T_VacationUsage.Period
	|		AND R9541T_VacationUsage.Active
	|		AND R9541T_VacationUsage.Recorder REFS Document.EmployeeVacation
	|GROUP BY
	|	tmp.Company,
	|	tmp.Employee";
	Query.SetParameter("tmp", VacationEmployeeTable);
	
	DaysTable = Query.Execute().Unload();
	For Each TotalRow In DaysTable Do
		Filter = New Structure();
		Filter.Insert("Company"  , TotalRow.Company);
		Filter.Insert("Employee" , TotalRow.Employee);
		EmployeeRows = VacationEmployeeTable.FindRows(Filter);
						
		CalculatePaidDays(0, TotalRow.PaidDays, EmployeeRows, "IsPaidVacation");
	EndDo;
	
	Return VacationEmployeeTable;
EndFunction	

Function CalculateDaysForPaid_SickLeave(SickLeaveEmployeeTable, Parameters, Settings)
	Return SalaryPrivileged.CalculateDaysForPaid_SickLeave(SickLeaveEmployeeTable, Parameters, Settings);
EndFunction
	
Function _CalculateDaysForPaid_SickLeave(SickLeaveEmployeeTable, Parameters, Settings) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	tmp.Company,
	|	tmp.Date,
	|	tmp.Employee
	|INTO tmp
	|FROM
	|	&tmp AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R9555T_PaidSickLeavesTurnovers.Company,
	|	R9555T_PaidSickLeavesTurnovers.Employee,
	|	SUM(R9555T_PaidSickLeavesTurnovers.PaidTurnover) AS PaidTurnover
	|FROM
	|	AccumulationRegister.R9555T_PaidSickLeaves.Turnovers(BEGINOFPERIOD(&EndDate, MONTH), ENDOFPERIOD(&EndDate, MONTH),
	|		Recorder, (Company, Employee) IN
	|		(SELECT
	|			tmp.Company,
	|			tmp.Employee
	|		FROM
	|			tmp AS tmp)) AS R9555T_PaidSickLeavesTurnovers
	|WHERE
	|	R9555T_PaidSickLeavesTurnovers.Recorder <> &Recorder
	|GROUP BY
	|	R9555T_PaidSickLeavesTurnovers.Company,
	|	R9555T_PaidSickLeavesTurnovers.Employee
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Employee,
	|	COUNT(tmp.Date) AS CountDates
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.Employee";
	Query.SetParameter("tmp", SickLeaveEmployeeTable);
	Query.SetParameter("EndDate", Parameters.EndDate);
	Query.SetParameter("Recorder", Parameters.Ref);
	
	QueryResults = Query.ExecuteBatch();
	PaidDays = QueryResults[1].Unload();
	TotalDays = QueryResults[2].Unload();
	
	For Each TotalRow In TotalDays Do
		Filter = New Structure();
		Filter.Insert("Company"  , TotalRow.Company);
		Filter.Insert("Employee" , TotalRow.Employee);
		
		PaidRows = PaidDays.FindRows(Filter);
		_PaidDays = 0;
		For Each PaidRow In PaidRows Do
			_PaidDays = _PaidDays + PaidRow.PaidTurnover;
		EndDo;
		
		EmployeeRows = SickLeaveEmployeeTable.FindRows(Filter);
						
		CalculatePaidDays(_PaidDays, Settings.SickLeaveDays, EmployeeRows, "IsPaidSickLeave");
	EndDo;
	
	Return SickLeaveEmployeeTable;
EndFunction	

Procedure CalculatePaidDays(_PaidDays, _TotalDays, EmployeeRows, ColumnName)
	PaidDays = _PaidDays;
	index = 0;
	While (PaidDays < _TotalDays) Do
		If index < EmployeeRows.Count() Then
			EmployeeRows[index][ColumnName] = True;
			PaidDays = PaidDays + 1;
		Else
			Break;
		EndIf;
		index = index + 1;
	EndDo;
EndProcedure		

Function GetAccrualSettings(Company)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Companies.SalaryAccrualVacation,
	|	Companies.SalaryMaxDaysVacation,
	|	Companies.SalaryAccrualSickLeave,
	|	Companies.SalaryMaxDaysSickLeave
	|FROM
	|	Catalog.Companies AS Companies
	|WHERE
	|	Companies.Ref = &Ref";
	Query.SetParameter("Ref", Company);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Vacation, VacationDays, SickLeave, SickLeaveDays",
		Undefined, 0, Undefined, 0);
	
	If QuerySelection.Next() Then
		Result.Vacation      = QuerySelection.SalaryAccrualVacation;
		Result.VacationDays  = QuerySelection.SalaryMaxDaysVacation;
		Result.SickLeave     = QuerySelection.SalaryAccrualSickLeave;
		Result.SickLeaveDays = QuerySelection.SalaryMaxDaysSickLeave;
	EndIf;
	
	Return Result;
EndFunction

Function GetAccrualByEmployeeOrPosition(Parameters, TableRow)
	ByEmployee = GetAccrualValue(Parameters, TableRow.Employee, TableRow.Date);
	If ValueIsFilled(ByEmployee.Accrual) Then
		Return ByEmployee;
	Else
		ByPosition = GetAccrualValue(Parameters, TableRow.Position, TableRow.Date);
		If ValueIsFilled(ByPosition.Accrual) Then
			Return ByPosition;
		EndIf;
	EndIf;
EndFunction	

Function GetAccrualValue(Parameters, EmployeeOrPosition, Date)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AccrualValues.AccualOrDeductionType AS Accrual,
	|	AccrualValues.Value,
	|	AccrualValues.Period
	|FROM
	|	InformationRegister.T9500S_AccrualAndDeductionValues.SliceLast(ENDOFPERIOD(&Date, DAY),
	|		EmployeeOrPosition = &EmployeeOrPosition
	|	AND AccualOrDeductionType.CalculationType = &CalculationType) AS AccrualValues
	|WHERE
	|	NOT AccrualValues.NotActual";
	Query.SetParameter("Date", Date);
	Query.SetParameter("EmployeeOrPosition", EmployeeOrPosition);
	Query.SetParameter("CalculationType", Parameters.CalculationType);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure("Accrual, Value, Period", Undefined, 0, Undefined);
	If QuerySelection.Next() Then
		Result.Accrual = QuerySelection.Accrual;
		Result.Value   = QuerySelection.Value;
		Result.Period  = QuerySelection.Period;
	EndIf;
	
	Return Result;
EndFUnction
		
Function _MonthlySalary(AccrualValues, BeginDate, EndDate)	
	tmp1 = AccrualValues.Copy();
	tmp1.GroupBy("EmployeeSchedule");
	
	tmp_days = AccrualValues.CopyColumns();
	tmp_days.Columns.Add("TotalFullActuallyDays", New TypeDescription("Number"));
	
	tmp_months = AccrualValues.CopyColumns();
	
	For Each Row In AccrualValues Do
		_Periodicity = Row.Accrual.Periodicity;
		If  _Periodicity = Enums.AccrualAndDeductionPeriodicity.ByDay Then
			If ValueIsFilled(Row.ActuallyDaysHours) Then
				new_row = tmp_days.Add();
				FillPropertyValues(new_row, Row);
				new_row.TotalFullActuallyDays = 1;
			EndIf;
		ElsIf _Periodicity = Enums.AccrualAndDeductionPeriodicity.ByPeriod Then
			FillPropertyValues(tmp_months.Add(), Row);
		EndIf;
	EndDo;
	tmp_days.GroupBy("Employee, EmployeeSchedule, Position, ProfitLossCenter, Accrual, Period", "TotalFullActuallyDays, Value, ActuallyDaysHours");
	tmp_months.GroupBy("Employee, EmployeeSchedule, Position, ProfitLossCenter, Accrual, Value, Period", "ActuallyDaysHours");
	
	tmp2 = AccrualValues.CopyColumns();
	tmp2.Columns.Add("TotalFullActuallyDays", New TypeDescription("Number"));
	
	For Each Row In tmp_days Do
		FillPropertyValues(tmp2.Add(), Row);
	EndDo;	
	For Each Row In tmp_months Do
		FillPropertyValues(tmp2.Add(), Row);
	EndDo;
	
	// total
	tmp2.Columns.Add("EndDate", New TypeDescription("Date"));
	tmp2.Sort("Period");
	
	tmp3 = AccrualValues.Copy();
	tmp3.GroupBy("Employee, EmployeeSchedule, Position, ProfitLossCenter, Accrual");
	
	For Each Row In tmp3 Do
		Filter = New Structure("Employee, EmployeeSchedule, Position, ProfitLossCenter, Accrual");
		FillPropertyValues(Filter, Row);
		Rows = tmp2.FindRows(Filter);
		LastRow = Undefined;
		For Each Row2 In Rows Do
			If LastRow <> Undefined Then
				LastRow.EndDate = Row2.Period;
			EndIf;
			LastRow = Row2;
		EndDo;
		If LastRow <> Undefined Then
			LastRow.EndDate = EndDate;
		EndIf;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	tmp1.EmployeeSchedule
	|INTO tmp1
	|FROM
	|	&tmp1 AS tmp1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.Employee,
	|	tmp2.EmployeeSchedule,
	|	tmp2.Position,
	|	tmp2.ProfitLossCenter,
	|	tmp2.Accrual,
	|	tmp2.Value,
	|	tmp2.Period,
	|	tmp2.EndDate,
	|	tmp2.ActuallyDaysHours,
	|	tmp2.TotalFullActuallyDays
	|INTO tmp2
	|FROM
	|	&tmp2 AS tmp2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp1.EmployeeSchedule AS EmployeeSchedule,
	|	T9530S_WorkDays.Date AS Date,
	|	SUM(ISNULL(T9530S_WorkDays.CountDaysHours, 0)) AS CountDaysHours
	|INTO TotalBySchedule
	|FROM
	|	tmp1 AS tmp1
	|		LEFT JOIN InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|		ON tmp1.EmployeeSchedule = T9530S_WorkDays.EmployeeSchedule
	|WHERE
	|	T9530S_WorkDays.Date BETWEEN BEGINOFPERIOD(&BeginDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND T9530S_WorkDays.EmployeeSchedule IN
	|		(SELECT
	|			tmp1.EmployeeSchedule
	|		FROM
	|			tmp1 AS tmp1)
	|GROUP BY
	|	tmp1.EmployeeSchedule,
	|	T9530S_WorkDays.Date
	|;
	|SELECT
	|	T9530S_WorkDays.EmployeeSchedule AS EmployeeSchedule,
	|	SUM(ISNULL(T9530S_WorkDays.CountDaysHours, 0)) AS TotalCountDaysHours,
	|	SUM( case when ISNULL(T9530S_WorkDays.CountDaysHours, 0) = 0 then 0 else 1 end) AS TotalFullDays
	|INTO TotalBySchedule2
	|FROM
	|	InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|WHERE
	|	T9530S_WorkDays.Date BETWEEN BEGINOFPERIOD(&BeginDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND T9530S_WorkDays.EmployeeSchedule IN
	|		(SELECT
	|			tmp1.EmployeeSchedule
	|		FROM
	|			tmp1 AS tmp1)
	|GROUP BY
	|	T9530S_WorkDays.EmployeeSchedule
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.Employee,
	|	tmp2.EmployeeSchedule,
	|	tmp2.Position,
	|	tmp2.ProfitLossCenter,
	|	tmp2.Accrual,
	|	tmp2.Value,
	|	tmp2.ActuallyDaysHours,
	|	tmp2.TotalFullActuallyDays,
	|	SUM(TotalBySchedule.CountDaysHours) AS CountDaysHours,
	|	0 AS MoneyForPaid,
	|	ISNULL(TotalBySchedule2.TotalCountDaysHours, 0) AS TotalCountDaysHours,
	|	ISNULL(TotalBySchedule2.TotalFullDays, 0) AS TotalFullDays
	|FROM
	|	tmp2 AS tmp2
	|		LEFT JOIN TotalBySchedule AS TotalBySchedule
	|		ON tmp2.EmployeeSchedule = TotalBySchedule.EmployeeSchedule
	|		AND TotalBySchedule.Date >= tmp2.Period
	|		AND TotalBySchedule.Date < tmp2.EndDate
	|		LEFT JOIN TotalBySchedule2 AS TotalBySchedule2
	|		ON tmp2.EmployeeSchedule = TotalBySchedule2.EmployeeSchedule
	|GROUP BY
	|	tmp2.Employee,
	|	tmp2.EmployeeSchedule,
	|	tmp2.Accrual,
	|	tmp2.Value,
	|	tmp2.ActuallyDaysHours,
	|	tmp2.Position,
	|	tmp2.ProfitLossCenter,
	|	ISNULL(TotalBySchedule2.TotalCountDaysHours, 0),
	|	ISNULL(TotalBySchedule2.TotalFullDays, 0),
	|	tmp2.TotalFullActuallyDays";
	
	Query.SetParameter("BeginDate" , BeginDate);
	Query.SetParameter("EndDate"   , EndDate);
	Query.SetParameter("tmp1"      , tmp1);
	Query.SetParameter("tmp2"      , tmp2);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	For Each Row In QueryTable Do
		If Not ValueIsFilled(Row.CountDaysHours) Or Not ValueIsFilled(Row.TotalCountDaysHours) Then
			Row.MoneyForPaid = 0;
			Continue;
		EndIf;
		
		If Row.CountDaysHours = Row.TotalCountDaysHours Then
			_Value = Row.Value;
		Else
			_Value = Row.Value / Row.TotalCountDaysHours * Row.CountDaysHours;
		EndIf;
			
		If Row.CountDaysHours = Row.ActuallyDaysHours Then
			Row.MoneyForPaid = _Value;
		Else
			If Row.Accrual.Periodicity = Enums.AccrualAndDeductionPeriodicity.ByDay Then
				Row.MoneyForPaid = _Value / Row.TotalFullActuallyDays * Row.TotalFullDays / Row.CountDaysHours * Row.ActuallyDaysHours;
			Else
				Row.MoneyForPaid = _Value / Row.CountDaysHours * Row.ActuallyDaysHours;
			EndIf;
		EndIf;
	EndDo;
	
	Return QueryTable;
EndFunction	

Function PutChoiceDataToServerStorage(ChoiceData, FormUUID) Export
	ValueTable = New ValueTable();
	ValueTable.Columns.Add("Employee");
	ValueTable.Columns.Add("PaymentPeriod");
	ValueTable.Columns.Add("CalculationType");
	ValueTable.Columns.Add("NetAmount");
	ValueTable.Columns.Add("TotalAmount");
	
	For Each Row In ChoiceData Do
		NewRow = ValueTable.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.NetAmount  = Row.Amount;
		NewRow.TotalAmount = Row.Amount;
	EndDo;
	GroupColumn = "Employee, PaymentPeriod, CalculationType";
	SumColumn = "NetAmount, TotalAmount";
	ValueTable.GroupBy(GroupColumn, SumColumn);
	Address = PutToTempStorage(ValueTable, FormUUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, GroupColumn, SumColumn);
EndFunction
