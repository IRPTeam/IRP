&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	SalesOrderClosingRef = DocOrderClosingServer.GetClosingBySalesOrder(CommandParameter);
	If ValueIsFilled(SalesOrderClosingRef) Then
		OpenForm("Document.SalesOrderClosing.ObjectForm", New Structure("Key", SalesOrderClosingRef), , New UUID());
	Else
		FillingValues = DocOrderClosingServer.GetDataFromSalesOrder(CommandParameter);
		OpenForm("Document.SalesOrderClosing.ObjectForm", New Structure("FillingValues", FillingValues), , New UUID());
	EndIf;
EndProcedure