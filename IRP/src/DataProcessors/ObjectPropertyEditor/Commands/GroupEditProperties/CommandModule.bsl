
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	If TypeOf(CommandParameter) = Type("Array") And CommandParameter.Count() > 0 Then
		FormParameters = New Structure("RefsList", CommandParameter);
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.Form", 
			FormParameters, 
			CommandExecuteParameters.Source, 
			CommandExecuteParameters.Uniqueness, 
			CommandExecuteParameters.Window, 
			CommandExecuteParameters.URL);
	EndIf;
EndProcedure
