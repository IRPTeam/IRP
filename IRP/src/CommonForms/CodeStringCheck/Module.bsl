// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Hardware = Parameters.Hardware;
	Item = Parameters.Item;
	ItemKey = Parameters.ItemKey;
	LineNumber = Parameters.LineNumber;
	RowKey = Parameters.RowKey;
EndProcedure

&AtClient
//@skip-check property-return-type, dynamic-access-method-not-found, statement-type-change
Procedure OnOpen(Cancel)
	For Each Row In FormOwner.Object.ControlCodeStrings.FindRows(New Structure("Key", RowKey)) Do
		NewRow = CurrentCodes.Add();
		NewRow.StringCode = Row.CodeString;
		NewRow.CodeIsApproved = Row.CodeIsApproved;
	EndDo;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	//@skip-check invocation-parameter-type-intersect
	DocumentsClient.SearchByBarcode(Barcode, New Structure, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

// Parameters:
//  Result - See BarcodeServer.SearchByBarcodes
//  AdditionalParameters - Structure - Additional parameters
&AtClient
Async Procedure SearchByBarcodeEnd(Result, AdditionalParameters = Undefined) Export

	ArrayOfCodeStrings = New Array; // Array Of String
	ArrayOfApprovedCodeStrings = New Array; // Array Of String
	For Each Row In Result.FoundedItems Do
		
		If Not Row.Item = Item Or Row.ItemKey = ItemKey Then
			Descr = String(Row.Item) + "[" + Row.ItemKey + "]";
			//@skip-check property-return-type, invocation-parameter-type-intersect
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().POS_Error_ThisBarcodeFromAnotherItem, Descr));
		EndIf;

		ArrayOfCodeStrings.Add(Row.Barcode);
	EndDo;

	For Each Row In Result.Barcodes Do
		ArrayOfCodeStrings.Add(Row);
	EndDo;
	
	For Each StrCode In ArrayOfCodeStrings Do
		If CheckCodeString(StrCode) Then
			ArrayOfApprovedCodeStrings.Add(StrCode);
		Else
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().POS_Error_ThisIsNotControleStringBarcode, StrCode));
		EndIf;
	EndDo;
	
	For Each StringCode In ArrayOfApprovedCodeStrings Do // String
		NewRow = CurrentCodes.Add();
		NewRow.StringCode = StringCode;
		
		RequestKMSettings = EquipmentFiscalPrinterClient.RequestKMSettings();
		RequestKMSettings.Quantity = 1;
		RequestKMSettings.MarkingCode = StringCode;
		
		Result = Await EquipmentFiscalPrinterClient.CheckKM(Hardware, RequestKMSettings); // See EquipmentFiscalPrinterClient.ProcessingKMResult
		
		NewRow.CodeIsApproved = Result.Approved;
	EndDo;
	
EndProcedure

&AtClient
Procedure Done(Command)
	Array = New Array; // Array Of Structure
	For Each Row In CurrentCodes Do
		Str = New Structure;
		Str.Insert("Key", RowKey);
		Str.Insert("CodeString", Row.StringCode);
		Str.Insert("CodeIsApproved", Row.CodeIsApproved);
		Array.Add(Str);
	EndDo;
	
	Close(Array);
EndProcedure

&AtClient
Function CheckCodeString(StrCode)
	If StrLen(StrCode) < 30 Then
		Return False;
	EndIf;
	
	Return True;
EndFunction

&AtClient
Async Procedure CheckKM(Command)
	For Each SelectedID In Items.CurrentCodes.SelectedRows Do // Number
		Row = CurrentCodes.FindByID(SelectedID);
		RequestKMSettings = EquipmentFiscalPrinterClient.RequestKMSettings();
		RequestKMSettings.Quantity = 1;
		RequestKMSettings.MarkingCode = Row.StringCode;
		
		Result = Await EquipmentFiscalPrinterClient.CheckKM(Hardware, RequestKMSettings); // See EquipmentFiscalPrinterClient.ProcessingKMResult
		
		Row.CodeIsApproved = Result.Approved;
	EndDo;
EndProcedure
