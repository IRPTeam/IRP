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
		EndIf;
	Else
		Items.SerialLotNumber.Visible = False;
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

#EndRegion

&AtClient
Procedure OnOpen(Cancel)
	CurrentItem = Items.Quantity;
#If MobileClient Then
	If IsBlankString(ActiveItem) Then
		If AutoMode Then
			BeginEditingItem();
		EndIf;
	Else
		CurrentItem = Items.Find(ActiveItem);
	EndIf;
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