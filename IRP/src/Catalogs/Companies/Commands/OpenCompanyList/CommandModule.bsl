&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filter = New Structure();
	Filter.Insert("Partner", CommandParameter);
	FormParameters = New Structure();
	FormParameters.Insert("Filter", Filter);
	
	OpenForm("Catalog.Companies.ListForm",
		FormParameters,
		CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness,
		CommandExecuteParameters.Window,
		CommandExecuteParameters.URL);
EndProcedure