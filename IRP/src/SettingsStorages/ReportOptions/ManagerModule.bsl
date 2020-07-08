

Procedure SaveProcessing(ObjectKey, SettingsKey, Settings, SettingsDescription, User)	
	Option = New ValueStorage(Settings, New Deflation(9));	
	ReportOptionRef = Catalogs.ReportOptions.FindByCode(SettingsKey);
	ReportOptionObj = ReportOptionRef.GetObject();
	ReportOptionObj.Option = Option;
	ReportOptionObj.Write();		
EndProcedure

Procedure LoadProcessing(ObjectKey, SettingsKey, Settings, SettingsDescription, User)
	ReportOption = Catalogs.ReportOptions.FindByCode(SettingsKey);
	Settings = ReportOption.Option;
	If SettingsDescription <> Undefined Then
		SettingsDescription.Presentation = ReportOption.Description;
	EndIf;
EndProcedure

