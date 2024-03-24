Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	IsMoneyExchange = ThisObject.TransactionType = Enums.IncomingPaymentTransactionType.CurrencyExchange;
		
	TotalTable = New ValueTable();
	TotalTable.Columns.Add("Key");
	For Each Row In ThisObject.PaymentList Do
		TotalTable.Add().Key = Row.Key;
		If IsMoneyExchange Then
			
			If Not ValueIsFilled(Row.TransitUUID) Then
				Row.TransitUUID = New UUID();
			EndIf;
			
			TotalTable.Add().Key = Row.TransitUUID;	
		EndIf;	
	EndDo;
	
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, TotalTable);
		
	For Each Row In ThisObject.PaymentList Do
		Parameters = CurrenciesClientServer.GetParameters_V8(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
		
		If IsMoneyExchange Then		
			TransitCurrency = ThisObject.TransitAccount.Currency;
		
			Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, Row.TransitUUID, TransitCurrency, Row.AmountExchange);
			CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.TransitUUID);
			CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);		
		EndIf;		
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
	DocumentsServer.CheckMatchingToBasisDocument(ThisObject, "Account", "Receiver", Cancel);
	
	For Each Row In PaymentList Do
		If Row.TotalAmount = 0 Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_FillTotalAmount, Row.LineNumber));
		EndIf;
	EndDo;
	
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") Then
			If FillingData.BasedOn = "CashTransferOrder"
				Or FillingData.BasedOn = "IncomingPaymentOrder"
				Or FillingData.BasedOn = "SalesInvoice"
				Or FillingData.BasedOn = "SalesOrder"
				Or FillingData.BasedOn = "PurchaseReturn"
				Or FillingData.BasedOn = "SalesReportFromTradeAgent"
				Or FillingData.BasedOn = "EmployeeCashAdvance" Then
					ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
					Filling_BasedOn(FillingData);
			EndIf;
		ElsIf FillingData.Property("Context") Then
			FillingDataStructure = BuilderAPI.GetWrapperFromContext(FillingData.Context).Object;
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingDataStructure);
			Filling_BasedOn(FillingDataStructure);
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

Procedure OnCopy(CopiedObject)
	RRNCode = "";
	PaymentInfo = "";
EndProcedure
