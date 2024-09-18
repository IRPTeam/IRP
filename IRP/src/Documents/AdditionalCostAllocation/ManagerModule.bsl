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
	Parameters.IsReposting = False;
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
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

	Tables.R6070T_OtherPeriodsExpenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T1040T_AccountingAmounts.Columns.Add("Basis", New TypeDescription("DocumentRef.PurchaseInvoice"));
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("RowID", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("BasisRowID", Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("Basis", Metadata.AccumulationRegisters.R6070T_OtherPeriodsExpenses.Dimensions.Basis.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
	
	// OtherPeriodsExpenses
	TableOtherPeriodsExpenses = Tables.R6070T_OtherPeriodsExpenses.Copy();
	TableOtherPeriodsExpenses.GroupBy("Basis");
	ArrayOfBasises = TableOtherPeriodsExpenses.UnloadColumn("Basis");

	TableOtherPeriodsExpensesRecalculated = Tables.R6070T_OtherPeriodsExpenses.CopyColumns();
	For Each Basis In ArrayOfBasises Do

		CurrencyTable = Basis.Currencies.Unload();

		OtherPeriodsExpensesByBasis = Tables.R6070T_OtherPeriodsExpenses.Copy(New Structure("Basis", Basis));
		If TypeOf(Basis) = Type("DocumentRef.PurchaseInvoice") Then
			If CurrencyTable.Count() Then
				OtherPeriodsExpensesByBasis.FillValues(CurrencyTable[0].Key, "Key");
			EndIf;
		EndIf;

		R6070T_OtherPeriodsExpenses = Metadata.AccumulationRegisters.R6070T_OtherPeriodsExpenses;
		PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, R6070T_OtherPeriodsExpenses.Name, OtherPeriodsExpensesByBasis);
		Parameters.PostingDataTables[R6070T_OtherPeriodsExpenses].WriteInTransaction = Parameters.IsReposting;

		CostAllocationObject = Parameters.Object;
		Parameters.Object = Basis;
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
		Parameters.Object = CostAllocationObject;

		For Each RowRecordSet In Parameters.PostingDataTables[R6070T_OtherPeriodsExpenses].PrepareTable Do
			FillPropertyValues(TableOtherPeriodsExpensesRecalculated.Add(), RowRecordSet);
		EndDo;
		Parameters.PostingDataTables.Delete(R6070T_OtherPeriodsExpenses);
	EndDo;
	Tables.R6070T_OtherPeriodsExpenses = TableOtherPeriodsExpensesRecalculated;

	// Accounting amounts
	For Each Row In Ref.AllocationResult Do
		Rows = Tables.T1040T_AccountingAmounts.FindRows(New Structure("RowKey", Row.Key));
		If Rows.Count() Then
			Rows[0].Basis = Row.ExpensePurchaseInvoice;
		EndIf;
	EndDo;
	
	TableAccountingAmounts = Tables.T1040T_AccountingAmounts.Copy();
	TableAccountingAmounts.GroupBy("Basis");
	ArrayOfBasises = TableAccountingAmounts.UnloadColumn("Basis");

	TableAccountingAmountsRecalculated = Tables.T1040T_AccountingAmounts.CopyColumns();
	For Each Basis In ArrayOfBasises Do

		CurrencyTable = Basis.Currencies.Unload();

		AccountingAmountsByBasis = Tables.T1040T_AccountingAmounts.Copy(New Structure("Basis", Basis));
		If TypeOf(Basis) = Type("DocumentRef.PurchaseInvoice") Then
			If CurrencyTable.Count() Then
				AccountingAmountsByBasis.FillValues(CurrencyTable[0].Key, "Key");
			EndIf;
		EndIf;

		T1040T_AccountingAmounts = Metadata.AccumulationRegisters.T1040T_AccountingAmounts;
		PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, T1040T_AccountingAmounts.Name, AccountingAmountsByBasis);
		Parameters.PostingDataTables[T1040T_AccountingAmounts].WriteInTransaction = Parameters.IsReposting;

		CostAllocationObject = Parameters.Object;
		Parameters.Object = Basis;
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
		Parameters.Object = CostAllocationObject;

		For Each RowRecordSet In Parameters.PostingDataTables[T1040T_AccountingAmounts].PrepareTable Do
			FillPropertyValues(TableAccountingAmountsRecalculated.Add(), RowRecordSet);
		EndDo;
		Parameters.PostingDataTables.Delete(T1040T_AccountingAmounts);
	EndDo;
	Tables.T1040T_AccountingAmounts = TableAccountingAmountsRecalculated;
	
	// BatchCostAllocationInfo
	CurrencyMovementType = Ref.Company.LandedCostCurrencyMovementType;
	BatchCostAllocationInfoRecalculated = Tables.T6060S_BatchCostAllocationInfo.CopyColumns();
	For Each Row In Tables.T6060S_BatchCostAllocationInfo Do
		CurrencyTable = Row.Basis.Currencies.Unload();

		BatchCostAllocationInfoByBasis = Tables.T6060S_BatchCostAllocationInfo.Copy(New Structure("RowID, BasisRowID", Row.RowID, Row.BasisRowID));
		If TypeOf(Row.Basis) = Type("DocumentRef.PurchaseInvoice") Then
			If CurrencyTable.Count() Then
				BatchCostAllocationInfoByBasis.FillValues(CurrencyTable[0].Key, "Key");
			EndIf;
		EndIf;

		T6060S_BatchCostAllocationInfo = Metadata.InformationRegisters.T6060S_BatchCostAllocationInfo;
		PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, T6060S_BatchCostAllocationInfo.Name, BatchCostAllocationInfoByBasis);
		Parameters.PostingDataTables[T6060S_BatchCostAllocationInfo].WriteInTransaction = Parameters.IsReposting;			
			
		CostAllocationObject = Parameters.Object;
		Parameters.Object = Row.Basis;
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
		Parameters.Object = CostAllocationObject;

		For Each RowRecordSet In Parameters.PostingDataTables[T6060S_BatchCostAllocationInfo].PrepareTable Do
			FillPropertyValues(BatchCostAllocationInfoRecalculated.Add(), RowRecordSet);
		EndDo;
		Parameters.PostingDataTables.Delete(T6060S_BatchCostAllocationInfo);
	EndDo;

	BatchCostAllocationInfoRecalculated = BatchCostAllocationInfoRecalculated.Copy(
		New Structure("CurrencyMovementType", CurrencyMovementType));
	BatchCostAllocationInfoRecalculated.GroupBy("Period, Company, Document, Store, ItemKey, Currency, CurrencyMovementType", "Amount, AmountTax");
	Tables.T6060S_BatchCostAllocationInfo = BatchCostAllocationInfoRecalculated;

	BatchKeysInfo = BatchCostAllocationInfoRecalculated.Copy();
	BatchKeysInfo.GroupBy("Period, Company, Document, Store, ItemKey", "Amount, AmountTax");
	BatchKeysInfo.Columns.Document.Name  = "PurchaseInvoiceDocument";
	BatchKeysInfo.Columns.Amount.Name    = "AllocatedCostAmount";
	BatchKeysInfo.Columns.AmountTax.Name = "AllocatedCostTaxAmount";
	BatchKeysInfo.Columns.Add("Direction");
	BatchKeysInfo.FillValues(Enums.BatchDirection.Receipt, "Direction");
	Tables.T6020S_BatchKeysInfo = BatchKeysInfo;

	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.AccumulationRegisters.R6070T_OtherPeriodsExpenses);
	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.AccumulationRegisters.T1040T_AccountingAmounts);
	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.InformationRegisters.T6060S_BatchCostAllocationInfo);	
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
	Parameters.Insert("RecordType", AccumulationRecordType.Receipt);
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
	QueryArray.Add(CostList());
	QueryArray.Add(AllocationList());
	QueryArray.Add(AllocationResult());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R6070T_OtherPeriodsExpenses());
	QueryArray.Add(T6060S_BatchCostAllocationInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(T1040T_AccountingAmounts());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function CostList()
	Return "SELECT
		   |	CostList.Ref.Date AS Period,
		   |	CostList.Ref.Company AS Company,
		   |	CostList.Ref.Branch AS Branch,
		   |	CostList.Basis AS Basis,
		   |	CostList.ItemKey AS ItemKey,
		   |	CostList.RowID AS RowID,
		   |	CostList.Basis.Currency AS Currency,
		   |	CostList.RowID AS Key,
		   |	CostList.ExpenseType,
		   |	CostList.ProfitLossCenter,
		   |	SUM(ISNULL(AllocationList.Amount, 0)) AS Amount,
		   |	SUM(ISNULL(AllocationList.TaxAmount, 0)) AS AmountTax,
		   |	AllocationList.RowID
		   |INTO CostList
		   |FROM
		   |	Document.AdditionalCostAllocation.CostList AS CostList
		   |		LEFT JOIN Document.AdditionalCostAllocation.AllocationList AS AllocationList
		   |		ON CostList.RowID = AllocationList.BasisRowID
		   |		AND CostList.Ref = &Ref
		   |		AND AllocationList.Ref = &Ref
		   |WHERE
		   |	CostList.Ref = &Ref
		   |	AND NOT AllocationList.RowID IS NULL
		   |GROUP BY
		   |	AllocationList.RowID,
		   |	CostList.Basis,
		   |	CostList.Basis.Currency,
		   |	CostList.ItemKey,
		   |	CostList.ExpenseType,
		   |	CostList.ProfitLossCenter,
		   |	CostList.Ref.Branch,
		   |	CostList.Ref.Company,
		   |	CostList.Ref.Date,
		   |	CostList.RowID";
EndFunction

Function AllocationList()
	Return "SELECT
		   |	AllocationList.Ref.Date AS Period,
		   |	AllocationList.Ref.Company AS Company,
		   |	AllocationList.Document AS Document,
		   |	AllocationList.Store AS Store,
		   |	AllocationList.ItemKey AS ItemKey,
		   |	SUM(AllocationList.Amount) AS Amount,
		   |	SUM(AllocationList.TaxAmount) AS AmountTax,
		   |	CostList.Currency AS Currency,
		   |	CostList.Basis AS Basis,
		   |	AllocationList.RowID AS Key,
		   |	AllocationList.RowID AS RowID,
		   |	AllocationList.BasisRowID AS BasisRowID
		   |INTO AllocationList
		   |FROM
		   |	Document.AdditionalCostAllocation.AllocationList AS AllocationList
		   |		LEFT JOIN Document.AdditionalCostAllocation.CostList AS CostList
		   |		ON AllocationList.BasisRowID = CostList.RowID
		   |		AND AllocationList.Ref = &Ref
		   |		AND CostList.Ref = &Ref
		   |WHERE
		   |	AllocationList.Ref = &Ref
		   |GROUP BY
		   |	CostList.Currency,
		   |	CostList.Basis,
		   |	AllocationList.ItemKey,
		   |	AllocationList.Document,
		   |	AllocationList.Ref.Company,
		   |	AllocationList.Ref.Company.LandedCostCurrencyMovementType,
		   |	AllocationList.Ref.Date,
		   |	AllocationList.Store,
		   |	AllocationList.RowID,
		   |	AllocationList.BasisRowID";
EndFunction

Function AllocationResult()
	Return
		"SELECT
		|	AllocationResult.Ref.Date AS Period,
		|	AllocationResult.Key,
		|	AllocationResult.Currency,
		|	AllocationResult.Amount,
		|	AllocationResult.ExpensePurchaseInvoice
		|INTO AllocationResult
		|FROM
		|	Document.AdditionalCostAllocation.AllocationResult AS AllocationResult
		|WHERE
		|	AllocationResult.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R6070T_OtherPeriodsExpenses()
	Return
	"SELECT
	|	CostList.Period AS Period,
	|	CostList.Company AS Company,
	|	CostList.Branch AS Branch,
	|	CostList.Basis AS Basis,
	|	CostList.ExpenseType,
	|	CostList.ProfitLossCenter,
	|	CostList.ItemKey AS ItemKey,
	|	CostList.RowID AS RowID,
	|	CostList.Currency AS Currency,
	|	CostList.Key AS Key,
	|	CostList.Amount AS Amount,
	|	CostList.AmountTax AS AmountTax,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	VALUE(enum.OtherPeriodExpenseType.ItemsCost) AS OtherPeriodExpenseType
	|INTO R6070T_OtherPeriodsExpenses
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
EndFunction

Function T6060S_BatchCostAllocationInfo()
	Return "SELECT
		   |	*
		   |INTO T6060S_BatchCostAllocationInfo
		   |FROM
		   |	AllocationList AS AllocationList
		   |WHERE
		   |	TRUE";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	AllocationList.Period,
		   |	AllocationList.Company,
		   |	VALUE(Enum.BatchDirection.Receipt) AS Direction,
		   |	AllocationList.Store AS Store,
		   |	AllocationList.ItemKey AS ItemKey,
		   |	AllocationList.Document AS PurchaseInvoiceDocument,
		   |	SUM(AllocationList.Amount) AS AllocatedCostAmount,
		   |	SUM(AllocationList.AmountTax) AS AllocatedCostTaxAmount
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	AllocationList AS AllocationList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	AllocationList.Period,
		   |	AllocationList.Company,
		   |	VALUE(Enum.BatchDirection.Receipt),
		   |	AllocationList.Store,
		   |	AllocationList.ItemKey,
		   |	AllocationList.Document";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObject.AdditionalCostAllocation -
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

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	AllocationResult.Period,
		|	AllocationResult.Key AS RowKey,
		|	AllocationResult.Currency,
		|	AllocationResult.Currency AS DrCurrency,
		|	AllocationResult.Currency AS CrCurrency,
		|	AllocationResult.Amount,
		|	AllocationResult.Amount AS DrCurrencyAmount,
		|	AllocationResult.Amount AS CrCurrencyAmount,
		|	VALUE(Catalog.AccountingOperations.AdditionalCostAllocation_DR_R4050B_StockInventory_CR_R5022T_Expenses) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	AllocationResult AS AllocationResult
		|WHERE
		|	TRUE";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	AO = Catalogs.AccountingOperations;
	If Parameters.Operation = AO.AdditionalCostAllocation_DR_R4050B_StockInventory_CR_R5022T_Expenses Then
		
		Return GetAnalytics_DR_R4050B_StockInventory_CR_R5022T_Expenses(Parameters); // Stock inventory - Expenses
		
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

Function GetAnalytics_DR_R4050B_StockInventory_CR_R5022T_Expenses(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	AccountingAnalytics.Debit = Debit.Account;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("ItemKey", Parameters.RowData.ItemKey);
	AdditionalAnalytics.Insert("Item", Parameters.RowData.Item);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9014S_AccountsExpenseRevenue(AccountParameters, 
	                                                          Parameters.RowData.ExpenseType,
	                                                          Parameters.RowData.ProfitLossCenter);
	
	AccountingAnalytics.Credit = Credit.AccountOtherPeriodsExpense;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion