
// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	JobDataSettings = Parameters.JobDataSettings; // See BackgroundJobAPIServer.JobDataSettings
	CallbackFunction = JobDataSettings.CallbackFunction;
	CallbackModule = JobDataSettings.CallbackModule;
	
	BackgroundJobAPIServer.FillJobList(JobDataSettings, JobList);
	
	RunBackgroundJobInDebugMode = SessionParameters.RunBackgroundJobInDebugMode;
	
	DontContinueOnError = JobDataSettings.StopOnErrorAnyJob;
	MaxJobStream = JobDataSettings.JobLimitCount;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateLabels();
	If UpdatePause = 0 Then
		UpdatePause = 2;
	EndIf;
	CheckJobStatus();
	
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
			If DontContinueOnError Then
				For Each JobData In JobsResult Do
					If Not JobData.Result Then
						Return;
					EndIf;
				EndDo;
			EndIf;
			If IsBlankString(CallbackModule) Then
				Execute "FormOwner." + CallbackFunction + "(JobsResult)";
				Close();
			Else
				Callback(JobsResult);
			EndIf;		
		EndIf;
	EndIf;
	UpdateLabels();
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
	Execute "CallbackModule" + "." + CallbackFunction + "(JobsResult)";
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
			Return True;
		EndIf;
	EndDo;
	Return False;
	
EndFunction

