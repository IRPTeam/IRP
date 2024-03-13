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
	PostingServer.SetRegisters(Tables, Ref, True);
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
	Tables = PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
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
		"Document.PlannedReceiptReservation.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters), PostingServer.GetQueryTableByName(
		"R4035B_IncomingStocks_Exists", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters),
		PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested_Exists", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.R4037B_PlannedReceiptReservationRequests.CheckBalance(Ref,
		LineNumberAndItemKeyFromItemList, PostingServer.GetQueryTableByName("R4037B_PlannedReceiptReservationRequests",
		Parameters), PostingServer.GetQueryTableByName("R4037B_PlannedReceiptReservationRequests_Exists", Parameters),
		AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
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
	QueryArray.Add(R4035B_IncomingStocks_Exists());
	QueryArray.Add(R4036B_IncomingStocksRequested_Exists());
	QueryArray.Add(R4037B_PlannedReceiptReservationRequests_Exists());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	PlannedReceiptReservationItemList.Ref.Date AS Period,
		   |	PlannedReceiptReservationItemList.ItemKey,
		   |	PlannedReceiptReservationItemList.QuantityInBaseUnit AS Quantity,
		   |	PlannedReceiptReservationItemList.Ref.Store AS IncomingStore,
		   |	PlannedReceiptReservationItemList.Store AS RequesterStore,
		   |	PlannedReceiptReservationItemList.Ref.Requester AS Requester,
		   |	PlannedReceiptReservationItemList.IncomingDocument
		   |INTO ItemList
		   |FROM
		   |	Document.PlannedReceiptReservation.ItemList AS PlannedReceiptReservationItemList
		   |WHERE
		   |	PlannedReceiptReservationItemList.Ref = &Ref"
EndFunction

Function R4035B_IncomingStocks_Exists()
	Return "SELECT *
		   |	INTO R4035B_IncomingStocks_Exists
		   |FROM
		   |	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		   |WHERE
		   |	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function R4036B_IncomingStocksRequested_Exists()
	Return "SELECT
		   |	*
		   |INTO R4036B_IncomingStocksRequested_Exists
		   |FROM
		   |	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		   |WHERE
		   |	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

Function R4037B_PlannedReceiptReservationRequests_Exists()
	Return "SELECT *
		   |	INTO R4037B_PlannedReceiptReservationRequests_Exists
		   |FROM
		   |	AccumulationRegister.R4037B_PlannedReceiptReservationRequests AS R4037B_PlannedReceiptReservationRequests
		   |WHERE
		   |	R4037B_PlannedReceiptReservationRequests.Recorder = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R4037B_PlannedReceiptReservationRequests());
	QueryArray.Add(T3010S_RowIDInfo());
	Return QueryArray;
EndFunction

Function R4035B_IncomingStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.IncomingStore AS Store,
		   |	ItemList.ItemKey,
		   |	ItemList.IncomingDocument AS Order,
		   |	ItemList.Quantity
		   |INTO R4035B_IncomingStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.RequesterStore AS IncomingStore,
		   |	ItemList.RequesterStore,
		   |	ItemList.ItemKey,
		   |	ItemList.IncomingDocument AS Order,
		   |	ItemList.Requester,
		   |	ItemList.Quantity
		   |INTO R4036B_IncomingStocksRequested
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.IncomingStore,
		   |	ItemList.IncomingStore,
		   |	ItemList.ItemKey,
		   |	ItemList.IncomingDocument,
		   |	ItemList.Requester,
		   |	ItemList.Quantity
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.RequesterStore <> ItemList.IncomingStore";
EndFunction

Function R4037B_PlannedReceiptReservationRequests()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period, 
		   |	ItemList.RequesterStore AS Store,
		   |	ItemList.Requester AS Order,
		   |	*
		   |	INTO R4037B_PlannedReceiptReservationRequests
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function T3010S_RowIDInfo()
	Return "SELECT
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
		   |	Document.PlannedReceiptReservation.ItemList AS ItemList
		   |		INNER JOIN Document.PlannedReceiptReservation.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
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
	AccessKeyMap.Insert("Store", Obj.Store);
	StoreList = Obj.ItemList.Unload(, "Store");
	StoreList.GroupBy("Store");
	StoreArray = StoreList.UnloadColumn("Store");
	StoreArray.Add(Obj.Store);
	AccessKeyMap.Insert("Store", StoreArray);
	Return AccessKeyMap;
EndFunction

#EndRegion