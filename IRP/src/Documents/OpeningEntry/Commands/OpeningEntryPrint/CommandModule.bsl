
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.OpeningEntry - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "OpeningEntryPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Opening entry print server.
// 
// Parameters:
//  Ref - DocumentRef.OpeningEntry
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Opening entry print server
&AtServer
Function OpeningEntryPrintServer(Ref, Param)
	Spreadsheet = Documents.OpeningEntry.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
