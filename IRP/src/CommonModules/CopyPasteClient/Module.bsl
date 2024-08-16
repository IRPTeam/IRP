// @strict-types

#Region COPY

// Copy to clipboard.
// 
// Parameters:
//  Object - DocumentObjectDocumentName, DataProcessorObjectDataProcessorName - Object
//  Form - ClientApplicationForm - Form
Procedure CopyToClipboard(Object, Form) Export
	//@skip-check wrong-string-literal-content
	Notify = New NotifyDescription("CopyToClipboardAfterSetSettings", Form);
	OpenSettings = New Structure;
	If Not Object = Undefined Then
		//@skip-check unknown-method-property
		OpenSettings.Insert("Ref", Object.Ref);
	EndIf;
	OpenSettings.Insert("CopySettings", CopySettings());
	OpenForm("CommonForm.CopyToClipboardSettings", OpenSettings, Form, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

// Copy settings.
// 
// Returns:
//  Structure - Copy settings:
// * CopySelectedRows - Boolean -
// * CopyQuantityAs - String -
Function CopySettings() Export
	
	Str = New Structure;
	Str.Insert("CopySelectedRows", True);
	Str.Insert("CopyQuantityAs", "Quantity");
	Return Str;
EndFunction

// After copy.
// 
// Parameters:
//  CopyPastResult - See CopyPasteServer.BufferSettings
Procedure AfterCopy(CopyPastResult) Export
	If CopyPastResult.isError And IsBlankString(CopyPastResult.Message) Then
		Return;
	EndIf;
	
	If Not CopyPastResult.isError Then
		Status(R().CP_004, , CopyPastResult.Message, PictureLib.AppearanceFlagGreen);
	Else
		Status(R().CP_005, , CopyPastResult.Message, PictureLib.AppearanceFlagRed);
	EndIf;
EndProcedure

#EndRegion

#Region PASTE

// Paste from clipboard.
// 
// Parameters:
//  Object - DocumentObjectDocumentName, Undefined - Object
//  Form - ClientApplicationForm - Form
Procedure PasteFromClipboard(Object, Form) Export
	//@skip-check wrong-string-literal-content
	Notify = New NotifyDescription("PasteFromClipboardAfterSetSettings", Form);
	OpenSettings = New Structure;
	If Not Object = Undefined Then
		//@skip-check unknown-method-property
		OpenSettings.Insert("Ref", Object.Ref);
	EndIf;
	OpenSettings.Insert("PasteSettings", PasteSettings());
	OpenForm("CommonForm.PasteFromClipboardSettings", OpenSettings, Form, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

// Paste settings.
// 
// Returns:
//  Structure:
//  * PasteQuantityAs - String -
Function PasteSettings() Export
	
	Str = New Structure;
	Str.Insert("PasteQuantityAs", "Quantity");
	Return Str;
	
EndFunction

// After paste.
// 
// Parameters:
//  Object - DocumentObjectDocumentName - Object
//  Form - ClientApplicationForm - Form
//  CopyPastResult - See CopyPasteServer.PasteResult
Procedure AfterPaste(Object, Form, CopyPastResult) Export
	OpeningParameter = New Structure("Object, Form, AddInfo", Object, Form, Undefined);
	SerialLotNumberClient.OnFinishEditSerialLotNumbers(CopyPastResult.SerialLotNumbers, OpeningParameter);
EndProcedure

// Text from clip board.
// 
// Parameters:
//  DataFormat  - ClipboardDataStandardFormat
//  DefaultValue - Arbitrary
// 
// Returns:
//  Promise - Text from clip board
Async Function TextFromClipBoard(DataFormat, DefaultValue = Undefined) Export
	
    If ClipboardTools.CanUse() Then
        If Await ClipboardTools.ContainsDataAsync(DataFormat) Then
            Return Await ClipboardTools.GetDataAsync(DataFormat);
        EndIf;
    EndIf;	
    Return DefaultValue;
		
EndFunction	

#EndRegion

#Region PasteValuesIntoDocs
// Recalculate rows by new values.
// 
// Parameters:
//  Object - FormDataStructure
//  Form - ClientApplicationForm
//  ClipBoardText - String
Procedure RecalculateRowsByNewValues(Object, Form, ClipBoardText) Export
	//@skip-check property-return-type
	//@skip-check variable-value-type
	DocRef = Object.Ref;
	FormItems = Form.Items;
	ValueArray = StrSplit(ClipBoardText, Chars.LF, False);
	ArraySize = ValueArray.Count();
	If TypeOf(DocRef) = Type("DocumentRef.SalesInvoice") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		CurrentColumnName = CurrentColumn.Name;
		Counter = 0;
		 
		//@skip-check property-return-type
		//@skip-check variable-value-type
		For Each Row In Object.ItemList Do
			Counter = Counter + 1;
			If Counter > ArraySize Then
				Break;	
			EndIf;
			NewValue = ValueArray[Counter - 1];
			If CurrentColumnName = "ItemListPrice" Then
				Row.Price = NewValue;
				DocSalesInvoiceClient.ItemListPriceOnChange(Object, Form, Undefined, Row);
			EndIf;	
		EndDo;			
	EndIf;	 
	
EndProcedure	

#EndRegion
