#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("GoodsInTransitOutgoing", PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance", PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ShipmentOrders", PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("ShipmentConfirmationSchedule", PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("InventoryBalance", PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("StockReservation", PostingServer.CreateTable(AccReg.StockReservation));
	
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
		|	SUM(ShipmentConfirmationItemList.Quantity) AS Quantity,
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
		|	ShipmentConfirmationItemList.Ref = &Ref
		|GROUP BY
		|	ShipmentConfirmationItemList.Ref.Company,
		|	ShipmentConfirmationItemList.Store,
		|	ShipmentConfirmationItemList.ItemKey,
		|	ShipmentConfirmationItemList.ShipmentBasis,
		|	ShipmentConfirmationItemList.ShipmentBasis REFS Document.SalesOrder
		|	AND
		|	NOT CAST(ShipmentConfirmationItemList.ShipmentBasis AS Document.SalesOrder).Date IS NULL,
		|	CASE
		|		WHEN ShipmentConfirmationItemList.ShipmentBasis REFS Document.SalesOrder
		|		AND
		|		NOT CAST(ShipmentConfirmationItemList.ShipmentBasis AS Document.SalesOrder).Date IS NULL
		|			THEN CAST(ShipmentConfirmationItemList.ShipmentBasis AS
		|				Document.SalesOrder).ShipmentConfirmationsBeforeSalesInvoice
		|		ELSE FALSE
		|	END,
		|	ShipmentConfirmationItemList.Ref,
		|	ShipmentConfirmationItemList.Unit,
		|	ShipmentConfirmationItemList.ItemKey.Item.Unit,
		|	ShipmentConfirmationItemList.ItemKey.Unit,
		|	ShipmentConfirmationItemList.ItemKey.Item,
		|	ShipmentConfirmationItemList.Ref.Date,
		|	VALUE(Catalog.Units.EmptyRef),
		|	ShipmentConfirmationItemList.Key,
		|	CASE
		|		WHEN ShipmentConfirmationItemList.ShipmentBasis.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	// UUID to String
	QueryTable.Columns.Add("RowKey", Metadata.AccumulationRegisters.ShipmentConfirmationSchedule.Dimensions.RowKey.Type);
	For Each Row In QueryTable Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
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
		GetTables_NotUseSalesOrder(Tables, TempManager, "tmp_1");
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
		GetTables_UseSalesOrder_NotShipmentBeforeInvoice(Tables, TempManager, "tmp_2");
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
		GetTables_UseSalesOrder_ShipmentBeforeInvoice(Tables, TempManager, "tmp_3");
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text =
		"SELECT * INTO tmp_4 FROM tmp AS tmp
		|WHERE
		|   NOT tmp.UseShipmentBasis";
	
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find("tmp_4").GetData().IsEmpty() Then
		GetTables_NotUseShipmentBasis(Tables, TempManager, "tmp_4");
	EndIf;
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

#Region Table_tmp_1

Procedure GetTables_NotUseSalesOrder(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseSalesOrder_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseSalesOrder_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] StockBalance
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
		|//[2] ShipmentConfirmationSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|       AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|GROUP BY
		|	tmp.Company,
		|	tmp.ShipmentBasis,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule, QueryResults[2].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_2

Procedure GetTables_UseSalesOrder_NotShipmentBeforeInvoice(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSalesOrder_NotShipmentBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_UseSalesOrder_NotShipmentBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] StockBalance
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
		|//[2] ShipmentOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.ShipmentConfirmation AS ShipmentConfirmation,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.ShipmentConfirmation,
		|	tmp.Period,
		|   tmp.RowKey
		|;
		|
		|//[3] ShipmentConfirmationSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|       AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|GROUP BY
		|	tmp.Company,
		|	tmp.ShipmentBasis,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule, QueryResults[3].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_3

Procedure GetTables_UseSalesOrder_ShipmentBeforeInvoice(Tables, TempManager, TableName)

	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_UseSalesOrder_ShipmentBeforeInvoice_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
	
EndProcedure

Procedure GetTables_UseSalesOrder_ShipmentBeforeInvoice_IsProduct(Tables, TempManager, TableName)
	
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] StockBalance
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
		|//[2] ShipmentOrders
		|SELECT
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.ShipmentConfirmation AS ShipmentConfirmation,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.ShipmentBasis,
		|	tmp.ShipmentConfirmation,
		|	tmp.Period,
		|   tmp.RowKey
		|;
		|
		|//[3] ShipmentConfirmationSchedule
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.ShipmentBasis AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
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
		|       AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|GROUP BY
		|	tmp.Company,
		|	tmp.ShipmentBasis,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|//[4] InventoryBalance
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
		|	tmp.Period";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.ShipmentOrders, QueryResults[2].Unload());
	PostingServer.MergeTables(Tables.ShipmentConfirmationSchedule, QueryResults[3].Unload());
	PostingServer.MergeTables(Tables.InventoryBalance, QueryResults[4].Unload());
EndProcedure

#EndRegion

#Region Table_tmp_4

