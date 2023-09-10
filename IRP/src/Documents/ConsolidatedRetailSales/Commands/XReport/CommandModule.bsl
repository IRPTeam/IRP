
&AtClient
Async Procedure CommandProcessing(DocConsolidatedRetailSales, CommandExecuteParameters)
	Settings = New Structure;
	Settings.Insert("FiscalPrinter", CommonFunctionsServer.GetRefAttribute(DocConsolidatedRetailSales, "FiscalPrinter"));
	Settings.Insert("Author", SessionParametersServer.GetSessionParameter("CurrentUser"));
	EquipmentResult = Await EquipmentFiscalPrinterClient.PrintXReport(Settings);
	If Not EquipmentResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentResult.Info.Error);
	EndIf;
EndProcedure
