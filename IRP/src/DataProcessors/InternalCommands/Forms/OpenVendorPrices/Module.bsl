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

// See InternalCommandsClient.Form_BeforeRunning
&AtClient
Procedure BeforeRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

// See InternalCommandsClient.Form_RunCommandAction
&AtClient
Procedure RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	
		Filter = New Structure("ItemKey, Partner");
		Filter.ItemKey = GetItemKeyArray(CommandParameter);
		Filter.Partner = CommonFunctionsServer.GetRefAttribute(CommandParameter, "Partner");
		
		FormParameters = New Structure;
		FormParameters.Insert("Filter", Filter);
		FormParameters.Insert("GenerateOnOpen", True);
		
		OpenForm("Report.S1001L_VendorsPrices.Form", 
			FormParameters,
			CommandExecuteParameters.Source,
			CommandExecuteParameters.Uniqueness,
			CommandExecuteParameters.Window,
			CommandExecuteParameters.URL);

	
	
EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
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
	Return;
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
	Return;
EndProcedure

#EndRegion
