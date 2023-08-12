
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("Hardware, OpenAsLog", CommandParameter, True);
	OpenForm("InformationRegister.HardwareLog.Form.LogAnalyze", FormParameters, CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure
