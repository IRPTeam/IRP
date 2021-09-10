&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filter = New Structure();
	Filter.Insert("Item", CommandParameter);
	Parameters = New Structure();
	Parameters.Insert("Filter", Filter);
	OpenForm("Catalog.ItemKeys.ListForm", Parameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure