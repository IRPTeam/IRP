
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.Bundling - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "BundlingPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Bundling print server.
// 
// Parameters:
//  Ref - DocumentRef.Bundling
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Bundling print server
&AtServer
Function BundlingPrintServer(Ref, Param)
	Spreadsheet = Documents.Bundling.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
