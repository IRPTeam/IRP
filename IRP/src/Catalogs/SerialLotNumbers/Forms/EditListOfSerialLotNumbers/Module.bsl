&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.RowKey = Parameters.RowKey;
	ThisObject.Item = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	ThisObject.ItemType = Parameters.Item.ItemType;
	ThisObject.ItemQuantity = Parameters.Quantity;
	For Each Row In Parameters.SerialLotNumbers Do
		NewRow = ThisObject.SerialLotNumbers.Add();
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	SerialLotNumberStatus = R().InfoMessage_018;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateFooter();
EndProcedure

&AtClient
Procedure SerialLotNumbersOnChange(Item)
	UpdateFooter();
	Modified = True;
EndProcedure

&AtClient
Procedure SerialLotNumbersSerialLotNumberStartChoice(Item, ChoiceData, StandardProcessing)
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", ThisObject.ItemType);
	FormParameters.Insert("Item", ThisObject.Item);
	FormParameters.Insert("ItemKey", ThisObject.ItemKey);

	SerialLotNumberClient.StartChoice(Item, ChoiceData, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure SerialLotNumbersSerialLotNumberEditTextChange(Item, Text, StandardProcessing)
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", ThisObject.ItemType);
	FormParameters.Insert("Item", ThisObject.Item);
	FormParameters.Insert("ItemKey", ThisObject.ItemKey);

	SerialLotNumberClient.EditTextChange(Item, Text, StandardProcessing, ThisObject, FormParameters);
EndProcedure

&AtClient
Procedure Ok(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	Result = New Structure();
	Result.Insert("RowKey", ThisObject.RowKey);
	Result.Insert("Item", ThisObject.Item);
	Result.Insert("ItemKey", ThisObject.ItemKey);
	Result.Insert("SerialLotNumbers", New Array());
	For Each Row In ThisObject.SerialLotNumbers Do
		Result.SerialLotNumbers.Add(
				New Structure("SerialLotNumber, Quantity", Row.SerialLotNumber, Row.Quantity));
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtServer
Procedure FillCheckProcessingAtServer(Cancel, CheckedAttributes)
	RowIndex = 0;
	For Each Row In SerialLotNumbers Do
		If Not ValueIsFilled(Row.SerialLotNumber) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, Metadata.Catalogs.SerialLotNumbers.Presentation()), "SerialLotNumbers["
				+ Format(RowIndex, "NZ=0; NG=0;") + "].SerialLotNumber", ThisObject);
		EndIf;
		If Not ValueIsFilled(Row.Quantity) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, R().Form_003), "SerialLotNumbers[" + Format(RowIndex, "NZ=0; NG=0;")
				+ "].Quantity", ThisObject);
		EndIf;
		RowIndex = RowIndex + 1;
	EndDo;
EndProcedure

&AtClient
Procedure UpdateFooter()
	SelectedCount = SerialLotNumbers.Total("Quantity");
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, New Structure(), ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	LastBarcode = "";
	SerialLotNumberStatus = "";
	Items.CreateSerialLotNumber.Visible = False;
	If Result.FoundedItems.Count() Then
		ScannedInfo = Result.FoundedItems[0];
		Barcode = Result.Barcodes[0];
		If Not ValueIsFilled(ScannedInfo.SerialLotNumber) Then
			CalculateStatus(StrTemplate(R().InfoMessage_017, Result.Barcodes[0]));
		ElsIf Not ScannedInfo.ItemKey.IsEmpty() And Not ScannedInfo.ItemKey = ItemKey Then
			CalculateStatus(StrTemplate(R().InfoMessage_016, Barcode, ScannedInfo.ItemKey));
		ElsIf Not ScannedInfo.Item.IsEmpty() And Not ScannedInfo.Item = Item Then
			CalculateStatus(StrTemplate(R().InfoMessage_016, Barcode, ScannedInfo.Item));
		ElsIf Not ScannedInfo.ItemType.IsEmpty() And Not ScannedInfo.ItemType = ItemType Then
			CalculateStatus(StrTemplate(R().InfoMessage_016, Barcode, ScannedInfo.ItemType));
		Else
			Row = SerialLotNumbers.Add();
			Row.SerialLotNumber = ScannedInfo.SerialLotNumber;
			Row.Quantity = 1;
			UpdateFooter();
		EndIf;
	Else
		LastBarcode = Result.Barcodes[0];
		CalculateStatus(StrTemplate(R().InfoMessage_015, LastBarcode));
		Items.CreateSerialLotNumber.Visible = True;
	EndIf;
EndProcedure

&AtClient
Procedure CreateSerialLotNumber(Command)
	Params = New Structure();
	Params.Insert("ItemType", ItemType);
	Params.Insert("Item", Item);
	Params.Insert("ItemKey", ItemKey);
	Params.Insert("Barcode", LastBarcode);
	CloseNotifyDescription = New NotifyDescription("AfterCreateSerialLotNumber", ThisObject, Params);
	OpenForm("Catalog.SerialLotNumbers.ObjectForm", Params, , , , , CloseNotifyDescription,
		FormWindowOpeningMode.LockOwnerWindow);
	LastBarcode = "";
	SerialLotNumberStatus = "";
	Items.CreateSerialLotNumber.Visible = False;
EndProcedure

&AtClient
Procedure AfterCreateSerialLotNumber(Result, AddInfo) Export
	SearchByBarcode(Undefined, AddInfo.Barcode);
EndProcedure

&AtClient
Procedure CalculateStatus(SetStatus = Undefined)

	If Not IsBlankString(SetStatus) Then
		SerialLotNumberStatus = SetStatus;
	EndIf;

EndProcedure