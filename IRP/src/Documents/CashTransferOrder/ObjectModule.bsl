Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(ThisObject.SendUUID) Then
		ThisObject.SendUUID = New UUID();
	EndIf;
	If Not ValueIsFilled(ThisObject.ReceiveUUID) Then
		ThisObject.ReceiveUUID = New UUID();
	EndIf;
	
	TotalTable = New ValueTable();
	TotalTable.Columns.Add("Key");
	TotalTable.Add().Key = ThisObject.SendUUID;
	TotalTable.Add().Key = ThisObject.ReceiveUUID;
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, TotalTable);
	
	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.SendUUID, ThisObject.SendCurrency,
		ThisObject.SendAmount);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.SendUUID);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
	AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
	AmountsInfo.TotalAmount.Value = ThisObject.SendAmount;
	AmountsInfo.TotalAmount.Name  = "SendLocalTotalAmount";
	AmountsInfo.LocalRate.Name    = "SendLocalRate";
	TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
	CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
	
	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.ReceiveUUID, ThisObject.ReceiveCurrency,
		ThisObject.ReceiveAmount);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.ReceiveUUID);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
	AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
	AmountsInfo.TotalAmount.Value = ThisObject.ReceiveAmount;
	AmountsInfo.TotalAmount.Name  = "ReceiveLocalTotalAmount";
	AmountsInfo.LocalRate.Name    = "ReceiveLocalRate";
	TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
	CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	DataFilled = ValueIsFilled(SendCurrency) And ValueIsFilled(ReceiveCurrency) And ValueIsFilled(Sender)
		And ValueIsFilled(Receiver);
	If DataFilled Then

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
	
	If Not ThisObject.Ref.IsEmpty() Then
		RefAttributes = CommonFunctionsServer.GetAttributesFromRef(ThisObject.Ref, "Receiver, Sender");
		If Not ThisObject.Receiver = RefAttributes.Receiver Or Not ThisObject.Sender = RefAttributes.Sender Then
			RefArray = CommonFunctionsServer.GetRelatedDocuments(ThisObject.Ref, True);
			If RefArray.Count() Then
				Cancel = True;
				If Not ThisObject.Receiver = RefAttributes.Receiver Then
					WrongAttribute = "Receiver";
					ErrorMesage = StrTemplate(R().Error_ChangeAttribute_RelatedDocsExist, WrongAttribute) + ":";
					For Each RefItem In RefArray Do
						ErrorMesage = ErrorMesage + Chars.CR + Chars.Tab + RefItem;  
					EndDo; 
					CommonFunctionsClientServer.ShowUsersMessage(ErrorMesage, WrongAttribute, ThisObject);
				EndIf;
				If Not ThisObject.Sender = RefAttributes.Sender Then
					WrongAttribute = "Sender";
					ErrorMesage = StrTemplate(R().Error_ChangeAttribute_RelatedDocsExist, WrongAttribute) + ":";
					For Each RefItem In RefArray Do
						ErrorMesage = ErrorMesage + Chars.CR + Chars.Tab + RefItem;  
					EndDo; 
					CommonFunctionsClientServer.ShowUsersMessage(ErrorMesage, WrongAttribute, ThisObject);
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure