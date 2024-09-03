// @strict-types

#Region Public

// Get file info.
// 
// Parameters:
//  FileRef - CatalogRef.Files - File ref
//  WithBody - Boolean - With body
// 
// Returns:
//  See FilesClientServer.GetFileInfo 
Function GetFileInfo(FileRef, WithBody = False) Export
	
	FileInfo = FilesClientServer.GetFileInfo();
	
	Query = New Query();
	Query.Text =
	"SELECT
	|	TRUE AS Success,
	|	Files.MD5 AS MD5,
	|	Files.FileID AS FileID,
	|	Files.Ref AS Ref,
	|	Files.URI AS URI,
	|	Files.Description AS FileName,
	|	Files.Extension AS Extension,
	|	Files.PrintFormName AS PrintFormName,
	|	Files.Height AS Height,
	|	Files.Width AS Width,
	|	Files.SizeBytes AS Size,
	|	Files.Volume AS Volume,
	|	Files.Volume.GETIntegrationSettings AS IntegrationSettings,
	|	Files.Preview AS Preview
	|FROM
	|	Catalog.Files AS Files
	|WHERE
	|	Files.Ref = &Ref";
	Query.SetParameter("Ref", FileRef);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		FileInfo.Success = True;
		FillPropertyValues(FileInfo, QuerySelection);
	EndIf;
	
	If WithBody Then
		FileInfo.BinaryBody = GetFileBinaryData(FileRef);
	EndIf;
	
	Return FileInfo;
	
EndFunction

// Get file ref by md5.
// 
// Parameters:
//  MD5 - String - MD5
// 
// Returns:
//  CatalogRef.Files - Get file ref by m d5
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
		//@skip-check property-return-type
		Return QuerySelection.Ref;
	Else
		Return Catalogs.Files.EmptyRef();
	EndIf;
EndFunction

// Get file ref by file ID.
// 
// Parameters:
//  FileID - String - File ID
// 
// Returns:
//  Undefined, Structure - Get file ref by file ID:
// * Ref - CatalogRef.Files
// * isFilledVolume - Boolean
// * GETIntegrationSettings - CatalogRef.IntegrationSettings
// * isLocalPictureURL - Boolean
// * URI - String
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

	//@skip-check property-return-type
	If QuerySelection.Next() Then
		Answer = New Structure;
		Answer.Insert("Ref", QuerySelection.Ref);
		Answer.Insert("isFilledVolume", QuerySelection.isFilledVolume);
		Answer.Insert("GETIntegrationSettings", QuerySelection.GETIntegrationSettings);
		Answer.Insert("isLocalPictureURL", QuerySelection.isLocalPictureURL);
		Answer.Insert("URI", QuerySelection.URI);
		Return Answer;
	EndIf;
	
	Return Undefined;
EndFunction

// Get file refs by file i ds.
// 
// Parameters:
//  FileIDs - Array of String - List of file id
// 
// Returns:
//  Array of CatalogRef.Files - List of file refs by file IDs
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

// Get file ref by binary data.
// 
// Parameters:
//  FileInfo - See FilesClientServer.GetFileInfo
//  Owner - DefinedType.typeFilesOwner - Owner
//  isPicture - Boolean - Is picture
// 
// Returns:
//  CatalogRef.Files - Get file ref by binary data
Function GetFileRefByBinaryData(FileInfo, Owner = Undefined, isPicture = False) Export
	
	FileRef = GetFileRefByMD5(FileInfo.MD5);
	
	If Not ValueIsFilled(FileRef) Then
		
		FileStorageVolume = Constants.DefaultFilesStorageVolume.Get();
		If Not ValueIsFilled(FileStorageVolume) Then
			Raise R().Error_102;
		EndIf;
		
		IntegrationSettings = FileStorageVolume.POSTIntegrationSettings;
		ConnectionSettings = IntegrationClientServer.ConnectionSetting(IntegrationSettings.UniqueID);
		
		FileBinaryData = FileInfo.BinaryBody;
		
		UploadPictureParameters = New Structure();
		UploadPictureParameters.Insert("ConnectionSettings", ConnectionSettings);
		UploadPictureParameters.Insert("RequestBody", FileBinaryData);
		UploadPictureParameters.Insert("FileID", FileInfo.FileID);
		
		//@skip-check property-return-type
		If ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
			
			IntegrationServer.SaveFileToFileStorage(
				ConnectionSettings.Value.AddressPath, 
				FileInfo.FileID + "." + FileInfo.Extension, 
				FileBinaryData);
			FileInfo.URI = FileInfo.FileID + "." + FileInfo.Extension;
	
		ElsIf Not PictureViewerServer.ExtensionCall_UploadPicture(FileInfo, UploadPictureParameters) Then
			
			ConnectionSettings.Value.QueryType = "POST";
			ResourceParameters = New Map();
			ResourceParameters.Insert("filename", FileInfo.FileID + "." + FileInfo.Extension);	
			RequestResult = IntegrationClientServer.SendRequest(
				ConnectionSettings.Value, ResourceParameters, , FileBinaryData);
			If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
				DeserializeResponse = CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody);
				//@skip-check statement-type-change
				FileInfo.URI = DeserializeResponse.Data.URI;
			EndIf;
		EndIf;
		
		If IsBlankString(FileInfo.URI) Then
			Return Catalogs.Files.EmptyRef();
		EndIf;
		
		If isPicture Then
			FilePreview = PictureViewerServer.UpdatePictureInfoAndGetPreview(FileBinaryData, 200);
			FillPropertyValues(FileInfo, FilePreview, "Preview,Size,Height,Width");
		EndIf;
		
		FileRef = CreateFile(FileStorageVolume, FileInfo);
	
	EndIf;
	
	If Owner <> Undefined Then
		LinkFileToObject(FileRef, Owner);
	EndIf;
	
	Return FileRef;
	
EndFunction

// Get file binary data.
// 
// Parameters:
//  FileRef - CatalogRef.Files - File ref
// 
// Returns:
//  Undefined, BinaryData - Get file binary data
Function GetFileBinaryData(FileRef) Export
	
	FileParameters = GetFileInfo(FileRef);
	FileURL = PictureViewerServer.GetVolumeURLByIntegrationSettings(FileParameters.IntegrationSettings, FileParameters.URI);
	
	If IsBlankString(FileURL) Then
		Return Undefined;
	ElsIf StrStartsWith(FileURL, "e1cib/tempstorage") Then
		FileBinaryData = GetFromTempStorage(FileURL); // BinaryData
		Return FileBinaryData;
	EndIf;
	
	Return FilesClientServer.GetBinaryDataFromFileInWEB(FileURL);
	
EndFunction

// Create file.
// 
// Parameters:
//  Volume - CatalogRef.FileStorageVolumes - Volume
//  FileInfo - See FilesClientServer.GetFileInfo 
// 
// Returns:
//  CatalogRef.Files - Created file
Function CreateFile(Volume, FileInfo) Export
	
	If ValueIsFilled(FileInfo.Ref) Then
		Return FileInfo.Ref;
	EndIf;
	
	FileObject = Catalogs.Files.CreateItem();
	FileObject.Volume = Volume;
	FilesClientServer.SetFileInfo(FileInfo, FileObject);

	If ValueIsFilled(FileInfo.Preview) Then
		FileObject.Preview = New ValueStorage(FileInfo.Preview);
		FileObject.isPreviewSet = True;
	EndIf;

	FileObject.Write();
	Return FileObject.Ref;
	
EndFunction

// Link file to object.
// 
// Parameters:
//  FileRef - CatalogRef.Files - File ref
//  OwnerRef - DefinedType.typeFilesOwner - Owner ref
//  Priority - Number, Undefined - Priority
Procedure LinkFileToObject(FileRef, OwnerRef, Val Priority = Undefined) Export
	
	If Priority = Undefined Then
		Priority = 0;
		Query = New Query;
		Query.Text =
		"SELECT TOP 1
		|	AttachedFiles.Priority AS Priority
		|FROM
		|	InformationRegister.AttachedFiles AS AttachedFiles
		|WHERE
		|	AttachedFiles.Owner = &Owner
		|
		|ORDER BY
		|	Priority DESC";
		Query.SetParameter("Owner", OwnerRef);
		QueryResult = Query.Execute().Select();
		If QueryResult.Next() Then
			//@skip-check property-return-type
			Priority = QueryResult.Priority + 1;
		EndIf;
	EndIf;
	
	RecordSet = InformationRegisters.AttachedFiles.CreateRecordSet();
	RecordSet.Filter.Owner.Set(OwnerRef);
	RecordSet.Filter.File.Set(FileRef);
	
	NewRecord = RecordSet.Add();
	NewRecord.Owner = OwnerRef;
	NewRecord.File = FileRef;
	NewRecord.Priority = Priority;
	NewRecord.CreationDate = CurrentUniversalDate();
	RecordSet.Write();
	
EndProcedure

