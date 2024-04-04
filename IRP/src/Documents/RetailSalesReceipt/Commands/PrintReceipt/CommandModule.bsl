
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintReceipt(CommandParameter);
EndProcedure

&AtClient
Async Procedure PrintReceipt(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales");
	If ConsolidatedRetailSales.IsEmpty() Then
		Return;
	EndIf;
	
	StatusType = CommonFunctionsServer.GetRefAttribute(CommandParameter, "StatusType");
	If StatusType <> PredefinedValue("Enum.RetailReceiptStatusTypes.Completed") Then
		Return;
	EndIf;
	
	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(ConsolidatedRetailSales, CommandParameter); //  See EquipmentFiscalPrinterClient.ReceiptResultStructure
	
	If EquipmentPrintFiscalReceiptResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentPrintFiscalReceiptResult.Info.Error);
	EndIf;
	NotifyChanged(Type("DocumentRef.RetailSalesReceipt"));
EndProcedure
