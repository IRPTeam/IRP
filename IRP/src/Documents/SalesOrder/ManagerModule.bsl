#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	
#Region OldPosting	
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("OrderBalance"                         , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation"                     , PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("InventoryBalance"                     , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("GoodsInTransitOutgoing"               , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
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
	|	Document.SalesOrder.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	|	RowIDInfo.RowID AS RowKey,
	|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
	|	SalesOrderItemList.Cancel AS IsCancel,
	|	NOT SalesOrderItemList.Cancel
	|	AND SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
	|	NOT SalesOrderItemList.Cancel
	|	AND SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
	|	NOT SalesOrderItemList.Cancel
	|	AND SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve) AS IsProcurementMethod_NoReserve,
	|	CASE
	|		WHEN SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsService,
	|	SalesOrderItemList.TotalAmount AS Amount,
	|	SalesOrderItemList.Ref.Currency AS Currency
	|FROM
	|	Document.SalesOrder.ItemList AS SalesOrderItemList
	|		LEFT JOIN RowIDInfo AS RowIDInfo
	|		ON SalesOrderItemList.Key = RowIDInfo.Key
	|WHERE
	|	SalesOrderItemList.Ref = &Ref
	|	AND NOT SalesOrderItemList.Cancel";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	QueryResults = Query.Execute();
	QueryTable = QueryResults.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
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
		|   QueryTable.IsProcurementMethod_NoReserve AS IsProcMeth_NoReserve,
		|	QueryTable.IsCancel AS IsCancel,
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
		|AND     tmp.IsCancel
		|AND NOT tmp.IsService";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethCancel_NotIsService(Tables, TempManager, "tmp_3");
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
		|AND     tmp.IsCancel
		|AND NOT tmp.IsService";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_6").GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethCancel_NotIsService(Tables, TempManager, "tmp_6");
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
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_8 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_NoReserve
		|AND NOT tmp.IsService";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_8").GetData().IsEmpty() Then
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethNoReserve_NotIsService(Tables, TempManager, "tmp_8");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_9 FROM tmp AS tmp
		|WHERE
		|        tmp.UseShipmentBeforeInvoice
		|AND     tmp.IsProcMeth_NoReserve
		|AND NOT tmp.IsService";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_9").GetData().IsEmpty() Then
		GetTables_UseShipmentBeforeInvoice_IsProcMethNoReserve_NotIsService(Tables, TempManager, "tmp_9");
	EndIf;
	
#EndRegion	
	Parameters.IsReposting = False;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	Return Tables;
EndFunction

Procedure GetTables_Common(Tables, TempManager, TableName)
	// tmp
	Query = New Query();
	Query.TempTablesManager = TempManager;
	#Region QueryText
	Query.Text =
		"// [0]
		|SELECT
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
	Query.Text =
		"//[0] OrderBalance
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
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethStock_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = 
		"//[0] OrderBalance
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
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
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

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethCancel_NotIsService(Tables, TempManager, TableName)
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
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethCancel_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
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
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethCancel_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethCancel_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Return;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethCancel_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
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
	Query.Text = 
		"//[0] OrderBalance
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
		|//[3] ShipmentOrders
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
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|;
		|
		|//[5] ShipmentConfirmationSchedule_Expense
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
	
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance                     , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders                       , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Expense , QueryResults[5].Unload());
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethStock_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"// [0] OrderBalance
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
		|
		|//[2] GoodsInTransitOutgoing
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
	
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.OrderReservation                     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing               , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[3].Unload());
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

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethCancel_NotIsService(Tables, TempManager, TableName)
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
		GetTables_UseShipmentBeforeInvoice_IsProcMethCancel_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
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
		GetTables_UseShipmentBeforeInvoice_IsProcMethCancel_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethCancel_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Return;
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethCancel_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
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

#Region Table_tmp_8

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethNoReserve_NotIsService(Tables, TempManager, TableName)
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
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethNoReserve_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
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
		GetTables_NotUseShipmentBeforeInvoice_IsProcMethNoReserve_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethNoReserve_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		|//[0] OrderBalance
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

Procedure GetTables_NotUseShipmentBeforeInvoice_IsProcMethNoReserve_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		|//[0] OrderBalance
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

