// @strict-types

// Command processing.
// 
// Parameters:
//  CommandParameter - Array of CatalogRef.ExternalFunctions - Command parameter
//  CommandExecuteParameters - CommandExecuteParameters - Command execute parameters
&AtClient
Async Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	If Await DoQueryBoxAsync(R().InfoMessage_032, QuestionDialogMode.YesNo) = DialogReturnCode.No Then
		Return;
	EndIf;
	
	For Each ExtFunction In CommandParameter Do
		ServiceSystemServer.ContinueOrPauseShedulerJob(ExtFunction, True);
	EndDo;
	
	CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
EndProcedure
