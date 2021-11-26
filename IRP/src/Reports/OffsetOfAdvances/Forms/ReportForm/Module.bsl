
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Period.StartDate = Date(2021,11,22);
	Period.EndDate   = Date(2021,11,22);
EndProcedure

&AtClient
Procedure Run(Command)
	RunAtServer();
EndProcedure

&AtServer
Procedure RunAtServer()
	ThisObject.Doc.Clear();
	Template = Reports.OffsetOfAdvances.GetTemplate("Template");
	Area_Header = Template.GetArea("Header");
	Doc.Put(Area_Header);
	MainTable = GetMainTable();
	For Each MainRow In MainTable Do
		Area_Caption = Template.GetArea("Caption");
		Area_Caption.Parameters.Fill(MainRow);
		Doc.Put(Area_Caption);
		
		ArrayOf_FromTRN = New Array();
		ArrayOf_FromADV = New Array();
		
		DocumentTable = GetDocumentTable(MainRow);
		For Each DocumentRow In DocumentTable Do
			Area_Row = Template.GetArea("Row");
			Area_Row.Parameters.Fill(DocumentRow);
			//Area_Row.Parameters.Fill(GetCorrespondent(MainRow, DocumentRow));
			
			ADV_KEY = GetADV_KEY(MainRow.Company, MainRow.Branch, MainRow.Currency, 
				MainRow.Partner, MainRow.LegalName, DocumentRow.Order);
			Area_Row.Parameters.ADV_KEY = ADV_KEY;
			ArrayOf_FromADV.Add(ADV_KEY);
			
			 
			TRN_KEY = GetTRN_KEY(MainRow.Company, MainRow.Branch, MainRow.Currency, 
				MainRow.Partner, MainRow.LegalName, MainRow.Agreement, DocumentRow.Order, DocumentRow.Document);
			Area_Row.Parameters.TRN_KEY = TRN_KEY;
			ArrayOf_FromTRN.Add(TRN_KEY);
			
			Doc.Put(Area_Row);
			If TypeOf(DocumentRow.Document) = Type("DocumentRef.PurchaseInvoice") Then
				AgingTable = GetAgingTable(DocumentRow.Document);
				If AgingTable.Count() Then
					Area_AgingHeader = Template.GetArea("AgingHeader");
					Doc.Put(Area_AgingHeader);
					For Each AgingRow In AgingTable Do
						Area_AgingRow = Template.GetArea("AgingRow");
						Area_AgingRow.Parameters.Fill(AgingRow);
						Doc.Put(Area_AgingRow);
					EndDo;
				EndIf;
			EndIf;
		EndDo; // DocumentRow
		ADV_TRN_Table = GetFromADV_ToTRN(ArrayOf_FromADV);
		If ADV_TRN_Table.Count() Then
			Area_ADV_TRN_Header = Template.GetArea("ADV_TRN_Header");
			Doc.Put(Area_ADV_TRN_Header);
			For Each Row_ADV_TRN in ADV_TRN_Table Do
				Area_ADV_TRN_Row = Template.GetArea("ADV_TRN_Row");
				Area_ADV_TRN_Row.Parameters.Fill(Row_ADV_TRN);
				Doc.Put(Area_ADV_TRN_Row);
			EndDo;
		EndIf;
		TRN_ADV_Table = GetFromTRN_ToADV(ArrayOf_FromTRN);
		
		If TRN_ADV_Table.Count() Then
			Area_TRN_ADV_Header = Template.GetArea("TRN_ADV_Header");
			Doc.Put(Area_TRN_ADV_Header);
			For Each Row_TRN_ADV in TRN_ADV_Table Do
				Area_TRN_ADV_Row = Template.GetArea("TRN_ADV_Row");
				Area_TRN_ADV_Row.Parameters.Fill(Row_TRN_ADV);
				Doc.Put(Area_TRN_ADV_Row);
			EndDo;
		EndIf;
		
	EndDo;// MainRow
	Doc.FixedTop=2;
