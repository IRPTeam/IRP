
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	For Each Ref In CommandParameter Do
		CommandProcessingAtServer(Ref);
	EndDo;
EndProcedure

&AtServer
Procedure CommandProcessingAtServer(Val Ref)
	Catalogs.Extensions.SetupExtentionInCurrentArea(Ref, True);
EndProcedure