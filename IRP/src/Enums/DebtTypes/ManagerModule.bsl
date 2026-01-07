
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(AdvanceVendor);
	ChoiceData.Add(TransactionVendor);
	ChoiceData.Add(AdvanceCustomer);
	ChoiceData.Add(TransactionCustomer);
	ChoiceData.Add(OtherPartnerPayable);
	ChoiceData.Add(OtherPartnerReceivable);
	ChoiceData.Add(EmployeeReceivable);
	ChoiceData.Add(EmployeePayable);
EndProcedure
