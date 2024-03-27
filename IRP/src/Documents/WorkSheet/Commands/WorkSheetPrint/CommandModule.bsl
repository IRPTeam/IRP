
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.WorkSheet - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "WorkSheetPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Work sheet print server.
// 
// Parameters:
//  Ref - DocumentRef.WorkSheet
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Work sheet print server
&AtServer
Function WorkSheetPrintServer(Ref, Param)
	Spreadsheet = Documents.WorkSheet.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
