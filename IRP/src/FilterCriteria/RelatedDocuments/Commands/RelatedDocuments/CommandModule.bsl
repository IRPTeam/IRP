&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("DocumentRef", CommandParameter);
	OpenForm("CommonForm.RelatedDocuments", FormParameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness);
EndProcedure