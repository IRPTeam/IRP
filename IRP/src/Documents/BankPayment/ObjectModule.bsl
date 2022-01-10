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
	
//	AccountingClientServer.DeleteUnusedRowsFromAnalyticsTable(ThisObject, "PaymentList");
//	CompanyLadgerTypes = AccountingServer.GetLadgerTypesByCompany(ThisObject);
	
	If WriteMode = DocumentWriteMode.Posting Then
		ArrayOfIdentifiers = New Array();
		ArrayOfIdentifiers.Add("Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts");
		AccountingClientServer.BeforeWriteAccountingDocument(ThisObject, "PaymentList", ArrayOfIdentifiers);
	EndIf;
	
//	Identifier = "Dr_PartnerTBAccounts_Cr_CashAccountTBAccounts";
//	For Each LadgerType In CompanyLadgerTypes Do
//		
//		For Each Row In ThisObject.PaymentList Do
//			
//			AnalyticRow = Undefined;
//			Filter = New Structure();
//			Filter.Insert("Key"       , Row.Key);
//			Filter.Insert("Identifier", Identifier);
//			Filter.Insert("LadgerType", LadgerType);
//			AnalyticRows = ThisObject.AccountingRowAnalytics.FindRows(Filter);
//			If AnalyticRows.Count() > 1 Then
//				Raise StrTemplate("More than 1 analytic rows by filter: Key[%1] Identifier[%2] LadgerType[%3]",
//					Filter.Key, Filter.Identifier, Filter.LadgerType);
//			ElsIf AnalyticRows.Count() = 1 Then
//				AnalyticRow = AnalyticRows[0];
//				If AnalyticRow.IsFixed Then
//					Continue;
//				EndIf;
//			EndIf;
//			AnalyticData = AccountingClientServer.GetAccountingAnalytics(ThisObject, Row, Identifier, LadgerType);
//			
//			If AnalyticRow = Undefined Then
//				AnalyticRow = ThisObject.AccountingRowAnalytics.Add();
//				AnalyticRow.Key = Row.Key;
//				AccountingClientServer.FillAccountingAnalytics(AnalyticRow, AnalyticData, ThisObject.AccountingExtDimensions);
//			Else
//				If AccountingClientServer.AccountingAnalyticsIsChanged(AnalyticRow, AnalyticData, ThisObject.AccountingExtDimensions) Then
//					AccountingClientServer.FillAccountingAnalytics(AnalyticRow, AnalyticData, ThisObject.AccountingExtDimensions);
//				EndIf;
//			EndIf;
//			
//		EndDo;
//	EndDo;
	
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