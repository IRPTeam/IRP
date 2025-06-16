
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data["Description_" + LocalizationReuse.UserLanguageCode()]);
EndProcedure

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields = New Array();
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
	
	Query = New Query;
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
	|	tmpProcess.StageID,
	|	tmpProcess.TaskID,
	|	MAX(ExecutorTasks.IterationNumber) AS IterationNumber
	|INTO tmpTasks
	|FROM
	|	tmpProcess AS tmpProcess
	|		INNER JOIN Task.ExecutorTasks AS ExecutorTasks
	|		ON tmpProcess.TaskID = ExecutorTasks.TaskID
	|		AND ExecutorTasks.BusinessProcess = &Ref
	|GROUP BY
	|	tmpProcess.StageID,
	|	tmpProcess.TaskID
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpProcess.StageID,
	|	tmpProcess.StageLineNumber AS StageLineNumber,
	|	tmpProcess.StageDescription,
	|	tmpProcess.TaskID,
	|	tmpProcess.TaskLineNumber AS TaskLineNumber,
	|	tmpProcess.TaskDescription,
	|	tmpProcess.TaskType,
	|	ExecutorTasks.Ref AS TaskRef,
	|	ExecutorTasks.CurrentExecutor,
	|	ISNULL(ExecutorTasks.ExecutionDate, DATETIME(1, 1, 1)) AS ExecutionDate,
	|	ISNULL(ExecutorTasks.Executed, FALSE) AS Executed,
	|	ISNULL(ExecutorTasks.Canceled, FALSE) AS Canceled,
	|	ISNULL(ExecutorTasks.Comment, """") AS Comment,
	|	NOT ExecutionProcessStatusSliceLast.ExecutionProcess IS NULL AS CurrentTask
	|FROM
	|	tmpProcess AS tmpProcess
	|		LEFT JOIN tmpTasks AS tmpTasks
	|			LEFT JOIN Task.ExecutorTasks AS ExecutorTasks
	|			ON tmpTasks.TaskID = ExecutorTasks.TaskID
	|			AND tmpTasks.IterationNumber = ExecutorTasks.IterationNumber
	|			AND ExecutorTasks.BusinessProcess = &Ref
	|			LEFT JOIN InformationRegister.ExecutionProcessStatus.SliceLast AS ExecutionProcessStatusSliceLast
	|			ON tmpTasks.StageID = ExecutionProcessStatusSliceLast.CurrentStage
	|			AND tmpTasks.IterationNumber = ExecutionProcessStatusSliceLast.IterationNumber
	|			AND ExecutionProcessStatusSliceLast.ExecutionProcess = &Ref
	|			AND (ExecutionProcessStatusSliceLast.CurrentTask = tmpTasks.TaskID
	|			OR ExecutionProcessStatusSliceLast.CurrentTask = &EmptyID)
	|		ON tmpProcess.StageID = tmpTasks.StageID
	|		AND tmpProcess.TaskID = tmpTasks.TaskID
	|
	|ORDER BY
	|	StageLineNumber,
	|	TaskLineNumber";
	
	Query.SetParameter("Ref", ProcessRef);
	Query.SetParameter("EmptyID", New UUID("00000000-0000-0000-0000-000000000000"));
	
	Query.Text = StrReplace(Query.Text, "Description_en", "Description_" + LocalizationReuse.UserLanguageCode());
	QuerySelection = Query.Execute().Select();
	
	CurrentStage = Undefined;
	TaskNumber = 0; 
	While QuerySelection.Next() Do
		If QuerySelection.StageID <> CurrentStage Then
			TaskNumber = 0;
			CurrentStage = QuerySelection.StageID;
			
			StageArea = Template.GetArea("Stage");
			StageArea.Parameters.Number = QuerySelection.StageLineNumber;
			StageArea.Parameters.StageName = QuerySelection.StageDescription;
			Result.Put(StageArea);
		EndIf;

		If QuerySelection.TaskLineNumber > 0 Then
			TaskNumber = TaskNumber + 1;
			
			TaskArea = Template.GetArea("Task");
			TaskArea.Parameters.Number = StrTemplate("%1.%2", QuerySelection.StageLineNumber, TaskNumber);
			TaskArea.Parameters.TaskName = QuerySelection.TaskDescription;
			TaskArea.Parameters.Executor = QuerySelection.CurrentExecutor;
			TaskArea.Parameters.Comment = QuerySelection.Comment;
			TaskArea.Parameters.Date = 
				?(QuerySelection.ExecutionDate=Date(1,1,1), "", Format(QuerySelection.ExecutionDate, "DF='dd.MM.yyyy hh:mm';"));
			
			TaskArea.Parameters.Result = 
				?(QuerySelection.Canceled, Enums.TaskResults.Canceled, 
				?(Not QuerySelection.Executed, Enums.TaskResults.EmptyRef(), 
				?(QuerySelection.TaskType = Enums.TaskTypes.Execution, Enums.TaskResults.Executed,
				?(QuerySelection.TaskType = Enums.TaskTypes.Verification, Enums.TaskResults.Verified,
				?(QuerySelection.TaskType = Enums.TaskTypes.Confirmation, Enums.TaskResults.Confirmed,
					Enums.TaskResults.EmptyRef())))));
			
			If Not QuerySelection.Executed Then
				If QuerySelection.CurrentTask Then
					TaskArea.Area(1, 2, 1, 2).TextColor = WebColors.Green;
				Else
					TaskArea.Area(1, 2, 1, 2).TextColor = WebColors.Gray;
				EndIf;
			EndIf;
			
			Result.Put(TaskArea);
		EndIf;

	EndDo;
	
	Return Result;
	
EndFunction