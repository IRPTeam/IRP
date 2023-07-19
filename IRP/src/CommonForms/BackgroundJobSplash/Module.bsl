
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.JobTitle = ThisObject.Parameters.BackgroundJobTitle;
	ThisObject.StartDate = CommonFunctionsServer.GetCurrentSessionDate();
	ThisObject.StartTime = CommonFunctionsServer.GetCurrentSessionDate();
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	If Not FormCanBeClose Then
		Cancel = True;
	EndIf;
EndProcedure

&AtClient
Procedure OK(Command)
	Close();
EndProcedure


