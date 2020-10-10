Function AskGoogle(RequestBody)
	HTTPSettings = IntegrationServer.ConnectionSettingTemplate();
	HTTPSettings.Ip = "accounts.google.com";
	HTTPSettings.SecureConnection = True;
	HTTPSettings.Port = 443;
	HTTPSettings.ResourceAddress = "/o/oauth2/token";
	HTTPSettings.Headers.Insert("Content-Type", "application/x-www-form-urlencoded");
	Answer = IntegrationClientServer.SendRequest(HTTPSettings, , , RequestBody);
	
	If NOT Answer.StatusCode = 200 Then
		WriteLogEvent("Get picture from Google drive", EventLogLevel.Error, , , 
					  "Status: " + Answer.StatusCode + Chars.LF + Answer.ResponseBody);
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_084);	
		Return Undefined;
	EndIf;
	
	AnswerStructure = CommonFunctionsServer.DeserializeJSON(Answer.ResponseBody);
	Return AnswerStructure;
EndFunction

Function MainToken(Code, ConnectionSetting) Export
	FillTokenInfo(ConnectionSetting);
	RequestBody = ConnectionSetting.tokenRequest + Code;
	Return AskGoogle(RequestBody);
EndFunction

Function UpdateAccessToken(IntegrationSettings) Export
	FillTokenInfo(IntegrationSettings);
	If IntegrationSettings.Property("refresh_token") And Not IsBlankString(IntegrationSettings.refresh_token) Then
		RequestBody = IntegrationSettings.updateTokenRequest + IntegrationSettings.refresh_token;
		Return AskGoogle(RequestBody);			
	EndIf;
	
EndFunction

Procedure FillTokenInfo(ConnectionSetting) Export

	oauth2 = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%1&access_type=offline&scope=%2&redirect_uri=" + ConnectionSetting.redirect_uri;
	
	ScopesArray = New Array;
	ScopesArray.Add("https://www.googleapis.com/auth/drive");

	ConnectionSetting.Insert("oauth2", StrTemplate(oauth2, ConnectionSetting.client_id, StrConcat(ScopesArray, " ")));
	
	tokenRequest = "client_id=%1&client_secret=%2&grant_type=authorization_code&access_type=offline&redirect_uri=%3&code=";
	ConnectionSetting.Insert("tokenRequest", StrTemplate(tokenRequest, ConnectionSetting.client_id, ConnectionSetting.client_secret, ConnectionSetting.redirect_uri));
	updateTokenRequest =  "grant_type=refresh_token&client_id=%1&client_secret=%2&refresh_token=";
	ConnectionSetting.Insert("updateTokenRequest", StrTemplate(updateTokenRequest, ConnectionSetting.client_id, ConnectionSetting.client_secret));

EndProcedure

Function CurrentActiveToken(IntegrationRef, FolderID = "") Export
	ConnectionSetting = IntegrationClientServer.ConnectionSetting(IntegrationRef.UniqueID);
	FolderID = ConnectionSetting.Value.folderID;

	Query = New Query;
	Query.Text =
		"SELECT
		|	IntegrationInfo.Value
		|FROM
		|	InformationRegister.IntegrationInfo AS IntegrationInfo
		|WHERE
		|	IntegrationInfo.IntegrationSettings = &IntegrationSettings
		|	AND IntegrationInfo.Key = &Key
		|	AND IntegrationInfo.SecondValue > &SecondValue";
	
	Query.SetParameter("SecondValue", CurrentDate());
	Query.SetParameter("IntegrationSettings", IntegrationRef);
	Query.SetParameter("Key", "access_token");
	
	QueryResult = Query.Execute();
	
	If NOT QueryResult.IsEmpty() Then		
		Tmp = QueryResult.Select();
		Tmp.Next();
		Return Tmp.Value;
	EndIf;
	refresh_token = UpdateAccessToken(ConnectionSetting.Value);
	
	If refresh_token = Undefined Then
		Return Undefined;
	EndIf;
	
	Tab = IntegrationServer.InfoRegSettingsStructure();
	NewRow = Tab.Add();
	NewRow.IntegrationSettings = IntegrationRef;
	NewRow.Key = "access_token";
	NewRow.Value = refresh_token.access_token;
	NewRow.SecondValue = CurrentDate() + refresh_token.expires_in;
	
	IntegrationServer.SaveSettingsInInfoReg(Tab);
	
	Return refresh_token.access_token;
EndFunction

Function SendData(Headers, DataTXT) Export

	HTTPConnection = New HTTPConnection("accounts.google.com", 443, , , , 5, New OpenSSLSecureConnection());
	
	
	Request = New HTTPRequest("upload/drive/v2/files?uploadType=multipart", Headers);
	Request.SetBodyFromString(StrConcat(DataTXT, Chars.LF));
	
	Answer = HTTPConnection.POST(Request);
	Return Answer
EndFunction

Function GetFileFromGoogleDrive(URI, Headers) Export
	HTTPConnection = New HTTPConnection("accounts.google.com", 443, , , , 15, New OpenSSLSecureConnection());
	Request = New HTTPRequest("/drive/v2/files/" + URI + "?alt=media&source=downloadUrl", Headers);
	Answer = HTTPConnection.GET(Request);
	Return Answer
EndFunction
