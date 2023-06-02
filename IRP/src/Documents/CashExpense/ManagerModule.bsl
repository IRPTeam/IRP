#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R9510B_SalaryPayment.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(R3011T_CashFlow());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return 
		"SELECT
		|	PaymentList.Ref.Date AS Period,
		|	PaymentList.Ref.Company AS Company,
		|	PaymentList.Ref.OtherCompany AS OtherCompany,
		|	PaymentList.Ref.Account AS Account,
		|	PaymentList.Currency AS Currency,
		|	PaymentList.PaymentPeriod AS PaymentPeriod,
		|	PaymentList.ExpenseType AS ExpenseType,
		|	PaymentList.NetAmount AS NetAmount,
		|	PaymentList.TaxAmount AS TaxAmount,
		|	PaymentList.TotalAmount AS TotalAmount,
		|	PaymentList.Key,
		|	PaymentList.ProfitLossCenter,
		|	PaymentList.FinancialMovementType,
		|	PaymentList.Partner,
		|	PaymentList.Employee,
		|	PaymentList.AdditionalAnalytic,
		|	PaymentList.Ref.Branch AS Branch,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.CashExpenseTransactionTypes.CurrentCompanyExpense) AS IsCurrentCompanyExpense,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.CashExpenseTransactionTypes.OtherCompanyExpense) AS IsOtherCompanyExpense,
		|	PaymentList.Ref.TransactionType = VALUE(Enum.CashExpenseTransactionTypes.SalaryPayment) AS IsSalaryPayment
		|INTO PaymentList
		|FROM
		|	Document.CashExpense.PaymentList AS PaymentList
		|WHERE
		|	PaymentList.Ref = &Ref";
EndFunction

Function R3010B_CashOnHand()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Company AS Company,
		|	PaymentList.TotalAmount AS Amount,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	PaymentList.OtherCompany,
		|	PaymentList.TotalAmount,
		|	*
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherCompanyExpense
		|	OR PaymentList.IsSalaryPayment
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	PaymentList.OtherCompany,
		|	PaymentList.TotalAmount,
		|	*
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherCompanyExpense
		|	OR PaymentList.IsSalaryPayment";
EndFunction

Function R3011T_CashFlow()
	Return
		"SELECT
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS Direction,
		|	PaymentList.FinancialMovementType,
		|	UNDEFINED AS PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.TotalAmount AS Amount
		|INTO R3011T_CashFlow
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.OtherCompany,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	VALUE(Enum.CashFlowDirections.Incoming),
		|	PaymentList.FinancialMovementType,
		|	UNDEFINED AS PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.TotalAmount AS Amount
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherCompanyExpense
		|	OR PaymentList.IsSalaryPayment
		|
		|UNION ALL
		|
		|SELECT
		|	PaymentList.Period,
		|	PaymentList.OtherCompany,
		|	PaymentList.Branch,
		|	PaymentList.Account,
		|	VALUE(Enum.CashFlowDirections.Outgoing),
		|	PaymentList.FinancialMovementType,
		|	UNDEFINED AS PlanningPeriod,
		|	PaymentList.Currency,
		|	PaymentList.Key,
		|	PaymentList.TotalAmount AS Amount
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherCompanyExpense
		|	OR PaymentList.IsSalaryPayment";
	
EndFunction

Function R5022T_Expenses()
	Return 
		"SELECT
		|	CASE
		|		WHEN PaymentList.IsOtherCompanyExpense
		|			THEN PaymentList.OtherCompany
		|		ELSE PaymentList.Company
		|	END AS Company,
		|	PaymentList.NetAmount AS Amount,
		|	PaymentList.TotalAmount AS AmountWithTaxes,
		|	*
		|INTO R5022T_Expenses
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsCurrentCompanyExpense 
		|	OR PaymentList.IsOtherCompanyExpense";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentList.Company AS Company,
		|	PaymentList.TotalAmount AS Amount,
		|	*
		|INTO R3027B_EmployeeCashAdvance
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherCompanyExpense
		|	OR PaymentList.IsSalaryPayment
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	PaymentList.OtherCompany,
		|	PaymentList.TotalAmount,
		|	*
		|FROM
		|	PaymentList AS PaymentList
		|WHERE
		|	PaymentList.IsOtherCompanyExpense";
EndFunction

Function R9510B_SalaryPayment()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	PaymentList.Period,
		|	PaymentList.Company,
		|	PaymentList.Currency,
		|	PaymentList.TotalAmount AS Amount,
		|	PaymentList.Key,
		|	PaymentList.Employee,
		|	PaymentList.PaymentPeriod,
		|	PaymentList.Branch
		|INTO R9510B_SalaryPayment
		|FROM
		|	PaymentList AS PaymentLIst
		|WHERE
		|	PaymentList.IsSalaryPayment";
EndFunction
