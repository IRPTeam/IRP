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
	
	Var EndNotify; 			// NotifyDescription
	Var TargetField; 		// FormAttribute
	Var FieldsForLoadData; 	// FormAttribute
	
	If TypeOf(AddInfo) = Type("Structure") Then
		AddInfo.Property("FieldsForLoadData", FieldsForLoadData);
		AddInfo.Property("TargetField", TargetField);
		AddInfo.Property("EndNotify", EndNotify);
	EndIf;
	
	If FieldsForLoadData = Undefined Then
		//@skip-check wrong-string-literal-content
		FieldsForLoadData = Form["_FieldsForLoadData"];
	EndIf;
	If EndNotify = Undefined Then
		AddInfoNotify = New Structure;
		AddInfoNotify.Insert("FormObject",     Form);
		AddInfoNotify.Insert("DocumentObject", MainAttribute);
		EndNotify = New NotifyDescription("LoadDataFromTableEnd", ThisObject, AddInfoNotify);
	EndIf;
	
	FormParameters = New Structure;
	FormParameters.Insert("FieldsForLoadData", FieldsForLoadData);
	If TargetField <> Undefined Then
		FormParameters.Insert("TargetField", TargetField);
	EndIf;
	
	OpenForm("CommonForm.LoadDataFromTable", FormParameters, Form, , , , EndNotify);

EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region PrivateClient

// Load data from table end.
// 
// Parameters:
//  Result - See GetLoadDataDescription
//  AddInfo - Structure - Add info:
//	* FormObject - ClientApplicationForm - Form
//	* DocumentObject - DocumentObjectDocumentName - Document object
&AtClient
Procedure LoadDataFromTableEnd(Result, AddInfo) Export
	
	If Not Result = Undefined Then
		ViewClient_V2.ItemListLoad(
			AddInfo.DocumentObject, 
			AddInfo.FormObject, 
			Result.Address, 
			Result.GroupColumns, 
			Result.SumColumns);
	EndIf;
	
EndProcedure

// Get load data description.
// 
// Returns:
//  Structure - Get load data description:
// * Address - String -
// * GroupColumns - String -
// * SumColumns - String -
&AtClient
Function GetLoadDataDescription() Export
	
	Result = New Structure;
	Result.Insert("Address", "");
	Result.Insert("GroupColumns", "Item, ItemKey, Unit"); // See ControllerServer_V2.GetServerData
	Result.Insert("SumColumns", "Quantity");
	
	Return Result;
	
EndFunction

#EndRegion
