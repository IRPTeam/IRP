
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.FromSchedule = Parameters.EmployeeSchedule;
EndProcedure

&AtClient
Procedure Ok(Command)
	If ThisObject.CheckFilling() Then
		
	EndIf;
EndProcedure

&AtClient
Procedure Cancel(Command)
	ThisObject.Close();
EndProcedure


