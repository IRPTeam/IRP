
#Region Public

// Save service exchange data to catalog.
// 
// Parameters:
//  ServiceExchangeData - See IntegrationClientServer.Unit_GetServiceExchangeDataTemplate
Procedure Unit_SaveServiceExchangeData(ServiceExchangeData) Export

	// Bodies and hashs preparation
	RequestBody = ?(TypeOf(ServiceExchangeData.RequestBody) = Type("String"),
			GetBinaryDataFromString(ServiceExchangeData.RequestBody),
			ServiceExchangeData.RequestBody);
	RequestBodyInfo = Unit_GetBodyInfo(RequestBody, ServiceExchangeData.Headers);
	HeadersMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.Headers);
	
	AnswerBody = ?(TypeOf(ServiceExchangeData.ServerResponse.ResponseBody) = Type("String"),
			GetBinaryDataFromString(ServiceExchangeData.ServerResponse.ResponseBody),
			ServiceExchangeData.ServerResponse.ResponseBody);
	AnswerBodyInfo = Unit_GetBodyInfo(AnswerBody, ServiceExchangeData.ServerResponse.Headers);
	AnswerHeadersMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.ServerResponse.Headers);
	
	NeedToCreateAnswer = False;
	
	DescriptionLength = Metadata.Catalogs.Unit_ServiceExchangeHistory.DescriptionLength;
	ValidDescription = TrimAll(Left(ServiceExchangeData.Description, DescriptionLength));
	
	RequiredRequest = SearchRequest(ValidDescription, ServiceExchangeData, RequestBodyInfo, HeadersMD5);
	If Not ValueIsFilled(RequiredRequest) Then
		NewQuery = Catalogs.Unit_ServiceExchangeHistory.CreateItem();
		NewQuery.Description = ValidDescription;
		NewQuery.Time = ServiceExchangeData.StartTime;
		NewQuery.RequestType = ServiceExchangeData.RequestType;
		NewQuery.ResourceAddress = ServiceExchangeData.ResourceAddress;
		NewQuery.HeadersMD5 = HeadersMD5;
		NewQuery.Headers = New ValueStorage(ServiceExchangeData.Headers);
		NewQuery.Body = New ValueStorage(RequestBody);
		NewQuery.BodyMD5  = RequestBodyInfo.MD5;
		NewQuery.BodySize = RequestBodyInfo.Size;  
		NewQuery.BodyType = RequestBodyInfo.Type;
		NewQuery.BodyIsText = (TypeOf(ServiceExchangeData.RequestBody) = Type("String"));
		NewQuery.Write();
		RequiredRequest = NewQuery.Ref;
		NeedToCreateAnswer = True;
	EndIf;
	
	If NeedToCreateAnswer Or Not isExistingAnswer(ServiceExchangeData, RequiredRequest, AnswerBodyInfo) Then
		NewAnswer = Catalogs.Unit_ServiceExchangeHistory.CreateItem();
		NewAnswer.Parent = RequiredRequest;
		NewAnswer.Description = ServiceExchangeData.ServerResponse.Message;
		NewAnswer.ResourceAddress = ServiceExchangeData.ServerResponse.Message;
		NewAnswer.Time = ServiceExchangeData.EndTime;
		NewAnswer.StatusCode = ServiceExchangeData.ServerResponse.StatusCode;
		NewAnswer.Headers = New ValueStorage(ServiceExchangeData.ServerResponse.Headers);
		NewAnswer.HeadersMD5 = AnswerHeadersMD5;
		NewAnswer.Body = New ValueStorage(AnswerBody);
		NewAnswer.BodyMD5 = AnswerBodyInfo.MD5;
		NewAnswer.BodySize = AnswerBodyInfo.Size;  
		NewAnswer.BodyType = AnswerBodyInfo.Type;
		NewAnswer.BodyIsText = (TypeOf(ServiceExchangeData.ServerResponse.ResponseBody) = Type("String"));
		NewAnswer.Write();
	EndIf;
			
EndProcedure

// Get body info.
// 
// Parameters:
//  Body - String, BinaryData, Undefined - Body
//  Headers - Map - Headers
// 
// Returns:
//  Structure - Body info:
// * Size - Number - size of body
// * Type - String - type of body
// * MD5 - String - hash of body
Function Unit_GetBodyInfo(Body, Headers) Export
	
	Info = New Structure;
	Info.Insert("Size", 0);
	Info.Insert("Type", "");
	Info.Insert("MD5", "");
	
	If TypeOf(Body) = Type("Undefined") Then
		Return Info;
	EndIf;
		
	ContentType = Headers.Get("Content-Type");
	If Not ContentType = Undefined Then
		Info.Type = String(ContentType);
	ElsIf TypeOf(Body) = Type("String") Then
		Info.Type = "Text";
	Else
		Info.Type = "Binary";
	EndIf;
	
	If TypeOf(Body) = Type("String") Then
		Info.Size = StrLen(Body);
	ElsIf TypeOf(Body) = Type("BinaryData") Then
		Info.Size = Body.Size();
	EndIf;
	
	Info.MD5 = CommonFunctionsServer.GetMD5(Body); 
	
	Return Info;
	
