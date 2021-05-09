Function MD5ByBinaryData(TmpAddress) Export
	BinaryData = GetFromTempStorage(TmpAddress);
	Hash = New DataHashing(HashFunction.MD5);
	Hash.Append(BinaryData);
	Return Hash.HashSum;
EndFunction

Function PictureURLStructure()
	Structure = New Structure;
	Structure.Insert("PictureRef", "");
	Structure.Insert("PictureURL", "");
	Structure.Insert("IntegrationSettings", "");
	Structure.Insert("isLocalPictureURL", False);
	Structure.Insert("ProcessingModule", "PictureViewerClientServer");
	Return Structure;
EndFunction

Function GetPictureURL(RefStructure) Export
	Result = PictureURLStructure();
	
	If Not ValueIsFilled(RefStructure.Ref) Or Not RefStructure.isFilledVolume Then
		Return Result;
	EndIf;
	Result.PictureRef = RefStructure.Ref;
	Result.PictureURL = GetVolumeURLByIntegrationSettings(RefStructure.GETIntegrationSettings, RefStructure.URI);
	Result.isLocalPictureURL = RefStructure.isLocalPictureURL;
	Result.IntegrationSettings = RefStructure.GETIntegrationSettings;
	If RefStructure.GETIntegrationSettings.IntegrationType = Enums.IntegrationType.GoogleDrive Then
		Result.ProcessingModule = "GoogleDriveClientServer";
	EndIf;

	Return Result;
EndFunction

Function GetPictureURLByFileID(FileID) Export
	FileRef = GetFileRefByFileID(FileID);
	If ValueIsFilled(FileRef) Then
		Return GetPictureURL(FileRef);
	Else
		Return PictureURLStructure();
	EndIf;
EndFunction

Function GetFileRefByMD5(MD5) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	Files.Ref,
		|	NOT Files.Volume = VALUE(Catalog.IntegrationSettings.EmptyRef) AS isFilledVolume,
		|	Files.Volume.GETIntegrationSettings AS GETIntegrationSettings,
		|	Files.Volume.GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
		|		isLocalPictureURL,
		|	Files.URI
		|FROM
		|	Catalog.Files AS Files
		|WHERE
		|	Files.MD5 = &MD5";
	Query.SetParameter("MD5", MD5);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Catalogs.Files.EmptyRef();
	EndIf;
EndFunction

