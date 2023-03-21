
// Get barcode settings.
// 
// Returns:
//  Structure - Get barcode settings:
// * Form - Undefined -
// * Object - Undefined -
// * AddInfo - Structure -
// * ReturnCallToModule - See CommonModule.DocumentsClient
// * MobileBarcodeModule - See CommonModule.BarcodeClient
// * ServerSettings - See GetBarcodeServerSettings
// * Result - Structure:
// ** FoundedItems - See BarcodeServer.SearchByBarcodes
// ** Barcodes - Array of String
// * Filter - Structure:
// ** DisableIfIsService - Boolean
Function GetBarcodeSettings() Export
	Settings = New Structure();
	Settings.Insert("Form", Undefined);
	Settings.Insert("Object", Undefined);
	Settings.Insert("AddInfo", New Structure());
	Settings.Insert("ReturnCallToModule", DocumentsClient);
	Settings.Insert("MobileBarcodeModule", BarcodeClient);
	
	Filter = New Structure;
	Filter.Insert("DisableIfIsService", False);
	Settings.Insert("Filter", Filter);
	
	Settings.Insert("ServerSettings", GetBarcodeServerSettings());
	
	Result = New Structure;
	Result.Insert("FoundedItems", New Array);
	Result.Insert("Barcodes", New Array);
	
	Settings.Insert("Result", Result);
	
	Return Settings;
EndFunction

// Get barcode settings.
// 
// Returns:
//  Structure - Get barcode server settings:
// * PriceType - Undefined -
// * PricePeriod - Date -
// * SearchUserByBarcode - Boolean -
// * SaveScannedBarcode - Boolean -
// * BarcodeBasis - DocumentRef, Undefined -
Function GetBarcodeServerSettings() Export
	
	ServerSettings = New Structure;
	ServerSettings.Insert("PriceType", Undefined);
	ServerSettings.Insert("PricePeriod", CommonFunctionsServer.GetCurrentSessionDate());
	ServerSettings.Insert("SearchUserByBarcode", False);
	
	ServerSettings.Insert("SaveScannedBarcode", False);
	ServerSettings.Insert("BarcodeBasis", Undefined);
	
	Return ServerSettings;
	
EndFunction

// Search by barcode.
// 
// Parameters:
//  Barcode - String - Barcode
//  Settings - See GetBarcodeSettings
Procedure SearchByBarcode(Barcode, Settings) Export

	NotifyDescription = New NotifyDescription("InputBarcodeEnd", BarcodeClient, Settings);
	//@skip-warning
	NotifyScan = New NotifyDescription("ScanBarcodeEndMobile", Settings.MobileBarcodeModule, Settings);
	If IsBlankString(Barcode) Then
		DescriptionField = R().SuggestionToUser_2; // String
#If MobileClient Then
		If MultimediaTools.BarcodeScanningSupported() Then
			NotifyScanCancel = New NotifyDescription("InputBarcodeCancel", BarcodeClient, Settings);
			MultimediaTools.ShowBarcodeScanning(DescriptionField, NotifyScan, NotifyScanCancel, BarcodeType.All);
		EndIf;
#Else
		OpenForm("CommonForm.InputBarcode", , , , , , NotifyDescription, FormWindowOpeningMode.LockOwnerWindow);
//		ShowInputString(NotifyDescription, "", DescriptionField);
#EndIf
	Else
#If MobileClient Then
		Settings.MobileBarcodeModule.ScanBarcodeEndMobile(Barcode, True, "", Settings);
#Else
		ExecuteNotifyProcessing(NotifyDescription, Barcode);
#EndIf
	EndIf;
EndProcedure

// Input barcode end.
// 
// Parameters:
//  EnteredString - String - Entered string
//  Parameters - See GetBarcodeSettings
Procedure InputBarcodeEnd(EnteredString, Parameters) Export
	If EnteredString = Undefined Then
		Return;
	EndIf;
	ProcessBarcode(EnteredString, Parameters);
EndProcedure

#Region Mobile

// Scan barcode end mobile.
// 
// Parameters:
//  Barcode - String - Barcode
//  Result - Boolean - Result
//  Message - String - Message
//  Parameters - See GetBarcodeSettings
Procedure ScanBarcodeEndMobile(Barcode, Result, Message, Parameters) Export
	ProcessBarcodeResult = ProcessBarcode(Barcode, Parameters);
	If ProcessBarcodeResult Then
		Message = R().S_018;
	Else
		Result = False;
		Message = StrTemplate(R().S_019, Barcode);
	EndIf;
EndProcedure

Procedure CloseMobileScanner() Export
#If MobileClient Then
	If MultimediaTools.BarcodeScanningSupported() Then
		MultimediaTools.CloseBarcodeScanning();
	EndIf;
#EndIf
EndProcedure

#EndRegion

// Input barcode cancel.
// 
// Parameters:
//  Parameters - See GetBarcodeSettings
Procedure InputBarcodeCancel(Parameters) Export
	Return;
EndProcedure

// Process barcode.
// 
// Parameters:
//  Barcode - String, Array of String - Barcode
//  Settings - See GetBarcodeSettings
// Returns:
//  Boolean - Process barcode
Function ProcessBarcode(Barcode, Settings) Export
	If TypeOf(Barcode) = Type("String") Then 
		BarcodeArray = New Array();
		BarcodeArray.Add(Barcode);
	Else
		BarcodeArray = Barcode;
	EndIf;
	
	For Each Row In BarcodeArray Do
		Row = TrimAll(Row);
	EndDo;
	Return ProcessBarcodes(BarcodeArray, Settings);
EndFunction

Function ProcessBarcodes(Barcodes, Settings)
	ReturnResult = False;
	ReturnCallToModule = Settings.ReturnCallToModule;
	ServerSettings = Settings.ServerSettings;
	
	FoundedItems = BarcodeServer.SearchByBarcodes(Barcodes, ServerSettings);

	If FoundedItems = Undefined Then
		Return False;
	EndIf;

	For Each FoundedItem In FoundedItems Do
		While True Do 
			Index = Barcodes.Find(FoundedItem.Barcode);
			If Index = Undefined Then
				Break;
			EndIf;
			Barcodes.Delete(Index);
		EndDo;
	EndDo;
	
	Settings.Result.FoundedItems = FoundedItems;
	Settings.Result.Barcodes = Barcodes;

	//@skip-warning
	NotifyDescription = New NotifyDescription("SearchByBarcodeEnd", ReturnCallToModule, Settings);
	ExecuteNotifyProcessing(NotifyDescription, Settings.Result);
	If FoundedItems.Count() Then
		ReturnResult = True;
	EndIf;
	Return ReturnResult;
EndFunction

// Get barcodes by item key.
// 
// Parameters:
//  ItemKey - CatalogRef.ItemKeys - Item key
// 
// Returns:
//  Array of String - Get barcodes by item key
Function GetBarcodesByItemKey(ItemKey) Export
	Return BarcodeServer.GetBarcodesByItemKey(ItemKey);
EndFunction

Function isBarcodeScanned(Event) Export
	Return Event = "NewBarcode" Or Event = "Barcode" Or Event = "Штрихкод";
EndFunction