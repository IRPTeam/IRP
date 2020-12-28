
&AtClient
Procedure GenerateReport(Command)
	GenerateReportAtServer();
EndProcedure

&AtServer
Procedure GenerateReportAtServer()
	SalesOrdersArray = New Array;
	SalesOrdersArray.Add(SalesOrder);
	StrParams = New Structure;
	StrParams.Insert("SalesOrders", SalesOrdersArray);
	Report = DataProcessors.SalesOrderStatusReport.GenerateReport(StrParams);
EndProcedure
