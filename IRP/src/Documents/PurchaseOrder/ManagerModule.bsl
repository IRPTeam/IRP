#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	#Region OldPosting

	FillTables(Ref, AddInfo, Tables);

	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion		
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	RowIDInfo.Ref AS Ref,
		|	RowIDInfo.Key AS Key,
		|	MAX(RowIDInfo.RowID) AS RowID
		|INTO RowIDInfo
		|FROM
		|	Document.PurchaseOrder.RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Ref = &Ref
		|GROUP BY
		|	RowIDInfo.Ref,
		|	RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PurchaseOrderItemList.Ref.Company AS Company,
		|	PurchaseOrderItemList.Store AS Store,
		|	PurchaseOrderItemList.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseOrderItemList.Ref.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	PurchaseOrderItemList.Ref AS Order,
		|	PurchaseOrderItemList.PurchaseBasis AS PurchaseBasis,
		|	PurchaseOrderItemList.ItemKey.Item AS Item,
		|	PurchaseOrderItemList.ItemKey AS ItemKey,
		|	PurchaseOrderItemList.Quantity AS Quantity,
		|	PurchaseOrderItemList.Unit,
		|	PurchaseOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	0 AS BasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Period AS Period,
		|	RowIDInfo.RowID AS RowKey,
		|	PurchaseOrderItemList.BusinessUnit AS BusinessUnit,
		|	PurchaseOrderItemList.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN PurchaseOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	PurchaseOrderItemList.DeliveryDate AS DeliveryDate,
		|	CASE
		|		WHEN PurchaseOrderItemList.PurchaseBasis REFS Document.InternalSupplyRequest
		|		AND NOT PurchaseOrderItemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UseInternalSupplyRequest,
		|	CASE
		|		WHEN PurchaseOrderItemList.PurchaseBasis REFS Document.SalesOrder
		|		AND NOT PurchaseOrderItemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UseSalesOrder
		|FROM
		|	Document.PurchaseOrder.ItemList AS PurchaseOrderItemList
		|		LEFT JOIN RowIDInfo AS RowIDInfo
		|		ON PurchaseOrderItemList.Key = RowIDInfo.Key
		|WHERE
		|	PurchaseOrderItemList.Ref = &Ref
		|	AND NOT PurchaseOrderItemList.Cancel";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	QueryResults = Query.Execute();
	QueryTable = QueryResults.Unload();
	
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	QueryTable.UseGoodsReceipt AS UseGoodsReceipt,
		|	QueryTable.Order AS Order,
		|	QueryTable.PurchaseBasis AS PurchaseBasis,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType AS ExpenseType,
		|	QueryTable.IsService AS IsService,
		|   QueryTable.DeliveryDate AS DeliveryDate,
		|   QueryTable.UseInternalSupplyRequest AS UseInternalSupplyRequest,
		|   QueryTable.UseSalesOrder AS UseSalesOrder
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.PurchaseBasis AS Order,
		|	tmp.ItemKey,
		|	tmp.Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.UseInternalSupplyRequest
		|;
		|
//		|//[3]//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Store,
//		|	tmp.ItemKey,
//		|	tmp.Order AS ReceiptBasis,
//		|	tmp.Quantity,
//		|	tmp.Period,
//		|   tmp.RowKey
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.GoodsReceiptBeforePurchaseInvoice
//		|	AND tmp.UseGoodsReceipt
//		|	AND
//		|	NOT tmp.IsService
//		|;
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Order AS GoodsReceipt,
		|	tmp.Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity,
		|	tmp.DeliveryDate AS Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity,
		|	tmp.DeliveryDate AS Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|	AND tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|;
		|//[6]////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|   tmp.PurchaseBasis AS Order,
		|   tmp.Store AS Store,
		|   tmp.ItemKey AS ItemKey,
		|   tmp.RowKey AS RowKey,
		|   tmp.Quantity,
		|   tmp.Period
		|FROM 
		|	tmp AS tmp
		|WHERE
		|   tmp.UseSalesOrder";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance_Receipt         = QueryResults[1].Unload();
	Tables.OrderBalance_Expense         = QueryResults[2].Unload();
//	Tables.GoodsInTransitIncoming       = QueryResults[3].Unload();
	Tables.ReceiptOrders                = QueryResults[3].Unload();
	Tables.GoodsReceiptSchedule_Receipt = QueryResults[4].Unload();
	Tables.GoodsReceiptSchedule_Expense = QueryResults[5].Unload();
	Tables.OrderProcurement             = QueryResults[6].Unload();

