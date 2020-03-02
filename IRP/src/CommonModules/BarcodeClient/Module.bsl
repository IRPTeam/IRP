Procedure InputBarcodeEnd(EnteredString, Parameters) Export
	If EnteredString = Undefined Then
		Return;
	EndIf;
	ProcessBarcode(EnteredString, Parameters);
EndProcedure

Procedure ScanBarcodeEnd(Barcode, Result, Message, Parameters) Export
	ProcessBarcodeResult = ProcessBarcode(Barcode, Parameters);
	If ProcessBarcodeResult Then
		Message = R().S_018;
	Else
		Result = False;
		Message = StrTemplate(R().S_019, Barcode);
	EndIf;
EndProcedure

Procedure InputBarcodeCancel(Parameters) Export
	Return;
EndProcedure


Function ProcessBarcode(Barcode, Parameters)
	BarcodeArray = New Array;
	BarcodeArray.Add(Barcode);
	Return ProcessBarcodes(BarcodeArray, Parameters);
EndFunction

Function ProcessBarcodes(Barcodes, Parameters)
	ReturnResult = False;	
	AddInfo = Parameters.AddInfo;
	If AddInfo.Property("ClientModule") Then
		AddInfo.Delete("ClientModule");
	EndIf;	
	FoundedItems = BarcodeServer.SearchByBarcodes(Barcodes, AddInfo);
	If FoundedItems.Count() Then
		ClientModule = Parameters.ClientModule;
		ClientModule.SearchByBarcodeEnd(FoundedItems, Parameters);		
		ReturnResult = True;
	EndIf;	
	Return ReturnResult;
EndFunction

Function GetBarcodesByItemKey(ItemKey) Export
	Return BarcodeServer.GetBarcodesByItemKey(ItemKey);
EndFunction

&AtClient
Procedure SearchByBarcode(Command, Object, Form, ClientModule, AddInfo = Undefined) Export
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("ClientModule", ClientModule);
	If AddInfo = Undefined Then
		NotifyParameters.Insert("AddInfo", New Structure());
	Else
		NotifyParameters.Insert("AddInfo", AddInfo);
	EndIf;	
	DescriptionField = "";	
	#If MobileClient Then
		If MultimediaTools.BarcodeScanningSupported() Then
			NotifyScan = New NotifyDescription("ScanBarcodeEnd", BarcodeClient, NotifyParameters);
			NotifyScanCancel = New NotifyDescription("InputBarcodeCancel", BarcodeClient, NotifyParameters);
			MultimediaTools.ShowBarcodeScanning(DescriptionField, NotifyScan, NotifyScanCancel, BarcodeType.All);
		Else
			Return;
		EndIf;
	#Else
		DescriptionField = "";
		NotifyDescription = New NotifyDescription("InputBarcodeEnd", BarcodeClient, NotifyParameters);
		ShowInputString(NotifyDescription, "", DescriptionField);
	#EndIf
EndProcedure
