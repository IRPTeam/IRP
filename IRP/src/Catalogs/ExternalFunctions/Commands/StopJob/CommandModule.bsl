// @strict-types

// Command processing.
// 
// Parameters:
//  CommandParameter - Array of CatalogRef.ExternalFunctions - Command parameter
//  CommandExecuteParameters - CommandExecuteParameters - Command execute parameters
&AtClient
Async Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	If Await DoQueryBoxAsync(R().InfoMessage_033, QuestionDialogMode.YesNo) = DialogReturnCode.No Then
		Return;
	EndIf;
	
	For Each ExtFunction In CommandParameter Do
		ServiceSystemServer.StopSchedulerJob(ExtFunction);
	EndDo;
	
	CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
EndProcedure
