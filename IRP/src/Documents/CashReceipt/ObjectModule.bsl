Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.PaymentList);
	LocalTotalAmounts = New Structure("LocalTotalAmount, LocalNetAmount, LocalTaxAmount, LocalRate", 0, 0, 0, 0);
	AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();
	For Each Row In ThisObject.PaymentList Do
		Parameters = CurrenciesClientServer.GetParameters_V8(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
		
		AmountsInfo.TotalAmount.Value = Row.TotalAmount;
		AmountsInfo.NetAmount.Value   = Row.NetAmount;
		AmountsInfo.TaxAmount.Value   = Row.TaxAmount;
		TotalAounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
		LocalTotalAmounts.LocalTotalAmount = LocalTotalAmounts.LocalTotalAmount + TotalAounts.LocalTotalAmount;
		LocalTotalAmounts.LocalNetAmount   = LocalTotalAmounts.LocalNetAmount   + TotalAounts.LocalNetAmount;
		LocalTotalAmounts.LocalTaxAmount   = LocalTotalAmounts.LocalTaxAmount   + TotalAounts.LocalTaxAmount;
		LocalTotalAmounts.LocalRate        = TotalAounts.LocalRate;
		CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, LocalTotalAmounts, AmountsInfo);		
	EndDo;
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("TotalAmount");
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel);
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	DocumentsServer.FillCheckBankCashDocuments(ThisObject, CheckedAttributes);
	DocumentsServer.CheckMatchingToBasisDocument(ThisObject, "CashAccount", "Receiver", Cancel);
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		If FillingData.BasedOn = "CashTransferOrder" 
			Or FillingData.BasedOn = "IncomingPaymentOrder"
			Or FillingData.BasedOn = "SalesInvoice" 
			Or FillingData.BasedOn = "SalesOrder"
			Or FillingData.BasedOn = "PurchaseReturn"
			Or FillingData.BasedOn = "MoneyTransfer"
			Or FillingData.BasedOn = "SalesReportFromTradeAgent"
			Or FillingData.BasedOn = "EmployeeCashAdvance" Then
				ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
				Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData);
	For Each Row In FillingData.PaymentList Do
		NewRow = ThisObject.PaymentList.Add();
		FillPropertyValues(NewRow, Row);
			If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
	EndDo;
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("TotalAmount");
EndProcedure
