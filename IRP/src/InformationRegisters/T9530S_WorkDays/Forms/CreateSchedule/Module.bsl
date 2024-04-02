
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.EmployeeSchedule = Parameters.EmployeeSchedule;
	ThisObject.Period.StartDate = Parameters.StartDate;
	ThisObject.Period.EndDate = Parameters.EndDate;
	
	ThisObject.ScheduleVariant = "WeekWithDaysOff";
	
	ThisObject.Weekends.Add(1, R().Salary_WeekDays_1,);
	ThisObject.Weekends.Add(2, R().Salary_WeekDays_2,);
	ThisObject.Weekends.Add(3, R().Salary_WeekDays_3,);
	ThisObject.Weekends.Add(4, R().Salary_WeekDays_4,);
	ThisObject.Weekends.Add(5, R().Salary_WeekDays_5,);
	ThisObject.Weekends.Add(6, R().Salary_WeekDays_6, True);
	ThisObject.Weekends.Add(7, R().Salary_WeekDays_7, True);
	
	SetVisibilityAvailability(Undefined, ThisObject);	
EndProcedure

&AtClient
Procedure ScheduleVariantOnChange(Item)
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClient
Procedure EmployeeScheduleOnChange(Item)
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.Weekends.Visible = (Form.ScheduleVariant = "WeekWithDaysOff");
	Form.Items.StartWorkingDay.Visible = 
		(Form.ScheduleVariant = "InTwoDays" 
			Or Form.ScheduleVariant = "TwoInTwoDays"
			Or Form.ScheduleVariant = "ThreeInThreeDays");
			
	Form.Items.CountHours.Visible = 
		(CommonFunctionsServer.GetRefAttribute(Form.EmployeeSchedule, "Type") = 
			PredefinedValue("Enum.EmployeeScheduleTypes.Hour"));
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	If Not ValueIsFilled(ThisObject.Period.StartDate) 
		Or Not ValueIsFilled(ThisObject.Period.EndDate)
		Or ThisObject.Period.StartDate > ThisObject.Period.EndDate Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Salary_Err_001, "Period");
		Cancel = True;
	EndIf; 
	
	If ThisObject.ScheduleVariant = "WeekWithDaysOff" Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "StartWorkingDay");
	EndIf;
	
	If ThisObject.EmployeeSchedule.Type = Enums.EmployeeScheduleTypes.Day Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "CountHours");
	EndIf;
EndProcedure

&AtClient
Procedure Ok(Command)
	If ThisObject.CheckFilling() Then
		CreateCalendarAtServer();
		ThisObject.Close(True);
	EndIf;
EndProcedure

&AtServer
Procedure CreateCalendarAtServer()
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Date");
	ResultTable.Columns.Add("EmployeeSchedule");
	ResultTable.Columns.Add("CountDaysHours");
	
	CountDaysHours = 0;
	If ThisObject.EmployeeSchedule.Type = Enums.EmployeeScheduleTypes.Day Then
		CountDaysHours = 1;
	Else
		CountDaysHours = ThisObject.CountHours;
	EndIf;
	
	_CurrentDate = BegOfDay(ThisObject.Period.StartDate);
	
	_WorkingDate = BegOfDay(ThisObject.StartWorkingDay);
	
	_Counter = 0;
	
	While _CurrentDate <= BegOfDay(ThisObject.Period.EndDate) Do
		NewRow = ResultTable.Add();
		NewRow.Date = _CurrentDate;
		NewRow.EmployeeSchedule = ThisObject.EmployeeSchedule;
		
		If ThisObject.ScheduleVariant = "WeekWithDaysOff" Then
			
			DayOfWeek = ThisObject.Weekends.FindByValue(WeekDay(_CurrentDate));
			If DayOfWeek <> Undefined And  Not DayOfWeek.Check  Then
				NewRow.CountDaysHours = CountDaysHours;
			Else
				NewRow.CountDaysHours = 0;
			EndIf;
			
		ElsIf ThisObject.ScheduleVariant = "InTwoDays" Then
			
			If _CurrentDate = _WorkingDate Then
				NewRow.CountDaysHours = CountDaysHours;
				_WorkingDate = _WorkingDate + (60 * 60 * 24) * 3;
			Else
				NewRow.CountDaysHours = 0;
			EndIf;
		
		ElsIf ThisObject.ScheduleVariant = "TwoInTwoDays" Then
		
			If _CurrentDate = _WorkingDate Then
				If _Counter < 2 Then
					NewRow.CountDaysHours = CountDaysHours;
				Else
					NewRow.CountDaysHours = 0;
				EndIf;
				
				If _Counter + 1 >= 4 Then
					_Counter = 0;
				Else
					_Counter = _Counter + 1;
				EndIf;
				
				_WorkingDate = _WorkingDate + (60 * 60 * 24);
			EndIf;
				
		ElsIf ThisObject.ScheduleVariant = "ThreeInThreeDays" Then
		
			If _CurrentDate = _WorkingDate Then
				If _Counter < 3 Then
					NewRow.CountDaysHours = CountDaysHours;
				Else
					NewRow.CountDaysHours = 0;
				EndIf;
				
				If _Counter + 1 >= 6 Then
					_Counter = 0;
				Else
					_Counter = _Counter + 1;
				EndIf;
				
				_WorkingDate = _WorkingDate + (60 * 60 * 24);
			EndIf;
			
		EndIf;
		
		_CurrentDate = BegOfDay(EndOfDay(_CurrentDate) + 1);
	EndDo;
	
	For Each Row In ResultTable Do
		RecordSet = InformationRegisters.T9530S_WorkDays.CreateRecordSet();
		RecordSet.Filter.EmployeeSchedule.Set(Row.EmployeeSchedule);
		RecordSet.Filter.Date.Set(Row.Date);
		RecordSet.Clear();
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		RecordSet.Write();	
	EndDo;
	
EndProcedure

&AtClient
Procedure Cancel(Command)
	ThisObject.Close(Undefined);
EndProcedure

&AtClient
Procedure WeekendsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure WeekendsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

