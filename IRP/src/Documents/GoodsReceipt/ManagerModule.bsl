#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();		
	Parameters.IsReposting = False;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
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
	Tables = Parameters.DocumentDataTables;	
	
	Parameters.Insert("ConsiderStocksRequested", True);
	IncomingStocksServer.ClosureIncomingStocks(Parameters);
	
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
#Region NewRegisterPosting
	IncomingStocksServer.ClosureIncomingStocks_Unposting(Parameters);
	
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
	
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.GoodsReceipt.ItemList", AddInfo);
		
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.GoodsReceipt.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters),
	                                                                PostingServer.GetQueryTableByName("Exists_R4035B_IncomingStocks", Parameters),
	                                                                AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.R4036B_IncomingStocksRequested.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4036B_IncomingStocksRequested", Parameters),
	                                                                PostingServer.GetQueryTableByName("Exists_R4036B_IncomingStocksRequested", Parameters),
	                                                                AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region NewRegistersPosting

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
	QueryArray.Add(ItemList());
	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
	QueryArray.Add(Exists_R4036B_IncomingStocksRequested());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(R4021B_StockTransferOrdersReceipt());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	RowIDInfo.Ref AS Ref,
		|	RowIDInfo.Key AS Key,
		|	MAX(RowIDInfo.RowID) AS RowID
		|INTO TableRowIDInfo
		|FROM
		|	Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Ref = &Ref
		|GROUP BY
		|	RowIDInfo.Ref,
		|	RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ReceiptBasis AS ReceiptBasis,
		|	ItemList.Quantity AS UnitQuantity,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Unit,
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref AS GoodsReceipt,
		|	TableRowIDInfo.RowID AS RowKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	NOT ItemList.SalesOrder = VALUE(Document.SalesOrder.EmptyRef) AS SalesOrderExists,
		|	ItemList.SalesInvoice AS SalesInvoice,
		|	NOT ItemList.SalesInvoice = VALUE(Document.SalesInvoice.EmptyRef) AS SalesInvoiceExists,
		|	ItemList.PurchaseOrder AS PurchaseOrder,
		|	NOT ItemList.PurchaseOrder = VALUE(Document.PurchaseOrder.EmptyRef) AS PurchaseOrderExists,
		|	ItemList.PurchaseInvoice AS PurchaseInvoice,
		|	NOT ItemList.PurchaseInvoice = VALUE(Document.PurchaseInvoice.EmptyRef) AS PurchaseInvoiceExists,
		|	ItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	NOT ItemList.InternalSupplyRequest = VALUE(Document.InternalSupplyRequest.EmptyRef) AS InternalSupplyRequestExists,
		|	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		|	NOT ItemList.InventoryTransferOrder = VALUE(Document.InventoryTransferOrder.EmptyRef) AS
		|		InventoryTransferOrderExists,
		|	ItemList.InventoryTransfer AS InventoryTransfer,
		|	NOT ItemList.InventoryTransfer = VALUE(Document.InventoryTransfer.EmptyRef) AS InventoryTransferExists,
		|	ItemList.SalesReturn AS SalesReturn,
		|	NOT ItemList.SalesReturn = VALUE(Document.SalesReturn.EmptyRef) AS SalesReturnExists,
		|	ItemList.SalesReturnOrder AS SalesReturnOrder,
		|	NOT ItemList.SalesReturnOrder = VALUE(Document.SalesReturnOrder.EmptyRef) AS SalesReturnOrderExists,
		|	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.Purchase) AS IsTransaction_Purchase,
		|	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer) AS
		|		IsTransaction_ReturnFromCustomer,
		|	ItemList.Ref.TransactionType = VALUE(Enum.GoodsReceiptTransactionTypes.InventoryTransfer) AS
		|		IsTransaction_InventoryTransfer,
		|	ItemList.Ref.Branch AS Branch
		|INTO ItemList
		|FROM
		|	Document.GoodsReceipt.ItemList AS ItemList
		|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
		|		ON ItemList.Key = TableRowIDInfo.Key
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function IncomingStocksReal()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.PurchaseOrder AS Order,
		|	ItemList.Quantity
		|INTO IncomingStocksReal
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction
	

