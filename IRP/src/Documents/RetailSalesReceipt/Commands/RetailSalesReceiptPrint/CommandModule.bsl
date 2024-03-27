
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.RetailSalesReceipt - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "RetailSalesReceiptPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Retail sales receipt print server.
// 
// Parameters:
//  Ref - DocumentRef.RetailSalesReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales order print server
&AtServer
Function RetailSalesReceiptPrintServer(Ref, Param)
	Spreadsheet = Documents.RetailSalesReceipt.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
