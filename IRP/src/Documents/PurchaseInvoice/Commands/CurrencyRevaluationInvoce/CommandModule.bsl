
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	InvoiceInfo = DocumentsGenerationServer.GetCurrencyRevaluationInvoiceInfo(CommandParameter, 
		"R1021B_VendorsTransactions");
	
	If Not ValueIsFilled(InvoiceInfo.DocumentName) Then
		Return;
	EndIf;
	
	FormParameters = New Structure("FillingValues", InvoiceInfo.FillingValues);
	OpenForm("Document." + InvoiceInfo.DocumentName + ".ObjectForm", FormParameters, 
		CommandExecuteParameters.Source, 
		CommandExecuteParameters.Uniqueness); 
EndProcedure
