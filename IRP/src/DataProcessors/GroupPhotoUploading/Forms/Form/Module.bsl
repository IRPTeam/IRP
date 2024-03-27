// @strict-types
// @skip-check module-self-reference

#Region Variables

&AtClient
Var SplashForm; // ClientApplicationForm
&AtClient
Var PacketSize; // Number
&AtClient
Var PacketIndex; // Number
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
	
	ThisObject.FilesTable.Clear();
	If IsBlankString(ThisObject.FolderPath) Then
		Return;
	EndIf;
	
	ArrayFiles = FindFiles(ThisObject.FolderPath, "*.*", True);
	If ArrayFiles.Count() = 0 Then
		Return;
	EndIf;
	
	ThisObject.Start = CommonFunctionsServer.GetCurrentSessionDate();
	
	PacketIndex = 0;
	PacketCount = Int(ArrayFiles.Count() / PacketSize) + 1;
	BackgroundJobUUID = New UUID();
	ArrayFilesMD5 = New Array(); // Array of String
	
	//@skip-warning
	CreateSplashForm(R().GPU_AnalizeFolder, PacketCount);
	
	AttachIdleHandler("AnalizeFolder_Read", 0.5, True);
	
EndProcedure

&AtClient
Procedure FindOwner(Command)
	FindingOwnersOnClient();
EndProcedure

&AtClient
Procedure Load(Command)
	
	ThisObject.Start = CommonFunctionsServer.GetCurrentSessionDate();
	
	FilesTableRecords = New Array; // Array of FormDataCollectionItem
	For Each FilesTableRecord In ThisObject.FilesTable Do
		If IsBlankString(FilesTableRecord.UUID) Then
			FilesTableRecord.UUID = String(New UUID());
		EndIf;
		If IsBlankString(FilesTableRecord.URI) And Not IsBlankString(FilesTableRecord.MD5) Then
			FilesTableRecords.Add(FilesTableRecord);
		EndIf;
	EndDo;
	
	CurrentFileIndex = 0;
	PacketIndex = 0;
	PacketCount = Int(FilesTableRecords.Count() / PacketSize) + 1;
	BackgroundJobUUID = New UUID();
	
	//@skip-warning
	CreateSplashForm(R().GPU_Load_SendToDrive, PacketCount);
	
	AttachIdleHandler("LoadingOnClient", 0.1, True);
	
EndProcedure

#EndRegion

#Region FormItemEvens

&AtClient
Procedure PreviewOnChange(Item)
	Items.PictureViewHTML.Visible = ThisObject.Preview;
	FilesTableOnActivateRow(Undefined);
EndProcedure

&AtClient
Procedure FilesTableBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
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

&AtClient
Procedure FilesTableOwnerOnChange(Item)
	CurrentRow = ThisObject.Items.FilesTable.CurrentData;
	If NOT ValueIsFilled(CurrentRow.Owner) Then
		CurrentRow.IsLinked = False;
	Else
		FileRowDescription = FileRowDescription();
		FileRowDescription.FileRowID = CurrentRow.UUID;
		FillPropertyValues(FileRowDescription, CurrentRow);
		FileRows = New Array; // Array of See FileRowDescription
		FileRows.Add(FileRowDescription);
		
		CheckExistingLinks(FileRows);
		ReadExistingLinks(FileRows)
	EndIf;
EndProcedure

#EndRegion

#Region Other

&AtClient
Procedure AnalizeFolder_Read()
	
	IsCycleEnd = False;
	StartIndex = PacketSize * PacketIndex;
	EndIndex = StartIndex + PacketSize - 1;
	PacketIndex = PacketIndex + 1;
	
	For CurrentFileIndex = StartIndex To EndIndex Do
		If CurrentFileIndex = ArrayFiles.Count() Then
			IsCycleEnd = True;
			Break;
		EndIf;
		//@skip-check invocation-parameter-type-intersect
		AnalizeFolder_Read_File(ArrayFiles[CurrentFileIndex]);
	EndDo;
	
	If Not IsCycleEnd Then
		ShowCurrentSplashData();
		AttachIdleHandler("AnalizeFolder_Read", 1, True);
		Return;
	EndIf;

	//@skip-check property-return-type
	SetSplashData(R().GPU_CheckingFilesExist);
	
	AttachIdleHandler("AnalizeFolder_CheckFiles", 0.5, True);

EndProcedure

// Analize folder read file.
// 
// Parameters:
//  FileItem - File - File item
&AtClient
Procedure AnalizeFolder_Read_File(FileItem)
	
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
	
	FindingOwnersOnClient();
	
	CloseSplashForm();
	
	ThisObject.Finish = CommonFunctionsServer.GetCurrentSessionDate();

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

// Finding owners on client.
&AtClient
Procedure FindingOwnersOnClient()
	// In extensions, add finding in Before-mode
	
	RowFilter = New Structure("IsLinked", False);
	RowsWithoutLink = FilesTable.FindRows(RowFilter);
	If RowsWithoutLink.Count() > 0 Then
		RowsArray = New Array; // Array of See FileRowDescription
		For Each CurrentRow In RowsWithoutLink Do
			FileRowDescription = FileRowDescription();
			FileRowDescription.FileRowID = CurrentRow.UUID;
			FillPropertyValues(FileRowDescription, CurrentRow);
			RowsArray.Add(FileRowDescription);
		EndDo;
		CheckExistingLinks(RowsArray);
		ReadExistingLinks(RowsArray)
	EndIf;
EndProcedure

// File row description.
// 
// Returns:
//  Structure - File row description:
// * FileRowID - String - 
// * FileRef - CatalogRef.Files - 
// * Owner - DefinedType.typeFilesOwner - 
// * IsLinked - Boolean - 
&AtClientAtServerNoContext
Function FileRowDescription()
	Result = New Structure;
	Result.Insert("FileRowID", "");
	Result.Insert("FileRef", PredefinedValue("Catalog.Files.EmptyRef"));
	Result.Insert("Owner", Undefined);
	Result.Insert("IsLinked", False);
	Return Result;
EndFunction

// Check existing links.
// 
// Parameters:
//  FileRows - Array of See FileRowDescription
&AtServerNoContext
Procedure CheckExistingLinks(FileRows)

	Table = New ValueTable();
	Table.Columns.Add("FileRowID", New TypeDescription("String"));
	Table.Columns.Add("FileRef", New TypeDescription("CatalogRef.Files"));
	Table.Columns.Add("Owner", Metadata.DefinedTypes.typeFilesOwner.Type);
	
	DataMap = New Map;
	For Each FileRow In FileRows Do
		FillPropertyValues(Table.Add(), FileRow);
		DataMap.Insert(FileRow.FileRowID, FileRow);
	EndDo;
	
	Query = New Query;
	Query.SetParameter("Table", Table);
	Query.Text =
	"SELECT
	|	Table.FileRowID,
	|	Table.FileRef,
	|	Table.Owner
	|INTO tmpFiles
	|FROM
	|	&Table AS Table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpFiles.FileRowID,
	|	NOT AttachedFiles.File IS NULL AS IsLinked
	|FROM
	|	tmpFiles AS tmpFiles
	|		LEFT JOIN InformationRegister.AttachedFiles AS AttachedFiles
	|		ON tmpFiles.Owner = AttachedFiles.Owner
	|		AND tmpFiles.FileRef = AttachedFiles.File";
	
	QuerySelection = Query.Execute().Select();
	//@skip-check property-return-type, statement-type-change
	While QuerySelection.Next() Do
		FileRow = DataMap.Get(QuerySelection.FileRowID);
		FileRow.IsLinked = QuerySelection.IsLinked;
	EndDo;
	
EndProcedure

// Read existing links.
// 
// Parameters:
//  FileRows - Array of See FileRowDescription
&AtClient
Procedure ReadExistingLinks(FileRows)
	Filter = New Structure("UUID", "");
	For Each FileRow In FileRows Do
		Filter.UUID = FileRow.FileRowID; 
		TableRow = FilesTable.FindRows(Filter)[0];
		TableRow.IsLinked = FileRow.IsLinked; 
	EndDo;
EndProcedure

// Start loading on client.
// @skip-check property-return-type, statement-type-change
&AtClient
Procedure LoadingOnClient()
	
	IsCycleEnd = False;
	StartIndex = PacketSize * PacketIndex;
	EndIndex = StartIndex + PacketSize - 1;
	PacketIndex = PacketIndex + 1;
	FilesPacket = New Array; // Array of Structure
	FilesTableMap = New Map;

	If TypeOf(FilesTableRecords) = Type("Array") Then
		For CurrentFileIndex = StartIndex To EndIndex Do
			If CurrentFileIndex = FilesTableRecords.Count() Then
				IsCycleEnd = True;
				Break;
			EndIf;
			//@skip-check variable-value-type
			FilesTableRecord = FilesTableRecords[CurrentFileIndex];
			FilesTableMap.Insert(FilesTableRecord.UUID, FilesTableRecord);
			
			FileInfo = PictureViewerClientServer.FileInfo();
			FileInfo.FileID = FilesTableRecord.UUID;
			FileInfo.MD5 = FilesTableRecord.MD5;
			FileInfo.Extension = FilesTableRecord.Extension;
			FileInfo.FileName = FilesTableRecord.FileName;
			FileInfo.Insert("RequestBody", New BinaryData(ThisObject.FolderPath + FilesTableRecord.FilePath));
			FilesPacket.Add(FileInfo);
		EndDo;
	EndIf;
	
	If FilesPacket.Count() > 0 Then
		//@skip-check invocation-parameter-type-intersect
		Loading_SendServer(FilesPacket, ThisObject.PictureConnectionSetting, ThisObject.PreviewScaleSize);
		For Each FileInfo In FilesPacket Do
			FilesTableRecord = FilesTableMap.Get(FileInfo.FileID);
			If FileInfo.Success = True Then
				FilesTableRecord.URI = FileInfo.URI;
				FilesTableRecord.IsSaved = True;
				FilesTableRecord.IsFileCreate = FileInfo.Property("FileRef", FilesTableRecord.FileRef);
			EndIf;
		EndDo;
	EndIf;
	
	If Not IsCycleEnd Then
		ShowCurrentSplashData();
		AttachIdleHandler("LoadingOnClient", 1, True);
		Return;
	EndIf;

	SetSplashData(R().GPU_Load_SaveInBase, 100);
	
	AttachIdleHandler("LoadingOnClient_SaveInBase", 1, True);

EndProcedure

// Loading - send server.
// 
// Parameters:
//  FilesPacket - Array of Structure - Files packet
//  ConnectionSettings - See IntegrationServer.ConnectionSetting
//	PreviewScaleSize - Number - Preview scale size
&AtServerNoContext
Procedure Loading_SendServer(FilesPacket, ConnectionSettings, PreviewScaleSize)
	
	Volume = PictureViewerServer.GetIntegrationSettingsPicture().DefaultPictureStorageVolume; // CatalogRef.FileStorageVolumes
	
	For Each FileInfo In FilesPacket Do // See PictureViewerClientServer.FileInfo
		
		FileInfo.Success = False;
		FileBody = FileInfo["RequestBody"]; // BinaryData
		
		UploadPictureParameters = New Structure();
		UploadPictureParameters.Insert("ConnectionSettings", ConnectionSettings);
		UploadPictureParameters.Insert("RequestBody", FileBody);
		UploadPictureParameters.Insert("FileID", FileInfo.FileID);
		
		//@skip-check property-return-type
		If ConnectionSettings.Value.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
			
			IntegrationServer.SaveFileToFileStorage(
				ConnectionSettings.Value.AddressPath, 
				FileInfo.FileID + "." + FileInfo.Extension, 
				FileBody);
			FileInfo.Success = True;
			FileInfo.URI = FileInfo.FileID + "." + FileInfo.Extension;
	
		ElsIf Not PictureViewerServer.ExtensionCall_UploadPicture(FileInfo, UploadPictureParameters) Then
			
			ConnectionSettings.Value.QueryType = "POST";
			ResourceParameters = New Map();
			ResourceParameters.Insert("filename", FileInfo.FileID + "." + FileInfo.Extension);	
			RequestResult = IntegrationClientServer.SendRequest(
				ConnectionSettings.Value, ResourceParameters, , FileBody);
			If IntegrationClientServer.RequestResultIsOk(RequestResult) Then
				DeserializeResponse = CommonFunctionsServer.DeserializeJSON(RequestResult.ResponseBody);
				//@skip-check statement-type-change
				FileInfo.URI = DeserializeResponse.Data.URI;
			EndIf;
		EndIf;
		
		FileInfo.Success = Not IsBlankString(FileInfo.URI);
		If FileInfo.Success = True Then
			FilePreview = PictureViewerServer.UpdatePictureInfoAndGetPreview(FileBody, PreviewScaleSize);
			FillPropertyValues(FileInfo, FilePreview, "Preview,Size,Height,Width");
			FileInfo.Insert("FileRef", PictureViewerServer.CreateFile(Volume, FileInfo));
		EndIf;
		
	EndDo;

EndProcedure

&AtClient
Procedure LoadingOnClient_SaveInBase()
	
	LoadingSaveInBaseOnServer();
	
	CloseSplashForm();
	
EndProcedure

&AtServer
Procedure LoadingSaveInBaseOnServer()
	
	CompleteRecords = New Array; // Array of FormDataCollectionItem
	For Each FilesTableRecord In ThisObject.FilesTable Do
		If Not FilesTableRecord.IsLinked And ValueIsFilled(FilesTableRecord.FileRef) And ValueIsFilled(FilesTableRecord.Owner) Then
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
	
	For Each FilesTableRecord In CompleteRecords Do
		//@skip-check property-return-type
		FilesTableRecord.IsLinked = True;
	EndDo;

EndProcedure

// Create splash form.
//@skip-check structure-consructor-value-type, property-return-type
// 
// Parameters:
//  FormTitle - String - Form title
//  ItemCount - Number - Item count
&AtClient
Procedure CreateSplashForm(FormTitle, ItemCount)
	SplashForm = OpenForm("CommonForm.BackgroundJobSplash",
		New Structure("BackgroundJobTitle", FormTitle),
		ThisObject, 
		BackgroundJobUUID,,,,
		FormWindowOpeningMode.LockOwnerWindow);
	SplashForm.FormCanBeClose = True;
	SplashForm.CommandBar.ChildItems.FormCancelJob.Visible = False;
	SplashForm.Items.DoNotCloseOnFinish.Visible = False;
	SplashForm.Items.Percent.MaxValue = ItemCount;
EndProcedure

// Set splash data.
// @skip-check property-return-type
// 
// Parameters:
//  JobTitle - Undefined, String - Job title
//  MaxPercent - Undefined, Number - Max percent
&AtClient
Procedure SetSplashData(JobTitle = Undefined, MaxPercent = Undefined) Export
	If JobTitle <> Undefined Then
		SplashForm.JobTitle = JobTitle;
	EndIf;
	If MaxPercent <> Undefined Then
		SplashForm.Items.Percent.MaxValue = MaxPercent;
		SplashForm.Percent = 0;
	EndIf;
	SplashForm.EndDate = CommonFunctionsServer.GetCurrentSessionDate();
EndProcedure

// Show current splash data.
//@skip-check property-return-type
&AtClient
Procedure ShowCurrentSplashData() Export
	SplashForm.Percent = PacketIndex;
	SplashForm.EndDate = CommonFunctionsServer.GetCurrentSessionDate();
	
	If PacketIndex > 0 Then
		TotalTime = SplashForm.EndDate - SplashForm.StartTime;
		SplashForm.EndIn = SplashForm.StartTime + TotalTime * (SplashForm.Items.Percent.MaxValue / PacketIndex);
	EndIf;
EndProcedure

// Close splash form.
//@skip-check statement-type-change, dynamic-access-method-not-found
&AtClient
Procedure CloseSplashForm()
	If SplashForm <> Undefined Then
		SplashForm.Close();
		SplashForm = Undefined;
	EndIf;
EndProcedure

#EndRegion

//@skip-check module-structure-init-code-in-region
PacketSize = 10;
