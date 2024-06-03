
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FilterParameters = New Structure("Item", CommandParameter);
	FormParameters = New Structure("Filter, GenerateOnOpen", FilterParameters, True);
	OpenForm("Report.D4010_ActualStocks.Form", FormParameters, CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure
