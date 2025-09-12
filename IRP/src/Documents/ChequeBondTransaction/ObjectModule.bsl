Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	Properties = ThisObject.AdditionalProperties; 
	If Not Properties.Property("Sync_DeletionMark") Then
		Properties.Insert("Sync_DeletionMark", New Array());
	EndIf;
	
	If Not ThisObject.Ref.DeletionMark And ThisObject.DeletionMark Then
		Properties.Sync_DeletionMark.Add("SetDeletionMark");
	EndIf;
	
	If ThisObject.Ref.DeletionMark And Not ThisObject.DeletionMark Then
		Properties.Sync_DeletionMark.Add("UnsetDeletionMark");
	EndIf;
	
	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.ChequeBonds);
		For Each Row In ThisObject.ChequeBonds Do
			Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
			CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
			CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
		EndDo;
	
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	Properties = ThisObject.AdditionalProperties;
	If Properties.Property("Sync_DeletionMark") Then
		For Each Value In Properties.Sync_DeletionMark Do
			Synchronize(Value, Cancel);
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
			Documents.ChequeBondTransactionItem.Sync_Post(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "Unpost" Then
			Documents.ChequeBondTransactionItem.Sync_Unpost(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "Delete" Then
			Documents.ChequeBondTransactionItem.DeleteDocuments(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "SetDeletionMark" Then
			Documents.ChequeBondTransactionItem.Sync_SetDeletionMark(DataLock, ArrayOfCheque, ThisObject.Ref);
		ElsIf Event = "UnsetDeletionMark" Then
			Documents.ChequeBondTransactionItem.Sync_UnsetDeletionMark(DataLock, ArrayOfCheque, ThisObject.Ref);
		Else
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_032);
		EndIf;
	Except
		CommonFunctionsClientServer.ShowUsersMessage(ErrorDescription());
	EndTry;
EndProcedure
