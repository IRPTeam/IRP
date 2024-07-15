
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

Async Procedure Upload(Form, Object) Export
	StrParam = New Structure("Ref, UUID", Object.Ref, Form.UUID);
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	FileRef = Await PutFileToServerAsync(, , , , Form.UUID);
	AddFile(FileRef, Undefined, StrParam);
EndProcedure

Function UploadPicture(File, Volume, AdditionalParameters = Undefined) Export
	
	md5 = String(PictureViewerServer.MD5ByBinaryData(File.Address));
	FileRef = PictureViewerServer.GetFileRefByMD5(md5);
	If ValueIsFilled(FileRef) Then
		Return PictureViewerServer.GetFileInfo(FileRef);
	EndIf;
	RequestBody = GetFromTempStorage(File.Address);

	If PictureViewerServer.isImage(File.FileRef.Extension) Then
		PictureScaleSize = 200;
		FileInfo = PictureViewerServer.UpdatePictureInfoAndGetPreview(RequestBody, PictureScaleSize);
		IntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture(Volume);
	Else
		FileInfo = PictureViewerClientServer.FileInfo();
		IntegrationSettings = PictureViewerServer.GetIntegrationSettingsFile(Volume);
	EndIf;

	FileID = String(New UUID());
	FileInfo.FileID = FileID;
	FileInfo.FileName = File.FileRef.Name;
	FileInfo.MD5 = md5;
	FileInfo.Extension = StrReplace(File.FileRef.Extension, ".", "");

	ConnectionSettings = IntegrationClientServer.ConnectionSetting(
			ServiceSystemServer.GetObjectAttribute(IntegrationSettings.POSTIntegrationSettings, "UniqueID"));

	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;
	
	If TypeOf(AdditionalParameters) = Type("Structure") Then
		
		If AdditionalParameters.Property("FilePrefix") Then
			FilePrefix = AdditionalParameters.FilePrefix;
			FileID = StrTemplate("%1__%2", FilePrefix, FileID);
			//
			FileInfo.FileName = FilePrefix;
			//
		EndIf;
		
		If AdditionalParameters.Property("PrintFormName") Then
			FileInfo.PrintFormName = AdditionalParameters.PrintFormName;
		EndIf;
	EndIf;
	
	Parameters = New Structure();
	Parameters.Insert("ConnectionSettings", ConnectionSettings);
	Parameters.Insert("RequestBody", RequestBody);
	Parameters.Insert("FileID", FileID);
	If ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		FileName = FileID;
		IntegrationServer.SaveFileToFileStorage(ConnectionSettings.Value.AddressPath, FileName + "."
			+ FileInfo.Extension, RequestBody);
		FileInfo.Success = True;
		FileInfo.URI = FileID + "." + FileInfo.Extension;

	ElsIf Not ExtensionCall_UploadPicture(FileInfo, Parameters) Then
		ConnectionSettings.Value.QueryType = "POST";
		ResourceParameters = New Structure();
		ResourceParameters.Insert("filename", FileID + "." + FileInfo.Extension);

		RequestResult = IntegrationClientServer.SendRequest(ConnectionSettings.Value, ResourceParameters, , RequestBody);
		If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
			DeserializeResponse = CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody);
			FileInfo.URI = DeserializeResponse.Data.URI;
			FileInfo.Success = True;
		Else
			FileInfo.Success = False;
		EndIf;
	EndIf;
	Return FileInfo;
EndFunction

Function ExtensionCall_UploadPicture(FileInfo, Parameters) Export
	Return False
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
	ConnectionSettings.Value.QueryType = "GET";
	ResourceParameters = New Structure();
	ResourceParameters.Insert("filename", URI);
	RequestResult = IntegrationClientServer.SendRequest(ConnectionSettings.Value, ResourceParameters);

	If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
		Return PutToTempStorage(New Picture(RequestResult.ResponseBody), UUID);
	Else
		Return "";
	EndIf;
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
		NotifyOnClose = New NotifyDescription("AddPictureFromGallery", ThisObject, New Structure("Object, Form",
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

Procedure AddFile(File, Val Volume, AdditionalParameters) Export
	If File = Undefined Then
		Return;
	EndIf;

	Ref = AdditionalParameters.Ref;

	If Volume = Undefined Then
		If PictureViewerServer.isImage(File.FileRef.Extension) Then
			Volume = PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume;
		Else
			Volume = PictureViewerServer.GetIntegrationSettingsFile().DefaultFilesStorageVolume;
		EndIf;
	EndIf;

	FileInfo = UploadPicture(File, Volume, AdditionalParameters);
	If FileInfo.Success Then
		PictureViewerServer.CreateAndLinkFileToObject(Volume, FileInfo, Ref);
		Notify("UpdateObjectPictures_AddNewOne", FileInfo.Ref, AdditionalParameters.UUID);
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
