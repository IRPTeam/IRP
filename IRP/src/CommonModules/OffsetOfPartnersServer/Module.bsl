
// Parameters:
// 
// -->Input tables:
// 
// CustomersTransactions
//	*Period
//	*Company
//	*Currency
//	*Partner
//	*LegalName
//	*TransactionDocument
//	*Agreement
//	*DocumentAmount
//
// Aging
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *Invoice
//  *PaymentDate
//  *Agreement
//  *Amount
//  
// <--Output tables:
//
// OffsetOfAdvance
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *AdvancesDocument
//  *Agreement
//  *Amount
//
// OffsetOfAging
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *Invoice
//  *PaymentDate
//  *Agreement
//  *Amount
Procedure Customers_OnTransaction(Parameters) Export	
	AdvancesOnTransaction(Parameters, "R2020B_AdvancesFromCustomers" , "CustomersTransactions");

#Region Aging
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;

	Query.Text = 
	"SELECT
	|	Aging.Period,
	|	Aging.Company,
	|	Aging.Partner,
	|	Aging.Agreement,
	|	Aging.Invoice,
	|	Aging.PaymentDate,
	|	Aging.Currency,
	|	Aging.Amount AS DueAmount,
	|	OffsetOfAdvance.Amount AS Amount_OffsetOfAdvance,
	|	OffsetOfAdvance.AdvancesDocument,
	|	0 AS Amount
	|FROM
	|	Aging AS Aging
	|		INNER JOIN OffsetOfAdvance AS OffsetOfAdvance
	|		ON Aging.Company = OffsetOfAdvance.Company
	|		AND Aging.Partner = OffsetOfAdvance.Partner
	|		AND Aging.Agreement = OffsetOfAdvance.Agreement
	|		AND Aging.Invoice = OffsetOfAdvance.TransactionDocument
	|		AND Aging.Currency = OffsetOfAdvance.Currency
	|ORDER BY
	|	PaymentDate";
	
	QueryResult = Query.Execute();
	OffsetOfAging = QueryResult.Unload();
	OffsetOfAging_Groupped = OffsetOfAging.Copy();
	
	OffsetOfAging_Groupped.GroupBy("AdvancesDocument, Amount_OffsetOfAdvance");
	OffsetOfAging.GroupBy("Period, Company, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	
	For Each Row_Advance In OffsetOfAging_Groupped Do
		NeedWriteOff = Row_Advance.Amount_OffsetOfAdvance;
		For Each Row In OffsetOfAging Do
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
	For Each Row In OffsetOfAging Do
		If Not ValueIsFilled(Row.Amount) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemOfArray In ArrayForDelete Do
		OffsetOfAging.Delete(ItemOfArray);
	EndDo;
	
	PutAgingTableToTempTables(Query, OffsetOfAging);
		
#EndRegion
		
EndProcedure

Procedure Customers_OnTransaction_Unposting(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Currency,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Basis AS TransactionDocument,
	|	Table.Basis AS AdvancesDocument,
	|	Table.Agreement,
	|	Table.Amount
	|INTO OffsetOfAdvance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions AS Table
	|WHERE
	|	FALSE
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Currency,
	|	Table.Partner,
	|	Table.Invoice,
	|	Table.PaymentDate,
	|	Table.Agreement,
	|	Table.Amount
	|INTO OffsetOfAging
	|FROM
	|	AccumulationRegister.R5011B_PartnersAging AS Table
	|WHERE
	|	FALSE";
	Query.Execute();	

EndProcedure

// Parameters:
// 
// -->Input tables:
// 
// VendorsTransactions
//	*Period
//	*Company
//	*Currency
//	*Partner
//	*LegalName
//	*TransactionDocument
//	*Agreement
//	*DocumentAmount
//
// <--Output tables:
//
// OffsetOfAdvance
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *AdvancesDocument
//  *Agreement
//  *Amount
Procedure Vendors_OnTransaction(Parameters) Export
	AdvancesOnTransaction(Parameters, "R1020B_AdvancesToVendors", "VendorsTransactions");
EndProcedure

Procedure Vendors_OnTransaction_Unposting(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Currency,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Basis AS TransactionDocument,
	|	Table.Basis AS AdvancesDocument,
	|	Table.Agreement,
	|	Table.Amount
	|INTO OffsetOfAdvance
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions AS Table
	|WHERE
	|	FALSE";
	Query.Execute();	
EndProcedure	

Procedure AdvancesOnTransaction(Parameters, RegisterName, TransactionsTableName)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = StrTemplate(GetQueryTextAdvancesOnTransaction(), RegisterName, TransactionsTableName);
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
	QueryResult = Query.Execute();	
	AdvancesTable = QueryResult.Unload();
	OffsetOfAdvance = DistributeAdvancesTableOnTransaction(AdvancesTable);
	PutAdvancesTableToTempTables(Query, OffsetOfAdvance);
EndProcedure

Function GetQueryTextAdvancesOnTransaction()
	Return
		"SELECT
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.TransactionDocument,
		|	Transactions.Agreement,
		|	SUM(Transactions.DocumentAmount) AS DocumentAmount,
		|	Advances.Basis AS AdvancesDocument,
		|	SUM(Advances.AmountBalance) AS BalanceAmount,
		|	0 AS Amount,
		|	"""" AS Key
		|FROM
		|	AccumulationRegister.%1.Balance(&Period, (Company, Partner, LegalName, Currency,
		|		CurrencyMovementType) IN
		|		(SELECT
		|			Transactions.Company,
		|			Transactions.Partner,
		|			Transactions.LegalName,
		|			Transactions.Currency,
		|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|		FROM
		|			%2 AS Transactions)) AS Advances
		|		LEFT JOIN %2 AS Transactions
		|		ON Advances.Company = Transactions.Company
		|		AND Advances.Partner = Transactions.Partner
		|		AND Advances.LegalName = Transactions.LegalName
		|		AND Advances.Currency = Transactions.Currency
		|		AND Advances.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.TransactionDocument,
		|	Transactions.Agreement,
		|	Advances.Basis,
		|	VALUE(AccumulationRecordType.Expense)
		|ORDER BY
		|	Advances.Basis.Date,
		|	Transactions.Period";
EndFunction		

Function DistributeAdvancesTableOnTransaction(AdvancesTable)
	OffsetOfAdvance = AdvancesTable.CopyColumns();
	
	AdvancesTable_Groupped = AdvancesTable.Copy();
	
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
	AdvancesTable_Groupped.GroupBy(FilterFields);
	For Each Row In AdvancesTable_Groupped Do
		NeedWriteOff = Row.DocumentAmount;
		Filter = New Structure(FilterFields);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = AdvancesTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If Not ItemOfArray.BalanceAmount > 0 Then
				Continue;
			EndIf;
			CanWriteOff = Min(ItemOfArray.BalanceAmount, NeedWriteOff);
			NeedWriteOff = NeedWriteOff - CanWriteOff;
			ItemOfArray.BalanceAmount = ItemOfArray.BalanceAmount - CanWriteOff;
			
			NewRow = OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Amount = CanWriteOff;
			NewRow.AdvancesDocument = ItemOfArray.AdvancesDocument;
			
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	Return OffsetOfAdvance;
EndFunction	

// Parameters:
// 
// -->Input tables:
// 
// AdvancesFromCustomers
//  *Period
//  *Company
//  *Partner
//  *LegalName
//  *Currency
//  *DocumentAmount
//  *ReceiptDocument
//  *Key
//	
// CustomersTransactions
//  *Period
//  *Company
//  *TransactionDocument
//  *Partner
//  *LegalName
//  *Agreement
//  *Currency
//  *Amount
//  *Key
//
// <--Output tables:
//
// OffsetOfAdvance
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *AdvancesDocument
//  *Agreement
//  *Amount
//
// OffsetOfAging
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *Invoice
//  *PaymentDate
//  *Agreement
//  *Amount
Procedure Customers_OnMoneyMovements(Parameters) Export
		
AdvancesOnMoneyMovements(Parameters, "R2021B_CustomersTransactions", "AdvancesFromCustomers", "CustomersTransactions");
		
#Region Aging

	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;

	Query.Text = 
	"SELECT
	|	OffsetOfAdvance.Company,
	|	OffsetOfAdvance.Partner,
	|	OffsetOfAdvance.Agreement,
	|	OffsetOfAdvance.TransactionDocument AS Invoice,
	|	OffsetOfAdvance.Currency
	|INTO R5011B_PartnersAging_OffsetOfAging_Lock
	|FROM
	|	OffsetOfAdvance AS OffsetOfAdvance
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CustomersTransactions.Period,
	|	CustomersTransactions.Company,
	|	CustomersTransactions.TransactionDocument AS Basis,
	|	CustomersTransactions.Partner,
	|	CustomersTransactions.LegalName,
	|	CustomersTransactions.Agreement,
	|	CustomersTransactions.Currency,
	|	CustomersTransactions.Amount
	|INTO Transactions
	|FROM
	|	CustomersTransactions AS CustomersTransactions
	|
	|UNION ALL
	|
	|SELECT
	|	OffsetOfAdvance.Period,
	|	OffsetOfAdvance.Company,
	|	OffsetOfAdvance.TransactionDocument,
	|	OffsetOfAdvance.Partner,
	|	OffsetOfAdvance.LegalName,
	|	OffsetOfAdvance.Agreement,
	|	OffsetOfAdvance.Currency,
	|	OffsetOfAdvance.Amount
	|FROM
	|	OffsetOfAdvance AS OffsetOfAdvance
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Basis,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency,
	|	SUM(Transactions.Amount) AS Amount
	|INTO TransactionsGroupped
	|FROM
	|	Transactions AS Transactions
	|GROUP BY
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Basis,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency";
	Query.Execute();
	Aging_Lock = PostingServer.GetQueryTableByName("R5011B_PartnersAging_OffsetOfAging_Lock", Parameters);
		
	DataLock = New DataLock();
	LockFields = AccumulationRegisters.R5011B_PartnersAging.GetLockFields(Aging_Lock);
	DataLockItem = DataLock.Add(LockFields.RegisterName);
	DataLockItem.Mode = DataLockMode.Exclusive;
	DataLockItem.DataSource = LockFields.LockInfo.Data;
	For Each Field In LockFields.LockInfo.Fields Do
		DataLockItem.UseFromDataSource(Field.Key, Field.Value);
	EndDo;
	If LockFields.LockInfo.Data.Count() Then
		DataLock.Lock();
		Parameters.Insert("R5011B_PartnersAging_OffsetOfAging_Lock", DataLock);
	EndIf;	
	
	Query.Text = 
	"SELECT
	|	TransactionsGroupped.Period,
	|	R5011B_PartnersAgingBalance.Company,
	|	R5011B_PartnersAgingBalance.Partner,
	|	R5011B_PartnersAgingBalance.Agreement,
	|	R5011B_PartnersAgingBalance.Invoice,
	|	R5011B_PartnersAgingBalance.PaymentDate AS PaymentDate,
	|	R5011B_PartnersAgingBalance.Currency,
	|	R5011B_PartnersAgingBalance.AmountBalance AS DueAmount,
	|	TransactionsGroupped.Amount AS ReceiptAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.R5011B_PartnersAging.Balance(&Period, (Company, Partner, Agreement, Invoice, Currency) IN
	|		(SELECT
	|			TransactionsGroupped.Company,
	|			TransactionsGroupped.Partner,
	|			TransactionsGroupped.Agreement,
	|			TransactionsGroupped.Basis,
	|			TransactionsGroupped.Currency
	|		FROM
	|			TransactionsGroupped AS TransactionsGroupped)) AS R5011B_PartnersAgingBalance
	|		INNER JOIN TransactionsGroupped AS TransactionsGroupped
	|		ON R5011B_PartnersAgingBalance.Company = TransactionsGroupped.Company
	|		AND R5011B_PartnersAgingBalance.Partner = TransactionsGroupped.Partner
	|		AND R5011B_PartnersAgingBalance.Agreement = TransactionsGroupped.Agreement
	|		AND R5011B_PartnersAgingBalance.Invoice = TransactionsGroupped.Basis
	|		AND R5011B_PartnersAgingBalance.Currency = TransactionsGroupped.Currency
	|ORDER BY
	|	PaymentDate";
	
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable_Groupped = QueryTable.Copy();
	QueryTable_Groupped.GroupBy("Invoice, ReceiptAmount");
	QueryTable.GroupBy("Period, Company, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	For Each Row In QueryTable_Groupped Do
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
	
	Query.Text =  
	"SELECT
	|	Table_OffsetOfAging.Period,
	|	Table_OffsetOfAging.Company,
	|	Table_OffsetOfAging.Partner,
	|	Table_OffsetOfAging.Agreement,
	|	Table_OffsetOfAging.Invoice,
	|	Table_OffsetOfAging.PaymentDate,
	|	Table_OffsetOfAging.Currency,
	|	Table_OffsetOfAging.Amount
	|INTO OffsetOfAging
	|FROM
	|	&Table_OffsetOfAging AS Table_OffsetOfAging";
	Query.SetParameter("Table_OffsetOfAging", QueryTable);
	Query.Execute();

#EndRegion	
	
EndProcedure

// Parameters:
// 
// -->Input tables:
// 
// AdvancesToVendors
//  *Period
//  *Company
//  *Partner
//  *LegalName
//  *Currency
//  *DocumentAmount
//  *AdvancesDocument
//  *Key
//	
// VendorsTransactions
//  *Period
//  *Company
//  *TransactionDocument
//  *Partner
//  *LegalName
//  *Agreement
//  *Currency
//  *Amount
//  *Key
//
// <--Output tables:
//
// OffsetOfAdvance
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *AdvancesDocument
//  *Agreement
//  *Amount
Procedure Vendors_OnMoneyMovements(Parameters) Export
	AdvancesOnMoneyMovements(Parameters, "R1021B_VendorsTransactions", "AdvancesToVendors", "VendorsTransactions");
EndProcedure

Procedure AdvancesOnMoneyMovements(Parameters, RegisterName, AdvancesTableName, TransactionsTableName)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = StrTemplate(GetQueryTextAdvancesOnMoneyMovements(), RegisterName, AdvancesTableName);
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
		
	QueryResult = Query.Execute();
	TransactionsBalanceTable = QueryResult.Unload();
	
	FilterFields = 
		"Company,
		|Partner,
		|Agreement,
		|LegalName,
		|Currency,
		|TransactionDocument";
	TransactionsTable = PostingServer.GetQueryTableByName(TransactionsTableName, Parameters);	
	For Each Row In TransactionsTable Do
		Filter = New Structure(FilterFields);
		FillPropertyValues(Filter, Row);
		ArrayOfRows = TransactionsBalanceTable.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			If ItemOfArray.BalanceAmount < Row.Amount Then
				ItemOfArray.BalanceAmount = 0;
			Else
				ItemOfArray.BalanceAmount = ItemOfArray.BalanceAmount - Row.Amount;
			EndIf;
		EndDo;
	EndDo;

	DataLock = New DataLock();
	LockFields = AccumulationRegisters.R5011B_PartnersAging.GetLockFields(TransactionsBalanceTable);
	DataLockItem = DataLock.Add(LockFields.RegisterName);
	DataLockItem.Mode = DataLockMode.Exclusive;
	DataLockItem.DataSource = LockFields.LockInfo.Data;
	For Each Field In LockFields.LockInfo.Fields Do
		DataLockItem.UseFromDataSource(Field.Key, Field.Value);
	EndDo;
	If LockFields.LockInfo.Data.Count() Then
		DataLock.Lock();
		Parameters.Insert("R5011B_PartnersAging_OffsetOfAdvance_Lock", DataLock);
	EndIf;	

	Query.Text = 
	"SELECT
	|	TransactionsBalanceTable.Period,
	|	TransactionsBalanceTable.Company,
	|	TransactionsBalanceTable.Partner,
	|	TransactionsBalanceTable.LegalName,
	|	TransactionsBalanceTable.Currency,
	|	TransactionsBalanceTable.AdvancesDocument,
	|	TransactionsBalanceTable.Key,
	|	TransactionsBalanceTable.DocumentAmount,
	|	TransactionsBalanceTable.TransactionDocument,
	|	TransactionsBalanceTable.Agreement,
	|	TransactionsBalanceTable.BalanceAmount,
	|	TransactionsBalanceTable.Amount
	|INTO TransactionsBalanceTable
	|FROM
	|	&TransactionsBalanceTable AS TransactionsBalanceTable
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsBalanceTable.Period,
	|	TransactionsBalanceTable.Company,
	|	TransactionsBalanceTable.Partner,
	|	TransactionsBalanceTable.LegalName,
	|	TransactionsBalanceTable.Currency,
	|	TransactionsBalanceTable.AdvancesDocument,
	|	TransactionsBalanceTable.Key,
	|	TransactionsBalanceTable.DocumentAmount,
	|	TransactionsBalanceTable.TransactionDocument,
	|	TransactionsBalanceTable.Agreement,
	|	TransactionsBalanceTable.BalanceAmount AS BalanceAmount,
	|	ISNULL(AgingBalance.AmountBalance, 0) AS AgingBalanceAmount,
	|	CASE
	|		WHEN TransactionsBalanceTable.TransactionDocument.Date IS NULL
	|			THEN DATETIME(1, 1, 1)
	|		ELSE ISNULL(AgingBalance.PaymentDate, TransactionsBalanceTable.TransactionDocument.Date)
	|	END AS PriorityDate,
	|	TransactionsBalanceTable.Amount
	|FROM
	|	TransactionsBalanceTable AS TransactionsBalanceTable
	|		LEFT JOIN AccumulationRegister.R5011B_PartnersAging.Balance(&Period, (Company, Partner, Agreement, Invoice,
	|			Currency) IN
	|			(SELECT
	|				TransactionsBalanceTable.Company,
	|				TransactionsBalanceTable.Partner,
	|				TransactionsBalanceTable.Agreement,
	|				TransactionsBalanceTable.TransactionDocument,
	|				TransactionsBalanceTable.Currency
	|			FROM
	|				TransactionsBalanceTable AS TransactionsBalanceTable)) AS AgingBalance
	|		ON TransactionsBalanceTable.Company = AgingBalance.Company
	|		AND TransactionsBalanceTable.Partner = AgingBalance.Partner
	|		AND TransactionsBalanceTable.Agreement = AgingBalance.Agreement
	|		AND TransactionsBalanceTable.TransactionDocument = AgingBalance.Invoice
	|		AND TransactionsBalanceTable.Currency = AgingBalance.Currency
	|ORDER BY
	|	PriorityDate";
	Query.SetParameter("Period", New Boundary(Parameters.PointInTime, BoundaryType.Excluding));
	Query.SetParameter("TransactionsBalanceTable", TransactionsBalanceTable);
	
	AgingBalanceResult = Query.Execute();
	AgingBalanceTable = AgingBalanceResult.Unload();
		
	FilterFields = 
		"Period,
		|Company,
		|Partner,
		|LegalName,
		|Currency,
		|AdvancesDocument,
		|TransactionDocument,
		|Agreement,
		|DocumentAmount,
		|BalanceAmount,
		|Amount";
	
	For Each Row In TransactionsBalanceTable Do
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
	
	OffsetOfAdvance = DistributeAgingTableOnMoneyMovement(AgingBalanceTable);
	PutAdvancesTableToTempTables(Query, OffsetOfAdvance);	
EndProcedure	

Function GetQueryTextAdvancesOnMoneyMovements()
	Return
	"SELECT
	|	Advances.Period,
	|	Advances.Company,
	|	Advances.Partner,
	|	Advances.LegalName,
	|	Advances.Currency,
	|	Advances.AdvancesDocument,
	|	Advances.Key,
	|	SUM(Advances.DocumentAmount) AS DocumentAmount,
	|	Transactions.Basis AS TransactionDocument,
	|	Transactions.Basis AS Invoice,
	|	Transactions.Agreement,
	|	SUM(Transactions.AmountBalance) AS BalanceAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.%1.Balance(&Period, (Company, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			Advances.Company,
	|			Advances.Partner,
	|			Advances.LegalName,
	|			Advances.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			%2 AS Advances)) AS Transactions
	|		INNER JOIN %2 AS Advances
	|		ON Advances.Company = Transactions.Company
	|		AND Advances.Partner = Transactions.Partner
	|		AND Advances.LegalName = Transactions.LegalName
	|		AND Advances.Currency = Transactions.Currency
	|GROUP BY
	|	Advances.Period,
	|	Advances.Company,
	|	Advances.Partner,
	|	Advances.LegalName,
	|	Advances.Currency,
	|	Advances.AdvancesDocument,
	|	Advances.Key,
	|	Transactions.Basis,
	|	Transactions.Agreement
	|ORDER BY
	|	Advances.Period,
	|	Transactions.Basis.Date";
EndFunction

Function DistributeAgingTableOnMoneyMovement(AgingBalanceTable)
	OffsetOfAdvance = AgingBalanceTable.CopyColumns();
	AgingBalanceTable_Groupped = AgingBalanceTable.Copy();
	
	FilterFields = 
		"Period, 
		|Company,
		|Partner, 
		|LegalName, 
		|Currency, 
		|DocumentAmount, 
		|AdvancesDocument, 
		|Key,
		|Amount"; 
	AgingBalanceTable_Groupped.GroupBy(FilterFields);
	For Each Row In AgingBalanceTable_Groupped Do
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
			
			NewRow = OffsetOfAdvance.Add();
			FillPropertyValues(NewRow, Row);
			
			NewRow.Amount              = CanWriteOff;
			NewRow.Agreement           = ItemOfArray.Agreement;
			NewRow.AdvancesDocument    = ItemOfArray.AdvancesDocument;
			NewRow.TransactionDocument = ItemOfArray.TransactionDocument;
			If NeedWriteOff = 0 Then
				Break;
			EndIf;
		EndDo;
	EndDo;
	Return OffsetOfAdvance;
EndFunction

Procedure PutAdvancesTableToTempTables(Query, OffsetOfAdvance)
	Query.Text = 
	"SELECT
	|	OffsetOfAdvance.Period,
	|	OffsetOfAdvance.Company,
	|	OffsetOfAdvance.Partner,
	|	OffsetOfAdvance.LegalName,
	|	OffsetOfAdvance.Currency,
	|	OffsetOfAdvance.TransactionDocument,
	|	OffsetOfAdvance.AdvancesDocument,
	|	OffsetOfAdvance.Agreement,
	|	OffsetOfAdvance.Amount AS Amount,
	|	OffsetOfAdvance.Key
	|INTO OffsetOfAdvance
	|FROM
	|	&OffsetOfAdvance AS OffsetOfAdvance";
	Query.SetParameter("OffsetOfAdvance", OffsetOfAdvance);
	Query.Execute();
EndProcedure	

Procedure PutAgingTableToTempTables(Query, OffsetOfAging)
	Query.Text =  
	"SELECT
	|	OffsetOfAging.Period,
	|	OffsetOfAging.Company,
	|	OffsetOfAging.Partner,
	|	OffsetOfAging.Agreement,
	|	OffsetOfAging.Invoice,
	|	OffsetOfAging.PaymentDate,
	|	OffsetOfAging.Currency,
	|	OffsetOfAging.Amount
	|INTO OffsetOfAging
	|FROM
	|	&OffsetOfAging AS OffsetOfAging";
	Query.SetParameter("OffsetOfAging", OffsetOfAging);
	Query.Execute();
EndProcedure
