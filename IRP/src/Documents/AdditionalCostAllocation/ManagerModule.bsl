
#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Parameters.IsReposting = False;
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
	
	Tables.R6070T_OtherPeriodsExpenses.Columns.Add("Key"           , Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("Key"        , Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("RowID"      , Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("BasisRowID" , Metadata.DefinedTypes.typeRowID.Type);
	Tables.T6060S_BatchCostAllocationInfo.Columns.Add("Basis"      ,
		Metadata.AccumulationRegisters.R6070T_OtherPeriodsExpenses.Dimensions.Basis.Type);
	
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
		
		PostingDataTables = New Map();
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.R6070T_OtherPeriodsExpenses,
			New Structure("RecordSet, WriteInTransaction", OtherPeriodsExpensesByBasis, Parameters.IsReposting));
		Parameters.Insert("PostingDataTables", PostingDataTables);
		
		CostAllocationObject = Parameters.Object;
		Parameters.Object = Basis;
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
		Parameters.Object = CostAllocationObject;
		
		For Each RowRecordSet In Parameters.PostingDataTables.Get(Parameters.Object.RegisterRecords.R6070T_OtherPeriodsExpenses).RecordSet Do
			FillPropertyValues(TableOtherPeriodsExpensesRecalculated.Add(), RowRecordSet);
		EndDo;
	EndDo;
	Tables.R6070T_OtherPeriodsExpenses = TableOtherPeriodsExpensesRecalculated;
	
	// BatchCostAllocationInfo
	CurrencyMovementType = Ref.Company.LandedCostCurrencyMovementType;
	BatchCostAllocationInfoRecalculated = Tables.T6060S_BatchCostAllocationInfo.CopyColumns();
	For Each Row In Tables.T6060S_BatchCostAllocationInfo Do
		CurrencyTable = Row.Basis.Currencies.Unload();
		
		BatchCostAllocationInfoByBasis = 
		Tables.T6060S_BatchCostAllocationInfo.Copy(New Structure("RowID, BasisRowID", Row.RowID, Row.BasisRowID));
		If TypeOf(Row.Basis) = Type("DocumentRef.PurchaseInvoice") Then
			If CurrencyTable.Count() Then
				BatchCostAllocationInfoByBasis.FillValues(CurrencyTable[0].Key, "Key");
			EndIf;	
		EndIf;
	
		PostingDataTables = New Map();
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.T6060S_BatchCostAllocationInfo,
			New Structure("RecordSet, WriteInTransaction", BatchCostAllocationInfoByBasis, Parameters.IsReposting));
		Parameters.Insert("PostingDataTables", PostingDataTables);
		
		CostAllocationObject = Parameters.Object;
		Parameters.Object = Row.Basis;
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
		Parameters.Object = CostAllocationObject;
		
		For Each RowRecordSet In Parameters
		                .PostingDataTables
		                .Get(Parameters.Object.RegisterRecords.T6060S_BatchCostAllocationInfo)
		                .RecordSet Do
			FillPropertyValues(BatchCostAllocationInfoRecalculated.Add(), RowRecordSet);
		EndDo;	
	EndDo;
	
	BatchCostAllocationInfoRecalculated = BatchCostAllocationInfoRecalculated.Copy(New Structure("CurrencyMovementType", CurrencyMovementType));
	BatchCostAllocationInfoRecalculated.GroupBy("Period, Company, Document, Store, ItemKey, Currency, CurrencyMovementType", 
	"Amount");	
	Tables.T6060S_BatchCostAllocationInfo = BatchCostAllocationInfoRecalculated;
	
	OtherPeriodsExpensesMetadata    = Parameters.Object.RegisterRecords.R6070T_OtherPeriodsExpenses.Metadata();
	BatchCostAllocationInfoMetadata = Parameters.Object.RegisterRecords.T6060S_BatchCostAllocationInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(OtherPeriodsExpensesMetadata);
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchCostAllocationInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array();
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(OtherPeriodsExpensesMetadata);
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchCostAllocationInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
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
	DataMapWithLockFields = New Map();
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

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
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
	QueryArray = New Array;
	QueryArray.Add(CostList());
	QueryArray.Add(AllocationList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R6070T_OtherPeriodsExpenses());
	QueryArray.Add(T6060S_BatchCostAllocationInfo());
	Return QueryArray;
EndFunction

Function CostList()
	Return
	"SELECT
	|	CostList.Ref.Date AS Period,
	|	CostList.Ref.Company AS Company,
	|	CostList.Ref.Branch AS Branch,
	|	CostList.Basis AS Basis,
	|	CostList.ItemKey AS ItemKey,
	|	CostList.RowID AS RowID,
	|	CostList.Basis.Currency AS Currency,
	|	CostList.RowID AS Key,
	|	SUM(ISNULL(AllocationList.Amount, 0)) AS Amount,
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
	|	CostList.Ref.Branch,
	|	CostList.Ref.Company,
	|	CostList.Ref.Date,
	|	CostList.RowID";
EndFunction

Function AllocationList()
	Return
	"SELECT
	|	AllocationList.Ref.Date AS Period,
	|	AllocationList.Ref.Company AS Company,
	|	AllocationList.Document AS Document,
	|	AllocationList.Store AS Store,
	|	AllocationList.ItemKey AS ItemKey,
	|	SUM(AllocationList.Amount) AS Amount,
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

Function R6070T_OtherPeriodsExpenses()
	Return
	"SELECT
	|	*,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType
	|INTO R6070T_OtherPeriodsExpenses
	|FROM
	|	CostList AS CostList
	|WHERE
	|	TRUE";
EndFunction

Function T6060S_BatchCostAllocationInfo()
	Return
	"SELECT
	|	*
	|INTO T6060S_BatchCostAllocationInfo
	|FROM
	|	AllocationList AS AllocationList
	|WHERE
	|	TRUE";
EndFunction
