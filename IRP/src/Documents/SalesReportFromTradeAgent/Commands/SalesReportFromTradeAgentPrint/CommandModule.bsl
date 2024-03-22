
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.SalesReportFromTradeAgent - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "SalesReportFromTradeAgentPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Sales report from trade agent print server.
// 
// Parameters:
//  Ref - DocumentRef.SalesReportFromTradeAgent
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales report from trade agent print server
&AtServer
Function SalesReportFromTradeAgentPrintServer(Ref, Param)
	Spreadsheet = Documents.SalesReportFromTradeAgent.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
