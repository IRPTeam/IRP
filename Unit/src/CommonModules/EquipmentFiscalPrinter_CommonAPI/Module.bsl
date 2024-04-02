
&Around("ReadXMLReponse")
Function Unit_ReadXMLReponse(DeviceResponse)
	If Units_CommonServerCall.GetErrorValue("ErrorOnFiscalWhenGetXMLResponse").Boolean Then
		DeviceResponse = "DoSomeBug" + DeviceResponse;
	EndIf;
	Return ProceedWithCall(DeviceResponse);
EndFunction