#Region Table_tmp_9

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethNoReserve_NotIsService(Tables, TempManager, TableName)
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
		GetTables_UseShipmentBeforeInvoice_IsProcMethNoReserve_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
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
		GetTables_UseShipmentBeforeInvoice_IsProcMethNoReserve_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethNoReserve_NotUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		|//[0] OrderBalance
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
		|//[1] ShipmentOrders
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
		|//[3] ShipmentConfirmationSchedule_Expense
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
	
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders                       , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Expense , QueryResults[3].Unload());
EndProcedure

Procedure GetTables_UseShipmentBeforeInvoice_IsProcMethNoReserve_UseUseShipmentConfirmation_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		|// [0] OrderBalance
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
		|//[1] GoodsInTransitOutgoing
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
		|	tmp.DeliveryDate <> DATETIME(1, 1, 1)";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.OrderBalance                         , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing               , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule_Receipt , QueryResults[2].Unload());
EndProcedure

#EndRegion

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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesOrder.ItemList", AddInfo);
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.SalesOrder.ItemList");
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
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Exists_R4011B_FreeStocks());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2010T_SalesOrders());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2014T_CanceledSalesOrders());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4013B_StockReservationPlanning());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	SalesOrderItemList.Ref.Company AS Company,
		|	SalesOrderItemList.Ref.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
		|	SalesOrderItemList.Store AS Store,
		|	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	SalesOrderItemList.ItemKey AS ItemKey,
		|	SalesOrderItemList.Ref AS Order,
		|	SalesOrderItemList.Quantity AS UnitQuantity,
		|	SalesOrderItemList.QuantityInBaseUnit AS Quantity,
		|	SalesOrderItemList.Unit,
		|	SalesOrderItemList.ItemKey.Item AS Item,
		|	SalesOrderItemList.Ref.Date AS Period,
		|	SalesOrderItemList.Key AS RowKey,
		|	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		|	SalesOrderItemList.ProcurementMethod,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		|	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve) AS IsProcurementMethod_NonReserve,
		|	SalesOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	SalesOrderItemList.TotalAmount AS Amount,
		|	SalesOrderItemList.Ref.Currency AS Currency,
		|	SalesOrderItemList.Cancel AS IsCanceled,
		|	SalesOrderItemList.CancelReason,
		|	SalesOrderItemList.NetAmount,
		|	SalesOrderItemList.Ref.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
		|	SalesOrderItemList.OffersAmount,
		|	&StatusInfoPosting
		|INTO ItemList
		|FROM
		|	Document.SalesOrder.ItemList AS SalesOrderItemList
		|WHERE
		|	SalesOrderItemList.Ref = &Ref";
EndFunction

Function R2010T_SalesOrders()
	Return
		"SELECT
		|	*
		|INTO R2010T_SalesOrders
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND ItemList.StatusInfoPosting";

EndFunction

Function R2011B_SalesOrdersShipment()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.StatusInfoPosting";

EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R2012B_SalesOrdersInvoiceClosing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND ItemList.StatusInfoPosting";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	ItemList.Quantity AS OrderedQuantity,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.IsProcurementMethod_Purchase
		|	AND ItemList.StatusInfoPosting";

EndFunction

Function R2014T_CanceledSalesOrders()
	Return
		"SELECT
		|	*
		|INTO R2014T_CanceledSalesOrders
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.isCanceled
		|	AND ItemList.StatusInfoPosting";

EndFunction

#Region Stock

Function R4011B_FreeStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.IsProcurementMethod_Stock
		|	AND ItemList.StatusInfoPosting";

EndFunction

Function Exists_R4011B_FreeStocks()
	Return
	"SELECT *
	|INTO Exists_R4011B_FreeStocks
	|FROM
	|	AccumulationRegister.R4011B_FreeStocks AS R4011B_FreeStocks
	|WHERE
	|	R4011B_FreeStocks.Recorder = &Ref";
EndFunction	

Function R4012B_StockReservation()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4012B_StockReservation
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND ItemList.IsProcurementMethod_Stock
		|	AND ItemList.StatusInfoPosting";

EndFunction

#EndRegion

Function R4013B_StockReservationPlanning()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4013B_StockReservationPlanning
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	FALSE
		|	AND ItemList.StatusInfoPosting";

EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.DeliveryDate AS Period,
		|	ItemList.Order AS Basis,
		|	*
		|INTO R4034B_GoodsShipmentSchedule
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.isCanceled
		|	AND NOT ItemList.IsService
		|	AND NOT ItemList.DeliveryDate = DATETIME(1, 1, 1)
		|	AND ItemList.UseItemsShipmentScheduling
		|	AND ItemList.StatusInfoPosting";

EndFunction

#EndRegion
