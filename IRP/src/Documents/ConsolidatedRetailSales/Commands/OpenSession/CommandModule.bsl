
&AtClient
Async Procedure CommandProcessing(DocConsolidatedRetailSales, CommandExecuteParameters)
	EquipmentOpenShiftResult = Await EquipmentFiscalPrinterClient.OpenShift(DocConsolidatedRetailSales); // See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
	If EquipmentOpenShiftResult.Info.Success Then
		DocConsolidatedRetailSalesServer.DocumentOpenShift(DocConsolidatedRetailSales, EquipmentOpenShiftResult.Out.OutputParameters);
		NotifyChanged(Type("DocumentRef.ConsolidatedRetailSales"));
	Else
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentOpenShiftResult.Info.Error);
	EndIf;
EndProcedure
