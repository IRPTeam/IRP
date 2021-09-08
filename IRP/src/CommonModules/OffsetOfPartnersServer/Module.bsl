
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
//	*AdvanceBasis
//	*Agreement
//	*DocumentAmount
//	*DueAsAdvance
//  
// <--Output tables:
//
// DueAsAdvanceFromCustomers
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *Agreement
//  *Amount
Procedure Customers_DueAsAdvance(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Currency,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.TransactionDocument,
	|	&Recorder AS AdvancesDocument,
	|	Transactions.Agreement,
	|	Transactions.Amount,
	|	Transactions.Key
	|INTO Transactions
	|FROM
	|	CustomersTransactions AS Transactions
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.Agreement,
	|	SUM(TransactionsBalance.AmountBalance) AS Amount,
	|	SUM(Transactions.Amount) AS DocumentAmount,
	|	Transactions.Period,
	|	Transactions.TransactionDocument,
	|	Transactions.AdvancesDocument,
	|	Transactions.Key
	|INTO TransactionsBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period, (Company, Branch, Currency, LegalName, Partner, Agreement,
	|		Basis, CurrencyMovementType) IN
	|		(SELECT
	|			Transactions.Company,
	|			Transactions.Branch,
	|			Transactions.Currency,
	|			Transactions.LegalName,
	|			Transactions.Partner,
	|			Transactions.Agreement,
	|			Transactions.TransactionDocument,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			Transactions AS Transactions)) AS TransactionsBalance
	|		INNER JOIN Transactions AS Transactions
	|		ON TransactionsBalance.Company = Transactions.Company
	|		AND TransactionsBalance.Branch = Transactions.Branch
	|		AND TransactionsBalance.Partner = Transactions.Partner
	|		AND TransactionsBalance.LegalName = Transactions.LegalName
	|		AND TransactionsBalance.Agreement = Transactions.Agreement
	|		AND TransactionsBalance.Currency = Transactions.Currency
	|		AND TransactionsBalance.Basis = Transactions.TransactionDocument
	|GROUP BY
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.Agreement,
	|	Transactions.Period,
	|	Transactions.TransactionDocument,
	|	Transactions.AdvancesDocument,
	|	Transactions.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsBalance.Period,
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Agreement,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.TransactionDocument,
	|	TransactionsBalance.AdvancesDocument,
	|	CASE
	|		WHEN TransactionsBalance.Amount > TransactionsBalance.DocumentAmount
	|			THEN TransactionsBalance.DocumentAmount
	|		ELSE TransactionsBalance.Amount
	|	END AS Amount,
	|	TransactionsBalance.Key
	|INTO DueAsAdvanceFromCustomers
	|FROM
	|	TransactionsBalance AS TransactionsBalance
	|WHERE
	|	TransactionsBalance.Amount < 0";
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Including));
	Query.SetParameter("Recorder", Parameters.RecorderPointInTime.Ref);
	
	Query.Execute();
EndProcedure

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
//	*IgnoreAdvances
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
	AdvancesOnTransaction(Parameters, "R2020B_AdvancesFromCustomers" , "CustomersTransactions", "OffsetOfAdvanceFromCustomers");

