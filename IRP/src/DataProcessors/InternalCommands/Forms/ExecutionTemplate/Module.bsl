// @strict-types
// @skip-check module-structure-top-region

#Region FormEventHandlers

// On create at server.
// 
// Parameters:
//  Cancel - Boolean - Cancel
//  StandardProcessing - Boolean - Standard processing
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	TemplateName = StrReplace(Parameters.FullName, "InternalCommand_", "");
	
	NameParts = StrSplit(TemplateName, "_");
	TemplateRef = Catalogs.ExecutionTemplates.FindByCode(Number(NameParts[1]));
	
	CommandDescription = DataProcessors.InternalCommands.GetCommandDescription(TemplateName);
	
EndProcedure

// On open.
// 
// Parameters:
//  Cancel - Boolean - Cancel
&AtClient
Procedure OnOpen(Cancel)
	Cancel = True;
EndProcedure

#EndRegion

#Region Public

// See InternalCommandsClient.Form_BeforeRunning
&AtClient
Procedure BeforeRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

// See InternalCommandsClient.Form_RunCommandAction
&AtClient
Procedure RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	
	Refs = New Array; // Array of AnyRef
	If TypeOf(Targets) = Type("Array") Then
		For Each Target In Targets Do // AnyRef
			Refs.Add(Target);
		EndDo;
	Else
		Refs.Add(Targets);
	EndIf;
	
	Processes = StartExecutionProcesses(Refs, AddInfo);
	For Each ProcessRef In Processes Do
		ShowValue(,ProcessRef);
	EndDo;
	
EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region PrivateServer

// Start execution processes.
// 
// Parameters:
//  Refs - Array of DocumentRef, CatalogRef - Refs
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array of BusinessProcessRef.ExecutionProcesses - Start execution processes
&AtServer
Function StartExecutionProcesses(Refs, AddInfo = Undefined)
	
	Results = New Array; // Array of BusinessProcessRef.ExecutionProcesses
	
	For Each ObjectRef In Refs Do
		
		ProcessRef = BusinessProcesses.ExecutionProcesses.FindStartedProcess(ObjectRef, TemplateRef);
		If ValueIsFilled(ProcessRef) Then
			Results.Add(ProcessRef);
			Continue;
		EndIf;
		
		NewProcess = BusinessProcesses.ExecutionProcesses.CreateBusinessProcess();
		NewProcess.Fill(TemplateRef);
		NewProcess.ExecutionObject = ObjectRef;
		NewProcess.Write();
		NewProcess.Start();
		
		Results.Add(NewProcess.Ref);

	EndDo;
	
	Return Results;
	
EndFunction

#EndRegion
