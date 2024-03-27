
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.GoodsReceipt - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "GoodsReceiptPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Goods receipt print server.
// 
// Parameters:
//  Ref - DocumentRef.GoodsReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Goods receipt print server
&AtServer
Function GoodsReceiptPrintServer(Ref, Param)
	Spreadsheet = Documents.GoodsReceipt.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