EndProcedure

Function GetFromTRN_ToADV(ArrayOf_FromTRN)
	Query = New Query();
	Query.Text = 

"SELECT
|	T2010S_OffsetOfAdvances.FromTransactionKey AS FromTransactionKey,
|	T2010S_OffsetOfAdvances.ToAdvanceKey AS ToAdvanceKey
|INTO tmp
|FROM
|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
|WHERE
|	NOT T2010S_OffsetOfAdvances.FromTransactionKey.Ref IS NULL
|	AND NOT T2010S_OffsetOfAdvances.ToAdvanceKey.Ref IS NULL
|	AND T2010S_OffsetOfAdvances.FromTransactionKey IN (&ArrayOf_FromTRN)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|SELECT
|	tmp.FromTransactionKey AS FromTransactionKey,
|	TRN.Period AS TRN_Period,
|	TRN.AmountOpeningBalance AS TRN_Open,
|	TRN.AmountReceipt AS TRN_Receipt,
|	TRN.AmountExpense AS TRN_Expense,
|	TRN.AmountClosingBalance AS TRN_Close,
|	tmp.ToAdvanceKey AS ToAdvanceKey
|INTO tmp2
|FROM
|	tmp AS tmp
|		LEFT JOIN AccumulationRegister.TM1030B_TransactionsKey.BalanceAndTurnovers(BEGINOFPERIOD(&BeginOfPeriod, DAY),
|			ENDOFPERIOD(&EndOfPeriod, DAY), Record, RegisterRecords, TransactionKey IN
|			(SELECT
|				tmp.FromTransactionKey
|			FROM
|				tmp AS tmp)) AS TRN
|		ON TRN.TransactionKey = tmp.FromTransactionKey
|;
|
|////////////////////////////////////////////////////////////////////////////////
|SELECT
|	tmp2.FromTransactionKey AS FromTransactionKey,
|	tmp2.TRN_Period AS TRN_Period,
|	CASE
|		WHEN tmp2.TRN_Period IS NULL
|			THEN ADV.Period //DATETIME(3000, 1, 1)
|		ELSE tmp2.TRN_Period
|	END AS pOrder,
|	tmp2.TRN_Open AS TRN_Open,
|	tmp2.TRN_Receipt AS TRN_Receipt,
|	tmp2.TRN_Expense AS TRN_Expense,
|	tmp2.TRN_Close AS TRN_Close,
|	tmp2.ToAdvanceKey AS ToAdvanceKey,
|	ADV.Period AS ADV_Period,
|	ADV.AmountOpeningBalance AS ADV_Open,
|	ADV.AmountReceipt AS ADV_Receipt,
|	ADV.AmountExpense AS ADV_Expense,
|	ADV.AmountClosingBalance AS ADV_Close
|FROM
|	tmp2 AS tmp2
|		FULL JOIN AccumulationRegister.TM1020B_AdvancesKey.BalanceAndTurnovers(BEGINOFPERIOD(&BeginOfPeriod, DAY),
|			ENDOFPERIOD(&EndOfPeriod, DAY), Record, RegisterRecords, AdvanceKey IN
|			(SELECT
|				tmp2.ToAdvanceKey
|			FROM
|				tmp2 AS tmp2)) AS ADV
|		ON ADV.AdvanceKey = tmp2.ToAdvanceKey
|		AND tmp2.TRN_Period = ADV.Period
|		AND tmp2.TRN_Expense = ADV.AmountExpense
|GROUP BY
|	tmp2.FromTransactionKey,
|	tmp2.TRN_Period,
|	tmp2.TRN_Open,
|	tmp2.TRN_Receipt,
|	tmp2.TRN_Expense,
|	tmp2.TRN_Close,
|	tmp2.ToAdvanceKey,
|	ADV.Period,
|	ADV.AmountOpeningBalance,
|	ADV.AmountReceipt,
|	ADV.AmountExpense,
|	ADV.AmountClosingBalance,
|	CASE
|		WHEN tmp2.TRN_Period IS NULL
|			THEN ADV.Period //DATETIME(3000, 1, 1)
|		ELSE tmp2.TRN_Period
|	END
|ORDER BY
|	pOrder";
	Query.SetParameter("BeginOfPeriod", Period.StartDate);
	Query.SetParameter("EndOfPeriod", Period.EndDate);
	Query.SetParameter("ArrayOf_FromTRN", ArrayOf_FromTRN);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetFromADV_ToTRN(ArrayOf_FromADV)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T2010S_OffsetOfAdvances.FromAdvanceKey AS FromAdvanceKey,
	|	T2010S_OffsetOfAdvances.ToTransactionKey AS ToTransactionKey
	|INTO tmp
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
	|WHERE
	|	NOT T2010S_OffsetOfAdvances.FromAdvanceKey.Ref IS NULL
	|	AND NOT T2010S_OffsetOfAdvances.ToTransactionKey.Ref IS NULL
	|	AND T2010S_OffsetOfAdvances.FromAdvanceKey IN (&ArrayOf_FromADV)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.FromAdvanceKey AS FromAdvanceKey,
	|	ADV.Period AS ADV_Period,
	|	ADV.AmountOpeningBalance AS ADV_Open,
	|	ADV.AmountReceipt AS ADV_Receipt,
	|	ADV.AmountExpense AS ADV_Expense,
	|	ADV.AmountClosingBalance AS ADV_Close,
	|	tmp.ToTransactionKey AS ToTransactionKey
	|INTO tmp2
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN AccumulationRegister.TM1020B_AdvancesKey.BalanceAndTurnovers(BEGINOFPERIOD(&BeginOfPeriod, DAY),
	|			ENDOFPERIOD(&EndOfPeriod, DAY), Record, RegisterRecords, AdvanceKey IN
	|			(SELECT
	|				tmp.FromAdvanceKey
	|			FROM
	|				tmp AS tmp)) AS ADV
	|		ON ADV.AdvanceKey = tmp.FromAdvanceKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.FromAdvanceKey AS FromAdvanceKey,
	|	tmp2.ADV_Period AS ADV_Period,
	|	CASE
	|		WHEN tmp2.ADV_Period IS NULL
	|			THEN TRN.Period //DATETIME(3000, 1, 1)
	|		ELSE tmp2.ADV_Period
	|	END AS pOrder,
	|	tmp2.ADV_Open AS ADV_Open,
	|	tmp2.ADV_Receipt AS ADV_Receipt,
	|	tmp2.ADV_Expense AS ADV_Expense,
	|	tmp2.ADV_Close AS ADV_Close,
	|	TRN.TransactionKey AS ToTransactionKey,
	|	TRN.Period AS TRN_Period,
	|	TRN.AmountOpeningBalance AS TRN_Open,
	|	TRN.AmountReceipt AS TRN_Receipt,
	|	TRN.AmountExpense AS TRN_Expense,
	|	TRN.AmountClosingBalance AS TRN_Close
	|FROM
	|	tmp2 AS tmp2
	|		FULL JOIN AccumulationRegister.TM1030B_TransactionsKey.BalanceAndTurnovers(BEGINOFPERIOD(&BeginOfPeriod, DAY),
	|			ENDOFPERIOD(&EndOfPeriod, DAY), Record, RegisterRecords, TransactionKey IN
	|			(SELECT
	|				tmp2.ToTransactionKey
	|			FROM
	|				tmp2 AS tmp2)) AS TRN
	|		ON TRN.TransactionKey = tmp2.ToTransactionKey
	|		AND tmp2.ADV_Period = TRN.Period
	|		AND tmp2.ADV_Expense = TRN.AmountExpense
	|GROUP BY
	|	tmp2.FromAdvanceKey,
	|	tmp2.ADV_Period,
	|	tmp2.ADV_Open,
	|	tmp2.ADV_Receipt,
	|	tmp2.ADV_Expense,
	|	tmp2.ADV_Close,
	|	TRN.TransactionKey,
	|	TRN.Period,
	|	TRN.AmountOpeningBalance,
	|	TRN.AmountReceipt,
	|	TRN.AmountExpense,
	|	TRN.AmountClosingBalance,
	|	CASE
	|		WHEN tmp2.ADV_Period IS NULL
	|			THEN TRN.Period //DATETIME(3000, 1, 1)
	|		ELSE tmp2.ADV_Period
	|	END
	|ORDER BY
	|	pOrder";
	Query.SetParameter("BeginOfPeriod", Period.StartDate);
	Query.SetParameter("EndOfPeriod", Period.EndDate);
	Query.SetParameter("ArrayOf_FromADV", ArrayOf_FromADV);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetTRN_KEY(Company, Branch, Currency, Partner, LegalName, Agreement, Order, TransactionBasis)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TransactionsKeys.Ref as key
	|FROM
	|	Catalog.TransactionsKeys AS TransactionsKeys
	|WHERE
	|	TransactionsKeys.Company = &Company
	|	AND TransactionsKeys.Branch = &Branch
	|	AND TransactionsKeys.Currency = &Currency
	|	AND TransactionsKeys.Partner = &Partner
	|	AND TransactionsKeys.LegalName = &LegalName
	|	AND TransactionsKeys.Order = &Order
	|	AND NOT TransactionsKeys.DeletionMark
	|	AND TransactionsKeys.TransactionBasis = &TransactionBasis
	|	AND TransactionsKeys.Agreement = &Agreement
	|	AND TransactionsKeys.IsVendorTransaction";
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch", Branch);
	Query.SetParameter("Currency", Currency);
	Query.SetParameter("Partner", Partner);
	Query.SetParameter("LegalName", LegalName);
	Query.SetParameter("Order"            , Order);
	Query.SetParameter("Agreement"        , Agreement);
	Query.SetParameter("TransactionBasis" , TransactionBasis);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Function GetADV_KEY(Company, Branch, Currency, Partner, LegalName, Order)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AdvancesKeys.Ref as key
	|FROM
	|	Catalog.AdvancesKeys AS AdvancesKeys
	|WHERE
	|	AdvancesKeys.Company = &Company
	|	AND AdvancesKeys.Branch = &Branch
	|	AND AdvancesKeys.Currency = &Currency
	|	AND AdvancesKeys.Partner = &Partner
	|	AND AdvancesKeys.LegalName = &LegalName
	|	AND AdvancesKeys.Order = &Order
	|	AND AdvancesKeys.IsVendorAdvance
	|	AND NOT AdvancesKeys.DeletionMark";
	Query.SetParameter("Company", Company);
	Query.SetParameter("Branch", Branch);
	Query.SetParameter("Currency", Currency);
	Query.SetParameter("Partner", Partner);
	Query.SetParameter("LegalName", LegalName);
	Query.SetParameter("Order", Order);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Key;
	EndIf;
	Return "";
