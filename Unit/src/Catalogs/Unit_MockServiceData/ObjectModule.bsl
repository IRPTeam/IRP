// @strict-types

#Region EventHandlers

Procedure Filling(FillingData, StandartProcessing) 

	If TypeOf(FillingData) = Type("CatalogRef.Unit_ServiceExchangeHistory") Then
		
		InputRequest = FillingData;
		InputAnswer = FillingData;
		If InputAnswer.Parent.IsEmpty() Then
			InputAnswer = IntegrationServer.Unit_GetLastAnswerByRequest(InputAnswer);
		Else
			InputRequest = InputAnswer.Parent;
		EndIf;
		
		Description = InputRequest.Description;
		
		Request_Type = InputRequest.RequestType;
		Request_ResourceAddress = InputRequest.ResourceAddress;
		Request_Body = InputRequest.Body;
		Request_BodyMD5 = InputRequest.BodyMD5;
		Request_BodySize = InputRequest.BodySize;
		Request_BodyType = InputRequest.BodyType;
		Request_BodyIsText = InputRequest.BodyIsText;

		HeadersValue = InputRequest.Headers.Get();
		If TypeOf(HeadersValue) = Type("Map") Then
			For Each KeyValue In HeadersValue Do
				RequestHeaderRow       = Request_Headers.Add();
				RequestHeaderRow.Key   = String(KeyValue.Key);
				RequestHeaderRow.Value = String(KeyValue.Value);
			EndDo;
		EndIf;
		
		Answer_Message = InputAnswer.ResourceAddress;
		Answer_StatusCode = InputAnswer.StatusCode;
		Answer_Body = InputAnswer.Body;
		Answer_BodySize = InputAnswer.BodySize;
		Answer_BodyType = InputAnswer.BodyType;
		Answer_BodyIsText = InputAnswer.BodyIsText;

		HeadersValue = InputAnswer.Headers.Get();
		If TypeOf(HeadersValue) = Type("Map") Then
			For Each KeyValue In HeadersValue Do
				AnswerHeaderRow       = Answer_Headers.Add();
				AnswerHeaderRow.Key   = String(KeyValue.Key);
				AnswerHeaderRow.Value = String(KeyValue.Value);
			EndDo;
		EndIf;
		
	EndIf;

EndProcedure

#EndRegion
