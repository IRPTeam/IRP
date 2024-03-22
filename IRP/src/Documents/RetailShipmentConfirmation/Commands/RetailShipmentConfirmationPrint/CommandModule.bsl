
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.RetailShipmentConfirmation - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "RetailShipmentConfirmationPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Retail shipment confirmation print server.
// 
// Parameters:
//  Ref - DocumentRef.RetailShipmentConfirmation
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Retail shipment confirmation print server
&AtServer
Function RetailShipmentConfirmationPrintServer(Ref, Param)
	Spreadsheet = Documents.RetailShipmentConfirmation.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
