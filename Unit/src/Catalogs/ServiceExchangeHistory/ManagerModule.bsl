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
	
	If ValueIsFilled(RequiredQuery) Then
		Return;
	EndIf;
	
	// Create a new query record
	NewQuery = Catalogs.ServiceExchangeHistory.CreateItem();
	NewQuery.Description = ValidDescription;
	NewQuery.Time = ServiceExchangeData.StartTime;
	NewQuery.QueryType = ServiceExchangeData.QueryType;
	NewQuery.ResourceAddress = ServiceExchangeData.ResourceAddress;
	NewQuery.HeadersMD5 = HeadersMD5;
	NewQuery.Headers = New ValueStorage(ServiceExchangeData.Headers);
	NewQuery.BodyMD5 = BodyMD5;
	NewQuery.Body = New ValueStorage(ServiceExchangeData.RequestBody);
	NewQuery.Write();
	RequiredQuery = NewQuery.Ref;
	
	// Create a new answer record
	NewAnswer = Catalogs.ServiceExchangeHistory.CreateItem();
	NewAnswer.Parent = RequiredQuery;
	NewAnswer.Description = ServiceExchangeData.ServerResponse.Message;
	NewAnswer.ResourceAddress = ServiceExchangeData.ServerResponse.Message;
	NewAnswer.Time = ServiceExchangeData.EndTime;
	NewAnswer.StatusCode = ServiceExchangeData.ServerResponse.StatusCode;
	NewAnswer.Body = New ValueStorage(ServiceExchangeData.ServerResponse.ResponseBody);
	NewAnswer.BodyMD5 = CommonFunctionsServer.GetMD5(ServiceExchangeData.ServerResponse.ResponseBody);
	NewAnswer.Write();
			
EndProcedure