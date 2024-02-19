// @strict-types

#Region Variables

&AtClient
Var SplashForm; // ClientApplicationForm
&AtClient
Var ArrayFilesMD5; // Array of String
&AtClient
Var ArrayFiles; // Array of File
&AtClient
Var CurrentFileIndex; // Number
&AtClient
Var FilesTableRecords; // Array of FormDataCollectionItem

#EndRegion

#Region FormEvents

&AtServer
//@skip-check property-return-type
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Try
		ThisObject.PictureIntegrationSettings = PictureViewerServer.GetIntegrationSettingsPicture();
		//@skip-check invocation-parameter-type-intersect
		ThisObject.PictureConnectionSetting = 
			IntegrationClientServer.ConnectionSetting(
				ServiceSystemServer.GetObjectAttribute(
					ThisObject.PictureIntegrationSettings.POSTIntegrationSettings, "UniqueID"));
		If Not ThisObject.PictureConnectionSetting.Success Then
			Raise ThisObject.PictureConnectionSetting.Message;
		EndIf;
		ThisObject.EnableToLoad = True;
	Except 
		ThisObject.EnableToLoad = False;
		ThisObject.Enabled = False;
		Items.SelectPath.Enabled = False;
	EndTry;
	
	PreviewScaleSize = 200;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Not ThisObject.EnableToLoad Then
		//@skip-check invocation-parameter-type-intersect, property-return-type
		ShowMessageBox(, R().Error_049);
	EndIf;
EndProcedure


#EndRegion

#Region Commands

&AtClient
Async Procedure SelectPath(Command)
	
	Dialog = New FileDialog(FileDialogMode.ChooseDirectory);
	Dialog.CheckFileExist = True;
	Dialog.Directory = ThisObject.FolderPath;
	
	Choosed = Await Dialog.ChooseAsync();
	If TypeOf(Choosed) = Type("Array") Then
		ThisObject.FolderPath = Choosed[0];
	EndIf;

EndProcedure

&AtClient
Procedure AnalizeFolder(Command)
	
	DetachIdleHandler("AnalizeFolder_Read");
	
	ThisObject.FilesTable.Clear();
	If IsBlankString(ThisObject.FolderPath) Then
		Return;
	EndIf;
	
	ArrayFiles = FindFiles(ThisObject.FolderPath, "*.*", True);
	If ArrayFiles.Count() = 0 Then
		Return;
	EndIf;
	
	SplashForm = OpenForm("CommonForm.BackgroundJobSplash",
		New Structure("BackgroundJobTitle", R().GPU_AnalizeFolder),
		ThisObject, 
		New UUID(),,,,
		FormWindowOpeningMode.LockOwnerWindow);
	//@skip-check property-return-type
	SplashForm.EndDate = CommonFunctionsServer.GetCurrentSessionDate();
	SplashForm.FormCanBeClose = True;
	SplashForm.CommandBar.ChildItems.FormCancelJob.Visible = False;
	SplashForm.Items.DoNotCloseOnFinish.Visible = False;
	SplashForm.Items.Percent.MaxValue = ArrayFiles.Count();
	
	CurrentFileIndex = 0;
	ArrayFilesMD5 = New Array(); // Array of String
	
	AttachIdleHandler("AnalizeFolder_Read", 0.01, True);
	
EndProcedure

&AtClient
Procedure FindOwner(Command)
	Return;
EndProcedure

