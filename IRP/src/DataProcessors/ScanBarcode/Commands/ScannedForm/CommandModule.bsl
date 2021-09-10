&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("Basis", CommandParameter);
	OpenForm("DataProcessor.ScanBarcode.Form", FormParameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure