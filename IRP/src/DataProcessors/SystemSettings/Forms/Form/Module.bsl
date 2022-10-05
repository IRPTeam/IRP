
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	RunBackgroundJobInDebugMode = SessionParametersServer.GetSessionParameter("RunBackgroundJobInDebugMode");
	IgnoreLockModificationData = SessionParametersServer.GetSessionParameter("IgnoreLockModificationData");
EndProcedure

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
