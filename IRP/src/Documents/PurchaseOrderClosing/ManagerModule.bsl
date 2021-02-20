#Region Posting

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
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
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
	Return;
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
	StrParams.Insert("PurchaseOrder", Ref.PurchaseOrder);
	StrParams.Insert("Period", Ref.Date);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(R4035B_IncomingStocks_Exists());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1010T_PurchaseOrders());
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1012B_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(R1014T_CanceledPurchaseOrders());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R4016B_InternalSupplyRequestOrdering());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	PurchaseOrderItems.Ref.Company AS Company,
		|	PurchaseOrderItems.Store AS Store,
		|	PurchaseOrderItems.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseOrderItems.Ref.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	PurchaseOrderItems.Ref AS Order,
		|	PurchaseOrderItems.PurchaseBasis AS PurchaseBasis,
		|	PurchaseOrderItems.ItemKey.Item AS Item,
		|	PurchaseOrderItems.ItemKey AS ItemKey,
		|	PurchaseOrderItems.Quantity AS UnitQuantity,
		|	PurchaseOrderItems.QuantityInBaseUnit AS Quantity,
		|	PurchaseOrderItems.Unit,
		|	PurchaseOrderItems.Ref.Date AS Period,
		|	PurchaseOrderItems.Key AS RowKey,
		|	PurchaseOrderItems.BusinessUnit AS BusinessUnit,
		|	PurchaseOrderItems.ExpenseType AS ExpenseType,
		|	PurchaseOrderItems.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	PurchaseOrderItems.DeliveryDate AS DeliveryDate,
		|	PurchaseOrderItems.InternalSupplyRequest AS InternalSupplyRequest,
		|	PurchaseOrderItems.SalesOrder AS SalesOrder,
		|	PurchaseOrderItems.Cancel AS IsCanceled,
		|	PurchaseOrderItems.CancelReason,
		|	PurchaseOrderItems.TotalAmount AS Amount,
		|	PurchaseOrderItems.NetAmount,
		|	PurchaseOrderItems.Ref.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,
		|	PurchaseOrderItems.PurchaseBasis REFS Document.SalesOrder
		|	AND NOT PurchaseOrderItems.PurchaseBasis.REF IS NULL AS UseSalesOrder
		|INTO ItemList
		|FROM
		|	Document.PurchaseOrder.ItemList AS PurchaseOrderItems
		|WHERE
		|	PurchaseOrderItems.Ref = &Ref";
EndFunction

Function R1010T_PurchaseOrders()
	Return
		"SELECT *
		|INTO R1010T_PurchaseOrders
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function R1011B_PurchaseOrdersReceipt()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService";

EndFunction

Function R1012B_PurchaseOrdersInvoiceClosing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R1012B_PurchaseOrdersInvoiceClosing
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function R1014T_CanceledPurchaseOrders()
	Return
		"SELECT *
		|INTO R1014T_CanceledPurchaseOrders
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.isCanceled";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	QueryTable.Quantity AS ReOrderedQuantity,
		|	QueryTable.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS QueryTable
		|WHERE
		|	NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService
		|	AND NOT QueryTable.SalesOrder = Value(Document.SalesOrder.EmptyRef)";

EndFunction

Function R4016B_InternalSupplyRequestOrdering()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.Quantity AS Quantity,
		|	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		|	*
		|INTO R4016B_InternalSupplyRequestOrdering
		|FROM
		|	ItemList AS QueryTable
		|WHERE
		|	NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService
		|	AND NOT QueryTable.InternalSupplyRequest = Value(Document.InternalSupplyRequest.EmptyRef)";

EndFunction

Function R4033B_GoodsReceiptSchedule()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CASE WHEN QueryTable.DeliveryDate = DATETIME(1, 1, 1) THEN
		|		QueryTable.Period
		|	ELSE
		|		QueryTable.DeliveryDate
		|	END AS Period,
		|	QueryTable.Order AS Basis,
		|*
		|
		|INTO R4033B_GoodsReceiptSchedule
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.isCanceled 
		|	AND NOT QueryTable.IsService 
		|	AND QueryTable.UseItemsReceiptScheduling";

EndFunction

Function R4035B_IncomingStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.Period AS Period,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.Order AS Order,
		|	QueryTable.Quantity AS Quantity
		|INTO R4035B_IncomingStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE
		|	NOT QueryTable.UseSalesOrder
		|	AND NOT QueryTable.IsService
		|	AND NOT QueryTable.IsCanceled";
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
		
#EndRegion
