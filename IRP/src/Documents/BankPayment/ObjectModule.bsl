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
	
	AccountingClientServer.DeleteUnusedRowsFromAnalyticsTable(ThisObject.AccountingRowAnalytics, ThisObject.PaymentList);
	UserDefinedAnalytics = Undefined;
	ThisObject.AdditionalProperties.Property("AccountingRowAnalytics", UserDefinedAnalytics);
	CompanyLadgerTypes = AccountingServer.GetLadgerTypesByCompany(ThisObject);
	
	For Each LadgerType In CompanyLadgerTypes Do
	For Each Row In ThisObject.PaymentList Do
		// Identifier - Analytics_CashOnHand
		AnalyticRow = Undefined;
		If UserDefinedAnalytics <> Undefined Then
			AnalyticRows = UserDefinedAnalytics.FindRows(
			New Structure("Key, LadgerType, Identifier", Row.Key, LadgerType, "Analytics_CashOnHand"));
			If AnalyticRows.Count() Then
				AnalyticRow = AnalyticRows[0];
			EndIf;
		EndIf;
		
		If AnalyticRow = Undefined Then
			Parameters = AccountingClientServer.GetParameters(ThisObject, Row, "AccountingRowAnalytics");
			For Each AccountingAnalytic In Parameters.AccountingAnalytics Do
				If AccountingAnalytic.LadgerType = LadgerType 
					And AccountingAnalytic.Identifier = "Analytics_CashOnHand" Then
					AnalyticRow = AccountingAnalytic;
				EndIf;
			EndDo;
		EndIf;
		
		If AnalyticRow = Undefined Then
			Continue;
		EndIf;
		
		UpdateCatalogAccountingAnalytics = False;
		ObjectCatalogAccountingAnalytics = Undefined;
		
		ExistsAnalyticRow = Undefined;
		ExistsAnalyticRows = ThisObject["AccountingRowAnalytics"].FindRows(
			New Structure("Key, LadgerType", Row.Key, LadgerType));
		If ExistsAnalyticRows.Count() Then
			ExistsAnalyticRow = ExistsAnalyticRows[0];
			
			
		Else
			ExistsAnalyticRow = ThisObject["AccountingRowAnalytics"].Add();
			ExistsAnalyticRow.Key = Row.Key;
			ExistsAnalyticRow.LadgerType = LadgerType;
			
			ObjectCatalogAccountingAnalytics = Catalogs.AccountingAnalytics.CreateItem();
			UpdateCatalogAccountingAnalytics = True;
		EndIf;
		
		If UpdateCatalogAccountingAnalytics Then
			FillPropertyValues(ObjectCatalogAccountingAnalytics, AnalyticRow);
			ObjectCatalogAccountingAnalytics.Write();
		EndIf;
		ExistsAnalyticRow["Analytics_CashOnHand"] = ObjectCatalogAccountingAnalytics.Ref;
		
	EndDo;
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
	DocumentsServer.FillCheckBankCashDocuments(ThisObject, CheckedAttributes);
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		If FillingData.BasedOn = "CashTransferOrder" Or FillingData.BasedOn = "OutgoingPaymentOrder"
			Or FillingData.BasedOn = "PurchaseInvoice" Or FillingData.BasedOn = "PurchaseOrder" Then
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
	ThisObject.Company         = FillingData.Company;
	ThisObject.Account         = FillingData.Account;
	ThisObject.TransitAccount  = FillingData.TransitAccount;
	ThisObject.Currency        = FillingData.Currency;
	ThisObject.TransactionType = FillingData.TransactionType;
	For Each Row In FillingData.PaymentList Do
		NewRow = ThisObject.PaymentList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	ThisObject.DocumentAmount = ThisObject.PaymentList.Total("TotalAmount");
EndProcedure