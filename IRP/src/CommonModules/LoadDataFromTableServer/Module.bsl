// @strict-types

#Region FORM

// Create commands.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  ObjectMetadata - MetadataObject - Object Metadata
//  FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
Procedure CreateCommands(Form, ObjectMetadata, FormType, AddInfo = Undefined) Export
	
	If Not FormType = Enums.FormTypes.ObjectForm Then
		Return;
	EndIf;
	
	ItemListForm = Form.Items.Find("ItemList");
	If ItemListForm = Undefined Then
		Return;
	EndIf;
	
	CommandForm = Form.Commands.Add("LoadDataFromTable");
	CommandForm.Representation = ButtonRepresentation.Picture;
	CommandForm.Picture = PictureLib.SpreadsheetShowGrid;
	CommandForm.Action = "LoadDataFromTable";
	
	R().Property("LDT_Button_Title",   CommandForm.Title);
	R().Property("LDT_Button_ToolTip", CommandForm.ToolTip);
	
	CommandButton = Form.Items.Add("ItemListLoadDataFromTable", Type("FormButton"), ItemListForm.CommandBar); // FormButton
	CommandButton.CommandName = "LoadDataFromTable";
	
EndProcedure

#EndRegion