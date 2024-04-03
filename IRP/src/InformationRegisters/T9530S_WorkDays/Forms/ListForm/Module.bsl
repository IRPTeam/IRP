
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetListParameters();
	ThisObject.ListMode = "Calendar";
	ThisObject.Period.StartDate = BegOfMonth(CommonFunctionsServer.GetCurrentSessionDate());
	ThisObject.Period.EndDate = EndOfMonth(CommonFunctionsServer.GetCurrentSessionDate());
	
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClient
Procedure CalendarOnPeriodOutput(Item, PeriodAppearance)
	CalendarDates = GetCalendarDates(ThisObject.EmployeeScheduleFilter, ThisObject.Period.StartDate, ThisObject.Period.EndDate);
	For Each Appearance In PeriodAppearance.Dates Do
		If CalendarDates.AllDays.Find(Appearance.Date) = Undefined Then
			Appearance.BackColor = WebColors.LightGray;
		Elsif CalendarDates.NotWorkingDays.Find(Appearance.Date) <> Undefined Then
			Appearance.BackColor = WebColors.LightPink;
		EndIf;
	EndDo;
EndProcedure

&AtServerNoContext
Function GetCalendarDates(EmployeeSchedule, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T9530S_WorkDays.Date,
	|	T9530S_WorkDays.CountDaysHours
	|FROM
	|	InformationRegister.T9530S_WorkDays AS T9530S_WorkDays
	|WHERE
	|	T9530S_WorkDays.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND T9530S_WorkDays.EmployeeSchedule = &EmployeeSchedule";
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);
	Query.SetParameter("EmployeeSchedule", EmployeeSchedule);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Structure();
	Result.Insert("WorkingDays", New Array());
	Result.Insert("NotWorkingDays", New Array());
	Result.Insert("AllDays", New Array());
	
	While QuerySelection.Next() Do
		Result.AllDays.Add(QuerySelection.Date);
		If ValueIsFilled(QuerySelection.CountDaysHours) Then
			Result.WorkingDays.Add(QuerySelection.Date);
		Else
			Result.NotWorkingDays.Add(QuerySelection.Date);
		EndIf;
	EndDo;
	
	Return Result;
EndFunction

&AtClient
Procedure ListModeOnChange(Item)
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClient
Procedure EmployeeScheduleFilterOnChange(Item)
	SetListParameters();
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClient
Procedure PeriodOnChange(Item)
	SetListParameters();
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	If Form.ListMode = "Calendar" Then
		Form.Items.GroupPages.CurrentPage = Form.Items.GroupCalendar;
	Else
		Form.Items.GroupPages.CurrentPage = Form.Items.GroupList;
	EndIf;
	
	Form.Items.Calendar.BeginOfRepresentationPeriod = Form.Period.StartDate;
	Form.Items.Calendar.EndOfRepresentationPeriod = Form.Period.EndDate;
#IF Client THEN
	Form.Items.Calendar.Refresh();
#ENDIF
EndProcedure

&AtServer
Procedure SetListParameters()
	ThisObject.List.Parameters.SetParameterValue("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
	ThisObject.List.Parameters.SetParameterValue("BeginPeriod", ThisObject.Period.StartDate);
	ThisObject.List.Parameters.SetParameterValue("EndPeriod", ThisObject.Period.EndDate);
EndProcedure

&AtClient
Procedure CreateSchedule(Command)
	OpeningParameters = New Structure();
	OpeningParameters.Insert("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
	OpeningParameters.Insert("StartDate", ThisObject.Period.StartDate);
	OpeningParameters.Insert("EndDate", ThisObject.Period.EndDate);
	
	OpenForm("InformationRegister.T9530S_WorkDays.Form.CreateSchedule", 
		OpeningParameters, ThisObject, , , , New NotifyDescription("UpdateFormEnd", ThisObject) 
		,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure CopySchedule(Command)
	OpeningParameters = New Structure();
	OpeningParameters.Insert("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
	OpeningParameters.Insert("StartDate", ThisObject.Period.StartDate);
	OpeningParameters.Insert("EndDate", ThisObject.Period.EndDate);
	
	OpenForm("InformationRegister.T9530S_WorkDays.Form.CopySchedule", 
		OpeningParameters, ThisObject, , , , New NotifyDescription("UpdateFormEnd", ThisObject)
		,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient
Procedure CalendarSelection(Item, SelectedDate)
	If Not ValueIsFilled(ThisObject.EmployeeScheduleFilter) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Salary_Err_002, "EmployeeScheduleFilter");
		Return;
	EndIf;
	
	KeyValues = New Structure();
	KeyValues.Insert("Date", SelectedDate);
	KeyValues.Insert("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
	
	RecordKeyInfo = GetRecordKey(KeyValues);
	
	OpeningParameters = New Structure();
	If RecordKeyInfo.IsExists Then
		OpeningParameters.Insert("Key", RecordKeyInfo.RecordKey);
	Else
		OpeningParameters.Insert("FillingValues", KeyValues);
	EndIf;
	
	OpenForm("InformationRegister.T9530S_WorkDays.RecordForm",
		OpeningParameters, ThisObject, , , , New NotifyDescription("UpdateFormEnd", ThisObject)
		,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtServer
Function GetRecordKey(KeyValues)
	
	RecordSet = InformationRegisters.T9530S_WorkDays.CreateRecordSet();
	RecordSet.Filter.Date.Set(KeyValues.Date);
	RecordSet.Filter.EmployeeSchedule.Set(KeyValues.EmployeeSchedule);
	RecordSet.Read();
	
	RecordKey = InformationRegisters.T9530S_WorkDays.CreateRecordKey(KeyValues);	
	Return New Structure("RecordKey, IsExists", RecordKey, RecordSet.Count() > 0);
EndFunction
	
&AtClient
Procedure UpdateFormEnd(Result, NotufyParams) Export
	ThisObject.Items.List.Refresh();
	ThisObject.Items.Calendar.Refresh();
EndProcedure

