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

	NumeratorItem = Form.Items.Find("NumeratorRules");
	If NumeratorItem <> Undefined Then
		NumeratorItem.Visible = Not CommandFormItem.Check;
	EndIf;
	
EndProcedure

#EndRegion

#Region PrivateServer

#EndRegion
