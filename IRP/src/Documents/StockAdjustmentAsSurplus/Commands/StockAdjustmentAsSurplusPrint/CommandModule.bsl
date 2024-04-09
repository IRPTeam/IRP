
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.StockAdjustmentAsSurplus - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "StockAdjustmentAsSurplusPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Stock adjustment as surplus print server.
// 
// Parameters:
//  Ref - DocumentRef.StockAdjustmentAsSurplus
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Stock adjustment as surplus print server
&AtServer
Function StockAdjustmentAsSurplusPrintServer(Ref, Param)
	Spreadsheet = Documents.StockAdjustmentAsSurplus.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
