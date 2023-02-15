// @strict-types

// Create commands.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  ObjectFullName - String - Object full name
//  FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
Procedure CreateCommands(Form, ObjectFullName, FormType, AddInfo = Undefined) Export
	
	If Form.Items.Find("ItemList") = Undefined Then
		Return;
	EndIf;
	
	CommandForm = Form.Commands.Add("CopyToClipboard");
	CommandForm.Title = R().CP_001;
	CommandForm.Action = "CopyToClipboard";
	CommandButton = Form.Items.Add("CopyToClipboard", Type("FormButton"), Form.CommandBar);
	CommandButton.CommandName = "CopyToClipboard";
EndProcedure


// Copy to clipboard.
// 
// Parameters:
//  Object - DocumentObjectDocumentName - Object
//  Form - ClientApplicationForm - Form
//  CopySettings - See CopyPasteClient.CopySettings
// 
// Returns:
//  See BufferSettings
Function CopyToClipboard(Object, Form, CopySettings) Export
	Result = Undefined;
	If CopySettings.CopySelectedRows Then
		Result = CopySelectedRows(Object, Form, CopySettings); 
	EndIf;
	
	If Result = Undefined Then
		Result = BufferSettings();
		Result.isError = True;
		Return Result;
	EndIf;
	
	If Result.isError Then
		Return Result;
	EndIf;

	Data = SessionParameters.Buffer.Get(); // Array Of See BufferSettings
	Data.Add(Result);
	SessionParameters.Buffer = New ValueStorage(Data, New Deflation(9));
	Result.Data = Undefined;
	
	Return Result;
EndFunction

Function CopySelectedRows(Object, Form, CopySettings) Export
	Result = BufferSettings();
	If Not Form.CurrentItem.DataPath = "Object.ItemList" Then
		Result.isError = True;
		Result.Message = StrTemplate(R().CP_003, Object.Ref.Metadata().TabularSections.ItemList.Synonym);
		Return Result;
	EndIf;
	
	Result.Message = StrTemplate(R().CP_006, Form.CurrentItem.SelectedRows.Count());	
	
	Return Result;
EndFunction


// Buffer settings.
// 
// Returns:
//  Structure - Buffer settings:
// * SourceName - String -
// * Data - String -
// * CopySettings - See CopyPasteClient.CopySettings
// * isError - Boolean -
// * Message - String -
Function BufferSettings() Export
	Str = New Structure;
	Str.Insert("SourceName", "");
	Str.Insert("Data", "");
	Str.Insert("CopySettings", New Structure());
	Str.Insert("isError", False);
	Str.Insert("Message", "");
	Return Str;
EndFunction
