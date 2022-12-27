
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();

	ChoiceData.Add(PaymentToVendor);
	ChoiceData.Add(ReturnToCustomer);

	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.BankPayment") Then
		ChoiceData.Add(ReturnToCustomerByPOS);
		ChoiceData.Add(PaymentByCheque);
	EndIf;

	If FOServer.IsUseCashTransaction() Then
		ChoiceData.Add(CurrencyExchange);
		ChoiceData.Add(CashTransferOrder);
	EndIf;
EndProcedure
