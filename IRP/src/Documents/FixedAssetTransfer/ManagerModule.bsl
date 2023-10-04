#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;
	Parameters.IsReposting = False;

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

//	BatchKeysInfoMetadata = Parameters.Object.RegisterRecords.T6020S_BatchKeysInfo.Metadata();
//	If Parameters.Property("MultiCurrencyExcludePostingDataTables") Then
//		Parameters.MultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
//	Else
//		ArrayOfMultiCurrencyExcludePostingDataTables = New Array;
//		ArrayOfMultiCurrencyExcludePostingDataTables.Add(BatchKeysInfoMetadata);
//		Parameters.Insert("MultiCurrencyExcludePostingDataTables", ArrayOfMultiCurrencyExcludePostingDataTables);
//	EndIf;

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
//	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
//	AccReg = AccumulationRegisters;
//	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
//		"Document.CommissioningOfFixedAsset.ItemList");
//
//	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
//
//	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
//		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
//		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
//		Cancel = True;
//	EndIf;
EndProcedure

//Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
//	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
//	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.CommissioningOfFixedAsset.ItemList", AddInfo);
//EndProcedure

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
//	QueryArray.Add(ItemList());
//	QueryArray.Add(SerialLotNumbers());
//	QueryArray.Add(SourceOfOrigins());
//	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
//	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
//	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
//	QueryArray.Add(R4010B_ActualStocks());
//	QueryArray.Add(R4011B_FreeStocks());
//	QueryArray.Add(R4014B_SerialLotNumber());
//	QueryArray.Add(R4050B_StockInventory());
//	QueryArray.Add(R9010B_SourceOfOriginStock());
//	QueryArray.Add(T6020S_BatchKeysInfo());
//	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

//Function ItemList()
//	Return 
//		"SELECT
//		|	ItemList.Ref.Date AS Period,
//		|	ItemList.Ref.Company AS Company,
//		|	ItemList.Ref.Branch AS Branch,
//		|	ItemList.Ref.FixedAsset AS FixedAsset,
//		|	ItemList.Store AS Store,
//		|	ItemList.ItemKey AS ItemKey,
//		|	ItemList.QuantityInBaseUnit AS Quantity,
//		|	ItemList.Key
//		|INTO ItemList
//		|FROM
//		|	Document.CommissioningOfFixedAsset.ItemList AS ItemList
//		|WHERE
//		|	ItemList.Ref = &Ref";
//EndFunction
//
//Function SerialLotNumbers()
//	Return 
//		"SELECT
//		|	SerialLotNumbers.Ref.Date AS Period,
//		|	SerialLotNumbers.Ref.Company AS Company,
//		|	SerialLotNumbers.Ref.Branch AS Branch,
//		|	SerialLotNumbers.Key,
//		|	SerialLotNumbers.SerialLotNumber,
//		|	SerialLotNumbers.SerialLotNumber.StockBalanceDetail AS StockBalanceDetail,
//		|	SerialLotNumbers.Quantity,
//		|	ItemList.ItemKey AS ItemKey
//		|INTO SerialLotNumbers
//		|FROM
//		|	Document.CommissioningOfFixedAsset.SerialLotNumbers AS SerialLotNumbers
//		|		LEFT JOIN Document.CommissioningOfFixedAsset.ItemList AS ItemList
//		|		ON SerialLotNumbers.Key = ItemList.Key
//		|		AND ItemList.Ref = &Ref
//		|WHERE
//		|	SerialLotNumbers.Ref = &Ref";
//EndFunction
//
//Function SourceOfOrigins()
//	Return 
//		"SELECT
//		|	SourceOfOrigins.Key AS Key,
//		|	CASE
//		|		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
//		|			THEN SourceOfOrigins.SerialLotNumber
//		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
//		|	END AS SerialLotNumber,
//		|	CASE
//		|		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
//		|			THEN SourceOfOrigins.SourceOfOrigin
//		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
//		|	END AS SourceOfOrigin,
//		|	SourceOfOrigins.SourceOfOrigin AS SourceOfOriginStock,
//		|	SUM(SourceOfOrigins.Quantity) AS Quantity
//		|INTO SourceOfOrigins
//		|FROM
//		|	Document.CommissioningOfFixedAsset.SourceOfOrigins AS SourceOfOrigins
//		|WHERE
//		|	SourceOfOrigins.Ref = &Ref
//		|GROUP BY
//		|	SourceOfOrigins.Key,
//		|	CASE
//		|		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
//		|			THEN SourceOfOrigins.SerialLotNumber
//		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
//		|	END,
//		|	CASE
//		|		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
//		|			THEN SourceOfOrigins.SourceOfOrigin
//		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
//		|	END,
//		|	SourceOfOrigins.SourceOfOrigin";
//EndFunction

#EndRegion

#Region Posting_MainTables

