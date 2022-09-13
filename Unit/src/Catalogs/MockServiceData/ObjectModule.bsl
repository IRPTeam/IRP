// @strict-types

Procedure Filling(FillingData, StandartProcessing) 

	If TypeOf(FillingData) = Type("CatalogRef.ServiceExchangeHistory") Then
		
		InputQuery = FillingData;
		InputAnswer = FillingData;
		If FillingData.Parent.IsEmpty() Then
			Selection = Catalogs.ServiceExchangeHistory.Select(InputQuery,,, "Time desc");
			If Selection.Next() Then
				InputAnswer = Selection.Ref;
			EndIf;
		Else
			InputQuery = FillingData.Parent;
		EndIf;
		
		Description = InputQuery.Description;
		
		Query_Type = InputQuery.QueryType;
		Query_ResourceAddress = InputQuery.ResourceAddress;
		Query_Body = InputQuery.Body;
		Query_BodyMD5 = InputQuery.BodyMD5;

		HeadersValue = InputQuery.Headers.Get();
		If TypeOf(HeadersValue) = Type("Map") Then
			For Each KeyValue In HeadersValue Do
				QueryHeaderRow       = Query_Headers.Add();
				QueryHeaderRow.Key   = String(KeyValue.Key);
				QueryHeaderRow.Value = String(KeyValue.Value);
			EndDo;
		EndIf;
		
		Answer_Message = InputAnswer.ResourceAddress;
		Answer_StatusCode = InputAnswer.StatusCode;
		Answer_Body = InputAnswer.Body;

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
