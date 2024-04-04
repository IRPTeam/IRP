
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.SalesInvoice - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "SalesOrderClosingPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Sales invoice print server.
// 
// Parameters:
//  Ref - DocumentRef.SalesInvoice
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales invoice print server
&AtServer
Function SalesOrderPrintServer(Ref, Param)
	Spreadsheet = Documents.SalesInvoice.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
