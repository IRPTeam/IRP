
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.CommissioningOfFixedAsset - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "CommissioningOfFixedAssetPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Commissioning of fixed asset print server.
// 
// Parameters:
//  Ref - DocumentRef.CommissioningOfFixedAsset
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Commissioning of fixed asset print server
&AtServer
Function CommissioningOfFixedAssetPrintServer(Ref, Param)
	Spreadsheet = Documents.CommissioningOfFixedAsset.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
