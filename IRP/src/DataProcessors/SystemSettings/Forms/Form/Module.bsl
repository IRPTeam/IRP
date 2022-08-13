
// @strict-types

&AtClient
Procedure RunBackgroundJobInDebugModeOnChange(Item)
	RunBackgroundJobInDebugModeOnChangeAtServer();
EndProcedure

&AtServer
Procedure RunBackgroundJobInDebugModeOnChangeAtServer()
	SessionParameters.RunBackgroundJobInDebugMode = RunBackgroundJobInDebugMode;
EndProcedure
