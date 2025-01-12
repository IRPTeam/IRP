
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	AdditionalProperties.Insert("Posted", Ref.Posted);
	AdditionalProperties.Insert("WriteMode", WriteMode);
	AdditionalProperties.Insert("AssigneeArray", Ref.AssigneeList.Unload().UnloadColumn("Assignee"));
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
	
	If Posted Then
		NotifyUsers = New Array;
		For Each AssigneeRow In AssigneeList Do
			If AdditionalProperties.AssigneeArray.Find(AssigneeRow.Assignee) = Undefined Then
				NotifyUsers.Add(AssigneeRow.Assignee);
			EndIf;
		EndDo;
		
		If NotifyUsers.Count() > 0 Then
			Settings = LoggerServerCall.GetNotifySettings();
			Settings.SendEmail = True;
			Settings.WaitForOpenRef = True;
			LoggerServerCall.AddLog(Ref, R().Issue_5, False, NotifyUsers, Settings);
		EndIf;		
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