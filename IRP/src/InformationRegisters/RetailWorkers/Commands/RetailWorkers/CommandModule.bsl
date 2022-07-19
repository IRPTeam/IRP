
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filter = New Structure();
	Filter.Insert("Worker", CommandParameter);
	Parameters = New Structure();
	Parameters.Insert("Filter", Filter);
	OpenForm("InformationRegister.RetailWorkers.ListForm", Parameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure
