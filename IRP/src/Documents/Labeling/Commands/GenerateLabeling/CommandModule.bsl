&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FillingValues = New Structure("BasedOn", CommandParameter);
	OpenForm("Document.Labeling.ObjectForm", New Structure("FillingValues", FillingValues));
EndProcedure