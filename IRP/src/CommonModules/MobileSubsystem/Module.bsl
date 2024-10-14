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
// * Address - String - 
// * Extension - String - 
// * Name - String -
Function CreateVideo(UUID = Undefined) Export
#If MobileAppClient Or MobileClient Then
	If MultimediaTools.VideoRecordingSupported() Then	
		Video = MultimediaTools.MakeVideoRecording();
		
		If Video = Undefined Then
			Return Undefined;
		EndIf;
		
		VideoData = New Structure;
		VideoData.Insert("Address", PutToTempStorage(Video.GetBinaryData(), UUID));
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
//  * Address - String -
//  * Name - String -
Async Function AddAttachment(UUID = Undefined) Export
	Files = Await PutFilesToServerAsync( , , , UUID);
	Array = New Array;
	
	For Each File In Files Do // StoredFileDescription
		Str = New Structure;
		Str.Insert("Extension", File.FileRef.Extension);
		Str.Insert("Address", File.Address);
		Str.Insert("Name", File.FileRef.File.BaseName);
		Array.Add(Str);
	EndDo; 
	
	Return Array;
EndFunction

// Create photo.
// 
// Returns:
//  Undefined, Structure - Create photo:
// * Address - String - 
// * Extension - String - 
// * Name - String - 
Function CreatePhoto(UUID = Undefined) Export
#If MobileAppClient Or MobileClient Then
	If MultimediaTools.PhotoSupported() Then	
		Photo = MultimediaTools.MakePhoto();
		
		If Photo = Undefined Then
			Return Undefined;
		EndIf;
		
		PhotoData = New Structure;
		PhotoData.Insert("Address", PutToTempStorage(Photo.GetBinaryData(), UUID));
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
