&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	FormParameters = New Structure("Document, PutInTable, GenerateOnOpen", CommandParameter, True, True);
	OpenForm("Report.D0013_DocumentRegistrationsReport.ObjectForm", FormParameters, CommandExecuteParameters.Source,
		CommandParameter);
EndProcedure