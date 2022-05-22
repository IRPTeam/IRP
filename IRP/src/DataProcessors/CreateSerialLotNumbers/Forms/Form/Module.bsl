&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, DataProcessors.MobileDesktop, Items.PageAddInfo);
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

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	If Result.FoundedItems.Count() Then
#If MobileClient Then
		MultimediaTools.CloseBarcodeScanning();
#EndIf
	Else
#If Not MobileClient Then
		For Each Row In Result.Barcodes Do
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, Row));
		EndDo;
#EndIf
	EndIf;

	For Each Row In Result.FoundedItems Do
	EndDo;

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
Procedure InputBarcode(Command)
	Barcode = 0;
	ShowInputNumber(New NotifyDescription("AddBarcodeAfterEnd", ThisForm), Barcode, R().SuggestionToUser_2);
EndProcedure

&AtClient
Procedure AddBarcodeAfterEnd(Number, AdditionalParameters) Export
	SearchByBarcode(Undefined, Barcode);
EndProcedure

#EndRegion
