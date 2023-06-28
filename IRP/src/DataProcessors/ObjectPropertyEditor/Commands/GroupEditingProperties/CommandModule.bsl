
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	If TypeOf(CommandParameter) = Type("Array") And CommandParameter.Count() > 0 Then
		RefsList = New ValueList;
		RefsList.LoadValues(CommandParameter);
		FormParameters = New Structure("RefsList, ObjectTable", RefsList, "Ref");
		OpenForm("DataProcessor.ObjectPropertyEditor.Form.Form", 
			FormParameters, 
			CommandExecuteParameters.Source, 
			CommandExecuteParameters.Uniqueness, 
			CommandExecuteParameters.Window, 
			CommandExecuteParameters.URL);
	EndIf;
EndProcedure
