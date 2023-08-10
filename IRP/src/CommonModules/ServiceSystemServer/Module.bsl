// @strict-types

// Set session parameter.
// 
// Parameters:
//  Name - String - Name
//  Value - String - Value
//  AddInfo - Undefined - Add info
Procedure SetSessionParameter(Name, Value, AddInfo = Undefined) Export
	SessionParameters[Name] = Value;
EndProcedure

// Get object attribute.
// 
// Parameters:
//  Ref - AnyRef - Ref
//  Name - String - Name
// 
// Returns:
//  Arbitrary
Function GetObjectAttribute(Ref, Name) Export
	Return Ref[Name];
EndFunction

// Get constant value.
// 
// Parameters:
//  ConstantName - String - Constant name
// 
// Returns:
//  Arbitrary - Get constant value
Function GetConstantValue(ConstantName) Export
	Return Constants[ConstantName].Get();
EndFunction

// Set constant value.
// 
// Parameters:
//  ConstantName - String - Constant name
//  Value - Arbitrary - Value
Procedure SetConstantValue(ConstantName, Value) Export
	Constants[ConstantName].Set(Value);
EndProcedure

// Get composite object attribute.
// 
// Parameters:
//  Object - AnyRef - Object
//  AttributeName - String - Attribute name
// 
// Returns:
//  Undefined, Arbitrary - Get composite object attribute
Function GetCompositeObjectAttribute(Object, AttributeName) Export
	If ObjectHasAttribute(AttributeName, Object) Then
		Return GetObjectAttribute(Object, AttributeName);
	EndIf;
	Return Undefined;
EndFunction

// Object has attribute.
// 
// Parameters:
//  AttributeName - String - Attribute name
//  Object - AnyRef - Object
// 
// Returns:
//  Boolean - Object has attribute
Function ObjectHasAttribute(AttributeName, Object) Export
	If Object = Undefined Then
		Return False;
	EndIf;
	ValueKey = New UUID();
	Str = New Structure(AttributeName, ValueKey);
	FillPropertyValues(Str, Object);
	Return Str[AttributeName] <> ValueKey;
EndFunction

// Update scheduled job.
// 
// Parameters:
//  ScheduledJob - MetadataObjectScheduledJob - Scheduled job
//  AddJob - Boolean - Add job
Procedure UpdateScheduledJob(ScheduledJob, AddJob) Export

	ScheduledJobsList = ScheduledJobs.GetScheduledJobs(New Structure("Key", ScheduledJob.Key));
	For Each Job In ScheduledJobsList Do
		If Job.Predefined Then
			Job.Use = False;
			Job.Write();
		Else
			Job.Delete();
		EndIf;
	EndDo;
	If AddJob Then
		Job = ScheduledJobs.CreateScheduledJob(ScheduledJob);
		Job.Use = True;
		Job.Write();
	EndIf;

EndProcedure

// Get session parameter.
// 
// Parameters:
//  Name - String - Name
//  AddInfo - Structure - Add info
// 
// Returns:
//  Arbitrary - Get session parameter
Function GetSessionParameter(Name, AddInfo = Undefined) Export

	Return SessionParameters[Name];

EndFunction

// Get meta data structure.
// 
// Parameters:
//  Ref - AnyRef - Ref
// 
// Returns:
//  Structure - Get meta data structure:
// * Attributes - Structure -
// * TabularSections - Structure -
Function GetMetaDataStructure(Ref) Export
	RefMetadata = Ref.Metadata();
	MetaDataStructure = New Structure();
	Attributes = New Structure();
	For Each Attribute In RefMetadata.Attributes Do
		Attributes.Insert(Attribute.Name);
	EndDo;

	MetaDataStructure.Insert("Attributes", Attributes);
	TabularSections = New Structure();
	For Each TabularSection In RefMetadata.TabularSections Do
		TabularRow = New Structure();
		For Each Attribute In TabularSection.Attributes Do
			TabularRow.Insert(Attribute.Name);
		EndDo;

		TabularSections.Insert(TabularSection.Name, New Structure("Name, Attributes", TabularSection.Name, TabularRow));
	EndDo;

	MetaDataStructure.Insert("TabularSections", TabularSections);

	Return MetaDataStructure;
