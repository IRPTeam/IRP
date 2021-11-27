Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.PaymentList);
	For Each Row In ThisObject.PaymentList Do
		Parameters = CurrenciesClientServer.GetParameters_V8(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;

	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("TotalAmount");
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	DocumentsServer.CheckPaymentList(ThisObject, Cancel, CheckedAttributes);
	DocumentsServer.FillCheckBankCashDocuments(ThisObject, CheckedAttributes);
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		Return;
	EndIf;

	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "CashTransferOrder" Then
			Filling_BasedOn(FillingData);
		EndIf;
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "IncomingPaymentOrder" Then
			Filling_BasedOn(FillingData);
		EndIf;
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesInvoice" Then
			Filling_BasedOn(FillingData);
		EndIf;
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesOrder" Then
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
	For Each Row In ThisObject.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	ThisObject.Company          = FillingData.Company;
	ThisObject.Account          = FillingData.Account;
	ThisObject.TransitAccount   = FillingData.TransitAccount;
	ThisObject.Currency         = FillingData.Currency;
	ThisObject.TransactionType  = FillingData.TransactionType;
	ThisObject.CurrencyExchange = FillingData.CurrencyExchange;
	For Each Row In FillingData.PaymentList Do
		NewRow = ThisObject.PaymentList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("TotalAmount");
EndProcedure