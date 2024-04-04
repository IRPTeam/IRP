
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.DecommissioningOfFixedAsset - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "DecommissioningOfFixedAssetPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Decommissioning of fixed asset print server.
// 
// Parameters:
//  Ref - DocumentRef.DecommissioningOfFixedAsset
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Decommissioning of fixed asset print server
&AtServer
Function DecommissioningOfFixedAssetPrintServer(Ref, Param)
	Spreadsheet = Documents.DecommissioningOfFixedAsset.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
