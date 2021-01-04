#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	#Region OldPosting
	FillTables(Ref, AddInfo, Tables);
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	PurchaseOrdertemList.Ref.Company AS Company,
		|	PurchaseOrdertemList.Store AS Store,
		|	PurchaseOrdertemList.Store.UseGoodsReceipt AS UseGoodsReceipt,
		|	PurchaseOrdertemList.Ref.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,
		|	PurchaseOrdertemList.Ref AS Order,
		|	PurchaseOrdertemList.PurchaseBasis AS PurchaseBasis,
		|	PurchaseOrdertemList.ItemKey.Item AS Item,
		|	PurchaseOrdertemList.ItemKey AS ItemKey,
		|	PurchaseOrdertemList.Quantity AS Quantity,
		|	PurchaseOrdertemList.Unit,
		|	PurchaseOrdertemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseOrdertemList.ItemKey.Unit AS ItemKeyUnit,
		|	0 AS BasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Period AS Period,
		|	PurchaseOrdertemList.Key AS RowKeyUUID,
		|	PurchaseOrdertemList.BusinessUnit AS BusinessUnit,
		|	PurchaseOrdertemList.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN PurchaseOrdertemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	PurchaseOrdertemList.DeliveryDate AS DeliveryDate,
		|	CASE
		|		WHEN PurchaseOrdertemList.PurchaseBasis REFS Document.InternalSupplyRequest
		|		AND
		|		NOT PurchaseOrdertemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UseInternalSupplyRequest,
		|   CASE
		|		WHEN PurchaseOrdertemList.PurchaseBasis REFS Document.SalesOrder
		|		AND
		|		NOT PurchaseOrdertemList.PurchaseBasis.Date IS NULL
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UseSalesOrder	
		|FROM
		|	Document.PurchaseOrder.ItemList AS PurchaseOrdertemList
		|WHERE
		|	PurchaseOrdertemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	QueryResults = Query.Execute();
	QueryTable = QueryResults.Unload();
	
	PostingServer.UUIDToString(QueryTable);
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
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|   AND NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS ReceiptBasis,
		|	tmp.Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[6]////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|
		|//[7]///////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.GoodsReceiptBeforePurchaseInvoice
		|	AND
		|	NOT tmp.UseGoodsReceipt
		|	AND
		|	NOT tmp.IsService
		|   AND tmp.UseSalesOrder
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|
		|//[8]//////////////////////////////////////////////////////////////////////////////
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
		|//[9]//////////////////////////////////////////////////////////////////////////////
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
		|//[10]//////////////////////////////////////////////////////////////////////////////
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
		|//[11]////////////////////////////////////////////////////////////////////////////////
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
		|   tmp.UseSalesOrder
		|;
		|
		|//[12]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.PurchaseBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Quantity,
		|	tmp.DeliveryDate AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1) 
		|	AND tmp.PurchaseBasis REFS Document.SalesOrder
		|";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance_Receipt         = QueryResults[1].Unload();
	Tables.OrderBalance_Expense         = QueryResults[2].Unload();
	Tables.InventoryBalance             = QueryResults[3].Unload();
	Tables.GoodsInTransitIncoming       = QueryResults[4].Unload();
	Tables.StockBalance                 = QueryResults[5].Unload();
	Tables.StockReservation_Receipt     = QueryResults[6].Unload();
	Tables.StockReservation_Expense     = QueryResults[7].Unload();	
	Tables.ReceiptOrders                = QueryResults[8].Unload();
	Tables.GoodsReceiptSchedule_Receipt = QueryResults[9].Unload();
	Tables.GoodsReceiptSchedule_Expense = QueryResults[10].Unload();
	Tables.OrderProcurement             = QueryResults[11].Unload();
	
	#EndRegion
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting	
	
	Query = New Query;
	Query.TempTablesManager = New TempTablesManager();
	Query.SetParameter("Ref", Ref);
	
	QueryArray = New Array;
	SetQueryTexts(QueryArray);
	
	Query.Text = StrConcat(QueryArray, Chars.LF + ";" + Chars.LF);
	Query.Execute();
	For Each VT In Tables Do
		VTSearch = Query.TempTablesManager.Tables.Find(VT.Key);
		If VTSearch = Undefined Then
			Continue;
		EndIf;
		PostingServer.MergeTables(Tables[VT.Key], VTSearch.GetData().Unload());
	EndDo;
#EndRegion	
	Return Tables;
EndFunction

Procedure FillTables(Ref, AddInfo, Tables)
	Var AccReg;
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("OrderBalance_Expense"         , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderBalance_Receipt"         , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("InventoryBalance"             , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitIncoming"       , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("StockBalance"                 , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation_Receipt"     , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Expense"     , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("ReceiptOrders"                , PostingServer.CreateTable(AccReg.ReceiptOrders));
	Tables.Insert("GoodsReceiptSchedule_Receipt" , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("GoodsReceiptSchedule_Expense" , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("OrderProcurement"             , PostingServer.CreateTable(AccReg.OrderProcurement));
	
	Tables.Insert("OrderBalance_Exists_Receipt"   , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderBalance_Exists_Expense"   , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("GoodsInTransitIncoming_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("OrderProcurement_Exists"       , PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("ReceiptOrders_Exists"          , PostingServer.CreateTable(AccReg.ReceiptOrders));
	
	Tables.Insert("StockReservation_Exists" 	  , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"           , PostingServer.CreateTable(AccReg.StockBalance));

	Tables.OrderBalance_Exists_Receipt =
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.OrderBalance_Exists_Expense =
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.GoodsInTransitIncoming_Exists =
	AccumulationRegisters.GoodsInTransitIncoming.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.OrderProcurement_Exists =
	AccumulationRegisters.OrderProcurement.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.ReceiptOrders_Exists =
	AccumulationRegisters.ReceiptOrders.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	SetRegisters(Tables);
EndProcedure

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	AccRegOrderBalance = AccumulationRegisters.OrderBalance;
	ArrayOfTables = New Array();
	ArrayOfTables.Add(DocumentDataTables.OrderBalance_Receipt);
	ArrayOfTables.Add(DocumentDataTables.OrderBalance_Expense);
	
	OrderBalance = AccRegOrderBalance.GetLockFields(
	PostingServer.JoinTables(ArrayOfTables, AccRegOrderBalance.GetLockFieldNames()));
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// GoodsInTransitIncoming
	GoodsInTransitIncoming = AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// ReceiptOrders
	ReceiptOrders = AccumulationRegisters.ReceiptOrders.GetLockFields(DocumentDataTables.ReceiptOrders);
	DataMapWithLockFields.Insert(ReceiptOrders.RegisterName, ReceiptOrders.LockInfo);
	
	// GoodsReceiptSchedule
	GoodsReceiptSchedule = AccumulationRegisters.GoodsReceiptSchedule.GetLockFields(DocumentDataTables.GoodsReceiptSchedule_Expense);
	DataMapWithLockFields.Insert(GoodsReceiptSchedule.RegisterName, GoodsReceiptSchedule.LockInfo);
	
	// OrderProcurement
	OrderProcurement = AccumulationRegisters.OrderProcurement.GetLockFields(DocumentDataTables.OrderProcurement);
	DataMapWithLockFields.Insert(OrderProcurement.RegisterName, OrderProcurement.LockInfo);
	
#Region NewRegistersPosting	
	GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
#EndRegion
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
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
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.InventoryBalance,
			Parameters.IsReposting));
	
	// GoodsInTransitIncoming
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitIncoming,
			True));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.StockBalance,
			True));
	
	// StockReservation
	// StockReservation_Receipt [Receipt]  
	// StockReservation_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
			"RecordType, Period, Store, ItemKey, Quantity"),
			True));
	
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
	SetPostingDataTables(PostingDataTables, Parameters);
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
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	AccRegOrderBalance = AccumulationRegisters.OrderBalance;
	ArrayOfTables = New Array();
	ArrayOfTables.Add(DocumentDataTables.OrderBalance_Exists_Receipt);
	ArrayOfTables.Add(DocumentDataTables.OrderBalance_Exists_Expense);
	
	OrderBalance = AccRegOrderBalance.GetLockFields(
	PostingServer.JoinTables(ArrayOfTables, AccRegOrderBalance.GetLockFieldNames()));
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);

	// GoodsInTransitIncoming
	GoodsInTransitIncoming = AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);

	// OrderProcurement
	OrderProcurement = AccumulationRegisters.OrderProcurement.GetLockFields(DocumentDataTables.OrderProcurement_Exists);
	DataMapWithLockFields.Insert(OrderProcurement.RegisterName, OrderProcurement.LockInfo);

	// ReceiptOrders
	ReceiptOrders = AccumulationRegisters.ReceiptOrders.GetLockFields(DocumentDataTables.ReceiptOrders_Exists);
	DataMapWithLockFields.Insert(ReceiptOrders.RegisterName, ReceiptOrders.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Exists);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Exists);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
#Region NewRegistersPosting	
	GetLockDataSource(DataMapWithLockFields, DocumentDataTables);
#EndRegion	
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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseOrder.ItemList", AddInfo);
		
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
	
	If Not Cancel And Not AccReg.GoodsInTransitIncoming.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming_Exists,
	                                                                 AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
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
EndProcedure

#EndRegion

#Region NewRegistersPosting

Procedure SetRegisters(Tables)

	For Each Register In Metadata.Documents.PurchaseOrder.RegisterRecords Do
		// use only new registers
		If Not StrFind(Register.Name, "_") Then
			Continue;
		EndIf;
		Tables.Insert(Register.Name, PostingServer.CreateTable(Register));
	EndDo;
	
EndProcedure

Procedure SetQueryTexts(QueryArray)
	QueryArray.Add(SetItemListVT());
	QueryArray.Add(SetPostingTables_R1010_PurchaseOrders());
	QueryArray.Add(SetPostingTables_R1011_PurchaseOrdersReceipt());
	QueryArray.Add(SetPostingTables_R1012_PurchaseOrdersInvoiceClosing());
	QueryArray.Add(SetPostingTables_R1014_CanceledPurchaseOrders());
	QueryArray.Add(SetPostingTables_R2013_SalesOrdersProcurement());
	QueryArray.Add(SetPostingTables_R4016_InternalSupplyRequestOrdering());
	QueryArray.Add(SetPostingTables_R4033_GoodsReceiptSchedule());