#EndRegion
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Procedure FillTables(Ref, AddInfo, Tables)
	Var AccReg;
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("OrderBalance_Expense"         , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderBalance_Receipt"         , PostingServer.CreateTable(AccReg.OrderBalance));
//	Tables.Insert("GoodsInTransitIncoming"       , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("ReceiptOrders"                , PostingServer.CreateTable(AccReg.ReceiptOrders));
	Tables.Insert("GoodsReceiptSchedule_Receipt" , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("GoodsReceiptSchedule_Expense" , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("OrderProcurement"             , PostingServer.CreateTable(AccReg.OrderProcurement));
	
	Tables.Insert("OrderBalance_Exists_Receipt"   , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderBalance_Exists_Expense"   , PostingServer.CreateTable(AccReg.OrderBalance));
//	Tables.Insert("GoodsInTransitIncoming_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("OrderProcurement_Exists"       , PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("ReceiptOrders_Exists"          , PostingServer.CreateTable(AccReg.ReceiptOrders));
	
	Tables.OrderBalance_Exists_Receipt =
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.OrderBalance_Exists_Expense =
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
//	Tables.GoodsInTransitIncoming_Exists =
//	AccumulationRegisters.GoodsInTransitIncoming.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.OrderProcurement_Exists =
	AccumulationRegisters.OrderProcurement.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.ReceiptOrders_Exists =
	AccumulationRegisters.ReceiptOrders.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
EndProcedure

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	 
	// OrderBalance_Expense [Expense] 
	// OrderBalance_Receipt [Receipt]
	ArrayOfTables = New Array();
	
	Table1 = Parameters.DocumentDataTables.OrderBalance_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.OrderBalance_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, Order, ItemKey, RowKey, Quantity"), 
			True));
	
//	// GoodsInTransitIncoming
//	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
//		New Structure("RecordType, RecordSet, WriteInTransaction",
//			AccumulationRecordType.Receipt,
//			Parameters.DocumentDataTables.GoodsInTransitIncoming,
//			True));
		
	// ReceiptOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReceiptOrders,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReceiptOrders,
			True));
	
	// GoodsReceiptSchedule
	// GoodsReceiptSchedule_Receipt [Receipt]  
	// GoodsReceiptSchedule_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.GoodsReceiptSchedule_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.GoodsReceiptSchedule_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsReceiptSchedule,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Order, Store, ItemKey, RowKey, Quantity, DeliveryDate"),
			Parameters.IsReposting));
	
	// OrderProcurement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderProcurement,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderProcurement,
			True));
			
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
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.PurchaseOrder.ItemList");
	If Not Cancel And Not AccReg.OrderBalance.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                       Parameters.DocumentDataTables.OrderBalance_Receipt,
	                                                       Parameters.DocumentDataTables.OrderBalance_Exists_Receipt,
	                                                       AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.OrderBalance.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                       Parameters.DocumentDataTables.OrderBalance_Expense,
	                                                       Parameters.DocumentDataTables.OrderBalance_Exists_Expense,
	                                                       AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
//	If Not Cancel And Not AccReg.GoodsInTransitIncoming.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
//	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming,
//	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming_Exists,
//	                                                                 AccumulationRecordType.Receipt, Unposting, AddInfo) Then
//		Cancel = True;
//	EndIf;
	
	If Not Cancel And Not AccReg.OrderProcurement.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                           Parameters.DocumentDataTables.OrderProcurement,
	                                                           Parameters.DocumentDataTables.OrderProcurement_Exists,
	                                                           AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.ReceiptOrders.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                        Parameters.DocumentDataTables.ReceiptOrders,
	                                                        Parameters.DocumentDataTables.ReceiptOrders_Exists,
	                                                        AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.PurchaseOrder.ItemList");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters),
	                                                                PostingServer.GetQueryTableByName("Exists_R4035B_IncomingStocks", Parameters),
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
	StrParams.Insert("Ref", Ref);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Exists_R4035B_IncomingStocks());
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
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO TableRowIDInfo
	|FROM
	|	Document.PurchaseOrder.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	|	ISNULL(TableRowIDInfo.RowID, PurchaseOrderItems.Key)  AS RowKey,
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
	|	AND NOT PurchaseOrderItems.PurchaseBasis.REF IS NULL AS UseSalesOrder,
	|	PurchaseOrderItems.Ref.Currency AS Currency,
	|	&StatusInfoPosting
	|INTO ItemList
	|FROM
	|	Document.PurchaseOrder.ItemList AS PurchaseOrderItems
	|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
	|		ON PurchaseOrderItems.Key = TableRowIDInfo.Key
	|WHERE
	|	PurchaseOrderItems.Ref = &Ref
	|	AND &StatusInfoPosting";
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

Function Exists_R4035B_IncomingStocks()
	Return
		"SELECT *
		|	INTO Exists_R4035B_IncomingStocks
		|FROM
		|	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		|WHERE
		|	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction
		
#EndRegion
