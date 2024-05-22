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
// * JobLimitCount - Number - If = 0 then all tasks are launched simultaneously.
// * StopOnErrorAnyJob - Boolean -
// * CallbackWhenAllJobsDone - Boolean -
// * JobSettings - Array Of See JobSettings 
// * UpdatePause - Number -
Function JobDataSettings() Export
	Settings = New Structure;
	Settings.Insert("CallbackModule", "");
	Settings.Insert("CallbackFunction", "");
	Settings.Insert("ProcedurePath", "");
	Settings.Insert("JobLimitCount", 5);
	Settings.Insert("StopOnErrorAnyJob", True);
	Settings.Insert("JobSettings", New Array);
	Settings.Insert("CallbackWhenAllJobsDone", True);
	Settings.Insert("UpdatePause", 20);
	Return Settings;
EndFunction

// Notify settings.
// 
// Returns:
//  Structure - Notify settings:
// * Percent - Number - 
// * Log - String - 
// * Data - String - 
// * Speed - String - 
// * End - Boolean - 
Function NotifySettings() Export
	Settings = New Structure;
	Settings.Insert("Percent", 0);
	Settings.Insert("Log", "");
	Settings.Insert("DataAddress", Undefined);
	Settings.Insert("End", False);
	Settings.Insert("Speed", "");
	Return Settings;
EndFunction

// Notify stream.
// 
// Parameters:
//  NotifySettings - See NotifySettings
Procedure NotifyStream(NotifySettings) Export
	Settings = CommonFunctionsServer.SerializeJSONUseXDTO(NotifySettings);
	Settings = "✔️❌" + Settings;
	CommonFunctionsClientServer.ShowUsersMessage(Settings);
EndProcedure

Function RunJob(JobRow)
	
	If TypeOf(JobRow.JobParameters) = Type("String") Then
		Params = CommonFunctionsServer.GetFromCache(JobRow.JobParameters); // Array Of String
	Else
		Params = JobRow.JobParameters; // Array Of String
	EndIf;
	
	If SessionParameters.RunBackgroundJobInDebugMode Then
		Job = New Structure;
		Job.Insert("UUID", "Not job - " + New UUID);
		Job.Insert("Begin", CommonFunctionsServer.GetCurrentSessionDate());
		Job.Insert("Description", JobRow.Title);
		Job.Insert("Key", JobRow.Key);
		Job.Insert("UUID", New UUID);
		Job.Insert("ErrorInfo", ErrorInfo());
		Try
			ParamsText = New Array; // Array Of String
			For Index = 0 To Params.UBound() Do
				ParamsText.Add("Params[" + Index + "]");
			EndDo;
			SetSafeMode(True);
			Execute JobRow.ProcedurePath + "(" + StrConcat(ParamsText, ",") + ")";
			Job.Insert("State", Enums.JobStatus.Completed);
		Except
			Job.Insert("State", Enums.JobStatus.Failed);
			Job.Insert("ErrorInfo", ErrorInfo());		
		EndTry;
		Job.Insert("End", CommonFunctionsServer.GetCurrentSessionDate());
	Else
		//@skip-check statement-type-change
		Job = BackgroundJobs.Execute(JobRow.ProcedurePath, Params, JobRow.Key, JobRow.Title);
	EndIf;
	
	Return Job;
EndFunction

// Run jobs.
// 
// Parameters:
//  JobList - See GetJobList
//  MaxJobStream - Number - 
Procedure RunJobs(JobList, MaxJobStream) Export
	
	If MaxJobStream = 0 Then
		MaxJobStream = 20; // Set limit
	EndIf;
	
	CurrentJobRunning = JobList.FindRows(New Structure("Status", Enums.JobStatus.Active)).Count();
	
	CanRun = MaxJobStream - CurrentJobRunning;
	
	If CanRun <= 0 Then // Max job count already running
		Return;
	EndIf;
	
	For Each JobRow In JobList Do
		
		If Not JobRow.Status = Enums.JobStatus.Wait Then
			Continue;
		EndIf;			
		
		Job = RunJob(JobRow);
		If TypeOf(Job) = Type("Structure") Then
			//@skip-check property-return-type
			JobRow.NonJobData = Job;
		EndIf;
		//@skip-check invocation-parameter-type-intersect
		FillJobInfo(Job, JobRow);
		
		CanRun = CanRun - 1;
		
		If CanRun <= 0 Then // Max job count already running
			Break;
		EndIf;
	EndDo;
EndProcedure

