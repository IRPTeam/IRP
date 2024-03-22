
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.RetailGoodsReceipt - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "RetailGoodsReceiptPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Retail goods receipt print server.
// 
// Parameters:
//  Ref - DocumentRef.RetailGoodsReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Retail goods receipt print server
&AtServer
Function RetailGoodsReceiptPrintServer(Ref, Param)
	Spreadsheet = Documents.RetailGoodsReceipt.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
