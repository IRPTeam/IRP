
Function GetIntegrationSettingsRef(IntegrationSettingName, AddInfo = Undefined) Export
	IntegrationSettingsRef = UniqueID.UniqueIDByName(Metadata.Catalogs.IntegrationSettings, IntegrationSettingName);
	CustomizedSetting = New Structure();
	For Each Str In IntegrationSettingsRef.ConnectionSetting Do
		If ValueIsFilled(Str.Value) Then
			CustomizedSetting.Insert(Str.Key, Str.Value);
		EndIf;
	EndDo;
	Result = New Structure();
	Result.Insert("Ref", IntegrationSettingsRef);
	Result.Insert("IntegrationType", IntegrationSettingsRef.IntegrationType);
	Result.Insert("CustomizedSetting", CustomizedSetting);
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
