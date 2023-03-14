&AtClient
Procedure VoiceNarrator(Command)
	RECOGNIZE_SPEECH = MobileSubsystem.RECOGNIZE_SPEECH();
	If ValueIsFilled(RECOGNIZE_SPEECH) Then
		Text.AddLine(RECOGNIZE_SPEECH);
	EndIf;
EndProcedure

&AtClient
Procedure OK(Command)
	Close(Text.GetText());
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Text.SetText(Parameters.ExternalText);
EndProcedure