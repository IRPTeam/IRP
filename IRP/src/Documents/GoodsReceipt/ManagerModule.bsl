#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("GoodsInTransitIncoming"   , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("StockBalance_Receipt"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Expense"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation_Receipt" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Expense" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("ReceiptOrders"            , PostingServer.CreateTable(AccReg.ReceiptOrders));
	Tables.Insert("GoodsReceiptSchedule"     , PostingServer.CreateTable(AccReg.GoodsReceiptSchedule));
	Tables.Insert("GoodsInTransitOutgoing"   , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("InventoryBalance"         , PostingServer.CreateTable(AccReg.InventoryBalance));
	
	Tables.Insert("GoodsInTransitIncoming_Exists", PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("GoodsInTransitOutgoing_Exists", PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("ReceiptOrders_Exists"         , PostingServer.CreateTable(AccReg.ReceiptOrders));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	
	Tables.GoodsInTransitIncoming_Exists = 
	AccumulationRegisters.GoodsInTransitIncoming.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo); 
	
	Tables.GoodsInTransitOutgoing_Exists = 
	AccumulationRegisters.GoodsInTransitOutgoing.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo); 
	
	Tables.ReceiptOrders_Exists = 
	AccumulationRegisters.ReceiptOrders.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	GoodsReceiptItemList.Ref.Company AS Company,
		|	GoodsReceiptItemList.Store AS Store,
		|	GoodsReceiptItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	CASE
		|		WHEN NOT GoodsReceiptItemList.SalesOrder.Date IS NULL
		|			THEN GoodsReceiptItemList.SalesOrder.ShipmentConfirmationsBeforeSalesInvoice
		|		ELSE FALSE
		|	END AS ShipmentBeforeInvoice,
		|	GoodsReceiptItemList.ItemKey AS ItemKey,
		|	GoodsReceiptItemList.ReceiptBasis AS ReceiptBasis,
		|	GoodsReceiptItemList.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	GoodsReceiptItemList.Unit,
		|	GoodsReceiptItemList.ItemKey.Item.Unit AS ItemUnit,
		|	GoodsReceiptItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	GoodsReceiptItemList.ItemKey.Item AS Item,
		|	GoodsReceiptItemList.Ref.Date AS Period,
		|	GoodsReceiptItemList.Ref AS GoodsReceipt,
		|	GoodsReceiptItemList.Key AS RowKeyUUID,
		|	GoodsReceiptItemList.SalesOrder AS SalesOrder,
		|	CASE
		|		WHEN GoodsReceiptItemList.SalesOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS UseSalesOrder,
		|	CASE
		|		WHEN GoodsReceiptItemList.ReceiptBasis REFS Document.PurchaseOrder
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS UsePurchaseOrder
		|FROM
		|	Document.GoodsReceipt.ItemList AS GoodsReceiptItemList
		|WHERE
		|	GoodsReceiptItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
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
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.GoodsReceipt AS GoodsReceipt,
		|   QueryTable.RowKey AS RowKey,
		|   QueryTable.SalesOrder AS SalesOrder,
		|   QueryTable.UseSalesOrder AS UseSalesOrder,
		|	QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	QueryTable.ShipmentBeforeInvoice AS ShipmentBeforeInvoice,
		|   QueryTable.UsePurchaseOrder AS UsePurchaseOrder
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable";
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UseSalesOrder
		|AND NOT tmp.UsePurchaseOrder";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUseSO_NotUsePO(Tables, TempManager, "tmp_1");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|        tmp.UseSalesOrder
		|AND NOT tmp.UsePurchaseOrder";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_UseSO_NotUsePO(Tables, TempManager, "tmp_2");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|     tmp.UseSalesOrder
		|AND  tmp.UsePurchaseOrder";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_UseSO_UsePO(Tables, TempManager, "tmp_3");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|NOT tmp.UseSalesOrder
		|AND tmp.UsePurchaseOrder";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_NotUseSO_UsePO(Tables, TempManager, "tmp_4");
	EndIf;
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

#Region Table_tmp_1

Procedure GetTables_NotUseSO_NotUsePO(Tables, TempManager, TableName)
	// tmp_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSO_NotUsePO_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSO_NotUsePO_IsProduct(Tables, TempManager, TableName)
	// tmp_1_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = 
	"//[0] - GoodsInTransitIncoming
	|SELECT
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.ReceiptBasis,
	|	tmp.Quantity AS Quantity,
	|	tmp.Unit AS Unit,
	|	tmp.Period,
	|	tmp.RowKey
	|FROM
	|	tmp AS tmp
	|;
	|//[1] - StockBalance_Receipt
	|SELECT
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.ReceiptBasis,
	|	SUM(tmp.Quantity) AS Quantity,
	|	tmp.Unit AS Unit,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.ReceiptBasis,
	|	tmp.Unit,
	|	tmp.Period
	|;
	|//[2] - StockReservation_Receipt
	|SELECT
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.ReceiptBasis,
	|	SUM(tmp.Quantity) AS Quantity,
	|	tmp.Unit AS Unit,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.ReceiptBasis,
	|	tmp.Unit,
	|	tmp.Period
	|;
	|//[3] - GoodsReceiptSchedule
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.ReceiptBasis AS Order,
	|	tmp.Store AS Store,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.RowKey AS RowKey,
	|	tmp.Quantity AS Quantity,
	|	tmp.Period,
	|	tmp.Period AS DeliveryDate
	|FROM
	|	tmp AS tmp
	|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
	|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
	|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
	|		AND GoodsReceiptSchedule.Company = tmp.Company
	|		AND GoodsReceiptSchedule.Store = tmp.Store
	|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
	|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
	|;
	|//[4] - StockBalance_Expense
	|SELECT
	|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
	|	tmp.ItemKey,
	|	SUM(tmp.Quantity) AS Quantity,
	|	tmp.Period
	|FROM
	|	tmp AS tmp
	|WHERE
	|	tmp.ReceiptBasis REFS Document.InventoryTransfer
	|	AND
	|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
	|	AND CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
	|GROUP BY
	|	tmp.ItemKey,
	|	tmp.Period,
	|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit";
		
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[4].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_2

Procedure GetTables_UseSO_NotUsePO(Tables, TempManager, TableName)
	// tmp_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE 
		|	    NOT tmp.UseShipmentConfirmation
		|	AND NOT tmp.ShipmentBeforeInvoice";
	
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_NotUsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE 
		|	    tmp.UseShipmentConfirmation
		|	AND tmp.ShipmentBeforeInvoice";
	
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_NotUsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE 
		|	        tmp.UseShipmentConfirmation
		|	AND NOT tmp.ShipmentBeforeInvoice";
	
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_NotUsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseSO_NotUsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	// tmp_2_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[4] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[5] - StockBalance_Expense
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit";
		
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[5].Unload());
EndProcedure

Procedure GetTables_UseSO_NotUsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	// tmp_2_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[4] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[5] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.SalesOrder AS ShipmentBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period, 
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[6] - StockBalance_Expense
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit
		|";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing   , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[6].Unload());
EndProcedure

Procedure GetTables_UseSO_NotUsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	// tmp_2_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[4] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[5] - StockBalance_Expense
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit
		|";
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[5].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_3

Procedure GetTables_UseSO_UsePO(Tables, TempManager, TableName)
	// tmp_3
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp
		|WHERE
		|	    NOT tmp.UseShipmentConfirmation
		|	AND NOT tmp.ShipmentBeforeInvoice";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_UsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM source AS tmp
		|WHERE
		|	    tmp.UseShipmentConfirmation
		|	AND tmp.ShipmentBeforeInvoice";
	NewTableName = StrReplace("tmp_2", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_2", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_UsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM source AS tmp
		|WHERE
		|	        tmp.UseShipmentConfirmation
		|	AND NOT tmp.ShipmentBeforeInvoice";
	NewTableName = StrReplace("tmp_3", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_3", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_UsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseSO_UsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	// tmp_3_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[4] ReceiptOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.GoodsReceipt AS GoodsReceipt,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[5] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[6] InventoryBalance
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
		|//[7] - StockBalance_Expense
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.ReceiptOrders            , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance         , QueryResults[6].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[7].Unload());
EndProcedure

Procedure GetTables_UseSO_UsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	// tmp_3_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[4] ReceiptOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.GoodsReceipt AS GoodsReceipt,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[5] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[6] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.SalesOrder AS ShipmentBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period, 
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[7] InventoryBalance
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
		|//[8] - StockBalance_Expense
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.ReceiptOrders            , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing   , QueryResults[6].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance         , QueryResults[7].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[8].Unload());
EndProcedure

