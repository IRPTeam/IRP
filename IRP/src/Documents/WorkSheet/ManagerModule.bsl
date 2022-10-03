#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
	Else
		ArrayOfMultiCurrencyExcludePostingDataTables = New Array();
		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
	EndIf;
	
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
	
	Tables.R5022T_Expenses.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	
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
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	
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
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(T3010S_RowIDInfo());
	QueryArray.Add(R5022T_Expenses());
	Return QueryArray;
EndFunction

Function Materials()
	Return
	"SELECT
	|	WorkSheetItemList.Ref.Date AS Period,
	|	WorkSheetItemList.Key,
	|	WorkSheetItemList.ItemKey AS Work,
	|	WorkSheetItemList.WorkOrder AS WorkOrder,
	|	NOT WorkSheetItemList.WorkOrder.Ref IS NULL AS WorkOrderExists,
	|	WorkSheetMaterials.Ref AS WorkSheet,
	|	WorkSheetMaterials.Ref.Company AS Company,
	|	WorkSheetMaterials.Ref.Branch AS Branch,
	|	WorkSheetMaterials.Ref.Currency AS Currency,
	|	WorkSheetMaterials.ProfitLossCenter AS ProfitLossCenter,
	|	WorkSheetMaterials.ExpenseType AS ExpenseType,
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

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	Materials.Period,
		|	Materials.Store,
		|	Materials.ItemKey,
		|	Materials.WorkOrder,
		|	Materials.WorkOrderExists,
		|	SUM(Materials.Quantity) AS Quantity
		|INTO MaterialsGroup
		|FROM
		|	Materials AS Materials
		|WHERE
		|	Materials.IncludeToWorkCost
		|GROUP BY
		|	Materials.Period,
		|	Materials.Store,
		|	Materials.ItemKey,
		|	Materials.WorkOrder,
		|	Materials.WorkOrderExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	StockReservation.Store AS Store,
		|	StockReservation.Order AS Basis,
		|	StockReservation.ItemKey AS ItemKey,
		|	StockReservation.QuantityBalance AS Quantity
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			Materials.Store,
		|			Materials.ItemKey,
		|			Materials.WorkOrder
		|		FROM
		|			Materials AS Materials
		|		WHERE
		|			Materials.IncludeToWorkCost)) AS StockReservation
		|WHERE
		|	StockReservation.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	MaterialsGroup.Period AS Period,
		|	MaterialsGroup.Store AS Store,
		|	MaterialsGroup.ItemKey AS ItemKey,
		|	MaterialsGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	MaterialsGroup AS MaterialsGroup
		|		LEFT JOIN TmpStockReservation AS TmpStockReservation
		|		ON (MaterialsGroup.Store = TmpStockReservation.Store)
		|		AND (MaterialsGroup.ItemKey = TmpStockReservation.ItemKey)
		|		AND TmpStockReservation.Basis = MaterialsGroup.WorkOrder
		|WHERE
		|	MaterialsGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP MaterialsGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
EndFunction

Function R4012B_StockReservation()
	Return 
		"SELECT
		|	Materials.Period AS Period,
		|	Materials.Store AS Store,
		|	Materials.ItemKey AS ItemKey,
		|	Materials.WorkOrder AS WorkOrder,
		|	SUM(Materials.Quantity) AS Quantity
		|INTO TmpMaterialsGroup
		|FROM
		|	Materials AS Materials
		|WHERE
		|	Materials.WorkOrderExists
		|	AND Materials.IncludeToWorkCost
		|GROUP BY
		|	Materials.Period,
		|	Materials.Store,
		|	Materials.ItemKey,
		|	Materials.WorkOrder
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R4012B_StockReservationBalance.Store AS Store,
		|	R4012B_StockReservationBalance.ItemKey AS ItemKey,
		|	R4012B_StockReservationBalance.Order AS Order,
		|	R4012B_StockReservationBalance.QuantityBalance AS QuantityBalance
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			Materials.Store,
		|			Materials.ItemKey,
		|			Materials.WorkOrder
		|		FROM
		|			TmpMaterialsGroup AS Materials)) AS R4012B_StockReservationBalance
		|WHERE
		|	R4012B_StockReservationBalance.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	TmpMaterialsGroup.Period AS Period,
		|	TmpMaterialsGroup.WorkOrder AS Order,
		|	TmpMaterialsGroup.ItemKey AS ItemKey,
		|	TmpMaterialsGroup.Store AS Store,
		|	CASE
		|		WHEN StockReservation.QuantityBalance > TmpMaterialsGroup.Quantity
		|			THEN TmpMaterialsGroup.Quantity
		|		ELSE StockReservation.QuantityBalance
		|	END AS Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	TmpMaterialsGroup AS TmpMaterialsGroup
		|		INNER JOIN TmpStockReservation AS StockReservation
		|		ON TmpMaterialsGroup.WorkOrder = StockReservation.Order
		|		AND TmpMaterialsGroup.ItemKey = StockReservation.ItemKey
		|		AND TmpMaterialsGroup.Store = StockReservation.Store
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpMaterialsGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
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
	|	Materials.Currency,
	|	Materials.Key AS RowID,
	|	Materials.ProfitLossCenter,
	|	Materials.ExpenseType,
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

Function R5022T_Expenses()
	Return
	"SELECT
	|	WriteOffBatchesInfo.Period,
	|	WriteOffBatchesInfo.Company,
	|	WriteOffBatchesInfo.Branch,
	|	WriteOffBatchesInfo.ProfitLossCenter,
	|	WriteOffBatchesInfo.ExpenseType,
	|	WriteOffBatchesInfo.ItemKey,
	|	WriteOffBatchesInfo.Currency,
	|	WriteOffBatchesInfo.RowID AS Key,
	|	WriteOffBatchesInfo.Recorder AS CalculationMovementCost,
	|	WriteOffBatchesInfo.Amount AS Amount,
	|	WriteOffBatchesInfo.Amount + WriteOffBatchesInfo.AmountTax AS AmountWithTaxes
	|INTO R5022T_Expenses
	|FROM
	|	InformationRegister.T6095S_WriteOffBatchesInfo AS WriteOffBatchesInfo
	|WHERE
	|	WriteOffBatchesInfo.Document = &Ref";
EndFunction