#Region Aging
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;

	Query.Text = 
	"SELECT
	|	Aging.Period,
	|	Aging.Company,
	|	Aging.Branch,
	|	Aging.Partner,
	|	Aging.Agreement,
	|	Aging.Invoice,
	|	Aging.PaymentDate,
	|	Aging.Currency,
	|	Aging.Amount AS DueAmount,
	|	OffsetOfAdvanceFromCustomers.Amount AS Amount_OffsetOfAdvance,
	|	OffsetOfAdvanceFromCustomers.AdvancesDocument,
	|	0 AS Amount
	|FROM
	|	Aging AS Aging
	|		INNER JOIN OffsetOfAdvanceFromCustomers AS OffsetOfAdvanceFromCustomers
	|		ON Aging.Company = OffsetOfAdvanceFromCustomers.Company
	|		AND Aging.Branch = OffsetOfAdvanceFromCustomers.Branch
	|		AND Aging.Partner = OffsetOfAdvanceFromCustomers.Partner
	|		AND Aging.Agreement = OffsetOfAdvanceFromCustomers.Agreement
	|		AND Aging.Invoice = OffsetOfAdvanceFromCustomers.TransactionDocument
	|		AND Aging.Currency = OffsetOfAdvanceFromCustomers.Currency
	|ORDER BY
	|	PaymentDate";
	
	QueryResult = Query.Execute();
	OffsetOfAging = QueryResult.Unload();
	OffsetOfAging_Grouped = OffsetOfAging.Copy();
	
	OffsetOfAging_Grouped.GroupBy("AdvancesDocument, Amount_OffsetOfAdvance");
	OffsetOfAging.GroupBy("Period, Company, Branch, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	
	For Each Row_Advance In OffsetOfAging_Grouped Do
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
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Basis AS TransactionDocument,
	|	Table.Basis AS AdvancesDocument,
	|	Table.Agreement,
	|	Table.Amount
	|INTO OffsetOfAdvanceFromCustomers
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
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Partner,
	|	Table.Invoice,
	|	Table.PaymentDate,
	|	Table.Agreement,
	|	Table.Amount
	|INTO OffsetOfAging
	|FROM
	|	AccumulationRegister.R5011B_CustomersAging AS Table
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
//	*AdvanceBasis
//	*Agreement
//	*DocumentAmount
//	*DueAsAdvance
//  
// <--Output tables:
//
// DueAsAdvanceToVendors
//  *Period
//  *Company
//  *Currency
//  *Partner
//  *LegalName
//  *TransactionDocument
//  *Agreement
//  *Amount
Procedure Vendors_DueAsAdvance(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Currency,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.TransactionDocument,
	|	&Recorder AS AdvancesDocument,
	|	Transactions.Agreement,
	|	Transactions.Amount,
	|	Transactions.Key
	|INTO Transactions
	|FROM
	|	VendorsTransactions AS Transactions
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.Agreement,
	|	SUM(TransactionsBalance.AmountBalance) AS Amount,
	|	SUM(Transactions.Amount) AS DocumentAmount,
	|	Transactions.Period,
	|	Transactions.TransactionDocument,
	|	Transactions.AdvancesDocument,
	|	Transactions.Key
	|INTO TransactionsBalance
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Period, (Company, Branch, Currency, LegalName, Partner, Agreement,
	|		Basis, CurrencyMovementType) IN
	|		(SELECT
	|			Transactions.Company,
	|			Transactions.Branch,
	|			Transactions.Currency,
	|			Transactions.LegalName,
	|			Transactions.Partner,
	|			Transactions.Agreement,
	|			Transactions.TransactionDocument,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			Transactions AS Transactions)) AS TransactionsBalance
	|		INNER JOIN Transactions AS Transactions
	|		ON TransactionsBalance.Company = Transactions.Company
	|		AND TransactionsBalance.Branch = Transactions.Branch
	|		AND TransactionsBalance.Partner = Transactions.Partner
	|		AND TransactionsBalance.LegalName = Transactions.LegalName
	|		AND TransactionsBalance.Agreement = Transactions.Agreement
	|		AND TransactionsBalance.Currency = Transactions.Currency
	|		AND TransactionsBalance.Basis = Transactions.TransactionDocument
	|GROUP BY
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.Agreement,
	|	Transactions.Period,
	|	Transactions.TransactionDocument,
	|	Transactions.AdvancesDocument,
	|	Transactions.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransactionsBalance.Period,
	|	TransactionsBalance.Company,
	|	TransactionsBalance.Branch,
	|	TransactionsBalance.Partner,
	|	TransactionsBalance.LegalName,
	|	TransactionsBalance.Agreement,
	|	TransactionsBalance.Currency,
	|	TransactionsBalance.TransactionDocument,
	|	TransactionsBalance.AdvancesDocument,
	|	CASE
	|		WHEN TransactionsBalance.Amount > TransactionsBalance.DocumentAmount
	|			THEN TransactionsBalance.DocumentAmount
	|		ELSE TransactionsBalance.Amount
	|	END AS Amount,
	|	TransactionsBalance.Key
	|INTO DueAsAdvanceToVendors
	|FROM
	|	TransactionsBalance AS TransactionsBalance
	|WHERE
	|	TransactionsBalance.Amount < 0";
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Including));
	Query.SetParameter("Recorder", Parameters.RecorderPointInTime.Ref);
	
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
	AdvancesOnTransaction(Parameters, "R1020B_AdvancesToVendors", "VendorsTransactions", "OffsetOfAdvanceToVendors");
	
	#Region Aging
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;

	Query.Text = 
	"SELECT
	|	Aging.Period,
	|	Aging.Company,
	|	Aging.Branch,
	|	Aging.Partner,
	|	Aging.Agreement,
	|	Aging.Invoice,
	|	Aging.PaymentDate,
	|	Aging.Currency,
	|	Aging.Amount AS DueAmount,
	|	OffsetOfAdvanceToVendors.Amount AS Amount_OffsetOfAdvance,
	|	OffsetOfAdvanceToVendors.AdvancesDocument,
	|	0 AS Amount
	|FROM
	|	Aging AS Aging
	|		INNER JOIN OffsetOfAdvanceToVendors AS OffsetOfAdvanceToVendors
	|		ON Aging.Company = OffsetOfAdvanceToVendors.Company
	|		AND Aging.Branch = OffsetOfAdvanceToVendors.Branch
	|		AND Aging.Partner = OffsetOfAdvanceToVendors.Partner
	|		AND Aging.Agreement = OffsetOfAdvanceToVendors.Agreement
	|		AND Aging.Invoice = OffsetOfAdvanceToVendors.TransactionDocument
	|		AND Aging.Currency = OffsetOfAdvanceToVendors.Currency
	|ORDER BY
	|	PaymentDate";
	
	QueryResult = Query.Execute();
	OffsetOfAging = QueryResult.Unload();
	OffsetOfAging_Grouped = OffsetOfAging.Copy();
	
	OffsetOfAging_Grouped.GroupBy("AdvancesDocument, Amount_OffsetOfAdvance");
	OffsetOfAging.GroupBy("Period, Company, Branch, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	
	For Each Row_Advance In OffsetOfAging_Grouped Do
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

Procedure Vendors_OnTransaction_Unposting(Parameters) Export
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
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
	|	FALSE
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Partner,
	|	Table.Invoice,
	|	Table.PaymentDate,
	|	Table.Agreement,
	|	Table.Amount
	|INTO OffsetOfAging
	|FROM
	|	AccumulationRegister.R5012B_VendorsAging AS Table
	|WHERE
	|	FALSE";
	Query.Execute();	
EndProcedure	

Procedure AdvancesOnTransaction(Parameters, RegisterName, TransactionsTableName, OffsetOfAdvanceTableName)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = StrTemplate(GetQueryTextAdvancesOnTransaction(), RegisterName, TransactionsTableName);
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Excluding));
	QueryResult = Query.Execute();	
	AdvancesTable = QueryResult.Unload();
	OffsetOfAdvance = DistributeAdvancesTableOnTransaction(AdvancesTable);
	PutAdvancesTableToTempTables(Query, OffsetOfAdvance, OffsetOfAdvanceTableName);
