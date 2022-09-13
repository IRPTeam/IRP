// @strict-types

// Save service exchange data.
// 
// Parameters:
//  ServiceExchangeData - See IntegrationClientServer.GetServiceExchangeDataTemplate
//
Procedure SaveServiceExchangeData(ServiceExchangeData) Export

	// Hash preparation
	HeadersMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.Headers);
	BodyMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.RequestBody);

	// Quick search query by description
	DescriptionLength = Metadata.Catalogs.ServiceExchangeHistory.DescriptionLength;
	ValidDescription = TrimAll(Left(ServiceExchangeData.Description, DescriptionLength));
	RequiredQuery = Catalogs.ServiceExchangeHistory.FindByDescription(
			ValidDescription, True, Catalogs.ServiceExchangeHistory.EmptyRef());
	
	// Quick search query by attributes
	If ValueIsFilled(RequiredQuery) Then
		SearchQuery = New Query();
		SearchQuery.SetParameter("ResourceAddress", ServiceExchangeData.ResourceAddress);
		SearchQuery.SetParameter("QueryType", ServiceExchangeData.QueryType);
		SearchQuery.SetParameter("HeadersMD5", HeadersMD5);
		SearchQuery.SetParameter("BodyMD5", BodyMD5);
		SearchQuery.Text =
		"SELECT
		|	ServiceExchangeHistory.Ref
		|FROM
		|	Catalog.ServiceExchangeHistory AS ServiceExchangeHistory
		|WHERE
		|	ServiceExchangeHistory.Parent = VALUE(Catalog.ServiceExchangeHistory.EmptyRef)
		|	AND CAST(ServiceExchangeHistory.ResourceAddress AS STRING(1000)) = &ResourceAddress
		|	AND ServiceExchangeHistory.QueryType = &QueryType
		|	AND ServiceExchangeHistory.HeadersMD5 = &HeadersMD5
		|	AND ServiceExchangeHistory.BodyMD5 = &BodyMD5
		|	AND NOT ServiceExchangeHistory.DeletionMark";
		ResultQuery = SearchQuery.Execute().Select();
		If ResultQuery.Next() Then
			RequiredQuery = ResultQuery.Ref;
		Else
			RequiredQuery = Catalogs.ServiceExchangeHistory.EmptyRef();
		EndIf;
	EndIf;
	
	NeedCheckAnswer = True;
	
	// Create a new query record
	If Not ValueIsFilled(RequiredQuery) Then
		NewQuery = Catalogs.ServiceExchangeHistory.CreateItem();
		NewQuery.Description = ValidDescription;
		NewQuery.Time = ServiceExchangeData.StartTime;
		NewQuery.QueryType = ServiceExchangeData.QueryType;
		NewQuery.ResourceAddress = ServiceExchangeData.ResourceAddress;
		NewQuery.HeadersMD5 = HeadersMD5;
		NewQuery.Headers = New ValueStorage(ServiceExchangeData.Headers);
		NewQuery.BodyMD5 = BodyMD5;
		NewQuery.Body = New ValueStorage(ServiceExchangeData.RequestBody);
		
		BodyInfo = GetBodyInfo(ServiceExchangeData.RequestBody, ServiceExchangeData.Headers);
		NewQuery.BodySize = BodyInfo.Size;  
		NewQuery.BodyType = BodyInfo.Type;
		
		NewQuery.Write();
		RequiredQuery = NewQuery.Ref;
		NeedCheckAnswer = False;
	EndIf;
	
	If NeedCheckAnswer Then
		SearchQuery = New Query();
		SearchQuery.SetParameter("Query", RequiredQuery);
		SearchQuery.SetParameter("Message", ServiceExchangeData.ServerResponse.Message);
		SearchQuery.SetParameter("StatusCode", ServiceExchangeData.ServerResponse.StatusCode);
		SearchQuery.SetParameter("BodyMD5", BodyMD5);
		SearchQuery.Text =
		"SELECT
		|	ServiceExchangeHistory.Ref
		|FROM
		|	Catalog.ServiceExchangeHistory AS ServiceExchangeHistory
		|WHERE
		|	ServiceExchangeHistory.Parent = &Query
		|	AND CAST(ServiceExchangeHistory.ResourceAddress AS STRING(1000)) = &Message
		|	AND ServiceExchangeHistory.StatusCode = &StatusCode
		|	AND ServiceExchangeHistory.BodyMD5 = &BodyMD5
		|	AND NOT ServiceExchangeHistory.DeletionMark";
		ResultQuery = SearchQuery.Execute().Select();
		If ResultQuery.Next() Then
			Return;
		EndIf;
	EndIf;
	
	// Create a new answer record
	NewAnswer = Catalogs.ServiceExchangeHistory.CreateItem();
	NewAnswer.Parent = RequiredQuery;
	NewAnswer.Description = ServiceExchangeData.ServerResponse.Message;
	NewAnswer.ResourceAddress = ServiceExchangeData.ServerResponse.Message;
	NewAnswer.Time = ServiceExchangeData.EndTime;
	NewAnswer.StatusCode = ServiceExchangeData.ServerResponse.StatusCode;
	NewAnswer.Headers = New ValueStorage(ServiceExchangeData.ServerResponse.Headers);
	NewAnswer.HeadersMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.ServerResponse.Headers);
	NewAnswer.Body = New ValueStorage(ServiceExchangeData.ServerResponse.ResponseBody);
	NewAnswer.BodyMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.ServerResponse.ResponseBody);
	
	BodyInfo = GetBodyInfo(ServiceExchangeData.ServerResponse.ResponseBody, ServiceExchangeData.ServerResponse.Headers);
	NewAnswer.BodySize = BodyInfo.Size;  
	NewAnswer.BodyType = BodyInfo.Type;
	
	NewAnswer.Write();
			
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
Function GetBodyInfo(Body, Headers) Export
	
	Info = New Structure("Size, Type", 0, "");
	
	If TypeOf(Body) = Type("Undefined") Then
		Return Info;
	EndIf;
		
	ContentType = Headers.Get("Content-Type");
	If ContentType <> Undefined Then
		Info.Type = String(ContentType);
	ElsIf TypeOf(Body) = Type("String") Then
		Info.Type = "Text";
	Else
		Info.Type = "Binary";
	EndIf;
	
	If TypeOf(Body) = Type("String") Then
		Info.Size = StrLen(Body);
	Else
		Base64String = Base64String(Body);
		Info.Size = Int(StrLen(Base64String) - ?(Right(Base64String, 1) = "=", 1, 0) - ?(Right(Base64String, 2) = "==", 1, 0) / 4 * 3);
	EndIf;
	
	Return Info;
	
EndFunction