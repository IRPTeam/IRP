// @strict-types

#Region EventHandlers

// Command processing.
// 
// Parameters:
//  MessageRef - DocumentRef.OutgoingMessage - Message ref
//  CommandExecuteParameters - CommandExecuteParameters - Command execute parameters
&AtClient
Procedure CommandProcessing(MessageRef, CommandExecuteParameters)
	AddToQueue(MessageRef);
	Notify("Sended", MessageRef);
EndProcedure

#EndRegion

#Region Private

// Add to queue.
// 
// Parameters:
//  MessageRef - DocumentRef.OutgoingMessage - Message ref
&AtServer
Procedure AddToQueue(MessageRef)
	
	Query = New Query;
	Query.SetParameter("Message", MessageRef);
	
	Query.Text =
	"SELECT
	|	MessagesQueueToSendSliceLast.Period,
	|	MessagesQueueToSendSliceLast.Message,
	|	MessagesQueueToSendSliceLast.Sent,
	|	MessagesQueueToSendSliceLast.DateSent,
	|	MessagesQueueToSendSliceLast.NumberAttempts
	|FROM
	|	InformationRegister.MessagesQueueToSend.SliceLast(, Message = &Message) AS MessagesQueueToSendSliceLast";
	
	QuerySelect = Query.Execute().Select();
	//@skip-check property-return-type
	If QuerySelect.Next() And Not QuerySelect.Sent Then
		Return;
	EndIf;
	
	RecordManager = InformationRegisters.MessagesQueueToSend.CreateRecordManager();
	RecordManager.Period = CommonFunctionsServer.GetCurrentSessionDate();
	RecordManager.Message = MessageRef;
	RecordManager.Write();
	
	InformationRegisters.MessagesQueueToSend.SendMessagesFromQueue();

EndProcedure

#EndRegion
