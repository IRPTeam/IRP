// @strict-types

Function MainAnyMethod(Request)
	
	QueryType = Request.HTTPMethod; 
	ResourceAddress = Request.RelativeURL;
	
	
	Response = New HTTPServiceResponse(200);
	Response.SetBodyFromString("Test");
	Return Response;
EndFunction
