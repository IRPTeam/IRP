
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
	
	CurrentStage = New UUID("00000000-0000-0000-0000-000000000000");
	If ThisObject.ExecutionStages.Count() Then
		CurrentStage = ThisObject.ExecutionStages[0].StageID;
	ElsIf ThisObject.Ref.IsEmpty() Then
		Return;
	EndIf;
	
	If ThisObject.Ref.IsEmpty() Then
		Write();
	EndIf;
	
	SaveNewStageStatus(CurrentStage);

EndProcedure

Procedure CompleteTasksBeforeCreateTasks(RoutePoint, TasksBeingFormed, StandardProcessing)
	StandardProcessing = False;
	
	EmptyStage = New UUID("00000000-0000-0000-0000-000000000000");
	StatusRecord = InformationRegisters.ExecutionProcessStatus.GetLast(, New Structure("ExecutionProcess", ThisObject.Ref));
	If StatusRecord.CurrentStage = EmptyStage Then
		Return;
	EndIf;
	
	TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID", StatusRecord.CurrentStage));
	If TaskRows.Count() = 0 Then
		Return;
	EndIf;
	
	For Each TaskRow In TaskRows Do
		NewTask = Tasks.ExecutorTasks.CreateTask();
		
		FillPropertyValues(NewTask, TaskRow);
		NewTask.CurrentExecutor = TaskRow.Executor;
		NewTask.ExecutionObject = ThisObject.ExecutionObject;
		NewTask.Date = CommonFunctionsServer.GetCurrentSessionDate();
		NewTask.BusinessProcess = ThisObject.Ref;
		NewTask.RoutePoint = RoutePoint;
		NewTask.IterationNumber = StatusRecord.IterationNumber;
		
		TasksBeingFormed.Add(NewTask);
	EndDo;
	
EndProcedure

Procedure CheckTasksCompletedConditionCheck(RoutePoint, ToFinish)
	
	ToFinish = True;
	
	EmptyStage = New UUID("00000000-0000-0000-0000-000000000000");
	StatusRecord = InformationRegisters.ExecutionProcessStatus.GetLast(, New Structure("ExecutionProcess", ThisObject.Ref));
	If StatusRecord.CurrentStage = EmptyStage Then
		Return;
	EndIf;
	
	StageRow = ThisObject.ExecutionStages.Find(StatusRecord.CurrentStage, "StageID");
	If StageRow = Undefined Then
		Return;
	EndIf;
	
	TaskIDs = New Array;
	TaskRows = ThisObject.StagesTasks.FindRows(New Structure("StageID", StatusRecord.CurrentStage));
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
	|	AND ExecutorTasks.IterationNumber = &IterationNumber
	|	AND ExecutorTasks.Canceled";
	
	Query.SetParameter("TaskIDs", TaskIDs);
	Query.SetParameter("IterationNumber", StatusRecord.IterationNumber);
	
	QuerySelection = Query.Execute().Select();
	TasksFailed = QuerySelection.Next();
	
	If TasksFailed Then
		If StageRow.TasksFailAction = Enums.TaskFailActions.RestartStage Then
			ToFinish = False;
			SaveNewStageStatus(StatusRecord.CurrentStage);
		ElsIf StageRow.TasksFailAction = Enums.TaskFailActions.RestartProcess Then
			ToFinish = False;
			SaveNewStageStatus(ThisObject.ExecutionStages[0].StageID);
		Else
			Canceled = True;
			Return;
		EndIf;
		
	ElsIf StageRow.LineNumber < ThisObject.ExecutionStages.Count() Then
		NextStage = ThisObject.ExecutionStages[StageRow.LineNumber].StageID;
		SaveNewStageStatus(NextStage);
		ToFinish = False;
		
	EndIf;
	
	If Not TasksFailed And Not StageRow.TasksResult.IsEmpty() Then
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
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Canceled = True;
	EndIf;

EndProcedure

#Region Private

Function GetIterationNumber(StageID)
	
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
	|GROUP BY
	|	ExecutionProcessStatus.ExecutionProcess,
	|	ExecutionProcessStatus.CurrentStage";
	
	Query.SetParameter("CurrentStage", StageID);
	Query.SetParameter("ExecutionProcess", ThisObject.Ref);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.IterationNumber + 1;
	EndIf;
	
	Return 1;
	
EndFunction

Procedure SaveTasksResult(TasksResult)
	ResultRecord = InformationRegisters.ExecutionResults.CreateRecordManager();
	ResultRecord.ExecutionObject = ThisObject.ExecutionObject;
	ResultRecord.Result = TasksResult;
	ResultRecord.Process = ThisObject.Ref;
	ResultRecord.Period = CommonFunctionsServer.GetCurrentSessionDate();
	ResultRecord.Write();
EndProcedure

Procedure SaveNewStageStatus(NewStage)
	StatusRecord = InformationRegisters.ExecutionProcessStatus.CreateRecordManager();
	StatusRecord.ExecutionProcess = ThisObject.Ref;
	StatusRecord.CurrentStage = NewStage;
	StatusRecord.IterationNumber = GetIterationNumber(NewStage);
	StatusRecord.Period = CommonFunctionsServer.GetCurrentSessionDate();
	StatusRecord.Write();
EndProcedure

#EndRegion
