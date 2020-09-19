Function Auth(Form) Export
	ConnectionSetting = IntegrationClientServer.ConnectionSetting(Form.Object.UniqueID);
	GoogleDriveServer.FillTokenInfo(ConnectionSetting.Value);
	AddInfo = New Structure;
	AddInfo.Insert("IntegrationSettings", ConnectionSetting.Value.IntegrationSettingsRef);
	Params = New Structure("HTML, Type, SrcUUID, AddInfo", ConnectionSetting.Value.oauth2, "GoogleDrive", Form.UUID, AddInfo);
	OpenForm("CommonForm.HTMLField", Params);

EndFunction 

Procedure OnHTMLComplete(Document, UUID, AddInfo) Export 
	Code = Undefined;
	
	// FIXIT: #292
	If Document.location.host = "localhost" Then
		Params = StrSplit(Document.location.search, "&?");
		For Each Row In Params Do
			If StrStartsWith(Row, "code") Then
				Code = StrSplit(Row, "=")[1];
				TokenData = GoogleDriveServer.MainToken(Code, AddInfo.IntegrationSettings);
				Notify("GoogleDriveToken", TokenData, UUID);
			EndIf;
		EndDo;  
	EndIf;
EndProcedure

