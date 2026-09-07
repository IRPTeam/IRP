
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(AdvanceVendor);
	ChoiceData.Add(TransactionVendor);
	ChoiceData.Add(AdvanceCustomer);
	ChoiceData.Add(TransactionCustomer);
	ChoiceData.Add(OtherPartnerReceivable);
	ChoiceData.Add(EmployeeReceivable);
EndProcedure
