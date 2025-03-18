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
	TemplateCode = Number(NameParts[1]);
	TemplateRef = Catalogs.PrintFormTemplates.FindByCode(TemplateCode);
	
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
	
	PrintResults = GetPrintResults(Refs, AddInfo);
	If PrintResults.Count() = 0 Then
		Return;
	EndIf;
	
	OpenForm("CommonForm.PrintForm", , Form, String(New UUID()));
	
	For Each PrintParameters In PrintResults Do
		Notify("AddTemplatePrintForm", PrintParameters);
	EndDo; 
	
EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region PrivateServer

// Get print results.
// 
// Parameters:
//  CommandParameter - Array of AnyRef - Command parameter
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array - Get print results
&AtServer
Function GetPrintResults(Refs, AddInfo = Undefined)
	Results = New Array;
	
	//@skip-check statement-type-change, property-return-type, typed-value-adding-to-untyped-collection
	For Each ObjectRef In Refs Do
		ObjectParam = UniversalPrintServer.InitPrintParam(ObjectRef);
		ObjectParam.NameTemplate = CommandDescription.Title;
		ObjectParam.SpreadsheetDoc = Catalogs.PrintFormTemplates.GetPrintForm(TemplateRef, ObjectRef, True);
		Results.Add(ObjectParam);
	EndDo;
	
	Return Results;
EndFunction

#EndRegion
