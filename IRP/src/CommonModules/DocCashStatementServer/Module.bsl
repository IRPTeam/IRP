#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;	
	SetGroupItemsList(Object, Form);	
	ViewServer_V2.OnCreateAtServer(Object, Form, "");
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
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

Procedure FillTransactions(Object) Export

	// CashTransactionList
	Query = New Query();
	Query.Text =
	"SELECT
	|	R3010B_CashOnHandTurnovers.Recorder AS Document,
	|	R3010B_CashOnHandTurnovers.Recorder.Date AS Date,
	|	SUM(R3010B_CashOnHandTurnovers.AmountExpense) AS Expense,
	|	SUM(R3010B_CashOnHandTurnovers.AmountReceipt) AS Receipt
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.Turnovers(&BegOfPeriod, &EndOfPeriod, Record,
	|		Account.Branch = &Branch
	|	AND Company = &Company AND Account.Type = VALUE(Enum.CashAccountTypes.Cash) AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS R3010B_CashOnHandTurnovers
	|GROUP BY
	|	R3010B_CashOnHandTurnovers.Recorder,
	|	R3010B_CashOnHandTurnovers.Recorder.Date
	|ORDER BY
	|	R3010B_CashOnHandTurnovers.Recorder.Date";

	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("Branch", Object.Branch);
	Query.SetParameter("Company", Object.Company);
	CashTransactionList = Query.Execute().Unload();
	Object.CashTransactionList.Load(CashTransactionList);

	// PaymentList
	Query = New Query();
	Query.Text =
	"SELECT
	|	R3050T_PosCashBalances.PaymentType AS PaymentType,
	|	R3050T_PosCashBalances.Account AS Account,
	|	R3050T_PosCashBalances.AmountTurnover AS Amount,
	|	R3050T_PosCashBalances.CommissionTurnover AS Commission,
	|	R3050T_PosCashBalances.Account.Currency AS Currency,
	|	R3050T_PosCashBalances.PaymentTerminal
	|FROM
	|	AccumulationRegister.R3050T_PosCashBalances.Turnovers(BEGINOFPERIOD(&BegOfPeriod, DAY), ENDOFPERIOD(&EndOfPeriod,
	|		DAY),, Company = &Company
	|	AND Branch = &Branch) AS R3050T_PosCashBalances";

	Query.SetParameter("BegOfPeriod", Object.BegOfPeriod);
	Query.SetParameter("EndOfPeriod", Object.EndOfPeriod);
	Query.SetParameter("Branch", Object.Branch);
	Query.SetParameter("Company", Object.Company);
	
	QueryTable = Query.Execute().Unload();
	ArrayOfFillingRows = New Array();
	Object.PaymentList.Clear();
	
	For Each Row In QueryTable Do
		NewRow = Object.PaymentList.Add();
		NewRow.Key = New UUID();
		FillPropertyValues(NewRow, Row);
		ArrayOfFillingRows.Add(NewRow);
	EndDo;
		
	ArrayOfFillingColumns = New Array();
	ArrayOfFillingColumns.Add("PaymentList.PaymentType");
	ArrayOfFillingColumns.Add("PaymentList.PaymentTerminal");
	ArrayOfFillingColumns.Add("PaymentList.Account");
	ArrayOfFillingColumns.Add("PaymentList.Amount");
	ArrayOfFillingColumns.Add("PaymentList.Commission");
	ArrayOfFillingColumns.Add("PaymentList.Currency");
	
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
	ServerParameters.TableName = "PaymentList";
	ServerParameters.IsBasedOn = True;
	ServerParameters.ReadOnlyProperties = StrConcat(ArrayOfFillingColumns, ",");
	ServerParameters.Rows = ArrayOfFillingRows;
		
	Parameters = ControllerClientServer_V2.GetParameters(ServerParameters);
	For Each PropertyName In StrSplit(ServerParameters.ReadOnlyProperties, ",") Do
		Property = New Structure("DataPath", TrimAll(PropertyName));
		ControllerClientServer_V2.API_SetProperty(Parameters, Property, Undefined);
	EndDo;
	
	RecalculateClosingBalance(Object);
EndProcedure

Procedure RecalculateClosingBalance(Object)
	Object.ClosingBalance = Object.OpeningBalance + Object.CashTransactionList.Total("Receipt")
		- Object.CashTransactionList.Total("Expense");
EndProcedure

Procedure FillOnBasisDocument(Object) Export
	Object.OpeningBalance = Object.BasisDocument.ClosingBalance;
	RecalculateClosingBalance(Object);
EndProcedure

#EndRegion