&AtClient
Procedure Load(Command)
	
	ThisObject.Start = CommonFunctionsServer.GetCurrentSessionDate();
	
	CurrentFileIndex = 0;
	FilesTableRecords = New Array; // Array of FormDataCollectionItem
	For Each FilesTableRecord In ThisObject.FilesTable Do
		If IsBlankString(FilesTableRecord.UUID) Then
			FilesTableRecord.UUID = String(New UUID());
		EndIf;
		If IsBlankString(FilesTableRecord.URI) And Not IsBlankString(FilesTableRecord.MD5) Then
			FilesTableRecords.Add(FilesTableRecord);
		EndIf;
	EndDo;
	
	If FilesTableRecords.Count() = 0 Then
		ThisObject.Finish = CommonFunctionsServer.GetCurrentSessionDate();
		Return;
	EndIf;
	
	SplashForm = OpenForm("CommonForm.BackgroundJobSplash",
		New Structure("BackgroundJobTitle", R().GPU_Load_SendToDrive),
		ThisObject, 
		New UUID(),,,,
		FormWindowOpeningMode.LockOwnerWindow);
	//@skip-check property-return-type
	SplashForm.EndDate = CommonFunctionsServer.GetCurrentSessionDate();
	SplashForm.FormCanBeClose = True;
	SplashForm.CommandBar.ChildItems.FormCancelJob.Visible = False;
	SplashForm.Items.DoNotCloseOnFinish.Visible = False;
	SplashForm.Items.Percent.MaxValue = FilesTableRecords.Count();
	
	AttachIdleHandler("LoadingOnClient", 0.01, True);
	
EndProcedure

#EndRegion

#Region FormItemEvens

&AtClient
Procedure PreviewOnChange(Item)
	Items.PictureViewHTML.Visible = ThisObject.Preview;
	FilesTableOnActivateRow(Undefined);
EndProcedure

