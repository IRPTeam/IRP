
Function GetSettings() Export

	Settings = New Structure;
	
	Settings.Insert("Filter_LedgerType", True);
	Settings.Insert("Filter_DocumentType", True);
	Settings.Insert("Filter_LockType", True);
	Settings.Insert("Filter_FilesType", True);
	Settings.Insert("Filter_TasksType", True);
	
	Settings.Insert("Panel_GroupReport", True);
	Settings.Insert("Panel_GroupFiles", True);
	Settings.Insert("Panel_GroupChat", True);
	Settings.Insert("Panel_GroupHistory", True);
	
	RestoreSettings = CommonSettingsStorage.Load("AccountantAutomatedWorkplace", "Settings"); // Structure
	If TypeOf(RestoreSettings) = Type("Structure") Then
		FillPropertyValues(Settings, RestoreSettings);
	EndIf;	
	
	Return Settings;

EndFunction // GetSettings()

Procedure SaveSettings(Settings) Export

	CommonSettingsStorage.Save("AccountantAutomatedWorkplace", "Settings", Settings);

EndProcedure // SaveSettings()
