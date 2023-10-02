// @strict-types

// Command processing.
//
// Parameters:
//  CommandParameter - DocumentRef.MoneyTransfer -  Command parameter
//  CommandExecuteParameters - CommandExecuteParameters -  Command execute parameters
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashOut(CommandParameter);
EndProcedure

// Print cash out.
//
// Parameters:
//  CommandParameter - DocumentRef.MoneyTransfer -  Command parameter
&AtClient
Async Procedure PrintCashOut(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales"); // DocumentRef.ConsolidatedRetailSales
	If Not ConsolidatedRetailSales.IsEmpty() Then
		SendAmount = CommonFunctionsServer.GetRefAttribute(CommandParameter, "SendAmount"); // Number
		//@skip-check module-unused-local-variable
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashOutCome(ConsolidatedRetailSales
				, CommandParameter
				, SendAmount); // See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings

		If Not EquipmentResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(EquipmentResult.Info.Error);
		EndIf;
	EndIf;
EndProcedure
