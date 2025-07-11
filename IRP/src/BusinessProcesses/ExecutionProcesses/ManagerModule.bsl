
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = StrTemplate("%1 (%2)", String(Data["Description_" + LocalizationReuse.GetLocalizationCode()]), Data.Number);
EndProcedure

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields = New Array();
	Fields.Add("Number");
	For Each DescriptionName In LocalizationServer.AllDescription() Do
		Fields.Add(DescriptionName);
	EndDo;
EndProcedure

// Get execution flowchart.
// 
// Parameters:
//  ProcessRef - BusinessProcessRef.ExecutionProcesses - Process ref
// 
// Returns:
//  SpreadsheetDocument - Get execution flowchart
Function GetExecutionFlowchart(ProcessRef) Export
	
	Result = New SpreadsheetDocument();
	Result.PrintParametersName = "ExecutionProcesses_Flowchart";
	
	Template = GetTemplate("Template");
	
	HeaderArea = Template.GetArea("Header");
	HeaderArea.Parameters.Name = String(ProcessRef);
	HeaderArea.Parameters.Comment = ProcessRef.Comment;
	
	Result.Put(HeaderArea);
	
	StatusRecord = InformationRegisters.ExecutionProcessStatus.GetLastStatus(ProcessRef);
	
	Query = New Query;
	Query.SetParameter("Ref", ProcessRef);
	
	Query.Text =
	"SELECT
	|	Stages.StageID AS StageID,
	|	Stages.LineNumber AS StageLineNumber,
	|	Stages.Description_en AS StageDescription,
	|	Tasks.TaskID AS TaskID,
	|	ISNULL(Tasks.LineNumber, 0) AS TaskLineNumber,
	|	Tasks.Description_en AS TaskDescription,
	|	Tasks.TaskType AS TaskType
	|INTO tmpProcess
	|FROM
	|	BusinessProcess.ExecutionProcesses.ExecutionStages AS Stages
	|		LEFT JOIN BusinessProcess.ExecutionProcesses.StagesTasks AS Tasks
	|		ON Stages.StageID = Tasks.StageID
	|		AND Stages.Ref = Tasks.Ref
	|WHERE
	|	Stages.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpProcess.StageID AS StageID,
	|	tmpProcess.TaskID,
	|	tmpProcess.StageLineNumber AS StageLineNumber,
	|	tmpProcess.StageDescription AS StageDescription,
	|	tmpProcess.TaskLineNumber AS TaskLineNumber,
	|	tmpProcess.TaskDescription AS TaskDescription,
	|	tmpProcess.TaskType,
	|	ISNULL(ExecutorTasks.Ref, VALUE(Task.ExecutorTasks.EmptyRef)) AS TaskRef,
	|	ISNULL(ExecutorTasks.IterationNumber, 0) AS IterationNumber,
	|	ISNULL(ExecutorTasks.CurrentExecutor, VALUE(Catalog.Users.EmptyRef)) AS CurrentExecutor,
	|	ISNULL(ExecutorTasks.ExecutionDate, DATETIME(1, 1, 1)) AS ExecutionDate,
	|	ISNULL(ExecutorTasks.Executed, FALSE) AS Executed,
	|	ISNULL(ExecutorTasks.Canceled, FALSE) AS Canceled,
	|	ISNULL(ExecutorTasks.Comment, """") AS Comment
	|FROM
	|	tmpProcess AS tmpProcess
	|		LEFT JOIN Task.ExecutorTasks AS ExecutorTasks
	|		ON tmpProcess.TaskID = ExecutorTasks.TaskID
	|		AND ExecutorTasks.BusinessProcess = &Ref
	|
	|ORDER BY
	|	StageLineNumber,
	|	TaskLineNumber,
	|	IterationNumber
	|TOTALS
	|	MAX(StageDescription) AS StageDescription,
	|	MAX(TaskDescription) AS TaskDescription
	|BY
	|	StageLineNumber,
	|	TaskLineNumber";
	
	LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, "Stages");
	LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, "Tasks");
	
	StageSelection = Query.Execute().Select(QueryResultIteration.ByGroups);
	
	While StageSelection.Next() Do
		StageArea = Template.GetArea("Stage");
		StageArea.Parameters.Number = StageSelection.StageLineNumber;
		StageArea.Parameters.StageName = StageSelection.StageDescription;
		Result.Put(StageArea);

		TaskNumber = 0;
		TaskSelection = StageSelection.Select(QueryResultIteration.ByGroups);
		While TaskSelection.Next() Do
			TaskNumber = TaskNumber + 1;
			TaskArea = Template.GetArea("Task");
			TaskArea.Parameters.Number = StrTemplate("%1.%2", TaskSelection.StageLineNumber, TaskNumber);
			TaskArea.Parameters.TaskName = TaskSelection.TaskDescription;
			
			If TaskSelection.StageID = StatusRecord.CurrentStage
					AND (TaskSelection.TaskID = StatusRecord.CurrentTask
						OR Not ValueIsFilled(StatusRecord.CurrentTask)) Then
				TaskArea.Area(1, 1, 1, 2).TextColor = WebColors.Green;
			EndIf;
			
			Result.Put(TaskArea);
			
			ExecutorSelection = TaskSelection.Select();
			While ExecutorSelection.Next() Do
			
				ExecutorArea = Template.GetArea("Executor");
				ExecutorArea.Parameters.Number = StrTemplate("%1.%2.%3", 
					ExecutorSelection.StageLineNumber, TaskNumber, ExecutorSelection.IterationNumber);
				ExecutorArea.Parameters.ExecutorName = ExecutorSelection.CurrentExecutor;
				ExecutorArea.Parameters.Comment = ExecutorSelection.Comment;
				ExecutorArea.Parameters.Date = 
					?(ExecutorSelection.ExecutionDate = Date(1,1,1), "", 
						Format(ExecutorSelection.ExecutionDate, "DF='dd.MM.yyyy hh:mm';"));
				
				ExecutorArea.Parameters.Result = 
					?(ExecutorSelection.Canceled, Enums.TaskResults.Canceled, 
					?(Not ExecutorSelection.Executed, Enums.TaskResults.EmptyRef(), 
					?(ExecutorSelection.TaskType = Enums.TaskTypes.Execution, Enums.TaskResults.Executed,
					?(ExecutorSelection.TaskType = Enums.TaskTypes.Verification, Enums.TaskResults.Verified,
					?(ExecutorSelection.TaskType = Enums.TaskTypes.Confirmation, Enums.TaskResults.Confirmed,
						Enums.TaskResults.EmptyRef())))));
			
				If ExecutorSelection.Canceled Then
					ExecutorArea.Area(1, 1, 1, 2).TextColor = WebColors.Red;
				ElsIf Not ExecutorSelection.Executed Then
					If ExecutorSelection.StageID = StatusRecord.CurrentStage
							AND (ExecutorSelection.TaskID = StatusRecord.CurrentTask
								OR Not ValueIsFilled(StatusRecord.CurrentTask)) Then
						ExecutorArea.Area(1, 1, 1, 2).TextColor = WebColors.Green;
					Else
						ExecutorArea.Area(1, 1, 1, 2).TextColor = WebColors.Gray;
						ExecutorArea.Area(1, 1, 1, 2).Font = New Font(ExecutorArea.Area(1, 2, 1, 2).Font, , , , True); 
					EndIf;
				EndIf;
			
				Result.Put(ExecutorArea);
			EndDo;
		EndDo;
	EndDo;
	
	Return Result;
	
EndFunction

// Find started process.
// 
// Parameters:
//  ExecutionObject - See BusinessProcess.ExecutionProcesses.ExecutionObject
// 
// Returns:
//  BusinessProcessRef.ExecutionProcesses - Find started process
Function FindStartedProcess(ExecutionObject, Template) Export
	
	Query = New Query;
	Query.SetParameter("ExecutionObject", ExecutionObject);
	Query.SetParameter("Template", Template);
	Query.Text =
	"SELECT
	|	ExecutionProcesses.Ref,
	|	ExecutionProcesses.Date AS Date
	|FROM
	|	BusinessProcess.ExecutionProcesses AS ExecutionProcesses
	|WHERE
	|	ExecutionProcesses.ExecutionObject = &ExecutionObject
	|	AND ExecutionProcesses.Template = &Template
	|	AND NOT ExecutionProcesses.DeletionMark
	|	AND ExecutionProcesses.Started
	|	AND NOT ExecutionProcesses.Completed
	|
	|ORDER BY
	|	Date DESC";
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	EndIf;
	
	Return BusinessProcesses.ExecutionProcesses.EmptyRef();
	
EndFunction
