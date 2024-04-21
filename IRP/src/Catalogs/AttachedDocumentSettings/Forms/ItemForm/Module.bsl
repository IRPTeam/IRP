
&AtClient
Procedure DescriptionStartChoice(Item, ChoiceData, StandardProcessing)
	
	StandardProcessing = False;
	CallbackDescription = New NotifyDescription("AfterDocTypeSelect", ThisObject, New Structure);
	OpenForm(
		"Catalog.AttachedDocumentSettings.Form.FormChoiseDocsName", 
		,
		,
		,
		,
		,
		CallbackDescription,
		FormWindowOpeningMode.LockOwnerWindow);	
	
EndProcedure

&AtClient
Procedure AfterDocTypeSelect(Result, AdditionalParameters) Export
	
	If Result <> Undefined Then
		Object.Description = Result;
	EndIf;	
	
EndProcedure	

&AtClient
Procedure FileSettingsFileTemplateStartChoice(Item, ChoiceData, StandardProcessing)
	
	StandardProcessing = False;
	
	AttachTemplateAtClient();
	
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "UpdateObjectPictures_AddNewOne" Then
		Items.FileSettings.CurrentData.FileTemplate = Parameter;
	EndIf;
	
EndProcedure

&AtClient
Async Procedure AttachTemplateAtClient()
	
	If Object.Ref.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_WriteObject);
		Return;
	EndIf;
	
	Structure = New Structure;
	Structure.Insert("Ref", Object.Ref);
	Structure.Insert("UUID", ThisObject.UUID);
	
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	FileRef = Await PutFileToServerAsync(, , , , ThisObject.UUID);
	Volume = PictureViewerServer.GetIntegrationSettingsFile().DefaultFilesStorageVolume;
	PictureViewerClient.AddFile(FileRef, Volume, Structure);
	
EndProcedure

