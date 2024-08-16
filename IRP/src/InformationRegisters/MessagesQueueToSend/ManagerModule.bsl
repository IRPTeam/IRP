// @strict-types

#If Server Or ThickClientOrdinaryApplication Or ExternalConnection Then

#Region Public

Procedure SendMessagesFromQueue() Export
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	MessagesQueueToSend.Period,
	|	MessagesQueueToSend.Message,
	|	MessagesQueueToSend.NumberAttempts
	|FROM
	|	InformationRegister.MessagesQueueToSend AS MessagesQueueToSend
	|WHERE
	|	NOT MessagesQueueToSend.Sent
	|	AND MessagesQueueToSend.NumberAttempts < &NumberAllowedAttempts";
	
	Query.SetParameter("NumberAllowedAttempts", 10);
	
	QuerySelection = Query.Execute().Select();
	
	//@skip-check property-return-type, statement-type-change
	While QuerySelection.Next() Do
		
		RecordManager = InformationRegisters.MessagesQueueToSend.CreateRecordManager();
		RecordManager.Period = QuerySelection.Period;
		RecordManager.Message = QuerySelection.Message;
		RecordManager.NumberAttempts = RecordManager.NumberAttempts + 1;
		
		Try
			//@skip-check invocation-parameter-type-intersect
			Documents.OutgoingMessage.SendMessage(QuerySelection.Message);
			RecordManager.DateSent = CommonFunctionsServer.GetCurrentSessionDate();
			RecordManager.Sent = True;
		Except
			Log.Write("Send messages", ErrorDescription(), , , QuerySelection.Message);
		EndTry;
		
		RecordManager.Write();
	
	EndDo;
	
EndProcedure

#EndRegion

#EndIf
