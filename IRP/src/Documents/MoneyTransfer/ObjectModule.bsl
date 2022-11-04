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
	
	Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.ReceiveUUID, ThisObject.ReceiveCurrency,
		ThisObject.ReceiveAmount);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.ReceiveUUID);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
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
	DataFilled = ValueIsFilled(SendCurrency) 
				And ValueIsFilled(ReceiveCurrency) 
				And ValueIsFilled(Sender)
				And ValueIsFilled(Receiver);
	If DataFilled 
		And ThisObject.SendCurrency = ThisObject.ReceiveCurrency
		And ThisObject.SendAmount <> ThisObject.ReceiveAmount Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(R().Error_074, "SendAmount", ThisObject);
				CommonFunctionsClientServer.ShowUsersMessage(R().Error_074, "ReceiveAmount", ThisObject);
	EndIf;
	If Not Cancel And Not ThisObject.CashTransferOrder.IsEmpty() Then
		Attributes = CommonFunctionsServer.GetAttributesFromRef(ThisObject.CashTransferOrder, "Receiver,Sender");
		If ThisObject.Receiver <> Attributes.Receiver Then
			Cancel = True;
			WrongAttribute = "Receiver";
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_AttributeDontMatchValueFromBasisDoc, 
					WrongAttribute, Attributes.Receiver, ThisObject.CashTransferOrder), 
				WrongAttribute, 
				ThisObject);
		EndIf;
		If ThisObject.Sender <> Attributes.Sender Then
			Cancel = True;
			WrongAttribute = "Sender";
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_AttributeDontMatchValueFromBasisDoc, 
					WrongAttribute, Attributes.Sender, ThisObject.CashTransferOrder), 
				WrongAttribute, 
				ThisObject);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		If FillingData.BasedOn = "CashTransferOrder" Or FillingData.BasedOn = "PointOfSale" Then
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData);
EndProcedure
