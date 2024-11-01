
Function AllPictureExtensions(AddInfo = Undefined) Export
	Return StrSplit("jpeg,jpg,png,ico", ",");
EndFunction

Function FilterForPicturesDialog() Export

	Data = "*." + StrConcat(AllPictureExtensions(), ";*.");
	Return "(" + Data + ")|" + Data;

EndFunction

Function PreparePictureURL(IntegrationSettings, URI, UUID = "", AddInfo = Undefined) Export
	Return URI;
EndFunction

// Get image extensions.
// 
// Parameters:
//  Mode - Number - Mode:
// 0 - only extension
// 1 - begin on a point
// 2 - as file pattern
// 
// Returns:
//  Array - Get image extensions
Function GetImageExtensions(Mode = 1) Export
	// BSLLS:Typo-off
	ImgList = ".ase,.art,.bmp,.blp,.cd5,.cit,.cpt,.cr2,.cut,.dds,.dib,.djvu,.egt,.exif,.gif,.gpl,.grf,.icns,.ico,.iff,.jng,.jpeg,.jpg,.jfif,.jp2,.jps,.lbm,.max,.miff,.mng,.msp,.nitf,.ota,.pbm,.pc1,.pc2,.pc3,.pcf,.pcx,.pdn,.pgm,.PI1,.PI2,.PI3,.pict,.pct,.pnm,.pns,.ppm,.psb,.psd,.pdd,.psp,.px,.pxm,.pxr,.qfx,.raw,.rle,.sct,.sgi,.rgb,.int,.bw,.tga,.tiff,.tif,.vtf,.xbm,.xcf,.xpm,.3dv,.amf,.ai,.awg,.cgm,.cdr,.cmx,.dxf,.e2d,.egt,.eps,.fs,.gbr,.odg,.svg,.stl,.vrml,.x3d,.sxd,.v2d,.vnd,.wmf,.emf,.art,.xar,.png,.webp,.jxr,.hdp,.wdp,.cur,.ecw,.iff,.lbm,.liff,.nrrd,.pam,.pcx,.pgf,.sgi,.rgb,.rgba,.bw,.int,.inta,.sid,.ras,.sun,.tga";
	// BSLLS:Typo-on
	Result = StrSplit(ImgList, ",");
	If Not Mode = 1 Then
		For index = 0 To Result.UBound() Do
			If Mode = 0 Then
				Result[index] = Mid(Result[index], 2);
			ElsIf Mode = 2 Then
				Result[index] = "*" + Result[index];
			EndIf;
		EndDo;
	EndIf;
	Return Result;
EndFunction

// Is image.
// 
// Parameters:
//  Extensions - String - Extensions
// 
// Returns:
//  Boolean - Is image
Function isImage(Val Extensions) Export
	Extensions = StrReplace(Extensions, ".", "");
	Return Not GetImageExtensions(0).Find(Lower(Extensions)) = Undefined; 
EndFunction

// See FilesClientServer.GetFileInfo
Function FileInfo() Export
	Return FilesClientServer.GetFileInfo();
EndFunction

// See FilesClientServer.SetFileInfo
Procedure SetFileInfo(FileInfo, Object) Export
	FilesClientServer.SetFileInfo(FileInfo, Object);
EndProcedure

Function UploadPicture(File, ConnectionSettings, AdditionalParameters = Undefined) Export
	
	md5 = String(PictureViewerServer.MD5ByBinaryData(File.Address));
	FileRef = PictureViewerServer.GetFileRefByMD5(md5);
	If ValueIsFilled(FileRef) Then
		Return PictureViewerServer.GetFileInfo(FileRef);
	EndIf;
	RequestBody = GetFromTempStorage(File.Address);

	If isImage(File.FileRef.Extension) Then
		PictureScaleSize = 200;
		FileInfo = PictureViewerServer.UpdatePictureInfoAndGetPreview(RequestBody, PictureScaleSize);
	Else
		FileInfo = FileInfo();
	EndIf;

	FileID = String(New UUID());
	FileInfo.FileID = FileID;
	FileInfo.FileName = File.FileRef.Name;
	FileInfo.MD5 = md5;
	FileInfo.Extension = StrReplace(File.FileRef.Extension, ".", "");

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
	Return False;
EndFunction

