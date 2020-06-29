
#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControll();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetVisible();
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	If Object.isPreviewSet Then
		CurrentObject = FormAttributeToValue("Object");
		Preview = PutToTempStorage(CurrentObject.Preview.Get());
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ShowPicture();
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	ShowPicture();
EndProcedure

#EndRegion

&AtClient
Procedure VolumeOnChange(Item)
	SetVisible();
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

&AtServer
Function CreatePictureParameters()
	PictureParameters = New Structure();
	PictureParameters.Insert("Ref", Object.Ref);
	PictureParameters.Insert("Description", Object.Description);
	PictureParameters.Insert("FileID", Object.FileID);
	PictureParameters.Insert("isFilledVolume", Object.Volume <> Catalogs.IntegrationSettings.EmptyRef());
	PictureParameters.Insert("GETIntegrationSettings", Object.Volume.GETIntegrationSettings);
	PictureParameters.Insert("UsePreview1", Object.Volume.UsePreview1);
	PictureParameters.Insert("Preview1GETIntegrationSettings", Object.Volume.Preview1GETIntegrationSettings);
	PictureParameters.Insert("isLocalPictureURL", 
	Object.Volume.GETIntegrationSettings.IntegrationType = Enums.IntegrationType.LocalFileStorage);
	PictureParameters.Insert("isLocalPreview1URL", 
	Object.Volume.Preview1GETIntegrationSettings.IntegrationType = Enums.IntegrationType.LocalFileStorage);
	PictureParameters.Insert("Preview1URI", Object.Preview1URI);
	PictureParameters.Insert("URI", Object.URI);
	
	Return PictureParameters;		
EndFunction	

&AtClient
Procedure ShowPicture()
	If PictureViewerServer.IsPictureFile(Object.Volume) Then
		PictureParameters = CreatePictureParameters();	
		ThisObject.PictureViewHTML
			= "<html><img src=""" + PictureViewerServer.GetPictureURL(PictureParameters).PictureURL + """ height=""100%""></html>";
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
	PictureViewerClient.Upload(ThisForm, Object, Object.Volume);
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

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControll()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion
