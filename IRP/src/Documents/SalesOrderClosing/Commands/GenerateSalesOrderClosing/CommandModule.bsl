&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Param = New Structure();
	CSO = DocSalesOrderServer.GetLastSalesOrderClosingBySalesOrder(CommandParameter);
	If Not CSO.IsEmpty() Then
		Param.Insert("Key", CSO);
	Else
		Param.Insert("FillingValues", New Structure("SalesOrder", CommandParameter));
	EndIf;

	OpenForm("Document.SalesOrderClosing.ObjectForm", Param, , New UUID());
EndProcedure