//Function R4014B_SerialLotNumber()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	*
//		|INTO R4014B_SerialLotNumber
//		|FROM
//		|	SerialLotNumbers AS QueryTable
//		|WHERE
//		|	TRUE";
//
//EndFunction
//
//Function R4011B_FreeStocks()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	*
//		|INTO R4011B_FreeStocks
//		|FROM
//		|	ItemList AS ItemList
//		|WHERE
//		|	TRUE";
//EndFunction
//
//Function R4010B_ActualStocks()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	ItemList.Period,
//		|	ItemList.Store,
//		|	ItemList.ItemKey,
//		|	CASE
//		|		WHEN SerialLotNumbers.StockBalanceDetail
//		|			THEN SerialLotNumbers.SerialLotNumber
//		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
//		|	END AS SerialLotNumber,
//		|	SUM(CASE
//		|		WHEN SerialLotNumbers.SerialLotNumber IS NULL
//		|			THEN ItemList.Quantity
//		|		ELSE SerialLotNumbers.Quantity
//		|	END) AS Quantity
//		|INTO R4010B_ActualStocks
//		|FROM
//		|	ItemList AS ItemList
//		|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
//		|		ON ItemList.Key = SerialLotNumbers.Key
//		|WHERE
//		|	TRUE
//		|GROUP BY
//		|	VALUE(AccumulationRecordType.Expense),
//		|	ItemList.Period,
//		|	ItemList.Store,
//		|	ItemList.ItemKey,
//		|	CASE
//		|		WHEN SerialLotNumbers.StockBalanceDetail
//		|			THEN SerialLotNumbers.SerialLotNumber
//		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
//		|	END";
//EndFunction
//
//Function R4050B_StockInventory()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	ItemList.Period,
//		|	ItemList.Company,
//		|	ItemList.Store,
//		|	ItemList.ItemKey,
//		|	SUM(ItemList.Quantity) AS Quantity
//		|INTO R4050B_StockInventory
//		|FROM
//		|	ItemList AS ItemList
//		|WHERE
//		|	TRUE
//		|GROUP BY
//		|	VALUE(AccumulationRecordType.Expense),
//		|	ItemList.Period,
//		|	ItemList.Company,
//		|	ItemList.Store,
//		|	ItemList.ItemKey";
//EndFunction
//
//Function T6020S_BatchKeysInfo()
//	Return 
//		"SELECT
//		|	ItemList.Period,
//		|	VALUE(Enum.BatchDirection.Expense) AS Direction,
//		|	ItemList.Company,
//		|	ItemList.FixedAsset,
//		|	ItemList.Store,
//		|	ItemList.ItemKey,
//		|	ItemList.Branch,
//		|	ItemList.Key,
//		|	ItemList.Quantity AS Quantity
//		|INTO BatchKeysInfo_1
//		|FROM
//		|	ItemList AS ItemList
//		|WHERE
//		|	TRUE
//		|;
//		|
//		|////////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	BatchKeysInfo_1.Period,
//		|	BatchKeysInfo_1.Direction,
//		|	BatchKeysInfo_1.Company,
//		|	BatchKeysInfo_1.FixedAsset,
//		|	BatchKeysInfo_1.Store,
//		|	BatchKeysInfo_1.ItemKey,
//		|	BatchKeysInfo_1.Branch,
//		|	SUM(CASE
//		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
//		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
//		|		ELSE BatchKeysInfo_1.Quantity
//		|	END) AS Quantity,
//		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
//		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
//		|INTO T6020S_BatchKeysInfo
//		|FROM
//		|	BatchKeysInfo_1 AS BatchKeysInfo_1
//		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
//		|		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
//		|GROUP BY
//		|	BatchKeysInfo_1.Period,
//		|	BatchKeysInfo_1.Direction,
//		|	BatchKeysInfo_1.Company,
//		|	BatchKeysInfo_1.FixedAsset,
//		|	BatchKeysInfo_1.Store,
//		|	BatchKeysInfo_1.ItemKey,
//		|	BatchKeysInfo_1.Branch,
//		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
//		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))";
//EndFunction
//
//Function R9010B_SourceOfOriginStock()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	ItemList.Period,
//		|	ItemList.Company,
//		|	ItemList.Branch,
//		|	ItemList.Store,
//		|	ItemList.ItemKey,
//		|	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
//		|	SourceOfOrigins.SerialLotNumber,
//		|	SUM(SourceOfOrigins.Quantity) AS Quantity
//		|INTO R9010B_SourceOfOriginStock
//		|FROM
//		|	ItemList AS ItemList
//		|		INNER JOIN SourceOfOrigins AS SourceOfOrigins
//		|		ON ItemList.Key = SourceOfOrigins.Key
//		|		AND NOT SourceOfOrigins.SourceOfOriginStock.Ref IS NULL
//		|WHERE
//		|	TRUE
//		|GROUP BY
//		|	VALUE(AccumulationRecordType.Expense),
//		|	ItemList.Period,
//		|	ItemList.Company,
//		|	ItemList.Branch,
//		|	ItemList.Store,
//		|	ItemList.ItemKey,
//		|	SourceOfOrigins.SourceOfOriginStock,
//		|	SourceOfOrigins.SerialLotNumber";
//EndFunction
//
//Function R8510B_BookValueOfFixedAsset()
//	Return
//		"SELECT
//		|	*,
//		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
//		|	T8510S_FixedAssetsInfo.Recorder AS CalculationMovementCost
//		|INTO R8510B_BookValueOfFixedAsset
//		|FROM
//		|	InformationRegister.T8510S_FixedAssetsInfo AS T8510S_FixedAssetsInfo
//		|WHERE
//		|	T8510S_FixedAssetsInfo.Document = &Ref";
//EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObject.FixedAssetTransfer -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	BranchList = New Array;
	BranchList.Add(Obj.BranchSender);
	BranchList.Add(Obj.BranchReceiver);
	AccessKeyMap.Insert("Branch", BranchList);
	Return AccessKeyMap;
EndFunction

#EndRegion