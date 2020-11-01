#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If IsTempStorageURL(FileAddress) Then
		CurrentObject.FileData = New ValueStorage(GetFromTempStorage(FileAddress));
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

#EndRegion

#Region CommandInterface

&AtClient
Procedure AddFile(Command)
	PutFilesDialogParameters = New PutFilesDialogParameters(, , "(*.cfe)|*.cfe");
	EndCall			= New NotifyDescription("AddFileEndCall", ThisObject);
    ProgressCall    = New NotifyDescription("AddFileProgressCall", ThisObject);
    BeforeStartCall = New NotifyDescription("AddFileBeforeStartCall", ThisObject);
    BeginPutFileToServer(EndCall, ProgressCall, BeforeStartCall, , PutFilesDialogParameters, ThisObject.UUID);
EndProcedure

&AtClient
Procedure SaveFile(Command)
	If Parameters.Key.IsEmpty() Then
    	QuestionToUserNotify = New NotifyDescription("SaveFileNewObjectContinue", ThisObject);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
		Return;
    EndIf;
    SaveFileContinue();
EndProcedure

#EndRegion

&AtClient
Procedure AddFileEndCall(FileDescription, AddInfo) Export
	If FileDescription.PutFileCanceled Then
		Return;
	EndIf;
	
	FileAddress = FileDescription.Address;
	Object.Description = FileDescription.FileRef.File.BaseName;
EndProcedure

&AtClient
Procedure AddFileProgressCall(PuttingFile, PutProgress, CancelPut, AddInfo) Export
	#If Not MobileClient AND Not MobileAppClient Then
    	Status(PuttingFile.Name, PutProgress);
    #EndIf
EndProcedure

&AtClient
Procedure AddFileBeforeStartCall(PuttingFile, CancelPut, AddInfo) Export
	Return;
EndProcedure

&AtClient
Procedure SaveFileNewObjectContinue(Result, AddInfo = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		SaveFileContinue();
	EndIf;
EndProcedure

&AtClient
Procedure SaveFileContinue()
	BeginGetFileFromServer(GetURL(Object.Ref, "FileData"), Object.Description);
EndProcedure

