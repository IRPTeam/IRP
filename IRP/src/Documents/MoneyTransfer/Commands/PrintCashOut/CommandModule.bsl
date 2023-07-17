
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashOut(CommandParameter);
EndProcedure

&AtClient
Async Procedure PrintCashOut(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales");
	If Not IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales) Then
		//@skip-check module-unused-local-variable
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashOutCome(ConsolidatedRetailSales
				, CommandParameter
				, CommonFunctionsServer.GetRefAttribute(CommandParameter, "SendAmount"));
	EndIf;
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction
