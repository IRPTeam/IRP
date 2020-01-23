&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetVisible();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ShowPicture();
EndProcedure

&AtClient
Procedure VolumeOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	ShowPicture();
EndProcedure

&AtServer
Procedure SetVisible()
	IsPicture = PictureViewerServer.IsPictureFile(Object.Volume);
	UsePreview1 = ValueIsFilled(Object.Volume) And ServiceSystemServer.GetObjectAttribute(Object.Volume, "UsePreview1");
	
	Items.Height.Visible = IsPicture;
	Items.Width.Visible = IsPicture;
	Items.SizeBytes.Visible = IsPicture;
	Items.Preview1URI.Visible = IsPicture And UsePreview1;
	Items.CreatePreview1.Visible = IsPicture And UsePreview1;
EndProcedure

&AtClient
Procedure ShowPicture()
	If PictureViewerServer.IsPictureFile(Object.Volume) Then
		ThisObject.PictureViewHTML
			= "<html><img src=""" + PictureViewerServer.GetPictureURL(Object.Ref).PictureURL + """ height=""100%""></html>";
	EndIf;
EndProcedure

&AtClient
Procedure CreatePreview1(Command)
	FileInfo = PictureViewerClient.CreatePreview1(Object);
	If FileInfo.Success Then
		PictureViewerClientServer.SetFileInfo(FileInfo, Object);
		Write();
		ShowPicture();
	EndIf;
EndProcedure

&AtClient
Procedure Upload(Command)
	PictureViewerClient.Upload(ThisForm, ThisObject, Object.Volume);
EndProcedure

&AtClient
Procedure SelectFileEnd(Files, AdditionalParameters) Export
	If Files = Undefined Then
		Return;
	EndIf;
	If Files.Count() > 1 Then
		Raise R().Error_035;
	EndIf;
	FileInfo = PictureViewerClient.UploadPicture(Files[0], Object.Volume);
	If FileInfo.Success And Not ValueIsFilled(FileInfo.Ref) Then
		PictureViewerClientServer.SetFileInfo(FileInfo, Object);
		Write();
	Else
		ThisObject.Modified = False;
		ThisObject.Close();
		OpenForm("Catalog.Files.ObjectForm", New Structure("Key", FileInfo.Ref));
	EndIf;
EndProcedure

