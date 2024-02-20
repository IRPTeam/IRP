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
	CommandDescription = DataProcessors.InternalCommands.GetCommandDescription(StrSplit(FormName, ".")[3]);
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

// See InternalCommandsClient.Form_RunCommandAction
&AtClient
Procedure RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	CommandProcessingAtClient(Targets, AddInfo);
EndProcedure

#EndRegion

#Region PrivateClient

// Command processing at client.
// 
// Parameters:
//  CommandParameter - AnyRef, Array of AnyRef - Command parameter
//  AddInfo - Undefined - Add info
&AtClient
Procedure CommandProcessingAtClient(CommandParameter, AddInfo = Undefined)
	
	RefsList = New ValueList; // ValueList of AnyRef
	If TypeOf(CommandParameter) = Type("Array") Then
		RefsList.LoadValues(CommandParameter);
	Else
		RefsList.Add(CommandParameter);
	EndIf;
	
	If RefsList.Count() > 0 Then
		FormParameters = New Structure("RefsList, ObjectTable", RefsList, "Ref");
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.Form", FormParameters);
	EndIf;
	
EndProcedure

#EndRegion
