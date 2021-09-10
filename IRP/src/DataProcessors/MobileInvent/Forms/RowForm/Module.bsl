&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ItemRef = Parameters.ItemRef;
	ItemKey = Parameters.ItemKey;
	If ItemRef.IsEmpty() Then
		ItemRef = ItemKey.Item;
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
Procedure OnOpen(Cancel)
	CurrentItem = Items.Quantity;
#If MobileClient Then
	If AutoMode Then
		BeginEditingItem();
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
	Data.Insert("RowId", RowId);
	Close(Data);
EndProcedure