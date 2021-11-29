
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = GetFormParameters(CommandParameter);
	OpenForm("Report.OffsetOfAdvances.Form.ReportForm", FormParameters, 
		CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, , CommandExecuteParameters.URL);
EndProcedure

&AtServer
Function GetFormParameters(Doc)
	FormParameters = New Structure();
	FormParameters.Insert("StartDate", Doc.BeginOfPeriod);
	FormParameters.Insert("EndDate", Doc.EndOfPeriod);
	Return FormParameters;
EndFunction
	