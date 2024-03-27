
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.ShipmentConfirmation - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "ShipmentConfirmationPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Shipment confirmation print server.
// 
// Parameters:
//  Ref - DocumentRef.ShipmentConfirmation
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Shipment confirmation print server
&AtServer
Function ShipmentConfirmationPrintServer(Ref, Param)
	Spreadsheet = Documents.ShipmentConfirmation.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