EndProcedure

Procedure GetLockDataSource(DataMapWithLockFields, DocumentDataTables)

	For Each Register In DocumentDataTables Do
		// use only new registers
		If Not Mid(Register.Key, 6, 1) = "_" Then
			Continue;
		EndIf;
		LockData = AccumulationRegisters[Register.Key].GetLockFields(DocumentDataTables[Register.Key]);
		DataMapWithLockFields.Insert(LockData.RegisterName, LockData.LockInfo);
	
	EndDo;
	
EndProcedure

Procedure SetPostingDataTables(PostingDataTables, Parameters)

	Settings = New Structure("RegisterName", "R1010_PurchaseOrders");
	Settings.Insert("RecordType", AccumulationRecordType.Receipt);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);

	Settings = New Structure("RegisterName", "R1011_PurchaseOrdersReceipt");
	Settings.Insert("RecordType", AccumulationRecordType.Receipt);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);
	
	Settings = New Structure("RegisterName", "R1012_PurchaseOrdersInvoiceClosing");
	Settings.Insert("RecordType", AccumulationRecordType.Receipt);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);
	
	Settings = New Structure("RegisterName", "R1014_CanceledPurchaseOrders");
	Settings.Insert("RecordType", AccumulationRecordType.Receipt);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);

	Settings = New Structure("RegisterName", "R2013_SalesOrdersProcurement");
	Settings.Insert("RecordType", AccumulationRecordType.Expense);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);		
	
	Settings = New Structure("RegisterName", "R4016_InternalSupplyRequestOrdering");
	Settings.Insert("RecordType", AccumulationRecordType.Expense);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);
		
	Settings = New Structure("RegisterName", "R4033_GoodsReceiptSchedule");
	Settings.Insert("RecordType", AccumulationRecordType.Receipt);
	Settings.Insert("RecordSet", Parameters.DocumentDataTables[Settings.RegisterName]);
	Settings.Insert("WriteInTransaction", True);
	PostingDataTables.Insert(Parameters.Object.RegisterRecords[Settings.RegisterName], Settings);
	
EndProcedure

Function SetItemListVT()

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
		|	PurchaseOrderItems.NetAmount
		|INTO DocData
		|FROM
		|	Document.PurchaseOrder.ItemList AS PurchaseOrderItems
		|WHERE
		|	PurchaseOrderItems.Ref = &Ref";
EndFunction

Function SetPostingTables_R1010_PurchaseOrders()
	Return
		"SELECT *
		|INTO R1010_PurchaseOrders
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function SetPostingTables_R1011_PurchaseOrdersReceipt()
	Return
		"SELECT *
		|INTO R1011_PurchaseOrdersReceipt
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService";

EndFunction

Function SetPostingTables_R1012_PurchaseOrdersInvoiceClosing()
	Return
		"SELECT *
		|INTO R1012_PurchaseOrdersInvoiceClosing
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.isCanceled";

EndFunction

Function SetPostingTables_R1014_CanceledPurchaseOrders()
	Return
		"SELECT *
		|INTO R1014_CanceledPurchaseOrders
		|FROM
		|	DocData AS QueryTable
		|WHERE QueryTable.isCanceled";

EndFunction

Function SetPostingTables_R2013_SalesOrdersProcurement()
	Return
		"SELECT
		|	QueryTable.Quantity AS ReOrderedQuantity,
		|	QueryTable.SalesOrder AS Order,
		|	*
		|INTO R2013_SalesOrdersProcurement
		|FROM
		|	DocData AS QueryTable
		|WHERE
		|	NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService
		|	AND NOT QueryTable.SalesOrder = Value(Document.SalesOrder.EmptyRef)";

EndFunction

Function SetPostingTables_R4016_InternalSupplyRequestOrdering()
	Return
		"SELECT
		|	QueryTable.Quantity AS Quantity,
		|	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		|	*
		|INTO R4016_InternalSupplyRequestOrdering
		|FROM
		|	DocData AS QueryTable
		|WHERE
		|	NOT QueryTable.isCanceled
		|	AND NOT QueryTable.IsService
		|	AND NOT QueryTable.InternalSupplyRequest = Value(Document.InternalSupplyRequest.EmptyRef)";

EndFunction

Function SetPostingTables_R4033_GoodsReceiptSchedule()
	Return
		"SELECT 
		|	CASE WHEN QueryTable.DeliveryDate = DATETIME(1, 1, 1) THEN
		|		QueryTable.Period
		|	ELSE
		|		QueryTable.DeliveryDate
		|	END AS Period,
		|	QueryTable.Order AS Basis,
		|*
		|
		|INTO R4033_GoodsReceiptSchedule
		|FROM
		|	DocData AS QueryTable
		|WHERE NOT QueryTable.isCanceled AND NOT QueryTable.IsService
		|	AND QueryTable.SalesOrder = Value(Document.SalesOrder.EmptyRef)";

EndFunction

#EndRegion