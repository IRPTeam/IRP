
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	RunBackgroundJobInDebugMode = SessionParametersServer.GetSessionParameter("RunBackgroundJobInDebugMode");
	IgnoreLockModificationData = SessionParametersServer.GetSessionParameter("IgnoreLockModificationData");
	
	Items.InfoBaseTimeZone.ChoiceList.Clear();
	For Each Zone In GetAvailableTimeZones() Do
		Items.InfoBaseTimeZone.ChoiceList.Add(Zone);
	EndDo;
	InfoBaseTimeZone = GetInfoBaseTimeZone();
	
	Items.SessionTimeZone.ChoiceList.Clear();
	For Each Zone In GetAvailableTimeZones() Do
		Items.SessionTimeZone.ChoiceList.Add(Zone);
	EndDo;
	SessionTimeZone = SessionTimeZone();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	UpdateTimeInfo();
EndProcedure

&AtClient
Procedure SessionTimeZoneOnChange(Item)
	SessionTimeZoneOnChangeAtServer();
EndProcedure

&AtServer
Procedure SessionTimeZoneOnChangeAtServer()
	If SessionTimeZone <> SessionTimeZone()Then 
		Try 
			SetSessionTimeZone(SessionTimeZone);
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_035, SessionTimeZone));
		Except 
			Raise ;
		EndTry;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_034);
	EndIf;
EndProcedure

&AtClient
Procedure InfoBaseTimeZoneOnChange(Item)
	InfoBaseTimeZoneOnChangeAtServer();
EndProcedure

&AtServer
Procedure InfoBaseTimeZoneOnChangeAtServer()
	If InfoBaseTimeZone <> GetInfoBaseTimeZone() Then 
		SetPrivilegedMode(True);
		Try 
			SetExclusiveMode(True);
			SetInfoBaseTimeZone(InfoBaseTimeZone);
			SetExclusiveMode(False);
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_035, InfoBaseTimeZone));
		Except 
			SetExclusiveMode(False);
			Raise ;
		EndTry;
		SetPrivilegedMode(False);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_034);
	EndIf;
EndProcedure

&AtClient
Procedure UpdateTimeInfo()
	UpdateTimeInfoAtServer();
	CurrentUserPCTime = CurrentDate();
EndProcedure

&AtServer
Procedure UpdateTimeInfoAtServer()
	CurrentDatabaseTimeZone = GetInfoBaseTimeZone();
	CurrentSessionTimeZone = SessionTimeZone();
	CurrentDatabaseTime = CurrentDate();
	CurrentSessionTime = CommonFunctionsServer.GetCurrentSessionDate();
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
