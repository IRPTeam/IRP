&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FillingValues = New Structure("Basis", CommandParameter);
	OpenForm("Document.Unboxing.ObjectForm", New Structure("FillingValues", FillingValues));
EndProcedure

