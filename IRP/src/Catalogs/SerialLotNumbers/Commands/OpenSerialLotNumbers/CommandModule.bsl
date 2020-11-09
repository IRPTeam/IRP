
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("SerialLotNumberOwner", CommandParameter);
	OpenForm("Catalog.SerialLotNumbers.ListForm", FormParameters, CommandExecuteParameters.Source, 
				CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, 
				CommandExecuteParameters.URL);
EndProcedure
