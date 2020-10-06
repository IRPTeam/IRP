#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("StockReservation"                     , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("OrderBalance"                         , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation"                     , PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("InventoryBalance"                     , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitOutgoing"               , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance"                         , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ShipmentOrders"                       , PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("ShipmentConfirmationSchedule_Receipt" , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ShipmentConfirmationSchedule_Expense" , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("OrderProcurement"                     , PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("SalesOrderTurnovers"                  , PostingServer.CreateTable(AccReg.SalesOrderTurnovers));

	Tables.Insert("OrderBalance_Exists"           , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("GoodsInTransitOutgoing_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("OrderProcurement_Exists"       , PostingServer.CreateTable(AccReg.OrderProcurement));
	Tables.Insert("ShipmentOrders_Exists"         , PostingServer.CreateTable(AccReg.ShipmentOrders));
	
	Tables.OrderBalance_Exists = 
	AccumulationRegisters.OrderBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.GoodsInTransitOutgoing_Exists = 
	AccumulationRegisters.GoodsInTransitOutgoing.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.OrderProcurement_Exists = 
	AccumulationRegisters.OrderProcurement.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.ShipmentOrders_Exists = 
	AccumulationRegisters.ShipmentOrders.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	SalesOrderItemList.Ref.Company AS Company,
		|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
		|	SalesOrderItemList.Store AS Store,
		|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Ref AS SalesOrder,
		|	SalesOrderItemList.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	SalesOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	SalesOrderItemList.ItemKey.Item AS Item,
		|	&Period AS Period,
		|	SalesOrderItemList.Key AS RowKeyUUID,
		|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Repeal) AS IsProcurementMethod_Repeal,
		|	CASE
		|		WHEN SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	SalesOrderItemList.TotalAmount AS Amount,
		|	SalesOrderItemList.Ref.Currency AS Currency
		|FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	QueryResults = Query.Execute();
	QueryTable = QueryResults.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTable);
	PostingServer.UUIDToString(QueryTable);
	
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
	Query.SetParameter("QueryTable", QueryTable);
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
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Procedure GetTables_Common(Tables, TempManager, TableName)
	// tmp
	Query = New Query();
	Query.TempTablesManager = TempManager;
	#Region QueryText
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
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	Tables.SalesOrderTurnovers = QueryResults[0].Unload();
EndProcedure

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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation                     , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[3].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation                     , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[3].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;	
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement                     , QueryResults[3].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;	
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
		
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement                     , QueryResults[3].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[6] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[7] ShipmentConfirmationSchedule_Expense
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation                     , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance                     , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.StockBalance                         , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders                       , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[6].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Expense , QueryResults[7].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period, 
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[4] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockReservation                     , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing               , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[4].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[4] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance                     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement                     , QueryResults[4].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
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
		|//[2] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[3] OrderProcurement
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.OrderProcurement                     , QueryResults[3].Unload());
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
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] ShipmentConfirmationSchedule_Receipt
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Order AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[1].Unload());
EndProcedure

#EndRegion

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
			True));
	
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
			True));
	
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
			True));
	
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
			True));
	
	// SalesOrderTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesOrderTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SalesOrderTurnovers,
			Parameters.IsReposting));
	
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
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance_Exists);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// OrderProcurement
	OrderProcurement = AccumulationRegisters.OrderProcurement.GetLockFields(DocumentDataTables.OrderProcurement_Exists);
	DataMapWithLockFields.Insert(OrderProcurement.RegisterName, OrderProcurement.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders_Exists);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
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
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.SalesOrder.ItemList");
	AccReg = AccumulationRegisters;
	If Not Cancel And Not AccReg.GoodsInTransitOutgoing.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists,
	                                                                 AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.OrderBalance.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                       Parameters.DocumentDataTables.OrderBalance,
	                                                       Parameters.DocumentDataTables.OrderBalance_Exists,
	                                                       AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.OrderProcurement.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                           Parameters.DocumentDataTables.OrderProcurement,
	                                                           Parameters.DocumentDataTables.OrderProcurement_Exists,
	                                                           AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.ShipmentOrders.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                         Parameters.DocumentDataTables.ShipmentOrders,
	                                                         Parameters.DocumentDataTables.ShipmentOrders_Exists,
	                                                         AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion
