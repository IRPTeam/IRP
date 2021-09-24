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
	FilesAtServer = Await PutFilesToServerAsync( , , FileIDs);	
	SaveFiles(FilesAtServer);
EndProcedure

&AtServer
Procedure SaveFiles(FilesAtServer) 
	
EndProcedure

&AtClient
Procedure DownloadFile(Command)
	//TODO: Insert the handler content
EndProcedure
