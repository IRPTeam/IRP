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
	If IsBlankString(TableName) Then
		Text.SetText(FormOwner.Object[ItemName]);
	Else
		Text.SetText(FormOwner.Object[TableName][TableIndex][ItemName]);
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ItemName = Parameters.ItemName;
	TableName = Parameters.TableName;
	TableIndex = Parameters.TableIndex;
EndProcedure