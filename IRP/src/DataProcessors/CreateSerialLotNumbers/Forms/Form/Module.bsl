&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Return;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	HideWhenMobileEmulatorBarcode();
EndProcedure

#Region Barcode

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	Settings = BarcodeClient.GetBarcodeSettings();
	//@skip-warning
	Settings.MobileBarcodeModule = ThisObject;
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, , Settings);
EndProcedure

// Search by barcode end.
// 
// Parameters:
//  Result - Structure:
//   * FoundedItems - See BarcodeServer.SearchByBarcodes
//   * Barcodes - Array of String
//  AdditionalParameters - Structure - Additional parameters
&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	Info = "";
	
	If Result.FoundedItems.Count() Then
#If MobileClient Then
		MultimediaTools.CloseBarcodeScanning();
#EndIf
	Else
#If Not MobileClient Then
		For Each Row In Result.Barcodes Do
			Info = StrTemplate(R().S_019, Row);
		EndDo;
#EndIf
	EndIf;

	For Each Row In Result.FoundedItems Do
		
		If Not Row.UseSerialLotNumber Then
			Info = StrTemplate(R().InfoMessage_017, Row.Item);
		ElsIf ItemRef.IsEmpty() And Not Row.SerialLotNumber.IsEmpty() Then
			Info = R().InfoMessage_029;
		ElsIf ItemRef = Row.Item And ItemKey = Row.ItemKey And Not Row.SerialLotNumber.IsEmpty() Then
			Info = StrTemplate(R().InfoMessage_027, Row.Barcode, Row.Item, Row.ItemKey, Row.SerialLotNumber);
		ElsIf Row.SerialLotNumber.IsEmpty() Then
			ItemRef = Row.Item;
			ItemKey = Row.ItemKey;
			SerialLotNumberList.Clear();
		Else
			Info = StrTemplate(R().InfoMessage_027, Row.SerialLotNumber, Row.Item, Row.ItemKey, Row.SerialLotNumber);
		EndIf;
		
		Return;
		
	EndDo;
	
	For Each Row In Result.Barcodes Do

		If ItemRef.IsEmpty() Or ItemKey.IsEmpty() Then
			Info = R().InfoMessage_029;
			Return;
		EndIf;
	
		SerialLotNumber = SerialLotNumbersServer.GetNewSerialLotNumber(Row, ItemKey);
		
		If Not SerialLotNumber.IsEmpty() Then
			NewRow = SerialLotNumberList.Insert(0);
			NewRow.Barcode = Row;
			NewRow.SerialLotNumber = SerialLotNumber;
			
			Info = StrTemplate(R().InfoMessage_028, Row, ItemKey);
		EndIf;
	EndDo;

EndProcedure

&AtClient
Procedure BarcodeInputOnChange(Item)
	AttachIdleHandler("BeginEditBarcode", 0.1, True);
	SearchByBarcode(Undefined, BarcodeInput);
	BarcodeInput = "";
EndProcedure

&AtClient
Procedure BeginEditBarcode() Export
	ThisObject.CurrentItem = Items.BarcodeInput;
#If Not MobileClient Then
	ThisObject.BeginEditingItem();
#EndIf

EndProcedure

&AtClient
Procedure ScanEmulatorOnChange(Item)
	HideWhenMobileEmulatorBarcode();
EndProcedure

&AtClient
Procedure HideWhenMobileEmulatorBarcode() Export
	Items.GroupBottom.Visible = Not ScanEmulator;
EndProcedure

&AtClient
Procedure ScanBarcodeEndMobile(Barcode, Result, Message, Parameters) Export
	ProcessBarcodeResult = Barcodeclient.ProcessBarcode(Barcode, Parameters);
	If ProcessBarcodeResult Then
		Message = R().S_018;
	Else
		Result = False;
		Message = StrTemplate(R().S_019, Barcode);
	EndIf;
EndProcedure

&AtClient
Procedure AddBarcodeAfterEnd(Number, AdditionalParameters) Export
	SearchByBarcode(Undefined, Barcode);
EndProcedure

#EndRegion