EndProcedure

Function GetQueryTextAdvancesOnTransaction()
	Return
		"SELECT
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.TransactionDocument,
		|	Transactions.Agreement,
		|	SUM(Transactions.DocumentAmount) AS DocumentAmount,
		|	Advances.Basis AS AdvancesDocument,
		|	SUM(Advances.AmountBalance) AS BalanceAmount,
		|	0 AS Amount,
		|	Transactions.Key AS Key
		|FROM
		|	AccumulationRegister.%1.Balance(&Period, (Company, Branch, Partner, LegalName, Currency,
		|		CurrencyMovementType) IN
		|		(SELECT
		|			Transactions.Company,
		|			Transactions.Branch,
		|			Transactions.Partner,
		|			Transactions.LegalName,
		|			Transactions.Currency,
		|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|		FROM
		|			%2 AS Transactions)) AS Advances
		|		LEFT JOIN %2 AS Transactions
		|		ON Advances.Company = Transactions.Company
		|		AND Advances.Branch = Transactions.Branch
		|		AND Advances.Partner = Transactions.Partner
		|		AND Advances.LegalName = Transactions.LegalName
		|		AND Advances.Currency = Transactions.Currency
		|		AND Advances.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
		|WHERE
		|	NOT Transactions.IgnoreAdvances
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Branch,
		|	Transactions.Partner,
		|	Transactions.LegalName,
		|	Transactions.Currency,
		|	Transactions.TransactionDocument,
		|	Transactions.Agreement,
		|	Transactions.Key,
		|	Advances.Basis,
		|	VALUE(AccumulationRecordType.Expense)
		|ORDER BY
		|	Advances.Basis.Date,
		|	Transactions.Period";
