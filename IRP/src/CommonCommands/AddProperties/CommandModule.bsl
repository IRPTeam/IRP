&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	If CommandParameter = Undefined Then
		Return;
	EndIf;
	
	FormArgs = New Structure();
	FormArgs.Insert("Ref", CommandParameter);
	
	OpenForm("CommonForm.EditAddProperties",
		FormArgs,
		CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness,
		CommandExecuteParameters.Window);
	
EndProcedure