// Fill job list.
// 
// Parameters:
//  JobDataSettings - See JobDataSettings
//  JobList - See GetJobList
Procedure FillJobList(JobDataSettings, JobList) Export
	For Each JobSetting In JobDataSettings.JobSettings Do
		JobRow = JobList.Add();
		JobRow.Title = JobSetting.Description;
		JobRow.Key = JobSetting.Key;
		If TypeOf(JobSetting.ProcedureParams) = Type("String") Then
			JobRow.JobParameters = JobSetting.ProcedureParams;
		Else
			JobRow.JobParameters = CommonFunctionsServer.PutToCache(JobSetting.ProcedureParams);
		EndIf;
		JobRow.Icon = PictureLib.AppearanceCircleYellow;
		JobRow.Status = Enums.JobStatus.Wait;
		JobRow.ProcedurePath = JobDataSettings.ProcedurePath;
	EndDo;
EndProcedure

// Check jobs.
// 
// Parameters:
//  JobList - See GetJobList
Procedure CheckJobs(JobList) Export
	For Each JobRow In JobList Do
		
		If Not JobRow.Status = Enums.JobStatus.Active Then
			Continue;
		EndIf;
		
		//@skip-check property-return-type
		If Not JobRow.NonJobData = Undefined Then
			//@skip-check variable-value-type
			Job = JobRow.NonJobData;
		Else
			Job = BackgroundJobs.FindByUUID(New UUID(JobRow.ID));
		EndIf;
		//@skip-check invocation-parameter-type-intersect
		FillJobInfo(Job, JobRow);
	EndDo;
EndProcedure

// Filljob info.
// 
// Parameters:
//  Job - BackgroundJob - Job
//  JobRow - ValueTableRow Of See GetJobList
Procedure FillJobInfo(Job, JobRow)
	JobRow.ID = Job.UUID;
	JobRow.Start = Job.Begin;
	JobRow.End = Job.End;
	JobRow.Title = Job.Description;
	JobRow.Key = Job.Key;

	LogData = New Array; // Array Of String
	MsgArray = New Array; // Array Of String
	
	//@skip-check property-return-type
	If JobRow.NonJobData = Undefined Then
		UsrMsg = Job.GetUserMessages(True);
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
		//@skip-check statement-type-change
		UsrMsg = GetUserMessages(True);
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
	ElsIf JobRow.Status = Enums.JobStatus.Wait Then
		JobRow.Icon = PictureLib.AppearanceCircleYellow;
	Else
		JobRow.Icon = PictureLib.FormHelp;
	EndIf;
	
	For Each Message In UsrMsg Do
		If StrStartsWith(Message.Text, "✔️❌") Then
			NotifySettings = CommonFunctionsServer.DeserializeJSONUseXDTO(Right(Message.Text, StrLen(Message.Text) - StrLen("✔️❌"))); // See NotifySettings
			If Not IsBlankString(NotifySettings.Log) Then
				LogData.Insert(0, NotifySettings.Log);
			EndIf;
			If Not IsBlankString(NotifySettings.Speed) Then
				JobRow.Speed = NotifySettings.Speed;
			EndIf;
			If NotifySettings.End Then
				//@skip-check property-return-type, statement-type-change
				JobRow.DataAddress = NotifySettings.DataAddress;
				NotifySettings.Percent = 100;
			EndIf;
			If NotifySettings.Percent > 0 Then
				JobRow.Percent = NotifySettings.Percent;
				JobRow.PercentIndicator = Left("|||||||||||||||||||||||||||||||||||||||||||||||||", Int(NotifySettings.Percent / 2));
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
//  JobList - See GetJobList
// 
// Returns:
//  Array Of Structure:
//  * Result - Boolean - 
//  * CacheKey - String - 
Function GetJobsResult(JobList) Export
	
	Array = New Array; // Array Of Structure
	For Each Row In JobList Do
		
		If Row.CallbackDone Then
			Continue;
		EndIf;
		
		If Row.Status = Enums.JobStatus.Completed 
			OR Row.Status = Enums.JobStatus.Failed Then
			Str = New Structure;
			Str.Insert("Result", Row.Status = Enums.JobStatus.Completed);
			Str.Insert("CacheKey", Row.DataAddress);
			Array.Add(Str);
		
			Row.CallbackDone = True;
		EndIf;
		
	EndDo;
	
	Return Array;
	
EndFunction

// Get job list.
// 
// Returns:
//  ValueTable - Get job list:
// * CallbackDone - Boolean - 
// * DataAddress - String - 
// * End - Date - 
// * EndAt - Date - 
// * ID - String - 
// * Icon - Picture - 
// * JobParameters - String - 
// * Key - String - 
// * Log - String - 
// * NonJobData - Arbitrary - 
// * Percent - Number - 
// * PercentIndicator - String - 
// * ProcedurePath - String - 
// * Speed - String - 
// * Start - Date - 
// * Status - EnumRef.JobStatus - 
// * Title - String - 
// * UserMessages - String - 
Function GetJobList() Export
	Table = New ValueTable();
	Table.Columns.Add("CallbackDone", New TypeDescription("Boolean"));
	Table.Columns.Add("DataAddress", New TypeDescription("String"));
	Table.Columns.Add("End", New TypeDescription("Date"));
	Table.Columns.Add("EndAt", New TypeDescription("Date"));
	Table.Columns.Add("ID", New TypeDescription("String"));
	Table.Columns.Add("Icon", New TypeDescription("Picture"));
	Table.Columns.Add("JobParameters", New TypeDescription("String"));
	Table.Columns.Add("Key", New TypeDescription("String"));
	Table.Columns.Add("Log", New TypeDescription("String"));
	Table.Columns.Add("NonJobData");
	Table.Columns.Add("Percent", New TypeDescription("Number"));
	Table.Columns.Add("PercentIndicator", New TypeDescription("String"));
	Table.Columns.Add("ProcedurePath", New TypeDescription("String"));
	Table.Columns.Add("Speed", New TypeDescription("String"));
	Table.Columns.Add("Start", New TypeDescription("Date"));
	Table.Columns.Add("Status", New TypeDescription("EnumRef.JobStatus"));
	Table.Columns.Add("Title", New TypeDescription("String"));
	Table.Columns.Add("UserMessages", New TypeDescription("String"));
	Return Table;
EndFunction

Function GetPostingInfo() Export
	Tree = New ValueTree();
	Tree.Columns.Add("Date");
	Tree.Columns.Add("DocumentType");
	Tree.Columns.Add("Errors");
	Tree.Columns.Add("NewMovement");
	Tree.Columns.Add("Processed");
	Tree.Columns.Add("Ref");
	Tree.Columns.Add("RegName");
	Tree.Columns.Add("Select");
	Return Tree;
EndFunction

Function RegInfoArrayToPostingInfo(RegInfoArray) Export
	Tree = GetPostingInfo();
	
	For Each DocRow In RegInfoArray Do			
		ParentRow = Tree.Rows.Add();
		ParentRow.Ref = DocRow.Ref;
		ParentRow.DocumentType = TypeOf(DocRow.Ref);
		ParentRow.Errors = DocRow.Error;
		For Each RegInfoData In DocRow.RegInfo Do
			NewRow = ParentRow.Rows.Add();
			FillPropertyValues(NewRow, RegInfoData);
			NewRow.Select = True;
			NewRow.Processed = False;
			NewRow.Date = ParentRow.Date;
			NewRow.Ref = ParentRow.Ref;
			NewRow.DocumentType = ParentRow.DocumentType;
			NewRow.NewMovement = New ValueStorage(RegInfoData.NewPostingData, New Deflation(9));
		EndDo;
	EndDo;
	Return Tree;
EndFunction

// Run jobs from server.
// 
// Parameters:
//  JobDataSettings - See BackgroundJobAPIServer.JobDataSettings
//  JobList - See BackgroundJobAPIServer.GetJobList
Procedure RunJobsFromServer(JobDataSettings, JobList) Export
	RunBackgroundJobInDebugMode = SessionParameters.RunBackgroundJobInDebugMode;
 
	AllJobIsDone = False;
	While Not AllJobIsDone Do 
		CheckJobs(JobList);
		RunJobs(JobList, JobDataSettings.JobLimitCount); 
		
		JobListForWait = New Array; // Array Of BackgroundJob 
		For Each Row In JobList Do
			If Row.Status = Enums.JobStatus.Active Then
				JobListForWait.Add(BackgroundJobs.FindByUUID(New UUID(Row.ID)));
			EndIf;   			
		EndDo;
		
		NotAllJobIsDone = False;
		For Each Row In JobList Do
			If Row.Status = Enums.JobStatus.Active OR Row.Status = Enums.JobStatus.Wait Then
				NotAllJobIsDone = True;
			EndIf;   			
		EndDo;           
		
		AllJobIsDone = Not NotAllJobIsDone;
		If Not RunBackgroundJobInDebugMode Then
			BackgroundJobs.WaitForExecutionCompletion(JobListForWait);   
		EndIf;
	EndDo;
EndProcedure