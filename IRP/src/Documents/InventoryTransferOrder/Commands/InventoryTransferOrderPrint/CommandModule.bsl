
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.InventoryTransferOrder - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "InventoryTransferOrderPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Inventory transfer order print server.
// 
// Parameters:
//  Ref - DocumentRef.InventoryTransferOrder
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Inventory transfer order print server
&AtServer
Function InventoryTransferOrderPrintServer(Ref, Param)
	Spreadsheet = Documents.InventoryTransferOrder.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
