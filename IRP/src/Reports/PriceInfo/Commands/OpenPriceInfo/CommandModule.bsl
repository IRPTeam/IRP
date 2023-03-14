&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("PriceOwner", CommandParameter);
	OpenForm("Report.PriceInfo.Form.ReportForm", FormParameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure