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
	If ItemListForm = Undefined 
		Or Not Form.Items.Find("CopyPasteGroup") = Undefined Then // When recal create on server, ex. POS
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
	
	CommandForm = Form.Commands.Add("PasteFromClipboardValues");
	CommandForm.Title = R().CP_007;
	CommandForm.ToolTip = R().CP_007;
	CommandForm.Representation = ButtonRepresentation.Picture;
	CommandForm.Picture = PictureLib.PasteValuesFromClipboard;
	CommandForm.Action = "PasteFromClipboardValues";
	CommandButton = Form.Items.Add("PasteFromClipboardValues", Type("FormButton"), CommandGroup);
	CommandButton.CommandName = "PasteFromClipboardValues";
	CommandButton.Title = R().CP_007;
	
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
	
		//@skip-check dynamic-access-method-not-found
		Result.Data.Insert(TabularSection.Name, Object[TabularSection.Name].Unload(New Array));
	EndDo;
	
	For Each RowIndex In Form.CurrentItem.SelectedRows Do // Number
		RowKey = Form.Object.ItemList.FindByID(RowIndex).Key;
		
		For Each Table In Result.Data Do
			
			//@skip-check dynamic-access-method-not-found
			For Each TableRow In Object[Table.Key].FindRows(New Structure("Key", RowKey)) Do // ValueTableRow
				FillPropertyValues(Table.Value.Add(), TableRow);
			EndDo;
		EndDo;
	EndDo;
	
	// Rename Quantity column
	//@skip-check property-return-type
	Result.Data.ItemList.Columns[CopySettings.CopyQuantityAs].Name = "Quantity";
	
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
		PasteResult.SerialLotNumbers = Undefined;
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
	
	SourceHasTableSLN = BufferData.Data.Property("SerialLotNumbers");
	TargetHasTableSLN = Wrapper.Tables.Property("SerialLotNumbers");
	
	//@skip-check property-return-type, dynamic-access-method-not-found
	SourceHasSLNInItemList = Not BufferData.Data.ItemList.Columns.Find("SerialLotNumber") = Undefined;
	//@skip-check property-return-type, dynamic-access-method-not-found
	TargetHasSLNInItemList = Wrapper.Tables.ItemList.Property("SerialLotNumber"); // Boolean
	
	For Each ItemRow In ItemList Do
		If SourceHasTableSLN And TargetHasTableSLN Then
			SourceAndTargetHasTableSLN(BufferData, ItemRow, Wrapper, Result, PasteSettings);
		ElsIf SourceHasTableSLN And TargetHasSLNInItemList Then
			SourceHasSLNTableAndTargetHasSLNInItemList(BufferData, ItemRow, Wrapper, PasteSettings);
		ElsIf SourceHasSLNInItemList And TargetHasTableSLN Then
			SourceHasSLNInItemListAndTargetHasTableSLN(BufferData, ItemRow, Wrapper, Result);
		ElsIf SourceHasSLNInItemList And TargetHasSLNInItemList Then
			CopyAsIsItemListWithSLN(BufferData, ItemRow, Wrapper, PasteSettings);
		Else
			CopyAsIsItemList(BufferData, ItemRow, Wrapper, PasteSettings);
		EndIf;
	EndDo;
	
	If Not TargetHasTableSLN Then
		Result.SerialLotNumbers = Undefined;
	EndIf;
	
	BuilderAPI.Write(Wrapper, , , CurrentObject);
	Form.ValueToFormAttribute(CurrentObject, "Object");
	
	Return Result;
EndFunction

Procedure SourceHasSLNInItemListAndTargetHasTableSLN(BufferData, ItemRow, Wrapper, Result)
	NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
	
	For Each Property In ColumnNameToPaste() Do
		BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
	EndDo;
	
	//@skip-check property-return-type, unknown-method-property
	SLN = ItemRow.SerialLotNumber; // CatalogRef.SerialLotNumbers
	If Not SLN.isEmpty() Then
		SerialSetting = SerialLotNumbersServer.FillSettingsAddNewSerial();
		SerialSetting.Item = ItemRow.Item;
		SerialSetting.ItemKey = ItemRow.ItemKey;
		SerialSetting.RowKey = NewItemRow.Key;
		NewSerial = New Structure;
		NewSerial.Insert("SerialLotNumber", SLN);
		NewSerial.Insert("Quantity", ItemRow.Quantity);
		SerialSetting.SerialLotNumbers.Add(NewSerial);
		Result.SerialLotNumbers.Add(SerialSetting);
	EndIf;
EndProcedure

Procedure SourceAndTargetHasTableSLN(BufferData, ItemRow, Wrapper, Result, PasteSettings)
	NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
	
	For Each Property In ColumnNameToPaste() Do
		BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
	EndDo;
	
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
EndProcedure

Procedure CopyAsIsItemListWithSLN(BufferData, ItemRow, Wrapper, PasteSettings)
	NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
	
	For Each Property In ColumnNameToPaste() Do
		BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
	EndDo;
	BuilderAPI.SetRowProperty(Wrapper, NewItemRow, PasteSettings.PasteQuantityAs, ItemRow.Quantity, "ItemList");
	//@skip-check property-return-type, unknown-method-property
	BuilderAPI.SetRowProperty(Wrapper, NewItemRow, "SerialLotNumber", ItemRow.SerialLotNumber, "ItemList");
EndProcedure

Procedure CopyAsIsItemList(BufferData, ItemRow, Wrapper, PasteSettings)
	NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
	
	For Each Property In ColumnNameToPaste() Do
		BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
	EndDo;
	BuilderAPI.SetRowProperty(Wrapper, NewItemRow, PasteSettings.PasteQuantityAs, ItemRow.Quantity, "ItemList");
EndProcedure

Procedure SourceHasSLNTableAndTargetHasSLNInItemList(BufferData, ItemRow, Wrapper, PasteSettings)
	SerialLotNumbers = BufferData.Data.SerialLotNumbers;
	Serials = SerialLotNumbers.FindRows(New Structure("Key", ItemRow.Key));
	If Serials.Count() Then	
		For Each Serial In Serials Do
			NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
			For Each Property In ColumnNameToPaste() Do
				BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
			EndDo;
			BuilderAPI.SetRowProperty(Wrapper, NewItemRow, "SerialLotNumber", Serial.SerialLotNumber, "ItemList");
			BuilderAPI.SetRowProperty(Wrapper, NewItemRow, PasteSettings.PasteQuantityAs, Serial.Quantity, "ItemList");
		EndDo;
	Else
		NewItemRow = BuilderAPI.AddRow(Wrapper, "ItemList");
		For Each Property In ColumnNameToPaste() Do
			BuilderAPI.SetRowProperty(Wrapper, NewItemRow, Property, ItemRow[Property], "ItemList");
		EndDo;
		BuilderAPI.SetRowProperty(Wrapper, NewItemRow, PasteSettings.PasteQuantityAs, ItemRow.Quantity, "ItemList");
	EndIf;
EndProcedure

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

Function ColumnNameToPaste() Export
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
