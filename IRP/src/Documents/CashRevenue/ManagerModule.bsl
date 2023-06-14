#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	QueryArray = GetQueryTextsSecondaryTables();
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
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5021T_Revenues.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3011T_CashFlow.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
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

#EndRegion


#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return "SELECT
		   |	PaymentList.Ref.Date AS Period,
		   |	PaymentList.Ref.Company AS Company,
		   |	PaymentList.Ref.OtherCompany AS OtherCompany,
		   |	PaymentList.Ref.Account AS Account,
		   |	PaymentList.Currency AS Currency,
		   |	PaymentList.RevenueType AS RevenueType,
		   |	PaymentList.NetAmount AS NetAmount,
		   |	PaymentList.TaxAmount AS TaxAmount,
		   |	PaymentList.TotalAmount AS TotalAmount,
		   |	PaymentList.Key,
		   |	PaymentList.ProfitLossCenter,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.Partner,
		   |	PaymentList.AdditionalAnalytic,
		   |	PaymentList.Ref.Branch AS Branch,
		   |	PaymentList.Ref.TransactionType = VALUE(Enum.CashRevenueTransactionTypes.OtherCompanyRevenue) AS
		   |		IsOtherCompanyRevenue
		   |INTO PaymentList
		   |FROM
		   |	Document.CashRevenue.PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3011T_CashFlow());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R5021T_Revenues());
	Return QueryArray;
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		   |	VALUE(AccumulationRecordType.Expense),
		   |	PaymentList.OtherCompany,
		   |	PaymentList.TotalAmount,
		   |	*
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsOtherCompanyRevenue
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
		   |	PaymentList.IsOtherCompanyRevenue";
EndFunction

Function R3011T_CashFlow()
	Return "SELECT
		   |	PaymentList.Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Account,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS Direction,
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
		   |	VALUE(Enum.CashFlowDirections.Outgoing),
		   |	PaymentList.FinancialMovementType,
		   |	UNDEFINED AS PlanningPeriod,
		   |	PaymentList.Currency,
		   |	PaymentList.Key,
		   |	PaymentList.TotalAmount AS Amount
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsOtherCompanyRevenue
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
		   |	PaymentList.IsOtherCompanyRevenue";
EndFunction

Function R5021T_Revenues()
	Return "SELECT
		   |	CASE
		   |		WHEN PaymentList.IsOtherCompanyRevenue
		   |			THEN PaymentList.OtherCompany
		   |		ELSE PaymentList.Company
		   |	END AS Company,
		   |	PaymentList.NetAmount AS Amount,
		   |	PaymentList.TotalAmount AS AmountWithTaxes,
		   |	*
		   |INTO R5021T_Revenues
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	TRUE";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Company AS Company,
		   |	PaymentList.TotalAmount AS Amount,
		   |	*
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.IsOtherCompanyRevenue
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
		   |	PaymentList.IsOtherCompanyRevenue";
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