
// Get picture URL.
// 
// Parameters:
//  FileRef - See PictureViewerServer.CreatePictureParameters
// 
// Returns:
//  String
Function GetPictureURL(FileRef) Export
	URLStructure = PictureViewerServer.GetPictureURL(FileRef);
	ProcessingCommonModule = Eval(URLStructure.ProcessingModule);
	Return ProcessingCommonModule.PreparePictureURL(URLStructure.IntegrationSettings, URLStructure.PictureURL);
EndFunction

Function GetPictureURLByFileID(FileID) Export
	Return PictureViewerServer.GetPictureURLByFileID(FileID);
EndFunction

Function GetIntegrationSettingsPicture(Val FileStorageVolume = Undefined) Export
	Return PictureViewerServer.GetIntegrationSettingsPicture(FileStorageVolume);
EndFunction

Function GetArrayOfUnusedFiles(POSTIntegrationSettings) Export
	ConnectionSettings = IntegrationClientServer.ConnectionSetting(
			ServiceSystemServer.GetObjectAttribute(POSTIntegrationSettings, "UniqueID"));

	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;

	If ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.FileStorage") Then
		ConnectionSettings.Value.QueryType = "POST";
		ResourceParameters = New Structure();
		ResourceParameters.Insert("filename", "cleaner_service");

		RequestParameters = New Structure();
		RequestParameters.Insert("get_unused_files", "True");

		RequestResult = IntegrationClientServer.SendRequest(ConnectionSettings.Value, ResourceParameters,
			RequestParameters);

		If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
			Return CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody).Data.ArrayOfUnusedFiles;
		Else
			Return New Array();
		EndIf;
	ElsIf ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		Return IntegrationServer.GetArrayOfUnusedFiles(ConnectionSettings.Value.AddressPath);
	EndIf;
EndFunction

Procedure DeleteUnusedFiles(ArrayOfFilesID, PostIntegrationSettings) Export
	ConnectionSettings = IntegrationClientServer.ConnectionSetting(
			ServiceSystemServer.GetObjectAttribute(POSTIntegrationSettings, "UniqueID"));

	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;

	If ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.FileStorage") Then
		ConnectionSettings.Value.QueryType = "POST";
		ResourceParameters = New Structure();
		ResourceParameters.Insert("filename", "cleaner_service");

		RequestParameters = New Structure();
		RequestParameters.Insert("delete_unused_files", "True");

		RequestBody = CommonFunctionsServer.SerializeJSON(New Structure("ArrayOfFilesID", ArrayOfFilesID));

		RequestResult = IntegrationClientServer.SendRequest(ConnectionSettings.Value, ResourceParameters,
			RequestParameters, RequestBody);
		If Not IntegrationClientServer.RequestResultIsOk(RequestResult) Then
			Raise RequestResult.Message;
		EndIf;
	ElsIf ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		IntegrationServer.DeleteUnusedFiles(ConnectionSettings.Value.AddressPath, ArrayOfFilesID);
	EndIf;
EndProcedure

// Ref info.
// 
// Returns:
//  Structure - Ref info:
// * Ref - See typeFilesOwner 
// * UUID - UUID - Form UUID 
Function RefInfo() Export
	StrParam = New Structure();
	StrParam.Insert("Ref", Undefined);
	StrParam.Insert("UUID", Undefined);
	Return StrParam
EndFunction

// Upload.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  Object - CatalogObjectCatalogName, DocumentObjectDocumentName - Object
Procedure Upload(Form, Object) Export
	RefInfo = RefInfo();
	RefInfo.Ref = Object.Ref;
	RefInfo.UUID = Form.UUID;
	OpenFileDialog = New PutFilesDialogParameters(FileDialogMode.Open);
	OpenFileDialog.MultipleChoice = False;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	BeginPutFileToServer(New CallbackDescription("Upload_END", ThisObject, RefInfo), , , , OpenFileDialog, Form.UUID);
EndProcedure

