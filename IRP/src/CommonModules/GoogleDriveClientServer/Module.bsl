
Function PreparePictureURL(IntegrationSettings, URI, UUID = "", AddInfo = Undefined) Export
	Return GetFileLink(IntegrationSettings, URI, UUID); 
EndFunction

Function SendToDrive(IntegrationSettingsRef, Name, RequestBody) Export
	FolderID = "";
	access_token = GoogleDriveServer.CurrentActiveToken(IntegrationSettingsRef, FolderID);
	
	DataTXT = New Array; 
	Boundary = "-----np" + StrReplace(String(New UUID()), "-", "");
	
	DataTXT.Add("");
	DataTXT.Add("--" + boundary);
	DataTXT.Add("Content-Type: application/json; charset=UTF-8");
	DataTXT.Add("");
	DataTXT.Add("{");
	If IsBlankString(FolderID) Then
		DataTXT.Add("  ""title"": """ + Name + """");
	Else
		DataTXT.Add("  ""title"": """ + Name + """,");
		DataTXT.Add("  ""parents"": [{");
		DataTXT.Add("  ""kind"": ""drive#parentReference"",");
		DataTXT.Add("  ""id"": """ + FolderID + """");
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

	Answer = SendDataToGoogle(Headers, DataTXT);
	
	If Answer.StatusCode <> 200 Then
		#If Not Server Then
			Status(Answer.GetBodyAsString() + ": " + Name, , , PictureLib.Attach);
		#EndIf
	Else	
		JSON = CommonFunctionsServer.DeserializeJSON(Answer.GetBodyAsString());
		Return JSON.id;		
	EndIf;
	
	Return Undefined;
	
EndFunction

Function SendDataToGoogle(Headers, DataTXT)
	#If Webclient Then
		Answer = GoogleDriveServer.SendData(Headers, DataTXT);
	#Else
		HTTPConnection = New HTTPConnection("accounts.google.com", 443, , , , 15, New OpenSSLSecureConnection());
		Request = New HTTPRequest("upload/drive/v2/files?uploadType=multipart", Headers);
		Request.SetBodyFromString(StrConcat(DataTXT, Chars.LF));
		
		Answer = HTTPConnection.POST(Request);
	#EndIf

	Return Answer
EndFunction


Function GetFileLink(IntegrationSettings, URI, UUID) Export
	access_token = GoogleDriveServer.CurrentActiveToken(IntegrationSettings);
	Headers = New Map();
	Headers.Insert("Host", "www.googleapis.com");
	Headers.Insert("Authorization", "OAuth " + access_token);

	Answer = GetFileFromGoogleDrive(URI, Headers);
	
	If Answer.StatusCode <> 200 Then
		#If Not Server Then
			Status(Answer.GetBodyAsString() + ": " + URI, , , PictureLib.Attach);
		#EndIf
	Else
		PictureBD = Answer.GetBodyAsBinaryData();		
	EndIf;
	Return PutToTempStorage(PictureBD, UUID);

EndFunction


Function GetFileFromGoogleDrive(URI, Headers) 
	#If Webclient Then
		Answer = GoogleDriveServer.GetFileFromGoogleDrive(URI, Headers);
	#Else
		HTTPConnection = New HTTPConnection("accounts.google.com", 443, , , , 15, New OpenSSLSecureConnection());
		Request = New HTTPRequest("/drive/v2/files/" + URI + "?alt=media&source=downloadUrl", Headers);
		Answer = HTTPConnection.GET(Request);
	#EndIf
	
	Return Answer
EndFunction