EndFunction		

Function DistributeAdvancesTableOnTransaction(AdvancesTable)
	OffsetOfAdvance = AdvancesTable.CopyColumns();
	
	AdvancesTable_Grouped = AdvancesTable.Copy();
	
	FilterFields = 
		"Period, 
		|Company,
		|Branch,
		|Partner, 
		|LegalName, 
		|Currency,  
		|TransactionDocument, 
		|Agreement,
		|DocumentAmount,
		|Key, 
		|Amount"; 
	AdvancesTable_Grouped.GroupBy(FilterFields);
	For Each Row In AdvancesTable_Grouped Do
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
//  *IgnoreAdvances
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
		
AdvancesOnMoneyMovements(Parameters, "R2021B_CustomersTransactions", "AdvancesFromCustomers", "CustomersTransactions", "OffsetOfAdvanceFromCustomers");
		
#Region Aging

	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;

	Query.Text = 
	"SELECT
	|	OffsetOfAdvanceFromCustomers.Company,
	|	OffsetOfAdvanceFromCustomers.Branch,
	|	OffsetOfAdvanceFromCustomers.Partner,
	|	OffsetOfAdvanceFromCustomers.Agreement,
	|	OffsetOfAdvanceFromCustomers.TransactionDocument AS Invoice,
	|	OffsetOfAdvanceFromCustomers.Currency
	|INTO R5011B_CustomersAging_OffsetOfAging_Lock
	|FROM
	|	OffsetOfAdvanceFromCustomers AS OffsetOfAdvanceFromCustomers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CustomersTransactions.Period,
	|	CustomersTransactions.Company,
	|	CustomersTransactions.Branch,
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
	|	OffsetOfAdvanceFromCustomers.Period,
	|	OffsetOfAdvanceFromCustomers.Company,
	|	OffsetOfAdvanceFromCustomers.Branch,
	|	OffsetOfAdvanceFromCustomers.TransactionDocument,
	|	OffsetOfAdvanceFromCustomers.Partner,
	|	OffsetOfAdvanceFromCustomers.LegalName,
	|	OffsetOfAdvanceFromCustomers.Agreement,
	|	OffsetOfAdvanceFromCustomers.Currency,
	|	OffsetOfAdvanceFromCustomers.Amount
	|FROM
	|	OffsetOfAdvanceFromCustomers AS OffsetOfAdvanceFromCustomers
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Basis,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency,
	|	SUM(Transactions.Amount) AS Amount
	|INTO TransactionsGrouped
	|FROM
	|	Transactions AS Transactions
	|GROUP BY
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Basis,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency";
	Query.Execute();
	Aging_Lock = PostingServer.GetQueryTableByName("R5011B_CustomersAging_OffsetOfAging_Lock", Parameters);
		
	DataLock = New DataLock();
	LockFields = AccumulationRegisters.R5011B_CustomersAging.GetLockFields(Aging_Lock);
	DataLockItem = DataLock.Add(LockFields.RegisterName);
	DataLockItem.Mode = DataLockMode.Exclusive;
	DataLockItem.DataSource = LockFields.LockInfo.Data;
	For Each Field In LockFields.LockInfo.Fields Do
		DataLockItem.UseFromDataSource(Field.Key, Field.Value);
	EndDo;
	If LockFields.LockInfo.Data.Count() Then
		DataLock.Lock();
		Parameters.Insert("R5011B_CustomersAging_OffsetOfAging_Lock", DataLock);
	EndIf;	
	
	Query.Text = 
	"SELECT
	|	TransactionsGrouped.Period,
	|	R5011B_CustomersAgingBalance.Company,
	|	R5011B_CustomersAgingBalance.Branch,
	|	R5011B_CustomersAgingBalance.Partner,
	|	R5011B_CustomersAgingBalance.Agreement,
	|	R5011B_CustomersAgingBalance.Invoice,
	|	R5011B_CustomersAgingBalance.PaymentDate AS PaymentDate,
	|	R5011B_CustomersAgingBalance.Currency,
	|	R5011B_CustomersAgingBalance.AmountBalance AS DueAmount,
	|	TransactionsGrouped.Amount AS ReceiptAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.R5011B_CustomersAging.Balance(&Period, (Company, Branch, Partner, Agreement, Invoice, Currency) IN
	|		(SELECT
	|			TransactionsGrouped.Company,
	|			TransactionsGrouped.Branch,
	|			TransactionsGrouped.Partner,
	|			TransactionsGrouped.Agreement,
	|			TransactionsGrouped.Basis,
	|			TransactionsGrouped.Currency
	|		FROM
	|			TransactionsGrouped AS TransactionsGrouped)) AS R5011B_CustomersAgingBalance
	|		INNER JOIN TransactionsGrouped AS TransactionsGrouped
	|		ON R5011B_CustomersAgingBalance.Company = TransactionsGrouped.Company
	|		AND R5011B_CustomersAgingBalance.Branch = TransactionsGrouped.Branch
	|		AND R5011B_CustomersAgingBalance.Partner = TransactionsGrouped.Partner
	|		AND R5011B_CustomersAgingBalance.Agreement = TransactionsGrouped.Agreement
	|		AND R5011B_CustomersAgingBalance.Invoice = TransactionsGrouped.Basis
	|		AND R5011B_CustomersAgingBalance.Currency = TransactionsGrouped.Currency
	|ORDER BY
	|	PaymentDate";
	
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Excluding));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable_Grouped = QueryTable.Copy();
	QueryTable_Grouped.GroupBy("Invoice, ReceiptAmount");
	QueryTable.GroupBy("Period, Company, Branch, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	For Each Row In QueryTable_Grouped Do
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
	"DROP R5011B_CustomersAging_OffsetOfAging_Lock;
	|DROP Transactions;
	|DROP TransactionsGrouped";
	Query.Execute();
	
	Query.Text =  
	"SELECT
	|	Table_OffsetOfAging.Period,
	|	Table_OffsetOfAging.Company,
	|	Table_OffsetOfAging.Branch,
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
	AdvancesOnMoneyMovements(Parameters, "R1021B_VendorsTransactions", "AdvancesToVendors", "VendorsTransactions", "OffsetOfAdvanceToVendors");
	
	#Region Aging

	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;

	Query.Text = 
	"SELECT
	|	OffsetOfAdvanceToVendors.Company,
	|	OffsetOfAdvanceToVendors.Branch,
	|	OffsetOfAdvanceToVendors.Partner,
	|	OffsetOfAdvanceToVendors.Agreement,
	|	OffsetOfAdvanceToVendors.TransactionDocument AS Invoice,
	|	OffsetOfAdvanceToVendors.Currency
	|INTO R5012B_VendorsAging_OffsetOfAging_Lock
	|FROM
	|	OffsetOfAdvanceToVendors AS OffsetOfAdvanceToVendors
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VendorsTransactions.Period,
	|	VendorsTransactions.Company,
	|	VendorsTransactions.Branch,
	|	VendorsTransactions.TransactionDocument AS Basis,
	|	VendorsTransactions.Partner,
	|	VendorsTransactions.LegalName,
	|	VendorsTransactions.Agreement,
	|	VendorsTransactions.Currency,
	|	VendorsTransactions.Amount
	|INTO Transactions
	|FROM
	|	VendorsTransactions AS VendorsTransactions
	|
	|UNION ALL
	|
	|SELECT
	|	OffsetOfAdvanceToVendors.Period,
	|	OffsetOfAdvanceToVendors.Company,
	|	OffsetOfAdvanceToVendors.Branch,
	|	OffsetOfAdvanceToVendors.TransactionDocument,
	|	OffsetOfAdvanceToVendors.Partner,
	|	OffsetOfAdvanceToVendors.LegalName,
	|	OffsetOfAdvanceToVendors.Agreement,
	|	OffsetOfAdvanceToVendors.Currency,
	|	OffsetOfAdvanceToVendors.Amount
	|FROM
	|	OffsetOfAdvanceToVendors AS OffsetOfAdvanceToVendors
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Basis,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency,
	|	SUM(Transactions.Amount) AS Amount
	|INTO TransactionsGrouped
	|FROM
	|	Transactions AS Transactions
	|GROUP BY
	|	Transactions.Period,
	|	Transactions.Company,
	|	Transactions.Branch,
	|	Transactions.Basis,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	Transactions.Currency";
	Query.Execute();
	Aging_Lock = PostingServer.GetQueryTableByName("R5012B_VendorsAging_OffsetOfAging_Lock", Parameters);
		
	DataLock = New DataLock();
	LockFields = AccumulationRegisters.R5012B_VendorsAging.GetLockFields(Aging_Lock);
	DataLockItem = DataLock.Add(LockFields.RegisterName);
	DataLockItem.Mode = DataLockMode.Exclusive;
	DataLockItem.DataSource = LockFields.LockInfo.Data;
	For Each Field In LockFields.LockInfo.Fields Do
		DataLockItem.UseFromDataSource(Field.Key, Field.Value);
	EndDo;
	If LockFields.LockInfo.Data.Count() Then
		DataLock.Lock();
		Parameters.Insert("R5011B_VendorsAging_OffsetOfAging_Lock", DataLock);
	EndIf;	
	
	Query.Text = 
	"SELECT
	|	TransactionsGrouped.Period,
	|	R5012B_VendorsAgingBalance.Company,
	|	R5012B_VendorsAgingBalance.Branch,
	|	R5012B_VendorsAgingBalance.Partner,
	|	R5012B_VendorsAgingBalance.Agreement,
	|	R5012B_VendorsAgingBalance.Invoice,
	|	R5012B_VendorsAgingBalance.PaymentDate AS PaymentDate,
	|	R5012B_VendorsAgingBalance.Currency,
	|	R5012B_VendorsAgingBalance.AmountBalance AS DueAmount,
	|	TransactionsGrouped.Amount AS ReceiptAmount,
	|	0 AS Amount
	|FROM
	|	AccumulationRegister.R5012B_VendorsAging.Balance(&Period, (Company, Branch, Partner, Agreement, Invoice, Currency) IN
	|		(SELECT
	|			TransactionsGrouped.Company,
	|			TransactionsGrouped.Branch,
	|			TransactionsGrouped.Partner,
	|			TransactionsGrouped.Agreement,
	|			TransactionsGrouped.Basis,
	|			TransactionsGrouped.Currency
	|		FROM
	|			TransactionsGrouped AS TransactionsGrouped)) AS R5012B_VendorsAgingBalance
	|		INNER JOIN TransactionsGrouped AS TransactionsGrouped
	|		ON R5012B_VendorsAgingBalance.Company = TransactionsGrouped.Company
	|		AND R5012B_VendorsAgingBalance.Branch = TransactionsGrouped.Branch
	|		AND R5012B_VendorsAgingBalance.Partner = TransactionsGrouped.Partner
	|		AND R5012B_VendorsAgingBalance.Agreement = TransactionsGrouped.Agreement
	|		AND R5012B_VendorsAgingBalance.Invoice = TransactionsGrouped.Basis
	|		AND R5012B_VendorsAgingBalance.Currency = TransactionsGrouped.Currency
	|ORDER BY
	|	PaymentDate";
	
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Excluding));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	QueryTable_Grouped = QueryTable.Copy();
	QueryTable_Grouped.GroupBy("Invoice, ReceiptAmount");
	QueryTable.GroupBy("Period, Company, Branch, Partner, Agreement, Invoice, PaymentDate, Currency, DueAmount, Amount");
	For Each Row In QueryTable_Grouped Do
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
	"DROP R5012B_VendorsAging_OffsetOfAging_Lock;
	|DROP Transactions;
	|DROP TransactionsGrouped";
	Query.Execute();
	
	Query.Text =  
	"SELECT
	|	Table_OffsetOfAging.Period,
	|	Table_OffsetOfAging.Company,
	|	Table_OffsetOfAging.Branch,
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

