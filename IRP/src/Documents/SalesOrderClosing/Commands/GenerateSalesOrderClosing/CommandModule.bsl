&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	SalesOrderClosingRef = DocSalesOrderClosingServer.GetLastSalesOrderClosingBySalesOrder(CommandParameter);
	If ValueIsFilled(SalesOrderClosingRef) Then
		OpenForm("Document.SalesOrderClosing.ObjectForm", New Structure("Key", SalesOrderClosingRef), , New UUID());
	Else
		FillingValues = DocSalesOrderClosingServer.GetSalesOrderForClosing(CommandParameter);
		OpenForm("Document.SalesOrderClosing.ObjectForm", New Structure("FillingValues", FillingValues), , New UUID());
	EndIf;
EndProcedure