&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ItemRef = Parameters.ItemRef;
	ItemKey = Parameters.ItemKey;
	SerialLotNumber = Parameters.SerialLotNumber;
	
	If ItemRef.IsEmpty() Then
		ItemRef = ItemKey.Item;
	EndIf;
	UseSerialLotNumber = SerialLotNumbersServer.IsItemKeyWithSerialLotNumbers(ItemKey);
	If UseSerialLotNumber Then
		If SerialLotNumber.IsEmpty() Then
			ActiveItem = "SerialLotNumber";
		Else
			Items.SerialLotNumber.ReadOnly = True;
			Items.SearchByBarcode.Visible = False;
		EndIf;
	Else
		Items.SerialLotNumber.Visible = False;
		Items.SearchByBarcode.Visible = False;
	EndIf;
	
	Quantity = Parameters.Quantity;
	RowId = Parameters.RowId;
	AutoMode = Parameters.AutoMode;
	CurrentPicture = Catalogs.Files.EmptyRef();
	ItemKeyPictures = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(ItemKey);
	If ItemKeyPictures.Count() Then
		Picture = ItemKeyPictures[0];
	Else
		ItemPictures = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(ItemRef);
		If ItemPictures.Count() Then
			CurrentPicture = ItemPictures[0];
		EndIf;
	EndIf;
	If CurrentPicture.isPreviewSet Then
		Picture = GetURL(CurrentPicture, "Preview");
	EndIf;
EndProcedure

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
	DocumentsClient.SearchByBarcode(Barcode, New Structure(), ThisObject, ThisObject, , Settings);
EndProcedure

// Search by barcode end.
// 
// Parameters:
//  Result - Structure - Result
//  AdditionalParameters - See BarcodeClient.GetBarcodeSettings
&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	BarcodeClient.CloseMobileScanner();		
	For Each Row In Result.FoundedItems Do
		
		If Row.Item = ItemRef And Row.ItemKey = ItemKey Then
			SerialLotNumber = Row.SerialLotNumber;
		Else
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_027, 
				Result.Barcodes[0], Row.Item, Row.ItemKey, Row.SerialLotNumber));
		EndIf;
		
		Return;
		
	EndDo;
	SerialLotNumber = SerialLotNumbersServer.GetNewSerialLotNumber(Result.Barcodes[0], ItemKey);
	If Not SerialLotNumber.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_028, 
					Result.Barcodes[0], ItemKey));
	EndIf;				
EndProcedure

// Scan barcode end mobile.
// 
// Parameters:
//  Barcode - String - Barcode
//  Result - Boolean - Result
//  Message - String - Message
//  Parameters - See BarcodeClient.GetBarcodeSettings
&AtClient
Procedure ScanBarcodeEndMobile(Barcode, Result, Message, Parameters) Export

	Barcodeclient.ProcessBarcode(Barcode, Parameters);
	
EndProcedure

#Region SERIAL_LOT_NUMBERS
&AtClient
Procedure SerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing)
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", ItemRef);
	FormParameters.Insert("ItemKey", ItemKey);

	SerialLotNumberClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", ItemRef);
	FormParameters.Insert("ItemKey", ItemKey);

	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SerialLotNumberCreating(Item, StandardProcessing)
	
	StandardProcessing = False;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", Undefined);
	FormParameters.Insert("Item", ItemRef);
	FormParameters.Insert("ItemKey", ItemKey);
	FormParameters.Insert("Description", Item.EditText);
	
	OpenForm("Catalog.SerialLotNumbers.ObjectForm", FormParameters, ThisObject);
EndProcedure


#EndRegion

&AtClient
Procedure OnOpen(Cancel)
	CurrentItem = Items.Quantity;
#If MobileClient Then
	If IsBlankString(ActiveItem) Then
		If AutoMode Then
			AttachIdleHandler("BeginEditBarcode", 0.1, True);
		EndIf;
	Else
		CurrentItem = Items.Find(ActiveItem);
	EndIf;
#EndIf
EndProcedure

&AtClient
Procedure BeginEditBarcode() Export
#If MobileClient Then
	ThisObject.BeginEditingItem();
#EndIf
EndProcedure

&AtClient
Procedure QuantityOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure OK()
	Data = New Structure();
	Data.Insert("Quantity", Quantity);
	Data.Insert("SerialLotNumber", SerialLotNumber);
	Data.Insert("RowId", RowId);
	Close(Data);
EndProcedure
