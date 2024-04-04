
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.InventoryTransfer - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "InventoryTransferPrint";
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
//  Ref - DocumentRef.InventoryTransfer
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Inventory transfer print server
&AtServer
Function InventoryTransferPrintServer(Ref, Param)
	Spreadsheet = Documents.InventoryTransfer.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
