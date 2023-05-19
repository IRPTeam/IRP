// Connection setting.
// 
// Parameters:
//  IntegrationSettingName - String - Integration setting name
//  AddInfo - Structure
// 
// Returns:
//  Structure - Connection setting:
// * Success - Boolean -
// * Value - See ConnectionSettingTemplate
// * Message - String -
Function ConnectionSetting(IntegrationSettingName, AddInfo = Undefined) Export
	Result = New Structure("Success, Value, Message", False, Undefined, "");

	IntegrationSettings = IntegrationServerReuse.GetIntegrationSettings(IntegrationSettingName);

	If Not ValueIsFilled(IntegrationSettings.Ref) Then
		Result.Success = False;
		Result.Message = StrTemplate(R().S_005, IntegrationSettingName);
		Return Result;
	EndIf;

	ConnectionSetting = ConnectionSettingTemplate(IntegrationSettings.IntegrationType, IntegrationSettings.Ref);
	
	// Customize setting with according IntegrationSettings catalog
	FillPropertyValues(ConnectionSetting, IntegrationSettings.CustomizedSetting);

	ConnectionSetting.Insert("IntegrationSettingsRef", IntegrationSettings.Ref);
	ConnectionSetting.Insert("IntegrationType", IntegrationSettings.IntegrationType);
	ConnectionSetting.Insert("AddData", GetAdditionalSettings(IntegrationSettings.Ref));
	If Not ConnectionSetting.Property("Headers") Then
		ConnectionSetting.Insert("Headers", New Map);
	EndIf;
	If Not ConnectionSetting.Property("User") Then
		ConnectionSetting.Insert("User", "");
	EndIf;
	If Not ConnectionSetting.Property("Password") Then
		ConnectionSetting.Insert("Password", "");
	EndIf;
	If Not ConnectionSetting.Property("Proxy") Then
		ConnectionSetting.Insert("Proxy", Undefined);
	EndIf;
	If Not ConnectionSetting.Property("UseOSAuthentication") Then
		ConnectionSetting.Insert("UseOSAuthentication", False);
	EndIf;	
	
	Result.Success = True;
	Result.Value = ConnectionSetting;
	Return Result;
EndFunction

// Get additional settings.
// 
// Parameters:
//  IntegrationSettings Integration settings
// 
// Returns:
//  Structure - Get additional settings
Function GetAdditionalSettings(IntegrationSettings) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	IntegrationInfo.Key,
		|	IntegrationInfo.Value,
		|	IntegrationInfo.SecondValue
		|FROM
		|	InformationRegister.IntegrationInfo AS IntegrationInfo
		|WHERE
		|	IntegrationInfo.IntegrationSettings = &IntegrationSettings
		|	AND IntegrationInfo.isProduct = &isProduct";
	
	Query.SetParameter("isProduct", ServiceSystemServer.isProduction());
	Query.SetParameter("IntegrationSettings", IntegrationSettings);
	QueryResult = Query.Execute().Unload();
	
	Str = New Structure;
	For Each Row In QueryResult Do
		Str.Insert(Row.Key, ?(IsBlankString(Row.Value), Row.SecondValue, Row.Value));
	EndDo;
	Return Str;
EndFunction

// Connection setting template.
// 
// Parameters:
//  IntegrationType - EnumRef.IntegrationType - Integration type
//  Object - CatalogObject.IntegrationSettings - Add info
// 
// Returns:
//  Structure - Connection setting template:
// * IntegrationSettingsRef - CatalogRef.IntegrationSettings -
// * QueryType - String -
// * ResourceAddress - String -
// * Ip - String -
// * Port - Number -
// * User - String -
// * Password - String -
// * Proxy - Undefined -
// * TimeOut - Number -
// * SecureConnection - Undefined -
// * UseOSAuthentication - Boolean -
// * Headers - Map -
// * AddData - Structure - Data from register IntegrationInfo
Function ConnectionSettingTemplate(IntegrationType, Object = Undefined) Export
	Return IntegrationServerReuse.ConnectionSettingTemplate(IntegrationType, Object);
EndFunction

Function InfoRegSettingsStructure() Export
	Return IntegrationServerReuse.InfoRegSettingsStructure();
EndFunction

Procedure SaveFileToFileStorage(PathForSave, FileName, BinaryData) Export
	BinaryData.Write(PathForSave + ?(StrEndsWith(PathForSave, "\"), "", "\") + FileName);
EndProcedure

Procedure SaveSettingsInInfoReg(SettingsTab) Export

	IntegrationServerPrivileged.SaveSettingsInInfoReg(SettingsTab);

EndProcedure

Function GetArrayOfUnusedFiles(PathForSave) Export
	TableOfFilesURI = New ValueTable();
	TableOfFilesURI.Columns.Add("FileURI", Metadata.Catalogs.Files.Attributes.URI.Type);

	ArrayOfExtensions = PictureViewerClientServer.AllPictureExtensions();
	ArrayOfFiles = FindFiles(PathForSave, "*", True);
	For Each File In ArrayOfFiles Do
		If ArrayOfExtensions.Find(Lower(File.Extension)) = Undefined Then
			Continue;
		EndIf;
		TableOfFilesURI.Add().FileURI = File.Name;
	EndDo;
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.FileURI
	|INTO tmp
	|FROM
	|	&TablesOfFilesURI AS tmp
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.FileURI
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN Catalog.Files AS Files
	|		ON tmp.FileURI = Files.URI
	|WHERE
	|	Files.Ref IS NULL";
	Query.SetParameter("TablesOfFilesURI", TableOfFilesURI);
	Return Query.Execute().Unload().UnloadColumn("FileURI");
EndFunction

Procedure DeleteUnusedFiles(PathForSave, ArrayOfFilesID) Export
	For Each FileName In ArrayOfFilesID Do
		DeleteFiles(PathForSave + "\" + FileName);
	EndDo;
EndProcedure

// Extension call test connection call.
// 
// Parameters:
//  IntegrationSettings - CatalogRef.IntegrationSettings -
// 
// Returns:
//  Undefined - Extension call test connection call
Function ExtensionCall_TestConnectionCall(IntegrationSettings) Export
	Return Undefined;
EndFunction
