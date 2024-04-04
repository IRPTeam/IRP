
// Print command handler.
//
// Parameters:
//	CommandParameter - Array of DocumentRef.ModernizationOfFixedAsset - contains a reference to the object for which the print command was executed.
//	CommandExecuteParameters - CommandExecuteParameters - command execute parameters.
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	For Each ItRef In CommandParameter Do
		Param = InitPrintParam(ItRef);
		Param.NameTemplate = "ModernizationOfFixedAssetPrint";
		Param.BuilderLayout = True;

		OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
		Notify("AddTemplatePrintForm", Param);
	EndDo;
EndProcedure

&AtServer
Function InitPrintParam(It)
	Return UniversalPrintServer.InitPrintParam(It);
EndFunction

// Modernization of fixed asset server.
// 
// Parameters:
//  Ref - DocumentRef.ModernizationOfFixedAsset
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Modernization of fixed asset server
&AtServer
Function ModernizationOfFixedAssetPrintServer(Ref, Param)
	Spreadsheet = Documents.ModernizationOfFixedAsset.Print(Ref, Param);
	Return Spreadsheet;
EndFunction
