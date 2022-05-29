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
Procedure SerialLotNumbersSerialLotNumberCreating(Item, StandardProcessing)
	
	StandardProcessing = False;
	
	FormParameters = New Structure();
	FormParameters.Insert("ItemType", ThisObject.ItemType);
	FormParameters.Insert("Item", ThisObject.Item);
	FormParameters.Insert("ItemKey", ThisObject.ItemKey);
	FormParameters.Insert("Description", Item.EditText);
	
	OpenForm("Catalog.SerialLotNumbers.ObjectForm", FormParameters, ThisObject, , , , New NotifyDescription("AfterCreateNewSerial", ThisObject));
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

// Search by barcode end.
// 
// Parameters:
//  Result Result
//  AdditionalParameters Additional parameters
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
			AddNewSerialLotNumberRow(ScannedInfo.SerialLotNumber);
		EndIf;
	Else
		If AutoCreateNewSerialLotNumbers Then
			SerialLotNumber = SerialLotNumbersServer.GetNewSerialLotNumber(Result.Barcodes[0], ItemKey);
			AddNewSerialLotNumberRow(SerialLotNumber);
		Else
			LastBarcode = Result.Barcodes[0];
			CalculateStatus(StrTemplate(R().InfoMessage_015, LastBarcode));
			Items.CreateSerialLotNumber.Visible = True;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure AddNewSerialLotNumberRow(SerialLotNumber)
	Var Row;
	Row = SerialLotNumbers.Add();
	Row.SerialLotNumber = SerialLotNumber;
	Row.Quantity = 1;
	UpdateFooter();
EndProcedure

&AtClient
Procedure CreateSerialLotNumber(Command)
	SerialLotNumber = SerialLotNumbersServer.GetNewSerialLotNumber(LastBarcode, ItemKey);
	LastBarcode = "";
	SerialLotNumberStatus = "";
	Items.CreateSerialLotNumber.Visible = False;
	AddNewSerialLotNumberRow(SerialLotNumber);
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

&AtClient
Procedure AfterCreateNewSerial(Result, AddInfo) Export
	
	If ValueIsFilled(Result) Then
		Row = SerialLotNumbers.FindByID(Items.SerialLotNumbers.CurrentRow);
		Row.SerialLotNumber = Result;
	EndIf;
	ThisObject.CurrentItem = Items.SerialLotNumbersQuantity;
	
EndProcedure
