
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)	
	StandardProcessing = False;
	
	IsSalesInvoice = False;
	
	If Parameters.Filter.Property("Ref") Then
		DocType = TypeOf(Parameters.Filter.Ref);
		IsSalesInvoice = (DocType = Type("DocumentRef.SalesInvoice"));
	EndIf;
	
	ChoiceData = New ValueList();
	ChoiceData.Add(Sales);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(ShipmentToTradeAgent);
	EndIf;
	
	If FOServer.IsUseRetailOrders() Then
			ChoiceData.Add(RetailSales);
	EndIf;
	
	If IsSalesInvoice Then
		ChoiceData.Add(CurrencyRevaluationCustomer);
		ChoiceData.Add(CurrencyRevaluationVendor);
	EndIf;
EndProcedure
