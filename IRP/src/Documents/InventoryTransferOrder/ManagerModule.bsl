#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();

	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
		Return Tables;
	EndIf
	;

	Parameters.IsReposting = False;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion

	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();

#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion

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

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;

	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod",
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransferOrder.ItemList", AddInfo);

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.InventoryTransferOrder.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters, True), PostingServer.GetQueryTableByName(
		"Exists_R4035B_IncomingStocks", Parameters, True), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters, True),
		PostingServer.GetQueryTableByName("Exists_R4036B_IncomingStocksRequested", Parameters, True),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("Period", StatusInfo.Period);
	StrParams.Insert("Ref", Ref);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);

	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(ItemList());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	QueryArray.Add(Exists_R4036B_IncomingStocksRequested());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4016B_InternalSupplyRequestOrdering());
	QueryArray.Add(R4020T_StockTransferOrders());
	QueryArray.Add(R4021B_StockTransferOrdersReceipt());
	QueryArray.Add(R4022B_StockTransferOrdersShipment());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	RowIDInfo.Ref AS Ref,
		   |	RowIDInfo.Key AS Key,
		   |	MAX(RowIDInfo.RowID) AS RowID
		   |INTO TableRowIDInfo
		   |FROM
		   |	Document.InventoryTransferOrder.RowIDInfo AS RowIDInfo
		   |WHERE
		   |	RowIDInfo.Ref = &Ref
		   |GROUP BY
		   |	RowIDInfo.Ref,
		   |	RowIDInfo.Key
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	&Period AS Period,
		   |	InventoryTransferOrderItemList.Ref.Company AS Company,
		   |	InventoryTransferOrderItemList.Ref.StoreSender AS StoreSender,
		   |	InventoryTransferOrderItemList.Ref.StoreReceiver AS StoreReceiver,
		   |	InventoryTransferOrderItemList.Ref AS Order,
		   |	InventoryTransferOrderItemList.ItemKey AS ItemKey,
		   |	InventoryTransferOrderItemList.QuantityInBaseUnit AS Quantity,
		   |	TableRowIDInfo.RowID AS RowKey,
		   |	InventoryTransferOrderItemList.PurchaseOrder AS PurchaseOrder,
		   |	NOT InventoryTransferOrderItemList.PurchaseOrder.Ref IS NULL AS PurchaseOrderExists,
		   |	InventoryTransferOrderItemList.InternalSupplyRequest AS InternalSupplyRequest,
		   |	NOT InventoryTransferOrderItemList.InternalSupplyRequest.Ref IS NULL AS InternalSupplyRequestExists,
		   |	&StatusInfoPosting AS StatusInfoPosting,
		   |	InventoryTransferOrderItemList.Ref.Branch
		   |INTO ItemList
		   |FROM
		   |	Document.InventoryTransferOrder.ItemList AS InventoryTransferOrderItemList
		   |		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		   |		ON InventoryTransferOrderItemList.Key = TableRowIDInfo.Key
		   |WHERE
		   |	InventoryTransferOrderItemList.Ref = &Ref
		   |	AND &StatusInfoPosting";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.StoreSender AS Store,
		   |	ItemList.ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemLIst.PurchaseOrderExists
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.StoreSender,
		   |	ItemList.ItemKey";
EndFunction

Function R4012B_StockReservation()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.StoreSender AS Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Order,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4012B_StockReservation
		   |FROM 
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.PurchaseOrderExists
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.StoreSender,
		   |	ItemList.ItemKey,
		   |	ItemList.Order";
EndFunction

Function R4016B_InternalSupplyRequestOrdering()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.StoreSender AS Store,
		   |	*
		   |INTO R4016B_InternalSupplyRequestOrdering
		   |FROM 
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.InternalSupplyRequestExists";
EndFunction

Function R4020T_StockTransferOrders()
	Return "SELECT
		   |	*
		   |INTO R4020T_StockTransferOrders
		   |FROM 
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R4021B_StockTransferOrdersReceipt()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.StoreReceiver AS Store,
		   |	*
		   |INTO R4021B_StockTransferOrdersReceipt
		   |FROM 
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R4022B_StockTransferOrdersShipment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.StoreSender AS Store,
		   |	*
		   |INTO R4022B_StockTransferOrdersShipment
		   |FROM 
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE";
EndFunction

Function R4035B_IncomingStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.StoreSender AS Store,
		   |	ItemList.ItemKey,
		   |	ItemList.PurchaseOrder AS Order,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4035B_IncomingStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemLIst.PurchaseOrderExists
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.StoreSender,
		   |	ItemList.ItemKey,
		   |	ItemList.PurchaseOrder";
EndFunction

Function Exists_R4035B_IncomingStocks()
	Return "SELECT *
		   |	INTO Exists_R4035B_IncomingStocks
		   |FROM
		   |	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		   |WHERE
		   |	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.StoreSender AS IncomingStore,
		   |	ItemList.StoreReceiver AS RequesterStore,
		   |	ItemList.ItemKey,
		   |	ItemList.PurchaseOrder AS Order,
		   |	ItemList.Order AS Requester,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4036B_IncomingStocksRequested
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.PurchaseOrderExists
		   |GROUP BY
		   |	ItemList.Period,
		   |	ItemList.StoreSender,
		   |	ItemList.StoreReceiver,
		   |	ItemList.ItemKey,
		   |	ItemList.PurchaseOrder,
		   |	ItemList.Order";
EndFunction

Function Exists_R4036B_IncomingStocksRequested()
	Return "SELECT
		   |	*
		   |INTO Exists_R4036B_IncomingStocksRequested
		   |FROM
		   |	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		   |WHERE
		   |	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

#EndRegion