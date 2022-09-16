Function GetArrayOfBatchDocumentTypes()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	ArrayOfTypes.Add(Type("DocumentRef.OpeningEntry"));
	ArrayOfTypes.Add(Type("DocumentRef.PurchaseInvoice"));
	ArrayOfTypes.Add(Type("DocumentRef.PurchaseReturn"));
	ArrayOfTypes.Add(Type("DocumentRef.RetailSalesReceipt"));
	ArrayOfTypes.Add(Type("DocumentRef.RetailReturnReceipt"));
	ArrayOfTypes.Add(Type("DocumentRef.SalesInvoice"));
	ArrayOfTypes.Add(Type("DocumentRef.SalesReturn"));
	ArrayOfTypes.Add(Type("DocumentRef.StockAdjustmentAsSurplus"));
	ArrayOfTypes.Add(Type("DocumentRef.StockAdjustmentAsWriteOff"));
	ArrayOfTypes.Add(Type("DocumentRef.Unbundling"));
	ArrayOfTypes.Add(Type("DocumentRef.BatchReallocateIncoming"));
	ArrayOfTypes.Add(Type("DocumentRef.BatchReallocateOutgoing"));
	Return ArrayOfTypes;
EndFunction

Function GetBatchDocumentsTypes()
	ArrayOfTypes = GetArrayOfBatchDocumentTypes();
	Types = New TypeDescription(ArrayOfTypes);
	Return Types;
EndFunction

Function CreateTable_BatchWiseBalance()
	Table = New ValueTable();
	Table.Columns.Add("Batch"     , New TypeDescription("CatalogRef.Batches"));
	Table.Columns.Add("BatchKey"  , New TypeDescription("CatalogRef.BatchKeys"));
	Table.Columns.Add("Document"  , GetBatchDocumentsTypes());
	Table.Columns.Add("Company"   , New TypeDescription("CatalogRef.Companies"));
	Table.Columns.Add("Period"    , Metadata.AccumulationRegisters.R6010B_BatchWiseBalance.StandardAttributes.Period.Type);
	Table.Columns.Add("Quantity"  , Metadata.AccumulationRegisters.R6010B_BatchWiseBalance.Resources.Quantity.Type);
	Table.Columns.Add("Amount"    , Metadata.AccumulationRegisters.R6010B_BatchWiseBalance.Resources.Amount.Type);
	Table.Columns.Add("AmountTax" , Metadata.AccumulationRegisters.R6010B_BatchWiseBalance.Resources.AmountTax.Type);
	Return Table;
EndFunction

Procedure LockCatalogs(LocksStorage)
	// Set lock for table Catalog.Batches
	DataLock_Batches = New DataLock();
	ItemLock_Batches = DataLock_Batches.Add("Catalog.Batches");
	ItemLock_Batches.Mode = DataLockMode.Exclusive;
	DataLock_Batches.Lock();
	LocksStorage.Add(DataLock_Batches);
	
	// Set lock for table Catalog.BatchKeys
	DataLock_BatchKeys = New DataLock();
	ItemLock_BatchKeys = DataLock_Batches.Add("Catalog.BatchKeys");
	ItemLock_BatchKeys.Mode = DataLockMode.Exclusive;
	DataLock_BatchKeys.Lock();
	LocksStorage.Add(DataLock_BatchKeys);
EndProcedure

Procedure LockDocuments(LocksStorage)
	// Set lock for Document.BatchReallocateIncoming
	DataLock_BatchReallocateIncoming = New DataLock();
	ItemLock_BatchReallocateIncoming = DataLock_BatchReallocateIncoming.Add("Document.BatchReallocateIncoming");
	ItemLock_BatchReallocateIncoming.Mode = DataLockMode.Exclusive;
	DataLock_BatchReallocateIncoming.Lock();
	LocksStorage.Add(DataLock_BatchReallocateIncoming);
	
	// Set lock for Document.BatchReallocateOutgoing
	DataLock_BatchReallocateOutgoing = New DataLock();
	ItemLock_BatchReallocateOutgoing = DataLock_BatchReallocateOutgoing.Add("Document.BatchReallocateOutgoing");
	ItemLock_BatchReallocateOutgoing.Mode = DataLockMode.Exclusive;
	DataLock_BatchReallocateOutgoing.Lock();
	LocksStorage.Add(DataLock_BatchReallocateOutgoing);
EndProcedure

Procedure Posting_BatchReallocate(BatchReallocateRef, EndPeriod) Export
	LocksStorage = New Array();
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			BatchReallocate(LocksStorage, BatchReallocateRef, EndPeriod);
			If TransactionActive() Then
				CommitTransaction();
			EndIf;
		Except
			If TransactionActive() Then
				RollbackTransaction();
			EndIf;
			Raise ErrorDescription();
		EndTry;
	Else
		BatchReallocate(LocksStorage, BatchReallocateRef, EndPeriod);
	EndIf;
EndProcedure

Procedure Posting_BatchWiceBalance(CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod, AddInfo = Undefined) Export
	LocksStorage = New Array();
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			BatchWiseBalance_DoRegistration(LocksStorage, CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod);
			If TransactionActive() Then
				CommitTransaction();
			EndIf;
		Except
			If TransactionActive() Then
				RollbackTransaction();
			EndIf;
			Raise ErrorDescription();
		EndTry;
	Else
		BatchWiseBalance_DoRegistration(LocksStorage, CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod);
	EndIf;
EndProcedure

// Entry point
Procedure BatchWiseBalance_DoRegistration(LocksStorage, CalculationMovementCostRef, Company, CalculationMode, BeginPeriod, EndPeriod)
	If CalculationMode = Enums.CalculationMode.LandedCost Then
		DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);
	ElsIf CalculationMode = Enums.CalculationMode.LandedCostBatchReallocate Then
		BatchReallocate(LocksStorage, CalculationMovementCostRef, EndPeriod);
		DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationMovementCostRef, Undefined, BeginPeriod, EndPeriod);
	ElsIf CalculationMode = Enums.CalculationMode.AdditionalItemCost Then
		DoRegistration_CalculationMode_AdditionalItemCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);
	ElsIf CalculationMode = Enums.CalculationMode.AdditionalItemRevenue Then
		DoRegistration_CalculationMode_AdditionalItemRevenue(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);
	EndIf;
EndProcedure

Procedure BatchReallocate(LocksStorage, BatchReallocateRef, EndPeriod)
	LockDocuments(LocksStorage);
	ReleaseBatchReallocateDocuments(BatchReallocateRef);

	MetadataR4050B = Metadata.AccumulationRegisters.R4050B_StockInventory;

	EmptyLackItemList = New ValueTable();
	EmptyLackItemList.Columns.Add("Store", MetadataR4050B.Dimensions.Store.Type);
	EmptyLackItemList.Columns.Add("ItemKey", MetadataR4050B.Dimensions.ItemKey.Type);
	EmptyLackItemList.Columns.Add("Quantity", MetadataR4050B.Resources.Quantity.Type);

	EmptyResultItemList = New ValueTable();
	EmptyResultItemList.Columns.Add("Store", MetadataR4050B.Dimensions.Store.Type);
	EmptyResultItemList.Columns.Add("ItemKey", MetadataR4050B.Dimensions.ItemKey.Type);
	EmptyResultItemList.Columns.Add("Quantity", MetadataR4050B.Resources.Quantity.Type);
	EmptyResultItemList.Columns.Add("CompanySender", MetadataR4050B.Dimensions.Company.Type);
	EmptyResultItemList.Columns.Add("CompanyReceiver", MetadataR4050B.Dimensions.Company.Type);

	ProcessedRecorders = New Array();
	LackOfBatches = True;
	While LackOfBatches Do

		NegativeStockBalanceSelection = GetNegativeStockBalance(ProcessedRecorders, EndPeriod);
		If Not NegativeStockBalanceSelection.Next() Then
			LackOfBatches = False;
			Break;
		EndIf;
		ProcessedRecorders.Add(NegativeStockBalanceSelection.Recorder);

		LackItemList = EmptyLackItemList.CopyColumns();
		ItemListSelection = NegativeStockBalanceSelection.Select();
		While ItemListSelection.Next() Do
			NewRow = LackItemList.Add();
			NewRow.Store    = ItemListSelection.Store;
			NewRow.ItemKey  = ItemListSelection.ItemKey;
			NewRow.Quantity = ItemListSelection.Quantity;
		EndDo;

		LackItemList.GroupBy("Store, ItemKey", "Quantity");

		ReallocatePeriod = NegativeStockBalanceSelection.Period - 2;

		PositiveStockBalance = GetPositiveStockBalance(NegativeStockBalanceSelection.Company, ReallocatePeriod, LackItemList);

		ResultItemList = EmptyResultItemList.CopyColumns();
		IsQuantityEnought = True;
		For Each LackRow In LackItemList Do

			LackQuantity = LackRow.Quantity;
			Filter = New Structure("Store, ItemKey", LackRow.Store, LackRow.ItemKey);
			FilteredRows = PositiveStockBalance.FindRows(Filter);

			For Each Row In FilteredRows Do
				If LackQuantity = 0 Then
					Break;
				EndIf;
				ReallocateQuantity = Min(LackQuantity, Row.QuantityBalance);
				Row.QuantityBalance = Row.QuantityBalance - ReallocateQuantity;
				LackQuantity = LackQuantity - ReallocateQuantity;

				NewRow = ResultItemList.Add();
				NewRow.CompanyReceiver = NegativeStockBalanceSelection.Company;
				NewRow.CompanySender   = Row.Company;
				NewRow.Store   = Row.Store;
				NewRow.ItemKey = Row.ItemKey;
				NewRow.Quantity = ReallocateQuantity;
			EndDo;

			If LackQuantity <> 0 Then
				IsQuantityEnought = False;
				Break;
			EndIf;
		EndDo;

		If Not IsQuantityEnought Then
			Continue;
		EndIf;

		ResultItemListCopy = ResultItemList.Copy();
		ResultItemListCopy.GroupBy("CompanyReceiver, CompanySender");

		For Each Row In ResultItemListCopy Do
			// outgoing reallocate
			OutgoingDoc = GetReleasedBatchReallocateDocument("BatchReallocateOutgoing", BatchReallocateRef, ReallocatePeriod);
			OutgoingDoc.Document = NegativeStockBalanceSelection.Recorder;
			OutgoingDoc.Company  = Row.CompanySender;
			
			// incoming reallocate
			IncomingDoc = GetReleasedBatchReallocateDocument("BatchReallocateIncoming", BatchReallocateRef, ReallocatePeriod + 1);
			IncomingDoc.Document = NegativeStockBalanceSelection.Recorder;
			IncomingDoc.Company  = Row.CompanyReceiver;

			Filter = New Structure("CompanyReceiver, CompanySender", Row.CompanyReceiver, Row.CompanySender);
			FilteredRows = ResultItemList.FindRows(Filter);
			For Each FilteredRow In FilteredRows Do
				// outgoing item list
				NewRowOutgoing = OutgoingDoc.ItemList.Add();
				NewRowOutgoing.ItemKey  = FilteredRow.ItemKey;
				NewRowOutgoing.Store    = FilteredRow.Store;
				NewRowOutgoing.Quantity = FilteredRow.Quantity;
				
				// incoming item list
				NewRowIncoming = IncomingDoc.ItemList.Add();
				NewRowIncoming.ItemKey  = FilteredRow.ItemKey;
				NewRowIncoming.Store    = FilteredRow.Store;
				NewRowIncoming.Quantity = FilteredRow.Quantity;
			EndDo;

			OutgoingDoc.Incoming = IncomingDoc.Ref;
			IncomingDoc.Outgoing = OutgoingDoc.Ref;

			OutgoingDoc.Write(DocumentWriteMode.Posting);
			IncomingDoc.Write(DocumentWriteMode.Posting);
		EndDo;
	EndDo;
EndProcedure