Procedure GetTables_UseSO_UsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	// tmp_3_2
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] StockReservation_Expense
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[4] ReceiptOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.GoodsReceipt AS GoodsReceipt,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[5] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[6] InventoryBalance
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
		|//[7] - StockBalance_Expense /////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Expense , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.ReceiptOrders            , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance         , QueryResults[6].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[7].Unload());
EndProcedure
	
#EndRegion

#Region Table_tmp_4

Procedure GetTables_NotUseSO_UsePO(Tables, TempManager, TableName)
	// tmp_4
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSO_UsePO_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSO_UsePO_IsProduct(Tables, TempManager, TableName)
	// tmp_4_1
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text = "
		// [0] GoodsInTransitIncoming
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] StockBalance
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|//[2] StockReservation_Receipt
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3] ReceiptOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.GoodsReceipt AS GoodsReceipt,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|//[4] GoodsReceiptSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ReceiptBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
		|		ON GoodsReceiptSchedule.Recorder = tmp.ReceiptBasis
		|		AND GoodsReceiptSchedule.RowKey = tmp.RowKey
		|		AND GoodsReceiptSchedule.Company = tmp.Company
		|		AND GoodsReceiptSchedule.Store = tmp.Store
		|		AND GoodsReceiptSchedule.ItemKey = tmp.ItemKey
		|       AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|//[5] InventoryBalance
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
		|//[6] - StockBalance_Expense
		|SELECT
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ReceiptBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ReceiptOrders            , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance         , QueryResults[5].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[6].Unload());
EndProcedure

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// GoodsInTransitIncoming
	GoodsInTransitIncoming = 
	AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
	
	// StockBalance
	ArrayOfTables = New Array();
	ArrayOfTables.Add(DocumentDataTables.StockBalance_Expense);
	ArrayOfTables.Add(DocumentDataTables.StockBalance_Receipt);
		
	StockBalance = 
	AccumulationRegisters.StockBalance.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// StockReservation
	ArrayOfTables = New Array();
	ArrayOfTables.Add(DocumentDataTables.StockReservation_Expense);
	ArrayOfTables.Add(DocumentDataTables.StockReservation_Receipt);
	
	StockReservation = 
	AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// ReceiptOrders
	ReceiptOrders = 
	AccumulationRegisters.ReceiptOrders.GetLockFields(DocumentDataTables.ReceiptOrders);
	DataMapWithLockFields.Insert(ReceiptOrders.RegisterName, ReceiptOrders.LockInfo);
	
	// GoodsReceiptSchedule
	GoodsReceiptSchedule = 
	AccumulationRegisters.GoodsReceiptSchedule.GetLockFields(DocumentDataTables.GoodsReceiptSchedule);
	DataMapWithLockFields.Insert(GoodsReceiptSchedule.RegisterName, GoodsReceiptSchedule.LockInfo);
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = 
	AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// InventoryBalance
	InventoryBalance = 
	AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// GoodsInTransitIncoming
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.GoodsInTransitIncoming,
			True));
	
	// StockBalance
	// StockBalance_Receipt [Receipt]  
	// StockBalance_Expense [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockBalance_Receipt.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Store, ItemKey, Quantity"), 
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
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsReceiptSchedule,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.GoodsReceiptSchedule,
			Parameters.IsReposting));
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing,
			True));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.InventoryBalance,
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
	
	// GoodsInTransitIncoming
	GoodsInTransitIncoming = AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// ReceiptOrders
	ReceiptOrders = AccumulationRegisters.ReceiptOrders.GetLockFields(DocumentDataTables.ReceiptOrders_Exists);
	DataMapWithLockFields.Insert(ReceiptOrders.RegisterName, ReceiptOrders.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Exists);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// StockBalance
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Exists);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
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
	
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.GoodsReceipt.ItemList", AddInfo);
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.GoodsReceipt.ItemList");
	If Not Cancel And Not AccReg.GoodsInTransitIncoming.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitIncoming_Exists,
	                                                                 AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And Not AccReg.GoodsInTransitOutgoing.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists,
	                                                                 AccumulationRecordType.Receipt, Unposting, AddInfo) Then
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

