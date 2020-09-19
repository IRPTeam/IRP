Procedure FillTokenInfo(IntegrationSettings) Export

	oauth2 = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%1&access_type=offline&scope=%2&redirect_uri=" + IntegrationSettings.redirect_uri;
	
	ScopesArray = New Array;
	ScopesArray.Add("https://www.googleapis.com/auth/drive");

	IntegrationSettings.Insert("oauth2", StrTemplate(oauth2, IntegrationSettings.client_id, StrConcat(ScopesArray, " ")));
	
	tokenRequest = "client_id=%1&client_secret=%2&grant_type=authorization_code&access_type=offline&redirect_uri=%3&code=";
	IntegrationSettings.Insert("tokenRequest", StrTemplate(tokenRequest, IntegrationSettings.client_id, IntegrationSettings.client_secret, IntegrationSettings.redirect_uri));
	updateTokenRequest =  "grant_type=refresh_token&client_id=%1&client_secret=%2&refresh_token=";
	IntegrationSettings.Insert("updateTokenRequest", StrTemplate(updateTokenRequest, IntegrationSettings.client_id, IntegrationSettings.client_secret));

EndProcedure

Function AskGoogle(RequestBody)
	HTTPSettings = IntegrationServer.ConnectionSettingTemplate();
	HTTPSettings.Ip = "accounts.google.com";
	HTTPSettings.SecureConnection = True;
	HTTPSettings.Port = 443;
	HTTPSettings.ResourceAddress = "/o/oauth2/token";
	HTTPSettings.Headers.Insert("Content-Type", "application/x-www-form-urlencoded");
	Answer = IntegrationClientServer.SendRequest(HTTPSettings, , , RequestBody);
	
	If NOT Answer.StatusCode = 200 Then
		Raise Answer.ResponseBody;
	EndIf;
	
	AnswerStructure = CommonFunctionsServer.DeserializeJSON(Answer.ResponseBody);
	Return AnswerStructure;
EndFunction

Function MainToken(Code, IntegrationSettings) Export
	FillTokenInfo(IntegrationSettings);
	RequestBody = IntegrationSettings.tokenRequest + Code;
	Return AskGoogle(RequestBody);
EndFunction

Function UpdateAccessToken(IntegrationSettings) Export
	FillTokenInfo(IntegrationSettings);
	If IntegrationSettings.Property("refresh_token") And Not IsBlankString(IntegrationSettings.refresh_token) Then
		RequestBody = IntegrationSettings.updateTokenRequest + IntegrationSettings.refresh_token;
		Return AskGoogle(RequestBody);			
	EndIf;
	
EndFunction

Function CurrentActiveToken(IntegrationRef) Export
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
	
	Query.SetParameter("SecondValue", CurrentUniversalDate());
	Query.SetParameter("IntegrationSettings", IntegrationRef);
	Query.SetParameter("Key", "access_token");
	
	QueryResult = Query.Execute();
	
	If NOT QueryResult.IsEmpty() Then		
		Tmp = QueryResult.Select();
		Tmp.Next();
		Return Tmp.Value;
	EndIf;
	ConnectionSetting = IntegrationClientServer.ConnectionSetting(IntegrationRef.UniqueID);
	refresh_token = UpdateAccessToken(ConnectionSetting.Value);
	
	If refresh_token = Undefined Then
		Return Undefined;
	EndIf;
	
	Tab = IntegrationServer.InfoRegSettingsStructure();
	NewRow = Tab.Add();
	NewRow.IntegrationSettings = IntegrationRef;
	NewRow.Key = "access_token";
	NewRow.Value = refresh_token.access_token;
	NewRow.SecondValue = CurrentUniversalDate() + refresh_token.expires_in;
	
	IntegrationServer.SaveSettingsInInfoReg(Tab);
	
	Return refresh_token.access_token;
EndFunction

Function SendToDrive(IntegrationSettingsRef, Name, RequestBody) Export
	access_token = CurrentActiveToken(IntegrationSettingsRef);
	

	
	Body = New MemoryStream();
	DataTXT = New Array;
	Boundary = "-----np" + StrReplace(String(New UUID()), "-", "");
	
	DataTXT.Add("");
	DataTXT.Add("--" + boundary);
	DataTXT.Add("Content-Type: application/json; charset=UTF-8");
	DataTXT.Add("");
	DataTXT.Add("{");
	If Not ValueIsFilled("") Then
		DataTXT.Add("  ""title"": """ + Name + """");
	Else
		DataTXT.Add("  ""title"": """ + Name + """,");
		DataTXT.Add("  ""parents"": [{");
		DataTXT.Add("  ""kind"": ""drive#fileLink"",");
		DataTXT.Add("  ""id"": """ + Name + """");
		DataTXT.Add("  }]");
	EndIf;
	DataTXT.Add("}");
	DataTXT.Add("");
	DataTXT.Add("--" + boundary);
	DataTXT.Add("Content-Type: image/" + StrSplit(Name, ".")[1]); 
	DataTXT.Add("Content-Transfer-Encoding: base64");
	DataTXT.Add("");
	DataTXT.Add("");
	
	DataTXT.Add(Base64String(RequestBody));
	
	DataTXT.Add("");
	DataTXT.Add("--" + boundary + "--");

	Headers = New Map();
	Headers.Insert("POST /upload/drive/v2/files?uploadType=multipart HTTP/1.1");
	Headers.Insert("Host", "www.googleapis.com");
	Headers.Insert("Content-Type", "multipart/related; boundary=" + boundary);
	Headers.Insert("Authorization", "OAuth " + access_token);

	HTTPConnection = New HTTPConnection("accounts.google.com", 443, , , , 5, New OpenSSLSecureConnection());
	
	
	Request = New HTTPRequest("upload/drive/v2/files?uploadType=multipart", Headers);
	Request.SetBodyFromString(StrConcat(DataTXT, Chars.LF));
	
	Answer = HTTPConnection.POST(Request);
	JSON = CommonFunctionsServer.DeserializeJSON(Answer.GetBodyAsString());
	Return JSON.webContentLink;
	
EndFunction