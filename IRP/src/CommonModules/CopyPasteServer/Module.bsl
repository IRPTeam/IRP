// @strict-types

#Region FORM

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
	
	CommandForm = Form.Commands.Add("PasteFromClipboard");
	CommandForm.Title = R().CP_002;
	CommandForm.Action = "PasteFromClipboard";
	CommandButton = Form.Items.Add("PasteFromClipboard", Type("FormButton"), Form.CommandBar);
	CommandButton.CommandName = "PasteFromClipboard";
	
EndProcedure

#EndRegion

#Region COPY

// Copy to clipboard.
// 
// Parameters:
//  Object - DocumentObjectDocumentName, DocumentObject.SalesInvoice - Object
//  Form - See Document.SalesInvoice.Form.DocumentForm
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
	Result.CopySettings = CopySettings;
	Result.SourceRef = Object.Ref;
	If Not Form.CurrentItem.DataPath = "Object.ItemList" Then
		Result.isError = True;
		Result.Message = StrTemplate(R().CP_003, Object.Ref.Metadata().TabularSections.ItemList.Synonym);
		Return Result;
	EndIf;
	
	For Each TabularSection In Object.Ref.Metadata().TabularSections Do
		If TabularSection.Attributes.Find("Key") = Undefined Then
			Continue;
		EndIf;
	
		Result.Data.Insert(TabularSection.Name, Object[TabularSection.Name].Unload(New Array));
	EndDo;
	
	For Each RowIndex In Form.CurrentItem.SelectedRows Do
		RowKey = Form.Object.ItemList.FindByID(RowIndex).Key;
		
		For Each Table In Result.Data Do
			
			For Each TableRow In Object.ItemList.FindRows(New Structure("Key", RowKey)) Do
				FillPropertyValues(Table.Value.Add(), TableRow);
			EndDo;
		EndDo;
	EndDo;
	
	Result.Message = StrTemplate(R().CP_006, Form.CurrentItem.SelectedRows.Count());	
	
	Return Result;
EndFunction

#EndRegion

#Region PASTE

// Paste from clipboard.
// 
// Parameters:
//  Object - DocumentObjectDocumentName - Object
//  Form - ClientApplicationForm - Form
//  PasteSettings - See CopyPasteClient.PasteSettings
// 
// Returns:
//  See BufferSettings
Function PasteFromClipboard(Object, Form, PasteSettings) Export
	Data = SessionParameters.Buffer.Get(); // Array Of See BufferSettings
	If Data.Count() = 0 Then
		Return False;
	EndIf;
	Index = Data.UBound();
	BufferData = Data[Index]; // See BufferSettings
	Data.Delete(Index);
	
	If BufferData.CopySettings.CopySelectedRows Then
		PasteSelectedRows(Object, Form, BufferData, PasteSettings);
	EndIf;
	
	SessionParameters.Buffer = New ValueStorage(Data, New Deflation(9));
	
	Return True;
EndFunction

Function PasteSelectedRows(Object, Form, BufferData, PasteSettings) Export
	CurrentObject = Form.FormAttributeToValue("Object"); // DocumentObjectDocumentName
	DocInfo = New Structure;
	DocInfo.Insert("DocMetadata", Object.Ref.Metadata());
	DocInfo.Insert("DocObject", CurrentObject);
	Wrapper = BuilderAPI.Initialize(, , , , DocInfo);
	
	For Each ItemRow In BufferData.Data.ItemList Do
		
		NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
		
		For Each Property In ColumnNameToPaste() Do
			BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
		EndDo;
		
	EndDo;
	BuilderAPI.Write(Wrapper, , , CurrentObject);
	Form.ValueToFormAttribute(CurrentObject, "Object");
	
	Return True;
EndFunction

#EndRegion

#Region SERVICE

Function ColumnNameToPaste()
	Array = New Array; // Array of String
	
	Array.Add("Item");
	Array.Add("ItemKey");
	Array.Add("Quantity");
	Array.Add("Unit");
	
	Return Array;
EndFunction

// Buffer settings.
// 
// Returns:
//  Structure - Buffer settings:
// * SourceName - String -
// * SourceRef - Undefined, DocumentRefDocumentName -
// * Data - Structure:
// ** ItemList - ValueTable
// * CopySettings - See CopyPasteClient.CopySettings
// * isError - Boolean -
// * Message - String -
Function BufferSettings() Export
	Str = New Structure;
	Str.Insert("SourceName", "");
	Str.Insert("SourceRef", Undefined);
	Str.Insert("Data", New Structure);
	Str.Insert("CopySettings", New Structure());
	Str.Insert("isError", False);
	Str.Insert("Message", "");
	Return Str;
EndFunction

#EndRegion