EndFunction

// Get manager by metadata.
// 
// Parameters:
//  CurrentMetadata - MetadataObject, Undefined - Current metadata
// 
// Returns:
//  CatalogManagerCatalogName, DocumentManagerDocumentName, EnumManagerEnumerationName, ChartOfCharacteristicTypesManagerChartOfCharacteristicTypesName, ChartOfAccountsManagerChartOfAccountsName, ChartOfCalculationTypesManagerChartOfCalculationTypesName, BusinessProcessManagerBusinessProcessName, TaskManagerTaskName, ExchangePlanManagerExchangePlanName, InformationRegisterManagerInformationRegisterName, AccumulationRegisterManagerAccumulationRegisterName, AccountingRegisterManagerAccountingRegisterName, CalculationRegisterManagerCalculationRegisterName, Undefined - Get manager by metadata
Function GetManagerByMetadata(CurrentMetadata) Export
	MetadataName = CurrentMetadata.Name;
	If Metadata.Catalogs.Contains(CurrentMetadata) Then
		Return Catalogs[MetadataName];
	ElsIf Metadata.Documents.Contains(CurrentMetadata) Then
		Return Documents[MetadataName];
	ElsIf Metadata.Enums.Contains(CurrentMetadata) Then
		Return Enums[MetadataName];
	ElsIf Metadata.ChartsOfCharacteristicTypes.Contains(CurrentMetadata) Then
		Return ChartsOfCharacteristicTypes[MetadataName];
	ElsIf Metadata.ChartsOfAccounts.Contains(CurrentMetadata) Then
		Return ChartsOfAccounts[MetadataName];
	ElsIf Metadata.ChartsOfCalculationTypes.Contains(CurrentMetadata) Then
		Return ChartsOfCalculationTypes[MetadataName];
	ElsIf Metadata.BusinessProcesses.Contains(CurrentMetadata) Then
		Return BusinessProcesses[MetadataName];
	ElsIf Metadata.Tasks.Contains(CurrentMetadata) Then
		Return Tasks[MetadataName];
	ElsIf Metadata.ExchangePlans.Contains(CurrentMetadata) Then
		Return ExchangePlans[MetadataName];
	ElsIf Metadata.InformationRegisters.Contains(CurrentMetadata) Then
		Return InformationRegisters[MetadataName];
	ElsIf Metadata.AccumulationRegisters.Contains(CurrentMetadata) Then
		Return AccumulationRegisters[MetadataName];
	ElsIf Metadata.AccountingRegisters.Contains(CurrentMetadata) Then
		Return AccountingRegisters[MetadataName];
	ElsIf Metadata.CalculationRegisters.Contains(CurrentMetadata) Then
		Return CalculationRegisters[MetadataName];
	Else
		// Primitive type
		Return Undefined;
	EndIf;
EndFunction

// Get manager by metadata full name.
// 
// Parameters:
//  MetadataName - String - Metadata name
// 
// Returns:
//  Undefined, CatalogManagerCatalogName, DocumentManagerDocumentName, EnumManagerEnumerationName, ChartOfCharacteristicTypesManagerChartOfCharacteristicTypesName, ChartOfAccountsManagerChartOfAccountsName, ChartOfCalculationTypesManagerChartOfCalculationTypesName, BusinessProcessManagerBusinessProcessName, TaskManagerTaskName, ExchangePlanManagerExchangePlanName, InformationRegisterManagerInformationRegisterName, AccumulationRegisterManagerAccumulationRegisterName, AccountingRegisterManagerAccountingRegisterName, CalculationRegisterManagerCalculationRegisterName - Get manager by metadata full name
Function GetManagerByMetadataFullName(MetadataName) Export
	CurrentMetadata = Metadata.FindByFullName(MetadataName);
	If CurrentMetadata = Undefined Then
		Return Undefined;
	EndIf;
	Return GetManagerByMetadata(CurrentMetadata);
