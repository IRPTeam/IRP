// @strict-types

// Command processing.
// 
// Parameters:
//  CommandParameter - DocumentRef.RetailReturnReceipt -  Command parameter
//  CommandExecuteParameters - CommandExecuteParameters -  Command execute parameters
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintReceipt(CommandParameter);
EndProcedure

// Print receipt.
// 
// Parameters:
//  CommandParameter - DocumentRef.RetailReturnReceipt -  Command parameter
&AtClient
Async Procedure PrintReceipt(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales"); // DocumentRef.ConsolidatedRetailSales
	If ConsolidatedRetailSales.IsEmpty() Then
		Return;
	EndIf;
	
	StatusType = CommonFunctionsServer.GetRefAttribute(CommandParameter, "StatusType");
	If StatusType <> PredefinedValue("Enum.RetailReceiptStatusTypes.Completed") Then
		Return;
	EndIf;
	
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(ConsolidatedRetailSales, CommandParameter); // See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
	
	If Not EquipmentPrintFiscalReceiptResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentPrintFiscalReceiptResult.Info.Error);
	EndIf;
	NotifyChanged(Type("DocumentRef.RetailReturnReceipt"));
EndProcedure
