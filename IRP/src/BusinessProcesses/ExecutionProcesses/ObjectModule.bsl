
Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If TypeOf(FillingData) = Type("CatalogRef.ExecutionTemplates") Then
		StandardProcessing = False;
		
		ThisObject.Template = FillingData;
		ThisObject.ExecutionStages.Load(FillingData.ExecutionStages.Unload());
		ThisObject.StagesTasks.Load(FillingData.StagesTasks.Unload());
	EndIf;

EndProcedure

Procedure CompleteTasksBeforeCreateTasks(RoutePoint, TasksBeingFormed, StandardProcessing)
	//TODO: Insert the handler content
EndProcedure

Procedure CheckTasksCompletedConditionCheck(RoutePoint, Result)
	//TODO: Insert the handler content
EndProcedure

Procedure CompletionOnComplete(RoutePoint, Cancel)
	//TODO: Insert the handler content
EndProcedure
