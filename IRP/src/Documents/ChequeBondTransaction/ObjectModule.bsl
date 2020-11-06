
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	If Not ThisObject.AdditionalProperties.Property("DelayedSynchronization") Then
		ThisObject.AdditionalProperties.Insert("DelayedSynchronization", New Array());
	EndIf;
	
	If Not ThisObject.Ref.DeletionMark And ThisObject.DeletionMark Then
		ThisObject.AdditionalProperties.DelayedSynchronization.Add("SetDeletionMark");
	EndIf;
	If ThisObject.Ref.DeletionMark And Not ThisObject.DeletionMark Then
		ThisObject.AdditionalProperties.DelayedSynchronization.Add("UnsetDeletionMark");
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	If ThisObject.AdditionalProperties.Property("DelayedSynchronization") Then
		For Each ItemOfDelayedSynchronization In ThisObject.AdditionalProperties.DelayedSynchronization Do
			Synchronize(ItemOfDelayedSynchronization, Cancel);
		EndDo;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	Synchronize("Delete", Cancel);
	
EndProcedure

Procedure Posting(Cancel, PostingMode)
	
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	Synchronize("Post", Cancel);
	
EndProcedure

Procedure UndoPosting(Cancel)
	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	Synchronize("Unpost", Cancel);
	
EndProcedure

Procedure Synchronize(Event, Cancel)
	ArrayOfCheque = ThisObject.ChequeBonds.UnloadColumn("Cheque");
	Try
		DataLock = New DataLock();
		If Event = "Post" Then
			Documents.ChequeBondTransactionItem.PostDocuments(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "Unpost" Then
			Documents.ChequeBondTransactionItem.UnpostDocuments(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "Delete" Then
			Documents.ChequeBondTransactionItem.DeleteDocuments(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "SetDeletionMark" Then
			Documents.ChequeBondTransactionItem.SetDeletionMarkForDocuments(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "UnsetDeletionMark" Then
			Documents.ChequeBondTransactionItem.UnsetDeletionMarkForDocuments(DataLock, ArrayOfCheque, ThisObject.Ref);
		Else
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_032);
		EndIf;
	Except
		
		CommonFunctionsClientServer.ShowUsersMessage(ErrorDescription());
		
	EndTry;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	Text = R().Error_030;
	
	For Each RowChequeBond In ChequeBonds Do
		
		If DocChequeBondTransactionServer.CheckRowChequeBond(RowChequeBond.NewStatus, RowChequeBond.CashAccount) Then
			
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(Text, Metadata.Catalogs.CashAccounts.Synonym, 
																		"" + RowChequeBond.LineNumber,  
																		Metadata.Catalogs.ChequeBonds.Synonym),
																		"ChequeBonds[" + (RowChequeBond.LineNumber - 1) + "].CashAccount",
																		ThisObject);
		EndIf;
		
	EndDo;
	
EndProcedure

