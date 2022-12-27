
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashIn(CommandParameter);
	//TODO: Paste handler content.
	//FormParameters = New Structure("", );
	//OpenForm("Document.Document.ListForm", FormParameters, CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure

&AtClient
Async Procedure PrintCashIn(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales");
	If Not IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales) Then
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashInCome(CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales"), GetSumm(CommandParameter));
		If EquipmentResult.Success Then
	
		EndIf;
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
