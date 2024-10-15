Function RECOGNIZE_SPEECH() Export
	Info = InfoSample();
	Info.Action = "android.speech.action.RECOGNIZE_SPEECH";
	AppRun = StartApplication(Info);
	If AppRun = Undefined Then
		Return Undefined;
	Else
		//@skip-check unknown-method-property
		Return AppRun.AdditionalData.Get("query").Value;
	EndIf;
EndFunction

Function SendTo(SpreadsheetDocument) Export
	Info = InfoSample();

	Info.Action = "android.intent.action.SEND";

	Path = DocumentsDir() + "Report.pdf";
	SpreadsheetDocument.Write(Path, SpreadsheetDocumentFileType.PDF);

	Info.AdditionalData.Add(New Structure("Name, Value, Type", "android.intent.extra.STREAM", "file://" + Path, "uri"));
	Info.AdditionalData.Add(New Structure("Name, Value, Type", "android.intent.extra.SUBJECT", "Info", "String"));
	Info.Wait = False;
	Info.Type = "*/*";
	StartApplication(Info);
	Return Undefined;

EndFunction

// Get coordinates.
// 
// Returns:
//  Undefined, Structure - Get coordinates:
// * Latitude - Number - 
// * Longitude - Number - 
Function GetCoordinates() Export
#If MobileAppClient Or MobileClient Then
	If Not LocationTools.LocationDataUseEnabled() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Mobile_4);
		Return Undefined;
	EndIf; 
	
	Provider = LocationTools.GetMostAccurateProvider(True);
	If Not LocationTools.UpdateLocation(Provider.Name, 10) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Mobile_5);
		Return Undefined;
	EndIf;
	
	CoordinatesInfo = LocationTools.GetLastLocation(Provider.Name);
	
	Coordinates = New Structure;
	Coordinates.Insert("Latitude", CoordinatesInfo.Coordinates.Latitude);
	Coordinates.Insert("Longitude", CoordinatesInfo.Coordinates.Longitude);
	
	Return Coordinates;
#EndIf	
EndFunction

Function StartApplication(Info) Export
#If MobileAppClient Or MobileClient Then
	NewAppRun = New MobileDeviceApplicationRun();

	If NewAppRun.RunningSupported() Then
		FillPropertyValues(NewAppRun, Info, , "AdditionalData");
		For Each StrAddData In Info.AdditionalData Do
			NewAppRun.AdditionalData.Add(StrAddData.Name, StrAddData.Value, StrAddData.Type);
		EndDo;

		Result = NewAppRun.Run(Info.Wait);
		If Info.ErrorCode = Result Then
			Return Undefined;
		Else
			Return NewAppRun;
		EndIf;
	Else
		Return Undefined;
	EndIf;
#Else
		Return Undefined;
#EndIf

EndFunction

Function InfoSample() Export
	Info = New Structure();
	Info.Insert("Data", "");
	Info.Insert("Action", "");
	Info.Insert("ClassName", "");
	Info.Insert("Category", "");
	Info.Insert("Package", "");
	Info.Insert("Wait", True);
	Info.Insert("ErrorCode", 0);
	Info.Insert("Type", "");
	AdditionalData = New Array();

	Info.Insert("AdditionalData", AdditionalData);

	Return Info;

EndFunction

// Create video.
// 
// Returns:
//  Undefined, Structure - Create video:
// * BD - BinaryData - 
// * Extension - String - 
// * Name - String -
Function CreateVideo() Export
#If MobileAppClient Or MobileClient Then
	If MultimediaTools.VideoRecordingSupported() Then	
		Video = MultimediaTools.MakeVideoRecording();
		
		If Video = Undefined Then
			Return Undefined;
		EndIf;
		
		VideoData = New Structure;
		VideoData.Insert("BD", Video.GetBinaryData());
		VideoData.Insert("Extension", Video.FileExtention);
		VideoData.Insert("Name", "Video");
		
		Return VideoData;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().Mobile_2);
	EndIf;
	Return Undefined
#EndIf		
EndFunction

// Add attachment.
// 
// Parameters:
//  UUID - Undefined - UUID
// 
// Returns:
//  Array Of Structure:
//  * Extension - String - 
//  * BD - BinaryData -
//  * Name - String -
Async Function AddAttachment() Export
	FileDialog = New FileDialog(FileDialogMode.Open); 
	FileDialog.Multiselect = True;
	FileDialog.MIMETypes.Add("image");
	
	Array = New Array;
	Files = Await FileDialog.ChooseAsync();
	If Files = Undefined  Then
		Return Array;
	EndIf;
	
	For Each FilePath In Files Do // StoredFileDescription
		File = New File(FilePath);                         
		#If MobileAppClient Or MobileClient Then
			Name = File.GetMobileDeviceLibraryFilePresentation();
		#Else
			Name = File.Name;
		#EndIf                     
		NameParts = StrSplit(Name, ".");
		Str = New Structure;
		Str.Insert("Extension", NameParts[NameParts.UBound()]);
		NameParts.Delete(NameParts.UBound());
		Str.Insert("BD", New BinaryData(FilePath));
		Str.Insert("Name", StrConcat(NameParts, "."));
		Array.Add(Str);
	EndDo; 
	
	Return Array;
EndFunction

// Create photo.    
// Parameters:
//	Stamp - String -
// 
// Returns:
//  Undefined, Structure - Create photo:
// * BD - BinaryData - 
// * Extension - String - 
// * Name - String - 
Function CreatePhoto(Stamp = "") Export
#If MobileAppClient Or MobileClient Then
	If MultimediaTools.PhotoSupported() Then
		
		Resolution = New DeviceCameraResolution(1280,720);
		
		Photo = MultimediaTools.MakePhoto(, Resolution, 50, , , New PhotoStamp(True, , Stamp));
		
		If Photo = Undefined Then
			Return Undefined;
		EndIf;
		
		PhotoData = New Structure;
		PhotoData.Insert("BD", Photo.GetBinaryData());
		PhotoData.Insert("Extension", Photo.FileExtention);
		PhotoData.Insert("Name", "Photo");
		Return PhotoData;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().Mobile_1);
	EndIf;
	Return Undefined
#EndIf		
EndFunction

Procedure Play(Sound) Export
#If MobileAppClient Or MobileClient Then
	MultimediaTools.PlayAudio(Sound);
#EndIf	
EndProcedure

Procedure Vibrate() Export
#If MobileAppClient Or MobileClient Then
	MultimediaTools.PlaySoundAlert(SoundAlert.None, True);
#EndIf
EndProcedure
