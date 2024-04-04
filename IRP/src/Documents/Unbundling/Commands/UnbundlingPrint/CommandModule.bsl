
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.SalesInvoice - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "UnbundlingPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Unbundling print server.
// 
// Parameters:
//  Ref - DocumentRef.Unbundling
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Unbundling print server
&AtServer
Function UnbundlingPrintServer(Ref, Param)
	Spreadsheet = Documents.Unbundling.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
