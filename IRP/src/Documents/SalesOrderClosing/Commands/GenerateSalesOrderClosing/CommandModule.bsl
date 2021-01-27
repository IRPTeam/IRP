
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Param = New Structure();
	Param.Insert("Key", DocSalesOrderServer.GetLastSalesOrderClosingBySalesOrder(CommandParameter));
	Param.Insert("SalesOrder", CommandParameter);
	OpenForm("Document.SalesOrderClosing.ObjectForm", Param)
EndProcedure
