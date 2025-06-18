
Procedure BeforeWrite(Cancel)
	
	If DataExchange.Load = True Then
		Return;
	EndIf;
	
	ThisObject.Author = SessionParameters.CurrentUser;
	If ThisObject.Date = Date(1,1,1) Then
		ThisObject.Date = CommonFunctionsServer.GetCurrentSessionDate();
	EndIf;
	
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If TypeOf(FillingData) = Type("CatalogRef.ExecutionTemplates") Then
		StandardProcessing = False;
		
		ThisObject.Template = FillingData;
		ThisObject.ExecutionStages.Load(FillingData.ExecutionStages.Unload());
		ThisObject.StagesTasks.Load(FillingData.StagesTasks.Unload());
		For Each DescriptionAttribute In LocalizationReuse.AllDescription() Do
			ThisObject[DescriptionAttribute] = FillingData[DescriptionAttribute]; 
		EndDo;
	EndIf;

EndProcedure

Procedure StartBeforeStart(RoutePoint, Cancel)

	If ThisObject.ExecutionObject = Undefined Or ThisObject.ExecutionObject.IsEmpty() Then
		Cancel = True;
		Return;
	EndIf;
	
	If ValueIsFilled(BusinessProcesses.ExecutionProcesses.FindStartedProcess(
					ThisObject.ExecutionObject, ThisObject.Template)) Then
		Cancel = True;
		Return;
	EndIf;
	
	CurrentStage = New UUID("00000000-0000-0000-0000-000000000000");
	CurrentTask = New UUID("00000000-0000-0000-0000-000000000000");
	
	If ThisObject.ExecutionStages.Count() Then
		CurrentStage = ThisObject.ExecutionStages[0].StageID;
		CurrentTask = GetFirstTask(CurrentStage);
		
	ElsIf ThisObject.Ref.IsEmpty() Then
		Return;
		
	EndIf;
	
	If ThisObject.Ref.IsEmpty() Then
		Write();
	EndIf;
	
	SaveNewStageStatus(CurrentStage, CurrentTask);

EndProcedure

Procedure CompleteTasksBeforeCreateTasks(RoutePoint, TasksBeingFormed, StandardProcessing)
	StandardProcessing = False;
	
	EmptyUUID = New UUID("00000000-0000-0000-0000-000000000000");
	StatusRecord = InformationRegisters.ExecutionProcessStatus.GetLast(, New Structure("ExecutionProcess", ThisObject.Ref)); // InformationRegisterRecordManager.ExecutionProcessStatus
	If StatusRecord.CurrentStage = EmptyUUID Then
		Return;
	EndIf;
	
	StageRow = ThisObject.ExecutionStages.Find(StatusRecord.CurrentStage, "StageID");
	If StageRow = Undefined Then
		Return;
	EndIf;
	
	TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID", StatusRecord.CurrentStage));
	If TaskRows.Count() = 0 Then
		Return;
	EndIf;
	
	If StageRow.TasksStartTogether Then
		For Each TaskRow In TaskRows Do
			CreateTask(TaskRow, RoutePoint, StatusRecord.IterationNumber, TasksBeingFormed);
		EndDo;
	Else
		TaskRow = ThisObject.StagesTasks.Find(StatusRecord.CurrentTask, "TaskID");
		If TaskRow <> Undefined Then
			CreateTask(TaskRow, RoutePoint, StatusRecord.IterationNumber, TasksBeingFormed);
		EndIf;
	EndIf;
	
EndProcedure

