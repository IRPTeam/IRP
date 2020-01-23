Procedure Posting(Cancel, PostingMode)
	
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure UndoPosting(Cancel)
	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If Not (ThisObject.AdditionalProperties.Property("WriteOnTransaction")
			And ThisObject.AdditionalProperties.WriteOnTransaction) Then
		Cancel = True;
	EndIf;
EndProcedure

