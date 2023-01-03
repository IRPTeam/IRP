
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashOut(CommandParameter);
EndProcedure

&AtClient
Async Procedure PrintCashOut(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales");
	If Not IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales) Then
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashInCome(ConsolidatedRetailSales
				, - CommonFunctionsServer.GetRefAttribute(CommandParameter, "SendAmount"));
		If EquipmentResult.Success Then
	
		EndIf;
	EndIf;
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction
