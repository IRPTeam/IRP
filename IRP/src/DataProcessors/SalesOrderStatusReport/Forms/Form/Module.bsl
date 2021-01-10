
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
	StrParams.Insert("EndOfTheDate", EndOfTheDate);
	Report = DataProcessors.SalesOrderStatusReport.GenerateReport(StrParams);
EndProcedure
