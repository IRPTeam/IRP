
// @strict-types

&AtClient
Procedure DoNotCloseForm(Command)
	DoNotCloseForm = Not DoNotCloseForm;
	Items.DoNotCloseForm.Check = DoNotCloseForm;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	JobDataSettings = Parameters.JobDataSettings; // See BackgroundJobAPIServer.JobDataSettings
	If JobDataSettings.JobSettings.Count() = 0 Then
		Cancel = True;
		Return;
	EndIf;
	
	CallbackFunction = JobDataSettings.CallbackFunction;
	CallbackModule = JobDataSettings.CallbackModule;
	
	BackgroundJobAPIServer.FillJobList(JobDataSettings, JobList);
	
	RunBackgroundJobInDebugMode = SessionParameters.RunBackgroundJobInDebugMode;
	
	DontContinueOnError = JobDataSettings.StopOnErrorAnyJob;
	MaxJobStream = JobDataSettings.JobLimitCount;
	CallbackWhenAllJobsDone = JobDataSettings.CallbackWhenAllJobsDone;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateLabels();
	If UpdatePause = 0 Then
		UpdatePause = 2;
	EndIf;
	CheckJobStatus();
	
	Title = FormOwner.Title + " [Jobs: " + JobList.Count() + "]";
EndProcedure

&AtClient
Procedure UpdateStatuses(Command)
	CheckJobStatus();
EndProcedure

&AtClient
Procedure CheckJobStatus() Export
	AllJobDone = CheckJobStatusAtServer();
	If AllJobDone Then
		DetachIdleHandler("CheckJobStatus");
	Else
		AttachIdleHandler("CheckJobStatus", UpdatePause, True);
	EndIf;
	UpdateLabels();
	RunCallbackForOwner(AllJobDone);
EndProcedure

&AtClient
Procedure RunCallbackForOwner(AllJobDone)
	Items.FormUpdateStatuses.Enabled = False;
	If IsBlankString(CallbackFunction) Then
		Return;
	EndIf;
		
	JobsResult = GetJobsResult();
	If JobsResult.Count() = 0 Then
		Return;
	EndIf;
	
	If DontContinueOnError And CallbackWhenAllJobsDone Then
		For Each JobData In JobsResult Do
			If Not JobData.Result Then
				MaxJobStream = 0;
				Return;
			EndIf;
		EndDo;
	EndIf;
	If IsBlankString(CallbackModule) Then
		Execute "FormOwner." + CallbackFunction + "(JobsResult, AllJobDone)";
	Else
		Callback(JobsResult);
	EndIf;
			
	If Not DoNotCloseForm And AllJobDone Then
		Close();
	EndIf;
	Items.FormUpdateStatuses.Enabled = True;
EndProcedure

&AtClient
Procedure UpdateLabels()
	ActiveJob = JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Active"))).Count();
	FailedJob = JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Failed"))).Count();
	ComplitedJob = JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Completed"))).Count();
	WaitJob = JobList.FindRows(New Structure("Status", PredefinedValue("Enum.JobStatus.Wait"))).Count();
EndProcedure

&AtServer
Procedure Callback(JobsResult)
	Execute "CallbackModule" + "." + CallbackFunction + "(JobsResult, AllJobDone)";
EndProcedure

&AtServer
Function GetJobsResult()
	Return BackgroundJobAPIServer.GetJobsResult(JobList);
EndFunction

&AtServer
Function CheckJobStatusAtServer()
	
	BackgroundJobAPIServer.CheckJobs(JobList);
	BackgroundJobAPIServer.RunJobs(JobList, MaxJobStream);
	For Each Row In JobList Do
		If Row.Status = Enums.JobStatus.Active OR Row.Status = Enums.JobStatus.Wait Then
			Return False;
		EndIf;
	EndDo;
	Return True;
	
EndFunction

