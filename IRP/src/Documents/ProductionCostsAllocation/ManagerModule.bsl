#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.IsReposting = False;
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	InfoReg = Metadata.InformationRegisters.T6060S_BatchCostAllocationInfo.Dimensions;
	AllocationInfoTable = New ValueTable();
	AllocationInfoTable.Columns.Add("Document" , InfoReg.Document.Type);
	AllocationInfoTable.Columns.Add("Store"    , InfoReg.Store.Type);
	AllocationInfoTable.Columns.Add("ItemKey"  , InfoReg.ItemKey.Type);
	AllocationInfoTable.Columns.Add("Amount"   , Metadata.DefinedTypes.typeAmount.Type);
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	DurationsList.BusinessUnit,
	|	DurationsList.ItemKey,
	|	DurationsList.Duration,
	|	DurationsList.Amount
	|FROM
	|	Document.ProductionCostsAllocation.ProductionDurationsList AS DurationsList
	|WHERE
	|	DurationsList.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	BeginDate = BegOfDay(Ref.BeginDate);
	EndDate   = EndOfDay(Ref.EndDate);
	Company = Ref.Company;
	
	While QuerySelection.Next() Do
		AllocationInfo = GetAllocationInfo(QuerySelection.BusinessUnit, 
			QuerySelection.ItemKey, 
			QuerySelection.Duration, 
			QuerySelection.Amount,
			Company,
			BeginDate,
			EndDate);
		For Each Row In AllocationInfo Do
			NewRow = AllocationInfoTable.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndDo;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = 
	"SELECT
	|	*
	|INTO BatchKeysInfo
	|FROM
	|	&T1 AS T1";
	Query.SetParameter("T1", AllocationInfoTable);
	Query.Execute();
	
	Return Tables;
EndFunction

Function GetAllocationInfo(BusinessUnit, ItemKey, Duration, Amount,Company, BeginDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T7051S_ProductionDurationDetails.ItemKey,
	|	T7051S_ProductionDurationDetails.Document,
	|	T7051S_ProductionDurationDetails.Store,
	|	0 AS Amount,
	|	SUM(T7051S_ProductionDurationDetails.Duration) AS Duration
	|FROM
	|	InformationRegister.T7051S_ProductionDurationDetails AS T7051S_ProductionDurationDetails
	|WHERE
	|	T7051S_ProductionDurationDetails.Company = &Company
	|	AND T7051S_ProductionDurationDetails.BusinessUnit = &BusinessUnit
	|	AND T7051S_ProductionDurationDetails.ItemKey = &ItemKey
	|	AND T7051S_ProductionDurationDetails.Period BETWEEN BEGINOFPERIOD(&BeginDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|GROUP BY
	|	T7051S_ProductionDurationDetails.ItemKey,
	|	T7051S_ProductionDurationDetails.Document,
	|	T7051S_ProductionDurationDetails.Store";
	Query.SetParameter("Company"      , Company);
	Query.SetParameter("BusinessUnit" , BusinessUnit);
	Query.SetParameter("ItemKey"      , ItemKey);
	Query.SetParameter("BeginDate"    , BeginDate);
	Query.SetParameter("EndDate"      , EndDate);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
		
	CostOneHour = 0;
	If Duration <> 0 Then
		CostOneHour = Round(Amount / Duration, 2, RoundMode.Round15as10);
	EndIf;
	
	MaxRow = Undefined;
	For Each Row In QueryTable Do
		If MaxRow = Undefined Then
			MaxRow = Row;
		Else
			If MaxRow.Duration < Row.Duration Then
				MaxRow = Row;
			EndIf;
		EndIf;
			
		Row.Amount = Row.Duration * CostOneHour;
	EndDo;	
	
	AllocatedAmount = QueryTable.Total("Amount");
	
	If Amount <> AllocatedAmount Then
		MaxRow.Amount = MaxRow.Amount + (Amount - AllocatedAmount);
	EndIf;
	Return QueryTable;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
		
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
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
	StrParams.Insert("Period", EndOfDay(Ref.EndDate));
	StrParams.Insert("Company", Ref.Company);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(T6020S_BatchKeysInfo());
	Return QueryArray;
EndFunction

Function T6020S_BatchKeysInfo()
	Return
		"SELECT
		|	&Period AS Period,
		|	&Company AS Company,
		|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
		|	BatchKeysInfo.Store,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Document AS ProductionDocument,
		|	BatchKeysInfo.Amount AS NotDirectCosts
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo AS BatchKeysInfo
		|WHERE
		|	TRUE";
EndFunction

