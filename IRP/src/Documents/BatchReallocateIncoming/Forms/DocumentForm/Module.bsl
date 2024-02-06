
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocumentsServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	ThisObject.ReadOnly = True;
EndProcedure

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion