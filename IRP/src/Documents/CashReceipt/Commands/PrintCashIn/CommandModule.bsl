
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashIn(CommandParameter);
	//TODO: Paste handler content.
	//FormParameters = New Structure("", );
	//OpenForm("Document.Document.ListForm", FormParameters, CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure

&AtClient
Async Procedure PrintCashIn(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales"); // DocumentRef.ConsolidatedRetailSales
	If Not ConsolidatedRetailSales.IsEmpty() Then
		//@skip-check module-unused-local-variable
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashInCome(ConsolidatedRetailSales
				, CommandParameter
				, GetSumm(CommandParameter)); // See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings

		If Not EquipmentResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(EquipmentResult.Info.Error);
		EndIf;
	EndIf;
EndProcedure

&AtServer
Function GetSumm(CommandParameter)
	Return CommandParameter.PaymentList.Total("TotalAmount");
EndFunction
