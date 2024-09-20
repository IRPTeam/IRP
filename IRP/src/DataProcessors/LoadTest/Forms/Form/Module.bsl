
&AtClient
Procedure Test(Command)
	END = New CallbackDescription("Upload_END", ThisObject);	
	FilesClient.StartFileLoading(PictureViewerClientServer.FilterForPicturesDialog(), END, UUID);
EndProcedure

// Upload END.
// 
// Parameters:
//  FileRef - StoredFileDescription,Undefined - File ref
//  StructureParams - Structure - Structure parameters
&AtClient
Procedure Upload_END(FileRef, StructureParams) Export
	If FileRef = Undefined Then
		Return;
	EndIf;
	
	FileArray = New Array; // Array of FileRef
	FileArray.Add(FileRef.FileRef);
EndProcedure