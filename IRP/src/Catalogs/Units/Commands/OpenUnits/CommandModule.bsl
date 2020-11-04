
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("Item", CommandParameter);
	Filter = New Structure("Filter", FormParameters);
	OpenForm("Catalog.Units.ListForm", Filter, CommandExecuteParameters.Source, 
				CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, 
				CommandExecuteParameters.URL);
EndProcedure
