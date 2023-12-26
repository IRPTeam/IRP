
// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	JobDataSettings = Parameters.JobDataSettings; // See BackgroundJobAPIServer.JobDataSettings
	CallbackFunction = JobDataSettings.CallbackFunction;
	CallbackModule = JobDataSettings.CallbackModule;
	
	BackgroundJobAPIServer.RunJobs(JobDataSettings, JobList);
	
	RunBackgroundJobInDebugMode = SessionParameters.RunBackgroundJobInDebugMode;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If UpdatePause = 0 Then
		UpdatePause = 10;
	EndIf;
	If RunBackgroundJobInDebugMode Then
		CheckJobStatus();
	Else
		AttachIdleHandler("CheckJobStatus", UpdatePause, True);
	EndIf;
	
	Title = FormOwner.Title + " [ Jobs: " + JobList.Count() + " ]";
EndProcedure

&AtClient
Procedure UpdateStatuses(Command)
	CheckJobStatus();
EndProcedure

&AtClient
Procedure CheckJobStatus() Export
	If CheckJobStatusAtServer() Then
		AttachIdleHandler("CheckJobStatus", UpdatePause, True);
	Else
		DetachIdleHandler("CheckJobStatus");
		Items.FormUpdateStatuses.Visible = False;
		If Not IsBlankString(CallbackFunction) Then
			JobsResult = GetJobsResult();
			If IsBlankString(CallbackModule) Then
				Execute "FormOwner." + CallbackFunction + "(JobsResult)";
				Close();
			Else
				Callback(JobsResult);
			EndIf;		
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure Callback(JobsResult)
	Execute "CallbackModule" + "." + CallbackFunction + "(JobsResult)";
EndProcedure

&AtServer
Function GetJobsResult()
	Return BackgroundJobAPIServer.GetJobsResult(JobList);
EndFunction

&AtServer
Function CheckJobStatusAtServer()
	
	BackgroundJobAPIServer.CheckJobs(JobList);
	
	For Each Row In JobList Do
		If Row.Status = Enums.JobStatus.Active Then
			Return True;
		EndIf;
	EndDo;
	Return False;
	
EndFunction

