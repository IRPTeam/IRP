
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.RetailReturnReceipt - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "RetailReturnReceiptPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Retail return receipt print server.
// 
// Parameters:
//  Ref - DocumentRef.RetailReturnReceipt
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Retail return receipt print server
&AtServer
Function SalesOrderPrintServer(Ref, Param)
	Spreadsheet = Documents.RetailReturnReceipt.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
