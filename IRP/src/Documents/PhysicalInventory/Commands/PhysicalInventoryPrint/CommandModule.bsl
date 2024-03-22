
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.PhysicalInventory - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "PhysicalInventoryPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Physical inventory print server.
// 
// Parameters:
//  Ref - DocumentRef.PhysicalInventory
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Physical inventory print server
&AtServer
Function PhysicalInventoryPrintServer(Ref, Param)
	Spreadsheet = Documents.PhysicalInventory.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
