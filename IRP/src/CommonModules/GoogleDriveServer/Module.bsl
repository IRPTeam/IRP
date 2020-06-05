Function Settings() Export
	Str = New Structure;
	Str.Insert("client_id", "968447696884-0431fs3eom677aln94ilrej9ei1hl05j.apps.googleusercontent.com");
	Str.Insert("client_secret", "tDGHoY99m5LTCsHaWMdd2SVl");
	Str.Insert("key", "AIzaSyAwhWtBbQrTKJJ4rW4A0KK8FRcROz8b_IQ");
	oauth2 ="https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%1&access_type=offline&scope=%2&redirect_uri=http://localhost";
	
	ScopesArray = New Array;
	ScopesArray.Add("https://www.googleapis.com/auth/drive");

	Str.Insert("oauth2", StrTemplate(oauth2, Str.client_id, StrConcat(ScopesArray, " ")));
	
	tokenRequest = "client_id=%1&client_secret=%2&grant_type=authorization_code&access_type=offline&redirect_uri=http://localhost&code=";
	Str.Insert("tokenRequest", StrTemplate(tokenRequest, Str.client_id, Str.client_secret));
	updateTokenRequest =  "grant_type=refresh_token&client_id=%1&client_secret=%2&refresh_token=";
	Str.Insert("updateTokenRequest", StrTemplate(updateTokenRequest, Str.client_id, Str.client_secret));
	Return Str;

EndFunction


Function AskGoogle(RequestBody)
	HTTPSettings = IntegrationServer.ConnectionSettingTemplate();
	HTTPSettings.Ip = "accounts.google.com";
	HTTPSettings.SecureConnection = True;
	HTTPSettings.Port = 443;
	HTTPSettings.ResourceAddress = "/o/oauth2/token";
	HTTPSettings.Headers.Insert("Content-Type", "application/x-www-form-urlencoded");
	Answer = IntegrationClientServer.SendRequest(HTTPSettings,,,RequestBody);
	
	If NOT Answer.StatusCode = 200 Then
		Raise Answer.ResponseBody;
	EndIf;
	
	AnswerStructure = CommonFunctionsServer.DeserializeJSON(Answer.ResponseBody);
	Return AnswerStructure;
EndFunction

Function MainToken(Code) Export
	Settings = Settings();
	RequestBody = Settings.tokenRequest + Code;
	Return AskGoogle(RequestBody);
EndFunction

Function UpdateAccessToken(IntegrationRef) Export
	Settings = Settings();
	
	refresh_token = IntegrationRef.ConnectionSetting.FindRows(New Structure("Key", "refresh_token"));
	If refresh_token.Count() Then
		RequestBody = Settings.updateTokenRequest + refresh_token[0].Value;
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
	
	refresh_token = UpdateAccessToken(IntegrationRef);
	
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
		DataTXT.Add("  ""title"": """+Name+"""");
	Else
		DataTXT.Add("  ""title"": """+Name+""",");
		DataTXT.Add("  ""parents"": [{");
		DataTXT.Add("  ""kind"": ""drive#fileLink"",");
		DataTXT.Add("  ""id"": """+Name+"""");
		DataTXT.Add("  }]");
	EndIf;
	DataTXT.Add("}");
	DataTXT.Add("");
	DataTXT.Add("--" + boundary);
	DataTXT.Add("Content-Type: image/" + StrSplit(Name, ".")[1]); 
	DataTXT.Add("Content-Transfer-Encoding: base64");
	DataTXT.Add("");DataTXT.Add("");
	
	DataTXT.Add(Base64String(RequestBody));
	
	DataTXT.Add("");
	DataTXT.Add("--"+boundary+"--");

	Headers = New Map();
	Headers.Insert("POST /upload/drive/v2/files?uploadType=multipart HTTP/1.1");
	Headers.Insert("Host", "www.googleapis.com");
	Headers.Insert("Content-Type", "multipart/related; boundary="+boundary);
	Headers.Insert("Authorization", "OAuth " + access_token);


	HTTPConnection = New HTTPConnection("accounts.google.com", 443, , , , 5, New OpenSSLSecureConnection());
	
	
	Request = New HTTPRequest("upload/drive/v2/files?uploadType=multipart", Headers);
	Request.SetBodyFromString(StrConcat(DataTXT, Chars.LF));
	
	Answer = HTTPConnection.POST(Request);
	JSON = CommonFunctionsServer.DeserializeJSON(Answer.GetBodyAsString());
	Return JSON.webContentLink;
	
EndFunction