#Region Public

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	DocumentDataTables = GetRegisterTables();	
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	
	DocumentDataTables.OrderBalance_Exists = GetExistsOrderBalance(Ref, AddInfo);
	
	If Not StatusInfo.Posting Then
		Return DocumentDataTables;
	EndIf;

	QueryTables = GetQueryTables(Ref, StatusInfo);
	
	FillRegisterTables(QueryTables, DocumentDataTables);	
	
	Parameters.IsReposting = False;
	
	Return DocumentDataTables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;	
	
	DataMapWithLockFields = New Map();
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// OrderReservation
	OrderReservation = AccumulationRegisters.OrderReservation.GetLockFields(DocumentDataTables.OrderReservation);
	DataMapWithLockFields.Insert(OrderReservation.RegisterName, OrderReservation.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
	// ShipmentConfirmationSchedule
	ShipmentConfirmationSchedule 
	= AccumulationRegisters.ShipmentConfirmationSchedule.GetLockFields(DocumentDataTables.ShipmentConfirmationSchedule_Expense);
	DataMapWithLockFields.Insert(ShipmentConfirmationSchedule.RegisterName, ShipmentConfirmationSchedule.LockInfo);
	
	// OrderProcurement
	OrderProcurement = AccumulationRegisters.OrderProcurement.GetLockFields(DocumentDataTables.OrderProcurement);
	DataMapWithLockFields.Insert(OrderProcurement.RegisterName, OrderProcurement.LockInfo);
	
	Return DataMapWithLockFields;
	
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export

	PostingDataTables = New Map();
		
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			Parameters.IsReposting));
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.DocumentDataTables.OrderBalance_Exists.Count() > 0));
	
	// OrderReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderReservation,
			Parameters.IsReposting));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.InventoryBalance,
			Parameters.IsReposting));
	
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing,
			Parameters.IsReposting));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance,
			Parameters.IsReposting));
	
	// ShipmentOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentOrders,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ShipmentOrders,
			Parameters.IsReposting));
	
	// ShipmentConfirmationSchedule
	// ShipmentConfirmationSchedule_Receipt [Receipt]  
	// ShipmentConfirmationSchedule_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.ShipmentConfirmationSchedule_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.ShipmentConfirmationSchedule_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentConfirmationSchedule,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Order, Store, ItemKey, RowKey, Quantity, DeliveryDate"),
			Parameters.IsReposting));
	
	// OrderProcurement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderProcurement,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderProcurement,
			Parameters.IsReposting));
	
	// SalesOrderTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesOrderTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesOrderTurnovers,
			Parameters.IsReposting));
	
	Return PostingDataTables;

EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	If Not CheckOrderBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("OrderBalance_Exists", PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.OrderBalance_Exists = GetExistsOrderBalance(Ref, AddInfo);	
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance_Exists);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	If Not CheckOrderBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#EndRegion

#Region Private

#Region PostingProcedures

#Region PostingGetDocumentDataTables

