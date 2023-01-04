
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(Enums.SalesTransactionTypes.Sales);
	ChoiceData.Add(Enums.SalesTransactionTypes.ShipmentToTradeAgent);
	
	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.SalesOrder") Then
		ChoiceData.Add(Enums.SalesTransactionTypes.RetailSales);
	EndIf;
EndProcedure