// Create and link file to object.
// 
// Parameters:
//  Volume - CatalogRef.FileStorageVolumes - Volume
//  FileInfo - See FilesClientServer.GetFileInfo
//  OwnerRef - DefinedType.typeFilesOwner
Procedure CreateAndLinkFileToObject(Volume, FileInfo, OwnerRef) Export
	NewFileRef = CreateFile(Volume, FileInfo);
	FileInfo.Ref = NewFileRef;
	LinkFileToObject(NewFileRef, OwnerRef);
EndProcedure

// Unlink file from object.
// 
// Parameters:
//  FileRef - CatalogRef.Files - File ref
//  OwnerRef - DefinedType.typeFilesOwner - Owner ref
Procedure UnlinkFileFromObject(FileRef, OwnerRef) Export
	RecordSet = InformationRegisters.AttachedFiles.CreateRecordSet();
	RecordSet.Filter.Owner.Set(OwnerRef);
	RecordSet.Filter.File.Set(FileRef);
	RecordSet.Clear();
	RecordSet.Write();
EndProcedure

// Unlink all files from object.
// 
// Parameters:
//  OwnerRef - DefinedType.typeFilesOwner - Owner ref
Procedure UnlinkAllFilesFromObject(OwnerRef) Export
	RecordSet = InformationRegisters.AttachedFiles.CreateRecordSet();
	RecordSet.Filter.Owner.Set(OwnerRef);
	RecordSet.Clear();
	RecordSet.Write();
EndProcedure

// MD5 by binary data.
// 
// Parameters:
//  BinaryDataSource - String, BinaryData - Binary data source
// 
// Returns:
//  BinaryData - MD5 by binary data
Function MD5ByBinaryData(BinaryDataSource) Export
	
	If TypeOf(BinaryDataSource) = Type("String") Then
		BinaryData = GetFromTempStorage(BinaryDataSource);
	Else
		BinaryData = BinaryDataSource; // BinaryData
	EndIf;
	
	Hash = New DataHashing(HashFunction.MD5);
	Hash.Append(BinaryData);
	
	Return Hash.HashSum;
	
EndFunction

// Is file ref belong to owner.
// 
// Parameters:
//  FileRef - CatalogRef.Files - File ref
//  OwnerRef - DefinedType.typeFilesOwner - Owner ref
// 
// Returns:
//  Boolean - Is file ref belong to owner
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

// Change priority file.
// @skip-check property-return-type
// 
// Parameters:
//  OwnerRef - DefinedType.typeFilesOwner
//  FileRef - CatalogRef.Files - File ref
//  Rise - Number - Rise [1, -1], if > 0 then rise
Procedure ChangePriorityFile(OwnerRef, FileRef, Rise = 0) Export
	
	If Rise = 0 Then
		Return;
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	AttachedFiles.Priority AS Priority,
	|	AttachedFiles.Priority AS NewPriority,
	|	AttachedFiles.File
	|FROM
	|	InformationRegister.AttachedFiles AS AttachedFiles
	|WHERE
	|	AttachedFiles.Owner = &Owner
	|
	|ORDER BY
	|	isDraft,
	|	Priority";
	
	Query.SetParameter("Owner", OwnerRef);
	FilesPriorityList = Query.Execute().Unload();
	For Index = 0 To FilesPriorityList.Count() - 1 Do
		FilesPriorityList[Index].NewPriority = Index;
	EndDo;

	FindFile = FilesPriorityList.FindRows(New Structure("File", FileRef));
	CurrentPriority = FindFile[0].NewPriority; // Number
	NewPriority = CurrentPriority - Rise;
	FindFile[0].NewPriority = NewPriority;
	
	If Rise > 0 Then
		For Index = NewPriority To CurrentPriority - 1 Do
			FilesPriorityList[Index].NewPriority = FilesPriorityList[Index].NewPriority + 1;
		EndDo;
	Else
		For Index = CurrentPriority + 1 To NewPriority Do
			FilesPriorityList[Index].NewPriority = FilesPriorityList[Index].NewPriority - 1;
		EndDo;
	EndIf;
	
	For Index = 0 To FilesPriorityList.Count() - 1 Do
		If Not FilesPriorityList[Index].NewPriority = FilesPriorityList[Index].Priority Then
			//@skip-check invocation-parameter-type-intersect
			LinkFileToObject(FilesPriorityList[Index].File, OwnerRef, FilesPriorityList[Index].NewPriority);			
		EndIf;
	EndDo;
	
EndProcedure

#EndRegion
