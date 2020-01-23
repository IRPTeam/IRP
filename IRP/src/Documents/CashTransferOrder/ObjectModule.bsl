
Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	If DocCashTransferOrderServer.CurrencyExchangeChecking(ThisObject) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_050, "Sender", ThisObject);
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_050, "Receiver", ThisObject);
		Cancel = True;
	EndIf;

	Settings = New Structure("Sender, Receiver, SendCurrency, ReceiveCurrency");
	FillPropertyValues(Settings, ThisObject);
	If DocCashTransferOrderServer.CashAdvanceHolderVisibility(Settings) Then
		CheckedAttributes.Add("CashAdvanceHolder");
	EndIf;
	

EndProcedure



