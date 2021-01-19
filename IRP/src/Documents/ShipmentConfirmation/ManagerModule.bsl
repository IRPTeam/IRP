#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("GoodsInTransitOutgoing"       , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance_Expense"         , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Receipt"         , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ShipmentOrders"               , PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("ShipmentConfirmationSchedule" , PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("InventoryBalance"             , PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("StockReservation"             , PostingServer.CreateTable(AccReg.StockReservation));
	
	Tables.Insert("GoodsInTransitOutgoing_Exists" , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("ShipmentOrders_Exists"         , PostingServer.CreateTable(AccReg.ShipmentOrders));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.GoodsInTransitOutgoing_Exists = 
	AccumulationRegisters.GoodsInTransitOutgoing.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.ShipmentOrders_Exists = 
	AccumulationRegisters.ShipmentOrders.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ShipmentConfirmationItemList.Ref.Company AS Company,
		|	ShipmentConfirmationItemList.Store AS Store,
		|	ShipmentConfirmationItemList.ItemKey AS ItemKey,
		|	ShipmentConfirmationItemList.ShipmentBasis AS ShipmentBasis,
		|	ShipmentConfirmationItemList.ShipmentBasis REFS Document.SalesOrder
		|	AND
		|	NOT CAST(ShipmentConfirmationItemList.ShipmentBasis AS Document.SalesOrder).Date IS NULL AS UseSalesOrder,
		|	CASE
		|		WHEN ShipmentConfirmationItemList.ShipmentBasis REFS Document.SalesOrder
		|		AND
		|		NOT CAST(ShipmentConfirmationItemList.ShipmentBasis AS Document.SalesOrder).Date IS NULL
		|			THEN CAST(ShipmentConfirmationItemList.ShipmentBasis AS
		|				Document.SalesOrder).ShipmentConfirmationsBeforeSalesInvoice
		|		ELSE FALSE
		|	END AS ShipmentBeforeInvoice,
		|	CASE
		|		WHEN ShipmentConfirmationItemList.ShipmentBasis.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS UseShipmentBasis,
		|	ShipmentConfirmationItemList.Ref AS ShipmentConfirmation,
		|	ShipmentConfirmationItemList.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	ShipmentConfirmationItemList.Unit,
		|	ShipmentConfirmationItemList.ItemKey.Item.Unit AS ItemUnit,
		|	ShipmentConfirmationItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	ShipmentConfirmationItemList.ItemKey.Item AS Item,
		|	ShipmentConfirmationItemList.Ref.Date AS Period,
		|	ShipmentConfirmationItemList.Key AS RowKeyUUID
		|FROM
		|	Document.ShipmentConfirmation.ItemList AS ShipmentConfirmationItemList
		|WHERE
		|	ShipmentConfirmationItemList.Ref = &Ref";
	
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
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|	QueryTable.UseSalesOrder AS UseSalesOrder,
		|	QueryTable.ShipmentBeforeInvoice AS ShipmentBeforeInvoice,
		|	QueryTable.ShipmentConfirmation AS ShipmentConfirmation,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.UseShipmentBasis AS UseShipmentBasis
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|";
	Query.SetParameter("QueryTable", QueryTable);
	Query.Execute();
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_1 FROM tmp AS tmp
		|WHERE
		|   NOT tmp.UseSalesOrder
		|   AND tmp.UseShipmentBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_1").GetData().IsEmpty() Then
		GetTables_NotUseSO(Tables, TempManager, "tmp_1");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_2 FROM tmp AS tmp
		|WHERE
		|           tmp.UseSalesOrder
		|   AND     tmp.UseShipmentBasis
		|   AND NOT tmp.ShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_2").GetData().IsEmpty() Then
		GetTables_UseSO_NotSCBeforeInvoice(Tables, TempManager, "tmp_2");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_3 FROM tmp AS tmp
		|WHERE
		|       tmp.UseSalesOrder
		|   AND tmp.UseShipmentBasis
		|   AND tmp.ShipmentBeforeInvoice";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_3").GetData().IsEmpty() Then
		GetTables_UseSO_SCBeforeInvoice(Tables, TempManager, "tmp_3");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|   NOT tmp.UseShipmentBasis";
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_NotUseSCBasis(Tables, TempManager, "tmp_4");
	EndIf;
	
	Parameters.IsReposting = False;
	
#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExequteQuery(Ref, QueryArray, Parameters);
#EndRegion
	
	Return Tables;
EndFunction

#Region Table_tmp_1

Procedure GetTables_NotUseSO(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSO_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSO_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] - GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] - StockBalance_Expense
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
		|//[2] - ShipmentConfirmationSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.ShipmentBasis
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[3] - StockBalance_Receipt
		|SELECT
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ShipmentBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing       , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt         , QueryResults[3].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_2

Procedure GetTables_UseSO_NotSCBeforeInvoice(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_NotSCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseSO_NotSCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] - GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] - StockBalance_Expense
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
		|//[2] - ShipmentOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.ShipmentConfirmation AS ShipmentConfirmation,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[3] - ShipmentConfirmationSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.ShipmentBasis
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[4] - StockBalance_Receipt
		|SELECT
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ShipmentBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing       , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders               , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt         , QueryResults[4].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_3

Procedure GetTables_UseSO_SCBeforeInvoice(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSO_SCBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseSO_SCBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] - GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] - StockBalance_Expense
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
		|//[2] - ShipmentOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.ShipmentConfirmation AS ShipmentConfirmation,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[3] - ShipmentConfirmationSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.ShipmentBasis
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|;
		|
		|//[4] - InventoryBalance
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
		|//[5] - StockBalance_Receipt
		|SELECT
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ShipmentBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing       , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense         , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders               , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule , QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance             , QueryResults[4].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt         , QueryResults[5].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_4

