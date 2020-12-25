#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("TransferOrderBalance"     , PostingServer.CreateTable(AccReg.TransferOrderBalance));
	Tables.Insert("StockReservation"         , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("OrderBalance"             , PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("SupplyRequestProcurement" , PostingServer.CreateTable(AccReg.SupplyRequestProcurement));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Expense, AddInfo);
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	InventoryTransferOrderItemList.Ref.Company AS Company,
		|	InventoryTransferOrderItemList.Ref.StoreSender AS StoreSender,
		|	InventoryTransferOrderItemList.Ref.StoreReceiver AS StoreReceiver,
		|	InventoryTransferOrderItemList.Ref AS Order,
		|	InventoryTransferOrderItemList.InternalSupplyRequest AS InternalSupplyRequest,
		|	InventoryTransferOrderItemList.ItemKey AS ItemKey,
		|	InventoryTransferOrderItemList.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	InventoryTransferOrderItemList.Unit,
		|	InventoryTransferOrderItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InventoryTransferOrderItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InventoryTransferOrderItemList.ItemKey.Item AS Item,
		|	&Period AS Period,
		|	InventoryTransferOrderItemList.Key AS RowKey,
		|	InventoryTransferOrderItemList.Ref.Date AS DocumentDate,
		|	&StatusInfo_Posting AS StatusInfo_Posting
		|FROM
		|	Document.InventoryTransferOrder.ItemList AS InventoryTransferOrderItemList
		|WHERE
		|	InventoryTransferOrderItemList.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", StatusInfo.Period);
	Query.SetParameter("StatusInfo_Posting", StatusInfo.Posting);
	QueryResults = Query.Execute();
	
	QueryTable = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.StoreSender AS StoreSender,
		|	QueryTable.StoreReceiver AS StoreReceiver,
		|	QueryTable.InternalSupplyRequest AS InternalSupplyRequest,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.DocumentDate,
		|	QueryTable.StatusInfo_Posting
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS StoreSender,
		|	tmp.StoreReceiver AS StoreReceiver,
		|	tmp.Order AS Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|;
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Unit AS Unit,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Unit,
		|	tmp.Period
		|;
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	tmp.Quantity AS Quantity,
		|	tmp.InternalSupplyRequest AS Order,
		|	tmp.Period,
		|	tmp.RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.InternalSupplyRequest <> VALUE(Document.InternalSupplyRequest.EmptyRef)
		|;
		|//[4]/////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.DocumentDate AS Period,
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.StoreReceiver AS Store,
		|	tmp.InternalSupplyRequest,
		|	tmp.DocumentDate AS OrderCreationDate,
		|	CASE 
		|		WHEN StatusInfo_Posting THEN 
		|			tmp.Period 
		|		ELSE
		|			DATETIME(1,1,1)
		|		END AS OrderApprovalDate,
		|	CASE 
		|		WHEN StatusInfo_Posting THEN
		|			tmp.Period 
		|		ELSE
		|			DATETIME(1,1,1)
		|		END AS OrderDeliveryDate,
		|	VALUE(Enum.ProcurementMovementTypes.Order) AS MovementType,
		|	tmp.Quantity AS Quantity
		|FROM 
		|	tmp AS tmp
		|WHERE
		|	tmp.InternalSupplyRequest <> VALUE(Document.InternalSupplyRequest.EmptyRef)";
	
	Query.SetParameter("QueryTable", QueryTable);
	QueryResults = Query.ExecuteBatch();
	
	If StatusInfo.Posting Then
		Tables.TransferOrderBalance = QueryResults[1].Unload();
		Tables.StockReservation     = QueryResults[2].Unload();
		Tables.OrderBalance         = QueryResults[3].Unload();
	EndIf;
	
	Tables.SupplyRequestProcurement = QueryResults[4].Unload();
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// TransferOrderBalance
	TransferOrderBalance = 
	AccumulationRegisters.TransferOrderBalance.GetLockFields(DocumentDataTables.TransferOrderBalance);
	DataMapWithLockFields.Insert(TransferOrderBalance.RegisterName, TransferOrderBalance.LockInfo);
	
	// StockReservation
	StockReservation = 
	AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);

	// OrderBalance
	OrderBalance = 
	AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// TransferOrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TransferOrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.TransferOrderBalance,
			Parameters.IsReposting));
	
	// StockReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation,
			True));
	
	// OrderBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			Parameters.IsReposting));
	
	// SupplyRequestProcurement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SupplyRequestProcurement,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.SupplyRequestProcurement,
			False));
	
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
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod", 
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.InventoryTransferOrder.ItemList", AddInfo);
EndProcedure

#EndRegion