// Upload END.
// 
// Parameters:
//  FileRef - StoredFileDescription,Undefined - File ref
//  RefInfo - See RefInfo
Procedure Upload_END(FileRef, RefInfo) Export
	If FileRef = Undefined Then
		Return;
	EndIf;
	AddFile(FileRef, Undefined, RefInfo);
EndProcedure

Function UploadPicture(File, Volume, AdditionalParameters = Undefined) Export
	
	isFileImage = PictureViewerClientServer.isImage(File.FileRef.Extension);
	If isFileImage Then
		IntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture(Volume);
	Else
		IntegrationSettings = PictureViewerServer.GetIntegrationSettingsFile(Volume);
	EndIf;
	
	ConnectionSettings = IntegrationClientServer.ConnectionSetting(
			ServiceSystemServer.GetObjectAttribute(IntegrationSettings.POSTIntegrationSettings, "UniqueID"));
	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;
	
	If ConnectionSettings.Value.Property("ServerSideConnection") 
			And ConnectionSettings.Value.ServerSideConnection = True Then
		Return PictureViewerServer.UploadPicture(
			FilesClientServer.GetStoredFileDescriptionWrapper(, File), Volume, AdditionalParameters);
	EndIf;
	
	Return PictureViewerClientServer.UploadPicture(File, ConnectionSettings, AdditionalParameters);

EndFunction

Function GetMainPictureAndPutToTempStorage(FileRef, UUID) Export
	FileInfo = PictureViewerServer.GetFileInfo(FileRef);
	IntegrationSettings = GetIntegrationSettingsPicture(ServiceSystemServer.GetObjectAttribute(FileRef, "Volume"));
	Return GetPictureAndPutToTempStorage(UUID, FileInfo.URI, IntegrationSettings.GETIntegrationSettings);

EndFunction

Function GetPictureAndPutToTempStorage(UUID, URI, GETIntegrationSettings) Export

	ConnectionSettings = IntegrationClientServer.ConnectionSetting(
			ServiceSystemServer.GetObjectAttribute(GETIntegrationSettings, "UniqueID"));

	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;
	
	If ConnectionSettings.Value.Property("ServerSideConnection") 
			And ConnectionSettings.Value.ServerSideConnection = True Then
		Return PictureViewerServer.GetPictureAndPutToTempStorage(UUID, URI, ConnectionSettings);
	EndIf;
	
	Return PictureViewerClientServer.GetPictureAndPutToTempStorage(UUID, URI, ConnectionSettings);

EndFunction

Function PicturesInfoForSlider(ItemRef, UUID, FileRef = Undefined, UseFullSizePhoto = False) Export

	Pictures = PictureViewerServer.PicturesInfoForSlider(ItemRef, FileRef, UseFullSizePhoto);
	PicArray = New Array();
		
	For Each Picture In Pictures Do
		PictureStructure = New Structure("Src, Preview, ID");
		
		TempStorageURL = StrSplit(PutToTempStorage("", UUID), "?");
		SeanceID = "";
		If TempStorageURL.Count() > 1 Then
			SeanceID = "&" + TempStorageURL[TempStorageURL.UBound()];
		EndIf;
		Preview = Picture.Preview + SeanceID;
		
		If UseFullSizePhoto Then
			
			If TypeOf(Picture.Src) = Type("String") Then
				ProcessingCommonModule = Eval(Picture.PictureURLStructure.ProcessingModule);
				Picture.Src = ProcessingCommonModule.PreparePictureURL(
								Picture.PictureURLStructure.IntegrationSettings, Picture.Src, UUID);
			EndIf;
			
			If TypeOf(Picture.Src) = Type("String") Then
				PictureStructure.Src = Picture.Src;
			ElsIf TypeOf(Picture.Src) = Type("BinaryData") Then
				PictureStructure.Src = PutToTempStorage(Picture.Src, UUID);
			Else
				PictureStructure.Src = Preview;
			EndIf;
		Else
			PictureStructure.Src = Preview;
		EndIf;
		
		PictureStructure.Preview = Preview;
		PictureStructure.ID = Picture.ID;
		PicArray.Add(PictureStructure);
	EndDo;	
	
	StrForJSON = New Structure("Pictures", PicArray);
	PicArrayJSON = CommonFunctionsServer.SerializeJSON(StrForJSON);
	Return PicArrayJSON;

EndFunction

Procedure SetPDFForView(FileRef, PDFViewer) Export
	PictureParameters = PictureViewerServer.CreatePictureParameters(FileRef);
	
	URI = GetPictureURL(PictureParameters); //String
	BD = GetFromTempStorage(URI); // BinaryData
	If Not BD = Undefined Then
		BDB = GetBinaryDataBufferFromBinaryData(BD);
		MemoryStream = New MemoryStream(BDB); 
		PDFViewer.ReadAsync(MemoryStream);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_040);
	EndIf;
EndProcedure

#Region FormEvents

Procedure PictureViewHTMLOnClick(Form, Item, EventData, StandardProcessing) Export
	StandardProcessing = EventData.Href = Undefined;

	If EventData.Button = Undefined Or Not EventData.Button.Id = "call1CEvent" Then
		Return;
	EndIf;
	If Form.Object.Ref.isEmpty() Then
		ShowMessageBox(Undefined, R().InfoMessage_004);
	Else
		HTMLEvent(Form, Form.Object, Item.Document.defaultView.call1C);
	EndIf;
EndProcedure

Procedure UpdateObjectPictures(Form, OwnerRef) Export
	UpdateObjectPictureHTML(Form, OwnerRef);
EndProcedure

Procedure UpdateObjectPictureHTML(Form, OwnerRef)
	Form.PictureViewHTML = PictureViewerServer.HTMLPictureSlider();
EndProcedure

// Return main HTML window for eval js code
Function InfoDocumentComplete(Item) Export

#If MobileAppClient Or MobileClient Then
	BrWindow = Item.document.defaultView;
#Else
	BrWindow = Item.document.parentWindow;
	If BrWindow = Undefined Then
		BrWindow = Item.document.defaultView;
	EndIf;
#EndIf
	Return BrWindow;
EndFunction

Procedure HTMLEvent(Form, Object, Val Data, AddInfo = Undefined) Export
	Data = CommonFunctionsServer.DeserializeJSON(Data);
	If Data.value = "add_picture" Then
		Upload(Form, Object);
	ElsIf Data.value = "addImagesFromGallery" Then
		NotifyOnClose = New CallbackDescription("AddPictureFromGallery", ThisObject, New Structure("Object, Form",
			Object, Form));
		OpenForm("CommonForm.PictureGalleryForm", , ThisObject, , , , NotifyOnClose);
	ElsIf Data.value = "update_slider" Then
		Notify("UpdateObjectPictures_UpdateAll", , Form.UUID);
	ElsIf Data.value = "remove_picture" Then
		FileInfo = PictureViewerServer.GetFileRefByFileID(Data.ID);
		PictureViewerServer.UnlinkFileFromObject(FileInfo.Ref, Object.Ref);
		Notify("UpdateObjectPictures_Delete", Data.ID, Form.UUID);
	ElsIf Data.value = "zoom_img" Then
		FileInfo = PictureViewerServer.GetFileRefByFileID(Data.ID);
		OpenValueAsync(FileInfo.Ref);
	ElsIf Data.value = "change_priority" Then
		FileInfo = PictureViewerServer.GetFileRefByFileID(Data.ID);
		Rise = Number(Data.priority);
		PictureViewerServer.ChangePriorityFile(Object.Ref, FileInfo.Ref, Rise);
		Notify("UpdateObjectPictures_UpdateAll", , Form.UUID);
	Else
		Return;
	EndIf;
EndProcedure