Procedure ReleaseBatchReallocateDocuments(BatchReallocateRef) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	BatchReallocateIncoming.Ref
	|FROM
	|	Document.BatchReallocateIncoming AS BatchReallocateIncoming
	|WHERE
	|	NOT BatchReallocateIncoming.DeletionMark
	|	AND BatchReallocateIncoming.BatchReallocate = &BatchReallocate
	|
	|UNION ALL
	|
	|SELECT
	|	BatchReallocateOutgoing.Ref
	|FROM
	|	Document.BatchReallocateOutgoing AS BatchReallocateOutgoing
	|WHERE
	|	NOT BatchReallocateOutgoing.DeletionMark
	|	AND BatchReallocateOutgoing.BatchReallocate = &BatchReallocate";
	Query.SetParameter("BatchReallocate", BatchReallocateRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		DocObject = QuerySelection.Ref.GetObject();
		DocObject.ItemList.Clear();
		DocObject.BatchReallocate = Undefined;
		DocObject.Company         = Catalogs.Companies.EmptyRef();
		DocObject.Document        = Undefined;
		If TypeOf(DocObject) = Type("DocumentObject.BatchReallocateIncoming") Then
			DocObject.Outgoing = Undefined;
		EndIf;
		If TypeOf(DocObject) = Type("DocumentObject.BatchReallocateOutgoing") Then
			DocObject.Incoming = Undefined;
		EndIf;
		DocObject.Write(DocumentWriteMode.UndoPosting);
	EndDo;
EndProcedure

Function GetReleasedBatchReallocateDocument(DocumentName, BatchReallocateRef, ReallocatePeriod)
	Query = New Query();
	Query.Text =
	"SELECT TOP 1
	|	Table.Ref
	|FROM
	|	Document.%1 AS Table
	|WHERE
	|	NOT Table.DeletionMark
	|	AND Table.BatchReallocate.Ref IS NULL";
	Query.Text = StrTemplate(Query.Text, DocumentName);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		DocumentObject = QuerySelection.Ref.GetObject();
	Else
		DocumentObject = Documents[DocumentName].CreateDocument();
	EndIf;
	DocumentObject.Date = ReallocatePeriod;
	DocumentObject.BatchReallocate = BatchReallocateRef;
	DocumentObject.Write();
	Return DocumentObject.Ref.GetObject();
EndFunction

Function GetNegativeStockBalance(ProcessedRecorders, EndPeriod)
	Query = New Query();
	Query.Text =
	"SELECT
	|	R4050B.Period AS Period,
	|	R4050B.Recorder AS Recorder,
	|	R4050B.Company AS Company,
	|	R4050B.Store AS Store,
	|	R4050B.ItemKey AS ItemKey,
	|	-R4050B.QuantityClosingBalance AS Quantity
	|FROM
	|	AccumulationRegister.R4050B_StockInventory.BalanceAndTurnovers(, ENDOFPERIOD(&EndPeriod, DAY), Recorder,
	|		RegisterRecords,) AS R4050B
	|WHERE
	|	R4050B.QuantityClosingBalance < 0
	|	AND NOT R4050B.Recorder IN (&ProcessedRecorders)
	|
	|ORDER BY
	|	R4050B.Recorder.PointInTime
	|TOTALS
	|	MAX(Period),
	|	MAX(Company)
	|BY
	|	Recorder";
	Query.SetParameter("EndPeriod", EndPeriod);
	Query.SetParameter("ProcessedRecorders", ProcessedRecorders);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	Return QuerySelection;
EndFunction

Function GetPositiveStockBalance(Company, Period, ItemList)
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Quantity
	|INTO tmp
	|FROM
	|	&ItemList AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R4050B.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Quantity,
	|	ISNULL(R4050B.QuantityBalance, 0) AS QuantityBalance
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN AccumulationRegister.R4050B_StockInventory.Balance(&Period, Company <> &Company
	|		AND (Store, ItemKey) IN
	|			(SELECT
	|				tmp.Store,
	|				tmp.ItemKey
	|			FROM
	|				tmp AS tmp)) AS R4050B
	|		ON tmp.Store = R4050B.Store
	|		AND tmp.ItemKey = R4050B.ItemKey";
	Query.SetParameter("Period", Period);
	Query.SetParameter("Company", Company);
	Query.SetParameter("ItemList", ItemList);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Procedure DoRegistration_CalculationMode_LandedCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod)
	LockCatalogs(LocksStorage);

	Catalogs.Batches.Create_Batches(CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);
	Catalogs.BatchKeys.Create_BatchKeys(Company, BeginPeriod, EndPeriod);

	BatchWiseBalanceTables = GetBatchWiseBalance(CalculationMovementCostRef, Company, BeginPeriod, EndPeriod);

	RecordSet = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	// Batch wise balance
	For Each Row In BatchWiseBalanceTables.DataForReceipt Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.RecordType = AccumulationRecordType.Receipt;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	For Each Row In BatchWiseBalanceTables.DataForExpense Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.RecordType = AccumulationRecordType.Expense;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Batch shortage outgoing
	RecordSet = AccumulationRegisters.R6030T_BatchShortageOutgoing.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBatchShortageOutgoing Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Batch shortage incoming
	RecordSet = AccumulationRegisters.R6040T_BatchShortageIncoming.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForBatchShortageIncoming Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Sales batches
	RecordSet = AccumulationRegisters.R6050T_SalesBatches.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In BatchWiseBalanceTables.DataForSalesBatches Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Bundle amount values
	RecordSet = InformationRegisters.T6040S_BundleAmountValues.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForBundleAmountValues.GroupBy(
	"Company, Period, Batch, BatchKey, BatchKeyBundle", "AmountValue, AmountTaxValue");

	For Each Row In BatchWiseBalanceTables.DataForBundleAmountValues Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Composite amount values
	RecordSet = InformationRegisters.T6090S_CompositeBatchesAmountValues.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForCompositeBatchesAmountValues.GroupBy(
	"Company, Period, Batch, BatchKey, BatchComposite, BatchKeyComposite", "Amount, AmountTax, Quantity");

	For Each Row In BatchWiseBalanceTables.DataForCompositeBatchesAmountValues Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Reallocated amount values
	RecordSet = InformationRegisters.T6080S_ReallocatedBatchesAmountValues.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForReallocatedBatchesAmountValues.GroupBy(
	"Period, OutgoingDocument, IncomingDocument, BatchKey", "Amount, AmountTax, Quantity");

	For Each Row In BatchWiseBalanceTables.DataForReallocatedBatchesAmountValues Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	// Write-off batches
	RecordSet = InformationRegisters.T6095S_WriteOffBatchesInfo.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);
	BatchWiseBalanceTables.DataForWriteOffBatches.GroupBy(
	"Period, Document, Company, Branch, ProfitLossCenter, ExpenseType, ItemKey, Currency, RowID", "Amount, AmountTax");

	For Each Row In BatchWiseBalanceTables.DataForWriteOffBatches Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Period = Row.Period;
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;

	RecordSet.Write();
	
	
	// Batch balance
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_LoadRecords(CalculationMovementCostRef);
	
	// Cost of goods sold
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_LoadRecords(CalculationMovementCostRef);
	
	// Expenses
	AccumulationRegisters.R5022T_Expenses.Expenses_LoadRecords(CalculationMovementCostRef);
	
	// Relevance
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Clear(Company, EndPeriod);
	InformationRegisters.T6030S_BatchRelevance.BatchRelevance_Restore(Company, EndPeriod);	
EndProcedure

Procedure DoRegistration_CalculationMode_AdditionalItemCost(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod)
	Query = New Query();
	Query.Text =
	"SELECT
	|	T6060S_BatchCostAllocationInfo.Company AS Company,
	|	T6060S_BatchCostAllocationInfo.Document AS Document,
	|	T6060S_BatchCostAllocationInfo.Store AS Store,
	|	T6060S_BatchCostAllocationInfo.ItemKey AS ItemKey,
	|	T6060S_BatchCostAllocationInfo.CurrencyMovementType AS CurrencyMovementType,
	|	T6060S_BatchCostAllocationInfo.Currency AS Currency,
	|	T6060S_BatchCostAllocationInfo.Amount AS Amount
	|INTO CostAllocationInfo
	|FROM
	|	InformationRegister.T6060S_BatchCostAllocationInfo AS T6060S_BatchCostAllocationInfo
	|WHERE
	|	T6060S_BatchCostAllocationInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|	AND T6060S_BatchCostAllocationInfo.Company = &Company
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Recorder AS Document,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey,
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	MAX(CostAllocationInfo.Amount) AS Amount
	|INTO CostAmounts_tmp
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		INNER JOIN CostAllocationInfo AS CostAllocationInfo
	|		ON T6020S_BatchKeysInfo.Company = CostAllocationInfo.Company
	|		AND T6020S_BatchKeysInfo.Recorder = CostAllocationInfo.Document
	|		AND T6020S_BatchKeysInfo.ItemKey = CostAllocationInfo.ItemKey
	|		AND T6020S_BatchKeysInfo.Currency = CostAllocationInfo.Currency
	|		AND T6020S_BatchKeysInfo.CurrencyMovementType = CostAllocationInfo.CurrencyMovementType
	|		AND T6020S_BatchKeysInfo.Direction = VALUE(Enum.BatchDirection.Receipt)
	|GROUP BY
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Recorder,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CostAmounts_tmp.Company AS Company,
	|	CostAmounts_tmp.Document AS Document,
	|	CostAmounts_tmp.Store AS Store,
	|	CostAmounts_tmp.ItemKey AS ItemKey,
	|	CostAmounts_tmp.Quantity AS Quantity,
	|	CostAmounts_tmp.Amount AS Amount,
	|	CASE
	|		WHEN CostAmounts_tmp.Quantity = 0
	|			THEN 0
	|		ELSE CostAmounts_tmp.Amount / CostAmounts_tmp.Quantity
	|	END AS AmountPerOneUnit
	|INTO CostAmounts
	|FROM
	|	CostAmounts_tmp AS CostAmounts_tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS Recorder,
	|	R6010B_BatchWiseBalance.LineNumber AS LineNumber,
	|	R6010B_BatchWiseBalance.Active AS Active,
	|	R6010B_BatchWiseBalance.RecordType AS RecordType,
	|	R6010B_BatchWiseBalance.Batch AS Batch,
	|	R6010B_BatchWiseBalance.BatchKey AS BatchKey,
	|	R6010B_BatchWiseBalance.Quantity AS Quantity1,
	|	R6010B_BatchWiseBalance.Amount AS Amount1,
	|	R6010B_BatchWiseBalance.AmountCost AS AmountCost1,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|	0 AS Quantity,
	|	0 AS Amount,
	|	CostAmounts.AmountPerOneUnit * R6010B_BatchWiseBalance.Quantity AS AmountCost
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|		INNER JOIN CostAmounts AS CostAmounts
	|		ON R6010B_BatchWiseBalance.Batch.Document = CostAmounts.Document
	|		AND R6010B_BatchWiseBalance.Batch.Company = CostAmounts.Company
	|		AND R6010B_BatchWiseBalance.BatchKey.ItemKey = CostAmounts.ItemKey
	|WHERE
	|	CostAmounts.AmountPerOneUnit * R6010B_BatchWiseBalance.Quantity <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6050T_SalesBatches.Period AS Period,
	|	R6050T_SalesBatches.Recorder AS Recorder,
	|	R6050T_SalesBatches.LineNumber AS LineNumber,
	|	R6050T_SalesBatches.Active AS Active,
	|	R6050T_SalesBatches.Batch AS Batch,
	|	R6050T_SalesBatches.BatchKey AS BatchKey,
	|	R6050T_SalesBatches.SalesInvoice AS SalesInvoice,
	|	R6050T_SalesBatches.Quantity AS Quantity1,
	|	R6050T_SalesBatches.Amount AS Amount1,
	|	R6050T_SalesBatches.AmountCost AS AmountCost1,
	|	0 AS Quantity,
	|	0 AS Amount,
	|	CostAmounts.AmountPerOneUnit * R6050T_SalesBatches.Quantity AS AmountCost
	|FROM
	|	AccumulationRegister.R6050T_SalesBatches AS R6050T_SalesBatches
	|		INNER JOIN CostAmounts AS CostAmounts
	|		ON R6050T_SalesBatches.Batch.Document = CostAmounts.Document
	|		AND R6050T_SalesBatches.Batch.Company = CostAmounts.Company
	|		AND R6050T_SalesBatches.BatchKey.ItemKey = CostAmounts.ItemKey
	|WHERE
	|	CostAmounts.AmountPerOneUnit * R6050T_SalesBatches.Quantity <> 0";

	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BeginPeriod);
	Query.SetParameter("EndPeriod", EndPeriod);
	QueryResults = Query.ExecuteBatch();

	RecordSet = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	//Batch wise balance
	For Each Row In QueryResults[3].Unload() Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	RecordSet.Write();
	
	//Sales batches
	RecordSet = AccumulationRegisters.R6050T_SalesBatches.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In QueryResults[4].Unload() Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	RecordSet.Write();
	
	//Batch balance
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_LoadRecords(CalculationMovementCostRef);
	
	//Cost of goods sold
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_LoadRecords(CalculationMovementCostRef);
EndProcedure

Procedure DoRegistration_CalculationMode_AdditionalItemRevenue(LocksStorage, CalculationMovementCostRef, Company, BeginPeriod, EndPeriod)
	Query = New Query();
	Query.Text =
	"SELECT
	|	T6070S_BatchRevenueAllocationInfo.Company AS Company,
	|	T6070S_BatchRevenueAllocationInfo.Document AS Document,
	|	T6070S_BatchRevenueAllocationInfo.Store AS Store,
	|	T6070S_BatchRevenueAllocationInfo.ItemKey AS ItemKey,
	|	T6070S_BatchRevenueAllocationInfo.CurrencyMovementType AS CurrencyMovementType,
	|	T6070S_BatchRevenueAllocationInfo.Currency AS Currency,
	|	T6070S_BatchRevenueAllocationInfo.Amount AS Amount
	|INTO RevenueAllocationInfo
	|FROM
	|	InformationRegister.T6070S_BatchRevenueAllocationInfo AS T6070S_BatchRevenueAllocationInfo
	|WHERE
	|	T6070S_BatchRevenueAllocationInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|	AND T6070S_BatchRevenueAllocationInfo.Company = &Company
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Recorder AS Document,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey,
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	MAX(RevenueAllocationInfo.Amount) AS Amount
	|INTO RevenueAmounts_tmp
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		INNER JOIN RevenueAllocationInfo AS RevenueAllocationInfo
	|		ON T6020S_BatchKeysInfo.Company = RevenueAllocationInfo.Company
	|		AND T6020S_BatchKeysInfo.Recorder = RevenueAllocationInfo.Document
	|		AND T6020S_BatchKeysInfo.ItemKey = RevenueAllocationInfo.ItemKey
	|		AND T6020S_BatchKeysInfo.Currency = RevenueAllocationInfo.Currency
	|		AND T6020S_BatchKeysInfo.CurrencyMovementType = RevenueAllocationInfo.CurrencyMovementType
	|		AND T6020S_BatchKeysInfo.Direction = VALUE(Enum.BatchDirection.Receipt)
	|GROUP BY
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Recorder,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RevenueAmounts_tmp.Company AS Company,
	|	RevenueAmounts_tmp.Document AS Document,
	|	RevenueAmounts_tmp.Store AS Store,
	|	RevenueAmounts_tmp.ItemKey AS ItemKey,
	|	RevenueAmounts_tmp.Quantity AS Quantity,
	|	RevenueAmounts_tmp.Amount AS Amount,
	|	CASE
	|		WHEN RevenueAmounts_tmp.Quantity = 0
	|			THEN 0
	|		ELSE RevenueAmounts_tmp.Amount / RevenueAmounts_tmp.Quantity
	|	END AS AmountPerOneUnit
	|INTO RevenueAmounts
	|FROM
	|	RevenueAmounts_tmp AS RevenueAmounts_tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6010B_BatchWiseBalance.Period AS Period,
	|	R6010B_BatchWiseBalance.Recorder AS Recorder,
	|	R6010B_BatchWiseBalance.LineNumber AS LineNumber,
	|	R6010B_BatchWiseBalance.Active AS Active,
	|	R6010B_BatchWiseBalance.RecordType AS RecordType,
	|	R6010B_BatchWiseBalance.Batch AS Batch,
	|	R6010B_BatchWiseBalance.BatchKey AS BatchKey,
	|	R6010B_BatchWiseBalance.Quantity AS Quantity1,
	|	R6010B_BatchWiseBalance.Amount AS Amount1,
	|	R6010B_BatchWiseBalance.AmountCost AS AmountCost1,
	|	R6010B_BatchWiseBalance.Document AS Document,
	|	0 AS Quantity,
	|	0 AS Amount,
	|	-(RevenueAmounts.AmountPerOneUnit * R6010B_BatchWiseBalance.Quantity) AS AmountCost
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance AS R6010B_BatchWiseBalance
	|		INNER JOIN RevenueAmounts AS RevenueAmounts
	|		ON R6010B_BatchWiseBalance.Batch.Document = RevenueAmounts.Document
	|		AND R6010B_BatchWiseBalance.Batch.Company = RevenueAmounts.Company
	|		AND R6010B_BatchWiseBalance.BatchKey.ItemKey = RevenueAmounts.ItemKey
	|WHERE
	|	RevenueAmounts.AmountPerOneUnit * R6010B_BatchWiseBalance.Quantity <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6050T_SalesBatches.Period AS Period,
	|	R6050T_SalesBatches.Recorder AS Recorder,
	|	R6050T_SalesBatches.LineNumber AS LineNumber,
	|	R6050T_SalesBatches.Active AS Active,
	|	R6050T_SalesBatches.Batch AS Batch,
	|	R6050T_SalesBatches.BatchKey AS BatchKey,
	|	R6050T_SalesBatches.SalesInvoice AS SalesInvoice,
	|	R6050T_SalesBatches.Quantity AS Quantity1,
	|	R6050T_SalesBatches.Amount AS Amount1,
	|	R6050T_SalesBatches.AmountCost AS AmountCost1,
	|	0 AS Quantity,
	|	0 AS Amount,
	|	-(RevenueAmounts.AmountPerOneUnit * R6050T_SalesBatches.Quantity) AS AmountCost
	|FROM
	|	AccumulationRegister.R6050T_SalesBatches AS R6050T_SalesBatches
	|		INNER JOIN RevenueAmounts AS RevenueAmounts
	|		ON R6050T_SalesBatches.Batch.Document = RevenueAmounts.Document
	|		AND R6050T_SalesBatches.Batch.Company = RevenueAmounts.Company
	|		AND R6050T_SalesBatches.BatchKey.ItemKey = RevenueAmounts.ItemKey
	|WHERE
	|	RevenueAmounts.AmountPerOneUnit * R6050T_SalesBatches.Quantity <> 0";

	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BeginPeriod);
	Query.SetParameter("EndPeriod", EndPeriod);
	QueryResults = Query.ExecuteBatch();

	RecordSet = AccumulationRegisters.R6010B_BatchWiseBalance.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	//Batch wise balance
	For Each Row In QueryResults[3].Unload() Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	RecordSet.Write();
	
	//Sales batches
	RecordSet = AccumulationRegisters.R6050T_SalesBatches.CreateRecordSet();
	RecordSet.Filter.Recorder.Set(CalculationMovementCostRef);

	For Each Row In QueryResults[4].Unload() Do
		NewRecord = RecordSet.Add();
		FillPropertyValues(NewRecord, Row);
		NewRecord.Recorder = CalculationMovementCostRef;
	EndDo;
	RecordSet.Write();
	
	//Batch balance
	AccumulationRegisters.R6020B_BatchBalance.BatchBalance_LoadRecords(CalculationMovementCostRef);
	
	//Cost of goods sold
	AccumulationRegisters.R6060T_CostOfGoodsSold.CostOfGoodsSold_LoadRecords(CalculationMovementCostRef);
EndProcedure

Function GetBatchWiseBalance(CalculateMovementCostsRef, Company, BeginPeriod, EndPeriod)
	tmp_manager = New TempTablesManager();
	Tree = GetBatchTree(tmp_manager, CalculateMovementCostsRef, Company, BeginPeriod, EndPeriod);

	EmptyTable_BatchWiseBalance = CreateTable_BatchWiseBalance();
	Tables = New Structure();
	Tables.Insert("DataForExpense"               , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForReceipt"               , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForBatchShortageOutgoing" , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForBatchShortageIncoming" , EmptyTable_BatchWiseBalance.CopyColumns());
	Tables.Insert("DataForSalesBatches"          , EmptyTable_BatchWiseBalance.CopyColumns());

	ArrayOfTypes_SalesInvoice = New Array();
	ArrayOfTypes_SalesInvoice.Add(Type("DocumentRef.SalesInvoice"));
	ArrayOfTypes_SalesInvoice.Add(Type("DocumentRef.RetailSalesReceipt"));
	Tables.DataForSalesBatches.Columns.Add("SalesInvoice", New TypeDescription(ArrayOfTypes_SalesInvoice));

	Tables.Insert("DataForBundleAmountValues", New ValueTable());
	RegMetadata = Metadata.InformationRegisters.T6040S_BundleAmountValues;
	Tables.DataForBundleAmountValues.Columns.Add("Period"         , RegMetadata.StandardAttributes.Period.Type);
	Tables.DataForBundleAmountValues.Columns.Add("Company"        , RegMetadata.Dimensions.Company.Type);
	Tables.DataForBundleAmountValues.Columns.Add("Batch"          , RegMetadata.Dimensions.Batch.Type);
	Tables.DataForBundleAmountValues.Columns.Add("BatchKey"       , RegMetadata.Dimensions.BatchKey.Type);
	Tables.DataForBundleAmountValues.Columns.Add("AmountValue"    , RegMetadata.Resources.AmountValue.Type);
	Tables.DataForBundleAmountValues.Columns.Add("AmountTaxValue" , RegMetadata.Resources.AmountTaxValue.Type);
	Tables.DataForBundleAmountValues.Columns.Add("BatchKeyBundle" , RegMetadata.Dimensions.BatchKeyBundle.Type);

	Tables.Insert("DataForCompositeBatchesAmountValues", New ValueTable());
	RegMetadata = Metadata.InformationRegisters.T6090S_CompositeBatchesAmountValues;
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("Period"            , RegMetadata.StandardAttributes.Period.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("Company"           , RegMetadata.Dimensions.Company.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("Batch"             , RegMetadata.Dimensions.Batch.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("BatchKey"          , RegMetadata.Dimensions.BatchKey.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("BatchComposite"    , RegMetadata.Dimensions.BatchComposite.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("BatchKeyComposite" , RegMetadata.Dimensions.BatchKeyComposite.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("Quantity"          , RegMetadata.Resources.Quantity.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("Amount"            , RegMetadata.Resources.Amount.Type);
	Tables.DataForCompositeBatchesAmountValues.Columns.Add("AmountTax"         , RegMetadata.Resources.AmountTax.Type);
	
	Tables.Insert("DataForReallocatedBatchesAmountValues", New ValueTable());
	RegMetadata = Metadata.InformationRegisters.T6080S_ReallocatedBatchesAmountValues;
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("OutgoingDocument" , RegMetadata.Dimensions.OutgoingDocument.Type);
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("IncomingDocument" , RegMetadata.Dimensions.IncomingDocument.Type);
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("BatchKey"         , RegMetadata.Dimensions.BatchKey.Type);
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	Tables.DataForReallocatedBatchesAmountValues.Columns.Add("AmountTax"        , RegMetadata.Resources.AmountTax.Type);
	
	Tables.Insert("DataForWriteOffBatches", New ValueTable());
	RegMetadata = Metadata.InformationRegisters.T6095S_WriteOffBatchesInfo;
	Tables.DataForWriteOffBatches.Columns.Add("Period"           , RegMetadata.StandardAttributes.Period.Type);
	Tables.DataForWriteOffBatches.Columns.Add("Document"         , RegMetadata.Dimensions.Document.Type);
	Tables.DataForWriteOffBatches.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	Tables.DataForWriteOffBatches.Columns.Add("Branch"           , RegMetadata.Dimensions.Branch.Type);
	Tables.DataForWriteOffBatches.Columns.Add("ProfitLossCenter" , RegMetadata.Dimensions.ProfitLossCenter.Type);
	Tables.DataForWriteOffBatches.Columns.Add("ExpenseType"      , RegMetadata.Dimensions.ExpenseType.Type);
	Tables.DataForWriteOffBatches.Columns.Add("ItemKey"          , RegMetadata.Dimensions.ItemKey.Type);
	Tables.DataForWriteOffBatches.Columns.Add("Currency"         , RegMetadata.Dimensions.Currency.Type);
	Tables.DataForWriteOffBatches.Columns.Add("RowID"            , RegMetadata.Dimensions.RowID.Type);
	Tables.DataForWriteOffBatches.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	Tables.DataForWriteOffBatches.Columns.Add("AmountTax"        , RegMetadata.Resources.AmountTax.Type);
	
	RegMetadata = Metadata.InformationRegisters.T6020S_BatchKeysInfo;
	TableOfReturnedBatches = New ValueTable();
	TableOfReturnedBatches.Columns.Add("IsOpeningBalance" , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Skip"             , New TypeDescription("Boolean"));
	TableOfReturnedBatches.Columns.Add("Priority"         , New TypeDescription("Number"));
	TableOfReturnedBatches.Columns.Add("BatchKey"         , New TypeDescription("CatalogRef.BatchKeys"));
	TableOfReturnedBatches.Columns.Add("Quantity"         , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("Amount"           , RegMetadata.Resources.Amount.Type);
	TableOfReturnedBatches.Columns.Add("AmountTax"        , RegMetadata.Resources.AmountTax.Type);
	TableOfReturnedBatches.Columns.Add("Document"         , GetBatchDocumentsTypes());
	TableOfReturnedBatches.Columns.Add("Date"             , RegMetadata.StandardAttributes.Period.Type);
	TableOfReturnedBatches.Columns.Add("Company"          , RegMetadata.Dimensions.Company.Type);
	TableOfReturnedBatches.Columns.Add("Direction"        , RegMetadata.Dimensions.Direction.Type);
	TableOfReturnedBatches.Columns.Add("Batch"            , New TypeDescription("CatalogRef.Batches"));
	TableOfReturnedBatches.Columns.Add("QuantityBalance"  , RegMetadata.Resources.Quantity.Type);
	TableOfReturnedBatches.Columns.Add("AmountBalance"    , RegMetadata.Resources.Amount.Type);
	TableOfReturnedBatches.Columns.Add("AmountTaxBalance" , RegMetadata.Resources.AmountTax.Type);
	TableOfReturnedBatches.Columns.Add("BatchDocument"    , RegMetadata.Dimensions.BatchDocument.Type);
	TableOfReturnedBatches.Columns.Add("SalesInvoice"     , RegMetadata.Dimensions.SalesInvoice.Type);

	For Each Row In Tree.Rows Do
		CalculateBatch(Row.Document, Row.Rows, Tables, Tree, TableOfReturnedBatches, EmptyTable_BatchWiseBalance);
		If TableOfReturnedBatches.Count() Then
			For Each RowReturnedBatches In TableOfReturnedBatches Do
				ArrayOfTreeRows = Tree.Rows.FindRows(New Structure("Document", RowReturnedBatches.Document));
				If Not ArrayOfTreeRows.Count() Then
					Raise "Not found batch for sales return";
				EndIf;
				For Each ItemOfTreeRows In ArrayOfTreeRows Do
					FillPropertyValues(ItemOfTreeRows.Rows.Add(), RowReturnedBatches);
				EndDo;
			EndDo;
			Row.Rows.Sort("Date");
		EndIf;
	EndDo;
	Return Tables;
EndFunction

Function GetBatchTree(TempTablesManager, CalculateMovementCostsRef, Company, BeginPeriod, EndPeriod)
	Query = New Query();
	Query.TempTablesManager = TempTablesManager;
	Query.Text =
	"SELECT
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(T6020S_BatchKeysInfo.Amount) AS Amount,
	|	SUM(T6020S_BatchKeysInfo.AmountTax) AS AmountTax,
	|	T6020S_BatchKeysInfo.Recorder AS Document,
	|	T6020S_BatchKeysInfo.Recorder.PointInTime AS PointInTime,
	|	T6020S_BatchKeysInfo.Period AS Date,
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Direction AS Direction,
	|	T6020S_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end AS ProfitLossCenter,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ExpenseType else undefined end AS ExpenseType,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.RowID else undefined end AS RowID,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Branch else undefined end AS Branch,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Currency else undefined end AS Currency,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey
	|INTO BatchKeysRegister
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|WHERE
	|	T6020S_BatchKeysInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|	AND CASE
	|		WHEN &FilterByCompany
	|			THEN T6020S_BatchKeysInfo.Company = &Company
	|		ELSE TRUE
	|	END
	|GROUP BY
	|	T6020S_BatchKeysInfo.Recorder,
	|	T6020S_BatchKeysInfo.Period,
	|	T6020S_BatchKeysInfo.Recorder.PointInTime,
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Direction,
	|	T6020S_BatchKeysInfo.BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ExpenseType else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.RowID else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Branch else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Currency else undefined end,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ReallocateOutgoing.Ref AS Ref
	|INTO ReallocateDocuments
	|FROM
	|	Document.BatchReallocateOutgoing AS ReallocateOutgoing
	|WHERE
	|	ReallocateOutgoing.BatchReallocate = &CalculateMovementCostsRef
	|
	|UNION ALL
	|
	|SELECT
	|	ReallocateIncoming.Ref
	|FROM
	|	Document.BatchReallocateIncoming AS ReallocateIncoming
	|WHERE
	|	ReallocateIncoming.BatchReallocate = &CalculateMovementCostsRef
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ReallocateDocuments.Ref AS Ref
	|INTO ReallocateDocumentOutPeriod
	|FROM
	|	ReallocateDocuments AS ReallocateDocuments
	|		LEFT JOIN BatchKeysRegister AS BatchKeyRegister
	|		ON ReallocateDocuments.Ref = BatchKeyRegister.Document
	|WHERE
	|	BatchKeyRegister.Document IS NULL
	|GROUP BY
	|	ReallocateDocuments.Ref
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(T6020S_BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(T6020S_BatchKeysInfo.Amount) AS Amount,
	|	SUM(T6020S_BatchKeysInfo.AmountTax) AS AmountTax,
	|	T6020S_BatchKeysInfo.Recorder AS Document,
	|	T6020S_BatchKeysInfo.Recorder.PointInTime AS PointInTime,
	|	T6020S_BatchKeysInfo.Period AS Date,
	|	T6020S_BatchKeysInfo.Company AS Company,
	|	T6020S_BatchKeysInfo.Direction AS Direction,
	|	T6020S_BatchKeysInfo.BatchDocument AS BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end AS ProfitLossCenter,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ExpenseType else undefined end AS ExpenseType,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.RowID else undefined end AS RowID,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Branch else undefined end AS Branch,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Currency else undefined end AS Currency,
	|	T6020S_BatchKeysInfo.Store AS Store,
	|	T6020S_BatchKeysInfo.ItemKey AS ItemKey
	|INTO BatchKeysRegisterOutPeriod
	|FROM
	|	ReallocateDocumentOutPeriod AS ReallocateDocumentOutPeriod
	|		INNER JOIN InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|		ON ReallocateDocumentOutPeriod.Ref = T6020S_BatchKeysInfo.Recorder
	|GROUP BY
	|	T6020S_BatchKeysInfo.Recorder,
	|	T6020S_BatchKeysInfo.Period,
	|	T6020S_BatchKeysInfo.Recorder.PointInTime,
	|	T6020S_BatchKeysInfo.Company,
	|	T6020S_BatchKeysInfo.Direction,
	|	T6020S_BatchKeysInfo.BatchDocument,
	|	T6020S_BatchKeysInfo.SalesInvoice,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ProfitLossCenter else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.ExpenseType else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.RowID else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Branch else undefined end,
	|	case when T6020S_BatchKeysInfo.Recorder refs Document.StockAdjustmentAsWriteOff then T6020S_BatchKeysInfo.Currency else undefined end,
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeysRegister.Quantity AS Quantity,
	|	BatchKeysRegister.Amount AS Amount,
	|	BatchKeysRegister.AmountTax AS AmountTax,
	|	BatchKeysRegister.Document AS Document,
	|	BatchKeysRegister.PointInTime AS PointInTime,
	|	BatchKeysRegister.Date AS Date,
	|	BatchKeysRegister.Company AS Company,
	|	BatchKeysRegister.Direction AS Direction,
	|	BatchKeysRegister.BatchDocument AS BatchDocument,
	|	BatchKeysRegister.SalesInvoice AS SalesInvoice,
	|	BatchKeysRegister.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeysRegister.ExpenseType AS ExpenseType,
	|	BatchKeysRegister.RowID AS RowID,
	|	BatchKeysRegister.Branch AS Branch,
	|	BatchKeysRegister.Currency AS Currency,
	|	BatchKeysRegister.Store AS Store,
	|	BatchKeysRegister.ItemKey AS ItemKey
	|INTO BatchKeysInfo
	|FROM
	|	BatchKeysRegister AS BatchKeysRegister
	|
	|UNION ALL
	|
	|SELECT
	|	BatchKeysRegisterOutPeriod.Quantity,
	|	BatchKeysRegisterOutPeriod.Amount,
	|	BatchKeysRegisterOutPeriod.AmountTax,
	|	BatchKeysRegisterOutPeriod.Document,
	|	BatchKeysRegisterOutPeriod.PointInTime,
	|	BatchKeysRegisterOutPeriod.Date,
	|	BatchKeysRegisterOutPeriod.Company,
	|	BatchKeysRegisterOutPeriod.Direction,
	|	BatchKeysRegisterOutPeriod.BatchDocument,
	|	BatchKeysRegisterOutPeriod.SalesInvoice,
	|	BatchKeysRegisterOutPeriod.ProfitLossCenter,
	|	BatchKeysRegisterOutPeriod.ExpenseType,
	|	BatchKeysRegisterOutPeriod.RowID,
	|	BatchKeysRegisterOutPeriod.Branch,
	|	BatchKeysRegisterOutPeriod.Currency,
	|	BatchKeysRegisterOutPeriod.Store,
	|	BatchKeysRegisterOutPeriod.ItemKey
	|FROM
	|	BatchKeysRegisterOutPeriod AS BatchKeysRegisterOutPeriod
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BatchKeys.Ref AS BatchKey,
	|	SUM(BatchKeysInfo.Quantity) AS Quantity,
	|	SUM(BatchKeysInfo.Amount) AS Amount,
	|	SUM(BatchKeysInfo.AmountTax) AS AmountTax,
	|	BatchKeysInfo.Document AS Document,
	|	BatchKeysInfo.PointInTime AS PointInTime,
	|	BatchKeysInfo.Date AS Date,
	|	BatchKeysInfo.Company AS Company,
	|	BatchKeysInfo.Direction AS Direction,
	|	BatchKeysInfo.BatchDocument AS BatchDocument,
	|	BatchKeysInfo.SalesInvoice AS SalesInvoice,
	|	BatchKeysInfo.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeysInfo.ExpenseType AS ExpenseType,
	|	BatchKeysInfo.RowID AS RowID,
	|	BatchKeysInfo.Branch AS Branch,
	|	BatchKeysInfo.Currency AS Currency
	|INTO BatchKeys
	|FROM
	|	BatchKeysInfo AS BatchKeysInfo
	|		INNER JOIN Catalog.BatchKeys AS BatchKeys
	|		ON (BatchKeys.ItemKey = BatchKeysInfo.ItemKey)
	|		AND (BatchKeys.Store = BatchKeysInfo.Store)
	|		AND (NOT BatchKeys.DeletionMark)
	|GROUP BY
	|	BatchKeys.Ref,
	|	BatchKeysInfo.Document,
	|	BatchKeysInfo.Date,
	|	BatchKeysInfo.PointInTime,
	|	BatchKeysInfo.Company,
	|	BatchKeysInfo.Direction,
	|	BatchKeysInfo.BatchDocument,
	|	BatchKeysInfo.SalesInvoice,
	|	BatchKeysInfo.ProfitLossCenter,
	|	BatchKeysInfo.ExpenseType,
	|	BatchKeysInfo.RowID,
	|	BatchKeysInfo.Branch,
	|	BatchKeysInfo.Currency
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	FALSE AS IsOpeningBalance,
	|	BatchKeys.BatchKey AS BatchKey,
	|	BatchKeys.Quantity AS Quantity,
	|	BatchKeys.Amount AS Amount,
	|	BatchKeys.AmountTax AS AmountTax,
	|	BatchKeys.Document AS Document,
	|	BatchKeys.PointInTime AS PointInTime,
	|	BatchKeys.Date AS Date,
	|	BatchKeys.Company AS Company,
	|	BatchKeys.Direction AS Direction,
	|	ISNULL(Batches.Ref, VALUE(Catalog.Batches.EmptyRef)) AS Batch,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.Quantity
	|	END AS QuantityBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.Amount
	|	END AS AmountBalance,
	|	CASE
	|		WHEN Batches.Ref IS NULL
	|		OR NOT BatchKeys.SalesInvoice.Date IS NULL
	|			THEN 0
	|		ELSE BatchKeys.AmountTax
	|	END AS AmountTaxBalance,
	|	BatchKeys.BatchDocument AS BatchDocument,
	|	BatchKeys.SalesInvoice AS SalesInvoice,
	|	BatchKeys.ProfitLossCenter AS ProfitLossCenter,
	|	BatchKeys.ExpenseType AS ExpenseType,
	|	BatchKeys.RowID AS RowID,
	|	BatchKeys.Branch AS Branch,
	|	BatchKeys.Currency AS Currency
	|INTO AllData
	|FROM
	|	BatchKeys AS BatchKeys
	|		LEFT JOIN Catalog.Batches AS Batches
	|		ON (Batches.Document = BatchKeys.Document)
	|		AND (Batches.Company = BatchKeys.Company)
	|		AND (Batches.Date = BatchKeys.Date)
	|		AND (NOT Batches.DeletionMark)
	|
	|UNION ALL
	|
	|SELECT
	|	TRUE,
	|	R6010B_BatchWiseBalance.BatchKey,
	|	0,
	|	0,
	|	0,
	|	R6010B_BatchWiseBalance.Batch.Document,
	|	R6010B_BatchWiseBalance.Batch.Document.PointInTime,
	|	R6010B_BatchWiseBalance.Batch.Date,
	|	R6010B_BatchWiseBalance.Batch.Company,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	R6010B_BatchWiseBalance.Batch,
	|	R6010B_BatchWiseBalance.QuantityBalance,
	|	R6010B_BatchWiseBalance.AmountBalance,
	|	R6010B_BatchWiseBalance.AmountTaxBalance,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED,
	|	UNDEFINED
	|FROM
	|	AccumulationRegister.R6010B_BatchWiseBalance.Balance(ENDOFPERIOD(&EndPeriod, DAY), (BatchKey, Batch.Company) IN
	|		(SELECT
	|			BatchKeys.BatchKey,
	|			BatchKeys.Company
	|		FROM
	|			BatchKeys AS BatchKeys)) AS R6010B_BatchWiseBalance
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllData.IsOpeningBalance AS IsOpeningBalance,
	|	AllData.BatchKey AS BatchKey,
	|	SUM(AllData.Quantity) AS Quantity,
	|	SUM(AllData.Amount) AS Amount,
	|	SUM(AllData.AmountTax) AS AmountTax,
	|	AllData.Document AS Document,
	|	AllData.Document.PointInTime AS PointInTime,
	|	AllData.Date AS Date,
	|	AllData.Company AS Company,
	|	AllData.Direction AS Direction,
	|	AllData.Batch AS Batch,
	|	SUM(AllData.QuantityBalance) AS QuantityBalance,
	|	SUM(AllData.AmountBalance) AS AmountBalance,
	|	SUM(AllData.AmountTaxBalance) AS AmountTaxBalance,
	|	AllData.BatchDocument AS BatchDocument,
	|	AllData.SalesInvoice AS SalesInvoice,
	|	AllData.ProfitLossCenter AS ProfitLossCenter,
	|	AllData.ExpenseType AS ExpenseType,
	|	AllData.RowID AS RowID,
	|	AllData.Branch AS Branch,
	|	AllData.Currency AS Currency
	|INTO AllDataGrouped
	|FROM
	|	AllData AS AllData
	|GROUP BY
	|	AllData.IsOpeningBalance,
	|	AllData.BatchKey,
	|	AllData.Document,
	|	AllData.Document.PointInTime,
	|	AllData.Date,
	|	AllData.Company,
	|	AllData.Direction,
	|	AllData.Batch,
	|	AllData.BatchDocument,
	|	AllData.SalesInvoice,
	|	AllData.ProfitLossCenter,
	|	AllData.ExpenseType,
	|	AllData.RowID,
	|	AllData.Branch,
	|	AllData.Currency
	|;
	|
	////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDataGrouped.IsOpeningBalance AS IsOpeningBalance,
	|	AllDataGrouped.BatchKey AS BatchKey,
	|	AllDataGrouped.Quantity AS Quantity,
	|	AllDataGrouped.Amount AS Amount,
	|	AllDataGrouped.AmountTax AS AmountTax,
	|	AllDataGrouped.Document AS Document,
	|	AllDataGrouped.Date AS Date,
	|	AllDataGrouped.Company AS Company,
	|	AllDataGrouped.Direction AS Direction,
	|	AllDataGrouped.Batch AS Batch,
	|	AllDataGrouped.QuantityBalance AS QuantityBalance,
	|	AllDataGrouped.AmountBalance AS AmountBalance,
	|	AllDataGrouped.AmountTaxBalance AS AmountTaxBalance,
	|	AllDataGrouped.BatchDocument AS BatchDocument,
	|	AllDataGrouped.SalesInvoice AS SalesInvoice,
	|	AllDataGrouped.ProfitLossCenter AS ProfitLossCenter,
	|	AllDataGrouped.ExpenseType AS ExpenseType,
	|	AllDataGrouped.RowID AS RowID,
	|	AllDataGrouped.Branch AS Branch,
	|	AllDataGrouped.Currency AS Currency,
	|	FALSE AS Skip,
	|	0 AS Priority
	|FROM
	|	AllDataGrouped AS AllDataGrouped
	|
	|ORDER BY
	|	AllDataGrouped.PointInTime
	|TOTALS
	|BY
	|	Document";

	Query.SetParameter("FilterByCompany", ValueIsFilled(Company));
	Query.SetParameter("CalculateMovementCostsRef", CalculateMovementCostsRef);
	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BegOfDay(BeginPeriod));
	Query.SetParameter("EndPeriod", EndOfDay(EndPeriod));
	QueryResult = Query.Execute();
	Tree = QueryResult.Unload(QueryResultIteration.ByGroups);

	QueryDrop = New Query();
	QueryDrop.TempTablesManager = TempTablesManager;
	QueryDrop.Text =
	"DROP BatchKeysRegister;
	|DROP ReallocateDocuments;
	|DROP ReallocateDocumentOutPeriod;
	|DROP BatchKeysRegisterOutPeriod;
	|DROP BatchKeysInfo;
	|DROP BatchKeys;
	|DROP AllData;
	|DROP AllDataGrouped";
	QueryDrop.Execute();
	
	ArrayOfReturnedSalesInvoices = New Array();
	For Each Row In Tree.Rows Do // document level
		For Each RowDetails In Row.Rows Do // row level
			If ValueIsFilled(RowDetails.SalesInvoice) Then
				ArrayOfReturnedSalesInvoices.Add(RowDetails.SalesInvoice);
			EndIf;
		EndDo;
	EndDo;
	Query = New Query();
	Query.Text =
	"SELECT
	|	R6050T_SalesBatchesTurnovers.Batch.Document AS BatchDocument
	|FROM
	|	AccumulationRegister.R6050T_SalesBatches.Turnovers(, , , SalesInvoice IN (&ArrayOfReturnedSalesInvoices)) AS
	|		R6050T_SalesBatchesTurnovers
	|GROUP BY
	|	R6050T_SalesBatchesTurnovers.Batch.Document";
	Query.SetParameter("ArrayOfReturnedSalesInvoices", ArrayOfReturnedSalesInvoices);
	TableOfReturnedBatches = Query.Execute().Unload();
	For Each ReturnedBatch In TableOfReturnedBatches Do
		If Not Tree.Rows.FindRows(New Structure("Document", ReturnedBatch.BatchDocument)).Count() Then
			Tree.Rows.Add().Document = ReturnedBatch.BatchDocument;
		EndIf;
	EndDo;

	Return Tree;
EndFunction

Procedure CalculateBatch(Document, Rows, Tables, Tree, TableOfReturnedBatches, EmptyTable_BatchWiseBalance)
	TableOfReturnedBatches.Clear();

	DataForExpense = EmptyTable_BatchWiseBalance.CopyColumns();
	DataForReceipt = EmptyTable_BatchWiseBalance.CopyColumns();

	For Each Row In Rows Do
		If Row.Skip Then
			Continue;
		EndIf;
		If Row.Direction = Enums.BatchDirection.Receipt And Not Row.IsOpeningBalance Then

			NewRow = DataForReceipt.Add();
			NewRow.Batch     = Row.Batch;
			NewRow.BatchKey  = Row.BatchKey;
			NewRow.Document  = Row.Document;
			NewRow.Company   = Row.Company;
			NewRow.Period    = Row.Date;
			NewRow.Quantity  = Row.Quantity;
			NewRow.Amount    = Row.Amount;
			NewRow.AmountTax = Row.AmountTax;
			
			// simple receipt	
			If IsNotMultiDirectionDocument(Document) // is not transfer, produce, bundling or unbundling
				And Not ValueIsFilled(Row.SalesInvoice) // is not return by sales invoice
				And TypeOf(Document) <> Type("DocumentRef.BatchReallocateIncoming") Then // is not receipt by btach reallocation
				
				If Row.Amount = 0 AND Row.Company.LandedCostFillEmptyAmount 
					AND TypeOf(Document) = Type("DocumentRef.StockAdjustmentAsSurplus") Then
						Price = GetPriceForEmptyAmountFromDataForReceipt(Row.BatchKey.ItemKey, Row.Date, Tables.DataForReceipt);
						
						If Price = 0 Then
							Price = GetPriceForEmptyAmountFromBatchBalance(Row.BatchKey.ItemKey, Row.Date);
						EndIf;
						
						If Price = 0 AND Not Row.Company.LandedCostPriceTypeForEmptyAmount.isEmpty() Then
							PriceSettings = New Structure("ItemKey, PriceType, Period, Unit");
							PriceSettings.ItemKey = Row.BatchKey.ItemKey;
							PriceSettings.Period = Row.Date;
							PriceSettings.PriceType = Row.Company.LandedCostPriceTypeForEmptyAmount;
							PriceSettings.Unit = GetItemInfo.GetInfoByItemsKey(Row.BatchKey.ItemKey)[0].Unit;
							Price = GetItemInfo.ItemPriceInfo(PriceSettings).Price;
						EndIf;
						
						Row.Amount = Price * Row.Quantity;
						Row.AmountBalance = Price * Row.Quantity;
						
						NewRow.Amount = Price * Row.Quantity;
				EndIf;
				
				FillPropertyValues(Tables.DataForReceipt.Add(), NewRow);
				
			EndIf;

			If ValueIsFilled(Row.SalesInvoice) Then // return by sales invoice

				TableOfBatchBySales = GetSalesBatches(Row.SalesInvoice, Tables.DataForSalesBatches, Row.BatchKey.ItemKey);

				NeedReceipt = Row.Quantity; // how many returned (quantity)

				For Each BatchBySales In TableOfBatchBySales Do
					If NeedReceipt = 0 Then
						Break;
					EndIf;
					ReceiptQuantity = Min(NeedReceipt, BatchBySales.Quantity); // how many can receipt (quantity)
					// receipt amount
					ReceiptAmount = 0;
					If BatchBySales.Quantity - ReceiptQuantity = 0 Then
						ReceiptAmount = BatchBySales.Amount;
					Else
						If BatchBySales.Quantity <> 0 Then
							ReceiptAmount = (BatchBySales.Amount / BatchBySales.Quantity) * ReceiptQuantity;
						EndIf;
					EndIf;
					
					// receipt amount tax
					ReceiptAmountTax = 0;
					If BatchBySales.Quantity - ReceiptQuantity = 0 Then
						ReceiptAmountTax = BatchBySales.AmountTax;
					Else
						If BatchBySales.Quantity <> 0 Then
							ReceiptAmountTax = (BatchBySales.AmountTax / BatchBySales.Quantity) * ReceiptQuantity;
						EndIf;
					EndIf;
					
					BatchBySales.Quantity  = BatchBySales.Quantity  - ReceiptQuantity;
					BatchBySales.Amount    = BatchBySales.Amount    - ReceiptAmount;
					BatchBySales.AmountTax = BatchBySales.AmountTax - ReceiptAmountTax;
					
					NeedReceipt = NeedReceipt - ReceiptQuantity;
					
					_BatchBySales_Document = BatchBySales.Document;
					_BatchBySales_Company  = BatchBySales.Company;
					_BatchBySales_Batch    = BatchBySales.Batch;
					
					// determine batch when returned by another company
					If ValueIsFilled(Row.Batch) And Row.Company <> _BatchBySales_Company Then
						_BatchBySales_Document = Row.Batch.Document;
						_BatchBySales_Company  = Row.Company;
						_BatchBySales_Batch    = Row.Batch;
					EndIf;
					
					// Table of returned batches
					NewRow_ReturnedBatches = TableOfReturnedBatches.Add();
					NewRow_ReturnedBatches.IsOpeningBalance = False;
					NewRow_ReturnedBatches.Skip             = True;
					NewRow_ReturnedBatches.Priority         = 0;
					NewRow_ReturnedBatches.BatchKey         = Row.BatchKey;
					NewRow_ReturnedBatches.Quantity         = ReceiptQuantity;
					NewRow_ReturnedBatches.Amount           = ReceiptAmount;
					NewRow_ReturnedBatches.AmountTax        = ReceiptAmountTax;
					
					NewRow_ReturnedBatches.Document         = _BatchBySales_Document;
					NewRow_ReturnedBatches.Company          = _BatchBySales_Company;
					NewRow_ReturnedBatches.Batch            = _BatchBySales_Batch;
					
					NewRow_ReturnedBatches.Date             = Row.Date;
					NewRow_ReturnedBatches.Direction        = Enums.BatchDirection.Receipt;
					NewRow_ReturnedBatches.QuantityBalance  = ReceiptQuantity;
					NewRow_ReturnedBatches.AmountBalance    = ReceiptAmount;
					NewRow_ReturnedBatches.AmountTaxBalance = ReceiptAmountTax;
					
					// Data for receipt
					NewRow_DataForReceipt = Tables.DataForReceipt.Add();
					
					NewRow_DataForReceipt.Company   = _BatchBySales_Company;
					NewRow_DataForReceipt.Batch     = _BatchBySales_Batch;
					
					NewRow_DataForReceipt.BatchKey  = Row.BatchKey;
					NewRow_DataForReceipt.Document  = Row.Document;
					NewRow_DataForReceipt.Period    = Row.Date;
					NewRow_DataForReceipt.Quantity  = ReceiptQuantity;
					NewRow_DataForReceipt.Amount    = ReceiptAmount;
					NewRow_DataForReceipt.AmountTax = ReceiptAmountTax;
				EndDo; // return by sales invoice

				If NeedReceipt <> 0 Then
					Message(StrTemplate("Can not receipt Batch key by sales return: %1 , Quantity: %2 , Doc: %3", Row.BatchKey, NeedReceipt, Row.Document));
					NewRow = Tables.DataForBatchShortageIncoming.Add();
					NewRow.BatchKey = Row.BatchKey;
					NewRow.Document = Row.Document;
					NewRow.Company  = Row.Company;
					NewRow.Period   = Row.Date;
					NewRow.Quantity = NeedReceipt;
				EndIf;
			EndIf;
		Else //Expense

			NeedExpense = Row.Quantity;

			RestoreSortByDate = False;
			//purchase return by purchase invoice
			If ValueIsFilled(Row.BatchDocument) Then
				RestoreSortByDate = True;
				For Each Row_Documents In Tree.Rows Do
					For Each Row_Batch In Row_Documents.Rows Do
						If Row.BatchDocument = Row_Batch.Batch.Document Then
							Row_Batch.Priority = -1;
						EndIf;
					EndDo;
					Row_Documents.Rows.Sort("Priority, Date");
				EndDo;
			EndIf;

			Filter = New Structure();
			Filter.Insert("BatchKey", Row.BatchKey);
			FIlter.Insert("Direction", Enums.BatchDirection.Receipt);

			FilteredRows = Tree.Rows.FindRows(Filter, True);

			For Each Row_Batch In FilteredRows Do

				If Row_Batch.Date > Row.Date Then
					Break;
				EndIf;

				If Row_Batch.QuantityBalance = 0 Then
					Continue;
				EndIf;

				If NeedExpense = 0 Then
					Continue;
				EndIf;

				If Row_Batch.Company <> Row.Company Then
					Continue;
				EndIf;

				If Not ValueIsFilled(Row_Batch.Batch) Then
					Continue;
				EndIf;

				ExpenseQuantity = Min(NeedExpense, Row_Batch.QuantityBalance);

				// expense amount 
				ExpenseAmount = 0;
				If Row_Batch.QuantityBalance - ExpenseQuantity = 0 Then
					ExpenseAmount = Row_Batch.AmountBalance;
				Else
					If Row_Batch.QuantityBalance <> 0 Then
						ExpenseAmount = Round((Row_Batch.AmountBalance / Row_Batch.QuantityBalance) * ExpenseQuantity, 2);
					EndIf;
				EndIf;
				
				// expense amount tax
				ExpenseAmountTax = 0;
				If Row_Batch.QuantityBalance - ExpenseQuantity = 0 Then
					ExpenseAmountTax = Row_Batch.AmountTaxBalance;
				Else
					If Row_Batch.QuantityBalance <> 0 Then
						ExpenseAmountTax = Round((Row_Batch.AmountTaxBalance / Row_Batch.QuantityBalance) * ExpenseQuantity, 2);
					EndIf;
				EndIf;
				
				Row_Batch.QuantityBalance  = Row_Batch.QuantityBalance  - ExpenseQuantity;
				Row_Batch.AmountBalance    = Row_Batch.AmountBalance    - ExpenseAmount;
				Row_Batch.AmountTaxBalance = Row_Batch.AmountTaxBalance - ExpenseAmountTax;
				
				NeedExpense = NeedExpense - ExpenseQuantity;

				If ExpenseQuantity <> 0 Or ExpenseAmount <> 0 Then
					NewRow = Tables.DataForExpense.Add();
					NewRow.BatchKey  = Row.BatchKey;
					NewRow.Document  = Row.Document;
					NewRow.Company   = Row.Company;
					NewRow.Period    = Row.Date;
					NewRow.Batch     = Row_Batch.Batch;
					NewRow.Quantity  = ExpenseQuantity;
					NewRow.Amount    = ExpenseAmount;
					NewRow.AmountTax = ExpenseAmountTax;

					FillPropertyValues(DataForExpense.Add(), NewRow);
						
						// sales batches
					If TypeOf(Row.Document) = Type("DocumentRef.SalesInvoice") 
						Or TypeOf(Row.Document) = Type("DocumentRef.RetailSalesReceipt") Then
						NewRow_SalesBatches = Tables.DataForSalesBatches.Add();
						FillPropertyValues(NewRow_SalesBatches, NewRow);
						NewRow_SalesBatches.SalesInvoice = Row.Document;
					EndIf;
						
						// reallocated batches
					If TypeOf(Row.Document) = Type("DocumentRef.BatchReallocateOutgoing") Then
						NewRow_ReallocatedBatches = Tables.DataForReallocatedBatchesAmountValues.Add();
						FillPropertyValues(NewRow_ReallocatedBatches, NewRow);
						NewRow_ReallocatedBatches.OutgoingDocument = Row.Document;
						NewRow_ReallocatedBatches.IncomingDocument = Row.Document.Incoming;
					EndIf;
					
						// write-off batches
					If TypeOf(Row.Document) = Type("DocumentRef.StockAdjustmentAsWriteOff") Then
						NewRow_WriteOffBatches = Tables.DataForWriteOffBatches.Add();
						FillPropertyValues(NewRow_WriteOffBatches, NewRow);
						NewRow_WriteOffBatches.ExpenseType      = Row.ExpenseType;
						NewRow_WriteOffBatches.ProfitLossCenter = Row.ProfitLossCenter;
						NewRow_WriteOffBatches.Branch           = Row.Branch;
						NewRow_WriteOffBatches.Currency         = Row.Currency;
						NewRow_WriteOffBatches.RowID            = Row.RowID;
					EndIf;		
				EndIf;

			EndDo;
			If RestoreSortByDate Then
				For Each Row_Documents In Tree.Rows Do
					Row_Documents.Rows.Sort("Date");
				EndDo;
			EndIf;

			If NeedExpense <> 0 Then
				Message(StrTemplate("Can not expense Batch key: %1 , Quantity: %2 , Doc: %3", Row.BatchKey, NeedExpense, Row.Document));
				NewRow = Tables.DataForBatchShortageOutgoing.Add();
				NewRow.BatchKey = Row.BatchKey;
				NewRow.Document = Row.Document;
				NewRow.Company  = Row.Company;
				NewRow.Period   = Row.Date;
				NewRow.Quantity = NeedExpense;
			EndIf;
		EndIf;
	EndDo;
	
	// Bundling, Unbundling, Transfer, Produce
	TableOfNewReceivedBatches = New ValueTable();
	TableOfNewReceivedBatches.Columns.Add("Batch");
	TableOfNewReceivedBatches.Columns.Add("BatchKey");
	TableOfNewReceivedBatches.Columns.Add("Document");
	TableOfNewReceivedBatches.Columns.Add("Company");
	TableOfNewReceivedBatches.Columns.Add("Date");
	TableOfNewReceivedBatches.Columns.Add("Quantity");
	TableOfNewReceivedBatches.Columns.Add("Amount");
	TableOfNewReceivedBatches.Columns.Add("AmountTax");
	TableOfNewReceivedBatches.Columns.Add("QuantityBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountBalance");
	TableOfNewReceivedBatches.Columns.Add("AmountTaxBalance");
	TableOfNewReceivedBatches.Columns.Add("IsOpeningBalance");
	TableOfNewReceivedBatches.Columns.Add("Direction");

	If IsTransferDocument(Document) Then
		CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches);
	ElsIf IsCompositeDocument(Document) Then
		CalculateCompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches);
	ElsIf IsDecompositeDocument(Document) Then
		CalculateDecompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches);
	ElsIf TypeOf(Document) = Type("DocumentRef.BatchReallocateIncoming") Then

		For Each Row_Receipt In DataForReceipt Do
			NewRow = Tables.DataForReceipt.Add();
			FillPropertyValues(NewRow, Row_Receipt);

			Filter = New Structure();
			Filter.Insert("BatchKey", Row_Receipt.BatchKey);
			Filter.Insert("IncomingDocument", Document);
			Filter.Insert("OutgoingDocument", Document.Outgoing);

			FilteredRows = Tables.DataForReallocatedBatchesAmountValues.FindRows(Filter);
			ReallocatedAmount    = 0;
			ReallocatedAmountTax = 0;
			ReallocatedQuantity  = 0;
			If FilteredRows.Count() Then
				For Each FilteredRow In FilteredRows Do
					ReallocatedAmount    = ReallocatedAmount    + FilteredRow.Amount;
					ReallocatedAmountTax = ReallocatedAmountTax + FilteredRow.AmountTax;
					ReallocatedQuantity  = ReallocatedQuantity + FilteredRow.Quantity;
				EndDo;
			Else
				Query = New Query();
				Query.Text =
				"SELECT
				|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.Amount), 0) AS Amount,
				|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.AmountTax), 0) AS AmountTax,
				|	ISNULL(SUM(T6080S_ReallocatedBatchesAmountValuesSliceLast.Quantity), 0) AS Quantity
				|FROM
				|	InformationRegister.T6080S_ReallocatedBatchesAmountValues.SliceLast(, OutgoingDocument = &OutgoingDocument
				|	AND IncomingDocument = &IncomingDocument
				|	AND BatchKey = &BatchKey) AS T6080S_ReallocatedBatchesAmountValuesSliceLast";
				Query.SetParameter("BatchKey", Filter.BatchKey);
				Query.SetParameter("IncomingDocument", Filter.IncomingDocument);
				Query.SetParameter("OutgoingDocument", Filter.OutgoingDocument);
				QueryResult = Query.Execute();
				QuerySelection = QueryResult.Select();
				If QuerySelection.Next() Then
					ReallocatedAmount    = QuerySelection.Amount;
					ReallocatedAmountTax = QuerySelection.AmountTax;
					ReallocatedQuantity  = QuerySelection.Quantity;
				EndIf;
			EndIf;

			If NewRow.Quantity = ReallocatedQuantity Then
				NewRow.Amount    = ReallocatedAmount;
				NewRow.AmountTax = ReallocatedAmountTax;
			Else
				If ReallocatedQuantity <> 0 Then
					NewRow.Amount = NewRow.Quantity * (ReallocatedAmount / ReallocatedQuantity);
					NewRow.AmountTax = NewRow.Quantity * (ReallocatedAmountTax / ReallocatedQuantity);
				Else
					NewRow.Amount = 0;
					NewRow.AmountTax = 0;
				EndIf;
			EndIf;

			NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
			NewRowReceivedBatch.Batch            = NewRow.Batch;
			NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
			NewRowReceivedBatch.Document         = NewRow.Document;
			NewRowReceivedBatch.Company          = NewRow.Company;
			NewRowReceivedBatch.Date             = NewRow.Period;
			NewRowReceivedBatch.Quantity         = NewRow.Quantity;
			NewRowReceivedBatch.Amount           = NewRow.Amount;
			NewRowReceivedBatch.AmountTax        = NewRow.AmountTax;
			NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
			NewRowReceivedBatch.AmountBalance    = NewRow.Amount;
			NewRowReceivedBatch.AmountTaxBalance = NewRow.AmountTax;
			NewRowReceivedBatch.IsOpeningBalance = False;
			NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
		EndDo;

		For Each Row In TableOfNewReceivedBatches Do
			FillPropertyValues(Rows.Add(), Row);
		EndDo;
		ArrayForDelete = New Array();
		For Each Row In Rows Do
			If Not ValueIsFilled(Row.AmountBalance) Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each Row In ArrayForDelete Do
			Rows.Delete(Row);
		EndDo;
	EndIf;
EndProcedure

Function GetPriceForEmptyAmountFromDataForReceipt(ItemKey, Period, DataForReceipt)
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	TemporaryTable.BatchKey,
		|	TemporaryTable.Period,
		|	TemporaryTable.Amount,
		|	TemporaryTable.Quantity
		|INTO VT
		|FROM
		|	&DataForReceipt AS TemporaryTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT TOP 1
		|	VT.BatchKey,
		|	VT.Period AS Period,
		|	VT.Amount,
		|	VT.Quantity,
		|	CASE
		|		WHEN VT.Quantity = 0
		|			THEN 0
		|		ELSE VT.Amount / VT.Quantity
		|	END AS Price
		|FROM
		|	VT AS VT
		|WHERE
		|	VT.BatchKey.ItemKey = &ItemKey
		|	AND VT.Period <= &Period
		|
		|ORDER BY
		|	Period DESC";
	
	Query.SetParameter("Period", Period);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("DataForReceipt", DataForReceipt);
	Result = Query.Execute().Select();
	
	If Result.Next() Then 
		Return Result.Price;
	Else
		Return 0;
	EndIf;
EndFunction

Function GetPriceForEmptyAmountFromBatchBalance(ItemKey, Period)
	
	Query = New Query;
	Query.Text =
		"SELECT TOP 1
		|	BatchBalance.BatchKey,
		|	BatchBalance.Period AS Period,
		|	BatchBalance.Amount,
		|	BatchBalance.Quantity,
		|	CASE
		|		WHEN BatchBalance.Quantity = 0
		|			THEN 0
		|		ELSE BatchBalance.Amount / BatchBalance.Quantity
		|	END AS Price
		|FROM
		|	AccumulationRegister.R6020B_BatchBalance AS BatchBalance
		|WHERE
		|	BatchBalance.ItemKey = &ItemKey
		|	AND BatchBalance.Period <= &Period
		|	AND BatchBalance.RecordType = VALUE(AccumulationRecordType.Receipt)
		|	AND BatchBalance.Amount > 0
		|
		|ORDER BY
		|	Period DESC";
	
	Query.SetParameter("Period", Period);
	Query.SetParameter("ItemKey", ItemKey);
	Result = Query.Execute().Select();
	
	If Result.Next() Then 
		Return Result.Price;
	Else
		Return 0;
	EndIf;
EndFunction

Function GetArrayOfTransferDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	Return ArrayOfTypes;
EndFunction

Function IsTransferDocument(Document)
	ArrayOfTypes = GetArrayOfTransferDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) <> Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Procedure CalculateTransferDocument(Rows, Tables, DataForExpense, TableOfNewReceivedBatches)
	For Each Row In Rows Do
		If Row.Direction = Enums.BatchDirection.Receipt And Not Row.IsOpeningBalance Then
			NeedReceipt = Row.Quantity;
			For Each Row_Expense In DataForExpense Do
				If Row.BatchKey.ItemKey = Row_Expense.BatchKey.ItemKey Then
					NeedReceipt = NeedReceipt - Row_Expense.Quantity;
					NewRow = Tables.DataForReceipt.Add();
					NewRow.Batch     = Row_Expense.Batch;
					NewRow.BatchKey  = Row.BatchKey;
					NewRow.Document  = Row.Document;
					NewRow.Company   = Row.Company;
					NewRow.Period    = Row.Date;
					NewRow.Quantity  = Row_Expense.Quantity;
					NewRow.Amount    = Row_Expense.Amount;
					NewRow.AmountTax = Row_Expense.AmountTax;

					NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
					NewRowReceivedBatch.Batch            = Row_Expense.Batch;
					NewRowReceivedBatch.BatchKey         = Row.BatchKey;
					NewRowReceivedBatch.Document         = Row.Document;
					NewRowReceivedBatch.Company          = Row.Company;
					NewRowReceivedBatch.Date             = Row.Date;
					NewRowReceivedBatch.Quantity         = Row_Expense.Quantity;
					NewRowReceivedBatch.Amount           = Row_Expense.Amount;
					NewRowReceivedBatch.AmountTax        = Row_Expense.AmountTax;
					NewRowReceivedBatch.QuantityBalance  = Row_Expense.Quantity;
					NewRowReceivedBatch.AmountBalance    = Row_Expense.Amount;
					NewRowReceivedBatch.AmountTaxBalance = Row_Expense.AmountTax;
					NewRowReceivedBatch.IsOpeningBalance = False;
					NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
				EndIf;
			EndDo;
			If NeedReceipt <> 0 Then
				Message(StrTemplate("Can not receipt Batch key: %1 , Quantity: %2 , Doc: %3", Row.BatchKey, NeedReceipt, Row.Document));
				NewRow = Tables.DataForBatchShortageIncoming.Add();
				NewRow.BatchKey = Row.BatchKey;
				NewRow.Document = Row.Document;
				NewRow.Company  = Row.Company;
				NewRow.Period   = Row.Date;
				NewRow.Quantity = NeedReceipt;
			EndIf;
		EndIf;
	EndDo;

	For Each Row In TableOfNewReceivedBatches Do
		FillPropertyValues(Rows.Add(), Row);
	EndDo;
	ArrayForDelete = New Array();
	For Each Row In Rows Do
		If Not ValueIsFilled(Row.AmountBalance) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Row In ArrayForDelete Do
		Rows.Delete(Row);
	EndDo;
EndProcedure

Function GetArrayOfCompositeDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	Return ArrayOfTypes;
EndFunction

Function IsCompositeDocument(Document)
	ArrayOfTypes = GetArrayOfCompositeDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) <> Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Procedure CalculateCompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches)
	For Each Row_Receipt In DataForReceipt Do
		NewRow = Tables.DataForReceipt.Add();
		FillPropertyValues(NewRow, Row_Receipt);
		TotalExpense    = DataForExpense.Total("Amount");
		TotalExpenseTax = DataForExpense.Total("AmountTax");
		For Each Row_Expense In DataForExpense Do
			NewRow.Amount    = NewRow.Amount    + Row_Expense.Amount;
			NewRow.AmountTax = NewRow.AmountTax + Row_Expense.AmountTax;
			If TypeOf(Row_Expense.Document) = Type("DocumentRef.Bundling") Then
				NewRowBundleAmountValues = Tables.DataForBundleAmountValues.Add();
				NewRowBundleAmountValues.Batch          = Row_Expense.Batch;
				NewRowBundleAmountValues.BatchKey       = Row_Expense.BatchKey;
				NewRowBundleAmountValues.Company        = Row_Expense.Company;
				NewRowBundleAmountValues.Period         = Row_Expense.Period;
				NewRowBundleAmountValues.BatchKeyBundle = Row_Receipt.BatchKey;
				If TotalExpense <> 0 And Row_Expense.Amount <> 0 Then
					NewRowBundleAmountValues.AmountValue = Row_Expense.Amount / (TotalExpense / 100);
				EndIf;
				If TotalExpenseTax <> 0 And Row_Expense.AmountTax <> 0 Then
					NewRowBundleAmountValues.AmountTaxValue = Row_Expense.AmountTax / (TotalExpenseTax / 100);
				EndIf;				
			Else
				NewRowCompositeBatchesAmountValues = Tables.DataForCompositeBatchesAmountValues.Add();
				NewRowCompositeBatchesAmountValues.Batch     = Row_Expense.Batch;
				NewRowCompositeBatchesAmountValues.BatchKey  = Row_Expense.BatchKey;
				NewRowCompositeBatchesAmountValues.Company   = Row_Expense.Company;
				NewRowCompositeBatchesAmountValues.Period    = Row_Expense.Period;
				NewRowCompositeBatchesAmountValues.BatchComposite    = Row_Receipt.Batch;
				NewRowCompositeBatchesAmountValues.BatchKeyComposite = Row_Receipt.BatchKey;
				NewRowCompositeBatchesAmountValues.Amount    = Row_Expense.Amount;
				NewRowCompositeBatchesAmountValues.AmountTax = Row_Expense.AmountTax;
				NewRowCompositeBatchesAmountValues.Quantity  = Row_Expense.Quantity;
			EndIf;
		EndDo;

		NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
		NewRowReceivedBatch.Batch            = NewRow.Batch;
		NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
		NewRowReceivedBatch.Document         = NewRow.Document;
		NewRowReceivedBatch.Company          = NewRow.Company;
		NewRowReceivedBatch.Date             = NewRow.Period;
		NewRowReceivedBatch.Quantity         = NewRow.Quantity;
		NewRowReceivedBatch.Amount           = NewRow.Amount;
		NewRowReceivedBatch.AmountTax        = NewRow.AmountTax;
		NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
		NewRowReceivedBatch.AmountBalance    = NewRow.Amount;
		NewRowReceivedBatch.AmountTaxBalance = NewRow.AmountTax;
		NewRowReceivedBatch.IsOpeningBalance = False;
		NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;

	EndDo;

	ArrayForDelete = New Array();
	For Each Row In TableOfNewReceivedBatches Do
		If ValueIsFilled(Row.AmountBalance) Then
			For Each Row2 In Rows Do
				If Row.Batch = Row2.Batch 
					And Row.BatchKey = Row2.BatchKey 
					And Row.Direction = Row2.Direction 
					And Not ValueIsFilled(Row2.AmountBalance) 
					And ArrayForDelete.Find(Row2) = Undefined Then

					ArrayForDelete.Add(Row2);
				EndIf;
			EndDo;
		EndIf;
		FillPropertyValues(Rows.Add(), Row);
	EndDo;

	For Each Row In ArrayForDelete Do
		Rows.Delete(Row);
	EndDo;
EndProcedure

Function GetArrayOfDecompositeDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.Unbundling"));
	Return ArrayOfTypes;
EndFunction

Function IsDecompositeDocument(Document)
	ArrayOfTypes = GetArrayOfDecompositeDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) <> Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Procedure CalculateDecompositeDocument(Rows, Tables, DataForReceipt, DataForExpense, TableOfNewReceivedBatches)
	For Each Row_Receipt In DataForReceipt Do
		NewRow = Tables.DataForReceipt.Add();
		FillPropertyValues(NewRow, Row_Receipt);
		For Each Row_Expense In DataForExpense Do
			If Not ValueIsFilled(Row_Expense.Amount) Then
				Continue;
			EndIf;
			Query = New Query();
			Query.Text =
			"SELECT
			|	DataForBundleAmountValues.BatchKey AS BatchKey,
			|	DataForBundleAmountValues.Company AS Company,
			|	DataForBundleAmountValues.BatchKeyBundle AS BatchKeyBundle,
			|	DataForBundleAmountValues.AmountValue AS AmountValue,
			|	DataForBundleAmountValues.AmountTaxValue AS AmountTaxValue
			|INTO DataForBundleAmountValues
			|FROM
			|	&DataForBundleAmountValues AS DataForBundleAmountValues
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT
			|	DataForBundleAmountValues.BatchKey AS BatchKey,
			|	DataForBundleAmountValues.Company AS Company,
			|	DataForBundleAmountValues.BatchKeyBundle AS BatchKeyBundle,
			|	DataForBundleAmountValues.AmountValue AS AmountValue,
			|	DataForBundleAmountValues.AmountTaxValue AS AmountTaxValue
			|FROM
			|	DataForBundleAmountValues AS DataForBundleAmountValues
			|WHERE
			|	DataForBundleAmountValues.BatchKey = &BatchKey
			|	AND DataForBundleAmountValues.Company = &Company
			|	AND DataForBundleAmountValues.BatchKeyBundle = &BatchKeyBundle
			|
			|UNION
			|
			|SELECT
			|	T6040S_BundleAmountValues.BatchKey,
			|	T6040S_BundleAmountValues.Company,
			|	T6040S_BundleAmountValues.BatchKeyBundle,
			|	T6040S_BundleAmountValues.AmountValue,
			|	T6040S_BundleAmountValues.AmountTaxValue
			|FROM
			|	InformationRegister.T6040S_BundleAmountValues AS T6040S_BundleAmountValues
			|WHERE
			|	T6040S_BundleAmountValues.BatchKey = &BatchKey
			|	AND T6040S_BundleAmountValues.Company = &Company
			|	AND T6040S_BundleAmountValues.BatchKeyBundle = &BatchKeyBundle
			|
			|UNION
			|
			|SELECT
			|	BatchKeys.Ref,
			|	T6050S_ManualBundleAmountValues.Company,
			|	BatchKeys_Bundle.Ref,
			|	T6050S_ManualBundleAmountValues.AmountValue,
			|	T6050S_ManualBundleAmountValues.AmountTaxValue
			|FROM
			|	InformationRegister.T6050S_ManualBundleAmountValues AS T6050S_ManualBundleAmountValues
			|		INNER JOIN Catalog.BatchKeys AS BatchKeys
			|		ON T6050S_ManualBundleAmountValues.ItemKey = BatchKeys.ItemKey
			|		AND T6050S_ManualBundleAmountValues.Store = BatchKeys.Store
			|		INNER JOIN Catalog.BatchKeys AS BatchKeys_Bundle
			|		ON T6050S_ManualBundleAmountValues.Bundle = BatchKeys_Bundle.ItemKey
			|		AND T6050S_ManualBundleAmountValues.Store = BatchKeys_Bundle.Store
			|WHERE
			|	T6050S_ManualBundleAmountValues.Company = &Company
			|	AND T6050S_ManualBundleAmountValues.ItemKey = &ItemKey
			|	AND T6050S_ManualBundleAmountValues.Bundle = &Bundle
			|	AND T6050S_ManualBundleAmountValues.Store = &Store";

			Query.SetParameter("DataForBundleAmountValues", Tables.DataForBundleAmountValues);
			Query.SetParameter("BatchKeyBundle", Row_Expense.BatchKey);
			Query.SetParameter("BatchKey" , Row_Receipt.BatchKey);
			Query.SetParameter("Company"  , Row_Expense.Company);
			Query.SetParameter("ItemKey"  , Row_Receipt.BatchKey.ItemKey);
			Query.SetParameter("Bundle"   , Row_Expense.BatchKey.ItemKey);
			Query.SetParameter("Store"    , Row_Receipt.BatchKey.Store);

			QuerySelection = Query.Execute().Select();
			While QuerySelection.Next() Do
				NewRow.Amount = NewRow.Amount + (Row_Expense.Amount / 100 * QuerySelection.AmountValue);
				NewRow.AmountTax = NewRow.AmountTax + (Row_Expense.AmountTax / 100 * QuerySelection.AmountTaxValue);
			EndDo;
		EndDo;

		NewRowReceivedBatch = TableOfNewReceivedBatches.Add();
		NewRowReceivedBatch.Batch            = NewRow.Batch;
		NewRowReceivedBatch.BatchKey         = NewRow.BatchKey;
		NewRowReceivedBatch.Document         = NewRow.Document;
		NewRowReceivedBatch.Company          = NewRow.Company;
		NewRowReceivedBatch.Date             = NewRow.Period;
		NewRowReceivedBatch.Quantity         = NewRow.Quantity;
		NewRowReceivedBatch.Amount           = NewRow.Amount;
		NewRowReceivedBatch.AmountTax        = NewRow.AmountTax;
		NewRowReceivedBatch.QuantityBalance  = NewRow.Quantity;
		NewRowReceivedBatch.AmountBalance    = NewRow.Amount;
		NewRowReceivedBatch.AmountTaxBalance = NewRow.AmountTax;
		NewRowReceivedBatch.IsOpeningBalance = False;
		NewRowReceivedBatch.Direction        = Enums.BatchDirection.Receipt;
	EndDo;

	For Each Row In TableOfNewReceivedBatches Do
		FillPropertyValues(Rows.Add(), Row);
	EndDo;
	ArrayForDelete = New Array();
	For Each Row In Rows Do
		If Not ValueIsFilled(Row.AmountBalance) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each Row In ArrayForDelete Do
		Rows.Delete(Row);
	EndDo;
EndProcedure

Function GetSalesBatches(SalesInvoice, DataForSalesBatches, ItemKey)
	Query = New Query();
	Query.Text =
	"SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.Period AS Date,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.Amount AS Amount,
	|	DataForSalesBatches.AmountTax AS AmountTax
	|INTO DataForSalesBatches
	|FROM
	|	&DataForSalesBatches AS DataForSalesBatches
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	R6050T_SalesBatchesTurnovers.Batch AS Batch,
	|	R6050T_SalesBatchesTurnovers.Period AS Date,
	|	R6050T_SalesBatchesTurnovers.BatchKey AS BatchKey,
	|	R6050T_SalesBatchesTurnovers.SalesInvoice AS SalesInvoice,
	|	R6050T_SalesBatchesTurnovers.QuantityTurnover AS Quantity,
	|	R6050T_SalesBatchesTurnovers.AmountTurnover AS Amount,
	|	R6050T_SalesBatchesTurnovers.AmountTaxTurnover AS AmountTax
	|INTO SalesBatches
	|FROM
	|	AccumulationRegister.R6050T_SalesBatches.Turnovers(, , Record, SalesInvoice = &SalesInvoice
	|	AND BatchKey.ItemKey = &BatchKey_ItemKey) AS R6050T_SalesBatchesTurnovers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DataForSalesBatches.Batch AS Batch,
	|	DataForSalesBatches.BatchKey AS BatchKey,
	|	DataForSalesBatches.SalesInvoice AS SalesInvoice,
	|	DataForSalesBatches.Quantity AS Quantity,
	|	DataForSalesBatches.Amount AS Amount,
	|	DataForSalesBatches.AmountTax AS AmountTax,
	|	DataForSalesBatches.Date AS Date
	|INTO AllData
	|FROM
	|	DataForSalesBatches AS DataForSalesBatches
	|WHERE
	|	DataForSalesBatches.SalesInvoice = &SalesInvoice
	|	AND DataForSalesBatches.BatchKey.ItemKey = &BatchKey_ItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	SalesBatches.Batch,
	|	SalesBatches.BatchKey,
	|	SalesBatches.SalesInvoice,
	|	SalesBatches.Quantity,
	|	SalesBatches.Amount,
	|	SalesBatches.AmountTax,
	|	SalesBatches.Date
	|FROM
	|	SalesBatches AS SalesBatches
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllData.Batch AS Batch,
	|	AllData.BatchKey AS BatchKey,
	|	AllData.SalesInvoice AS SalesInvoice,
	|	SUM(AllData.Quantity) AS Quantity,
	|	SUM(AllData.Amount) AS Amount,
	|	SUM(AllData.AmountTax) AS AmountTax,
	|	AllData.Batch.Document AS Document,
	|	AllData.Date AS Date,
	|	AllData.Batch.Company AS Company
	|FROM
	|	AllData AS AllData
	|GROUP BY
	|	AllData.Batch,
	|	AllData.BatchKey,
	|	AllData.SalesInvoice,
	|	AllData.Batch.Document,
	|	AllData.Date,
	|	AllData.Batch.Company
	|ORDER BY
	|	Date";
	Query.SetParameter("SalesInvoice", SalesInvoice);
	Query.SetParameter("DataForSalesBatches", DataForSalesBatches);
	Query.SetParameter("BatchKey_ItemKey", ItemKey);
	Table_SalesBatches = Query.Execute().Unload();
	Return Table_SalesBatches;
EndFunction

Function IsNotMultiDirectionDocument(Document)
	ArrayOfTypes = GetArrayOfMultiDirectionDocument();
	If ArrayOfTypes.Find(TypeOf(Document)) = Undefined Then
		Return True;
	EndIf;
	Return False;
EndFunction

Function GetArrayOfMultiDirectionDocument()
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(Type("DocumentRef.InventoryTransfer"));
	ArrayOfTypes.Add(Type("DocumentRef.Bundling"));
	ArrayOfTypes.Add(Type("DocumentRef.Unbundling"));
	ArrayOfTypes.Add(Type("DocumentRef.ItemStockAdjustment"));
	Return ArrayOfTypes;
EndFunction