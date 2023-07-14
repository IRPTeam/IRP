
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashOut(CommandParameter);
	//TODO: Paste handler content.
	//FormParameters = New Structure("", );
	//OpenForm("Document.Document.ListForm", FormParameters, CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure

&AtClient
Async Procedure PrintCashOut(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales");
	If Not IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales) Then
		//@skip-check module-unused-local-variable
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashOutCome(ConsolidatedRetailSales
				, CommandParameter
				, GetSumm(CommandParameter));
	EndIf;
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction

&AtServer
Function GetSumm(CommandParameter)
	Return CommandParameter.PaymentList.Total("TotalAmount");
EndFunction
