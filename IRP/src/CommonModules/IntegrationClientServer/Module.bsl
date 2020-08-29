
Function RequestResultIsOk(RequestResult) Export
	OkStatusCode = 200;
	Return RequestResult.Success And RequestResult.StatusCode = OkStatusCode;
EndFunction

Function ServerResponse(AddInfo = Undefined) Export
	ServerResponse = New Structure();
	ServerResponse.Insert("Success", False);
	ServerResponse.Insert("Message", "");
	ServerResponse.Insert("ResponseBody", "");
	ServerResponse.Insert("StatusCode", Undefined);
	Return ServerResponse;
EndFunction

&AtClient
Function ConnectionSetting(IntegrationSettingName, AddInfo = Undefined) Export
	Return IntegrationServer.ConnectionSetting(IntegrationSettingName, AddInfo);
EndFunction

&AtServer
Function ConnectionSetting(IntegrationSettingName, AddInfo = Undefined) Export
	Return IntegrationServer.ConnectionSetting(IntegrationSettingName, AddInfo);
EndFunction

#If Not WebClient Then

Function SendRequestClientServer(ConnectionSetting,
		ResourceParameters,
		RequestParameters,
		RequestBody,
		EndPoint,
		AddInfo = Undefined)
	
	ServerResponse = ServerResponse(AddInfo);
	
	OpenSSLSecureConnection = Undefined;
	If TypeOf(ConnectionSetting.SecureConnection) = Type("Boolean") And ConnectionSetting.SecureConnection Then
		OpenSSLSecureConnection = New OpenSSLSecureConnection();
	EndIf;
	
	HTTPConnection = New HTTPConnection(
			ConnectionSetting.Ip,
			Number(ConnectionSetting.Port),
			ConnectionSetting.User,
			ConnectionSetting.Password,
			ConnectionSetting.Proxy,
			ConnectionSetting.TimeOut,
			OpenSSLSecureConnection,
			ConnectionSetting.UseOSAuthentication);
	
	If Not ValueIsFilled(ConnectionSetting.ResourceAddress) Then
		ServerResponse.Success = False;
		ServerResponse.Message = R().S_004;
		Return ServerResponse;
	EndIf;
	
	If Not ValueIsFilled(EndPoint) Then
		ResourceAddress = ConnectionSetting.ResourceAddress;
	Else
		ResourceAddress = ConnectionSetting.ResourceAddress + 
		?(StrStartsWith(EndPoint, "/"), EndPoint, "/" + EndPoint);
	EndIf;
	
	SetResourceParameters(ResourceAddress, ResourceParameters, AddInfo);
	
	SetRequestParameters(ResourceAddress, RequestParameters, AddInfo);
	
	HTTPRequest = New HTTPRequest(ResourceAddress);
	
	SetRequestHeaders(HTTPRequest, ConnectionSetting.Headers, AddInfo);
	
	SetRequestBody(HTTPRequest, RequestBody, AddInfo);
	
	HTTPResponse = Undefined;
	Try
		HTTPResponse = HTTPConnection.CallHTTPMethod(ConnectionSetting.QueryType, HTTPRequest);
	Except
		ServerResponse.Success = False;
		ServerResponse.Message = StrTemplate(R().S_002,
				ConnectionSetting.Ip,
				ConnectionSetting.Port,
				ErrorDescription());
		Return ServerResponse;
	EndTry;
	
	ServerResponse.Success = True;
	ServerResponse.Message = StrTemplate(R().S_003,
			ConnectionSetting.Ip,
			ConnectionSetting.Port);
	ServerResponse.StatusCode = HTTPResponse.StatusCode;
	ContentType = HTTPResponse.Headers.Get("Content-Type");
	ContentTypeNotDefined = True;
	If ContentType <> Undefined Then
		ArrayOfSegments = StrSplit(ContentType, "/");
		If ArrayOfSegments.Count() >= 1 And Upper(TrimAll(ArrayOfSegments[0])) = "IMAGE" Then
			ContentTypeNotDefined = False;
			ServerResponse.ResponseBody = HTTPResponse.GetBodyAsBinaryData();
		EndIf;
	EndIf;
	
	If ContentTypeNotDefined Then
		ServerResponse.ResponseBody = HTTPResponse.GetBodyAsString();
	EndIf;
	Return ServerResponse;
	
EndFunction

#EndIf

Function SendRequest(Val ConnectionSetting,
		Val ResourceParameters = Undefined,
		Val RequestParameters = Undefined,
		Val RequestBody = Undefined,
		Val EndPoint = Undefined,
		AddInfo = Undefined) Export
	
	#If WebClient Then
	
	ServerResponse = ServerResponse(AddInfo);
	ServerResponse.Success = False;
	ServerResponse.Message = R().S_006;
	Return ServerResponse;
	
	#Else
	
	Return SendRequestClientServer(ConnectionSetting,
		ResourceParameters,
		RequestParameters,
		RequestBody,
		EndPoint,
		AddInfo);
	#EndIf
	
EndFunction

Procedure SetResourceParameters(ResourceAddress, ResourceParameters, AddInfo = Undefined)
	If ResourceParameters = Undefined Then
		Return;
	EndIf;
	For Each ResourceParameter In ResourceParameters Do
		ResourceAddress = StrReplace(ResourceAddress, "{" + ResourceParameter.Key + "}", ResourceParameter.Value);
	EndDo;
EndProcedure

Procedure SetRequestParameters(ResourceAddress, RequestParameters, AddInfo = Undefined)
	If RequestParameters = Undefined Then
		Return;
	EndIf;
	If TypeOf(RequestParameters) = Type("Map") Or TypeOf(RequestParameters) = Type("Structure") Then
		ArrayOfParameters = New Array();
		For Each Parameter In RequestParameters Do
			ArrayOfParameters.Add(StrTemplate("%1=%2", String(Parameter.Key), String(Parameter.Value)));
		EndDo;
		If ArrayOfParameters.Count() Then
			ResourceAddress = ResourceAddress + "?" + StrConcat(ArrayOfParameters, "&");
		EndIf;
	EndIf;
EndProcedure

Procedure SetRequestHeaders(HTTPRequest, Headers, AddInfo = Undefined)
	If TypeOf(Headers) = Type("Map") Then
		For Each Header In Headers Do
			HTTPRequest.Headers.Insert(Header.Key, Header.Value);
		EndDo;
	EndIf;
EndProcedure

Procedure SetRequestBody(HTTPRequest, RequestBody, AddInfo = Undefined)
	If RequestBody <> Undefined Then
		If TypeOf(RequestBody) = Type("BinaryData") Then
			HTTPRequest.SetBodyFromBinaryData(RequestBody);
		ElsIf TypeOf(RequestBody) = Type("String") Then
			HTTPRequest.SetBodyFromString(RequestBody);
		Else
			Return;
		EndIf;
	EndIf;
EndProcedure

Function SendEmail(ConnectionSetting, InternetMailMessage, AddInfo = Undefined) Export
	InternetMailProfile = New InternetMailProfile;
	InternetMailProfile.SMTPServerAddress = ConnectionSetting.SMTPServerAddress;
	InternetMailProfile.SMTPPort = ConnectionSetting.SMTPPort;
	InternetMailProfile.SMTPAuthentication = SMTPAuthenticationMode.Login;
	InternetMailProfile.SMTPUser = ConnectionSetting.SMTPUser;
	InternetMailProfile.SMTPPassword = ConnectionSetting.SMTPPassword;
	InternetMailProfile.Timeout = ConnectionSetting.Timeout;
	InternetMailProfile.POP3BeforeSMTP = ConnectionSetting.POP3BeforeSMTP;
	InternetMailProfile.SMTPUseSSL = ConnectionSetting.SMTPUseSSL;

	Mail = New InternetMail;
	Mail.Logon(InternetMailProfile);
	
	InternetMailMessage.From.Address = ConnectionSetting.FromAddress;
	InternetMailMessage.From.DisplayName = ConnectionSetting.DisplayName;
	InternetMailMessage.SenderName = ConnectionSetting.SenderName;
	InternetMailMessage.ProcessTexts();
	Answer = Mail.Send(InternetMailMessage);
	Mail.Logoff();
	Return Answer;
EndFunction