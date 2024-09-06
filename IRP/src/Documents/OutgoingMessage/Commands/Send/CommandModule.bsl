// @strict-types

#Region EventHandlers

// Command processing.
// 
// Parameters:
//  MessageRef - DocumentRef.OutgoingMessage - Message ref
//  CommandExecuteParameters - CommandExecuteParameters - Command execute parameters
&AtClient
Procedure CommandProcessing(MessageRef, CommandExecuteParameters)
	MessagesServer.AddToMessagesQueue(MessageRef, True);
	Notify("Sended", MessageRef);
EndProcedure

#EndRegion
