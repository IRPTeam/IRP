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

Procedure Upload(Form, Object, Volume) Export

	If Not PictureViewerServer.IsPictureFile(Volume) Then
		Raise R().Error_040;
	EndIf;
	StrParam = New Structure("Ref, UUID", Object.Ref, Form.UUID);
	Notify = New NotifyDescription("SelectFileEnd", ThisObject, StrParam);
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	BeginPuttingFiles(Notify, , OpenFileDialog, True, Form.UUID);
EndProcedure

Function UploadPicture(File, Volume) Export

	md5 = String(PictureViewerServer.MD5ByBinaryData(File.Location));
	FileRef = PictureViewerServer.GetFileRefByMD5(md5);
	If ValueIsFilled(FileRef) Then
		Return PictureViewerServer.GetFileInfo(FileRef);
	EndIf;
	RequestBody = GetFromTempStorage(File.Location);

	If PictureViewerServer.IsPictureFile(Volume) Then
		PictureScaleSize = 200;
		FileInfo = PictureViewerServer.UpdatePictureInfoAndGetPreview(RequestBody, PictureScaleSize);
	Else
		FileInfo = PictureViewerClientServer.FileInfo();
	EndIf;

	IntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture();

	FileID = String(New UUID());
	FileInfo.FileID = FileID;
	FileInfo.FileName = File.Name;
	FileInfo.MD5 = md5;
	FileInfo.Extension = StrSplit(File.Name, ".")[StrSplit(File.Name, ".").UBound()];

	ConnectionSettings = IntegrationClientServer.ConnectionSetting(
			ServiceSystemServer.GetObjectAttribute(IntegrationSettings.POSTIntegrationSettings, "UniqueID"));

	If Not ConnectionSettings.Success Then
		Raise ConnectionSettings.Message;
	EndIf;
	Parameters = New Structure();
	Parameters.Insert("ConnectionSettings", ConnectionSettings);
	Parameters.Insert("RequestBody", RequestBody);
	Parameters.Insert("FileID", FileID);
	If ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		IntegrationServer.SaveFileToFileStorage(ConnectionSettings.Value.AddressPath, FileID + "."
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

Function ExtensionCall_UploadPicture(FileInfo, Parameters)
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

	Pictures = PictureViewerServer.PicturesInfoForSlider(ItemRef, FileRef);

	PicArray = New Array();
	For Each Picture In Pictures Do
		Map = New Structure("Src, Preview, ID");
		If UseFullSizePhoto Then
			ProcessingCommonModule = Eval(Picture.PictureURLStructure.ProcessingModule);
			Picture.Src = ProcessingCommonModule.PreparePictureURL(
								Picture.PictureURLStructure.IntegrationSettings, Picture.Src, UUID);
			If Picture.SrcBD = Undefined Then
				Map.Src = Picture.Src;
			Else
				Map.Src = PutToTempStorage(Picture.SrcBD, UUID);
			EndIf;
		Else
			Map.Src = PutToTempStorage(Picture.PreviewBD, UUID);
		EndIf;
		If Picture.PreviewBD = Undefined Then
			If Not ValueIsFilled(Picture.Preview) Then
				Map.Preview = Picture.Src;
			Else
				Map.Preview = Picture.Preview;
			EndIf;
		Else
			Map.Preview = PutToTempStorage(Picture.PreviewBD, UUID);
		EndIf;

		Map.ID = Picture.ID;
		PicArray.Add(Map);
	EndDo;

	Str = New Structure("Pictures", PicArray);

	Return Str;

EndFunction

#Region FormEvents

Procedure PictureViewHTMLOnClick(Form, Item, EventData, StandardProcessing) Export
	StandardProcessing = EventData.Href = Undefined;

	If EventData.Button = Undefined Or Not EventData.Button.Id = "call1CEvent" Then
		Return;
	EndIf;
	If Form.Object.Ref.isEmpty() Then
		ShowMessageBox(Undefined, R().InfoMessage_004);
	Else
		PictureViewerClient.HTMLEvent(Form, Form.Object, Item.Document.defaultView.call1C);
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
		Upload(Form, Object, PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume);
	ElsIf Data.value = "addImagesFromGallery" Then
		NotifyOnClose = New NotifyDescription("AddPictureFromGallery", ThisObject, New Structure("Object, Form",
			Object, Form));
		OpenForm("CommonForm.PictureGalleryForm", , ThisObject, , , , NotifyOnClose);
	ElsIf Data.value = "update_slider" Then
		Notify("UpdateObjectPictures_UpdateAll", , Form.UUID);
	ElsIf Data.value = "remove_picture" Then
		FileRef = PictureViewerServer.GetFileRefByFileID(Data.ID);
		PictureViewerServer.UnlinkFileFromObject(FileRef.Ref, Object.Ref);
		Notify("UpdateObjectPictures_Delete", Data.ID, Form.UUID);
	EndIf;
EndProcedure

Procedure HTMLEventAction(Val EventName, Val Parameter, Val Source, Form) Export
	If EventName = "UpdateObjectPictures" And Source = Form.UUID Then
		UpdateHTMLPicture(Form.Items.PictureViewHTML, Form);
	ElsIf EventName = "UpdateObjectPictures_AddNewOne" And Source = Form.UUID Then
		HTMLWindow = PictureViewerClient.InfoDocumentComplete(Form.Items.PictureViewHTML);
		PictureInfo = PictureViewerClient.PicturesInfoForSlider(Form.Object.Ref, Form.UUID, Parameter);
		JSON = CommonFunctionsServer.SerializeJSON(PictureInfo);
		HTMLWindow.addNewSlide(JSON);
	ElsIf EventName = "UpdateObjectPictures_Delete" And Source = Form.UUID Then
		HTMLWindow = PictureViewerClient.InfoDocumentComplete(Form.Items.PictureViewHTML);
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

Procedure UpdateHTMLPicture(Item, Form) Export
	HTMLWindow = PictureViewerClient.InfoDocumentComplete(Item);
	PictureInfo = PictureViewerClient.PicturesInfoForSlider(Form.Object.Ref, Form.UUID);
	JSON = CommonFunctionsServer.SerializeJSON(PictureInfo);
	HTMLWindow.fillSlider(JSON);
EndProcedure

Procedure SelectFileEnd(Files, AdditionalParameters) Export
	If Files = Undefined Then
		Return;
	EndIf;
	If Files.Count() > 1 Then
		Raise R().Error_035;
	EndIf;

	Ref = AdditionalParameters.Ref;

	DefaultPictureStorageVolume = PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume;
	FileInfo = UploadPicture(Files[0], DefaultPictureStorageVolume);
	If FileInfo.Success Then
		PictureViewerServer.CreateAndLinkFileToObject(DefaultPictureStorageVolume, FileInfo, Ref);
		Notify("UpdateObjectPictures_AddNewOne", FileInfo.Ref, AdditionalParameters.UUID);
	EndIf;
EndProcedure
#EndRegion