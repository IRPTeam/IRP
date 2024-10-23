
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	
	IsPurchaseInvoice = False;
	
	If Parameters.Filter.Property("Ref") Then
		DocType = TypeOf(Parameters.Filter.Ref);
		IsPurchaseInvoice = (DocType = Type("DocumentRef.PurchaseInvoice"));
	EndIf;
	
	ChoiceData = New ValueList();
	ChoiceData.Add(Purchase);
	ChoiceData.Add(ReceiptFromConsignor);
		
	If IsPurchaseInvoice Then
		ChoiceData.Add(CurrencyRevaluationCustomer);
		ChoiceData.Add(CurrencyRevaluationVendor);
	EndIf;
EndProcedure
