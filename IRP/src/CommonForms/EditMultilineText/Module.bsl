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

&AtClient
Procedure OnOpen(Cancel)
	Text.SetText(FormOwner.Object[ItemName]);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ItemName = Parameters.ItemName;
EndProcedure