Function GetRegisterTables()
	AccReg = Metadata.AccumulationRegisters;
	DocumentDataTables = New Structure();
	DocumentDataTables.Insert("StockReservation", PostingServer.CreateTable(AccReg.StockReservation));
	DocumentDataTables.Insert("OrderBalance", PostingServer.CreateTable(AccReg.OrderBalance));
	DocumentDataTables.Insert("OrderBalance_Exists", PostingServer.CreateTable(AccReg.OrderBalance));
	DocumentDataTables.Insert("OrderReservation", PostingServer.CreateTable(AccReg.OrderReservation));
	DocumentDataTables.Insert("InventoryBalance", PostingServer.CreateTable(AccReg.InventoryBalance));
	DocumentDataTables.Insert("GoodsInTransitOutgoing", PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	DocumentDataTables.Insert("StockBalance", PostingServer.CreateTable(AccReg.StockBalance));
	DocumentDataTables.Insert("ShipmentOrders", PostingServer.CreateTable(AccReg.ShipmentOrders));
	DocumentDataTables.Insert("ShipmentConfirmationSchedule_Receipt", PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	DocumentDataTables.Insert("ShipmentConfirmationSchedule_Expense", PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	DocumentDataTables.Insert("OrderProcurement", PostingServer.CreateTable(AccReg.OrderProcurement));
	DocumentDataTables.Insert("SalesOrderTurnovers", PostingServer.CreateTable(AccReg.SalesOrderTurnovers));
	Return DocumentDataTables;
EndFunction

function GetQueryTables(Ref, StatusInfo)
	QueryTables = New Structure();
	QueryTable = QueryTable(Ref, StatusInfo);	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	QueryTables.Insert("QueryTable", QueryTable);
	Return QueryTables;
EndFunction

Procedure FillRegisterTables(QueryTables, Tables)
	TempManager = New TempTablesManager();
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.ShipmentConfirmationsBeforeSalesInvoice AS UseShipmentBeforeInvoice,
		|	QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.SalesOrder AS Order,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.DeliveryDate AS DeliveryDate,
		|   QueryTable.IsProcurementMethod_Stock AS IsProcMeth_Stock,
		|   QueryTable.IsProcurementMethod_Purchase AS IsProcMeth_Purchase,
		|   QueryTable.IsProcurementMethod_Repeal AS IsProcMeth_Repeal,
		|   QueryTable.IsService AS IsService,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.Currency AS Currency
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable";
	Query.SetParameter("QueryTable", QueryTables.QueryTable);
	Query.Execute();
	
	GetTables_Common(Tables, TempManager, "tmp");
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_Stock
		|AND NOT tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_NotIsService(Tables, TempManager, "tmp_1");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_Purchase
		|AND NOT tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethPurchase_NotIsService(Tables, TempManager, "tmp_2");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_Repeal
		|AND NOT tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethRepeal_NotIsService(Tables, TempManager, "tmp_3");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|        tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_Stock
		|AND NOT tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethStock_NotIsService(Tables, TempManager, "tmp_4");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_5 FROM tmp AS tmp
		|WHERE
		|        tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_Purchase
		|AND NOT tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_5").GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethPurchase_NotIsService(Tables, TempManager, "tmp_5");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_6 FROM tmp AS tmp
		|WHERE
		|        tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_Repeal
		|AND NOT tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_6").GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethRepeal_NotIsService(Tables, TempManager, "tmp_6");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_7 FROM tmp AS tmp
		|WHERE
		|tmp.IsService";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_7").GetData().IsEmpty() Then
		GetTables_IsService(Tables, TempManager, "tmp_7");
	EndIf;
EndProcedure

Function QueryTable(Ref, StatusInfo)
	Query = New Query();
	Query.Text =
		"SELECT
		|	SalesOrderItemList.Ref.Company AS Company,
		|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
		|	SalesOrderItemList.Store AS Store,
		|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Ref AS SalesOrder,
		|	SUM(SalesOrderItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	SalesOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	SalesOrderItemList.ItemKey.Item AS Item,
		|	&Period AS Period,
		|	SalesOrderItemList.Key AS RowKey,
		|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Repeal) AS IsProcurementMethod_Repeal,
		|	CASE
		|		WHEN SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	SUM(SalesOrderItemList.TotalAmount) AS Amount,
		|	SalesOrderItemList.Ref.Currency AS Currency
		|FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref = &Ref
		|GROUP BY
		|	SalesOrderItemList.Ref.Company,
		|	SalesOrderItemList.Store,
		|	SalesOrderItemList.ItemKey,
		|	SalesOrderItemList.Ref,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.ItemKey.Item.Unit,
		|	SalesOrderItemList.ItemKey.Unit,
		|	SalesOrderItemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice,
		|	SalesOrderItemList.Store.UseShipmentConfirmation,
		|	SalesOrderItemList.Key,
		|	SalesOrderItemList.DeliveryDate,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock),
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase),
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Repeal),
		|	CASE
		|		WHEN SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END,
		|	SalesOrderItemList.Ref.Currency";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);	
	QueryResults = Query.Execute();
		
	Return QueryResults.Unload();
EndFunction

Procedure GetTables_Common(Tables, TempManager, TableName)
	// tmp
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		// [0]
		"SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS SalesOrder,
		|	tmp.Currency AS Currency,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Amount AS Amount,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables.SalesOrderTurnovers = QueryResults[0].Unload();
EndProcedure

#EndRegion

#Region FillRegisterTables

#Region Table_tmp_1

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_NotIsService(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] StockReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|   tmp.Order, 
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[2] OrderReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|//[3] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[3].Unload());
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] StockReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|   tmp.Order, 
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[2] OrderReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|//[3] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[3].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_2

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethPurchase_NotIsService(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethPurchase_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethPurchase_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethPurchase_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderReservation 
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|//[2] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;	
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement, QueryResults[3].Unload());
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethPurchase_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderReservation 
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;	
		|//[2] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;	
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement, QueryResults[3].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_3

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethRepeal_NotIsService(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethRepeal_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethRepeal_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethRepeal_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Return;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethRepeal_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_4

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethStock_NotIsService(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethStock_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethStock_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethStock_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)

	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] StockReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[2] OrderReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[3] InventoryBalance
		|SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[4] StockBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[5] ShipmentOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.Order AS Order,
		|	tmp.Order AS ShipmentConfirmation,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|   tmp.RowKey
		|;
		|
		|//[6] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|//[7] ShipmentConfirmationSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders, QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[6].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Expense, QueryResults[7].Unload());
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethStock_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] StockReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// [1] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[2] OrderReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|
		|//[3] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order AS ShipmentBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period, 
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|   tmp.RowKey
		|;
		|
		|//[4] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[4].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_5

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethPurchase_NotIsService(Tables, TempManager, TableName)
	// tmp_5
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethPurchase_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethPurchase_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethPurchase_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	// tmp_5_1
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[2] InventoryBalance
		|SELECT
		|	tmp.Company,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[3] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|//[4] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement, QueryResults[4].Unload());
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethPurchase_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	// tmp_5_2
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] OrderReservation
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|
		|//[2] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement, QueryResults[3].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_6

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethRepeal_NotIsService(Tables, TempManager, TableName)
	// tmp_6
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	 NOT tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethRepeal_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	tmp.UseShipmentConfirmation";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethRepeal_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethRepeal_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Return;
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethRepeal_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Return;
EndProcedure

#EndRegion

#Region Table_tmp_7

Procedure GetTables_IsService(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		//	[0] OrderBalance
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Order,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.Order,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt, QueryResults[1].Unload());
EndProcedure

#EndRegion

#EndRegion

#EndRegion