Procedure AdvancesOnMoneyMovements(Parameters, RegisterName, AdvancesTableName, TransactionsTableName, OffsetOfAdvanceTableName)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = StrTemplate(GetQueryTextAdvancesOnMoneyMovements(), RegisterName, AdvancesTableName);
	Query.SetParameter("Period", New Boundary(Parameters.RecorderPointInTime, BoundaryType.Excluding));
		
	QueryResult = Query.Execute();
	TransactionsBalanceTable = QueryResult.Unload();
	
	FilterFields = 
		"Company,
		|Branch,
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
	LockFields = AccumulationRegisters.R5011B_CustomersAging.GetLockFields(TransactionsBalanceTable);
	DataLockItem = DataLock.Add(LockFields.RegisterName);
	DataLockItem.Mode = DataLockMode.Exclusive;
	DataLockItem.DataSource = LockFields.LockInfo.Data;
	For Each Field In LockFields.LockInfo.Fields Do
		DataLockItem.UseFromDataSource(Field.Key, Field.Value);
	EndDo;
	If LockFields.LockInfo.Data.Count() Then
		DataLock.Lock();
		Parameters.Insert("R5011B_CustomersAging_OffsetOfAdvance_Lock", DataLock);
	EndIf;	

	Query.Text = 
	"SELECT
	|	TransactionsBalanceTable.Period,
	|	TransactionsBalanceTable.Company,
	|	TransactionsBalanceTable.Branch,
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
	|	TransactionsBalanceTable.Branch,
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
	|		LEFT JOIN AccumulationRegister.R5011B_CustomersAging.Balance(&Period, (Company, Branch, Partner, Agreement, Invoice,
	|			Currency) IN
	|			(SELECT
	|				TransactionsBalanceTable.Company,
	|				TransactionsBalanceTable.Branch,
	|				TransactionsBalanceTable.Partner,
	|				TransactionsBalanceTable.Agreement,
	|				TransactionsBalanceTable.TransactionDocument,
	|				TransactionsBalanceTable.Currency
	|			FROM
	|				TransactionsBalanceTable AS TransactionsBalanceTable)) AS AgingBalance
	|		ON TransactionsBalanceTable.Company = AgingBalance.Company
	|		AND TransactionsBalanceTable.Branch = AgingBalance.Branch
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
		
	Query.Text = "DROP TransactionsBalanceTable";
	Query.Execute();	
		
	FilterFields = 
		"Period,
		|Company,
		|Branch,
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
		
		If ValueIsFilled(Row.TransactionDocument)
		 And CommonFunctionsClientServer.ObjectHasProperty(Row.TransactionDocument, "IgnoreAdvances")
		 And Row.TransactionDocument.IgnoreAdvances Then
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
	PutAdvancesTableToTempTables(Query, OffsetOfAdvance, OffsetOfAdvanceTableName);	
EndProcedure	

Function GetQueryTextAdvancesOnMoneyMovements()
	Return
	"SELECT
	|	Advances.Period,
	|	Advances.Company,
	|	Advances.Branch,
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
	|	AccumulationRegister.%1.Balance(&Period, (Company, Branch, Partner, LegalName, Currency,
	|		CurrencyMovementType) IN
	|		(SELECT
	|			Advances.Company,
	|			Advances.Branch,
	|			Advances.Partner,
	|			Advances.LegalName,
	|			Advances.Currency,
	|			VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|		FROM
	|			%2 AS Advances)) AS Transactions
	|		INNER JOIN %2 AS Advances
	|		ON Advances.Company = Transactions.Company
	|		AND Advances.Branch = Transactions.Branch
	|		AND Advances.Partner = Transactions.Partner
	|		AND Advances.LegalName = Transactions.LegalName
	|		AND Advances.Currency = Transactions.Currency
	|GROUP BY
	|	Advances.Period,
	|	Advances.Company,
	|	Advances.Branch,
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
	AgingBalanceTable_Grouped = AgingBalanceTable.Copy();
	
	FilterFields = 
		"Period, 
		|Company,
		|Branch,
		|Partner, 
		|LegalName, 
		|Currency, 
		|DocumentAmount, 
		|AdvancesDocument, 
		|Key,
		|Amount"; 
	AgingBalanceTable_Grouped.GroupBy(FilterFields);
	For Each Row In AgingBalanceTable_Grouped Do
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
			
			If ValueIsFilled(ItemOfArray.TransactionDocument) 
				And CommonFunctionsClientServer.ObjectHasProperty(ItemOfArray.TransactionDocument, "IgnoreAdvances")
				And ItemOfArray.TransactionDocument.IgnoreAdvances Then
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

