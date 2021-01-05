Function ConnectionSetting(IntegrationSettingName, AddInfo = Undefined) Export
	Result = New Structure("Success, Value, Message", False, Undefined, "");
	
	IntegrationSettings = IntegrationServerReuse.GetIntegrationSettings(IntegrationSettingName);
		
	If Not ValueIsFilled(IntegrationSettings.Ref) Then
		Result.Success = False;
		Result.Message = StrTemplate(R().S_005, IntegrationSettingName);
		Return Result;
	EndIf;
	
	ConnectionSetting = ConnectionSettingTemplate(IntegrationSettings.IntegrationType, AddInfo);
	
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