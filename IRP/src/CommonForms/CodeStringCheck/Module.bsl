
// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Hardware = Parameters.Hardware;
	Item = Parameters.Item;
	ItemKey = Parameters.ItemKey;
	LineNumber = Parameters.LineNumber;
	RowKey = Parameters.RowKey;
	isReturn = Parameters.isReturn;
	AdditionalCheckIsOn = Parameters.Item.CheckCodeString;
	
	Items.DecorationCheckIsOff.Visible = Not AdditionalCheckIsOn;
EndProcedure

//@skip-check property-return-type, dynamic-access-method-not-found, statement-type-change
&AtClient
Procedure OnOpen(Cancel)
	For Each Row In FormOwner.Object.ControlCodeStrings.FindRows(New Structure("Key", RowKey)) Do // ValueTableRow
		NewRow = CurrentCodes.Add();
		NewRow.StringCode = Row.CodeString;
		NewRow.CodeIsApproved = Row.CodeIsApproved;
		NewRow.NotCheck = Row.NotCheck;
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
		
		If Not Row.Item = Item Or Not Row.ItemKey = ItemKey Then
			Descr = String(Row.Item) + "[" + Row.ItemKey + "]";
			//@skip-check property-return-type, invocation-parameter-type-intersect
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().POS_Error_ThisBarcodeFromAnotherItem, Descr));
			Return;
		EndIf;
		If GetCodeStringFromSerialLotNumber Then
			CodeStringFromSerial = CommonFunctionsServer.GetRefAttribute(Row.SerialLotNumber, "CodeString"); // String
			ArrayOfCodeStrings.Add(CodeStringFromSerial);
		Else	
			ArrayOfCodeStrings.Add(Row.Barcode);
		EndIf;
	EndDo;

	For Each Row In Result.Barcodes Do
		ArrayOfCodeStrings.Add(Row);
	EndDo;
	
	For Each StrCode In ArrayOfCodeStrings Do
		If CheckCodeString(StrCode) Then
			
			//@skip-check property-return-type, dynamic-access-method-not-found, variable-value-type
			dblRows = FormOwner.Object.ControlCodeStrings.FindRows(New Structure("CodeString", StrCode));
			For Each dblCode In dblRows Do // ValueTableRow 
				//@skip-check property-return-type, dynamic-access-method-not-found, variable-value-type, structure-consructor-value-type
				dblData = FormOwner.Object.ItemList.FindRows(New Structure("Key", dblCode.Key));
				//@skip-check property-return-type, invocation-parameter-type-intersect
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().EqFP_ScanedCodeStringAlreadyExists, dblData[0].LineNumber));
			EndDo;
			
			//@skip-check dynamic-access-method-not-found
			If dblRows.Count() > 0 Then
				Continue;
			EndIf;
			
			ArrayOfApprovedCodeStrings.Add(StrCode);
		Else
			//@skip-check property-return-type, invocation-parameter-type-intersect
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().POS_Error_ThisIsNotControleStringBarcode, StrCode));
		EndIf;
	EndDo;
	
	AllBarcodesIsOk = True;
	For Each StringCode In ArrayOfApprovedCodeStrings Do // String
		If AdditionalCheckIsOn Then
			RequestKMSettings = EquipmentFiscalPrinterClient.RequestKMSettingsInfo(isReturn);
			RequestKMSettings.Quantity = 1;
			RequestKMSettings.MarkingCode = StringCode;
			
			Result = Await EquipmentFiscalPrinterClient.CheckKM(Hardware, RequestKMSettings); // See EquipmentFiscalPrinterClient.ProcessingKMResult
			
			If Not Result.Approved Then
				AllBarcodesIsOk = False;
				//@skip-check transfer-object-between-client-server
				Log.Write("CodeStringCheck.CheckKM.Approved.False", Result, , , Hardware);
				//@skip-check invocation-parameter-type-intersect, property-return-type
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().EqFP_ProblemWhileCheckCodeString, StringCode));	
				Return;
			EndIf;
			NewRow = CurrentCodes.Add();
			NewRow.StringCode = StringCode;	
			NewRow.CodeIsApproved = Result.Approved;
		Else
			NewRow = CurrentCodes.Add();
			NewRow.StringCode = StringCode;	
			NewRow.CodeIsApproved = True;
			NewRow.NotCheck = True;
		EndIf;
	EndDo;
	
	If AllBarcodesIsOk And ArrayOfApprovedCodeStrings.Count() > 0 Then
		Done();
	EndIf;

EndProcedure

&AtClient
Procedure ApproveWithoutScan(Command)
	Close(New Structure("WithoutScan", True));
EndProcedure

&AtClient
Procedure Done(Command = Undefined)
	Result = New Structure;
	Result.Insert("WithoutScan", False);
	Array = New Array; // Array Of Structure
	For Each Row In CurrentCodes Do
		Str = New Structure;
		Str.Insert("Key", RowKey);
		Str.Insert("CodeString", Row.StringCode);
		Str.Insert("CodeIsApproved", Row.CodeIsApproved);
		Str.Insert("NotCheck", Row.NotCheck);
		Array.Add(Str);
	EndDo;
	Result.Insert("Scaned", Array);
	Close(Result);
EndProcedure

&AtClient
Function CheckCodeString(StrCode)
	If StrLen(StrCode) < 20 Then
		Return False;
	EndIf;
	
	Return True;
EndFunction

&AtClient
Procedure GetCodeStringFromSerialLotNumber(Command)
	Items.GetCodeStringFromSerialLotNumber.Visible = True;
	GetCodeStringFromSerialLotNumber = True;
EndProcedure