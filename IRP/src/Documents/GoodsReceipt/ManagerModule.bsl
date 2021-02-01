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
	Tables.Insert("IncomingStocksReal"       , PostingServer.CreateTable(AccReg.R4035B_IncomingStocks));
	
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
	Query.Text = GetQueryText_ItemList();
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	PostingServer.UUIDToString(QueryTable);
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = GetQueryText_QueryTable();
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|    NOT tmp.UseSalesOrder
		|AND NOT tmp.UsePurchaseOrder
		|AND tmp.UseReceiptBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUseSO_NotUsePO(Tables, "tmp_1", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|        tmp.UseSalesOrder
		|AND NOT tmp.UsePurchaseOrder
		|AND tmp.UseReceiptBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_UseSO_NotUsePO(Tables, "tmp_2", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|     tmp.UseSalesOrder
		|AND  tmp.UsePurchaseOrder
		|AND tmp.UseReceiptBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_UseSO_UsePO(Tables, "tmp_3", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|NOT tmp.UseSalesOrder
		|AND tmp.UsePurchaseOrder
		|AND tmp.UseReceiptBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_NotUseSO_UsePO(Tables, "tmp_4", Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_5 FROM tmp AS tmp
		|WHERE
		|NOT tmp.UseReceiptBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_5").GetData().IsEmpty() Then
		GetTables_NotUseReceiptBasis(Tables, "tmp_5", Parameters);
	EndIf;
	
	Parameters.IsReposting = False;

	// legacy code fix
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
	If Tables.IncomingStocksReal.Count() Then
		Query.Text = 
		"SELECT
		|	IncomingStocksReal.Period,
		|	IncomingStocksReal.Store,
		|	IncomingStocksReal.ItemKey,
		|	IncomingStocksReal.Order,
		|	IncomingStocksReal.Quantity
		|INTO IncomingStocksReal
		|FROM
		|	&IncomingStocksReal AS IncomingStocksReal";
		Query.SetParameter("IncomingStocksReal", Tables.IncomingStocksReal);
		Query.Execute();
		
		IncomingStocksServer.ClosureIncomingStocks(Parameters);
	
		PostingServer.MergeTables(Tables.StockReservation_Expense, 
		PostingServer.GetQueryTableByName("FreeStocks", Parameters));		
	EndIf;
	Query.Text = "";
	If Not PostingServer.QueryTableIsExists("IncomingStocks", Parameters) Then
		Query.Text = Query.Text + "SELECT UNDEFINED INTO IncomingStocks WHERE FALSE; ";
	EndIf;	
	If Not PostingServer.QueryTableIsExists("IncomingStocksRequested", Parameters) Then
		Query.Text = Query.Text + 
		"SELECT 
		|	UNDEFINED AS RecordType,
		|	UNDEFINED AS Period,
		|	UNDEFINED AS IncomingStore,
		|	UNDEFINED AS RequesterStore,
		|	UNDEFINED AS ItemKey,
		|	UNDEFINED AS Order,
		|	UNDEFINED AS Requester,
		|	UNDEFINED AS Quantity
		|INTO IncomingStocksRequested 
		|WHERE FALSE; ";		
	EndIf;	
	If Not PostingServer.QueryTableIsExists("FreeStocks", Parameters) Then
		Query.Text = Query.Text + 
		"SELECT 
		|	UNDEFINED AS RecordType, 
		|	UNDEFINED AS Period, 
		|	UNDEFINED AS Store, 
		|	UNDEFINED AS ItemKey, 
		|	UNDEFINED AS Quantity
		|INTO FreeStocks 
		|WHERE FALSE; ";
	EndIf;	
	If ValueIsFilled(Query.Text) Then
		Query.Execute();
	EndIf;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Function GetQueryText_ItemList()
	Return 
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
		|	END AS UsePurchaseOrder,
		|	NOT GoodsReceiptItemList.ReceiptBasis.Ref IS NULL AS UseReceiptBasis
		|
		|FROM
		|	Document.GoodsReceipt.ItemList AS GoodsReceiptItemList
		|WHERE
		|	GoodsReceiptItemList.Ref = &Ref";
EndFunction	

Function GetQueryText_QueryTable()
	Return
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
		|   QueryTable.UsePurchaseOrder AS UsePurchaseOrder,
		|	QueryTable.UseReceiptBasis AS UseReceiptBasis
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable";
EndFunction	

#Region Table_tmp_1

Procedure GetTables_NotUseSO_NotUsePO(Tables, TableName, Parameters)
	// tmp_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSO_NotUsePO_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSO_NotUsePO_IsProduct(Tables, TableName, Parameters)
	// tmp_1_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;	
	Query.Text = GetQueryText_GetTables_NotUseSO_NotUsePO_IsProduct();			
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitIncoming   , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.GoodsReceiptSchedule     , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense     , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.IncomingStocksReal       , QueryResults[5].Unload());
EndProcedure

Function GetQueryText_GetTables_NotUseSO_NotUsePO_IsProduct()
	Return
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
	|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit
	|;
	|
	|//[5][IncomingStocksReal]
	|SELECT
	|	tmp.Period,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	PurchaseOrderItemList.Ref AS Order,
	|	tmp.Quantity
	|FROM
	|tmp AS tmp
	|	INNER JOIN Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|	ON CAST(tmp.ReceiptBasis AS Document.PurchaseInvoice) = PurchaseInvoiceItemList.Ref
	|		AND tmp.RowKey = PurchaseInvoiceItemList.Key
	|	INNER JOIN Document.PurchaseOrder.ItemList AS PurchaseOrderItemList
	|	ON (PurchaseInvoiceItemList.PurchaseOrder = PurchaseOrderItemList.Ref)
	|		AND (PurchaseInvoiceItemList.Key = PurchaseOrderItemList.Key)";
EndFunction		

#EndRegion

#Region Table_tmp_2

Procedure GetTables_UseSO_NotUsePO(Tables, TableName, Parameters)
	// tmp_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UseSO_NotUsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UseSO_NotUsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UseSO_NotUsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UseSO_NotUsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, TableName, Parameters)
	// tmp_2_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UseSO_NotUsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, TableName, Parameters)
	// tmp_2_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UseSO_NotUsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, TableName, Parameters)
	// tmp_2_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UseSO_UsePO(Tables, TableName, Parameters)
	// tmp_3
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UseSO_UsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UseSO_UsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
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
		GetTables_UseSO_UsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_UseSO_UsePO_NotUseSC_NotSCBeforeInvoice_IsProduct(Tables, TableName, Parameters)
	// tmp_3_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UseSO_UsePO_UseSC_SCBeforeInvoice_IsProduct(Tables, TableName, Parameters)
	// tmp_3_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_UseSO_UsePO_UseSC_NotSCBeforeInvoice_IsProduct(Tables, TableName, Parameters)
	// tmp_3_2
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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

Procedure GetTables_NotUseSO_UsePO(Tables, TableName, Parameters)
	// tmp_4
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSO_UsePO_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSO_UsePO_IsProduct(Tables, TableName, Parameters)
	// tmp_4_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
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
		|	CAST(tmp.ReceiptBasis AS Document.InventoryTransfer).StoreTransit
		|
		|;
		|//[7][IncomingStocksReal]
		|SELECT
		|	tmp.Period,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	PurchaseOrderItemList.Ref AS Order,
		|	tmp.Quantity
		|FROM
		|tmp AS tmp
		|	INNER JOIN Document.PurchaseOrder.ItemList AS PurchaseOrderItemList
		|	ON CAST(tmp.ReceiptBasis AS Document.PurchaseOrder) = PurchaseOrderItemList.Ref
		|		AND tmp.RowKey = PurchaseOrderItemList.Key";
		
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
	PostingServer.MergeTables(Tables.IncomingStocksReal       , QueryResults[7].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_5

Procedure GetTables_NotUseReceiptBasis(Tables, TableName, Parameters)
	// tmp_5
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseReceiptBasis_IsProduct(Tables, NewTableName, Parameters);
	EndIf;
EndProcedure

Procedure GetTables_NotUseReceiptBasis_IsProduct(Tables, TableName, Parameters)
	// tmp_5_1
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	
	#Region QueryText
	Query.Text = "
		|//[0] StockBalance_Receipt
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
		|//[1] StockReservation_Receipt
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
		|	tmp.Period";
		
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.StockBalance_Receipt     , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockReservation_Receipt , QueryResults[1].Unload());
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
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1011B_PurchaseOrdersReceipt());
	QueryArray.Add(R1031B_ReceiptInvoicing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4017B_InternalSupplyRequestProcurement());
	QueryArray.Add(R4021B_StockTransferOrdersReceipt());
	QueryArray.Add(R4031B_GoodsInTransitIncoming());
	QueryArray.Add(R4033B_GoodsReceiptSchedule());
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R4036B_IncomingStocksRequested());
	QueryArray.Add(R4012B_StockReservation());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ReceiptBasis AS ReceiptBasis,
		|	ItemList.Quantity AS UnitQuantity,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Unit,
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref AS GoodsReceipt,
		|	ItemList.Key AS RowKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	NOT ItemList.SalesOrder = Value(Document.SalesOrder.EmptyRef) AS SalesOrderExists,
		|	ItemList.SalesInvoice AS SalesInvoice,
		|	NOT ItemList.SalesInvoice = Value(Document.SalesInvoice.EmptyRef) AS SalesInvoiceExists,
		|	ItemList.PurchaseOrder AS PurchaseOrder,
		|	NOT ItemList.PurchaseOrder = Value(Document.PurchaseOrder.EmptyRef) AS PurchaseOrderExists,
		|	ItemList.PurchaseInvoice AS PurchaseInvoice,
		|	NOT ItemList.PurchaseInvoice = Value(Document.PurchaseInvoice.EmptyRef) AS PurchaseInvoiceExists,
		|	ItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	NOT ItemList.InternalSupplyRequest = Value(Document.InternalSupplyRequest.EmptyRef) AS InternalSupplyRequestExists,
		|	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		|	NOT ItemList.InventoryTransferOrder = Value(Document.InventoryTransferOrder.EmptyRef) AS InventoryTransferOrderExists,
		|	ItemList.InventoryTransfer AS InventoryTransfer,
		|	NOT ItemList.InventoryTransfer = Value(Document.InventoryTransfer.EmptyRef) AS InventoryTransferExists,
		|	ItemList.SalesReturn AS SalesReturn,
		|	NOT ItemList.SalesReturn = Value(Document.SalesReturn.EmptyRef) AS SalesReturnExists,
		|	ItemList.SalesReturnOrder AS SalesReturnOrder,
		|	NOT ItemList.SalesReturnOrder = Value(Document.SalesReturnOrder.EmptyRef) AS SalesReturnOrderExists
		|INTO ItemList
		|FROM
		|	Document.GoodsReceipt.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function R1011B_PurchaseOrdersReceipt()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.PurchaseOrder AS Order,
		|	*
		|INTO R1011B_PurchaseOrdersReceipt
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.PurchaseOrderExists";
EndFunction

Function R1031B_ReceiptInvoicing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.GoodsReceipt AS Basis,
		|	QueryTable.Quantity AS Quantity,
		|	QueryTable.Company,
		|	QueryTable.Period,
		|	QueryTable.ItemKey
		|INTO R1031B_ReceiptInvoicing
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.PurchaseInvoiceExists
		|
		|UNION ALL
		|
		|SELECT 
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.PurchaseInvoice,
		|	QueryTable.Quantity,
		|	QueryTable.Company,
		|	QueryTable.Period,
		|	QueryTable.ItemKey
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.PurchaseInvoiceExists";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	QueryTable.Quantity AS ReceiptQuantity,
		|	QueryTable.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS QueryTable
		|WHERE
		|	QueryTable.SalesOrderExists";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.Period AS Period,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.Quantity AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS QueryTable
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
		|	FreeStocks AS FreeStocks";
EndFunction

Function R4017B_InternalSupplyRequestProcurement()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4017B_InternalSupplyRequestProcurement
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.InternalSupplyRequestExists";
EndFunction

Function R4021B_StockTransferOrdersReceipt()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.InventoryTransferOrder AS Order,
		|	*
		|INTO R4021B_StockTransferOrdersReceipt
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.InventoryTransferOrderExists";
EndFunction

Function R4031B_GoodsInTransitIncoming()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.InventoryTransfer AS Basis,
		|	*
		|INTO R4031B_GoodsInTransitIncoming
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.InventoryTransferExists";
EndFunction

Function R4033B_GoodsReceiptSchedule()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.PurchaseOrder AS Basis,
		|	*
		|INTO R4033B_GoodsReceiptSchedule
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.PurchaseOrderExists
		|	AND QueryTable.PurchaseOrder.UseItemsReceiptScheduling";
EndFunction

Function R4035B_IncomingStocks()
	Return
		"SELECT *
		|INTO R4035B_IncomingStocks
		|FROM 
		|	IncomingStocks AS IncomingStocks";
EndFunction

Function R4036B_IncomingStocksRequested()
	Return
		"SELECT *
		|INTO R4036B_IncomingStocksRequested
		|FROM
		|	IncomingStocksRequested AS IncomingStocksRequested";
EndFunction	

Function R4012B_StockReservation()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	IncomingStocksRequested.IncomingStore AS Store,
		|	IncomingStocksRequested.Requester AS Order,
		|*
		|INTO R4012B_StockReservation
		|FROM 
		|	IncomingStocksRequested AS IncomingStocksRequested";		
EndFunction

#EndRegion
