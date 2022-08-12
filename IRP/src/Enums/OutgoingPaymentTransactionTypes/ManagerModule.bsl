
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();

	ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.PaymentToVendor);
	ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer);

	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.BankPayment") Then
		ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.ReturnToCustomerByPOS);
		ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.PaymentByCheque);
	EndIf;

	If FOServer.IsUseCashTransaction() Then
		ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.CurrencyExchange);
		ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.CashTransferOrder);
	EndIf;
EndProcedure
