

Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(InventoryTransfer);
	ChoiceData.Add(Sales);
	ChoiceData.Add(ReturnToVendor);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(ShipmentToTradeAgent);
		ChoiceData.Add(ReturnToConsignor);
	EndIf;	
EndProcedure
