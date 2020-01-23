&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filter = New Structure();
	Filter.Insert("Item", CommandParameter);
	OpenArgs = New Structure();
	OpenArgs.Insert("Filter", Filter);
	OpenForm("Catalog.PriceKeys.ListForm",
		OpenArgs,
		CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness,
		CommandExecuteParameters.Window,
		CommandExecuteParameters.URL);
EndProcedure

