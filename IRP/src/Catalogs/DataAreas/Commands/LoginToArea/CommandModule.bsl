
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Code = AreasOnChangeServer(CommandParameter);
	#If NOT MobileAppClient Then
		ClientApplication.SetCaption("IRP (area: " + Code + ")");
	#EndIf
EndProcedure

&AtServer
Function AreasOnChangeServer(CurrentArea)
	Str = New Structure("ID", CurrentArea.Code);
	Saas.SetSeparationParameters(Str);
	Return CurrentArea.Code;
EndFunction
