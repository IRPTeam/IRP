#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("StockReservation_Receipt" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Expense"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation_Expense" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Receipt"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	UnbundlingItemList.Ref.Company AS Company,
		|	UnbundlingItemList.Ref.Store AS Store,
		|	UnbundlingItemList.ItemKey AS ItemKey,
		|	SUM(UnbundlingItemList.Quantity) * UnbundlingItemList.Ref.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	UnbundlingItemList.Unit,
		|	UnbundlingItemList.ItemKey.Item.Unit AS ItemUnit,
		|	UnbundlingItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	UnbundlingItemList.ItemKey.Item AS Item,
		|	UnbundlingItemList.Ref.Date AS Period,
		|	UnbundlingItemList.Ref AS ReceiptBasis,
		|	UnbundlingItemList.Ref AS ShipmentBasis,
		|   UnbundlingItemList.Key AS RowKey
		|FROM
		|	Document.Unbundling.ItemList AS UnbundlingItemList
		|WHERE
		|	UnbundlingItemList.Ref = &Ref
		|GROUP BY
		|	UnbundlingItemList.Ref.Company,
		|	UnbundlingItemList.Ref.Store,
		|	UnbundlingItemList.ItemKey,
		|	UnbundlingItemList.Unit,
		|	UnbundlingItemList.ItemKey.Item.Unit,
		|	UnbundlingItemList.ItemKey.Unit,
		|	UnbundlingItemList.ItemKey.Item,
		|	UnbundlingItemList.Ref.Date,
		|	UnbundlingItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef),
		|   UnbundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_ItemList = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_ItemList);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Unbundling.Company,
		|	Unbundling.Store,
		|	Unbundling.ItemKeyBundle AS ItemKey,
		|	Unbundling.Quantity,
		|	0 AS BasisQuantity,
		|	Unbundling.Unit,
		|	Unbundling.ItemKeyBundle.Item.Unit AS ItemUnit,
		|	Unbundling.ItemKeyBundle.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	Unbundling.ItemKeyBundle.Item AS Item,
		|	Unbundling.Date AS Period,
		|	Unbundling.Ref AS ReceiptBasis,
		|	Unbundling.Ref AS ShipmentBasis,
		|   &RowKey AS RowKey
		|FROM
		|	Document.Unbundling AS Unbundling
		|WHERE
		|	Unbundling.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("RowKey", Ref.UUID());
	QueryResults = Query.Execute();
	
	QueryTable_Header = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_Header);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|   QueryTable.RowKey AS RowKey
		|INTO tmp_ItemList
		|FROM
		|	&QueryTable_ItemList AS QueryTable
		|;
		|// 1//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.BasisUnit AS Unit,
		|	QueryTable.Period AS Period,
		|	QueryTable.ReceiptBasis AS ReceiptBasis,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|   QueryTable.RowKey AS RowKey
		|INTO tmp_Header
		|FROM
		|	&QueryTable_Header AS QueryTable
		|;
		|// 2//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp_ItemList AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|// 3//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp_Header AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|	tmp.Store,
		|   tmp.RowKey
		|;
		|// 4//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period
		|FROM
		|	tmp_Header AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.ItemKey,
		|	tmp.Store,
		|	tmp.Period
		|;
		|// 5//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey,
		|	SUM(Quantity) AS Quantity,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey
		|FROM
		|	tmp_ItemList AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.ReceiptBasis,
		|	tmp.ShipmentBasis,
		|   tmp.RowKey";
	
	Query.SetParameter("QueryTable_ItemList", QueryTable_ItemList);
	Query.SetParameter("QueryTable_Header", QueryTable_Header);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables.StockReservation_Receipt = QueryResults[2].Unload();
	Tables.StockBalance_Expense     = QueryResults[3].Unload();
	Tables.StockReservation_Expense = QueryResults[4].Unload();
	Tables.StockBalance_Receipt     = QueryResults[5].Unload();
	
	Header = New Structure();
	Header.Insert("StoreUseGoodsReceipt", Ref.Store.UseGoodsReceipt);
	Header.Insert("StoreUseShipmentConfirmation", Ref.Store.UseShipmentConfirmation);
	
	Tables.Insert("Header", Header);
	
	Tables.Insert("QueryTable_ItemList", QueryTable_ItemList);
	Tables.Insert("QueryTable_Header", QueryTable_Header);
	
	Parameters.IsReposting = False;
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// GoodsInTransitIncoming (Incoming) 
		GoodsInTransitIncoming = 
		AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.StockBalance_Receipt);
		DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
		
		// GoodsInTransitOutgoing (Outgoing) 
		GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.StockBalance_Expense);
		DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
		
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) 
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation_Expense);
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// GoodsInTransitIncoming (Incoming) 
		GoodsInTransitIncoming = 
		AccumulationRegisters.GoodsInTransitIncoming.GetLockFields(DocumentDataTables.StockBalance_Receipt);
		DataMapWithLockFields.Insert(GoodsInTransitIncoming.RegisterName, GoodsInTransitIncoming.LockInfo);
		
		// StockBalance (Outgoing) 
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Expense);
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming)	 	
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Receipt);
		
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// StockBalance (Incoming) 
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance_Receipt);
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
		
		// GoodsInTransitOutgoing (Outgoing) 
		GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.StockBalance_Expense);
		DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockReservation_Receipt);
		
		StockReservation = 
		AccumulationRegisters.StockReservation.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
		
		// StockBalance (Outgoing and Incoming) 
		ArrayOfTables = New Array();
		ArrayOfTables.Add(DocumentDataTables.StockBalance_Expense);
		ArrayOfTables.Add(DocumentDataTables.StockBalance_Receipt);
		
		StockBalance = 
		AccumulationRegisters.StockBalance.GetLockFields(PostingServer.JoinTables(ArrayOfTables, "Store, ItemKey"));
		DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	Else
		Raise R().Exc_002;
	EndIf;
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	If Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) StockReservation_Expense [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockReservation_Expense,
				True));
		
		
		// GoodsInTransitIncoming (Incoming) StockBalance_Receipt [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Receipt,
				Parameters.IsReposting));
		
		// GoodsInTransitOutgoing (Outgoing) StockBalance_Expense [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Expense,
				Parameters.IsReposting));
		
	ElsIf Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing) StockReservation_Expense [Expense] 		 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockReservation_Expense,
				True));
		
		// GoodsInTransitIncoming (Incoming) StockBalance_Receipt [Receipt]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitIncoming,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Receipt,
				Parameters.IsReposting));
		
		// StockBalance (Outgoing) StockBalance_Expense [Expense]
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Expense,
				Parameters.DocumentDataTables.StockBalance_Expense,
				True));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		// StockReservation_Expense [Expense] 
		// StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		StockReservation_Expense = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
		StockReservation_Expense.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		StockReservation_Expense.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(StockReservation_Expense);
		
		StockReservation_Receipt = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
		StockReservation_Receipt.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		StockReservation_Receipt.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(StockReservation_Receipt);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				True));
		
		// StockBalance (Incoming) StockBalance_Receipt 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Receipt,
				True));
		
		// GoodsInTransitOutgoing (Outgoing) StockBalance_Expense [Receipt] 
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
			New Structure("RecordType, RecordSet, WriteInTransaction",
				AccumulationRecordType.Receipt,
				Parameters.DocumentDataTables.StockBalance_Expense,
				Parameters.IsReposting));
		
	ElsIf Not Parameters.DocumentDataTables.Header.StoreUseGoodsReceipt
		And Not Parameters.DocumentDataTables.Header.StoreUseShipmentConfirmation Then
		
		// StockReservation (Outgoing and Incoming) 
		// StockReservation_Expense [Expense]  
		// StockReservation_Receipt [Receipt]
		ArrayOfTables = New Array();
		StockReservation_Expense = Parameters.DocumentDataTables.StockReservation_Expense.Copy();
		StockReservation_Expense.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		StockReservation_Expense.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(StockReservation_Expense);
		
		StockReservation_Receipt = Parameters.DocumentDataTables.StockReservation_Receipt.Copy();
		StockReservation_Receipt.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		StockReservation_Receipt.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(StockReservation_Receipt);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Store, ItemKey, Quantity"),
				True));
		
		// StockBalance (Outgoing and Incoming) 
		// StockBalance_Expense [Expense]  
		// StockBalance_Receipt [Receipt]
		ArrayOfTables = New Array();
		StockBalance_Expense = Parameters.DocumentDataTables.StockBalance_Expense.Copy();
		StockBalance_Expense.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		StockBalance_Expense.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(StockBalance_Expense);
		
		StockBalance_Receipt = Parameters.DocumentDataTables.StockBalance_Receipt.Copy();
		StockBalance_Receipt.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
		StockBalance_Receipt.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(StockBalance_Receipt);
		
		PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
			New Structure("RecordSet, WriteInTransaction",
				PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Store, ItemKey, Quantity"),
				True));
	Else
		Raise R().Exc_002;
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
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		Parameters.Insert("RecordType", AccumulationRecordType.Expense);
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ErrorQuantityField", "Object.Quantity");
	EndIf;
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Unbundling.ItemList", AddInfo);
EndProcedure

#EndRegion
