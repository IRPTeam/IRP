Function Auth(Form) Export
	Settings = GoogleDriveServer.Settings();
	
	Params = New Structure("HTML, Type, SrcUUID", Settings.oauth2, "GoogleDrive", Form.UUID);
	OpenForm("CommonForm.HTMLField", Params);

EndFunction 

Procedure OnHTMLComplite(Document, UUID) Export
	Code = Undefined;
	If Document.location.host = "localhost" Then
		Params = StrSplit(Document.location.search, "&?");
		For Each Row In Params Do
			If StrStartsWith(Row, "code") Then
				Code = StrSplit(Row, "=")[1];
				TokenData = GoogleDriveServer.MainToken(Code);
				Notify("GoogleDriveToken", TokenData, UUID);
			EndIf;
		EndDo; 
	EndIf;
EndProcedure

