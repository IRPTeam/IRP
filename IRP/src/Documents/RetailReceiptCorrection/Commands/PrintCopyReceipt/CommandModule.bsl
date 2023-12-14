
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
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.PrintCheckCopy(ConsolidatedRetailSales, CommandParameter); // See EquipmentFiscalPrinterAPIClient.PrintCheckCopySettings

	If EquipmentPrintFiscalReceiptResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentPrintFiscalReceiptResult.Info.Error);
	EndIf;
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction