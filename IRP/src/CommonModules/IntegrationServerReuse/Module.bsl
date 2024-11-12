Function GetIntegrationSettings(IntegrationSettingName, AddInfo = Undefined) Export

	If TypeOf(IntegrationSettingName) = Type("String") Then
		IntegrationSettingsRef = UniqueID.UniqueIDByName(Metadata.Catalogs.IntegrationSettings, IntegrationSettingName);
	ElsIf TypeOf(IntegrationSettingName) = Type("CatalogRef.IntegrationSettings") Then
		IntegrationSettingsRef = IntegrationSettingName;
	Else
		Raise R().Error_004; 
	EndIf;

	CustomizedSetting = New Structure();
	SettingsSource = IntegrationSettingsRef.ConnectionSetting;
	If Not ServiceSystemServer.isProduction() Then
		SettingsSource = IntegrationSettingsRef.ConnectionSettingTest;
	EndIf; 		  
	For Each Str In SettingsSource Do
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

Function ConnectionSettingTemplate(IntegrationType = Undefined, Object = Undefined) Export
	ConnectionSetting = New Structure();
	ConnectionSetting.Insert("IntegrationSettingsRef", Catalogs.IntegrationSettings.EmptyRef());
	If IntegrationType = Enums.IntegrationType.LocalFileStorage Then
		ConnectionSetting.Insert("AddressPath", "");
	ElsIf IntegrationType = Enums.IntegrationType.Email Then
		ConnectionSetting.Insert("SMTPServerAddress", "smtp.gmail.com");
		ConnectionSetting.Insert("SMTPPort", 465);
		ConnectionSetting.Insert("SMTPUser", "");
		ConnectionSetting.Insert("SMTPPassword", "");
		ConnectionSetting.Insert("SMTPUseSSL", True);
		ConnectionSetting.Insert("POP3BeforeSMTP", False);
		ConnectionSetting.Insert("TimeOut", 60);
		ConnectionSetting.Insert("eMailForTest", "email@test.com");
		ConnectionSetting.Insert("SenderName", "IRP Team");
		ConnectionSetting.Insert("FromAddress", "noreply@irpteam.com");
		ConnectionSetting.Insert("DisplayName", "IRP NO REPLY");
	ElsIf IntegrationType = Enums.IntegrationType.SMSProvider Then
		ConnectionSetting.Insert("TextOnApproveAction", "");
		ConnectionSetting.Insert("TextOnRegistration", "");
		ConnectionSetting.Insert("SenderName", "");
		ConnectionSetting.Insert("PhoneNumberForTest", "");
		ConnectionSetting.Insert("ApiKey", "");
		ConnectionSetting.Insert("QueryType", "POST");
		ConnectionSetting.Insert("ResourceAddress", "");
		ConnectionSetting.Insert("Ip", "localhost");
		ConnectionSetting.Insert("Port", 443);
		ConnectionSetting.Insert("User", "");
		ConnectionSetting.Insert("Password", "");
		ConnectionSetting.Insert("Proxy", Undefined);
		ConnectionSetting.Insert("TimeOut", 60);
		ConnectionSetting.Insert("SecureConnection", True);
		ConnectionSetting.Insert("UseOSAuthentication", False);
	ElsIf Not ExtensionCall_ConnectionSettingTemplate(IntegrationType, ConnectionSetting, Object) Then
		ConnectionSetting.Insert("QueryType", "POST");
		ConnectionSetting.Insert("ResourceAddress", "");
		ConnectionSetting.Insert("Ip", "localhost");
		ConnectionSetting.Insert("Port", 443);
		ConnectionSetting.Insert("User", "");
		ConnectionSetting.Insert("Password", "");
		ConnectionSetting.Insert("Proxy", Undefined);
		ConnectionSetting.Insert("TimeOut", 60);
		ConnectionSetting.Insert("SecureConnection", True);
		ConnectionSetting.Insert("UseOSAuthentication", False);
	EndIf;
	Return ConnectionSetting;
EndFunction

Function ExtensionCall_ConnectionSettingTemplate(IntegrationType, ConnectionSetting, Object = Undefined)
	Return False;
EndFunction

Function InfoRegSettingsStructure() Export
	Query = New Query();
	Query.Text =
	"SELECT TOP 1
	|	*
	|FROM
	|	InformationRegister.IntegrationInfo AS IntegrationInfo
	|WHERE
	|	FALSE";

	Return Query.Execute().Unload();

EndFunction