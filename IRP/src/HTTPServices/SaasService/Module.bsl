Function SuccessResponse()
	SuccessResponse = New Structure();
	SuccessResponse.Insert("Success", True);
	SuccessResponse.Insert("Data", New Structure());
	Return SuccessResponse;
EndFunction

Function ErrorResponse()
	ErrorResponse = New Structure();
	ErrorResponse.Insert("Success", False);
	ErrorResponse.Insert("Message", "");
	Return ErrorResponse;
EndFunction

Function CreateErrorResponse(HttpResponse, Message)
	ErrorResponse = ErrorResponse();
	ErrorResponse.Success = False;
	ErrorResponse.Message = Message;
	HttpResponse.SetBodyFromString(CommonFunctionsServer.SerializeJSON(ErrorResponse));
	Return HttpResponse;
EndFunction

Function CreateSuccessResponse(HttpResponse, Data = Undefined)
	SuccessResponse = SuccessResponse();
	SuccessResponse.Success = True;
	If Data <> Undefined Then
		For Each KeyValue In Data Do
			SuccessResponse.Data.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	HttpResponse.SetBodyFromString(CommonFunctionsServer.SerializeJSON(SuccessResponse));
	Return HttpResponse;
EndFunction

// POST
Function SaasCreateArea(Request)
	HttpResponse = New HTTPServiceResponse(200);
	
	AreaParameters = New Structure("CompanyName,
									|CompanyLocalization,
									|AdminLogin,
									|AdminPassword,
									|AdminLocalization");
	
	RequestParameters = CommonFunctionsServer.DeserializeJSON(Request.GetBodyAsString());
	FillPropertyValues(AreaParameters, RequestParameters);
	
	If Saas.AvailableCompanyLocalizations().Find(Lower(AreaParameters.CompanyLocalization)) = Undefined Then
		HttpResponse = New HTTPServiceResponse(400);
		Return CreateErrorResponse(HttpResponse, 
					StrTemplate(R()["Saas_003"], AreaParameters.CompanyLocalization));
	EndIf;
	
	NewArea = Catalogs.DataAreas.CreateItem();
	NewArea.Description         = AreaParameters.CompanyName;
	
	NewArea.DataAreaStatus      = Enums.DataAreaStatus.AreaPreparation;
	
	NewArea.CompanyName         = AreaParameters.CompanyName;
	NewArea.CompanyLocalization = AreaParameters.CompanyLocalization;
	
	NewArea.AdminLogin          = AreaParameters.AdminLogin;
	NewArea.AdminPassword       = AreaParameters.AdminPassword;
	NewArea.AdminLocalization   = AreaParameters.AdminLocalization;
	
	// default extension
	Query = New Query;
	Query.Text =
	"SELECT TOP 1
	|	Extensions.Ref
	|FROM
	|	Catalog.Extensions AS Extensions
	|WHERE
	|	Extensions.UniqueID = &UniqueID
	|	AND Not Extensions.DeletionMark";
	Query.SetParameter("UniqueID", "DefaultExt_" + AreaParameters.CompanyLocalization);
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		NewArea.Extensions.Add().Extension = Selection.Ref;
	EndIf;
	
	Try
		NewArea.Write();
	Except
		HttpResponse = New HTTPServiceResponse(500);
		
		WriteLogEvent("Data.Modify", 
		        EventLogLevel.Error,
		        Metadata.Catalogs.DataAreas,
		        NewArea,
		        ErrorInfo());
		
		Return CreateErrorResponse(HttpResponse, ErrorDescription());	
	EndTry;
	
	Result = New Structure("ID", NewArea.Code);
	Return CreateSuccessResponse(HttpResponse, Result);
	
EndFunction

// GET
Function SaasCompanyLocalizations(Request)
	HttpResponse = New HTTPServiceResponse(200);
	Result = New Structure("LocalizationCodes", Saas.AvailableCompanyLocalizations());
	Return CreateSuccessResponse(HttpResponse, Result);
EndFunction
