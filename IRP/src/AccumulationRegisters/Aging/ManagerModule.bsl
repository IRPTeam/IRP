Function GetLockFields(Data) Export
	Result = New Structure();
	Result.Insert("RegisterName", "AccumulationRegister.Aging");
	Result.Insert("LockInfo", New Structure("Data, Fields", 
	Data, PostingServer.GetLockFieldsMap(GetLockFieldNames())));
	Return Result;
EndFunction

Function GetLockFieldNames() Export
	Return "Company, Partner, Agreement, Invoice, PaymentDate, Currency";
EndFunction

Function GetTableAging_Expense_OnSalesInvoice(PartnerArTransactions_OffsetOfAdvance, Aging_Receipt) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Aging_Receipt.Period,
	|	Aging_Receipt.Company,
	|	Aging_Receipt.Partner,
	|	Aging_Receipt.Agreement,
	|	Aging_Receipt.Invoice,
	|	Aging_Receipt.PaymentDate,
	|	Aging_Receipt.Currency,
	|	Aging_Receipt.Amount
	|INTO Aging_Receipt
	|FROM
	|	&Aging_Receipt AS Aging_Receipt
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PartnerArTransactions_OffsetOfAdvance.Company,
	|	PartnerArTransactions_OffsetOfAdvance.Partner,
	|	PartnerArTransactions_OffsetOfAdvance.Agreement,
	|	PartnerArTransactions_OffsetOfAdvance.BasisDocument,
	|	PartnerArTransactions_OffsetOfAdvance.Currency,
	|	PartnerArTransactions_OffsetOfAdvance.Amount,
	|	PartnerArTransactions_OffsetOfAdvance.ReceiptDocument
	|INTO PartnerArTransactions_OffsetOfAdvance
	|FROM
	|	&PartnerArTransactions_OffsetOfAdvance AS PartnerArTransactions_OffsetOfAdvance
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Aging_Receipt.Period,
	|	Aging_Receipt.Company,
	|	Aging_Receipt.Partner,
	|	Aging_Receipt.Agreement,
	|	Aging_Receipt.Invoice,
	|	Aging_Receipt.PaymentDate AS PaymentDate,
	|	Aging_Receipt.Currency,
	|	Aging_Receipt.Amount AS DueAmount,
	|	PartnerArTransactions_OffsetOfAdvance.Amount AS Amount_OffsetOfAdvance,
	|	PartnerArTransactions_OffsetOfAdvance.ReceiptDocument AS ReceiptDocument,
	|	0 AS Amount
	|FROM
	|	Aging_Receipt AS Aging_Receipt
	|		INNER JOIN PartnerArTransactions_OffsetOfAdvance AS PartnerArTransactions_OffsetOfAdvance
	|		ON Aging_Receipt.Company = PartnerArTransactions_OffsetOfAdvance.Company
	|		AND Aging_Receipt.Partner = PartnerArTransactions_OffsetOfAdvance.Partner
	|		AND Aging_Receipt.Agreement = PartnerArTransactions_OffsetOfAdvance.Agreement
	|		AND Aging_Receipt.Invoice = PartnerArTransactions_OffsetOfAdvance.BasisDocument
	|		AND Aging_Receipt.Currency = PartnerArTransactions_OffsetOfAdvance.Currency
	|ORDER BY
	|	PaymentDate";
	
	Query.SetParameter("Aging_Receipt", Aging_Receipt);
	Query.SetParameter("PartnerArTransactions_OffsetOfAdvance", PartnerArTransactions_OffsetOfAdvance);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable_Grupped = QueryTable.Copy();
	QueryTable_Grupped.GroupBy("ReceiptDocument, Amount_OffsetOfAdvance");
	QueryTable.GroupBy("Period, Company, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	For Each Row_Advance In QueryTable_Grupped Do
		NeedWriteOff = Row_Advance.Amount_OffsetOfAdvance;
		For Each Row In QueryTable Do
			If Not NeedWriteOff > 0 Then
				Break;
			EndIf;
			If Row.DueAmount > 0 Then
				CanWriteOff   = Min(Row.DueAmount, NeedWriteOff);
				NeedWriteOff  = NeedWriteOff - CanWriteOff;
				Row.DueAmount = Row.DueAmount - CanWriteOff;
				Row.Amount    = Row.Amount + CanWriteOff;
			EndIf;
		EndDo;
	EndDo;
	
	ArrayForDelete = New Array();
	For Each Row In QueryTable Do
		If Not ValueIsFilled(Row.Amount) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemOfArray In ArrayForDelete Do
		QueryTable.Delete(ItemOfArray);
	EndDo;
	
	Return QueryTable;
EndFunction

Function GetTableAging_Expense_OnMoneyReceipt(PointInTime, PartnerArTransactions, PartnerArTransactions_OffsetOfAdvance) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PartnerArTransactions.Period,
	|	PartnerArTransactions.Company,
	|	PartnerArTransactions.BasisDocument,
	|	PartnerArTransactions.Partner,
	|	PartnerArTransactions.LegalName,
	|	PartnerArTransactions.Agreement,
	|	PartnerArTransactions.Currency,
	|	PartnerArTransactions.Amount
	|INTO PartnerArTransactions
	|FROM
	|	&PartnerArTransactions AS PartnerArTransactions
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PartnerArTransactions_OffsetOfAdvance.Period,
	|	PartnerArTransactions_OffsetOfAdvance.Company,
	|	PartnerArTransactions_OffsetOfAdvance.BasisDocument,
	|	PartnerArTransactions_OffsetOfAdvance.Partner,
	|	PartnerArTransactions_OffsetOfAdvance.LegalName,
	|	PartnerArTransactions_OffsetOfAdvance.Agreement,
	|	PartnerArTransactions_OffsetOfAdvance.Currency,
	|	PartnerArTransactions_OffsetOfAdvance.Amount
	|INTO PartnerArTransactions_OffsetOfAdvance
	|FROM
	|	&PartnerArTransactions_OffsetOfAdvance AS PartnerArTransactions_OffsetOfAdvance
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PartnerArTransactions.Period,
	|	PartnerArTransactions.Company,
	|	PartnerArTransactions.BasisDocument,
	|	PartnerArTransactions.Partner,
	|	PartnerArTransactions.LegalName,
	|	PartnerArTransactions.Agreement,
	|	PartnerArTransactions.Currency,
	|	PartnerArTransactions.Amount
	|INTO Transactions
	|FROM
	|	PartnerArTransactions AS PartnerArTransactions
	|
	|UNION ALL
	|
	|SELECT
	|	PartnerArTransactions_OffsetOfAdvance.Period,
	|	PartnerArTransactions_OffsetOfAdvance.Company,
	|	PartnerArTransactions_OffsetOfAdvance.BasisDocument,
	|	PartnerArTransactions_OffsetOfAdvance.Partner,
	|	PartnerArTransactions_OffsetOfAdvance.LegalName,
	|	PartnerArTransactions_OffsetOfAdvance.Agreement,
	|	PartnerArTransactions_OffsetOfAdvance.Currency,
	|	PartnerArTransactions_OffsetOfAdvance.Amount
	|FROM
	|	PartnerArTransactions_OffsetOfAdvance AS PartnerArTransactions_OffsetOfAdvance
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.BasisDocument,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency,
	|	SUM(Transactions.Amount) AS Amount
	|INTO TransactionsGrupped
	|FROM
	|	Transactions AS Transactions
	|GROUP BY
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.BasisDocument,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsGrupped.Period,
	|	AgingBalance.Company,
	|	AgingBalance.Partner,
	|	AgingBalance.Agreement,
	|	AgingBalance.Invoice,
	|	AgingBalance.PaymentDate AS PaymentDate,
	|	AgingBalance.Currency,
	|	AgingBalance.AmountBalance AS DueAmount,
	|	TransactionsGrupped.Amount AS ReceiptAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.Aging.Balance(&Period, (Company, Partner, Agreement, Invoice, Currency) IN
	|		(SELECT
	|			TransactionsGrupped.Company,
	|			TransactionsGrupped.Partner,
	|			TransactionsGrupped.Agreement,
	|			TransactionsGrupped.BasisDocument,
	|			TransactionsGrupped.Currency
	|		FROM
	|			TransactionsGrupped AS TransactionsGrupped)) AS AgingBalance
	|		INNER JOIN TransactionsGrupped AS TransactionsGrupped
	|		ON AgingBalance.Company = TransactionsGrupped.Company
	|		AND AgingBalance.Partner = TransactionsGrupped.Partner
	|		AND AgingBalance.Agreement = TransactionsGrupped.Agreement
	|		AND AgingBalance.Invoice = TransactionsGrupped.BasisDocument
	|		AND AgingBalance.Currency = TransactionsGrupped.Currency
	|ORDER BY
	|	PaymentDate";
	Query.SetParameter("Period", PointInTime);
	Query.SetParameter("PartnerArTransactions", PartnerArTransactions);
	Query.SetParameter("PartnerArTransactions_OffsetOfAdvance", PartnerArTransactions_OffsetOfAdvance);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable_Grupped = QueryTable.Copy();
	QueryTable_Grupped.GroupBy("Invoice, ReceiptAmount");
	QueryTable.GroupBy("Period, Company, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	For Each Row In QueryTable_Grupped Do
		NeedWriteOff = Row.ReceiptAmount;
		ArrayOfRows = QueryTable.FindRows(New Structure("Invoice", Row.Invoice));
		For Each ItemOfArray In ArrayOfRows Do
			If Not NeedWriteOff > 0 Then
				Break;
			EndIf;
			If ItemOfArray.DueAmount > 0 Then
				CanWriteOff   = Min(ItemOfArray.DueAmount, NeedWriteOff);
				NeedWriteOff  = NeedWriteOff - CanWriteOff;
				ItemOfArray.DueAmount = ItemOfArray.DueAmount - CanWriteOff;
				ItemOfArray.Amount    = ItemOfArray.Amount + CanWriteOff;
			EndIf;
		EndDo;
	EndDo;
	
	ArrayForDelete = New Array();
	For Each Row In QueryTable Do
		If Not ValueIsFilled(Row.Amount) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemOfArray In ArrayForDelete Do
		QueryTable.Delete(ItemOfArray);
	EndDo;
	
	Return QueryTable;
EndFunction

