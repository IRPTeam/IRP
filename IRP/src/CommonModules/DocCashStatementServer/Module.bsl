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
		|	RetailCashTurnovers.Recorder AS Document,
		|	CASE
		|		When SUM(RetailCashTurnovers.AmountReceipt) < 0
		|			Then -SUM(RetailCashTurnovers.AmountReceipt)
		|		Else SUM(RetailCashTurnovers.AmountExpense)
		|	End AS Expense,
		|	CASE
		|		When SUM(RetailCashTurnovers.AmountReceipt) < 0
		|			Then 0
		|		Else SUM(RetailCashTurnovers.AmountReceipt)
		|	End AS Receipt
		|FROM
		|	AccumulationRegister.RetailCash.Turnovers(&BegOfPeriod, &EndOfPeriod, Record, Company = &Company
		|	And BusinessUnit = &BusinessUnit) AS RetailCashTurnovers
		|GROUP BY
		|	RetailCashTurnovers.Recorder";
	
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
		|	SUM(RetailCash.Commission) AS Commission
		|FROM
		|	AccumulationRegister.RetailCash AS RetailCash
		|WHERE
		|	RetailCash.Company = &Company
		|	AND RetailCash.BusinessUnit = &BusinessUnit
		|	AND RetailCash.Period BETWEEN &BegOfPeriod AND &EndOfPeriod
		|GROUP BY
		|	RetailCash.PaymentType,
		|	RetailCash.Account";
	
	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("BusinessUnit", Object.BusinessUnit);
	Query.SetParameter("Company", Object.Company);
	QueryResult = Query.Execute().Unload();
	Object.PaymentList.Load(QueryResult);	
	
EndProcedure

#EndRegion