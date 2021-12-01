
Procedure EditCurrenciesContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	Form.Modified = True;
	Rows = Object.Currencies.FindRows(New Structure("Key", Result.RowKey));
	For Each Row In Rows Do
		Object.Currencies.Delete(Row);
	EndDo;
	For Each Row In Result.Currencies Do
		FillPropertyValues(Object.Currencies.Add(), Row);
	EndDo;
EndProcedure
