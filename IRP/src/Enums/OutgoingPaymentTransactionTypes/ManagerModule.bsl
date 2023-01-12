
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If Parameters.Filter.Property("Ref") Then
		StandardProcessing = False;
		ChoiceData = New ValueList();
		
		IsBankPayment = TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.BankPayment");
		IsCashPayment = TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.CashPayment");
		IsOutgoingPaymentOrder = TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.OutgoingPaymentOrder");
	EndIf;
	
	If IsBankPayment Or IsCashPayment Then
		ChoiceData.Add(PaymentToVendor);
		ChoiceData.Add(ReturnToCustomer);
		ChoiceData.Add(EmployeeCashAdvance);
			
		If FOServer.IsUseCashTransaction() Then
			ChoiceData.Add(CurrencyExchange);
			ChoiceData.Add(CashTransferOrder);
		EndIf;
	EndIf;	
		
	If IsBankPayment Then
		ChoiceData.Add(ReturnToCustomerByPOS);
		ChoiceData.Add(PaymentByCheque);
	EndIf;
			
	If IsOutgoingPaymentOrder Then
		ChoiceData.Add(PaymentToVendor);
		ChoiceData.Add(EmployeeCashAdvance);			
	EndIf;
EndProcedure