Function GetFileRefByFileID(FileID) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	Files.Ref,
		|	NOT Files.Volume = VALUE(Catalog.IntegrationSettings.EmptyRef) AS isFilledVolume,
		|	Files.Volume.GETIntegrationSettings AS GETIntegrationSettings,
		|	Files.Volume.GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
		|		isLocalPictureURL,
		|	Files.URI
		|FROM
		|	Catalog.Files AS Files
		|WHERE
		|	Files.FileID = &FileID";
	Query.SetParameter("FileID", FileID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Answer = New Structure("Ref, isFilledVolume, GETIntegrationSettings,
							|isLocalPictureURL, URI");
	
	If QuerySelection.Next() Then
		FillPropertyValues(Answer, QuerySelection);
		Return Answer;
	Else
		Return Undefined;
	EndIf;
EndFunction

Function GetFileRefsByFileIDs(FileIDs) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	Files.Ref
		|FROM
		|	Catalog.Files AS Files
		|WHERE
		|	Files.FileID In (&FileIDs)";
	Query.SetParameter("FileIDs", FileIDs);
	Return Query.Execute().Unload().UnloadColumn("Ref");
EndFunction

Function GetPicturesByObjectRef(OwnerRef, DirectLink = False, FileRef = Undefined) Export
	Query = New Query();
	If Not DirectLink And TypeOf(OwnerRef) = Type("CatalogRef.Items") Then
		Query.Text =
			"SELECT
			|	ItemKeys.Ref AS Ref
			|INTO tmp
			|FROM
			|	Catalog.ItemKeys AS ItemKeys
			|WHERE
			|	ItemKeys.Item = &Owner
			|	AND
			|	NOT ItemKeys.DeletionMark
			|
			|UNION ALL
			|
			|SELECT
			|	Items.Ref
			|FROM
			|	Catalog.Items AS Items
			|WHERE
			|	Items.Ref = &Owner
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT DISTINCT
			|	AttachedFiles.File AS Ref,
			|	AttachedFiles.File.FileID AS FileID,
			|	NOT AttachedFiles.File.Volume = VALUE(Catalog.IntegrationSettings.EmptyRef) AS isFilledVolume,
			|	AttachedFiles.File.Volume.GETIntegrationSettings AS GETIntegrationSettings,
			|	AttachedFiles.File.Volume.GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
			|		isLocalPictureURL,
			|	AttachedFiles.File.URI AS URI
			|FROM
			|	InformationRegister.AttachedFiles AS AttachedFiles
			|		INNER JOIN tmp AS tmp
			|		ON AttachedFiles.Owner = tmp.Ref
			|WHERE
			|	CASE
			|		When &ByOneFile
			|			THEN AttachedFiles.File = &File
			|		ELSE TRUE
			|	END";
		Else
			Query.Text =
			"SELECT
			|	AttachedFiles.File AS Ref,
			|	AttachedFiles.File.FileID AS FileID,
			|	NOT AttachedFiles.File.Volume = VALUE(Catalog.IntegrationSettings.EmptyRef) AS isFilledVolume,
			|	AttachedFiles.File.Volume.GETIntegrationSettings AS GETIntegrationSettings,
			|	AttachedFiles.File.Volume.GETIntegrationSettings.IntegrationType = VALUE(Enum.IntegrationType.LocalFileStorage) AS
			|		isLocalPictureURL,
			|	AttachedFiles.File.URI AS URI
			|FROM
			|	InformationRegister.AttachedFiles AS AttachedFiles
			|WHERE
			|	AttachedFiles.Owner = &Owner
			|	AND CASE
			|		When &ByOneFile
			|			THEN AttachedFiles.File = &File
			|		ELSE TRUE
			|	END";
	EndIf;
	Query.SetParameter("Owner", OwnerRef);
	Query.SetParameter("File", FileRef);
	Query.SetParameter("ByOneFile", ValueIsFilled(FileRef));
	Return Query.Execute().Unload();
EndFunction

Function GetPicturesByObjectRefAsArrayOfRefs(OwnerRef, DerectLink = False) Export
	Return GetPicturesByObjectRef(OwnerRef, DerectLink).UnloadColumn("Ref");
EndFunction

Function IsFileRefBelongToOwner(FileRef, OwnerRef) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	AttachedFiles.File
		|FROM
		|	InformationRegister.AttachedFiles AS AttachedFiles
		|WHERE
		|	AttachedFiles.Owner = &Owner
		|	AND AttachedFiles.File = &File";
	Query.SetParameter("File", FileRef);
	Query.SetParameter("Owner", OwnerRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Return QuerySelection.Next();
EndFunction

Function GetIntegrationSettingsPicture(Val FileStorageVolume = Undefined) Export
	If Not ValueIsFilled(FileStorageVolume) Then
		FileStorageVolume = Constants.DefaultPictureStorageVolume.Get();
	EndIf;
	If Not ValueIsFilled(FileStorageVolume) Then
		Raise R().Error_049;
	EndIf;
	Result = New Structure();
	Result.Insert("DefaultPictureStorageVolume", FileStorageVolume);
	Result.Insert("POSTIntegrationSettings", FileStorageVolume.POSTIntegrationSettings);
	Result.Insert("GETIntegrationSettings", FileStorageVolume.GETIntegrationSettings);
	Return Result;
EndFunction

Function GetVolumeURLByIntegrationSettings(IntegrationSettings, URI) Export
	
	If Not ValueIsFilled(IntegrationSettings) Then
		Return "";
	EndIf;
	
	ConnectionSettings = IntegrationClientServer.ConnectionSetting(IntegrationSettings.UniqueID);
	
	FullURL = "";

	If IntegrationSettings.IntegrationType = Enums.IntegrationType.LocalFileStorage Then
		FullURL = ConnectionSettings.Value.AddressPath;
	ElsIf IntegrationSettings.IntegrationType = Enums.IntegrationType.GoogleDrive Then
		Return URI;
	Else	
	
		If ConnectionSettings.Value.Property("SecureConnection") And ConnectionSettings.Value.SecureConnection = True Then
			FullURL = "https://";
		Else
			FullURL = "http://";
		EndIf;
		
		If ConnectionSettings.Value.Property("User") And ConnectionSettings.Value.Property("Password") Then
			FullURL = FullURL + StrTemplate("%1:%2@", ConnectionSettings.Value.User, ConnectionSettings.Value.Password);
		EndIf;
		
		If ConnectionSettings.Value.Property("Ip") Then
			FullURL = FullURL + String(ConnectionSettings.Value.Ip);
		EndIf;
		
		If ConnectionSettings.Value.Property("Port") Then
			FullURL = FullURL + ":" + Format(ConnectionSettings.Value.Port, "NDS=; NG=;");
		EndIf;
		
		If ConnectionSettings.Value.Property("ResourceAddress") Then
			ArrayOfSegments = StrSplit(ConnectionSettings.Value.ResourceAddress, "/");
			ArrayOfNewSegments = New Array();
			For Each Segment In ArrayOfSegments Do
				If StrStartsWith(Segment, "{") And StrEndsWith(Segment, "}") Then
					Continue;
				EndIf;
				If ValueIsFilled(Segment) Then
					ArrayOfNewSegments.Add(Segment);
				EndIf;
			EndDo;
			FullURL = FullURL + "/" + StrConcat(ArrayOfNewSegments, "/");
		EndIf;
	EndIf;
	FullURL = FullURL + "/" + URI;
	
	Return FullURL;
EndFunction

Function IsPictureFile(Volume) Export
	IsPicture = False;
	If ValueIsFilled(Volume) Then
		If Volume.FilesType = Enums.FileTypes.Picture Then
			IsPicture = True;
		EndIf;
	EndIf;
	Return IsPicture;
EndFunction

Function GetArrayOfFileIDAsURLParameter(OwnerRef) Export
	If Not ValueIsFilled(OwnerRef) Then
		Return "";
	EndIf;
	
	TableOfFiles = PictureViewerServer.GetPicturesByObjectRef(OwnerRef);
	ArrayOfFileID = New Array();
	For Each Row In TableOfFiles Do
		ArrayOfFileID.Add(Row.FileID);
	EndDo;
	Return StrConcat(ArrayOfFileID, ";");
EndFunction

Function StringCanBeUUID(Value) Export
	ArrayOfSegments = StrSplit(Value, "-");
	LenFirstSegment = 5;
	TotalLenString = 36;
	Return ArrayOfSegments.Count() = LenFirstSegment And StrLen(Value) = TotalLenString;
EndFunction

Procedure CreateAndLinkFileToObject(Volume, FileInfo, OwnerRef) Export
	NewFileRef = CreateFile(Volume, FileInfo);
	LinkFileToObject(NewFileRef, OwnerRef);
EndProcedure

Function CreateFile(Volume, FileInfo) Export
	If ValueIsFilled(FileInfo.Ref) Then
		FileObject = FileInfo.Ref.GetObject();
	Else
		FileObject = Catalogs.Files.CreateItem();
	EndIf;
	FileObject.Volume = Volume;
	PictureViewerClientServer.SetFileInfo(FileInfo, FileObject);
	
	FileObject.Preview = New ValueStorage(FileInfo.Preview);
	FileObject.isPreviewSet = True;
	
	FileObject.Write();
	Return FileObject.Ref;
EndFunction

Procedure LinkFileToObject(FileRef, OwnerRef) Export
	RecordSet = InformationRegisters.AttachedFiles.CreateRecordSet();
	RecordSet.Filter.Owner.Set(OwnerRef);
	RecordSet.Filter.File.Set(FileRef);
	NewRecord = RecordSet.Add();
	NewRecord.Owner = OwnerRef;
	NewRecord.File = FileRef;
	NewRecord.CreationDate = CurrentUniversalDate();
	RecordSet.Write();
EndProcedure

Procedure UnlinkFileFromObject(FileRef, OwnerRef) Export
	RecordSet = InformationRegisters.AttachedFiles.CreateRecordSet();
	RecordSet.Filter.Owner.Set(OwnerRef);
	RecordSet.Filter.File.Set(FileRef);
	RecordSet.Clear();
	RecordSet.Write();
EndProcedure

Procedure UnlinkAllFilesFromObject(OwnerRef) Export
	RecordSet = InformationRegisters.AttachedFiles.CreateRecordSet();
	RecordSet.Filter.Owner.Set(OwnerRef);
	RecordSet.Clear();
	RecordSet.Write();
EndProcedure

Function GetFileInfo(FileRef) Export
	FileInfo = PictureViewerClientServer.FileInfo();
	FileInfo.Success = True;
	Query = New Query();
	Query.Text =
		"SELECT
		|	Files.Description AS FileName,
		|	Files.URI AS URI,
		|	Files.FileID AS FileID,
		|	Files.Height AS Height,
		|	Files.Width AS Width,
		|	Files.SizeBytes AS Size,
		|	Files.Extension AS Extension,
		|	Files.MD5 AS MD5,
		|	Files.Ref AS Ref
		|FROM
		|	Catalog.Files AS Files
		|WHERE
		|	Files.Ref = &Ref";
	Query.SetParameter("Ref", FileRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FillPropertyValues(FileInfo, QuerySelection);
	EndIf;
	Return FileInfo;
EndFunction

Function PicturesInfoForSlider(ItemRef, FileRef = Undefined) Export
	
	Pictures = PictureViewerServer.GetPicturesByObjectRef(ItemRef, , FileRef);
	
	PicArray = New Array;
	For Each Picture In Pictures Do
		Map = New Structure("Src, SrcBD, Preview, PreviewBD, ID, PictureURLStructure");
		PicInfo = GetPictureURL(Picture);
		Map.PictureURLStructure = PicInfo; 
		Map.Src = PicInfo.PictureURL;
		If PicInfo.isLocalPictureURL Then
			Try
				Map.SrcBD = New BinaryData(Map.Src);
			Except
				EmptyPic = New Picture();
				Map.SrcBD = EmptyPic.GetBinaryData();
			EndTry;
		EndIf;
		If Picture.Ref.isPreviewSet Then
			Map.PreviewBD = Picture.Ref.Preview.Get();
		EndIf;
		Map.ID = Picture.FileID;
		PicArray.Add(Map);
	EndDo;
	
	Return PicArray;
	
EndFunction

Function ScalePicture(BinaryData, SizePx = Undefined) Export
	If Not ValueIsFilled(SizePx) Then
		Return BinaryData;
	EndIf;
	Picture = New Picture(BinaryData);
	ProcessingPicture = New ProcessingPicture(Picture);
	If Picture.Height() > Picture.Width() Then
		ProcessingPicture.SetSize( , SizePx);
	Else
		ProcessingPicture.SetSize(SizePx, );
	EndIf;
	NewPicture = ProcessingPicture.GetPicture();
	Return NewPicture.GetBinaryData();
EndFunction

Function UpdatePictureInfoAndGetPreview(BinaryData, SizePx = Undefined) Export
	FileInfo = PictureViewerClientServer.FileInfo();
	Picture = New Picture(BinaryData);
	FileInfo.Height = Picture.Height();
	FileInfo.Width = Picture.Width();
	FileInfo.Size = Picture.FileSize();
	FileInfo.Preview = ScalePicture(BinaryData, SizePx);
	Return FileInfo;
EndFunction

#Region HTML

Function HTMLPictureSlider() Export
	HTMLPictureSlider = GetCommonTemplate("HTMLPictureSlider");
	HTMLPictureSlider = HTMLPictureSlider.GetText();
	Return HTMLPictureSlider;
EndFunction

Function HTMLGallery() Export
	HTMLGallery = GetCommonTemplate("HTMLGallery");
	HTMLGallery = HTMLGallery.GetText();
	Return HTMLGallery;
EndFunction

#EndRegion

Function CreatePictureParameters(FileRef) Export
	PictureParameters = New Structure();
	PictureParameters.Insert("Ref", FileRef);
	PictureParameters.Insert("Description", FileRef.Description);
	PictureParameters.Insert("FileID", FileRef.FileID);
	PictureParameters.Insert("isFilledVolume", FileRef.Volume <> Catalogs.IntegrationSettings.EmptyRef());
	PictureParameters.Insert("GETIntegrationSettings", FileRef.Volume.GETIntegrationSettings);
	PictureParameters.Insert("isLocalPictureURL", 
	FileRef.Volume.GETIntegrationSettings.IntegrationType = Enums.IntegrationType.LocalFileStorage);
	PictureParameters.Insert("URI", FileRef.URI);
	
	Return PictureParameters;		
EndFunction	