&AtClient
Procedure FilesTableOnActivateRow(Item)
	If Items.FilesTable.CurrentData = Undefined Then
		Return;
	EndIf;
	
	ThisObject.PictureViewHTML = 
			"<html><img src=""file:///" 
			+ ThisObject.FolderPath + Items.FilesTable.CurrentData.FilePath
			+ """ height=""100%""></html>";
EndProcedure

#EndRegion

#Region Other

&AtClient
Procedure AnalizeFolder_Read()

	FileItem = ArrayFiles[CurrentFileIndex];
	CurrentFileIndex = CurrentFileIndex + 1;
	
	//@skip-check property-return-type
	SplashForm.Percent = CurrentFileIndex;
	
	ImageExtensions = PictureViewerClientServer.GetImageExtensions();
	If Not FileItem.IsDirectory() And ImageExtensions.Find(FileItem.Extension) <> Undefined Then
		FilesTableRecord = ThisObject.FilesTable.Add();
		FilesTableRecord.FilePath = StrReplace(FileItem.FullName, ThisObject.FolderPath, "");
		FilesTableRecord.Extension = FileItem.Extension;
		FilesTableRecord.FileName = FileItem.Name;
		FilesTableRecord.Size = (FileItem.Size()) / 1024 / 1024; // Size in Mb 
		FilesTableRecord.MD5 = CalculateMD5(ThisObject.FolderPath + FilesTableRecord.FilePath);
		If Not IsBlankString(FilesTableRecord.MD5) Then
			ArrayFilesMD5.Add(FilesTableRecord.MD5);
		EndIf;
	EndIf;
	
	If CurrentFileIndex = ArrayFiles.Count() Then
		//@skip-check property-return-type
		SplashForm.JobTitle = R().GPU_CheckingFilesExist;
		AttachIdleHandler("AnalizeFolder_CheckFiles", 0.1, True);
	Else
		AttachIdleHandler("AnalizeFolder_Read", 0.01, True);
	EndIf;

EndProcedure

&AtClient
Procedure AnalizeFolder_CheckFiles()

	FileFilter = New Structure("MD5", "");
	
	//@skip-check invocation-parameter-type-intersect
	FindedFiles = CheckFiles(ArrayFilesMD5);
	For Each FileRefDescription In FindedFiles Do
		FileFilter.MD5 = FileRefDescription.MD5;
		FilesTableRecords = ThisObject.FilesTable.FindRows(FileFilter);
		For Each FilesTableRecord In FilesTableRecords Do
			FilesTableRecord.FileRef = FileRefDescription.Ref;
			FilesTableRecord.URI = FileRefDescription.URI;
			FilesTableRecord.UUID = FileRefDescription.FileID;
			FilesTableRecord.IsFileCreate = True;
			FilesTableRecord.IsSaved = True;
		EndDo;
	EndDo;
	
	SplashForm.Close();
	//@skip-check statement-type-change
	SplashForm = Undefined;

EndProcedure

// Calculate MD5.
// 
// Parameters:
//  FilePath - String - Full path to file
// 
// Returns:
//  String - Calculate m d5
&AtClient
Function CalculateMD5(FilePath)
	Return CalculateMD5_AtServer(New BinaryData(FilePath)); 
EndFunction

// Calculate MD5 at server.
// 
// Parameters:
//  BinaryData - BinaryData - Binary data
// 
// Returns:
//  String - Calculate MD55 at server
&AtServerNoContext
Function CalculateMD5_AtServer(BinaryData)
	Hash = New DataHashing(HashFunction.MD5);
	Hash.Append(BinaryData);
	Return String(Hash.HashSum);
EndFunction // CalculateMD5_AtServer()

// Check files.
// 
// Parameters:
//  ArrayMD5 - Array of String - Array MD5
// 
// Returns:
//  Array of See FileRefDescription
&AtServerNoContext
Function CheckFiles(ArrayMD5)
	Result = New Array; // Array of See FileRefDescription
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	Files.Ref,
	|	Files.URI,
	|	Files.FileID,
	|	Files.MD5
	|FROM
	|	Catalog.Files AS Files
	|WHERE
	|	Files.MD5 IN (&ArrayMD5)";
	Query.SetParameter("ArrayMD5", ArrayMD5);
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		NewFileRefDescription = FileRefDescription();
		FillPropertyValues(NewFileRefDescription, QuerySelection);
		Result.Add(NewFileRefDescription);
	EndDo;
	
	Return Result;
EndFunction

// File ref description.
// 
// Returns:
//  Structure - File ref description:
// * Ref - CatalogRef.Files -
// * FileID - String -
// * URI - String -
// * MD5 - String -
&AtClientAtServerNoContext
Function FileRefDescription()
	Result = New Structure;
	Result.Insert("Ref", PredefinedValue("Catalog.Files.EmptyRef"));
	Result.Insert("FileID", "");
	Result.Insert("URI", "");
	Result.Insert("MD5", "");
	Return Result;
EndFunction

// Start loading on client.
// 
// Parameters:
//  FilesTableRecords - Array of FormDataCollectionItem - Files table records
//  
//@skip-check property-return-type, statement-type-change
&AtClient
Procedure LoadingOnClient()
	
	FilesTableRecord = FilesTableRecords[CurrentFileIndex];
		
	FileID = FilesTableRecord.UUID; // String
	FileFullName = ThisObject.FolderPath + FilesTableRecord.FilePath;
	
	FileInfo = PictureViewerClientServer.FileInfo();
	FileInfo.FileID = FileID;
	FileInfo.MD5 = FilesTableRecord.MD5;
	FileInfo.Extension = FilesTableRecord.Extension;
	
	UploadPictureParameters = New Structure();
	UploadPictureParameters.Insert("ConnectionSettings", ThisObject.PictureConnectionSetting);
	UploadPictureParameters.Insert("RequestBody", New BinaryData(FileFullName));
	UploadPictureParameters.Insert("FileID", FileID);
	
	If ThisObject.PictureConnectionSetting.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		IntegrationServer.SaveFileToFileStorage(
			ThisObject.PictureConnectionSetting.Value.AddressPath, 
			FileID + "." + FileInfo.Extension, 
			UploadPictureParameters.RequestBody);
		FileInfo.Success = True;
		FileInfo.URI = FileID + "." + FileInfo.Extension;

	ElsIf Not PictureViewerClient.ExtensionCall_UploadPicture(FileInfo, UploadPictureParameters) Then
		ThisObject.PictureConnectionSetting.Value.QueryType = "POST";
		ResourceParameters = New Map();
		ResourceParameters.Insert("filename", FileID + "." + FileInfo.Extension);	
		RequestResult = IntegrationClientServer.SendRequest(
			ThisObject.PictureConnectionSetting.Value, ResourceParameters, , UploadPictureParameters.RequestBody);
		If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
			DeserializeResponse = CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody);
			FileInfo.URI = DeserializeResponse.Data.URI;
			FileInfo.Success = Not IsBlankString(FileInfo.URI);
		Else
			FileInfo.Success = False;
		EndIf;
	EndIf;
	
	If FileInfo.Success = True Then
		FilesTableRecord.URI = FileInfo.URI;
		FilesTableRecord.IsSaved = True;
	EndIf;

	CurrentFileIndex = CurrentFileIndex + 1;
	SplashForm.Percent = CurrentFileIndex;
			
	If CurrentFileIndex < FilesTableRecords.Count() Then
		AttachIdleHandler("LoadingOnClient", 0.01, True);
		Return;
	EndIf;
	
	BackgroundJobUUID = String(New UUID());
	SplashForm.JobTitle = R().GPU_Load_SaveInBase;
	SplashForm.Items.Percent.MaxValue = 100;
	SplashForm.Percent = 0;
	
	FileDescriptionArray = New Array; // Array of TransferableFileDescription
    For Each FilesTableRecord In ThisObject.FilesTable Do
        FileDescriptionArray.Add(
	        	New TransferableFileDescription(ThisObject.FolderPath + FilesTableRecord.FilePath));
    EndDo;
    
   	CompletionNotifyDescription = New NotifyDescription("LoadingOnClient_PutFiles_Finish", ThisObject);
   	ProgressNotifyDescription = New NotifyDescription("LoadingOnClient_PutFiles_Progress", ThisObject);  
   	
   	BeginPutFilesToServer(CompletionNotifyDescription, ProgressNotifyDescription, , FileDescriptionArray, UUID);
   	
EndProcedure

// Loading on client put files finish.
// 
// Parameters:
//  PlacedFileDescriptions - Array of PlacedFileDescription - Placed file descriptions
//  AddInfo - Undefined - Add info
&AtClient
Procedure LoadingOnClient_PutFiles_Finish(PlacedFileDescriptions, AddInfo) Export
	
	FileAdrresses = New Map;
	If PlacedFileDescriptions <> Undefined Then
    	For Each PlacedFileDescription In PlacedFileDescriptions Do
    		//@skip-check property-return-type
    		If Not PlacedFileDescription.PutFileCanceled Then
		    	//@skip-check invocation-parameter-type-intersect
		    	FileAdrresses.Insert(Lower(PlacedFileDescription.FileRef.File.FullName), PlacedFileDescription.Address);
    		EndIf;
    	EndDo;
	EndIf;
	
	//@skip-check invocation-parameter-type-intersect
	StartLoadingOnServer(FileAdrresses);
	
	SplashForm.Close();
	//@skip-check statement-type-change
	SplashForm = Undefined;
	
	ThisObject.Finish = CommonFunctionsServer.GetCurrentSessionDate();
	
EndProcedure

// Loading on client put files progress.
// 
// Parameters:
//  PlacedFile - PlacedFileDescription - Placed file
//  PercentFile - Number - Percent file
//  CancelFile - Boolean - Cancel file
//  PercentAll - Number - Percent all
//  CancelAll - Boolean - Cancel all
//  AddInfo - Undefined - Add info
//@skip-check method-param-value-type, property-return-type
&AtClient
Procedure LoadingOnClient_PutFiles_Progress(PlacedFile, PercentFile, CancelFile, PercentAll, CancelAll, AddInfo) Export
	If SplashForm <> Undefined Then
		SplashForm.Percent = PercentAll;
	EndIf;
EndProcedure

// Start loading on server.
// 
// Parameters:
//  FileAdrresses - Map - File adrresses
&AtServer
Procedure StartLoadingOnServer(FileAdrresses)
	
	Volume = PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume; // CatalogRef.FileStorageVolumes
	
	IncompleteRecords = ThisObject.FilesTable.FindRows(New Structure("FileRef", Catalogs.Files.EmptyRef()));
	For Each FilesTableRecord In IncompleteRecords Do
		
		FileFullName = Lower(ThisObject.FolderPath + FilesTableRecord.FilePath);
		FileTmpAddress = FileAdrresses.Get(FileFullName); // String
		If FileTmpAddress = Undefined Then
			Continue;
		EndIf;
		
		FileBinaryData = GetFromTempStorage(FileTmpAddress); // BinaryData
		DeleteFromTempStorage(FileTmpAddress);
		
		If IsBlankString(FilesTableRecord.MD5) Then
			FilesTableRecord.MD5 = String(PictureViewerServer.MD5ByBinaryData(FileBinaryData));
		EndIf;
		
		ExistingFileRef = PictureViewerServer.GetFileRefByMD5(FilesTableRecord.MD5);
		If ValueIsFilled(ExistingFileRef) Then
			FilesTableRecord.FileRef = ExistingFileRef;
			FilesTableRecord.IsFileCreate = True; 
			Continue;
		EndIf;
		
		FileInfo = PictureViewerServer.UpdatePictureInfoAndGetPreview(FileBinaryData, ThisObject.PreviewScaleSize);
		FileInfo.FileID = FilesTableRecord.UUID;
		FileInfo.MD5 = FilesTableRecord.MD5;
		FileInfo.Extension = FilesTableRecord.Extension;
		FileInfo.FileName = FilesTableRecord.FileName;
		
		UploadPictureParameters = New Structure();
		//@skip-check property-return-type
		UploadPictureParameters.Insert("ConnectionSettings", ThisObject.PictureConnectionSetting);
		UploadPictureParameters.Insert("RequestBody", FileBinaryData);
		UploadPictureParameters.Insert("FileID", FilesTableRecord.UUID);
		
		//@skip-check property-return-type
		If IsBlankString(FilesTableRecord.URI) Then
			If Not PictureViewerServer.ExtensionCall_UploadPicture(FileInfo, UploadPictureParameters) Then
				ThisObject.PictureConnectionSetting.Value.QueryType = "POST";
				ResourceParameters = New Map();
				ResourceParameters.Insert("filename", FileInfo.FileID + "." + FileInfo.Extension);
				RequestResult = IntegrationClientServer.SendRequest(
					ThisObject.PictureConnectionSetting.Value, ResourceParameters, , FileBinaryData);
				If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
					DeserializeResponse = CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody);
					FileInfo.URI = String(DeserializeResponse.Data.URI);
					FileInfo.Success = True;
				Else
					FileInfo.Success = False;
				EndIf;
			EndIf;
		Else
			FileInfo.Success = True;
		EndIf;
		
		If FileInfo.Success = True Then
			FilesTableRecord.FileRef = PictureViewerServer.CreateFile(Volume, FileInfo);
			FilesTableRecord.IsFileCreate = True;
		EndIf;
	EndDo;
	
	CompleteRecords = New Array; // Array of FormDataCollectionItem
	For Each FilesTableRecord In ThisObject.FilesTable Do
		If ValueIsFilled(FilesTableRecord.FileRef) And ValueIsFilled(FilesTableRecord.Owner) Then
			CompleteRecords.Add(FilesTableRecord);
		EndIf;
	EndDo;
	If CompleteRecords.Count() = 0 Then
		Return;
	EndIf;
	OwnerTable = ThisObject.FilesTable.Unload(CompleteRecords, "FileRef, Owner");
	
	Query = New Query;
	Query.SetParameter("OwnerTable", OwnerTable);
	Query.Text =
	"SELECT DISTINCT
	|	OwnerTable.FileRef,
	|	OwnerTable.Owner
	|INTO tmpOwners
	|FROM
	|	&OwnerTable AS OwnerTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpOwners.FileRef,
	|	tmpOwners.Owner
	|FROM
	|	tmpOwners AS tmpOwners
	|		LEFT JOIN InformationRegister.AttachedFiles AS AttachedFiles
	|		ON tmpOwners.FileRef = AttachedFiles.File
	|		AND tmpOwners.Owner = AttachedFiles.Owner
	|WHERE
	|	AttachedFiles.File IS NULL";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		//@skip-check property-return-type
		PictureViewerServer.LinkFileToObject(QuerySelection.FileRef, QuerySelection.Owner);
	EndDo;

EndProcedure

#EndRegion