Procedure HTMLEventAction(Val EventName, Val Parameter, Val Source, Form) Export
	If EventName = "UpdateObjectPictures" And Source = Form.UUID Then
		UpdateHTMLPicture(Form.Items.PictureViewHTML, Form);
	ElsIf EventName = "UpdateObjectPictures_AddNewOne" And Source = Form.UUID Then
		HTMLWindow = InfoDocumentComplete(Form.Items.PictureViewHTML);
		PictureInfo = PicturesInfoForSlider(Form.Object.Ref, Form.UUID, Parameter);
		JSON = CommonFunctionsServer.SerializeJSON(PictureInfo);
		HTMLWindow.addNewSlide(JSON);
	ElsIf EventName = "UpdateObjectPictures_Delete" And Source = Form.UUID Then
		HTMLWindow = InfoDocumentComplete(Form.Items.PictureViewHTML);
		HTMLWindow.removeCurrentSlide(Parameter);
	ElsIf EventName = "UpdateObjectPictures_UpdateAll" And Source = Form.UUID Then
		UpdateHTMLPicture(Form.Items.PictureViewHTML, Form);
	EndIf;
EndProcedure

Procedure AddPictureFromGallery(ClosureResult, AdditionalParameters) Export

	If Not ValueIsFilled(ClosureResult) Then
		Return;
	EndIf;

	isAddedNew = False;
	For Each FileRef In ClosureResult Do
		If Not PictureViewerServer.IsFileRefBelongToOwner(FileRef, AdditionalParameters.Object.Ref) Then
			isAddedNew = True;
			PictureViewerServer.LinkFileToObject(FileRef, AdditionalParameters.Object.Ref);
		EndIf;
	EndDo;

	If isAddedNew Then
		Notify("UpdateObjectPictures_UpdateAll", , AdditionalParameters.Form.UUID);
	EndIf;
EndProcedure

Async Procedure UpdateHTMLPicture(Item, Form) Export
	HTMLWindow = InfoDocumentComplete(Item);
	JSON = PicturesInfoForSlider(Form.Object.Ref, Form.UUID);
	HTMLWindow.fillSlider(JSON);
EndProcedure

// Add file.
// 
// Parameters:
//  File - StoredFileDescription, Undefined - File
//  Volume - Undefined - Volume
//  RefInfo - See RefInfo
Procedure AddFile(File, Val Volume = Undefined, RefInfo) Export
	If File = Undefined Then
		Return;
	EndIf;

	Ref = RefInfo.Ref;

	If Volume = Undefined Then
		If PictureViewerServer.isImage(File.FileRef.Extension) Then
			Volume = PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume;
		Else
			Volume = PictureViewerServer.GetIntegrationSettingsFile().DefaultFilesStorageVolume;
		EndIf;
	EndIf;

	FileInfo = UploadPicture(File, Volume, RefInfo);
	If FileInfo.Success Then
		PictureViewerServer.CreateAndLinkFileToObject(Volume, FileInfo, Ref);
		Notify("UpdateObjectPictures_AddNewOne", FileInfo.Ref, RefInfo.UUID);
	EndIf;
EndProcedure

#EndRegion

#Region ButtonsControl

// HTMLView control.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  CommandName - String - Command
Procedure HTMLViewControl(Form, CommandName) Export
	
	CommandItem = Form.Items[CommandName];
	CommandItem.Check = Not CommandItem.Check;
	Visible = CommandItem.Check;
	
	If Visible Then
		//@skip-warning
		CommandItem.BackColor = CommonFunctionsServer.GetStyleByName("ActivityColor");
	Else
		//@skip-warning
		CommandItem.BackColor = CommonFunctionsServer.GetStyleByName("ButtonBackColor");
	EndIf;
	
	If CommandName = "ViewPictures" Then
		Form.Items.PictureViewHTML.Visible = Visible;
		UpdateObjectPictures(Form, PredefinedValue("Catalog.Items.EmptyRef"));
	ElsIf CommandName = "ViewAdditionalAttribute" Then
		Form.Items.AddAttributeViewHTML.Visible = Visible;
		AddAttributesAndPropertiesClient.UpdateObjectAddAttributeHTML(Form, PredefinedValue("Catalog.Items.EmptyRef"));
	EndIf;
	
EndProcedure

#EndRegion