Function R1011B_PurchaseOrdersReceipt()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.PurchaseOrder AS Order,
		|	*
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists";
EndFunction

Function R1031B_ReceiptInvoicing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.GoodsReceipt AS Basis,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|INTO R1031B_ReceiptInvoicing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.PurchaseInvoiceExists
		|	AND ItemList.IsTransaction_Purchase
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.PurchaseInvoice,
		|	ItemList.Quantity,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseInvoiceExists
		|	AND ItemList.IsTransaction_Purchase";
EndFunction

Function R2031B_ShipmentInvoicing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.GoodsReceipt AS Basis,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|INTO R2031B_ShipmentInvoicing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.SalesReturnExists
		|	AND ItemList.IsTransaction_ReturnFromCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.SalesReturn,
		|	ItemList.Quantity,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesReturnExists
		|	AND ItemList.IsTransaction_ReturnFromCustomer";	
EndFunction	

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	ItemList.Quantity AS ReceiptQuantity,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesOrderExists";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Quantity AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	FreeStocks.Period,
		|	FreeStocks.Store,
		|	FreeStocks.ItemKey,
		|	FreeStocks.Quantity
		|FROM
		|	FreeStocks AS FreeStocks
		|WHERE
		|	TRUE";
EndFunction

Function R4017B_InternalSupplyRequestProcurement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4017B_InternalSupplyRequestProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.InternalSupplyRequestExists";
EndFunction

Function R4021B_StockTransferOrdersReceipt()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.InventoryTransferOrder AS Order,
		|	*
		|INTO R4021B_StockTransferOrdersReceipt
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.InventoryTransferOrderExists";
EndFunction

Function R4031B_GoodsInTransitIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	CASE
		|		WHEN ItemList.IsTransaction_InventoryTransfer AND ItemList.InventoryTransferExists
		|			THEN ItemList.InventoryTransfer
		|		WHEN ItemList.IsTransaction_Purchase AND ItemList.PurchaseInvoiceExists
		|			THEN ItemList.PurchaseInvoice
		|		WHEN ItemList.IsTransaction_ReturnFromCustomer AND ItemList.SalesReturnExists
		|			THEN ItemList.SalesReturn
		|	ELSE
		|		ItemList.GoodsReceipt
		|	END AS Basis,
		|	*
		|INTO R4031B_GoodsInTransitIncoming
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R4033B_GoodsReceiptSchedule()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.PurchaseOrder AS Basis,
		|	*
		|INTO R4033B_GoodsReceiptSchedule
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.PurchaseOrderExists
		|	AND ItemList.PurchaseOrder.UseItemsReceiptScheduling";
EndFunction

Function R4035B_IncomingStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4035B_IncomingStocks
		|FROM
		|	IncomingStocks AS IncomingStocks
		|WHERE
		|	TRUE";
EndFunction

Function Exists_R4035B_IncomingStocks()
	Return
		"SELECT *
		|	INTO Exists_R4035B_IncomingStocks
		|FROM
		|	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		|WHERE
		|	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4036B_IncomingStocksRequested
		|FROM
		|	IncomingStocksRequested AS IncomingStocksRequested
		|WHERE
		|	TRUE";
EndFunction	

Function Exists_R4036B_IncomingStocksRequested()
	Return
		"SELECT
		|	*
		|INTO Exists_R4036B_IncomingStocksRequested
		|FROM
		|	AccumulationRegister.R4036B_IncomingStocksRequested AS R4036B_IncomingStocksRequested
		|WHERE
		|	R4036B_IncomingStocksRequested.Recorder = &Ref";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	IncomingStocksRequested.Period,
		|	IncomingStocksRequested.IncomingStore AS Store,
		|	IncomingStocksRequested.ItemKey,
		|	IncomingStocksRequested.Requester AS Order,
		|	IncomingStocksRequested.Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	IncomingStocksRequested
		|WHERE
		|	TRUE";
EndFunction

#EndRegion
