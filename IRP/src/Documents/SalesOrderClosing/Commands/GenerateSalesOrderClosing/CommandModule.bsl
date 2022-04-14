&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	//Param = New Structure();
	//CSO = DocSalesOrderClosingServer.GetLastSalesOrderClosingBySalesOrder(CommandParameter);
	SalesOrderClosingRef = DocSalesOrderClosingServer.GetLastSalesOrderClosingBySalesOrder(CommandParameter);
	If ValueIsFilled(SalesOrderClosingRef) Then
		OpenForm("Document.SalesOrderClosing.ObjectForm", New Structure("Key", SalesOrderClosingRef), , New UUID());
	Else
		FillingValues = DocSalesOrderClosingServer.GetSalesOrderForClosing(CommandParameter);
		OpenForm("Document.SalesOrderClosing.ObjectForm", New Structure("FillingValues", FillingValues), , New UUID());
	EndIf;
	
//	If Not CSO.IsEmpty() Then
//		Param.Insert("Key", CSO);
//	Else
//		Param.Insert("FillingValues", New Structure("SalesOrder", CommandParameter));
//	EndIf;
//
//	OpenForm("Document.SalesOrderClosing.ObjectForm", Param, , New UUID());
EndProcedure