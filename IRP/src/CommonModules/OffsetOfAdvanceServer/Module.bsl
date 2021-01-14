
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
			If Not ItemOfArray.BalanceAmount > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.BalanceAmount, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.BalanceAmount = ItemOfArray.BalanceAmount - CanWriteOff;
			
			NewRow = Table_OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Amount = CanWriteOff;
			NewRow.ReceiptDocument = ItemOfArray.ReceiptDocument;
			
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

Procedure OffsetOfAdvanceFromCustomers_OnAdvance(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
	"SELECT
	|	CustomersTransactions_Lock.Period,
	|	CustomersTransactions_Lock.Company,
	|	CustomersTransactions_Lock.Partner,
	|	CustomersTransactions_Lock.LegalName,
	|	CustomersTransactions_Lock.Currency,
	|	CustomersTransactions_Lock.ReceiptDocument,
	|	CustomersTransactions_Lock.Key,
	|	SUM(CustomersTransactions_Lock.DocumentAmount) AS DocumentAmount,
	|	R2021B_CustomersTransactions.Basis AS TransactionDocument,
	|	R2021B_CustomersTransactions.Basis AS Invoice,
	|	R2021B_CustomersTransactions.Agreement,
	|	SUM(R2021B_CustomersTransactions.AmountBalance) AS BalanceAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			CustomersTransactions_Lock.Company,
	|			CustomersTransactions_Lock.Partner,
	|			CustomersTransactions_Lock.LegalName,
	|			CustomersTransactions_Lock.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			CustomersTransactions_Lock AS CustomersTransactions_Lock)) AS R2021B_CustomersTransactions
	|		INNER JOIN CustomersTransactions_Lock AS CustomersTransactions_Lock
	|		ON CustomersTransactions_Lock.Company = R2021B_CustomersTransactions.Company
	|		AND CustomersTransactions_Lock.Partner = R2021B_CustomersTransactions.Partner
	|		AND CustomersTransactions_Lock.LegalName = R2021B_CustomersTransactions.LegalName
	|		AND CustomersTransactions_Lock.Currency = R2021B_CustomersTransactions.Currency
	|GROUP BY
	|	CustomersTransactions_Lock.Period,
	|	CustomersTransactions_Lock.Company,
	|	CustomersTransactions_Lock.Partner,
	|	CustomersTransactions_Lock.LegalName,
	|	CustomersTransactions_Lock.Currency,
	|	CustomersTransactions_Lock.ReceiptDocument,
	|	CustomersTransactions_Lock.Key,
	|	R2021B_CustomersTransactions.Basis,
	|	R2021B_CustomersTransactions.Agreement
	|ORDER BY
	|	CustomersTransactions_Lock.Period,
	|	R2021B_CustomersTransactions.Basis.Date";
	
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
		
	CustomersTransactionsBalanceResult = Query.Execute();
	CustomersTransactionsBalanceTable = CustomersTransactionsBalanceResult.Unload();
	
	FilterFields = 
		"Company,
		|Partner,
		|Agreement,
		|LegalName,
		|Currency,
		|Basis";
	CustomersTransactions = PostingServer.GetQueryTableByName("CustomersTransactions", Parameters);	
	For Each Row In CustomersTransactions Do
		Filter = New Structure(FilterFields);
		FillPropertyValues(Filter, Row);
		
		ArrayOfRows = CustomersTransactionsBalanceTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If ItemOfArray.BalanceAmount < Row.Amount Then
				ItemOfArray.BalanceAmount = 0;
			Else
				ItemOfArray.BalanceAmount = ItemOfArray.BalanceAmount - Row.Amount;
			EndIf;
		EndDo;
		
	EndDo;
	
	DataLock = New DataLock();
	LockFields = AccumulationRegisters.R5011B_PartnersAging.GetLockFields(CustomersTransactionsBalanceTable);
	DataLockItem = DataLock.Add(LockFields.RegisterName);
	DataLockItem.Mode = DataLockMode.Exclusive;
	DataLockItem.DataSource = LockFields.LockInfo.Data;
	For Each Field In LockFields.LockInfo.Fields Do
		DataLockItem.UseFromDataSource(Field.Key, Field.Value);
	EndDo;
	If LockFields.LockInfo.Data.Count() Then
		DataLock.Lock();
		Parameters.Insert("R5011B_PartnersAging_Lock", DataLock);
	EndIf;	

	Query.Text = 
	"SELECT
	|	CustomersTransactionsBalanceTable.Period,
	|	CustomersTransactionsBalanceTable.Company,
	|	CustomersTransactionsBalanceTable.Partner,
	|	CustomersTransactionsBalanceTable.LegalName,
	|	CustomersTransactionsBalanceTable.Currency,
	|	CustomersTransactionsBalanceTable.ReceiptDocument,
	|	CustomersTransactionsBalanceTable.Key,
	|	CustomersTransactionsBalanceTable.DocumentAmount,
	|	CustomersTransactionsBalanceTable.TransactionDocument,
	|	CustomersTransactionsBalanceTable.Agreement,
	|	CustomersTransactionsBalanceTable.BalanceAmount,
	|	CustomersTransactionsBalanceTable.Amount
	|INTO CustomersTransactionsBalanceTable
	|FROM
	|	&CustomersTransactionsBalanceTable AS CustomersTransactionsBalanceTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Period,
	|	tmp.Company,
	|	tmp.Partner,
	|	tmp.LegalName,
	|	tmp.Currency,
	|	tmp.ReceiptDocument,
	|	tmp.Key,
	|	tmp.DocumentAmount,
	|	tmp.TransactionDocument,
	|	tmp.Agreement,
	|	tmp.BalanceAmount AS BalanceAmount,
	|	ISNULL(R5011B_PartnersAgingBalance.AmountBalance, 0) AS AgingBalanceAmount,
	|	CASE
	|		WHEN tmp.TransactionDocument.Date IS NULL
	|			THEN DATETIME(1, 1, 1)
	|		ELSE ISNULL(R5011B_PartnersAgingBalance.PaymentDate, tmp.TransactionDocument.Date)
	|	END AS PriorityDate,
	|	tmp.Amount
	|FROM
	|	CustomersTransactionsBalanceTable AS tmp
	|		LEFT JOIN AccumulationRegister.R5011B_PartnersAging.Balance(&Period, (Company, Partner, Agreement, Invoice,
	|			Currency) IN
	|			(SELECT
	|				tmp.Company,
	|				tmp.Partner,
	|				tmp.Agreement,
	|				tmp.TransactionDocument,
	|				tmp.Currency
	|			FROM
	|				CustomersTransactionsBalanceTable AS tmp)) AS R5011B_PartnersAgingBalance
	|		ON tmp.Company = R5011B_PartnersAgingBalance.Company
	|		AND tmp.Partner = R5011B_PartnersAgingBalance.Partner
	|		AND tmp.Agreement = R5011B_PartnersAgingBalance.Agreement
	|		AND tmp.TransactionDocument = R5011B_PartnersAgingBalance.Invoice
	|		AND tmp.Currency = R5011B_PartnersAgingBalance.Currency
	|ORDER BY
	|	PriorityDate";
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
	Query.SetParameter("CustomersTransactionsBalanceTable", CustomersTransactionsBalanceTable);
	
	AgingBalanceResult = Query.Execute();
	AgingBalanceTable = AgingBalanceResult.Unload();
		
	FilterFields = 
		"Period,
		|Company,
		|Partner,
		|LegalName,
		|Currency,
		|ReceiptDocument,
		|TransactionDocument,
		|Agreement,
		|DocumentAmount,
		|BalanceAmount,
		|Amount";
	
	For Each Row In CustomersTransactionsBalanceTable Do
		NeedWriteOff = Row.BalanceAmount;
		If NeedWriteOff = 0 Then
			Continue;
		EndIf;
		Filter = New Structure(FilterFields);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = AgingBalanceTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.AgingBalanceAmount > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.AgingBalanceAmount, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.AgingBalanceAmount = ItemOfArray.AgingBalanceAmount - CanWriteOff;
			ItemOfArray.BalanceAmount = CanWriteOff;
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	
	Table_OffsetOfAdvance = AgingBalanceTable.CopyColumns();
	Table_Grupped = AgingBalanceTable.Copy();
	
	FilterFields = 
		"Period, 
		|Company,
		|Partner, 
		|LegalName, 
		|Currency, 
		|DocumentAmount, 
		|ReceiptDocument, 
		|Key,
		|Amount"; 
	Table_Grupped.GroupBy(FilterFields);
	For Each Row In Table_Grupped Do
		NeedWriteOff = Row.DocumentAmount;
		If NeedWriteOff = 0 Then
			Continue;
		EndIf;
		Filter = New Structure(FilterFields);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = AgingBalanceTable.FindRows(Filter);
		
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.BalanceAmount > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.BalanceAmount, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.BalanceAmount = ItemOfArray.BalanceAmount - CanWriteOff;
			
			NewRow = Table_OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			
			NewRow.Amount        = CanWriteOff;
			NewRow.Agreement     = ItemOfArray.Agreement;
			NewRow.ReceiptDocument = ItemOfArray.ReceiptDocument;
			NewRow.TransactionDocument = ItemOfArray.TransactionDocument;
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
	|	Table_OffsetOfAdvance.Agreement,
	|	Table_OffsetOfAdvance.TransactionDocument,
	|	Table_OffsetOfAdvance.ReceiptDocument,
	|	Table_OffsetOfAdvance.Key,
	|	Table_OffsetOfAdvance.Amount
	|INTO OffsetOfAdvance
	|FROM
	|	&Table_OffsetOfAdvance AS Table_OffsetOfAdvance"; 
	Query.SetParameter("Table_OffsetOfAdvance", Table_OffsetOfAdvance);
	Query.Execute();
EndProcedure