Function CheckOrderBalance(Ref, Parameters, AddInfo = Undefined)
	Query = New Query();
	Query.Text =
	"SELECT
	|	OrderBalance_Exists.Order AS Order,
	|	OrderBalance_Exists.Store AS Store,
	|	OrderBalance_Exists.Item AS Item,
	|	OrderBalance_Exists.ItemKey AS ItemKey,
	|	OrderBalance_Exists.Quantity AS Quantity
	|INTO OrderBalance_Exists
	|FROM
	|	&OrderBalance_Exists AS OrderBalance_Exists
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	OrderBalance_Exists.Order AS Order,
	|	OrderBalance_Exists.Store AS Store,
	|	OrderBalance_Exists.Item AS Item,
	|	OrderBalance_Exists.ItemKey AS ItemKey,
	|	OrderBalance_Exists.Quantity AS Quantity
	|INTO OrderBalance_Deleted
	|FROM
	|	OrderBalance_Exists AS OrderBalance_Exists
	|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
	|		ON ItemList.Ref = &Ref
	|		AND OrderBalance_Exists.Order = ItemList.Ref
	|		AND OrderBalance_Exists.Store = ItemList.Store
	|		AND OrderBalance_Exists.ItemKey = ItemList.ItemKey
	|WHERE
	|	ItemList.Ref IS NULL
	|	AND
	|	NOT &Unposting
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesOrderItemList.Ref AS Order,
	|	SalesOrderItemList.ItemKey.Item AS Item,
	|	SalesOrderItemList.ItemKey AS ItemKey,
	|	SalesOrderItemList.Store AS Store,
	|	SalesOrderItemList.Quantity AS Quantity,
	|	0 AS BasisQuantity,
	|	SalesOrderItemList.Unit AS Unit,
	|	SalesOrderItemList.ItemKey.Item.Unit AS ItemUnit,
	|	SalesOrderItemList.ItemKey.Unit AS ItemKeyUnit,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
	|	SalesOrderItemList.LineNumber AS LineNumber
	|INTO ItemList_Full
	|FROM
	|	Document.SalesOrder.ItemList AS SalesOrderItemList
	|WHERE
	|	SalesOrderItemList.Ref = &Ref
	|
	|UNION ALL
	|
	|SELECT
	|	OrderBalance_Deleted.Order,
	|	OrderBalance_Deleted.Item,
	|	OrderBalance_Deleted.ItemKey,
	|	OrderBalance_Deleted.Store,
	|	OrderBalance_Deleted.Quantity,
	|	0,
	|	CASE
	|		WHEN OrderBalance_Deleted.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN OrderBalance_Deleted.ItemKey.Unit
	|		ELSE OrderBalance_Deleted.ItemKey.Item.Unit
	|	END,
	|	OrderBalance_Deleted.ItemKey.Item.Unit,
	|	OrderBalance_Deleted.ItemKey.Unit,
	|	VALUE(Catalog.Units.EmptyRef),
	|	UNDEFINED
	|FROM
	|	OrderBalance_Deleted
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_Full.Order,
	|	ItemList_Full.Item,
	|	ItemList_Full.ItemKey,
	|	ItemList_Full.Store,
	|	ItemList_Full.LineNumber,
	|	ItemList_Full.BasisQuantity AS BasisQuantity,
	|	ItemList_Full.Unit AS Unit,
	|	ItemList_Full.ItemUnit AS ItemUnit,
	|	ItemList_Full.ItemKeyUnit AS ItemKeyUnit,
	|	ItemList_Full.BasisUnit AS BasisUnit,
	|	SUM(ItemList_Full.Quantity) AS Quantity
	|INTO ItemList_Full_Grouped
	|FROM
	|	ItemList_Full AS ItemList_Full
	|GROUP BY
	|	ItemList_Full.Order,
	|	ItemList_Full.Item,
	|	ItemList_Full.ItemKey,
	|	ItemList_Full.Store,
	|	ItemList_Full.LineNumber,
	|	ItemList_Full.Unit,
	|	ItemList_Full.BasisQuantity,
	|	ItemList_Full.ItemUnit,
	|	ItemList_Full.ItemKeyUnit,
	|	ItemList_Full.BasisUnit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	OrderBalanceBalance.ItemKey.Item AS Item,
	|	OrderBalanceBalance.ItemKey AS ItemKey,
	|	OrderBalanceBalance.Order,
	|	SUM(OrderBalanceBalance.QuantityBalance) AS QuantityBalance,
	|	SUM(ItemList_Full_Grouped.Quantity) AS Quantity,
	|	-SUM(OrderBalanceBalance.QuantityBalance) AS LackOfBalance,
	|	ItemList_Full_Grouped.LineNumber AS LineNumber,
	|	ItemList_Full_Grouped.BasisQuantity AS BasisQuantity,
	|	ItemList_Full_Grouped.Unit AS Unit,
	|	ItemList_Full_Grouped.ItemUnit AS ItemUnit,
	|	ItemList_Full_Grouped.ItemKeyUnit AS ItemKeyUnit,
	|	ItemList_Full_Grouped.BasisUnit AS BasisUnit,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList_Full_Grouped AS ItemList_Full_Grouped
	|		INNER JOIN AccumulationRegister.OrderBalance.Balance(, (Order, ItemKey, Store) IN
	|			(SELECT
	|				ItemList_Full_Grouped.Order AS Order,
	|				ItemList_Full_Grouped.ItemKey AS ItemKey,
	|				ItemList_Full_Grouped.Store AS Store
	|			FROM
	|				ItemList_Full_Grouped AS ItemList_Full_Grouped)) AS OrderBalanceBalance
	|		ON OrderBalanceBalance.Order = ItemList_Full_Grouped.Order
	|		AND OrderBalanceBalance.ItemKey = ItemList_Full_Grouped.ItemKey
	|		AND OrderBalanceBalance.Store = ItemList_Full_Grouped.Store
	|GROUP BY
	|	OrderBalanceBalance.ItemKey.Item,
	|	OrderBalanceBalance.ItemKey,
	|	ItemList_Full_Grouped.LineNumber,
	|	OrderBalanceBalance.Order,
	|	ItemList_Full_Grouped.Unit,
	|	ItemList_Full_Grouped.BasisQuantity,
	|	ItemList_Full_Grouped.ItemUnit,
	|	ItemList_Full_Grouped.ItemKeyUnit,
	|	ItemList_Full_Grouped.BasisUnit
	|HAVING
	|	SUM(OrderBalanceBalance.QuantityBalance) < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("OrderBalance_Exists", Parameters.DocumentDataTables.OrderBalance_Exists);
	Query.SetParameter("Unposting", ?(Parameters.Property("Unposting"), Parameters.Unposting, False));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	HaveError = False;
	If QueryTable.Count() Then
		HaveError = True;
		
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Order, ItemKey, Item, BasisUnit, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "BasisQuantity");
		ErrorParameters.Insert("FilterColumns", "Order, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Invoiced");
		ErrorParameters.Insert("Excess", True);
		
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not HaveError;
EndFunction

Function GetExistsOrderBalance(Ref, AddInfo = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	OrderBalance.Store,
	|	OrderBalance.Order,
	|	OrderBalance.ItemKey,
	|	OrderBalance.ItemKey.Item AS Item,
	|	OrderBalance.RowKey,
	|	OrderBalance.Quantity
	|FROM
	|	AccumulationRegister.OrderBalance AS OrderBalance
	|WHERE
	|	OrderBalance.Recorder = &Recorder
	|	AND OrderBalance.RecordType = &RecordType";
	Query.SetParameter("Recorder", Ref);
	Query.SetParameter("RecordType", AccumulationRecordType.Receipt);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

#EndRegion
