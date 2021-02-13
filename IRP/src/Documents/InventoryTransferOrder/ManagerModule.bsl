#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("TransferOrderBalance"         , PostingServer.CreateTable(AccReg.TransferOrderBalance));
	Tables.Insert("StockReservation"             , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("OrderBalance"                 , PostingServer.CreateTable(AccReg.OrderBalance));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
		
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	InventoryTransferOrderItemList.Ref.Company AS Company,
		|	InventoryTransferOrderItemList.Ref.StoreSender AS StoreSender,
		|	InventoryTransferOrderItemList.Ref.StoreReceiver AS StoreReceiver,
		|	InventoryTransferOrderItemList.Ref AS Order,
		|	InventoryTransferOrderItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	InventoryTransferOrderItemList.ItemKey AS ItemKey,
		|	InventoryTransferOrderItemList.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	InventoryTransferOrderItemList.Unit,
		|	InventoryTransferOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InventoryTransferOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InventoryTransferOrderItemList.ItemKey.Item AS Item,
		|	&Period AS Period,
		|	InventoryTransferOrderItemList.Key AS RowKey,
		|	InventoryTransferOrderItemList.PurchaseOrder AS PurchaseOrder,
		|	NOT InventoryTransferOrderItemList.PurchaseOrder.Ref IS NULL AS UsePurchaseOrder
		|FROM
		|	Document.InventoryTransferOrder.ItemList AS InventoryTransferOrderItemList
		|WHERE
		|	InventoryTransferOrderItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.StoreSender AS StoreSender,
		|	QueryTable.StoreReceiver AS StoreReceiver,
		|	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.PurchaseOrder,
		|	QueryTable.UsePurchaseOrder
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS StoreSender,
		|	tmp.StoreReceiver AS StoreReceiver,
		|	tmp.Order AS Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UsePurchaseOrder
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.InternalSupplyRequest AS Order,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.InternalSupplyRequest <> VALUE(Document.InternalSupplyRequest.EmptyRef)";
	
	Query.SetParameter("QueryTable", QueryTable);
	Query.SetParameter("Period", New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Excluding));
	
	QueryResults = Query.ExecuteBatch();
	
	Tables.TransferOrderBalance         = QueryResults[1].Unload();
	Tables.StockReservation             = QueryResults[2].Unload();
	Tables.OrderBalance                 = QueryResults[3].Unload();
	
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	If Parameters.StatusInfo.Posting Then
		Tables = Parameters.DocumentDataTables;	
		QueryArray = GetQueryTextsMasterTables();
		PostingServer.SetRegisters(Tables, Ref);
		PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
	EndIf;
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// TransferOrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TransferOrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.TransferOrderBalance,
			Parameters.IsReposting));
	
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			True));
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));

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
	Tables = PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
#Region NewRegistersPosting
	If Parameters.StatusInfo.Posting Then
		QueryArray = GetQueryTextsMasterTables();
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	EndIf;
#EndRegion
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
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

	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod", 
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransferOrder.ItemList", AddInfo);
	
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.InventoryTransferOrder.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                 PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters),
	                                                                 PostingServer.GetQueryTableByName("R4035B_IncomingStocks_Exists", Parameters),
	                                                                 AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters),
	                                                                PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested_Exists", Parameters),
	                                                                AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)	
	StrParams = New Structure();
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("Period", StatusInfo.Period);
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(R4035B_IncomingStocks_Exists());
	QueryArray.Add(R4036B_IncomingStocksRequested_Exists());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R4012B_StockReservation());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	&Period AS Period,
		|	InventoryTransferOrderItemList.Ref.Company AS Company,
		|	InventoryTransferOrderItemList.Ref.StoreSender AS StoreSender,
		|	InventoryTransferOrderItemList.Ref.StoreReceiver AS StoreReceiver,
		|	InventoryTransferOrderItemList.Ref AS Order,
		|	InventoryTransferOrderItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	InventoryTransferOrderItemList.ItemKey AS ItemKey,
		|	InventoryTransferOrderItemList.QuantityInBaseUnit AS Quantity,
		|	InventoryTransferOrderItemList.Key AS RowKey,
		|	InventoryTransferOrderItemList.PurchaseOrder AS PurchaseOrder,
		|	NOT InventoryTransferOrderItemList.PurchaseOrder.Ref IS NULL AS UsePurchaseOrder
		|INTO ItemList
		|FROM
		|	Document.InventoryTransferOrder.ItemList AS InventoryTransferOrderItemList
		|WHERE
		|	InventoryTransferOrderItemList.Ref = &Ref";
EndFunction	

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.StoreSender AS Store,
		|	ItemList.ItemKey,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemLIst.UsePurchaseOrder
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.StoreSender,
		|	ItemList.ItemKey";
EndFunction 

Function R4035B_IncomingStocks()
	Return
		"SELECT
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
		|	ItemLIst.UsePurchaseOrder
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.StoreSender,
		|	ItemList.ItemKey,
		|	ItemList.PurchaseOrder";
EndFunction

Function R4035B_IncomingStocks_Exists()
	Return
		"SELECT *
		|	INTO R4035B_IncomingStocks_Exists
		|FROM
		|	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		|WHERE
		|	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return
		"SELECT
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
		|	ItemList.UsePurchaseOrder
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.StoreSender,
		|	ItemList.StoreReceiver,
		|	ItemList.ItemKey,
		|	ItemList.PurchaseOrder,
		|	ItemList.Order";
EndFunction

Function R4036B_IncomingStocksRequested_Exists()
	Return
		"SELECT
		|	*
		|INTO R4036B_IncomingStocksRequested_Exists
		|FROM
		|	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		|WHERE
		|	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
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
		|	NOT ItemList.UsePurchaseOrder
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.StoreSender,
		|	ItemList.ItemKey,
		|	ItemList.Order";
EndFunction	

#EndRegion

