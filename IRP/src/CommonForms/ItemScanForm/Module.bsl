&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	AddInfo = New Structure("MobileModule", ThisObject);
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, , AddInfo);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure InputBarcode(Command)
	Barcode = 0;
	ShowInputNumber(New NotifyDescription("AddBarcodeAfterEnd", ThisForm), Barcode, R().SuggestionToUser_2);
EndProcedure

&AtClient
Procedure AddBarcodeAfterEnd(Number, AdditionalParameters) Export
	If Not ValueIsFilled(Number) Then
		Return;
	EndIf;
	SearchByBarcode(Undefined, Format(Number, "NG="));
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export

	NotifyParameters = New Structure;
	NotifyParameters.Insert("Form", ThisObject);

	For Each Row In AdditionalParameters.FoundedItems Do
		NewRow = ItemList.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Quantity = Row.Quantity;
	EndDo;
	If AdditionalParameters.FoundedItems.Count() Then
		If RuleEditQuantity Then
			BarcodeClient.CloseMobileScanner();
			StartEditQuantity(NewRow.GetID(), True);
		EndIf;
	EndIf;

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
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	StartEditQuantity(RowSelected);
EndProcedure

&AtClient
Procedure StartEditQuantity(Val RowSelected, AutoMode = False)
	Structure = New Structure;
	ItemListRow = ItemList.FindByID(RowSelected);
	Structure.Insert("ItemRef", Undefined);
	Structure.Insert("ItemKey", ItemListRow.ItemKey);
	Structure.Insert("Quantity", ItemListRow.PhysCount);
	Structure.Insert("RowID", RowSelected);
	Structure.Insert("AutoMode", AutoMode);
	NotifyOnClosing = New NotifyDescription("OnEditQuantityEnd", ThisObject);
	OpenForm("DataProcessor.MobileInvent.Form.RowForm", Structure, ThisObject, , , , NotifyOnClosing);
EndProcedure

&AtClient
Procedure OnEditQuantityEnd(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ItemListRow = ItemList.FindByID(Result.RowID);
	ItemListRow.OpenScanForm = Result.Quantity;
EndProcedure

&AtClient
Procedure CompleteLocation()
	NotifyDescription = New NotifyDescription("InputQuantityEnd", ThisObject);
	If Not SecondTryToInputQuantity Then
		Text = R().QuestionToUser_018;
	Else
		Text = R().InfoMessage_009;
	EndIf;
	ShowInputNumber(NotifyDescription, "", Text);
EndProcedure

&AtClient
Procedure InputQuantityEnd(Quantity, Parameters) Export
	If Quantity <> ItemList.Total("Quantity") Then
		If Not SecondTryToInputQuantity Then
			SecondTryToInputQuantity = True;
			CompleteLocation();
		Else
			CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_010);
			ItemList.Clear();
		EndIf;
	Else
		SecondTryToInputQuantity = False;
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_011);
	EndIf;
EndProcedure
