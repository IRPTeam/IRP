
// Print command handler.
//
// Parameters:
//	CommandParameter - Arbitrary - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each It In CommandParameter Do
		Spreadsheet = New SpreadsheetDocument;	
		SalesOrderPrint(Spreadsheet, It);
		Param = InitPrintParam(It);
		Param.RefDocument = It;
		Param.SpreadsheetDoc = Spreadsheet; 
		Param.NameTemplate = "SalesOrderPrint";
		OpenForm("CommonForm.PrintForm", , ,"UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param)
	EndDo;

EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction



// Print command handler on the server.
//
// Parameters:
//	Spreadsheet - SpreadsheetDocument - spreadsheet document to fill out and print.
//	CommandParameter - Arbitrary - contains a reference to the object for which the print command was executed.
&AtServer
Procedure SalesOrderPrint(Spreadsheet, CommandParameter)
	Spreadsheet = Documents.SalesOrder.SalesOrderPrint(CommandParameter);
EndProcedure
