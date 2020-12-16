#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	InfoReg = Metadata.InformationRegisters;
	Tables = New Structure();
	Tables.Insert("StockReservation_Expense" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Receipt"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("StockReservation_Receipt" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Expense"     , PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("BundleContents"           , PostingServer.CreateTable(InfoReg.BundleContents));
	
	Tables.Insert("StockReservation_Exists" , PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("StockBalance_Exists"     , PostingServer.CreateTable(AccReg.StockBalance));
	
	Tables.StockReservation_Exists = 
	AccumulationRegisters.StockReservation.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Tables.StockBalance_Exists = 
	AccumulationRegisters.StockBalance.GetExistsRecords(Ref, AccumulationRecordType.Receipt, AddInfo);
	
	Specification = FindOrCreateSpecificationByProperties(Ref, AddInfo);
	ItemKey = Catalogs.ItemKeys.FindOrCreateRefBySpecification(Specification, Ref.ItemBundle, AddInfo);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	BundlingItemList.Ref.Company AS Company,
		|	BundlingItemList.Ref.Store AS Store,
		|	BundlingItemList.ItemKey AS ItemKey,
		|	SUM(BundlingItemList.Quantity) * BundlingItemList.Ref.Quantity AS Quantity,
		|	0 AS BasisQuantity,
		|	BundlingItemList.Unit,
		|	BundlingItemList.ItemKey.Item.Unit AS ItemUnit,
		|	BundlingItemList.ItemKey.Unit AS ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	BundlingItemList.ItemKey.Item AS Item,
		|	BundlingItemList.Ref.Date AS Period,
		|	BundlingItemList.Ref AS ReceiptBasis,
		|	BundlingItemList.Ref AS ShipmentBasis,
		|	BundlingItemList.Key AS RowKey
		|FROM
		|	Document.Bundling.ItemList AS BundlingItemList
		|WHERE
		|	BundlingItemList.Ref = &Ref
		|GROUP BY
		|	BundlingItemList.Ref.Company,
		|	BundlingItemList.Ref.Store,
		|	BundlingItemList.ItemKey,
		|	BundlingItemList.Unit,
		|	BundlingItemList.ItemKey.Item.Unit,
		|	BundlingItemList.ItemKey.Unit,
		|	BundlingItemList.ItemKey.Item,
		|	BundlingItemList.Ref.Date,
		|	BundlingItemList.Ref,
		|	VALUE(Catalog.Units.EmptyRef),
		|   BundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.Execute();
	
	QueryTable_ItemList = QueryResults.Unload();
	
	PostingServer.CalculateQuantityByUnit(QueryTable_ItemList);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Bundling.Company,
		|	Bundling.Store,
		|	&ItemKey,
		|	Bundling.Quantity,
		|	0 AS BasisQuantity,
		|	Bundling.Unit,
		|	Bundling.ItemBundle.Unit AS ItemUnit,
		|	&ItemKeyUnit,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	Bundling.ItemBundle AS Item,
		|	Bundling.Date AS Period,
		|	Bundling.Ref AS ReceiptBasis,
		|	Bundling.Ref AS ShipmentBasis,
		|   &RowKey AS RowKey
		|FROM
		|	Document.Bundling AS Bundling
		|WHERE
		|	Bundling.Ref = &Ref";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("ItemKeyUnit", ItemKey.Unit);
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
		|   tmp.RowKey
		|;
		|// 6//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SUM(tmp_ItemList.Quantity / tmp_Header.Quantity) AS Quantity,
		|	tmp_ItemList.ItemKey AS ItemKey,
		|	tmp_Header.ItemKey AS ItemKeyBundle,
		|	tmp_Header.Period AS Period
		|FROM
		|	tmp_Header AS tmp_Header
		|		LEFT JOIN tmp_ItemList AS tmp_ItemList
		|		ON TRUE
		|GROUP BY
		|	tmp_ItemList.ItemKey,
		|	tmp_Header.ItemKey,
		|	tmp_Header.Period";
	
	Query.SetParameter("QueryTable_ItemList", QueryTable_ItemList);
	Query.SetParameter("QueryTable_Header", QueryTable_Header);
	
	QueryResults = Query.ExecuteBatch();
	
	Tables.StockReservation_Expense = QueryResults[2].Unload();
	Tables.StockBalance_Receipt     = QueryResults[3].Unload();
	Tables.StockReservation_Receipt = QueryResults[4].Unload();
	Tables.StockBalance_Expense     = QueryResults[5].Unload();
	Tables.BundleContents           = QueryResults[6].Unload();
	
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
	
	// BundleContents 
	BundleContents = InformationRegisters.BundleContents.GetLockFields(DocumentDataTables.BundleContents);
	DataMapWithLockFields.Insert(BundleContents.RegisterName, BundleContents.LockInfo);
	
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
	
	// BundleContents 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.BundleContents,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.BundleContents,
			Parameters.IsReposting));
	
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
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Bundling.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region Specifications

Function FindOrCreateSpecificationByProperties(Ref, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	BundlingItemList.Key,
		|	BundlingItemList.ItemKey.Item AS Item,
		|	ItemKeysAddAttributes.Property AS Attribute,
		|	ItemKeysAddAttributes.Value
		|FROM
		|	Catalog.ItemKeys.AddAttributes AS ItemKeysAddAttributes
		|		INNER JOIN Document.Bundling.ItemList AS BundlingItemList
		|		ON BundlingItemList.ItemKey = ItemKeysAddAttributes.Ref
		|		AND BundlingItemList.Ref = &Ref
		|GROUP BY
		|	BundlingItemList.ItemKey.Item,
		|	ItemKeysAddAttributes.Property,
		|	ItemKeysAddAttributes.Value,
		|	BundlingItemList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BundlingItemList.Key,
		|	BundlingItemList.ItemKey.Item AS Item,
		|	SUM(BundlingItemList.Quantity) AS Quantity
		|FROM
		|	Document.Bundling.ItemList AS BundlingItemList
		|WHERE
		|	BundlingItemList.Ref = &Ref
		|GROUP BY
		|	BundlingItemList.ItemKey.Item,
		|	BundlingItemList.Key";
	Query.SetParameter("Ref", Ref);
	ArrayOfQueryResults = Query.ExecuteBatch();
	
	ArrayOfSpecifications = Catalogs.Specifications.FindOrCreateRefByProperties(ArrayOfQueryResults[0].Unload()
			, ArrayOfQueryResults[1].Unload()
			, Ref.ItemBundle
			, AddInfo);
	If ArrayOfSpecifications.Count() Then
		Return ArrayOfSpecifications[0];
	Else
		Return Catalogs.Specifications.EmptyRef();
	EndIf;
EndFunction

#EndRegion