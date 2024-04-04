
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.ItemStockAdjustment - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "ItemStockAdjustmentPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Item stock adjustment print server.
// 
// Parameters:
//  Ref - DocumentRef.ItemStockAdjustment
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Item stock adjustment print server
&AtServer
Function ItemStockAdjustmentPrintServer(Ref, Param)
	Spreadsheet = Documents.ItemStockAdjustment.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
