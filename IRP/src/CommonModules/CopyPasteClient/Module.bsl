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
	If TypeOf(DocRef) = Type("DocumentRef.SalesInvoice") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		RecalculateRowsFromValueArraySI(CurrentColumn, Object, Form, ValueArray);
	ElsIf TypeOf(DocRef) = Type("DocumentRef.SalesOrder") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		RecalculateRowsFromValueArraySO(CurrentColumn, Object, Form, ValueArray);
	ElsIf TypeOf(DocRef) = Type("DocumentRef.PurchaseOrder") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		RecalculateRowsFromValueArrayPO(CurrentColumn, Object, Form, ValueArray);
	ElsIf TypeOf(DocRef) = Type("DocumentRef.PurchaseInvoice") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		RecalculateRowsFromValueArrayPI(CurrentColumn, Object, Form, ValueArray);
	ElsIf TypeOf(DocRef) = Type("DocumentRef.SalesReturn") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		RecalculateRowsFromValueArraySR(CurrentColumn, Object, Form, ValueArray);
	ElsIf TypeOf(DocRef) = Type("DocumentRef.PurchaseReturn") Then
		CurrentColumn = FormItems.ItemList.CurrentItem;
		If CurrentColumn = Undefined Then
			Return
		EndIf;
		RecalculateRowsFromValueArrayPR(CurrentColumn, Object, Form, ValueArray);					
	EndIf;	
EndProcedure

// Recalculate rows from value array SI.
// 
// Parameters:
//  DocumentColumn - FormField - Document column
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  ValueArray - Array - Value array
Procedure RecalculateRowsFromValueArraySI(DocumentColumn, Object, Form, ValueArray)
	CurrentColumn = DocumentColumn;	
	
	CurrentColumnName = CurrentColumn.Name;
	Counter = 0;
	ArraySize = ValueArray.Count();
	 
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
		ElsIf CurrentColumnName = "ItemListQuantity" Then
			Row.Quantity = NewValue;
			DocSalesInvoiceClient.ItemListQuantityOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListTotalAmount" Then
			Row.TotalAmount = NewValue;
			DocSalesInvoiceClient.ItemListTotalAmountOnChange(Object, Form, Undefined, Row);		
		EndIf;	
	EndDo;
EndProcedure

// Recalculate rows from value array SO.
// 
// Parameters:
//  DocumentColumn - FormField - Document column
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  ValueArray - Array - Value array
Procedure RecalculateRowsFromValueArraySO(DocumentColumn, Object, Form, ValueArray)
	CurrentColumn = DocumentColumn;	
	
	CurrentColumnName = CurrentColumn.Name;
	Counter = 0;
	ArraySize = ValueArray.Count();
	 
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
			DocSalesOrderClient.ItemListPriceOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListQuantity" Then
			Row.Quantity = NewValue;
			DocSalesOrderClient.ItemListQuantityOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListTotalAmount" Then
			Row.TotalAmount = NewValue;
			DocSalesOrderClient.ItemListTotalAmountOnChange(Object, Form, Undefined, Row);		
		EndIf;	
	EndDo;
EndProcedure

// Recalculate rows from value array PO.
// 
// Parameters:
//  DocumentColumn - FormField - Document column
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  ValueArray - Array - Value array
Procedure RecalculateRowsFromValueArrayPO(DocumentColumn, Object, Form, ValueArray)
	CurrentColumn = DocumentColumn;	
	
	CurrentColumnName = CurrentColumn.Name;
	Counter = 0;
	ArraySize = ValueArray.Count();
	 
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
			DocPurchaseOrderClient.ItemListPriceOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListQuantity" Then
			Row.Quantity = NewValue;
			DocPurchaseOrderClient.ItemListQuantityOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListTotalAmount" Then
			Row.TotalAmount = NewValue;
			DocPurchaseOrderClient.ItemListTotalAmountOnChange(Object, Form, Undefined, Row);		
		EndIf;	
	EndDo;
EndProcedure		

// Recalculate rows from value array PI.
// 
// Parameters:
//  DocumentColumn - FormField - Document column
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  ValueArray - Array - Value array
Procedure RecalculateRowsFromValueArrayPI(DocumentColumn, Object, Form, ValueArray)
	CurrentColumn = DocumentColumn;	
	
	CurrentColumnName = CurrentColumn.Name;
	Counter = 0;
	ArraySize = ValueArray.Count();
	 
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
			DocPurchaseInvoiceClient.ItemListPriceOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListQuantity" Then
			Row.Quantity = NewValue;
			DocPurchaseInvoiceClient.ItemListQuantityOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListTotalAmount" Then
			Row.TotalAmount = NewValue;
			DocPurchaseInvoiceClient.ItemListTotalAmountOnChange(Object, Form, Undefined, Row);		
		EndIf;	
	EndDo;
EndProcedure

// Recalculate rows from value array SR.
// 
// Parameters:
//  DocumentColumn - FormField - Document column
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  ValueArray - Array - Value array
Procedure RecalculateRowsFromValueArraySR(DocumentColumn, Object, Form, ValueArray)
	CurrentColumn = DocumentColumn;	
	
	CurrentColumnName = CurrentColumn.Name;
	Counter = 0;
	ArraySize = ValueArray.Count();
	 
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
			DocSalesReturnClient.ItemListPriceOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListQuantity" Then
			Row.Quantity = NewValue;
			DocSalesReturnClient.ItemListQuantityOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListTotalAmount" Then
			Row.TotalAmount = NewValue;
			DocSalesReturnClient.ItemListTotalAmountOnChange(Object, Form, Undefined, Row);		
		EndIf;	
	EndDo;
EndProcedure

// Recalculate rows from value array PR.
// 
// Parameters:
//  DocumentColumn - FormField - Document column
//  Object - FormDataStructure - Object
//  Form - ClientApplicationForm - Form
//  ValueArray - Array - Value array
Procedure RecalculateRowsFromValueArrayPR(DocumentColumn, Object, Form, ValueArray)
	CurrentColumn = DocumentColumn;	
	
	CurrentColumnName = CurrentColumn.Name;
	Counter = 0;
	ArraySize = ValueArray.Count();
	 
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
			DocPurchaseReturnClient.ItemListPriceOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListQuantity" Then
			Row.Quantity = NewValue;
			DocPurchaseReturnClient.ItemListQuantityOnChange(Object, Form, Undefined, Row);
		ElsIf CurrentColumnName = "ItemListTotalAmount" Then
			Row.TotalAmount = NewValue;
			DocPurchaseReturnClient.ItemListTotalAmountOnChange(Object, Form, Undefined, Row);	
		EndIf;	
	EndDo;
EndProcedure

#EndRegion
