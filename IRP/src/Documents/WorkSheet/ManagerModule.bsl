#Region POSTING

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
	PostingServer.SetRegisters(Tables, Ref, True);	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters, True);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region UNDOPOSTING

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CHECK_AFTER_WRITE

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "TableDataPath", "Object.Materials");
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.WorkSheet.Materials", AddInfo);
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
	QueryArray.Add(Materials());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	Return QueryArray;
EndFunction

Function Materials()
	Return
	"SELECT
	|	WorkSheetItemList.Ref.Date AS Period,
	|	WorkSheetItemList.ItemKey AS Work,
	|	WorkSheetMaterials.Ref AS WorkSheet,
	|	WorkSheetMaterials.Ref.Company AS Company,
	|	WorkSheetMaterials.Ref.Branch AS Branch,
	|	WorkSheetMaterials.ItemKey,
	|	WorkSheetMaterials.Store,
	|	WorkSheetMaterials.CostWriteOff = VALUE(Enum.MaterialsCostWriteOff.IncludeToWorkCost) AS IncludeToWorkCost,
	|	WorkSheetMaterials.QuantityInBaseUnit AS Quantity
	|INTO Materials
	|FROM
	|	Document.WorkSheet.Materials AS WorkSheetMaterials
	|		INNER JOIN Document.WorkSheet.ItemList AS WorkSheetItemList
	|		ON WorkSheetItemList.Key = WorkSheetMaterials.KeyOwner
	|		AND WorkSheetItemList.Ref = WorkSheetMaterials.Ref
	|		AND WorkSheetMaterials.QuantityInBaseUnit <> 0
	|		AND WorkSheetItemList.Ref = &Ref
	|		AND WorkSheetMaterials.Ref = &Ref";
EndFunction

Function R4010B_ActualStocks()
	Return
	"SELECT
	|	Materials.Period,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Materials.ItemKey,
	|	Materials.Store,
	|	Materials.Quantity
	|INTO R4010B_ActualStocks
	|FROM
	|	Materials AS Materials
	|WHERE
	|	Materials.IncludeToWorkCost";
EndFunction

Function R4011B_FreeStocks()
	Return
	"SELECT
	|	Materials.Period,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Materials.ItemKey,
	|	Materials.Store,
	|	Materials.Quantity
	|INTO R4011B_FreeStocks
	|FROM
	|	Materials AS Materials
	|WHERE
	|	Materials.IncludeToWorkCost";
EndFunction

Function R4050B_StockInventory()
	Return
	"SELECT
	|	Materials.Period,
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Materials.Company,
	|	Materials.ItemKey,
	|	Materials.Store,
	|	Materials.Quantity
	|INTO R4050B_StockInventory
	|FROM
	|	Materials AS Materials
	|WHERE
	|	Materials.IncludeToWorkCost";
EndFunction

Function T6020S_BatchKeysInfo()
	Return
	"SELECT
	|	Materials.Period,
	|	VALUE(Enum.BatchDirection.Expense) AS Direction,
	|	Materials.Company,
	|	Materials.Branch,
	|	Materials.Work,
	|	Materials.WorkSheet,
	|	Materials.ItemKey,
	|	Materials.Store,
	|	Materials.Quantity
	|INTO T6020S_BatchKeysInfo
	|FROM
	|	Materials AS Materials
	|WHERE
	|	Materials.IncludeToWorkCost";
EndFunction

Function T3010S_RowIDInfo()
	Return
	"SELECT
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS Basis,
	|	ItemList.Key AS Key,
	|	0 AS Price,
	|	UNDEFINED AS Currency,
	|	ItemList.Unit AS Unit
	|INTO T3010S_RowIDInfo
	|FROM
	|	Document.WorkSheet.ItemList AS ItemList
	|		INNER JOIN Document.WorkSheet.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Ref
	|		AND ItemList.Ref = &Ref
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction
