&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.RowKey = Parameters.RowKey;
	ThisObject.Item = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	ThisObject.ItemType = Parameters.Item.ItemType;
	ThisObject.ItemQuantity = Parameters.Quantity;

	FillSingleMode();

	SerialLotNumberStatus = R().InfoMessage_018;
	SerialLotNumbersServer.SetUnique(ThisObject);
EndProcedure

&AtServer
Procedure FillSingleMode() Export
	ThisObject.SingleMode = Parameters.Single;
	
	Items.SerialLotNumbers.Visible = Not SingleMode;
	Items.GroupLegend.Visible = Not SingleMode;
	
	Items.SerialLotNumberSingle.Visible = SingleMode;
	Items.FormSearchByBarcode.Visible = SingleMode;
	
	For Each Row In Parameters.SerialLotNumbers Do
		If SingleMode Then
			ThisObject.SerialLotNumberSingle = Row.SerialLotNumber;
		EndIf;
		NewRow = ThisObject.SerialLotNumbers.Add();
		NewRow.SerialLotNumber = Row.SerialLotNumber;
		NewRow.Quantity = Row.Quantity;
	EndDo;
	
	If SingleMode And ThisObject.SerialLotNumbers.Count() = 0 Then
		NewRow = ThisObject.SerialLotNumbers.Add();
		NewRow.Quantity = 1;
	EndIf;
EndProcedure

&AtClient
Procedure SerialLotNumberSingleOnChange(Item)
	ThisObject.SerialLotNumbers[0].SerialLotNumber = ThisObject.SerialLotNumberSingle;
	SerialLotNumberOnChangeAtServer();
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
	FormParameters.Insert("ItemType", Undefined);
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
Procedure SerialLotNumbersSerialLotNumberOnChange(Item)
	SerialLotNumberOnChangeAtServer();
	ShowUniqueText();
EndProcedure

&AtServer
Procedure SerialLotNumberOnChangeAtServer()
	SerialLotNumbersServer.SetUnique(ThisObject);
EndProcedure

&AtClient
Procedure Ok(Command)
	CloseThisForm();
EndProcedure

&AtClient
Procedure CloseThisForm()

	If Not CheckFilling() Then
		Return;
	EndIf;

	Result = SerialLotNumbersServer.FillSettingsAddNewSerial();
	Result.RowKey = ThisObject.RowKey;
	Result.Item = ThisObject.Item;
	Result.ItemKey = ThisObject.ItemKey;
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
	ShowUniqueText();
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, New Structure(), ThisObject, ThisObject);
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
	LastBarcode = "";
	SerialLotNumberStatus = "";
	Items.CreateSerialLotNumber.Visible = False;
	
	For Each ScannedInfo In Result.FoundedItems Do
		If Not ValueIsFilled(ScannedInfo.SerialLotNumber) Then
			CalculateStatus(StrTemplate(R().InfoMessage_017, ScannedInfo.Barcode));
		ElsIf Not ScannedInfo.ItemKey.IsEmpty() And Not ScannedInfo.ItemKey = ItemKey Then
			StrTemp = "" + ScannedInfo.Item + " [ " + ScannedInfo.ItemKey + " ]";
			CalculateStatus(StrTemplate(R().InfoMessage_016, ScannedInfo.Barcode, StrTemp));
		ElsIf Not ScannedInfo.Item.IsEmpty() And Not ScannedInfo.Item = Item Then
			CalculateStatus(StrTemplate(R().InfoMessage_016, ScannedInfo.Barcode, ScannedInfo.Item));
		ElsIf Not ScannedInfo.ItemType.IsEmpty() And Not ScannedInfo.ItemType = ItemType Then
			CalculateStatus(StrTemplate(R().InfoMessage_016, ScannedInfo.Barcode, ScannedInfo.ItemType));
		Else
			AddNewSerialLotNumberRow(ScannedInfo.SerialLotNumber);
		EndIf;
	EndDo;
	
	If Result.Barcodes.Count() Then
		If AutoCreateNewSerialLotNumbers Then
			For Each NewBarcode In Result.Barcodes Do
				SerialLotNumber = SerialLotNumbersServer.GetNewSerialLotNumber(NewBarcode, ItemKey);
				AddNewSerialLotNumberRow(SerialLotNumber);
			EndDo;
		Else
			LastBarcode = StrConcat(Result.Barcodes, ";");
			CalculateStatus(StrTemplate(R().InfoMessage_015, LastBarcode));
			Items.CreateSerialLotNumber.Visible = True;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure AddNewSerialLotNumberRow(SerialLotNumber)
	
	If SingleMode Then
		SerialLotNumbers[0].SerialLotNumber = SerialLotNumber;
		ThisObject.SerialLotNumberSingle = SerialLotNumber;
		CloseThisForm();
	Else
		Row = SerialLotNumbers.Add();
		Row.SerialLotNumber = SerialLotNumber;
		Row.Quantity = 1;
		
		SerialLotNumberOnChangeAtServer();
		ShowUniqueText();
	EndIf;
	
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
		
		If SingleMode Then
			ThisObject.SerialLotNumberSingle = Result;
			CloseThisForm();
		EndIf;
		
		SerialLotNumberOnChangeAtServer();
		ShowUniqueText();
	EndIf;
	ThisObject.CurrentItem = Items.SerialLotNumbersQuantity;
	
EndProcedure

&AtClient
Procedure SerialLotNumbersOnActivateRow(Item)
	ShowUniqueText(); 
EndProcedure

&AtClient
Procedure ShowUniqueText()
	If Items.SerialLotNumbers.CurrentData = Undefined Or Not Items.SerialLotNumbers.CurrentData.isUnique Then
		Items.DecorationLock.Visible = False;
		Items.DecorationLegendInfo.Title = "";
	Else
		Items.DecorationLock.Visible = True;
		Items.DecorationLegendInfo.Title = R().InfoMessage_029;
	EndIf;
EndProcedure
