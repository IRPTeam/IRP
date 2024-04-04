
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.JobTitle = ThisObject.Parameters.BackgroundJobTitle;
	ThisObject.StartDate = CommonFunctionsServer.GetCurrentSessionDate();
	ThisObject.StartTime = CommonFunctionsServer.GetCurrentSessionDate();
	ThisObject.JobUUID = ThisObject.Parameters.JobUUID;
EndProcedure

&AtClient
Async Procedure CancelJob(Command)
	If Await DoQueryBoxAsync(R().InfoMessage_033, QuestionDialogMode.OKCancel) = DialogReturnCode.OK Then
		CancelJobAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure CancelJobAtServer()
	
	If IsBlankString(JobUUID) Then
		Return;
	EndIf;
	
	Job = BackgroundJobs.FindByUUID(New UUID(JobUUID));
	If Job = Undefined Then
		Return;
	Else
		Job.Cancel();
	EndIf;
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

