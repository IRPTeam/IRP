Function ConnectionSetting(IntegrationSettingName, AddInfo = Undefined) Export
	Result = New Structure("Success, Value, Message", False, Undefined, "");
	
	IntegrationSettings = IntegrationServerReuse.GetIntegrationSettings(IntegrationSettingName);
	
	If Not ValueIsFilled(IntegrationSettings.Ref) Then
		Result.Success = False;
		Result.Message = StrTemplate(R()["S_005"], IntegrationSettingName);
		Return Result;
	EndIf;
	
	ConnectionSetting = IntegrationServer.ConnectionSettingTemplate(IntegrationSettings.IntegrationType, AddInfo);
	
	// Customize setting with according IntegrationSettings catalog
	FillPropertyValues(ConnectionSetting, IntegrationSettings.CustomizedSetting);
	
	ConnectionSetting.Insert("IntegrationSettingsRef", IntegrationSettings.Ref);
	ConnectionSetting.Insert("IntegrationType", IntegrationSettings.IntegrationType);
	Result.Success = True;
	Result.Value = ConnectionSetting;
	Return Result;
EndFunction

Function ConnectionSettingTemplate(IntegrationType = Undefined, AddInfo = Undefined) Export
	Return  IntegrationServerReuse.ConnectionSettingTemplate(IntegrationType, AddInfo);
EndFunction

Function InfoRegSettingsStructure() Export
	Return IntegrationServerReuse.InfoRegSettingsStructure()
EndFunction

Procedure SaveFileToFileStorage(PathForSave, FileName, BinaryData) Export
    BinaryData.Write(PathForSave + ?(StrEndsWith(PathForSave, "\"), "", "\") + FileName);
EndProcedure

Procedure SaveSettingsInInfoReg(SettingsTab) Export

    For Each Row In SettingsTab Do
        Reg = InformationRegisters.IntegrationInfo.CreateRecordSet();
        Reg.Filter.IntegrationSettings.Set(Row.IntegrationSettings);
        Reg.Filter.Key.Set(Row.Key);
        
        If NOT ValueIsFilled(Row.Value) AND Row.SecondValue = Undefined Then
            Reg.Write();
            Continue;
        EndIf;
        
        FillPropertyValues(Reg.Add(), Row);
        Reg.Write();
        
    EndDo;
    
EndProcedure