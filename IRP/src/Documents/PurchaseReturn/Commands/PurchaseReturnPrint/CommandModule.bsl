
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.PurchaseReturn - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "PurchaseReturnPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Purchase return print server.
// 
// Parameters:
//  Ref - DocumentRef.PurchaseReturn
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Purchase return print server
&AtServer
Function PurchaseReturnPrintServer(Ref, Param)
	Spreadsheet = Documents.PurchaseReturn.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
