&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("FillingValues", New Structure("Basis", CommandParameter));
	OpenForm("Document.RetailReceiptCorrection.ObjectForm", FormParameters);
EndProcedure