EndFunction

// Get manager by type.
// 
// Parameters:
//  TypeOfValue - Type - Type of value
// 
// Returns:
//  CatalogManagerCatalogName, DocumentManagerDocumentName, EnumManagerEnumerationName, ChartOfCharacteristicTypesManagerChartOfCharacteristicTypesName, ChartOfAccountsManagerChartOfAccountsName, ChartOfCalculationTypesManagerChartOfCalculationTypesName, BusinessProcessManagerBusinessProcessName, TaskManagerTaskName, ExchangePlanManagerExchangePlanName, InformationRegisterManagerInformationRegisterName, AccumulationRegisterManagerAccumulationRegisterName, AccountingRegisterManagerAccountingRegisterName, CalculationRegisterManagerCalculationRegisterName, Undefined - Get manager by type
Function GetManagerByType(TypeOfValue) Export
	If TypeOfValue = Undefined Then
		Return Undefined;
	EndIf;
	CurrentMetadata = Metadata.FindByType(TypeOfValue);
	If CurrentMetadata = Undefined Then
		Return Undefined;
	EndIf;
	Return GetManagerByMetadata(CurrentMetadata);
EndFunction

// Get program title.
// 
// Returns:
//  String - Get program title
Function GetProgramTitle() Export
	DBName = String(SessionParameters.ConnectionSettings);
	If IsBlankString(DBName) Then
		DBName = "IRP";
	EndIf;

	If SessionParameters.ConnectionSettings.isProduction Then
		Return DBName;
	Else
		Return DBName + " (Test app)";
	EndIf;
EndFunction

// This instance is Production
// 
// Returns:
//  Boolean - is Production
Function isProduction() Export
	
	Return 
		Not SessionParameters.ConnectionSettings.IsEmpty() 
			And SessionParameters.ConnectionSettings.isProduction;

EndFunction

#Region ExternalFunctions

