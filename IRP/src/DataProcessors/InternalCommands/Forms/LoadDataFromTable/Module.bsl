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
	
	TableForLoading = "";
	CommandNameParts = StrSplit(CommandFormItem.CommandName, "_");
	If CommandNameParts.Count() = 3 Then
		TableForLoading = CommandNameParts[1];
	EndIf;
	
	AddInfoNotify = New Structure;
	AddInfoNotify.Insert("FormObject",      Form);
	AddInfoNotify.Insert("DocumentObject",  MainAttribute);
	AddInfoNotify.Insert("TableForLoading", TableForLoading);
	NotifyContext = ?(Form[CommandFormItem.CommandName + "_UseFormNotify"] = True, Form, ThisObject);
	EndNotify = New NotifyDescription(Form[CommandFormItem.CommandName + "_EndNotify"], NotifyContext, AddInfoNotify);
	
	FormParameters = New Structure;
	FormParameters.Insert("FieldsForLoadData", Form[CommandFormItem.CommandName + "_Fields"]);
	FormParameters.Insert("TargetField", Form[CommandFormItem.CommandName + "_Target"]);
	
	OpenForm("DataProcessor.InternalCommands.Form.LoadDataFromTable_Form", FormParameters, Form, , , , EndNotify);

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

// Load data from table end.
// 
// Parameters:
//  Result - See GetLoadDataDescription
//  AddInfo - Structure - Add info:
//	* FormObject - ClientApplicationForm - Form
//	* DocumentObject - DocumentObjectDocumentName - Document object
//	* TableForLoading - String - Table for loading
&AtClient
Procedure LoadDataFromTableEnd_Document_PriceList(Result, AddInfo) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	DataTable = GetTableByAddress(Result.Address);
	For Each TableRow In DataTable Do
		DocumentTable = AddInfo.DocumentObject[AddInfo.TableForLoading]; // See Document.PriceList.ItemList
		NewRecord = DocumentTable.Add();
		FillPropertyValues(NewRecord, TableRow);
		NewRecord.InputUnit = NewRecord.Unit;
	EndDo;
	
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

#Region PrivateServer

// Get table by address.
// 
// Parameters:
//  Address - String - Address
// 
// Returns:
//  Array of Structure - Get table by address
&AtServerNoContext
Function GetTableByAddress(Address)
	
	DataTable = GetFromTempStorage(Address); // ValueTable

	Return CommonFunctionsServer.GetTableForClient(DataTable);
	
EndFunction

#EndRegion
