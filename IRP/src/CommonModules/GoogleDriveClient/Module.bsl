Procedure Auth(Form) Export
	ConnectionSetting = IntegrationClientServer.ConnectionSetting(Form.Object.UniqueID);
	GoogleDriveServer.FillTokenInfo(ConnectionSetting.Value);
	AddInfo = New Structure;
	AddInfo.Insert("IntegrationSettings", ConnectionSetting.Value.IntegrationSettingsRef);
	AddInfo.Insert("redirect_uri", ConnectionSetting.Value.redirect_uri);
	AddInfo.Insert("Value", ConnectionSetting.Value);
	Params = New Structure("HTML, Type, SrcUUID, AddInfo", ConnectionSetting.Value.oauth2, "GoogleDrive", Form.UUID, AddInfo);
	OpenForm("CommonForm.HTMLField", Params, Form, , , , , FormWindowOpeningMode.LockOwnerWindow);

EndProcedure 

Procedure OnHTMLComplete(Document, UUID, AddInfo) Export 
	Code = Undefined;
	
	// FIXIT: #292
	If Lower(Document.location.origin) = Lower(AddInfo.redirect_uri) Then
		Params = StrSplit(Document.location.search, "&?");
		For Each Row In Params Do
			If StrStartsWith(Lower(Row), "code") Then
				Code = StrSplit(Row, "=")[1];
				TokenData = GoogleDriveServer.MainToken(Code, AddInfo.Value);
				Notify("GoogleDriveToken", TokenData, UUID);
				Notify("CloseForm", , UUID);
			EndIf;
		EndDo;  
	EndIf;
EndProcedure

