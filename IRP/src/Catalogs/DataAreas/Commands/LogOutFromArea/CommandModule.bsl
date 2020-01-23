
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	#If NOT MobileAppClient Then
		ClientApplication.SetCaption("IRP");
	#EndIf

	Str = New Structure("ID", 0);
	Saas.SetSeparationParameters(Str);	
EndProcedure
