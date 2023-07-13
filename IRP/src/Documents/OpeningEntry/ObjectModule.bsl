Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	TotalTable = New ValueTable();
	TotalTable.Columns.Add("Key");
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("AccountBalance");
	ArrayOfTableNames.Add("AdvanceFromCustomers");
	ArrayOfTableNames.Add("AdvanceToSuppliers");
	ArrayOfTableNames.Add("AccountReceivableByAgreements");
	ArrayOfTableNames.Add("AccountReceivableByDocuments");
	ArrayOfTableNames.Add("AccountPayableByAgreements");
	ArrayOfTableNames.Add("AccountPayableByDocuments");
	ArrayOfTableNames.Add("ShipmentToTradeAgent");
	ArrayOfTableNames.Add("ReceiptFromConsignor");
	ArrayOfTableNames.Add("EmployeeCashAdvance");
	ArrayOfTableNames.Add("AdvanceFromRetailCustomers");
	ArrayOfTableNames.Add("SalaryPayment");
	ArrayOfTableNames.Add("AccountReceivableOther");
	ArrayOfTableNames.Add("AccountPayableOther");
	ArrayOfTableNames.Add("CashInTransit");
	
	For Each TableName In ArrayOfTableNames Do
		For Each Row In ThisObject[TableName] Do
			TotalTable.Add().Key = Row.Key;
		EndDo;
	EndDo;
		
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, TotalTable);
	
	For Each Row In ThisObject.AccountBalance Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.CashInTransit Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;	
	For Each Row In ThisObject.AdvanceFromCustomers Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AdvanceToSuppliers Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AccountReceivableByAgreements Do
		Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AccountReceivableByDocuments Do
		Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AccountReceivableOther Do
		Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;	
	For Each Row In ThisObject.AccountPayableByAgreements Do
		Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AccountPayableByDocuments Do
		Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AccountPayableOther Do
		Parameters = CurrenciesClientServer.GetParameters_V4(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;	
	For Each Row In ThisObject.ReceiptFromConsignor Do
		Parameters = CurrenciesClientServer.GetParameters_V9(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.EmployeeCashAdvance Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.AdvanceFromRetailCustomers Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	For Each Row In ThisObject.SalaryPayment Do
		Parameters = CurrenciesClientServer.GetParameters_V6(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
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
	For Each Row In ThisObject.AccountReceivableByDocuments Do
		ArrayOfPaymentTerms = ThisObject.CustomersPaymentTerms.FindRows(New Structure("Key", Row.Key));
		AmountPaymentTerms = 0;
		For Each RowPaymentTerms In ArrayOfPaymentTerms Do
			AmountPaymentTerms = AmountPaymentTerms + RowPaymentTerms.Amount;
		EndDo;
		If AmountPaymentTerms <> 0 And Row.Amount <> AmountPaymentTerms Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
			StrTemplate(R().Error_086, Row.Amount, AmountPaymentTerms), "AccountReceivableByDocuments[" + Format(
			(Row.LineNumber - 1), "NZ=0; NG=0;") + "].Amount", ThisObject);
		EndIf;
	EndDo;

	For Each Row In ThisObject.AccountPayableByDocuments Do
		ArrayOfPaymentTerms = ThisObject.VendorsPaymentTerms.FindRows(New Structure("Key", Row.Key));
		AmountPaymentTerms = 0;
		For Each RowPaymentTerms In ArrayOfPaymentTerms Do
			AmountPaymentTerms = AmountPaymentTerms + RowPaymentTerms.Amount;
		EndDo;
		If AmountPaymentTerms <> 0 And Row.Amount <> AmountPaymentTerms Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
			StrTemplate(R().Error_086, Row.Amount, AmountPaymentTerms), "AccountPayableByDocuments[" + Format(
			(Row.LineNumber - 1), "NZ=0; NG=0;") + "].Amount", ThisObject);
		EndIf;
	EndDo;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	Inventory.LineNumber AS LineNumber,
	|	CAST(Inventory.Store AS Catalog.Stores) AS Store
	|into ttInventory
	|FROM
	|	&Inventory AS Inventory
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Inventory.LineNumber AS LineNumber,
	|	Inventory.Store AS Store,
	|	Inventory.Store.Company AS StoreCompany
	|FROM
	|	ttInventory AS Inventory
	|
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Inventory", ThisObject.Inventory.Unload());
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
			Cancel = True;
			MessageText = StrTemplate(
				R().Error_Store_Company_Row,
				QuerySelection.Store,
				ThisObject.Company, 
				QuerySelection.LineNumber);
			CommonFunctionsClientServer.ShowUsersMessage(
				MessageText, 
				"Object.Inventory[" + (QuerySelection.LineNumber - 1) + "].Store", 
				"Object.Inventory");
		EndIf;
	EndDo;
	
EndProcedure