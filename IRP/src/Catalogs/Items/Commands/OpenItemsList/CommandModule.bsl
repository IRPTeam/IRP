&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FilterData = New Structure("ItemType", CommandParameter);
	OpenArgs = New Structure("Filter", FilterData);
	OpenForm("Catalog.Items.ListForm",
		OpenArgs,
		CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness,
		CommandExecuteParameters.Window,
		CommandExecuteParameters.URL);
EndProcedure