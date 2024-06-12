
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Owner = Parameters.Owner;
	DefaultFilesStorageVolume = Constants.DefaultFilesStorageVolume.Get();
	FileList.Parameters.SetParameterValue("Owner", Owner);
EndProcedure

&AtClient
Procedure UploadDrag(Item, DragParameters, StandardProcessing)
	StandardProcessing = False;
	FileArray = New Array();
	If TypeOf(DragParameters.Value) = Type("Array") Then
		FileArray = DragParameters.Value;
	Else
		FileArray.Add(DragParameters.Value);
	EndIf;
	UploadFiles(FileArray);
EndProcedure

&AtClient
Procedure UploadDragCheck(Item, DragParameters, StandardProcessing)
	StandardProcessing = False;
EndProcedure

&AtClient
Async Procedure UploadFiles(FileArray)
	UserNotify = New Array();
	FilesToTransfer = New Array;
	For Each FileRef In FileArray Do
		If Not Await FileRef.File.IsDirectoryAsync() Then
			Size = FileRef.Size();
			byteSize = 1024;
			Size = Format(Size / (byteSize * byteSize), "NFD=3;");
			UserNotify.Add(FileRef.Name + " ( " + Size + "Mb )");
			FilesToTransfer.Add(FileRef);
		EndIf;
	EndDo;
	QueryText = StrTemplate(R().QuestionToUser_022, StrConcat(UserNotify, Chars.LF));
	If Await DoQueryBoxAsync(QueryText, QuestionDialogMode.OKCancel) = DialogReturnCode.OK Then
		AttachFileToOwner(FilesToTransfer);
	EndIf;
EndProcedure

&AtClient
Async Procedure AttachFileToOwner(FileIDs)
	FilesAtServer = Await PutFilesToServerAsync( , , FileIDs, UUID);	
	StrParam = New Structure("Ref, UUID", Owner, UUID);
	For Each File In FilesAtServer Do
		PictureViewerClient.AddFile(File, DefaultFilesStorageVolume, StrParam);
	EndDo;
	NotifyChanged(Type("InformationRegisterRecordKey.AttachedFiles"));
EndProcedure

&AtClient
Procedure DownloadFile(Command)
	If Items.FileList.CurrentData = Undefined Then
		Return;
	EndIf;
	PictureParameters = CreatePictureParameters(Items.FileList.CurrentData.File);
	PictureURL = PictureViewerClient.GetPictureURL(PictureParameters);
	GetFileFromServerAsync(PictureURL, PictureParameters.Description, New GetFilesDialogParameters());
EndProcedure

&AtServer
Function CreatePictureParameters(File)
	Return PictureViewerServer.CreatePictureParameters(File);
EndFunction

&AtClient
Procedure DeleteSelectedFiles(Command)
	If Items.FileList.CurrentData = Undefined Then
		Return;
	EndIf;
	
	FileKeys = New Array;
	For Each SelectedRow In Items.FileList.SelectedRows Do
		FileKeys.Add(SelectedRow);
	EndDo;
	
	DeleteFilesAtServer(FileKeys);
	Items.FileList.Refresh();
EndProcedure

&AtServerNoContext
Procedure DeleteFilesAtServer(FileKeys)
	
	RecordManager = InformationRegisters.AttachedFiles.CreateRecordManager();
	
	For Each FileKey In FileKeys Do
		RecordManager.Owner = FileKey.Owner;
		RecordManager.File = FileKey.File;
		RecordManager.Read();
		If RecordManager.Selected() Then
			RecordManager.Delete();
		EndIf;
	EndDo;
	
EndProcedure