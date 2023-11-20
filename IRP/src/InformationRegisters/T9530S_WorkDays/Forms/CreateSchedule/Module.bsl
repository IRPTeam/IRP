
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.EmployeeSchedule = Parameters.EmployeeSchedule;
	
	ThisObject.ScheduleVariant.Add("InTwoDays", R().Salary_001);	
	ThisObject.ScheduleVariant.Add("WeekWithDaysOff", R().Salary_002);
	
	ThisObject.Weekends.Add(1, R().Salary_WeekDays_1,);
	ThisObject.Weekends.Add(2, R().Salary_WeekDays_2,);
	ThisObject.Weekends.Add(3, R().Salary_WeekDays_3,);
	ThisObject.Weekends.Add(4, R().Salary_WeekDays_4,);
	ThisObject.Weekends.Add(5, R().Salary_WeekDays_5,);
	ThisObject.Weekends.Add(6, R().Salary_WeekDays_6, True);
	ThisObject.Weekends.Add(7, R().Salary_WeekDays_7, True);
	
	SetVisibilityAvailability(Undefined, ThisObject);	
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
//	Form.Items.StartWorkingDay.Visible = Form.ScheduleVariant.
	f=1;
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	
EndProcedure

&AtClient
Procedure WeekendsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure WeekendsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure



