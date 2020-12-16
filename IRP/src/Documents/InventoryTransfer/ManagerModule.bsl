#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("TransferOrderBalance"     , PostingServer.CreateTable(AccReg.TransferOrderBalance));
	Tables.Insert("StockReservation_Expense" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockReservation_Receipt" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Expense"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Receipt"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockBalance_Transit"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("GoodsInTransitIncoming"   , PostingServer.CreateTable(AccReg.GoodsInTransitIncoming));
	Tables.Insert("GoodsInTransitOutgoing"   , PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextInventoryTransferItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultsItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultsItemList.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResults = Query.ExecuteBatch();
	
	Tables.TransferOrderBalance     = QueryResults[1].Unload();
	Tables.StockReservation_Expense = QueryResults[2].Unload();
	Tables.StockReservation_Receipt = QueryResults[4].Unload();
	Tables.StockBalance_Expense     = QueryResults[5].Unload();
	Tables.StockBalance_Receipt     = QueryResults[3].Unload();
	Tables.GoodsInTransitIncoming   = QueryResults[6].Unload();
	Tables.GoodsInTransitOutgoing   = QueryResults[7].Unload();
	Tables.StockBalance_Transit     = QueryResults[8].Unload();
	
	Header = New Structure();
	Header.Insert("StoreReceiverUseGoodsReceipt", Ref.StoreReceiver.UseGoodsReceipt);
	Header.Insert("StoreSenderUseShipmentConfirmation", Ref.StoreSender.UseShipmentConfirmation);
	
	Tables.Insert("Header", Header);
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function GetQueryTextInventoryTransferItemList()
	Return
	"SELECT
		|	InventoryTransferItemList.Ref.Company AS Company,
		|	InventoryTransferItemList.Ref.StoreSender AS StoreSender,
		|	InventoryTransferItemList.Ref.StoreReceiver AS StoreReceiver,
		|	InventoryTransferItemList.Ref.StoreTransit AS StoreTransit,
		|	InventoryTransferItemList.InventoryTransferOrder AS Order,
		|	InventoryTransferItemList.ItemKey AS ItemKey,
		|	SUM(InventoryTransferItemList.Quantity) AS Quantity,
		|	0 AS BasisQuantity,
		|	InventoryTransferItemList.Unit,
		|	InventoryTransferItemList.Key AS RowKey,
		|	InventoryTransferItemList.ItemKey.Item.Unit AS ItemUnit,
		|	InventoryTransferItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	InventoryTransferItemList.ItemKey.Item AS Item,
		|	InventoryTransferItemList.Ref.Date AS Period,
		|	InventoryTransferItemList.Ref AS ReceiptBasis,
		|	InventoryTransferItemList.Ref AS ShipmentBasis
		|FROM
		|	Document.InventoryTransfer.ItemList AS InventoryTransferItemList
		|WHERE
		|	InventoryTransferItemList.Ref = &Ref
		|GROUP BY
		|	InventoryTransferItemList.Ref.Company,
		|	InventoryTransferItemList.Ref.StoreSender,
		|	InventoryTransferItemList.Ref.StoreReceiver,
		|	InventoryTransferItemList.InventoryTransferOrder,
		|	InventoryTransferItemList.Key,
		|	InventoryTransferItemList.ItemKey,
		|	InventoryTransferItemList.Unit,
		|	InventoryTransferItemList.ItemKey.Item.Unit,
		|	InventoryTransferItemList.ItemKey.Unit,
		|	InventoryTransferItemList.ItemKey.Item,
		|	InventoryTransferItemList.Ref.Date,
		|	InventoryTransferItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef)";
EndFunction

Function GetQueryTextQueryTable()
	Return
	"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.StoreSender AS StoreSender,
		|	QueryTable.StoreReceiver AS StoreReceiver,
		|	QueryTable.StoreTransit AS StoreTransit,
		|	QueryTable.Order AS Order,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|// 1 - OrderBalance//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender,
		|	tmp.StoreReceiver,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Order <> VALUE(Document.InventoryTransferOrder.EmptyRef)
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.StoreReceiver,
		|	tmp.Order,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period
		|;
		|
		|// 2 - StockReservation_Expense //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.Order = VALUE(Document.InventoryTransferOrder.EmptyRef)
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 3 - StockBalance_Receipt//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 4 - StockReservation_Receipt //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|// 5 - StockBalance_Expense //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|// 6 - GoodsInTransitIncoming//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreReceiver AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreReceiver,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|   tmp.RowKey
		|;
		|// 7 - GoodsInTransitOutgoing //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreSender AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.StoreSender,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|;
		|// 8 - StockBalance_Transit //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.StoreTransit AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|Where
		|	tmp.StoreTransit <> VALUE(Catalog.Stores.EmptyRef)
		|GROUP BY
		|	tmp.StoreTransit,
		|	tmp.ItemKey,
		|	tmp.Period
		|";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// TransferOrderBalance
	TransferOrderBalance = 
	AccumulationRegisters.TransferOrderBalance.GetLockFields(DocumentDataTables.TransferOrderBalance);
	DataMapWithLockFields.Insert(TransferOrderBalance.RegisterName, TransferOrderBalance.LockInfo);
	
	If Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// GoodsInTransitIncoming (Receiver) 
		GoodsInTransitIncoming = 
		AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming);
		DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
		
		// GoodsInTransitOutgoing (Sender)
		GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
		DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
		 
	ElsIf Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender)
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// GoodsInTransitIncoming (Receiver) 
		GoodsInTransitIncoming = 
		AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.GoodsInTransitIncoming);
		DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
		
		// StockBalance (Sender) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockBalance_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockBalance_Transit);
		
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver)
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Receipt);
		
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// StockBalance (Receiver) 
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Receipt);
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
		// GoodsInTransitOutgoing (Sender) 
		GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
		DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Receipt);
		
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
		// StockBalance (Sender and Receiver) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockBalance_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockBalance_Receipt);
		
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	EndIf;
	
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
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.TransferOrderBalance,
			Parameters.IsReposting));
	
	If Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) StockReservation_Expense [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockReservation_Expense,
				True));
		
		
		// GoodsInTransitIncoming (Receiver) GoodsInTransitIncoming [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitIncoming,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Sender) GoodsInTransitOutgoing [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitOutgoing,
				Parameters.IsReposting));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender) StockReservation_Expense [Expense] 		 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockReservation_Expense,
				True));
		
		// GoodsInTransitIncoming (Receiver) GoodsInTransitIncoming [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitIncoming,
				Parameters.IsReposting));
		
		// StockBalance (Sender) 
		// StockBalance_Expense [Expense]
		// StockBalance_Transit [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockBalance_Transit.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		// StockReservation_Expense [Expense] 
		// StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
		// StockBalance (Receiver) StockBalance_Receipt [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Receipt,
				True));
		
		// GoodsInTransitOutgoing (Sender) GoodsInTransitOutgoing [Receipt] 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.GoodsInTransitOutgoing,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreReceiverUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreSenderUseShipmentConfirmation Then
		
		// StockReservation (Sender and Receiver) 
		// StockReservation_Expense [Expense]  
		// StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		Table1 = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
		Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
		
		Table2 = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
		Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
		
		
		// StockBalance (Sender and Receiver) 
		// StockBalance_Expense [Expense]  
		// StockBalance_Receipt [Receipt]
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
		
	EndIf;
	
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
	
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.InventoryTransfer.ItemList");
	If Not Cancel And Not AccReg.StockReservation.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
															   Parameters.DocumentDataTables.StockReservation, 
															   Parameters.DocumentDataTables.StockReservation_Exists, 
															   AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;

	If Not Cancel And Not AccReg.StockBalance.CheckBalance(Ref, LineNumberAndItemKeyFromItemList, 
															   Parameters.DocumentDataTables.StockBalance, 
															   Parameters.DocumentDataTables.StockBalance_Exists, 
															   AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion
