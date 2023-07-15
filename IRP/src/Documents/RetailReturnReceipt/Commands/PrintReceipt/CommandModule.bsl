
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintReceipt(CommandParameter);
EndProcedure

&AtClient
Async Procedure PrintReceipt(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales");
	If IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales) Then
		Return;
	EndIf;
	//@skip-check module-unused-local-variable
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(ConsolidatedRetailSales, CommandParameter);
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction