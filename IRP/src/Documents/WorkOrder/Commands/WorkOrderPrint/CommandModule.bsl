
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.WorkOrder - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "WorkOrderPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Work order print server.
// 
// Parameters:
//  Ref - DocumentRef.WorkOrder
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Work order print server
&AtServer
Function WorkOrderPrintServer(Ref, Param)
	Spreadsheet = Documents.WorkOrder.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