EndFunction

// Get last answer by request.
// 
// Parameters:
//  Request - CatalogRef.Unit_ServiceExchangeHistory
// 
// Returns:
//  CatalogRef.Unit_ServiceExchangeHistory - Unit get last answer by request
Function Unit_GetLastAnswerByRequest(Request) Export
	Selection = Catalogs.Unit_ServiceExchangeHistory.Select(Request, , , "Time desc");
	If Selection.Next() Then
		Return Selection.Ref;
	EndIf;
	Return Catalogs.Unit_ServiceExchangeHistory.EmptyRef();
EndFunction

#EndRegion

#Region Private

// Search request in base.
// 
// Parameters:
//  ValidDescription - String - Valid description
//  ServiceExchangeData - See IntegrationClientServer.Unit_GetServiceExchangeDataTemplate
//  RequestBodyInfo - See IntegrationServer.Unit_GetBodyInfo
//  HeadersMD5 - String - Header's MD5
// 
// Returns:
//  CatalogRef.Unit_ServiceExchangeHistory - Search request
Function SearchRequest(ValidDescription, ServiceExchangeData, RequestBodyInfo, HeadersMD5)

	// Quick search request by description
	RequiredRequest = Catalogs.Unit_ServiceExchangeHistory.FindByDescription(
			ValidDescription, True, Catalogs.Unit_ServiceExchangeHistory.EmptyRef());
	
	// Quick search request by attributes
	If ValueIsFilled(RequiredRequest) Then
		SearchQuery = New Query();
		SearchQuery.SetParameter("ResourceAddress", ServiceExchangeData.ResourceAddress);
		SearchQuery.SetParameter("RequestType", ServiceExchangeData.RequestType);
		SearchQuery.SetParameter("HeadersMD5", HeadersMD5);
		SearchQuery.SetParameter("BodyMD5", RequestBodyInfo.MD5);
		SearchQuery.Text =
		"SELECT
		|	ServiceExchangeHistory.Ref
		|FROM
		|	Catalog.Unit_ServiceExchangeHistory AS ServiceExchangeHistory
		|WHERE
		|	ServiceExchangeHistory.Parent = VALUE(Catalog.Unit_ServiceExchangeHistory.EmptyRef)
		|	AND CAST(ServiceExchangeHistory.ResourceAddress AS STRING(1000)) = &ResourceAddress
		|	AND ServiceExchangeHistory.RequestType = &RequestType
		|	AND ServiceExchangeHistory.HeadersMD5 = &HeadersMD5
		|	AND ServiceExchangeHistory.BodyMD5 = &BodyMD5
		|	AND NOT ServiceExchangeHistory.DeletionMark";
		ResultQuery = SearchQuery.Execute().Select();
		If ResultQuery.Next() Then
			RequiredRequest = ResultQuery.Ref;
		Else
			RequiredRequest = Catalogs.Unit_ServiceExchangeHistory.EmptyRef();
		EndIf;
	EndIf;
	
	Return RequiredRequest;
	
EndFunction

// Checking if the answer exists.
// 
// Parameters:
//  ServiceExchangeData - See IntegrationClientServer.Unit_GetServiceExchangeDataTemplate
//  RequiredRequest - CatalogRef.Unit_ServiceExchangeHistory - Required request
//  AnswerBodyInfo - See IntegrationServer.Unit_GetBodyInfo
// 
// Returns:
//  Boolean - Is existing answer
Function isExistingAnswer(ServiceExchangeData, RequiredRequest, AnswerBodyInfo)
	
	SearchQuery = New Query();
	SearchQuery.SetParameter("Request", RequiredRequest);
	SearchQuery.SetParameter("Message", ServiceExchangeData.ServerResponse.Message);
	SearchQuery.SetParameter("StatusCode", ServiceExchangeData.ServerResponse.StatusCode);
	SearchQuery.SetParameter("BodyMD5", AnswerBodyInfo.MD5);
	SearchQuery.Text =
	"SELECT
	|	ServiceExchangeHistory.Ref
	|FROM
	|	Catalog.Unit_ServiceExchangeHistory AS ServiceExchangeHistory
	|WHERE
	|	ServiceExchangeHistory.Parent = &Request
	|	AND CAST(ServiceExchangeHistory.ResourceAddress AS STRING(1000)) = &Message
	|	AND ServiceExchangeHistory.StatusCode = &StatusCode
	|	AND ServiceExchangeHistory.BodyMD5 = &BodyMD5
	|	AND NOT ServiceExchangeHistory.DeletionMark";
	ResultQuery = SearchQuery.Execute().Select();
	If ResultQuery.Next() Then
		Return True;
	EndIf;
	
	Return False;
	
EndFunction

#EndRegion