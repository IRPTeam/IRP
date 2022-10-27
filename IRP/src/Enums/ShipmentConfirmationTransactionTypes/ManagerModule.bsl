

Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(Enums.ShipmentConfirmationTransactionTypes.InventoryTransfer);
	ChoiceData.Add(Enums.ShipmentConfirmationTransactionTypes.Sales);
	ChoiceData.Add(Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(Enums.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent);
		ChoiceData.Add(Enums.ShipmentConfirmationTransactionTypes.ReturnToConsignor);
	EndIf;	
EndProcedure
