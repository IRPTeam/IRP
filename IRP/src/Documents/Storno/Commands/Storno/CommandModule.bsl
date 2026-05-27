
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure("FillingValues", 
		New Structure("Company, Basis", CommonFunctionsServer.GetRefAttribute(CommandParameter, "Company"), CommandParameter));
	OpenForm("Document.Storno.ObjectForm", FormParameters);
EndProcedure
