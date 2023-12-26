// @strict-types

// Job settings.
// 
// Returns:
//  Structure - Job settings:
// * ProcedureParams - Array, String - Array of all parameters, or Key in T1020S_Cache
// * Key - Undefined - 
// * Description - String - 
Function JobSettings() Export
	Settings = New Structure;
	Settings.Insert("ProcedureParams", New Array);
	Settings.Insert("Key", Undefined);
	Settings.Insert("Description", "");
	Return Settings;
EndFunction

// Job data settings.
// 
// Returns:
//  Structure - Job data settings:
// * CallbackModule - String - 
// * CallbackFunction - String - 
// * ProcedurePath - String - 
// * JobSettings - Array Of See JobSettings 
Function JobDataSettings() Export
	Settings = New Structure;
	Settings.Insert("CallbackModule", "");
	Settings.Insert("CallbackFunction", "");
	Settings.Insert("ProcedurePath", "");
	Settings.Insert("JobSettings", New Array);
	Return Settings;
EndFunction

// Notify settings.
// 
// Returns:
//  Structure - Notify settings:
// * Percent - Number - 
// * Log - String - 
// * Data - String - 
// * End - Boolean - 
Function NotifySettings() Export
	Settings = New Structure;
	Settings.Insert("Percent", 0);
	Settings.Insert("Log", "");
	Settings.Insert("DataAddress", Undefined);
	Settings.Insert("End", False);
	Return Settings;
EndFunction

Procedure NotifyStream(NotifySettings) Export
	Settings = CommonFunctionsServer.SerializeJSONUseXDTO(NotifySettings);
	Settings = "✔️❌" + Settings;
	CommonFunctionsClientServer.ShowUsersMessage(Settings);
EndProcedure

// Run job.
// 
// Parameters:
//  JobSettings - See JobSettings
//  ProcedurePath - String -
// 
// Returns:
//  BackgroundJob
Function RunJob(JobSettings, ProcedurePath)
	
	If TypeOf(JobSettings.ProcedureParams) = Type("String") Then
		Params = CommonFunctionsServer.GetFromCache(JobSettings.ProcedureParams);
	Else
		Params = JobSettings.ProcedureParams;
	EndIf;
	
	If SessionParameters.RunBackgroundJobInDebugMode Then
		
		Job = New Structure;
		Job.Insert("UUID", "Not job - " + New UUID);
		Job.Insert("Begin", CommonFunctionsServer.GetCurrentSessionDate());
		Job.Insert("Description", JobSettings.Description);
		Job.Insert("Key", JobSettings.Key);
		Job.Insert("UUID", New UUID);
		Job.Insert("ErrorInfo", ErrorInfo());
		Try
			ParamsText = New Array; // Array Of String
			For Index = 0 To Params.UBound() Do
				ParamsText.Add("Params[" + Index + "]");
			EndDo;
			Execute ProcedurePath + "(" + StrConcat(ParamsText, ",") + ")";
			Job.Insert("State", Enums.JobStatus.Completed);
		Except
			Job.Insert("State", Enums.JobStatus.Failed);
			Job.Insert("ErrorInfo", ErrorInfo());		
		EndTry;
		Job.Insert("End", CommonFunctionsServer.GetCurrentSessionDate());
	Else
		Job = BackgroundJobs.Execute(ProcedurePath, Params, JobSettings.Key, JobSettings.Description);
	EndIf;
	
	Return Job;
EndFunction

// Run jobs.
// 
// Parameters:
//  JobDataSettings - See JobDataSettings
//  JobList - See CommonForm.BackgroundMultiJob.JobList
Procedure RunJobs(JobDataSettings, JobList) Export
	For Each JobSetting In JobDataSettings.JobSettings Do
		Job = RunJob(JobSetting, JobDataSettings.ProcedurePath);
		JobRow = JobList.Add();
		If TypeOf(Job) = Type("Structure") Then
			JobRow.NonJobData = Job;
		EndIf;
		FillJobInfo(Job, JobRow);
	EndDo;
EndProcedure

Procedure CheckJobs(JobList) Export
	For Each JobRow In JobList Do
		If Not JobRow.NonJobData = Undefined Then
			Job = JobRow.NonJobData;
		Else
			Job = BackgroundJobs.FindByUUID(New UUID(JobRow.ID));
		EndIf;
		FillJobInfo(Job, JobRow);
	EndDo;
EndProcedure

// Filljob info.
// 
// Parameters:
//  Job - BackgroundJob - Job
//  JobRow - ValueTableRow Of See CommonForm.BackgroundMultiJob.JobList
Procedure FillJobInfo(Job, JobRow)
	JobRow.ID = Job.UUID;
	JobRow.Start = Job.Begin;
	JobRow.End = Job.End;
	JobRow.Title = Job.Description;
	JobRow.Key = Job.Key;

	LogData = New Array; // Array Of String
	MsgArray = New Array; // Array Of String
	
	If JobRow.NonJobData = Undefined Then
		UsrMsg = Job.GetUserMessages();
		If Job.State = BackgroundJobState.Active Then
			JobRow.Status = Enums.JobStatus.Active;
		ElsIf Job.State = BackgroundJobState.Canceled Then
			JobRow.Status = Enums.JobStatus.Canceled;
		ElsIf Job.State = BackgroundJobState.Completed Then
			JobRow.Status = Enums.JobStatus.Completed;
		ElsIf Job.State = BackgroundJobState.Failed Then
			JobRow.Status = Enums.JobStatus.Failed;
		Else
			JobRow.Status = Enums.JobStatus.EmptyRef();
		EndIf;
	Else
		UsrMsg = GetUserMessages();
		JobRow.Status = Job.State;
	EndIf;
	
	If JobRow.Status = Enums.JobStatus.Active Then
		JobRow.Icon = PictureLib.Waiting;
	ElsIf JobRow.Status = Enums.JobStatus.Canceled Then
		JobRow.Icon = PictureLib.AppearanceExclamationMarkIcon;
	ElsIf JobRow.Status = Enums.JobStatus.Completed Then
		JobRow.Icon = PictureLib.AppearanceCheckIcon;
	ElsIf JobRow.Status = Enums.JobStatus.Failed Then
		JobRow.Icon = PictureLib.AppearanceCrossIcon;
	Else
		JobRow.Icon = PictureLib.FormHelp;
	EndIf;
	
	For Each Message In UsrMsg Do
		If StrStartsWith(Message.Text, "✔️❌") Then
			NotifySettings = CommonFunctionsServer.DeserializeJSONUseXDTO(Right(Message.Text, StrLen(Message.Text) - StrLen("✔️❌"))); // See NotifySettings
			If Not IsBlankString(NotifySettings.Log) Then
				LogData.Insert(0, NotifySettings.Log);
			EndIf;
			
			If NotifySettings.End Then
				JobRow.DataAddress = NotifySettings.DataAddress;
			EndIf;
		Else
			MsgArray.Insert(0, Message.Text);
		EndIf; 
	EndDo;
	
	If JobRow.Status = Enums.JobStatus.Failed Then
		LogData.Insert(0, ErrorProcessing.DetailErrorDescription(Job.ErrorInfo));
	EndIf;
	
	If LogData.Count() > 0 Then
		JobRow.Log = "" + CommonFunctionsServer.GetCurrentSessionDate() + ": " + StrConcat(LogData, Chars.LF) + Chars.LF + JobRow.Log;
	EndIf;
	
	If MsgArray.Count() > 0 Then
		JobRow.UserMessages = "" + CommonFunctionsServer.GetCurrentSessionDate() + ": " + StrConcat(MsgArray, Chars.LF) + Chars.LF + JobRow.UserMessages;
	EndIf;
	
EndProcedure


// Get jobs result.
// 
// Parameters:
//  JobList Job list
// 
// Returns:
//  Array Of Structure:
//  * Result - Boolean - 
//  * CacheKey - String - 
Function GetJobsResult(JobList) Export
	
	Array = New Array; // Array Of Structure
	For Each Row In JobList Do
		Str = New Structure;
		Str.Insert("Result", Row.Status = Enums.JobStatus.Completed);
		Str.Insert("CacheKey", Row.DataAddress);
		Array.Add(Str);
	EndDo;
	
	Return Array;
	
EndFunction