Procedure PutAdvancesTableToTempTables(Query, OffsetOfAdvance, OffsetOfAdvanceTableName)
	Query.Text = 
	"SELECT
	|	OffsetOfAdvance.Period,
	|	OffsetOfAdvance.Company,
	|	OffsetOfAdvance.Branch,
	|	OffsetOfAdvance.Partner,
	|	OffsetOfAdvance.LegalName,
	|	OffsetOfAdvance.Currency,
	|	OffsetOfAdvance.TransactionDocument,
	|	OffsetOfAdvance.AdvancesDocument,
	|	OffsetOfAdvance.Agreement,
	|	OffsetOfAdvance.Amount AS Amount,
	|	OffsetOfAdvance.Key
	|INTO %1
	|FROM
	|	&OffsetOfAdvance AS OffsetOfAdvance";
	Query.Text = StrTemplate(Query.Text, OffsetOfAdvanceTableName);
	Query.SetParameter("OffsetOfAdvance", OffsetOfAdvance);
	Query.Execute();
EndProcedure	

Procedure PutAgingTableToTempTables(Query, OffsetOfAging)
	Query.Text =  
	"SELECT
	|	OffsetOfAging.Period,
	|	OffsetOfAging.Company,
	|	OffsetOfAging.Branch,
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

Procedure CheckCreditLimit(Ref, Cancel) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R2021B_CustomersTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND Partner = &Partner
	|	AND Agreement = &Agreement) AS R2021B_CustomersTransactionsBalance";
	Query.SetParameter("Period"    , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Query.SetParameter("Partner"   , Ref.Partner);
	Query.SetParameter("Agreement" , Ref.Agreement);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		
		CreditLimitAmount = Ref.Agreement.CreditLimitAmount;
		
		If (QuerySelection.AmountBalance + Ref.DocumentAmount)  > CreditLimitAmount Then
			Cancel = True;
			Message = StrTemplate(R().Error_085, 
				CreditLimitAmount, 
				CreditLimitAmount - QuerySelection.AmountBalance, 
				Ref.DocumentAmount,
				(QuerySelection.AmountBalance + Ref.DocumentAmount) - CreditLimitAmount,
				Ref.Currency);
			CommonFunctionsClientServer.ShowUsersMessage(Message);
		EndIf;
	EndIf;
EndProcedure

Function IsDebitCreditNote(Ref) Export
	Return
	 	TypeOf(Ref) = Type("DocumentRef.DebitNote")
		Or TypeOf(Ref) = Type("DocumentRef.CreditNote");
EndFunction
	
Function IsReturn(Ref) Export
	Return
	 	TypeOf(Ref) = Type("DocumentRef.SalesReturn")
		Or TypeOf(Ref) = Type("DocumentRef.PurchaseReturn");
EndFunction

