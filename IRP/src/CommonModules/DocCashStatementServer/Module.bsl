#Region FormEvents

Procedure AfterWriteAtServer(Object, CurrentObject, WriteParameters) Export
	Return;
EndProcedure

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	DocLabelingServer.CreateCommandsAndItems(Object);
	SetGroupItemsList(Object, Form);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("BusinessUnit");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemFormEvents

Procedure FillTransactions(Object, AddInfo = Undefined) Export

	Query = New Query;
	Query.Text =
		"SELECT
		|	AccountBalanceTurnovers.Recorder AS Document,
		|	AccountBalanceTurnovers.AmountExpense AS Expense,
		|	AccountBalanceTurnovers.AmountReceipt AS Receipt
		|FROM
		|	AccumulationRegister.AccountBalance.Turnovers(&BegOfPeriod, &EndOfPeriod, Record,
		|		Account.BusinessUnit = &BusinessUnit AND Company = &Company) AS AccountBalanceTurnovers";
	
	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("BusinessUnit", Object.BusinessUnit);
	Query.SetParameter("Company", Object.Company);
	QueryResult = Query.Execute().Unload();
	Object.CashTransactionList.Load(QueryResult);
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	RetailCash.PaymentType,
		|	RetailCash.Account,
		|	SUM(RetailCash.Amount) AS Amount,
		|	SUM(RetailCash.Commission) AS Commission,
		|	RetailCash.Account.Currency AS Currency
		|FROM
		|	AccumulationRegister.RetailCash AS RetailCash
		|WHERE
		|	RetailCash.Company = &Company
		|	AND RetailCash.BusinessUnit = &BusinessUnit
		|	AND RetailCash.Period BETWEEN &BegOfPeriod AND &EndOfPeriod
		|GROUP BY
		|	RetailCash.PaymentType,
		|	RetailCash.Account,
		|	RetailCash.Account.Currency";
	
	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("BusinessUnit", Object.BusinessUnit);
	Query.SetParameter("Company", Object.Company);
	QueryResult = Query.Execute().Unload();
	Object.PaymentList.Load(QueryResult);	
	
	Object.Currencies.Clear();
	For Each Row In Object.PaymentList Do
		Row.Key = New UUID;
		If Row.Account.Type = Enums.CashAccountTypes.POS Then
			CurrenciesServer.FillCurrencyTable(Object, Object.Date, Object.Company, Row.Currency, Row.Key, Undefined);
			CurrenciesServer.CalculateAmount(Object, Row.Amount, Row.Key, Undefined);
		EndIf; 
	EndDo;
EndProcedure

#EndRegion