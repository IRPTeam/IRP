#Region FormEvents

&AtClient
Procedure OnOpen(Cancel)
	UpdateRows(FormOwner.Object.ItemList);
EndProcedure

#EndRegion

#Region FormTableEvent

&AtClient
Procedure ItemListQuantityOnChange(Item)
	CurrentData = Item.Parent.CurrentData;
	OwnerRow = FormOwner.Object.ItemList.FindRows(New Structure("Key", CurrentData.Key))[0];
	OwnerRow.Quantity = Item.Parent.CurrentData.Quantity;
	DocInventoryTransferClient.ItemListQuantityOnChange(FormOwner.Object, FormOwner, Item);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	CurrentData = Item.CurrentData;
	OwnerRow = FormOwner.Object.ItemList.FindRows(New Structure("Key", CurrentData.Key))[0];
	FormOwner.Object.ItemList.Delete(OwnerRow);
	DocInventoryTransferClient.ItemListAfterDeleteRow(FormOwner.Object, FormOwner, Item);
EndProcedure

#EndRegion

#Region Barcode

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	AddInfo = New Structure("MobileModule", ThisObject);
	DocInventoryTransferClient.SearchByBarcode(Barcode, FormOwner.Object, FormOwner, , , AddInfo);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	ElsIf EventName = "AddNewItemListRow" And IsInputAvailable()  AND Source = FormOwner Then
		UpdateRows(Parameter);
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
Procedure UpdateRows(RowList)

	For Each Row In RowList Do
		Rows = ItemList.FindRows(New Structure("Key", Row.Key));
		If Rows.Count() Then
			FillPropertyValues(Rows[0], Row);
		Else
			FillPropertyValues(ItemList.Add(), Row);
		EndIf;
	EndDo;
	
EndProcedure
#EndRegion
