
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(Enums.SalesTransactionTypes.Sales);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(Enums.SalesTransactionTypes.ShipmentToTradeAgent);
	EndIf;
	
	If FOServer.IsUseRetailOrders() Then
		If Parameters.Filter.Property("Ref") And 
			(TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.SalesOrder") 
			Or TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.SalesOrderClosing"))Then
			ChoiceData.Add(Enums.SalesTransactionTypes.RetailSales);
		EndIf;
	EndIf;
EndProcedure
