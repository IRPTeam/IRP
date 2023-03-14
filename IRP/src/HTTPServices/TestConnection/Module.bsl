
// @strict-types

Function ConnectionTest(Request)
	Response = New HTTPServiceResponse(200);
	Response.SetBodyFromString("OK");
	Return Response;
EndFunction
