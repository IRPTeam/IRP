
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetListParameters();
	ThisObject.ListMode = "View";
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure

&AtClient
Procedure ListModeOnChange(Item)
	SetVisibilityAvailability(Undefined, ThisObject);
EndProcedure


&AtClient
Procedure EmployeeScheduleFilterOnChange(Item)
	SetListParameters();
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)

	f=1;
EndProcedure

&AtServer
Procedure SetListParameters()
	ThisObject.List.Parameters.SetParameterValue("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
EndProcedure

&AtClient
Procedure CreateSchedule(Command)
	OpeningParameters = New Structure();
	OpeningParameters.Insert("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
	
	OpenForm("InformationRegister.T9530S_WorkDays.Form.CreateSchedule", 
		OpeningParameters, ThisObject, , , , ,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure CopySchedule(Command)
	OpeningParameters = New Structure();
	OpeningParameters.Insert("EmployeeSchedule", ThisObject.EmployeeScheduleFilter);
	
	OpenForm("InformationRegister.T9530S_WorkDays.Form.CopySchedule", 
		OpeningParameters, ThisObject, , , , ,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

