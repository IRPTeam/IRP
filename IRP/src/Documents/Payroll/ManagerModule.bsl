#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R9510B_SalaryPayment.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Return;
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(AccrualList());
	QueryArray.Add(DeductionList());
	QueryArray.Add(CashAdvanceDeductionList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R5021T_Revenues());
	QueryArray.Add(R5022T_Expenses());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(R9545T_PaidVacations());
	QueryArray.Add(R9555T_PaidSickLeaves());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function AccrualList()
	Return 
		"SELECT
		|	AccrualList.Key,
		|	AccrualList.Ref.Date AS Period,
		|	AccrualList.Ref.Company AS Company,
		|	AccrualList.Ref.Branch AS Branch,
		|	AccrualList.Ref.Currency AS Currency,
		|	AccrualList.Ref.PaymentPeriod AS PaymentPeriod,
		|	AccrualList.Ref.CalculationType AS CalculationType,
		|	AccrualList.Employee,
		|	AccrualList.ExpenseType,
		|	AccrualList.ProfitLossCenter,
		|	AccrualList.Amount,
		|	AccrualList.PaidVacationDays,
		|	AccrualList.PaidSickLeaveDays
		|INTO AccrualList
		|FROM
		|	Document.Payroll.AccrualList AS AccrualList
		|WHERE
		|	AccrualList.Ref = &Ref";
EndFunction

Function DeductionList()
	Return "SELECT
		   |	DeductionList.Key,
		   |	DeductionList.Ref.Date AS Period,
		   |	DeductionList.Ref.Company AS Company,
		   |	DeductionList.Ref.Branch AS Branch,
		   |	DeductionList.Ref.Currency AS Currency,
		   |	DeductionList.Ref.PaymentPeriod AS PaymentPeriod,
		   |	DeductionList.Ref.CalculationType AS CalculationType,
		   |	DeductionList.Employee,
		   |	DeductionList.ExpenseType,
		   |	DeductionList.ProfitLossCenter,
		   |	DeductionList.IsRevenue,
		   |	DeductionList.Amount
		   |INTO DeductionList
		   |FROM
		   |	Document.Payroll.DeductionList AS DeductionList
		   |WHERE
		   |	DeductionList.Ref = &Ref";
EndFunction

Function CashAdvanceDeductionList()
	Return "SELECT
		   |	CashAdvanceDeductionList.Key,
		   |	CashAdvanceDeductionList.Ref.Date AS Period,
		   |	CashAdvanceDeductionList.Ref.Company AS Company,
		   |	CashAdvanceDeductionList.Ref.Branch AS Branch,
		   |	CashAdvanceDeductionList.Ref.Currency AS Currency,
		   |	CashAdvanceDeductionList.Ref.PaymentPeriod AS PaymentPeriod,
		   |	CashAdvanceDeductionList.Employee,
		   |	CashAdvanceDeductionList.Amount
		   |INTO CashAdvanceDeductionList
		   |FROM
		   |	Document.Payroll.CashAdvanceDeductionList AS CashAdvanceDeductionList
		   |WHERE
		   |	CashAdvanceDeductionList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R5022T_Expenses()
	Return 
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Key,
		|	AccrualList.Company,
		|	AccrualList.Branch,
		|	AccrualList.Currency,
		|	AccrualList.ExpenseType,
		|	AccrualList.ProfitLossCenter,
		|	AccrualList.Amount AS Amount
		|INTO R5022T_Expenses
		|FROM
		|	AccrualList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Company,
		|	DeductionList.Branch,
		|	DeductionList.Currency,
		|	DeductionList.ExpenseType,
		|	DeductionList.ProfitLossCenter,
		|	-DeductionList.Amount AS Amount
		|FROM
		|	DeductionList
		|WHERE
		|	NOT DeductionList.IsRevenue";
EndFunction

Function R5021T_Revenues()
	Return 
		"SELECT
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Company,
		|	DeductionList.Branch,
		|	DeductionList.Currency,
		|	DeductionList.ExpenseType AS RevenueType,
		|	DeductionList.ProfitLossCenter,
		|	DeductionList.Amount AS Amount
		|INTO R5021T_Revenues
		|FROM
		|	DeductionList
		|WHERE
		|	DeductionList.IsRevenue";
EndFunction

Function R9510B_SalaryPayment()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	AccrualList.Period,
		|	AccrualList.Key,
		|	AccrualList.Company,
		|	AccrualList.Branch,
		|	AccrualList.Currency,
		|	AccrualList.PaymentPeriod,
		|	AccrualList.CalculationType,
		|	AccrualList.Employee,
		|	AccrualList.Amount
		|INTO R9510B_SalaryPayment
		|FROM
		|	AccrualList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	DeductionList.Period,
		|	DeductionList.Key,
		|	DeductionList.Company,
		|	DeductionList.Branch,
		|	DeductionList.Currency,
		|	DeductionList.PaymentPeriod,
		|	DeductionList.CalculationType,
		|	DeductionList.Employee,
		|	DeductionList.Amount
		|FROM
		|	DeductionList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	CashAdvanceDeductionList.Period,
		|	CashAdvanceDeductionList.Key,
		|	CashAdvanceDeductionList.Company,
		|	CashAdvanceDeductionList.Branch,
		|	CashAdvanceDeductionList.Currency,
		|	CashAdvanceDeductionList.PaymentPeriod,
		|	CashAdvanceDeductionList.Employee,
		|	CashAdvanceDeductionList.Amount
		|FROM
		|	CashAdvanceDeductionList
		|WHERE
		|	TRUE";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	CashAdvanceDeductionList.Period,
		|	CashAdvanceDeductionList.Key,
		|	CashAdvanceDeductionList.Company,
		|	CashAdvanceDeductionList.Branch,
		|	CashAdvanceDeductionList.Currency,
		|	CashAdvanceDeductionList.Employee AS Partner,
		|	CashAdvanceDeductionList.Amount
		|INTO R3027B_EmployeeCashAdvance
		|FROM
		|	CashAdvanceDeductionList
		|WHERE
		|	TRUE";
EndFunction

Function R9545T_PaidVacations()
	Return
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Company,
		|	AccrualList.Employee,
		|	AccrualList.PaidVacationDays AS Paid
		|INTO R9545T_PaidVacations
		|FROM
		|	AccrualList AS AccrualList
		|WHERE
		|	AccrualList.PaidVacationDays <> 0";
EndFunction

Function R9555T_PaidSickLeaves()
	Return
		"SELECT
		|	AccrualList.Period,
		|	AccrualList.Company,
		|	AccrualList.Employee,
		|	AccrualList.PaidSickLeaveDays AS Paid
		|INTO R9555T_PaidSickLeaves
		|FROM
		|	AccrualList AS AccrualList
		|WHERE
		|	AccrualList.PaidSickLeaveDays <> 0";	
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion