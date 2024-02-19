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
	
	TableName = StrSplit(CommandFormItem.Name, "_")[1];
	
	TableData = MainAttribute[TableName]; // FormDataCollection
	If TableData.Count() = 0 Then
		Return;
	EndIf;
	
	RowsArray = New Array; // Array of FormDataCollectionItem
	TableItem = Form.Items.Find(TableName); // FormTable
	For Each SelectedRow In TableItem.SelectedRows Do // Number
		TableRecord = TableData.FindByID(SelectedRow);
		If TableData.IndexOf(TableRecord) > 0 Then
			RowsArray.Add(TableRecord);
		EndIf;
	EndDo;
	If RowsArray.Count() = 0 Then
		Return;
	EndIf;
	
	If TableItem.CurrentItem.ReadOnly OR NOT TableItem.CurrentItem.Enabled Then
		Return
	EndIf;
	
	CloneValueAtServer(Form, TableItem.CurrentItem.Name, RowsArray, TableData[0]);
	
EndProcedure

// See InternalCommandsClient.Form_AfterRunning
&AtClient
Procedure AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Private

// Clone value at server.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  ItemName - String - Form item
//  RowsArray - Array of FormDataCollectionItem - Rows array
//  FirstRow - FormDataCollectionItem - First row
&AtServer
Procedure CloneValueAtServer(Form, ItemName, RowsArray, FirstRow)
	
	FormItem = Form.Items.Find(ItemName);
	ColumnName = StrSplit(FormItem.DataPath, ".")[1];
	
	For Each Row In RowsArray Do
		Row[ColumnName] = FirstRow[ColumnName];
	EndDo;
	
EndProcedure

#EndRegion
