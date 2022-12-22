
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(InventoryTransfer);
	ChoiceData.Add(Purchase);
	ChoiceData.Add(ReturnFromCustomer);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(ReceiptFromConsignor);
		ChoiceData.Add(ReturnFromTradeAgent);
	EndIf;	
EndProcedure
