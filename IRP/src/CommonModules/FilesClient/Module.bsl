// @strict-types

#Region Loading

// Start file loading.
// 
// Parameters:
//  FileFilter - String - File filter
//  FinishCallback - CallbackDescription - Finish callback
//  FormUUID - UUID - Form UUID
Procedure StartFileLoading(FileFilter, FinishCallback, FormUUID) Export
	
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.CheckFileExistence = True;
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Filter = FileFilter;
	
	AddInfo = New Structure;
	AddInfo.Insert("UUID", FormUUID);
	AddInfo.Insert("FinishCallback", FinishCallback);
	
	SelectNotify = New CallbackDescription("FinishFileSelection", ThisObject, AddInfo);
	
	OpenFileDialog.Show(SelectNotify);
	
EndProcedure

// Finish file selection.
// 
// Parameters:
//  SelectedFiles - Array of String - Selected files
//  AddInfo - Structure - Add info:
//	* UUID - UUID -
//	* FinishCallback - CallbackDescription -
Procedure FinishFileSelection(SelectedFiles, AddInfo) Export
	
	If SelectedFiles = Undefined OR TypeOf(SelectedFiles) <> Type("Array") OR SelectedFiles.Count() = 0 Then
		Return;
	EndIf;
	
	PathToFile = SelectedFiles[0]; // String
	StoredFileDescription = FilesClientServer.GetStoredFileDescriptionWrapper(PathToFile);
	
	LoadSettings = FilesServer.GetLoadSettings();
	
	If Not LoadSettings.UseFileSpliting OR LoadSettings.MaxUploadFileSize >= StoredFileDescription.Size Then
		
		BeginPutFileToServer(AddInfo.FinishCallback, , , , PathToFile, AddInfo.UUID);
		
	Else
		
		LoadFileInParts(StoredFileDescription, LoadSettings, AddInfo);

	EndIf;
	
EndProcedure

// Load file in parts.
// 
// Parameters:
//  FileDescription - See FilesClientServer.GetStoredFileDescriptionWrapper
//  LoadSettings - See FilesServer.GetLoadSettings 
//  AddInfo - Structure - Add info:
// * UUID - UUID - 
// * FinishCallback - CallbackDescription - 
Async Procedure LoadFileInParts(FileDescription, LoadSettings, AddInfo)
	
	PartsAmmount = FileDescription.Size / LoadSettings.MaxUploadFileSize;
	PartsAmmount = ?(Int(PartsAmmount) = PartsAmmount, PartsAmmount, Int(PartsAmmount)+1);
	
	CurrentPart = FilesServer.GetNextFilePartNumber(FileDescription, PartsAmmount);
	
	If CurrentPart <= PartsAmmount Then
		
		FileParts = SplitFile(FileDescription.PathToFile, LoadSettings.MaxUploadFileSize, TempFilesDir());
		
		//@skip-check property-return-type, invocation-parameter-type-intersect
		For PartNumber = CurrentPart To FileParts.Count() Do
			StoredFileDescription = Await PutFileToServerAsync(,,, FileParts[PartNumber-1], AddInfo.UUID);
			FilesServer.SaveUploadedFilePart(StoredFileDescription.Address, FileDescription, PartNumber);
		EndDo;
		
		For Each FileName In FileParts Do // String
			DeleteFiles(FileName);
		EndDo;
		
	EndIf;
	
	FileDescription = FilesServer.JoinFileParts(FileDescription, AddInfo.UUID);
	
	RunCallback(AddInfo.FinishCallback, FileDescription); 

EndProcedure

#EndRegion