Procedure GetTables_NotUseSCBasis(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSCBasis_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSCBasis_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] - GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentConfirmation AS ShipmentBasis,
		|	tmp.Quantity AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[1] - StockBalance_Expense
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
		|//[2] - StockReservation
		|SELECT
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
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
		|//[3] - StockBalance_Receipt
		|SELECT
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ShipmentBasis REFS Document.InventoryTransfer
		|	AND
		|	NOT CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).Date IS NULL
		|	AND CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Period,
		|	CAST(tmp.ShipmentBasis AS Document.InventoryTransfer).StoreTransit";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing , QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Expense   , QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation       , QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.StockBalance_Receipt   , QueryResults[3].Unload());
EndProcedure

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = 
	AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// StockBalance
	StockBalance = 
	AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Expense);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = 
	AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
	// ShipmentConfirmationSchedule
	ShipmentConfirmationSchedule = 
	AccumulationRegisters.ShipmentConfirmationSchedule.GetLockFields(DocumentDataTables.ShipmentConfirmationSchedule);
	DataMapWithLockFields.Insert(ShipmentConfirmationSchedule.RegisterName, ShipmentConfirmationSchedule.LockInfo);
	
	// InventoryBalance
	InventoryBalance = 
	AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// StockReservation
	StockReservation = 
	AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
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
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing,
			True));
	
	// StockBalance
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
		
	Table2 = Parameters.DocumentDataTables.StockBalance_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
		
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
			True));

	// ShipmentOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentOrders,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ShipmentOrders,
			True));
	
	// ShipmentConfirmationSchedule
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentConfirmationSchedule,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ShipmentConfirmationSchedule,
			Parameters.IsReposting));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.InventoryBalance,
			Parameters.IsReposting));
	
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
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
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders_Exists);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
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
	
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.ShipmentConfirmation.ItemList", AddInfo);
		
	LineNumberAndRowKeyFromItemList = PostingServer.GetLineNumberAndRowKeyFromItemList(Ref, "Document.ShipmentConfirmation.ItemList");
	If Not Cancel And Not AccReg.GoodsInTransitOutgoing.CheckBalance(Ref, LineNumberAndRowKeyFromItemList,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing,
	                                                                 Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists,
	                                                                 AccumulationRecordType.Expense, Unposting, AddInfo) Then
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

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4022B_StockTransferOrdersShipment());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	Return QueryArray;	
EndFunction	

Function ItemList()
	Return
		"SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Ref AS ShipmentConfirmation,
		|	ItemList.Quantity AS UnitQuantity,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Unit,
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	NOT ItemList.SalesOrder = Value(Document.SalesOrder.EmptyRef) AS SalesOrderExists,
		|	ItemList.SalesInvoice AS SalesInvoice,
		|	NOT ItemList.SalesInvoice = Value(Document.SalesInvoice.EmptyRef) AS SalesInvoiceExists,
		|	ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,
		|	NOT ItemList.PurchaseReturnOrder = Value(Document.PurchaseReturnOrder.EmptyRef) AS PurchaseReturnOrderExists,
		|	ItemList.PurchaseReturn AS PurchaseReturn,
		|	NOT ItemList.PurchaseReturn = Value(Document.PurchaseReturn.EmptyRef) AS PurchaseReturnExists,
		|	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
		|	NOT ItemList.InventoryTransferOrder = Value(Document.InventoryTransferOrder.EmptyRef) AS InventoryTransferOrderExists,
		|	ItemList.InventoryTransfer AS InventoryTransfer,
		|	NOT ItemList.InventoryTransfer = Value(Document.InventoryTransfer.EmptyRef) AS InventoryTransferExists
		|INTO ItemList
		|FROM
		|	Document.ShipmentConfirmation.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function R2011B_SalesOrdersShipment()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.SalesOrder AS Order,
		|	*
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.SalesOrderExists";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	QueryTable.Quantity AS ShippedQuantity,
		|	QueryTable.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS QueryTable
		|WHERE
		|	QueryTable.SalesOrderExists";

EndFunction

Function R2031B_ShipmentInvoicing()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	QueryTable.ShipmentConfirmation AS Basis,
		|	QueryTable.Quantity AS Quantity,
		|	QueryTable.Company,
		|	QueryTable.Period,
		|	QueryTable.ItemKey
		|INTO R1031B_ReceiptInvoicing
		|FROM
		|	ItemList AS QueryTable
		|WHERE NOT QueryTable.SalesInvoiceExists
		|
		|UNION ALL
		|
		|SELECT 
		|	VALUE(AccumulationRecordType.Expense),
		|	QueryTable.SalesInvoice,
		|	QueryTable.Quantity,
		|	QueryTable.Company,
		|	QueryTable.Period,
		|	QueryTable.ItemKey
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.SalesInvoiceExists";

EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE TRUE";

EndFunction

Function R4022B_StockTransferOrdersShipment()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.InventoryTransferOrder AS Order,
		|	*
		|INTO R4022B_StockTransferOrdersShipment
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.InventoryTransferOrderExists";

EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	QueryTable.SalesOrder AS Basis,
		|	*
		|INTO R4034B_GoodsShipmentSchedule
		|FROM
		|	ItemList AS QueryTable
		|WHERE QueryTable.SalesOrderExists
		|	AND QueryTable.SalesOrder.UseItemsShipmentScheduling";

EndFunction

#EndRegion
