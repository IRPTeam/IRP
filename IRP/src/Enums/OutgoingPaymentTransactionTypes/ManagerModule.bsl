
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If Not FOServer.IsUseCashTransaction() Then	
		StandardProcessing = False;
		ChoiceData = New ValueList();
		ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.PaymentToVendor);
		ChoiceData.Add(Enums.OutgoingPaymentTransactionTypes.ReturnToCustomer);
	EndIf;
EndProcedure
