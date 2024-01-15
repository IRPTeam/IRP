#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetVisible();
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	If Object.isPreviewSet Then
		CurrentObject = FormAttributeToValue("Object");
		Preview = PutToTempStorage(CurrentObject.Preview.Get());
	EndIf;
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
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
	IsPicture = PictureViewerServer.isImage("." + Object.Extension);

	Items.Height.Visible = IsPicture;
	Items.Width.Visible = IsPicture;
	Items.SizeBytes.Visible = IsPicture;
EndProcedure

&AtServer
Function CreatePictureParameters()
	Return PictureViewerServer.CreatePictureParameters(Object);
EndFunction

&AtClient
Procedure ShowPicture()
	If Not Object.Volume.IsEmpty() And PictureViewerServer.isImage("." + Object.Extension) Then
		PictureParameters = CreatePictureParameters();

		ThisObject.PictureViewHTML = "<html><img src=""" + PictureViewerClient.GetPictureURL(PictureParameters)
			+ """ height=""100%""></html>";
	EndIf;
EndProcedure

&AtClient
Procedure Upload(Command)
	PictureViewerClient.Upload(ThisObject, Object);
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
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion