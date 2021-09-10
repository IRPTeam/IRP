&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	FormParameters = New Structure("Document, PutInTable, GenerateOnOpen", CommandParameter, True, True);
	OpenForm("Report.DocumentRegistrationsReport.ObjectForm", FormParameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness);
EndProcedure