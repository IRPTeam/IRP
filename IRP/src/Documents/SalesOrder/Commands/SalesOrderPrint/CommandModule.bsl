
// Print command handler.
//
// Parameters:
//	CommandParameter - Arbitrary - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "SalesOrderPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , ,"UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param)
	EndDo;

EndProcedure


&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction



// Sales order print server.
// 
// Parameters:
//  Ref - DocumentRef.SalesOrder
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales order print server
&AtServer
Function SalesOrderPrintServer(Ref, Param)
	Spreadsheet = Documents.SalesOrder.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
