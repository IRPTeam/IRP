// @strict-types

// Command processing.
//
// Parameters:
//  CommandParameter - DocumentRef.CashPayment -  Command parameter
//  CommandExecuteParameters - CommandExecuteParameters -  Command execute parameters
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PrintCashOut(CommandParameter);
EndProcedure

// Print cash out.
//
// Parameters:
//  CommandParameter - DocumentRef.CashPayment - Command parameter
&AtClient
Async Procedure PrintCashOut(CommandParameter)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CommandParameter, "ConsolidatedRetailSales"); // DocumentRef.ConsolidatedRetailSales
	If Not ConsolidatedRetailSales.IsEmpty() Then
		//@skip-check module-unused-local-variable
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashOutCome(ConsolidatedRetailSales
				, CommandParameter
				, GetSumm(CommandParameter));// See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings

		If Not EquipmentResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(EquipmentResult.Info.Error);
		EndIf;
	EndIf;
EndProcedure

// Get summ.
//
// Parameters:
//  CommandParameter - DocumentRef.CashPayment, Arbitrary -  Command parameter
//
// Returns:
//  Number -  Get summ
&AtServer
Function GetSumm(CommandParameter)
	Return CommandParameter.PaymentList.Total("TotalAmount"); // Number
EndFunction
