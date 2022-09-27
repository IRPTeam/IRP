
#Region Public

&Around("SendRequestClientServer")
Function Unit_SendRequestClientServer(ConnectionSetting, ResourceParameters, RequestParameters, RequestBody, EndPoint, AddInfo)
	
	isNeedingToSaveExchange = CommonFunctionsServer.GetRefAttribute(ConnectionSetting.IntegrationSettingsRef, "Unit_SaveExchangeHistory");
	
	If isNeedingToSaveExchange Then 
		ServiceExchangeData = Unit_GetServiceExchangeDataTemplate();
		ServiceExchangeData.StartTime = CurrentDate();
		ServiceExchangeData.Headers = ConnectionSetting.Headers;
		ServiceExchangeData.RequestType = ConnectionSetting.QueryType;
		ServiceExchangeData.RequestBody = RequestBody;
	EndIf;
	
	ServerResponse = ProceedWithCall(ConnectionSetting, ResourceParameters, RequestParameters, RequestBody, EndPoint, AddInfo);
	
	If Not isNeedingToSaveExchange Then
		Return ServerResponse;
	EndIf;
		
	ServiceExchangeData.EndTime = CurrentDate();
	ServiceExchangeData.ServerResponse = ServerResponse;
	
	If Not ValueIsFilled(EndPoint) Then
		ResourceAddress = ConnectionSetting.ResourceAddress;
	Else
		ResourceAddress = ConnectionSetting.ResourceAddress + ?(StrStartsWith(EndPoint, "/"), EndPoint, "/" + EndPoint);
	EndIf;
	SetResourceParameters(ResourceAddress, ResourceParameters, AddInfo);
	SetRequestParameters(ResourceAddress, RequestParameters, AddInfo);
	ServiceExchangeData.ResourceAddress = ResourceAddress;
	
	Description = "http";
	If TypeOf(ConnectionSetting.SecureConnection) = Type("Boolean") And ConnectionSetting.SecureConnection Then
		Description = Description + "s";
	EndIf;
	Description = Description + "://" + ConnectionSetting.Ip;
	If Number(ConnectionSetting.Port) > 0 Then
		Description = Description + ":" + Format(Number(ConnectionSetting.Port), "NG=;");
	EndIf;
	If Not StrStartsWith(ResourceAddress, "/") Then
		Description = Description + "/";
	EndIf;
	Description = Description + ResourceAddress;
	ServiceExchangeData.Description = Description;
	
	IntegrationServer.Unit_SaveServiceExchangeData(ServiceExchangeData);
	
	Return ServerResponse;
	
EndFunction

// Get service exchange data template.
// 
// Returns:
//  Structure - Get service exchange data template:
// * Description - String -
// * ResourceAddress - String -
// * RequestType - String -
// * Headers - Map -
// * RequestBody - Undefined -
// * ServerResponse - See IntegrationClientServer.ServerResponse
// * StartTime - Date -
// * EndTime - Date -
Function Unit_GetServiceExchangeDataTemplate() Export
	ServiceExchangeData = New Structure;
	ServiceExchangeData.Insert("Description", "");
	ServiceExchangeData.Insert("ResourceAddress", "");
	ServiceExchangeData.Insert("RequestType", "");
	ServiceExchangeData.Insert("Headers", New Map);
	ServiceExchangeData.Insert("RequestBody", Undefined);
	ServiceExchangeData.Insert("ServerResponse", Undefined);
	ServiceExchangeData.Insert("StartTime", Date(1,1,1));
	ServiceExchangeData.Insert("EndTime", Date(1,1,1));
	Return ServiceExchangeData;
EndFunction

#EndRegion