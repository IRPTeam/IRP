
Procedure OffsetOfAdvanceFromCustomers_OnTransaction(Parameters) Export	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	AdvancesFromCustomers_Lock.Period,
	|	AdvancesFromCustomers_Lock.Company,
	|	AdvancesFromCustomers_Lock.Partner,
	|	AdvancesFromCustomers_Lock.LegalName,
	|	AdvancesFromCustomers_Lock.Currency,
	|	AdvancesFromCustomers_Lock.TransactionDocument,
	|	AdvancesFromCustomers_Lock.Agreement,
	|	SUM(AdvancesFromCustomers_Lock.DocumentAmount) AS DocumentAmount,
	|	R2020B_AdvancesFromCustomersBalance.Basis AS ReceiptDocument,
	|	SUM(R2020B_AdvancesFromCustomersBalance.AmountBalance) AS BalanceAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.R2020B_AdvancesFromCustomers.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			AdvancesFromCustomers_Lock.Company,
	|			AdvancesFromCustomers_Lock.Partner,
	|			AdvancesFromCustomers_Lock.LegalName,
	|			AdvancesFromCustomers_Lock.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			AdvancesFromCustomers_Lock AS AdvancesFromCustomers_Lock)) AS R2020B_AdvancesFromCustomersBalance
	|		LEFT JOIN AdvancesFromCustomers_Lock AS AdvancesFromCustomers_Lock
	|		ON R2020B_AdvancesFromCustomersBalance.Company = AdvancesFromCustomers_Lock.Company
	|		AND R2020B_AdvancesFromCustomersBalance.Partner = AdvancesFromCustomers_Lock.Partner
	|		AND R2020B_AdvancesFromCustomersBalance.LegalName = AdvancesFromCustomers_Lock.LegalName
	|		AND R2020B_AdvancesFromCustomersBalance.Currency = AdvancesFromCustomers_Lock.Currency
	|		AND
	|			R2020B_AdvancesFromCustomersBalance.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	AdvancesFromCustomers_Lock.Period,
	|	AdvancesFromCustomers_Lock.Company,
	|	AdvancesFromCustomers_Lock.Partner,
	|	AdvancesFromCustomers_Lock.LegalName,
	|	AdvancesFromCustomers_Lock.Currency,
	|	AdvancesFromCustomers_Lock.TransactionDocument,
	|	AdvancesFromCustomers_Lock.Agreement,
	|	R2020B_AdvancesFromCustomersBalance.Basis,
	|	VALUE(AccumulationRecordType.Expense)
	|ORDER BY
	|	R2020B_AdvancesFromCustomersBalance.Basis.Date,
	|	AdvancesFromCustomers_Lock.Period";
	 
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));

	QueryResult = Query.Execute();	
	QueryTable = QueryResult.Unload();
	
	Table_OffsetOfAdvance = QueryTable.CopyColumns();
	
	QueryTable_Grupped = QueryTable.Copy();
	
	FilterFields = 
		"Period, 
		|Company,
		|Partner, 
		|LegalName, 
		|Currency,  
		|TransactionDocument, 
		|Agreement,
		|DocumentAmount, 
		|Amount"; 
	QueryTable_Grupped.GroupBy(FilterFields);
	For Each Row In QueryTable_Grupped Do
		NeedWriteOff = Row.DocumentAmount;
		Filter = New Structure(FilterFields);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = QueryTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.AmountBalance > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.AmountBalance, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.AmountBalance = ItemOfArray.AmountBalance - CanWriteOff;
			
			NewRow = Table_OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Amount = CanWriteOff;
			
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	
	Query.Text = 
	"SELECT
	|	Table_OffsetOfAdvance.Period,
	|	Table_OffsetOfAdvance.Company,
	|	Table_OffsetOfAdvance.Partner,
	|	Table_OffsetOfAdvance.LegalName,
	|	Table_OffsetOfAdvance.Currency,
	|	Table_OffsetOfAdvance.TransactionDocument,
	|	Table_OffsetOfAdvance.ReceiptDocument,
	|	Table_OffsetOfAdvance.Agreement,
	|	Table_OffsetOfAdvance.Amount
	|INTO
	|	OffsetOfAdvance
	|FROM 
	|	&Table_OffsetOfAdvance AS Table_OffsetOfAdvance";
	Query.SetParameter("Table_OffsetOfAdvance", Table_OffsetOfAdvance);
	Query.Execute();	
EndProcedure
