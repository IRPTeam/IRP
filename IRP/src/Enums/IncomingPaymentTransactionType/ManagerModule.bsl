
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(PaymentFromCustomer);
	ChoiceData.Add(CurrencyExchange);
	ChoiceData.Add(CashTransferOrder);
	ChoiceData.Add(TransferFromPOS);
	ChoiceData.Add(ReturnFromVendor);
	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.BankReceipt") Then
		ChoiceData.Add(PaymentFromCustomerByPOS);
		ChoiceData.Add(ReceiptByCheque);
	Else
		If FOServer.IsUseConsolidatedRetailSales() Then
			ChoiceData.Add(CashIn);
		EndIf;	
	EndIf;
EndProcedure
