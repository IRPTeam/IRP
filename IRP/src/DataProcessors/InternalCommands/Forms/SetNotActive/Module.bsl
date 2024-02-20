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

	CommandProcessingAtServer(Targets, AddInfo);
	
EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	
	If TypeOf(Targets) = Type("Array") Then
		For Each Target In Targets Do
			NotifyChanged(Target);
		EndDo;
	Else
		NotifyChanged(Targets);
	EndIf;
	
	Form.RefreshDataRepresentation();
	
EndProcedure

#EndRegion

#Region PrivateServer

// Command processing at server.
// 
// Parameters:
//  CommandParameter - AnyRef, Array of AnyRef - Command parameter
//  AddInfo - Undefined - Add info
&AtServer
Procedure CommandProcessingAtServer(CommandParameter, AddInfo = Undefined)
	
	If Not ValueIsFilled(CommandParameter) Then
		Return;
	EndIf;
	
	If TypeOf(CommandParameter) = Type("Array") Then
		For Each CommandItem In CommandParameter Do
			ChangeNotActive(CommandItem);
		EndDo;
	Else
		ChangeNotActive(CommandParameter);
	EndIf;
	
EndProcedure

// Change not active.
// 
// Parameters:
//  CommandParameter - AnyRef - Command parameter
&AtServer
Procedure ChangeNotActive(CommandParameter)
	
	CatalogObject = CommandParameter.GetObject();
	CatalogObject.NotActive = Not CatalogObject.NotActive;
	
	CatalogObject.DataExchange.Load = True;
	CatalogObject.Write();
	
EndProcedure

#EndRegion