Procedure CheckTasksCompletedConditionCheck(RoutePoint, ProcessFinish)
	
	ProcessFinish = True;
	
	EmptyUUID = New UUID("00000000-0000-0000-0000-000000000000");
	StatusRecord = InformationRegisters.ExecutionProcessStatus.GetLast(, New Structure("ExecutionProcess", ThisObject.Ref));  // InformationRegisterRecordManager.ExecutionProcessStatus
	If StatusRecord.CurrentStage = EmptyUUID Then
		Return;
	EndIf;
	
	StageRow = ThisObject.ExecutionStages.Find(StatusRecord.CurrentStage, "StageID");
	If StageRow = Undefined Then
		Return;
	EndIf;
	
	TaskIDs = New Array;
	If StageRow.TasksStartTogether Then
		TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID", StatusRecord.CurrentStage));
	Else
		TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID, TaskID", StatusRecord.CurrentStage, StatusRecord.CurrentTask));
	EndIf;
	For Each TaskRow In TaskRows Do
		TaskIDs.Add(TaskRow.TaskID);
	EndDo;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ExecutorTasks.Ref
	|FROM
	|	Task.ExecutorTasks AS ExecutorTasks
	|WHERE
	|	ExecutorTasks.TaskID IN (&TaskIDs)
	|	AND ExecutorTasks.BusinessProcess = &BusinessProcess
	|	AND ExecutorTasks.IterationNumber = &IterationNumber
	|	AND ExecutorTasks.Canceled";
	
	Query.SetParameter("TaskIDs", TaskIDs);
	Query.SetParameter("BusinessProcess", ThisObject.Ref);
	Query.SetParameter("IterationNumber", StatusRecord.IterationNumber);
	
	QuerySelection = Query.Execute().Select();
	TasksFailed = QuerySelection.Next();
	
	If TasksFailed Then
		If StageRow.TasksFailAction = Enums.TaskFailActions.RestartStage Then
			ProcessFinish = False;
			SaveNewStageStatus(StatusRecord.CurrentStage, GetFirstTask(StatusRecord.CurrentStage));
		ElsIf StageRow.TasksFailAction = Enums.TaskFailActions.RestartProcess Then
			ProcessFinish = False;
			SaveNewStageStatus(ThisObject.ExecutionStages[0].StageID, GetFirstTask(ThisObject.ExecutionStages[0].StageID));
		Else
			Canceled = True;
			Return;
		EndIf;
		
	EndIf;
	
	StageFinish = True;
	
	If Not TasksFailed Then
		If StageRow.TasksStartTogether Then
			If StageRow.LineNumber < ThisObject.ExecutionStages.Count() Then
				NextStage = ThisObject.ExecutionStages[StageRow.LineNumber].StageID;
				SaveNewStageStatus(NextStage, EmptyUUID);
				ProcessFinish = False;
			EndIf;
		Else
			NextTask = GetNextTask(StatusRecord.CurrentStage, StatusRecord.CurrentTask);
			If NextTask = EmptyUUID Then
				If StageRow.LineNumber < ThisObject.ExecutionStages.Count() Then
					NextStage = ThisObject.ExecutionStages[StageRow.LineNumber].StageID;
					SaveNewStageStatus(NextStage, GetFirstTask(NextStage));
					ProcessFinish = False;
				EndIf;
			Else
				SaveNewStageStatus(StatusRecord.CurrentStage, NextTask);
				StageFinish = False;
				ProcessFinish = False;
			EndIf;
		EndIf;
	EndIf;
	
	If StageFinish And Not TasksFailed And Not StageRow.TasksResult.IsEmpty() Then
		SaveTasksResult(StageRow.TasksResult);
	EndIf;
	
EndProcedure

Procedure CompletionOnComplete(RoutePoint, Cancel)
	
	CompletionDate = CommonFunctionsServer.GetCurrentSessionDate();
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ExecutionProcessStatus.ExecutionProcess,
	|	ExecutionProcessStatus.IterationNumber,
	|	StagesTasks.TaskID
	|INTO tmpData
	|FROM
	|	InformationRegister.ExecutionProcessStatus.SliceLast AS ExecutionProcessStatus
	|		INNER JOIN BusinessProcess.ExecutionProcesses.StagesTasks AS StagesTasks
	|		ON ExecutionProcessStatus.ExecutionProcess = StagesTasks.Ref
	|		AND ExecutionProcessStatus.CurrentStage = StagesTasks.StageID
	|		AND (ExecutionProcessStatus.CurrentTask = StagesTasks.TaskID
	|		OR ExecutionProcessStatus.CurrentTask = &EmptyID)
	|WHERE
	|	ExecutionProcessStatus.ExecutionProcess = &ExecutionProcess
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ExecutorTasks.Ref
	|FROM
	|	tmpData AS tmpData
	|		INNER JOIN Task.ExecutorTasks AS ExecutorTasks
	|		ON tmpData.ExecutionProcess = ExecutorTasks.BusinessProcess
	|		AND tmpData.IterationNumber = ExecutorTasks.IterationNumber
	|		AND tmpData.TaskID = ExecutorTasks.TaskID
	|WHERE
	|	ExecutorTasks.Canceled = TRUE";
	
	Query.SetParameter("ExecutionProcess", ThisObject.Ref);
	Query.SetParameter("EmptyID", New UUID("00000000-0000-0000-0000-000000000000"));
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Canceled = True;
	EndIf;

EndProcedure

#Region Private