EndFunction

Function GetAgingTable(Invoice)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R5012B_VendorsAgingBalanceAndTurnovers.PaymentDate,
	|	SUM(R5012B_VendorsAgingBalanceAndTurnovers.AmountReceipt) AS Receipt,
	|	SUM(R5012B_VendorsAgingBalanceAndTurnovers.AmountExpense) AS Expense
	|FROM
	|	AccumulationRegister.R5012B_VendorsAging.BalanceAndTurnovers(,,,, Invoice = &Invoice) AS
	|		R5012B_VendorsAgingBalanceAndTurnovers
	|GROUP BY
	|	R5012B_VendorsAgingBalanceAndTurnovers.PaymentDate";
	Query.SetParameter("Invoice", Invoice);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

//Function GetCorrespondent(MainRow, DocumentRow)
//	Query = New Query();
//	Query.Text = 
//	"SELECT
//	|	CASE
//	|		WHEN T2010S_OffsetOfAdvances.Document = T2010S_OffsetOfAdvances.TransactionDocument
//	|			THEN T2010S_OffsetOfAdvances.AdvancesDocument
//	|		WHEN T2010S_OffsetOfAdvances.Document = T2010S_OffsetOfAdvances.AdvancesDocument
//	|			THEN T2010S_OffsetOfAdvances.TransactionDocument
//	|	END AS Correspondent,
//	|	T2010S_OffsetOfAdvances.LineNumber
//	|FROM
//	|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
//	|WHERE
//	|	T2010S_OffsetOfAdvances.Company = &Company
//	|	AND T2010S_OffsetOfAdvances.Branch = &Branch
//	|	AND T2010S_OffsetOfAdvances.Currency = &Currency
//	|	AND T2010S_OffsetOfAdvances.Partner = &Partner
//	|	AND T2010S_OffsetOfAdvances.LegalName = &LegalName
//	|	AND T2010S_OffsetOfAdvances.Agreement = &Agreement
//	|	AND T2010S_OffsetOfAdvances.Document = &Document";
//	Query.SetParameter("Company", MainRow.Company);
//	Query.SetParameter("Branch", MainRow.Branch);
//	Query.SetParameter("Currency", MainRow.Currency);
//	Query.SetParameter("LegalName", MainRow.LegalName);
//	Query.SetParameter("Partner", MainRow.Partner);
//	Query.SetParameter("Agreement", MainRow.Agreement);
//	Query.SetParameter("Document", DocumentRow.Document);
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
//	If QuerySelection.Next() Then
//		Return QuerySelection;
//	EndIf;
//	Return New Structure("Correspondent, LineNumber", "---", "");
//EndFunction

Function GetDocumentTable(MainRow)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.Recorder AS Recorder,
//	|	value(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.Order,
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.Recorder.PointInTime AS PointInTime,
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.AmountOpeningBalance AS AdvanceOpen,
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.AmountReceipt AS AdvanceReceipt,
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.AmountExpense AS AdvanceExpense,
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.AmountClosingBalance AS AdvanceClosing,
	|	0 AS TransactionOpen,
	|	0 AS TransactionReceipt,
	|	0 AS TransactionExpense,
	|	0 AS TransactionClose
	|INTO tmp
	|FROM
	|	AccumulationRegister.R1020B_AdvancesToVendors.BalanceAndTurnovers(BEGINOFPERIOD(&BeginOfPeriod, DAY),
	|		ENDOFPERIOD(&EndOfPeriod, DAY), Recorder, RegisterRecords, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND LegalName = &LegalName
	|	AND Partner = &Partner
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1020B_AdvancesToVendorsBalanceAndTurnovers
	|
	|UNION ALL
	|
	|SELECT
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.Recorder,
//	|	R1021B_VendorsTransactionsBalanceAndTurnovers.Agreement,
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.Order,
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.Recorder.PointInTime,
	|	0,
	|	0,
	|	0,
	|	0,
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.AmountOpeningBalance,
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.AmountReceipt,
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.AmountExpense,
	|	R1021B_VendorsTransactionsBalanceAndTurnovers.AmountClosingBalance
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.BalanceAndTurnovers(BEGINOFPERIOD(&BeginOfPeriod, DAY),
	|		ENDOFPERIOD(&EndOfPeriod, DAY), Recorder, RegisterRecords, Company = &Company
	|	AND Branch = &Branch
	|	AND Currency = &Currency
	|	AND LegalName = &LegalName
	|	AND Partner = &Partner
	|	AND Agreement = &Agreement
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		R1021B_VendorsTransactionsBalanceAndTurnovers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Recorder AS Document,
//	|	tmp.Agreement,
	|	tmp.Order,
	|	SUM(tmp.AdvanceOpen) AS AdvanceOpen,
	|	SUM(tmp.AdvanceReceipt) AS AdvanceReceipt,
	|	SUM(tmp.AdvanceExpense) AS AdvanceExpense,
	|	SUM(tmp.AdvanceClosing) AS AdvanceClosing,
	|	SUM(tmp.TransactionOpen) AS TransactionOpen,
	|	SUM(tmp.TransactionReceipt) AS TransactionReceipt,
	|	SUM(tmp.TransactionExpense) AS TransactionExpense,
	|	SUM(tmp.TransactionClose) AS TransactionClose
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Recorder,
//	|	tmp.Agreement,
	|	tmp.Order,
	|	tmp.PointInTime
	|ORDER BY
	|	tmp.PointInTime";
	Query.SetParameter("BeginOfPeriod", Period.StartDate);
	Query.SetParameter("EndOfPeriod", Period.EndDate);
	Query.SetParameter("Company", MainRow.Company);
	Query.SetParameter("Branch", MainRow.Branch);
	Query.SetParameter("Currency", MainRow.Currency);
	Query.SetParameter("LegalName", MainRow.LegalName);
	Query.SetParameter("Partner", MainRow.Partner);
	Query.SetParameter("Agreement", MainRow.Agreement);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
	
EndFunction

Function GetMainTable()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R1020B_AdvancesToVendors.Company,
	|	R1020B_AdvancesToVendors.Branch,
	|	R1020B_AdvancesToVendors.Partner,
	|	R1020B_AdvancesToVendors.LegalName,
	|	R1020B_AdvancesToVendors.Currency,
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement 
	//|	R1020B_AdvancesToVendors.Basis
	|INTO tmp
	|FROM
	|	AccumulationRegister.R1020B_AdvancesToVendors AS R1020B_AdvancesToVendors
	|WHERE
	|	R1020B_AdvancesToVendors.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, day) AND ENDOFPERIOD(&EndOfPeriod, day)
	|	AND
	|		R1020B_AdvancesToVendors.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|
	|UNION ALL
	|
	|SELECT
	|	R1021B_VendorsTransactions.Company,
	|	R1021B_VendorsTransactions.Branch,
	|	R1021B_VendorsTransactions.Partner,
	|	R1021B_VendorsTransactions.LegalName,
	|	R1021B_VendorsTransactions.Currency,
	|	R1021B_VendorsTransactions.Agreement 
	//|	R1021B_VendorsTransactions.Basis
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions AS R1021B_VendorsTransactions
	|WHERE
	|	R1021B_VendorsTransactions.Period BETWEEN BEGINOFPERIOD(&BeginOfPeriod, day) AND ENDOFPERIOD(&EndOfPeriod, day)
	|	AND
	|		R1021B_VendorsTransactions.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Partner AS Partner,
	|	tmp.LegalName AS LegalName,
	|	tmp.Currency AS Currency,
	|	tmp.Agreement
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Branch,
	|	tmp.Company,
	|	tmp.Currency,
	|	tmp.Agreement,
	|	tmp.LegalName,
	|	tmp.Partner
	|ORDER BY
	|	Company,
	|	Branch,
	|	Partner,
	|	LegalName,
	|	Currency";
	Query.SetParameter("BeginOfPeriod", Period.StartDate);
	Query.SetParameter("EndOfPeriod", Period.EndDate);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayForDelete = New Array();
	For Each Row In QueryTable Do
		If Not ValueIsFilled(Row.Agreement) Then
			ar = QueryTable.FindRows(New Structure("Company, Branch,Currency, Partner,LegalName",
			Row.Company, Row.Branch,Row.Currency, Row.Partner,Row.LegalName));
			found = False;
			For Each i in ar Do
				If ValueIsFilled(i.Agreement) Then
					found = True;
					break;
				EndIf;
			EndDo;
			if found Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		QueryTable.Delete(ItemForDelete);
	EndDo;
	Return QueryTable;
EndFunction	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	