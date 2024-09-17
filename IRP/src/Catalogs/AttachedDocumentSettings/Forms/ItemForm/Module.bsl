
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
Procedure AttachTemplateAtClient()
	
	If Object.Ref.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_WriteObject);
		Return;
	EndIf;
	
	Structure = New Structure;
	Structure.Insert("Ref", Object.Ref);
	Structure.Insert("UUID", ThisObject.UUID);
	
	OpenFileDialog = New PutFilesDialogParameters(FileDialogMode.Open);
	OpenFileDialog.MultipleChoice = False;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	
	BeginPutFileToServer(New CallbackDescription("AttachTemplateAtClient_END", ThisObject, Structure), , , , OpenFileDialog, ThisObject.UUID);
	
EndProcedure

&AtClient
Procedure AttachTemplateAtClient_END(FileRef, AdditionalParameters) Export
	If FileRef = Undefined Then
		Return;
	EndIf;
	
	Volume = PictureViewerServer.GetIntegrationSettingsFile().DefaultFilesStorageVolume;
	PictureViewerClient.AddFile(FileRef, Volume, AdditionalParameters);
EndProcedure
