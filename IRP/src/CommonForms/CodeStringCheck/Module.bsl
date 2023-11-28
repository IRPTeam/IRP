
// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Hardware = Parameters.Hardware;
	Item = Parameters.Item;
	ItemKey = Parameters.ItemKey;
	LineNumber = Parameters.LineNumber;
	RowKey = Parameters.RowKey;
	isReturn = Parameters.isReturn;
	ControlCodeStringType = Item.ControlCodeStringType;
	//@skip-check property-return-type, statement-type-change
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
		NewRow.ControlCodeStringType = Row.ControlCodeStringType;
		NewRow.Prefix = Row.Prefix;
		
		ControlCodeStringType = Row.ControlCodeStringType; // Get from last row
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
		If ControlCodeStringClient.ValidateCodeString(ControlCodeStringType, StrCode) Then

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
		If AdditionalCheckIsOn AND ControlCodeStringType = PredefinedValue("Enum.ControlCodeStringType.MarkingCode") Then
			If Await ControlCodeStringClient.CheckMarkingCode(StringCode, Hardware, isReturn) Then
				NewRow = CurrentCodes.Add();
				NewRow.StringCode = StringCode;
				NewRow.CodeIsApproved = True;
				NewRow.ControlCodeStringType = ControlCodeStringType;
			Else
				AllBarcodesIsOk = False;
			EndIf;
		ElsIf AdditionalCheckIsOn AND ControlCodeStringType = PredefinedValue("Enum.ControlCodeStringType.GoodCodeData") Then
			If ControlCodeStringClient.CheckGoodCodeData(StringCode, Hardware, isReturn) Then
				
				GoodData = GetGoodData(StringCode);
					
				If Not GoodData = Undefined Then
					NewRow = CurrentCodes.Add();
					NewRow.StringCode = GoodData.CodeString;
					NewRow.CodeIsApproved = True;
					NewRow.Prefix = GoodData.Type;
					NewRow.ControlCodeStringType = ControlCodeStringType;
				Else
					AllBarcodesIsOk = False;
				EndIf;
			Else
				AllBarcodesIsOk = False;
			EndIf; 
		Else
			NewRow = CurrentCodes.Add();
			NewRow.StringCode = StringCode;
			NewRow.CodeIsApproved = True;
			NewRow.NotCheck = True;
			NewRow.ControlCodeStringType = ControlCodeStringType;
		EndIf;
	EndDo;

	If AllBarcodesIsOk And ArrayOfApprovedCodeStrings.Count() > 0 Then
		Done();
	EndIf;

EndProcedure

&AtServer
Function GetGoodData(Val StringCode)
	Return ControlCodeStringServer.GetGoodData(ControlCodeStringType, StringCode);
EndFunction

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
		Str.Insert("ControlCodeStringType", Row.ControlCodeStringType);
		Str.Insert("Prefix", Row.Prefix);
		Array.Add(Str);
	EndDo;
	Result.Insert("Scaned", Array);
	Close(Result);
EndProcedure

&AtClient
Procedure GetCodeStringFromSerialLotNumber(Command)
	Items.GetCodeStringFromSerialLotNumber.Visible = True;
	GetCodeStringFromSerialLotNumber = True;
EndProcedure

&AtClient
Procedure ControlCodeStringTypeOnChange(Item)
	CurrentCodes.Clear();
EndProcedure