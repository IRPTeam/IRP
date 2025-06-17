
Procedure OnWrite_ExecutionObjectOnWrite(Source, Cancel) Export
	
	ObjectTypeRef = CatConfigurationMetadataServer.GetConfigurationMetadataItemByObject(Source);
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ExecutionTemplatesExecutionObjects.Ref
	|FROM
	|	Catalog.ExecutionTemplates.ExecutionObjects AS ExecutionTemplatesExecutionObjects
	|WHERE
	|	ExecutionTemplatesExecutionObjects.ObjectType = &ObjectType
	|	AND ExecutionTemplatesExecutionObjects.Ref.ReadyToStartProcesses
	|	AND ExecutionTemplatesExecutionObjects.AutostartProcesses = VALUE(Enum.AutostartProcessTypes.WhenCreating)";
	
	Query.SetParameter("ObjectType", ObjectTypeRef);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ProcessRef = BusinessProcesses.ExecutionProcesses.FindStartedProcess(Source.Ref, QuerySelection.Ref);
		If ValueIsFilled(ProcessRef) Then
			Continue;
		EndIf;
		
		NewProcess = BusinessProcesses.ExecutionProcesses.CreateBusinessProcess();
		NewProcess.Fill(QuerySelection.Ref);
		NewProcess.ExecutionObject = Source.Ref;
		NewProcess.Write();
		NewProcess.Start();
	EndDo;
	
EndProcedure

Procedure OnPosting_ExecutionObjectPosting(Source, Cancel, PostingMode) Export
	
	ObjectTypeRef = CatConfigurationMetadataServer.GetConfigurationMetadataItemByObject(Source);
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ExecutionTemplatesExecutionObjects.Ref
	|FROM
	|	Catalog.ExecutionTemplates.ExecutionObjects AS ExecutionTemplatesExecutionObjects
	|WHERE
	|	ExecutionTemplatesExecutionObjects.ObjectType = &ObjectType
	|	AND ExecutionTemplatesExecutionObjects.Ref.ReadyToStartProcesses
	|	AND ExecutionTemplatesExecutionObjects.AutostartProcesses = VALUE(Enum.AutostartProcessTypes.WhenPosting)";
	
	Query.SetParameter("ObjectType", ObjectTypeRef);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ProcessRef = BusinessProcesses.ExecutionProcesses.FindStartedProcess(Source.Ref, QuerySelection.Ref);
		If ValueIsFilled(ProcessRef) Then
			Continue;
		EndIf;
		
		NewProcess = BusinessProcesses.ExecutionProcesses.CreateBusinessProcess();
		NewProcess.Fill(QuerySelection.Ref);
		NewProcess.ExecutionObject = Source.Ref;
		NewProcess.Write();
		NewProcess.Start();
	EndDo;
	
EndProcedure

