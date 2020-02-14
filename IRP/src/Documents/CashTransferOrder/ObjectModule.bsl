
Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	If ValueIsFilled(SendCurrency) And ValueIsFilled(ReceiveCurrency)
		And ValueIsFilled(Sender) And ValueIsFilled(Receiver) Then
		
		If SendCurrency = ReceiveCurrency Then
			
			If SendAmount <> ReceiveAmount Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(R().Error_074, "SendAmount", ThisObject);
				CommonFunctionsClientServer.ShowUsersMessage(R().Error_074, "ReceiveAmount", ThisObject);
			EndIf;
		Else
			// Currency exchange is possible only through accounts with the same type (cash account or bank account)
			If Sender.Type <> Receiver.Type Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(R().Error_050, "Sender", ThisObject);
				CommonFunctionsClientServer.ShowUsersMessage(R().Error_050, "Receiver", ThisObject);
			EndIf;
		EndIf;
	EndIf;

	If DocCashTransferOrderServer.UseCashAdvanceHolder(ThisObject) Then
		CheckedAttributes.Add("CashAdvanceHolder");
	EndIf;
EndProcedure



