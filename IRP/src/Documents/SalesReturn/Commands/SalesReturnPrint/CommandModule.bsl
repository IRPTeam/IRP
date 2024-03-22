
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.SalesReturn - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "SalesReturnPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Sales return print server.
// 
// Parameters:
//  Ref - DocumentRef.SalesReturn
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales return print server
&AtServer
Function SalesReturnPrintServer(Ref, Param)
	Spreadsheet = Documents.SalesReturn.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