// Get first task.
// 
// Parameters:
//  CurrentStage - UUID - Current stage
// 
// Returns:
//  UUID - Get first task
Function GetFirstTask(CurrentStage)
	
	CurrentTask = New UUID("00000000-0000-0000-0000-000000000000");
	
	StageRow = ThisObject.ExecutionStages.Find(CurrentStage, "StageID");
	If StageRow = Undefined OR StageRow.TasksStartTogether Then
		Return CurrentTask;
	EndIf;
	
	TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID", CurrentStage));
	If TaskRows.Count() > 0 Then
		CurrentTask = TaskRows[0].TaskID;
	EndIf;
	
	Return CurrentTask;
	
EndFunction

Function GetNextTask(CurrentStage, CurrentTask)
	
	EmptyUUID = New UUID("00000000-0000-0000-0000-000000000000");
	
	TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID", CurrentStage));
	If TaskRows.Count() = 0 Then
		Return EmptyUUID;
	EndIf;
	
	TaskFound = False;
	For Each TaskRow In TaskRows Do
		
		If TaskFound Then
			Return TaskRow.TaskID;
			
		ElsIf TaskRow.TaskID = CurrentTask Then
			TaskFound = True;
			
		EndIf;
		
	EndDo;
	
	Return EmptyUUID;
	
EndFunction

// Create task.
// 
// Parameters:
//  TaskRow - BusinessProcessTabularSectionRow.ExecutionProcesses.StagesTasks - Task row
//  RoutePoint - BusinessProcessRoutePointRef.ExecutionProcesses - Route point
//  IterationNumber - Number - Iteration number
//  TasksBeingFormed - Structure, Array of Arbitrary - Tasks being formed
Procedure CreateTask(TaskRow, RoutePoint, IterationNumber, TasksBeingFormed)
	
	NewTask = Tasks.ExecutorTasks.CreateTask();
	FillPropertyValues(NewTask, TaskRow);
	
	NewTask.CurrentExecutor = TaskRow.Executor;
	NewTask.ExecutionObject = ThisObject.ExecutionObject;
	NewTask.Date = CommonFunctionsServer.GetCurrentSessionDate();
	NewTask.BusinessProcess = ThisObject.Ref;
	NewTask.RoutePoint = RoutePoint;
	NewTask.IterationNumber = IterationNumber;
	
	TasksBeingFormed.Add(NewTask);
	
EndProcedure

// Get iteration number.
// 
// Parameters:
//  StageID - UUID - Stage ID
//  TaskID - UUID - Task ID
// 
// Returns:
//  Number - Get iteration number
Function GetIterationNumber(StageID, TaskID)
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ExecutionProcessStatus.ExecutionProcess,
	|	ExecutionProcessStatus.CurrentStage,
	|	MAX(ExecutionProcessStatus.IterationNumber) AS IterationNumber
	|FROM
	|	InformationRegister.ExecutionProcessStatus AS ExecutionProcessStatus
	|WHERE
	|	ExecutionProcessStatus.ExecutionProcess = &ExecutionProcess
	|	AND ExecutionProcessStatus.CurrentStage = &CurrentStage
	|	AND ExecutionProcessStatus.CurrentTask = &CurrentTask
	|GROUP BY
	|	ExecutionProcessStatus.ExecutionProcess,
	|	ExecutionProcessStatus.CurrentStage";
	
	Query.SetParameter("CurrentStage", StageID);
	Query.SetParameter("CurrentTask", TaskID);
	Query.SetParameter("ExecutionProcess", ThisObject.Ref);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.IterationNumber + 1;
	EndIf;
	
	Return 1;
	
EndFunction

// Save tasks result.
// 
// Parameters:
//  TasksResult - EnumRef.TaskResults - Tasks result
Procedure SaveTasksResult(TasksResult)
	ResultRecord = InformationRegisters.ExecutionResults.CreateRecordManager();
	ResultRecord.ExecutionObject = ThisObject.ExecutionObject;
	ResultRecord.Result = TasksResult;
	ResultRecord.Process = ThisObject.Ref;
	ResultRecord.Period = CommonFunctionsServer.GetCurrentSessionDate();
	ResultRecord.Write();
EndProcedure

// Save new stage status.
// 
// Parameters:
//  NewStage - UUID - New stage
//  NewTask - UUID - New task
Procedure SaveNewStageStatus(NewStage, NewTask)
	StatusRecord = InformationRegisters.ExecutionProcessStatus.CreateRecordManager();
	StatusRecord.ExecutionProcess = ThisObject.Ref;
	StatusRecord.CurrentStage = NewStage;
	StatusRecord.CurrentTask = NewTask;
	StatusRecord.IterationNumber = GetIterationNumber(NewStage, NewTask);
	StatusRecord.Period = CommonFunctionsServer.GetCurrentSessionDate();
	StatusRecord.Write();
EndProcedure

#EndRegion