Procedure GetTables_NotUseShipmentBasis(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	Query.Text = "SELECT * INTO tmp_1 FROM source AS tmp";
	NewTableName = StrReplace("tmp_1", "tmp", TableName);
	Query.Text = StrReplace(Query.Text, "tmp_1", NewTableName);
	Query.Text = StrReplace(Query.Text, "source", TableName);
	Query.Execute();
	If Not Query.TempTablesManager.Tables.Find(NewTableName).GetData().IsEmpty() Then
		GetTables_NotUseShipmentBasis_IsProduct(Tables, TempManager, NewTableName);
	EndIf;
EndProcedure

Procedure GetTables_NotUseShipmentBasis_IsProduct(Tables, TempManager, TableName)
	Query = New Query();
	Query.TempTablesManager = TempManager;
	
	#Region QueryText
	Query.Text =
		"//[0] GoodsInTransitOutgoing
		|SELECT
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentConfirmation AS ShipmentBasis,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.ShipmentConfirmation,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|//[1] StockBalance
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
		|//[2] StockReservation
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
		|	tmp.Period";
	
	Query.Text = StrReplace(Query.Text, "tmp", TableName);
	#EndRegion
	
	QueryResults = Query.ExecuteBatch();
	
	PostingServer.MergeTables(Tables.GoodsInTransitOutgoing, QueryResults[0].Unload());
	PostingServer.MergeTables(Tables.StockBalance, QueryResults[1].Unload());
	PostingServer.MergeTables(Tables.StockReservation, QueryResults[2].Unload());
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
	AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
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
	Return;
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
			Parameters.IsReposting));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	If Not CheckGoodsInTransitOutgoingBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

Function CheckGoodsInTransitOutgoingBalance(Ref, Parameters, AddInfo = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	GoodsInTransitOutgoingBalance.ItemKey.Item AS Item,
	|	GoodsInTransitOutgoingBalance.ItemKey AS ItemKey,
	|	GoodsInTransitOutgoingBalance.ShipmentBasis,
	|	SUM(GoodsInTransitOutgoingBalance.QuantityBalance) AS QuantityBalance,
	|	SUM(ShipmentConfirmationItemList.Quantity) AS Quantity,
	|	-SUM(GoodsInTransitOutgoingBalance.QuantityBalance) AS LackOfBalance,
	|	ShipmentConfirmationItemList.LineNumber AS LineNumber,
	|	0 AS BasisQuantity,
	|	ShipmentConfirmationItemList.Unit AS Unit,
	|	ShipmentConfirmationItemList.ItemKey.Item.Unit AS ItemUnit,
	|	ShipmentConfirmationItemList.ItemKey.Unit AS ItemKeyUnit,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS ShipmentConfirmationItemList
	|		INNER JOIN AccumulationRegister.GoodsInTransitOutgoing.Balance(, (Store, ShipmentBasis, ItemKey) IN
	|			(SELECT
	|				ShipmentConfirmationItemList.Store AS Store,
	|				ShipmentConfirmationItemList.ShipmentBasis AS ShipmentBasis,
	|				ShipmentConfirmationItemList.ItemKey AS ItemKey
	|			FROM
	|				Document.ShipmentConfirmation.ItemList AS ShipmentConfirmationItemList
	|			WHERE
	|				ShipmentConfirmationItemList.Ref = &Ref
	|				AND
	|				NOT ShipmentConfirmationItemList.ShipmentBasis.Date IS NULL)) AS GoodsInTransitOutgoingBalance
	|		ON GoodsInTransitOutgoingBalance.Store = ShipmentConfirmationItemList.Store
	|		AND GoodsInTransitOutgoingBalance.ShipmentBasis = ShipmentConfirmationItemList.ShipmentBasis
	|		AND GoodsInTransitOutgoingBalance.ItemKey = ShipmentConfirmationItemList.ItemKey
	|WHERE
	|	ShipmentConfirmationItemList.Ref = &Ref
	|	AND
	|	NOT ShipmentConfirmationItemList.ShipmentBasis.Date IS NULL
	|GROUP BY
	|	GoodsInTransitOutgoingBalance.ItemKey.Item,
	|	GoodsInTransitOutgoingBalance.ItemKey,
	|	ShipmentConfirmationItemList.LineNumber,
	|	GoodsInTransitOutgoingBalance.ShipmentBasis,
	|	ShipmentConfirmationItemList.Unit,
	|	ShipmentConfirmationItemList.ItemKey.Item.Unit,
	|	ShipmentConfirmationItemList.ItemKey.Unit,
	|	VALUE(Catalog.Units.EmptyRef)
	|HAVING
	|	SUM(GoodsInTransitOutgoingBalance.QuantityBalance) < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	HaveError = False;
	If QueryTable.Count() Then
		HaveError = True;
		
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "ShipmentBasis, ItemKey, Item, BasisUnit, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "BasisQuantity");
		ErrorParameters.Insert("FilterColumns", "ShipmentBasis, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Invoiced");
		ErrorParameters.Insert("Excess", False);
		
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not HaveError;
EndFunction
