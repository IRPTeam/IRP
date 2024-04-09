
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.Production - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "ProductionPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Production print server.
// 
// Parameters:
//  Ref - DocumentRef.Production
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Production print server
&AtServer
Function ProductionPrintServer(Ref, Param)
	Spreadsheet = Documents.Production.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