// Run external functions.
Procedure RunExternalFunctions() Export
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	JobQueueSliceLast.Job,
		|	JobQueueSliceLast.Period AS Period,
		|	JobQueueSliceLast.JobID,
		|	JobQueueSliceLast.DifficultLevel,
		|	JobQueueSliceLast.Status
		|FROM
		|	InformationRegister.JobQueue.SliceLast AS JobQueueSliceLast
		|
		|ORDER BY
		|	Period";
	
	JobsQueue = Query.Execute().Select();
	
	CurrentJobsLevel = 0;
	While JobsQueue.Next() Do
		If Not ValueIsFilled(JobsQueue.JobID) Then
			Continue;
		EndIf;
			
		//@skip-check invocation-parameter-type-intersect
		JobInProgress = BackgroundJobs.FindByUUID(JobsQueue.JobID);
		If Not JobInProgress = Undefined And JobInProgress.State = BackgroundJobState.Active Then
			CurrentJobsLevel = CurrentJobsLevel + JobsQueue.DifficultLevel
		Else
			Job = InformationRegisters.JobQueue.CreateRecordSet();
			Job.Filter.Job.Set(JobsQueue.Job);
			Job.Filter.Period.Set(JobsQueue.Period);
			Job.Read();
			JobRecord = Job[0];
			If JobInProgress = Undefined Then
				JobRecord.Finish = CommonFunctionsServer.GetCurrentSessionDate();
				JobRecord.Status = Enums.JobStatus.Canceled;
				Job.Write();
				Continue;
			EndIf;
			
			JobRecord.Finish = JobInProgress.End;
			Messages = New Array; // Array Of String
			For Each Message In JobInProgress.GetUserMessages() Do
				Messages.Add(Message.Text);
			EndDo;
			JobRecord.UserMessages = StrConcat(Messages, Chars.LF + Chars.LF);
			
			If Not JobInProgress.ErrorInfo = Undefined Then
				JobRecord.Description = ErrorProcessing.DetailErrorDescription(JobInProgress.ErrorInfo);
			EndIf;
			
			If JobInProgress.State = BackgroundJobState.Completed Then
				JobRecord.Status = Enums.JobStatus.Completed;
			ElsIf JobInProgress.State = BackgroundJobState.Canceled Then
				JobRecord.Status = Enums.JobStatus.Canceled;
			ElsIf JobInProgress.State = BackgroundJobState.Failed Then
				JobRecord.Status = Enums.JobStatus.Failed;
			EndIf;
			
			Job.Write();
		EndIf;
	EndDo;

	MaximumServerDifficultLevel = Constants.MaximumServerDifficultLevel.Get();
	
	ServerFreeResource = MaximumServerDifficultLevel - CurrentJobsLevel;
	
	JobsQueue.Reset();
	
	While JobsQueue.Next() Do
		
		If Not JobsQueue.Status = Enums.JobStatus.Wait Then
			Continue;
		EndIf;
		
		CanWeAddNewJob = MaximumServerDifficultLevel = 0 // Limit not set 
			OR (ServerFreeResource - JobsQueue.DifficultLevel >= 0 And MaximumServerDifficultLevel > 0);
		If Not CanWeAddNewJob Then 
			Continue;
		EndIf;	
	
		ExternalFunction = JobsQueue.Job; // CatalogRef.ExternalFunctions
		
		JobStructure = New Structure;
		JobStructure.Insert("ExternalFunction", ExternalFunction);
		JobStructure.Insert("Period", JobsQueue.Period);
		
		Job = GetJobRecordInQueue(JobStructure);
		JobRecord = Job[0];
		JobRecord.Start = CommonFunctionsServer.GetCurrentSessionDate();
		JobRecord.Status = Enums.JobStatus.Active;
		
		ParamArray = New Array; // Array Of Structure
		ParamArray.Add(JobStructure);
		JobInfo = BackgroundJobs.Execute("ServiceSystemServer.RunJobExternalFunctions",
				ParamArray, String(ExternalFunction.UUID()), ExternalFunction.Description);
		JobRecord.JobID = JobInfo.UUID;
		Job.Write();

		ServerFreeResource = ServerFreeResource + JobsQueue.DifficultLevel;
	EndDo;
	
EndProcedure

Function GetJobRecordInQueue(JobStructure)
	Job = InformationRegisters.JobQueue.CreateRecordSet();
	Job.Filter.Job.Set(JobStructure.ExternalFunction);
	Job.Filter.Period.Set(JobStructure.Period);
	Job.Read();
	Return Job;
EndFunction

// Run job external functions.
// 
// Parameters:
// 	JobStructure - Structure:
//  * ExternalFunction - CatalogRef.ExternalFunctions - External function
//  * Period - Date - Period
Procedure RunJobExternalFunctions(JobStructure) Export
	Params = CommonFunctionsServer.GetRecalculateExpressionParams(JobStructure.ExternalFunction);
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	
	Job = GetJobRecordInQueue(JobStructure);
	JobRecord = Job[0];
	
	JobRecord.Result = New ValueStorage(ResultInfo.Result, New Deflation(9));
	JobRecord.Finish = CommonFunctionsServer.GetCurrentSessionDate();
	JobRecord.Status = ?(ResultInfo.isError, Enums.JobStatus.Failed, Enums.JobStatus.Completed);
	
	If ResultInfo.isError Then
		JobRecord.Description = ResultInfo.Description;
	EndIf;
	
	JobTask = BackgroundJobs.FindByUUID(JobRecord.JobID);
	Messages = New Array; // Array of String
	For Each Message In JobTask.GetUserMessages() Do
		Messages.Add(Message.Text);
	EndDo;
	JobRecord.UserMessages = StrConcat(Messages, Chars.LF + Chars.LF);
	
	JobRecord.Log = New ValueStorage(ResultInfo.Log, New Deflation(9));
	Job.Write();
EndProcedure

