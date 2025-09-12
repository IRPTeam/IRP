
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Filters = New Structure("TransactionType", PredefinedValue("Enum.SalesTransactionTypes.RetailSales"));
	OpenForm("Document.SalesOrder.ListForm", New Structure("Filter", Filters), , New UUID());
EndProcedure
