
&Around("ReadXMLReponse")
Function Unit_ReadXMLReponse(DeviceResponse)
	If Unit_CommonServerCall.GetErrorValue("ErrorOnFiscalWhenGetXMLResponse").Boolean Then
		DeviceResponse = "DoSomeBug" + DeviceResponse;
	EndIf;
	Return ProceedWithCall(DeviceResponse);
EndFunction
