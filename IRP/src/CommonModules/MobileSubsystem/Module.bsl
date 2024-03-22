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

Procedure Play(Sound) Export
#If MobileClient Then
	MultimediaTools.PlayAudio(Sound);
#EndIf	
EndProcedure

Procedure Vibrate() Export
#If MobileClient Then
	MultimediaTools.PlaySoundAlert(SoundAlert.None, True);
#EndIf
EndProcedure
