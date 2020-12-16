#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance"      , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation"  , PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("StockReservation"  , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("PurchaseTurnovers" , PostingServer.CreateTable(AccReg.PurchaseTurnovers));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If Not StatusInfo.Posting Then
		Return Tables;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	PurchaseReturnOrderItemList.Ref.Company AS Company,
		|	PurchaseReturnOrderItemList.Store AS Store,
		|	PurchaseReturnOrderItemList.Ref AS Order,
		|	PurchaseReturnOrderItemList.ItemKey.Item AS Item,
		|	PurchaseReturnOrderItemList.ItemKey AS ItemKey,
		|	SUM(PurchaseReturnOrderItemList.Quantity) AS Quantity,
		|	PurchaseReturnOrderItemList.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	PurchaseReturnOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	0 AS BasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Period AS Period,
		|	PurchaseReturnOrderItemList.PurchaseInvoice AS PurchaseInvoice,
		|	ISNULL(PurchaseReturnOrderItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)) AS Currency,
		|	SUM(PurchaseReturnOrderItemList.TotalAmount) AS TotalAmount,
		|	PurchaseReturnOrderItemList.Key AS RowKey,
		|	SUM(PurchaseReturnOrderItemList.NetAmount) AS NetAmount,
		|	CASE
		|		WHEN PurchaseReturnOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService
		|FROM
		|	Document.PurchaseReturnOrder.ItemList AS PurchaseReturnOrderItemList
		|WHERE
		|	PurchaseReturnOrderItemList.Ref = &Ref
		|GROUP BY
		|	PurchaseReturnOrderItemList.Ref.Company,
		|	PurchaseReturnOrderItemList.Store,
		|	PurchaseReturnOrderItemList.ItemKey,
		|	PurchaseReturnOrderItemList.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Item.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Unit,
		|	PurchaseReturnOrderItemList.ItemKey.Item,
		|	VALUE(Catalog.Units.EmptyRef),
		|	PurchaseReturnOrderItemList.Ref,
		|	PurchaseReturnOrderItemList.PurchaseInvoice,
		|	ISNULL(PurchaseReturnOrderItemList.Ref.Currency, VALUE(Catalog.Currencies.EmptyRef)),
		|	PurchaseReturnOrderItemList.Key,
		|	CASE
		|		WHEN PurchaseReturnOrderItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END
		|HAVING
		|	SUM(PurchaseReturnOrderItemList.Quantity) <> 0";
	
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
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.PurchaseInvoice,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.IsService AS IsService
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1. OrderBalance //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period,
		|	tmp.RowKey
		|;
		|
		|// 2. OrderReservation //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 3. StockReservation //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|
		|// 4. PurchaseTurnovers//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	-SUM(tmp.Quantity) AS Quantity,
		|	-SUM(Amount) AS Amount,
		|	-SUM(NetAmount) AS NetAmount,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.PurchaseInvoice,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.RowKey";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables.OrderBalance      = QueryResults[1].Unload();
	Tables.OrderReservation  = QueryResults[2].Unload();
	Tables.StockReservation  = QueryResults[3].Unload();
	Tables.PurchaseTurnovers = QueryResults[4].Unload();
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// PurchaseTurnovers
	PurchaseTurnovers = AccumulationRegisters.PurchaseTurnovers.GetLockFields(DocumentDataTables.PurchaseTurnovers);
	DataMapWithLockFields.Insert(PurchaseTurnovers.RegisterName, PurchaseTurnovers.LockInfo);

	// OrderReservation
	OrderReservation = AccumulationRegisters.OrderReservation.GetLockFields(DocumentDataTables.OrderReservation);
	DataMapWithLockFields.Insert(OrderReservation.RegisterName, OrderReservation.LockInfo);
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
	// PurchaseTurnuvers			   
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PurchaseTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.PurchaseTurnovers,
			Parameters.IsReposting));
	
	// OrderReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.OrderReservation,
			Parameters.IsReposting));
	
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			True));
	
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
	
	// StockReservation
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Exists);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.PurchaseReturnOrder.ItemList", AddInfo);
EndProcedure

#EndRegion

