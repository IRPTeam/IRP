
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
		
		DocumentTable = GetDocumentTable(MainRow);
		For Each DocumentRow In DocumentTable Do
			Area_Row = Template.GetArea("Row");
			Area_Row.Parameters.Fill(DocumentRow);
			Area_Row.Parameters.Fill(GetCorrespondent(MainRow, DocumentRow));
			Doc.Put(Area_Row);
		EndDo;
	EndDo;
	
EndProcedure

Function GetCorrespondent(MainRow, DocumentRow)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CASE
	|		WHEN T2010S_OffsetOfAdvances.Document = T2010S_OffsetOfAdvances.TransactionDocument
	|			THEN T2010S_OffsetOfAdvances.AdvancesDocument
	|		WHEN T2010S_OffsetOfAdvances.Document = T2010S_OffsetOfAdvances.AdvancesDocument
	|			THEN T2010S_OffsetOfAdvances.TransactionDocument
	|	END AS Correspondent,
	|	T2010S_OffsetOfAdvances.LineNumber
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS T2010S_OffsetOfAdvances
	|WHERE
	|	T2010S_OffsetOfAdvances.Company = &Company
	|	AND T2010S_OffsetOfAdvances.Branch = &Branch
	|	AND T2010S_OffsetOfAdvances.Currency = &Currency
	|	AND T2010S_OffsetOfAdvances.Partner = &Partner
	|	AND T2010S_OffsetOfAdvances.LegalName = &LegalName
	|	AND T2010S_OffsetOfAdvances.Agreement = &Agreement
	|	AND T2010S_OffsetOfAdvances.Document = &Document";
	Query.SetParameter("Company", MainRow.Company);
	Query.SetParameter("Branch", MainRow.Branch);
	Query.SetParameter("Currency", MainRow.Currency);
	Query.SetParameter("LegalName", MainRow.LegalName);
	Query.SetParameter("Partner", MainRow.Partner);
	Query.SetParameter("Agreement", MainRow.Agreement);
	Query.SetParameter("Document", DocumentRow.Document);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection;
	EndIf;
	Return New Structure("Correspondent, LineNumber", "---", "");
EndFunction

Function GetDocumentTable(MainRow)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	R1020B_AdvancesToVendorsBalanceAndTurnovers.Recorder AS Recorder,
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
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Recorder AS Document,
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
	|	VALUE(Catalog.Agreements.EmptyRef) AS Agreement,
	|	R1020B_AdvancesToVendors.Basis
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
	|	R1021B_VendorsTransactions.Agreement,
	|	R1021B_VendorsTransactions.Basis
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
	|	tmp.Company,
	|	tmp.Branch,
	|	tmp.Partner,
	|	tmp.LegalName,
	|	tmp.Currency,
	|	max(tmp.Agreement) as Agreement
	//|	tmp.Basis
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	
	//|	tmp.Basis,
	|	tmp.Branch,
	|	tmp.Company,
	|	tmp.Currency,
	|	tmp.LegalName,
	|	tmp.Partner";
	Query.SetParameter("BeginOfPeriod", Period.StartDate);
	Query.SetParameter("EndOfPeriod", Period.EndDate);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	