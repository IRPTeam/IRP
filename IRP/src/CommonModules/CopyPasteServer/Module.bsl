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
	ItemListForm = Form.Items.Find("ItemList");
	If ItemListForm = Undefined Then
		Return;
	EndIf;
	
	CommandGroup = Form.Items.Add("CopyPasteGroup", Type("FormGroup"), ItemListForm.CommandBar); // FormGroupExtensionForAButtonGroup
	CommandGroup.Type = FormGroupType.ButtonGroup;
	CommandGroup.Representation = ButtonGroupRepresentation.Compact;
	
	CommandForm = Form.Commands.Add("CopyToClipboard");
	CommandForm.Title = R().CP_001;
	CommandForm.ToolTip = R().CP_001;
	CommandForm.Representation = ButtonRepresentation.Picture;
	CommandForm.Picture = PictureLib.CopyRowsToClipboard;
	CommandForm.Action = "CopyToClipboard";
	CommandButton = Form.Items.Add("CopyToClipboard", Type("FormButton"), CommandGroup); // FormButton
	CommandButton.CommandName = "CopyToClipboard";
	
	CommandForm = Form.Commands.Add("PasteFromClipboard");
	CommandForm.Title = R().CP_002;
	CommandForm.ToolTip = R().CP_002;
	CommandForm.Representation = ButtonRepresentation.Picture;
	CommandForm.Picture = PictureLib.PasteRowsFromClipboard;
	CommandForm.Action = "PasteFromClipboard";
	CommandButton = Form.Items.Add("PasteFromClipboard", Type("FormButton"), CommandGroup);
	CommandButton.CommandName = "PasteFromClipboard";
	CommandButton.Title = R().CP_002;
	
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
	Data.Clear();
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
			
			For Each TableRow In Object[Table.Key].FindRows(New Structure("Key", RowKey)) Do
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
//  See PasteResult
Function PasteFromClipboard(Object, Form, PasteSettings) Export
	
	PasteResult = PasteResult();
	
	Data = SessionParameters.Buffer.Get(); // Array Of See BufferSettings
	If Data.Count() = 0 Then
		Return PasteResult;
	EndIf;
	Index = Data.UBound();
	BufferData = Data[Index]; // See BufferSettings
	
	If BufferData.CopySettings.CopySelectedRows Then
		PasteResult = PasteSelectedRows(Object, Form, BufferData, PasteSettings);
	EndIf;
	Data.Clear();
	
	SessionParameters.Buffer = New ValueStorage(Data, New Deflation(9));
	
	Form.Modified = True;
	
	Return PasteResult;
EndFunction

Function PasteSelectedRows(Object, Form, BufferData, PasteSettings) Export
	CurrentObject = Form.FormAttributeToValue("Object"); // DocumentObjectDocumentName, DocumentObject.SalesInvoice
	DocInfo = New Structure;
	DocInfo.Insert("DocMetadata", Object.Ref.Metadata());
	DocInfo.Insert("DocObject", CurrentObject);
	Wrapper = BuilderAPI.Initialize(, , , , DocInfo);
	
	ItemList = BufferData.Data.ItemList;
	Result = PasteResult();
	For Each ItemRow In ItemList Do
		
		NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
		
		For Each Property In ColumnNameToPaste() Do
			BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
		EndDo;
		
		If Not Wrapper.Tables.Property("SerialLotNumbers") Then
			Result.SerialLotNumbers = Undefined; 
		ElsIf BufferData.Data.Property("SerialLotNumbers") Then
			SerialLotNumbers = BufferData.Data.SerialLotNumbers;
			Serials = SerialLotNumbers.FindRows(New Structure("Key", ItemRow.Key));
			
			If Serials.Count() Then
				SerialSetting = SerialLotNumbersServer.FillSettingsAddNewSerial();
				SerialSetting.Item = ItemRow.Item;
				SerialSetting.ItemKey = ItemRow.ItemKey;
				SerialSetting.RowKey = NewItemRow.Key;
				For Each Serial In Serials Do
					NewSerial = New Structure;
					NewSerial.Insert("SerialLotNumber", Serial.SerialLotNumber);
					NewSerial.Insert("Quantity", Serial.Quantity);
					SerialSetting.SerialLotNumbers.Add(NewSerial);
				EndDo;
				Result.SerialLotNumbers.Add(SerialSetting);
			EndIf;
		EndIf;
	EndDo;
	BuilderAPI.Write(Wrapper, , , CurrentObject);
	Form.ValueToFormAttribute(CurrentObject, "Object");
	
	Return Result;
EndFunction

#EndRegion

#Region SERVICE

// Paste result.
// 
// Returns:
//  Structure - Paste result:
// * SerialLotNumbers - Array of See SerialLotNumbersServer.FillSettingsAddNewSerial
Function PasteResult() Export
	Str = New Structure;
	Str.Insert("SerialLotNumbers", New Array);
	Return Str;
EndFunction

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
// ** ItemList - See Document.SalesInvoice.ItemList
// ** SerialLotNumbers - See Document.SalesInvoice.SerialLotNumbers
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
