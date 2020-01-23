Function ConnectionSetting(IntegrationSettingName, AddInfo = Undefined) Export
	Result = New Structure("Success, Value, Message", False, Undefined, "");
	
	IntegrationSettingsRef = UniqueID.UniqueIDByName(Metadata.Catalogs.IntegrationSettings, IntegrationSettingName);
	
	If Not ValueIsFilled(IntegrationSettingsRef) Then
		Result.Success = False;
		Result.Message = StrTemplate(R()["S_005"], IntegrationSettingName);
		Return Result;
	EndIf;
	
	ConnectionSetting = ConnectionSettingTemplate(IntegrationSettingsRef.IntegrationType, AddInfo);
	
	// Customize setting with according IntegrationSettings catalog
	CustomizedSetting = New Structure();
	For Each Str In IntegrationSettingsRef.ConnectionSetting Do
		If ValueIsFilled(Str.Value) Then
			CustomizedSetting.Insert(Str.Key, Str.Value);
		EndIf;
	EndDo;
	FillPropertyValues(ConnectionSetting, CustomizedSetting);
	
	ConnectionSetting.Insert("IntegrationSettingsRef", IntegrationSettingsRef);
	ConnectionSetting.Insert("IntegrationType", IntegrationSettingsRef.IntegrationType);
	Result.Success = True;
	Result.Value = ConnectionSetting;
	Return Result;
EndFunction

Function ConnectionSettingTemplate(IntegrationType = Undefined, AddInfo = Undefined) Export
	ConnectionSetting = New Structure();
	If IntegrationType = Enums.IntegrationType.LocalFileStorage Then
		ConnectionSetting.Insert("AddressPath", "");
	Else
		ConnectionSetting.Insert("QueryType", "POST");
		ConnectionSetting.Insert("ResourceAddress", "");
		ConnectionSetting.Insert("Ip", "localhost");
		ConnectionSetting.Insert("Port", 8080);
		ConnectionSetting.Insert("User", "");
		ConnectionSetting.Insert("Password", "");
		ConnectionSetting.Insert("Proxy", Undefined);
		ConnectionSetting.Insert("TimeOut", 60);
		ConnectionSetting.Insert("SecureConnection", Undefined);
		ConnectionSetting.Insert("UseOSAuthentication", False);
		ConnectionSetting.Insert("Headers", New Map());
	EndIf;
	Return ConnectionSetting;
EndFunction

Function InfoRegSettingsStructure() Export
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	*
		|FROM
		|	InformationRegister.IntegrationInfo AS IntegrationInfo
		|WHERE
		|	FALSE";
	
	Return Query.Execute().Unload();
	
EndFunction
