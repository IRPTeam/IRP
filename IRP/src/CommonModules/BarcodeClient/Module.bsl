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
	
	If Parameters.Property("PriceType") Then
		PriceType = Parameters.PriceType;
	Else
		PriceType = Undefined;
	EndIf;
	If Parameters.Property("PricePeriod") Then
		PricePeriod = Parameters.PricePeriod;
	Else
		PricePeriod = CurrentDate();
	EndIf;
	
	FoundedItems = BarcodeServer.SearchByBarcodes(Barcodes, PriceType, PricePeriod);
	If FoundedItems.Count() Then
		
		If Parameters.Property("DocumentClientModule") Then
			DocumentModule = Parameters.DocumentClientModule;
			DocumentModule.PickupItemsEnd(FoundedItems, Parameters);
		EndIf;
		
		ReturnResult = True;
	EndIf;
	
	Return ReturnResult;
EndFunction

Function GetBarcodesByItemKey(ItemKey) Export
	Return BarcodeServer.GetBarcodesByItemKey(ItemKey);
EndFunction

