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
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters, True);
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
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.ItemStockAdjustment.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters).Copy(Filter),
		PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters).Copy(Filter), Filter.RecordType,
		Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	Filter = New Structure("RecordType", AccumulationRecordType.Expense);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters).Copy(Filter),
		PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters).Copy(Filter), Filter.RecordType,
		Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);

		Filter = New Structure("RecordType", AccumulationRecordType.Expense);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(
			Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(
			Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.ItemStockAdjustment.ItemList", AddInfo);
		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks", FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks", ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks", Exists_FreeStocksTable.Copy(
			Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks", Exists_ActualStocksTable.Copy(
			Filter));

		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.ItemStockAdjustment.ItemList", AddInfo);
	Else
		// is unposting
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.ItemStockAdjustment.ItemList", AddInfo);
	EndIf;
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
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	ItemStockAdjustmentItemList.Ref,
		   |	ItemStockAdjustmentItemList.Key,
		   |	ItemStockAdjustmentItemList.ItemKey,
		   |	ItemStockAdjustmentItemList.Unit,
		   |	ItemStockAdjustmentItemList.Quantity,
		   |	ItemStockAdjustmentItemList.QuantityInBaseUnit AS Quantity,
		   |	ItemStockAdjustmentItemList.ItemKeyWriteOff,
		   |	ItemStockAdjustmentItemList.Ref.Date AS Period,
		   |	ItemStockAdjustmentItemList.Ref.Company AS Company,
		   |	ItemStockAdjustmentItemList.Ref.Store AS Store,
		   |	ItemStockAdjustmentItemList.SerialLotNumber,
		   |	ItemStockAdjustmentItemList.SerialLotNumberWriteOff,
		   |	ItemStockAdjustmentItemList.Ref.Branch AS Branch
		   |INTO ItemList
		   |FROM
		   |	Document.ItemStockAdjustment.ItemList AS ItemStockAdjustmentItemList
		   |WHERE
		   |	ItemStockAdjustmentItemList.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R4051T_StockAdjustmentAsWriteOff());
	QueryArray.Add(R4052T_StockAdjustmentAsSurplus());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	Return QueryArray;
EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.ItemKey AS ItemKey,
		   |	CASE
		   |		WHEN ItemList.SerialLotNumber.StockBalanceDetail
		   |			THEN ItemList.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END SerialLotNumber,
		   |	*
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.ItemKeyWriteOff AS ItemKey,
		   |	CASE
		   |		WHEN ItemList.SerialLotNumberWriteOff.StockBalanceDetail
		   |			THEN ItemList.SerialLotNumberWriteOff
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END SerialLotNumber,
		   |	*
		   |FROM
		   |	ItemList AS ItemList";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKeyWriteOff AS ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKeyWriteOff";
EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	QueryTable.ItemKey AS ItemKey,
		   |	QueryTable.SerialLotNumber AS SerialLotNumber,
		   |	*
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE
		   |	Not QueryTable.SerialLotNumber = Value(Catalog.SerialLotNumbers.EmptyRef)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	QueryTable.ItemKeyWriteOff,
		   |	QueryTable.SerialLotNumberWriteOff,
		   |	*
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE
		   |	Not QueryTable.SerialLotNumberWriteOff = Value(Catalog.SerialLotNumbers.EmptyRef)";

EndFunction

Function R4050B_StockInventory()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey AS ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4050B_StockInventory
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKeyWriteOff AS ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKeyWriteOff";
EndFunction

Function R4051T_StockAdjustmentAsWriteOff()
	Return "SELECT 
		   |	*
		   |INTO R4051T_StockAdjustmentAsWriteOff
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE True";

EndFunction

Function R4052T_StockAdjustmentAsSurplus()
	Return "SELECT 
		   |	QueryTable.ItemKeyWriteOff AS ItemKey,
		   |	*
		   |INTO R4052T_StockAdjustmentAsSurplus
		   |FROM
		   |	ItemList AS QueryTable
		   |WHERE True";

EndFunction

Function T6010S_BatchesInfo()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Ref AS Document
		   |INTO T6010S_BatchesInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.Period,
		   |	ItemList.Ref";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		   |	ItemList.Period,
		   |	VALUE(Enum.BatchDirection.Receipt) AS Direction,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Key AS RowID,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO T6020S_BatchKeysInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.ItemKey,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.Key,
		   |	VALUE(Enum.BatchDirection.Receipt)
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	ItemList.Period,
		   |	VALUE(Enum.BatchDirection.Expense),
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKeyWriteOff,
		   |	ItemList.Key,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.Company,
		   |	ItemList.ItemKeyWriteOff,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.Key,
		   |	VALUE(Enum.BatchDirection.Expense)";
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