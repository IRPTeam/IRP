
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.StockAdjustmentAsWriteOff - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "StockAdjustmentAsWriteOffPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Sales order print server.
// 
// Parameters:
//  Ref - DocumentRef.StockAdjustmentAsWriteOff
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Stock Adjustment As Write Off server
&AtServer
Function StockAdjustmentAsWriteOffPrintServer(Ref, Param)
	Spreadsheet = Documents.StockAdjustmentAsWriteOff.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
