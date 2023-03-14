
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(Sales);
	
	If FOServer.IsUseCommissionTrading() Then
		ChoiceData.Add(ShipmentToTradeAgent);
	EndIf;
	
	If FOServer.IsUseRetailOrders() Then
		If Parameters.Filter.Property("Ref") And 
			(TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.SalesOrder") 
			Or TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.SalesOrderClosing"))Then
			ChoiceData.Add(RetailSales);
		EndIf;
	EndIf;
EndProcedure
