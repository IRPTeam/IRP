
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	AdditionalProperties.Insert("Posted", Ref.Posted);
	AdditionalProperties.Insert("WriteMode", WriteMode);
	AdditionalProperties.Insert("Assignee", Ref.Assignee);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Cancel Then
		Return; 
	EndIf;
	
	If Not AdditionalProperties.Posted 
		And AdditionalProperties.WriteMode = DocumentWriteMode.Posting Then
			LoggerServerCall.AddLog(Ref, R().Issue_3, False);
	ElsIf AdditionalProperties.Posted 
		And AdditionalProperties.WriteMode = DocumentWriteMode.UndoPosting Then
			
			NotifyUsers = New Array;
			If Not SessionParameters.CurrentUser = Author Then 
				NotifyUsers.Add(Author);
			EndIf;
			Settings = LoggerServerCall.GetNotifySettings();
			Settings.SendEmail = True;
			LoggerServerCall.AddLog(Ref, R().Issue_4, False, NotifyUsers, Settings);
	EndIf;
	
	If Posted And Not AdditionalProperties.Assignee = Assignee Then
		NotifyUsers = New Array;
		NotifyUsers.Add(Assignee);
		Settings = LoggerServerCall.GetNotifySettings();
		Settings.SendEmail = True;
		Settings.WaitForOpenRef = True;
		LoggerServerCall.AddLog(Ref, R().Issue_5, False, NotifyUsers, Settings);		
	EndIf;
		 
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure