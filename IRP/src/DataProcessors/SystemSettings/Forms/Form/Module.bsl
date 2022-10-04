
// @strict-types

&AtClient
Procedure RunBackgroundJobInDebugModeOnChange(Item)
	RunBackgroundJobInDebugModeOnChangeAtServer();
EndProcedure

&AtServer
Procedure RunBackgroundJobInDebugModeOnChangeAtServer()
	SessionParameters.RunBackgroundJobInDebugMode = RunBackgroundJobInDebugMode;
EndProcedure


&AtClient
Procedure IgnoreLockModificationDataOnChange(Item)
	IgnoreLockModificationDataOnChangeAtServer();
EndProcedure

&AtServer
Procedure IgnoreLockModificationDataOnChangeAtServer()
	SessionParameters.IgnoreLockModificationData = IgnoreLockModificationData;
EndProcedure