// Add external functions to job queue.
// 
// Parameters:
//  ExternalFunction - CatalogRef.ExternalFunctions - External function
Procedure AddExternalFunctionsToJobQueue(ExternalFunction) Export
	
	LastJob = InformationRegisters.JobQueue.GetLast(, New Structure("Job", ExternalFunction)); // InformationRegisterRecord.JobQueue
	If LastJob.Status = Enums.JobStatus.Wait
		OR LastJob.Status = Enums.JobStatus.Pause
		OR LastJob.Status = Enums.JobStatus.Active Then
		Return;
	EndIf;
	
	Period = CommonFunctionsServer.GetCurrentSessionDate();
	Job = InformationRegisters.JobQueue.CreateRecordSet();
	Job.Filter.Job.Set(ExternalFunction);
	Job.Filter.Period.Set(Period);
	JobRecord = Job.Add();
	JobRecord.Job = ExternalFunction;
	JobRecord.Period = Period;
	JobRecord.Status = Enums.JobStatus.Wait;
	Job.Write();
EndProcedure

// Stop scheduler job.
// 
// Parameters:
//  ExternalFunction - CatalogRef.ExternalFunctions - Job ID
// 
Procedure StopSchedulerJob(ExternalFunction) Export
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	JobQueueSliceLast.Period,
		|	JobQueueSliceLast.Job
		|FROM
		|	InformationRegister.JobQueue.SliceLast(, Job = &Job) AS JobQueueSliceLast";
	Query.SetParameter("Job", ExternalFunction);
	LastJob = Query.Execute().Select();
	If Not LastJob.Next() Then
		Return;
	EndIf;

	JobStructure = New Structure;
	JobStructure.Insert("ExternalFunction", ExternalFunction);
	JobStructure.Insert("Period", LastJob.Period);
	Job = GetJobRecordInQueue(JobStructure);
	
	JobRecord = Job[0];
	
	If Not ValueIsFilled(JobRecord.JobID) Then
        Return;
    EndIf;
    CurrentJob = BackgroundJobs.FindByUUID(JobRecord.JobID);
    If CurrentJob = Undefined Then
        Return;
    EndIf;
    
	If CurrentJob.State = BackgroundJobState.Active Then
		CurrentJob.Cancel();
	EndIf;
EndProcedure

// Continue scheduler job.
// 
// Parameters:
//  ExternalFunction - CatalogRef.ExternalFunctions - Job ID
//  Pause - Boolean - Pause
Procedure ContinueOrPauseSchedulerJob(ExternalFunction, Pause = True) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	JobQueueSliceLast.Period,
		|	JobQueueSliceLast.Job,
		|	JobQueueSliceLast.Job
		|FROM
		|	InformationRegister.JobQueue.SliceLast(, Job = &Job) AS JobQueueSliceLast";
	Query.SetParameter("Job", ExternalFunction);
	LastJob = Query.Execute().Select();
	If Not LastJob.Next() Then
		Return;
	EndIf;
	
	JobStructure = New Structure;
	JobStructure.Insert("ExternalFunction", ExternalFunction);
	JobStructure.Insert("Period", LastJob.Period);
	Job = GetJobRecordInQueue(JobStructure);
	
	JobRecord = Job[0];
	
	If Not ValueIsFilled(JobRecord.JobID) Then
        Return;
    EndIf;
    CurrentJob = BackgroundJobs.FindByUUID(JobRecord.JobID);
    If CurrentJob = Undefined Then
        Return;
    EndIf;
    
	If CurrentJob.State = BackgroundJobState.Active 
		And JobRecord.Status = Enums.JobStatus.Active And Pause Then
		JobRecord.Status = Enums.JobStatus.Pause;
		Job.Write();
	ElsIf CurrentJob.State = BackgroundJobState.Active 
		And JobRecord.Status = Enums.JobStatus.Pause And Not Pause Then
		JobRecord.Status = Enums.JobStatus.Active;
		Job.Write();
	EndIf;
EndProcedure

#EndRegion
