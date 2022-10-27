
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(Enums.GoodsReceiptTransactionTypes.InventoryTransfer);
	ChoiceData.Add(Enums.GoodsReceiptTransactionTypes.Purchase);
	ChoiceData.Add(Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(Enums.GoodsReceiptTransactionTypes.ReceiptFromConsignor);
		ChoiceData.Add(Enums.GoodsReceiptTransactionTypes.ReturnFromTradeAgent);
	EndIf;	
EndProcedure
