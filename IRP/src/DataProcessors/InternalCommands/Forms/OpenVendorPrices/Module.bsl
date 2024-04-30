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
		
	DocumentRef = Targets;

	Filter = New Structure;
	Filter.Insert("ItemKey", GetItemKeyArray(DocumentRef)); // Array of CatalogRef.ItemKeys
	
	FormParameters = New Structure;
	FormParameters.Insert("Filter", Filter);
	FormParameters.Insert("GenerateOnOpen", True);
	
	OpenForm("Report.S1001L_VendorsPrices.Form", 
		FormParameters,
		DocumentRef,
		DocumentRef.UUID(),
		,
		);
	
EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region PrivateServer

&AtServer
Function GetItemKeyArray(DocRef)
	
	If CommonFunctionsClientServer.ObjectHasProperty(DocRef, "ItemList") Then
				
		TempTable = DocRef.ItemList.Unload();
		Array = TempTable.UnloadColumn("ItemKey");
		
		Return Array;
	EndIf;
	
EndFunction

#EndRegion