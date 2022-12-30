
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
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(ConsolidatedRetailSales, CommandParameter);
	If EquipmentPrintFiscalReceiptResult.Success Then
		EquipmentFiscalPrinterServer.SetFiscalStatus(CommandParameter
						, EquipmentPrintFiscalReceiptResult.Status
						, EquipmentPrintFiscalReceiptResult.FiscalResponse
						, EquipmentPrintFiscalReceiptResult.DataPresentation);
	Else
		EquipmentFiscalPrinterServer.SetFiscalStatus(CommandParameter
						, EquipmentPrintFiscalReceiptResult.Status
						, EquipmentPrintFiscalReceiptResult.ErrorDescription);
	EndIf;
EndProcedure

&AtServer
Function IsConsolidatedRetailSalesEmpty(ConsolidatedRetailSales)
	Return ConsolidatedRetailSales.IsEmpty();
EndFunction