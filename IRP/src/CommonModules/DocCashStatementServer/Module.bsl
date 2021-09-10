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
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
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

	Query = New Query();
	Query.Text =
	"SELECT
	|	R3010B_CashOnHandTurnovers.Recorder AS Document,
	|	SUM(R3010B_CashOnHandTurnovers.AmountExpense) AS Expense,
	|	SUM(R3010B_CashOnHandTurnovers.AmountReceipt) AS Receipt
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.Turnovers(&BegOfPeriod, &EndOfPeriod, Record,
	|		Account.Branch = &Branch
	|	AND Company = &Company) AS R3010B_CashOnHandTurnovers
	|WHERE
	|	R3010B_CashOnHandTurnovers.Account.Type = VALUE(Enum.CashAccountTypes.Cash)
	|	AND
	|		R3010B_CashOnHandTurnovers.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	R3010B_CashOnHandTurnovers.Recorder
	|ORDER BY
	|	R3010B_CashOnHandTurnovers.Recorder.Date";

	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("Branch", Object.Branch);
	Query.SetParameter("Company", Object.Company);
	CashTransactionList = Query.Execute().Unload();
	Object.CashTransactionList.Load(CashTransactionList);

	Query = New Query();
	Query.Text =
	"SELECT
	|	R3050T_RetailCash.PaymentType AS PaymentType,
	|	R3050T_RetailCash.Account AS Account,
	|	R3050T_RetailCash.AmountTurnover AS Amount,
	|	R3050T_RetailCash.CommissionTurnover AS Commission,
	|	R3050T_RetailCash.Account.Currency AS Currency
	|FROM
	|	AccumulationRegister.R3050T_RetailCash.Turnovers(BEGINOFPERIOD(&BegOfPeriod, DAY), ENDOFPERIOD(&EndOfPeriod, DAY),,
	|		Company = &Company
	|	AND Branch = &Branch) AS R3050T_RetailCash";

	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("Branch", Object.Branch);
	Query.SetParameter("Company", Object.Company);
	QueryResult = Query.Execute().Unload();
	Object.PaymentList.Load(QueryResult);

	Object.Currencies.Clear();
	For Each Row In Object.PaymentList Do
		Row.Key = New UUID();
		If Row.Account.Type = Enums.CashAccountTypes.POS Then
			CurrenciesServer.FillCurrencyTable(Object, Object.Date, Object.Company, Row.Currency, Row.Key, Undefined);
			CurrenciesServer.CalculateAmount(Object, Row.Amount, Row.Key, Undefined);
		EndIf;
	EndDo;

	RecalculateClosingBalance(Object);

EndProcedure

Procedure RecalculateClosingBalance(Object)
	Object.ClosingBalance = Object.OpeningBalance + Object.CashTransactionList.Total("Receipt")
		- Object.CashTransactionList.Total("Expense");
EndProcedure

Procedure FillOnBasisDocument(Object, AddInfo = Undefined) Export

	Object.OpeningBalance = Object.BasisDocument.ClosingBalance;
	RecalculateClosingBalance(Object);
EndProcedure
#EndRegion