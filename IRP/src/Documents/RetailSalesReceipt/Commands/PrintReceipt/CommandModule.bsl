
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
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(ConsolidatedRetailSales, CommandParameter); //  See EquipmentFiscalPrinterClient.ReceiptResultStructure
	
	If EquipmentPrintFiscalReceiptResult.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	EndIf;  
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction